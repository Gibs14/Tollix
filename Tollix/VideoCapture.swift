//
//  VideoCapture.swift
//  Tollix
//
//  Created by Jonathan Tjahjadi on 22/07/25.
//

import Foundation
import AVFoundation
import Vision
import CoreML

class VideoCaptureCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session = AVCaptureSession()
    
    let classificationModel: VNCoreMLModel
    let detectionModel: VNCoreMLModel
    
    private var lastDetectionTime: Date = .distantPast
    private var detectionCooldown: TimeInterval = 5.0 // seconds
    private var isRunningDetection = false
    
    func runDetection(on pixelBuffer: CVPixelBuffer) {
            let request = VNCoreMLRequest(model: detectionModel) { request, error in
                guard let results = request.results as? [VNRecognizedObjectObservation] else {
                    print("❌ No objects detected")
                    return
                }

                for result in results {
                    let label = result.labels.first?.identifier ?? "Unknown"
                    let confidence = result.labels.first?.confidence ?? 0
                    print("🔎 Detected \(label) (\(Int(confidence * 100))%)")
                }
            }

            request.imageCropAndScaleOption = .scaleFill

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try? handler.perform([request])
        }

    override init() {
        do {
            // Load both models
            let vehicleClassifier = try VehClassNWST(configuration: MLModelConfiguration()).model
            classificationModel = try VNCoreMLModel(for: vehicleClassifier)

            let wheelDetector = try WheelDetect(configuration: MLModelConfiguration()).model
            detectionModel = try VNCoreMLModel(for: wheelDetector)
        } catch {
            fatalError("❌ Failed to load one of the models: \(error)")
        }
        super.init()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.devices(for: .video).first(where: { $0.localizedName.contains("-") }) else {
            print("C270 webcam not found")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:
                                    Int(kCVPixelFormatType_32BGRA)]

            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.startRunning()
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }

    // 🔍 Called for every video frame
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Cooldown check
        let now = Date()
        guard now.timeIntervalSince(lastDetectionTime) > detectionCooldown else { return }

        classify(pixelBuffer: pixelBuffer) // separate method
    }
    
    private func classify(pixelBuffer: CVPixelBuffer) {
        let request = VNCoreMLRequest(model: classificationModel) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }

            let label = topResult.identifier.lowercased()
            let confidence = topResult.confidence

            print("🧠 Vehicle type: \(label), Confidence: \(confidence)")

            // Trigger detection ONLY for trucks
            if label.contains("truck"), !self.isRunningDetection {
                self.isRunningDetection = true
                self.lastDetectionTime = Date()

                self.runDetection(on: pixelBuffer)

                // Reset isRunningDetection after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + self.detectionCooldown) {
                    self.isRunningDetection = false
                }
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }


}

