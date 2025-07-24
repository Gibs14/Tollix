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
import Combine

// MARK: - Detection Result Models
struct VehicleDetection {
    let vehicleType: String
    let confidence: Float
    let wheelCount: Int
    let golongan: Int
    let timestamp: Date
}

class VideoCaptureCoordinator: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var session = AVCaptureSession()
    
    let classificationModel: VNCoreMLModel
    let detectionModel: VNCoreMLModel
    
    private var lastDetectionTime: Date = .distantPast
    private var detectionCooldown: TimeInterval = 5.0 // seconds
    private var isRunningDetection = false
    
    // MARK: - Published Properties untuk UI
    @Published var currentVehicleType: String = ""
    @Published var currentGolongan: Int = 0
    @Published var currentWheelCount: Int = 0
    @Published var currentConfidence: Float = 0.0
    @Published var detectionStatus: String = "Menunggu kendaraan..."
    @Published var shouldActivateGolongan: Bool = false
    
    // MARK: - Vehicle Classification Logic
    private func determineGolongan(vehicleType: String, wheelCount: Int) -> Int {
        let type = vehicleType.lowercased()
        
        switch type {
        case let t where t.contains("motorcycle") || t.contains("motor"):
            return 1
        case let t where t.contains("car") || t.contains("sedan") || t.contains("suv"):
            return 1
        case let t where t.contains("truck") || t.contains("lorry"):
            // Berdasarkan jumlah ban untuk truck
            if wheelCount == 2 {
                return 2
            } else if wheelCount == 3 {
                return 3
            } else if wheelCount == 4 {
                return 4
            } else if wheelCount == 5 {
                return 5
            } else {
                return 1
            }
            
        case let t where t.contains("bus"):
            return 1
        default:
            // Fallback berdasarkan jumlah ban saja
            if wheelCount <= 2 {
                return 1
            } else if wheelCount <= 4 {
                return 2
            } else if wheelCount <= 6 {
                return 3
            } else {
                return 4
            }
        }
    }
    
    func runDetection(on pixelBuffer: CVPixelBuffer) {
        let request = VNCoreMLRequest(model: detectionModel) { [weak self] request, error in
            guard let self = self else { return }
            
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("❌ No objects detected")
                DispatchQueue.main.async {
                    self.detectionStatus = "Tidak ada objek terdeteksi"
                }
                return
            }

            var wheelCount = 0
            for result in results {
                let label = result.labels.first?.identifier ?? "Unknown"
                let confidence = result.labels.first?.confidence ?? 0
                
                if label.lowercased().contains("wheel") || label.lowercased().contains("tire") {
                    wheelCount += 1
                }
                
                print("🔎 Detected \(label) (\(Int(confidence * 100))%)")
            }
            
            // Update UI di main thread
            DispatchQueue.main.async {
                self.currentWheelCount = wheelCount
                let golongan = self.determineGolongan(vehicleType: self.currentVehicleType, wheelCount: wheelCount)
                self.currentGolongan = golongan
                self.shouldActivateGolongan = true
                self.detectionStatus = "Terdeteksi: \(self.currentVehicleType) - \(wheelCount) ban - Gol.\(golongan)"
                
                print("🎯 FINAL RESULT: Vehicle: \(self.currentVehicleType), Wheels: \(wheelCount), Golongan: \(golongan)")
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
        setupCamera()
    }
    
    private func setupCamera() {
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.devices(for: .video).first(where: { $0.localizedName.contains("iPhone") }) else {
            print("iPhone camera not found")
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

        classify(pixelBuffer: pixelBuffer)
    }
    
    private func classify(pixelBuffer: CVPixelBuffer) {
        let request = VNCoreMLRequest(model: classificationModel) { [weak self] request, error in
            guard let self = self else { return }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }

            let label = topResult.identifier.lowercased()
            let confidence = topResult.confidence

            print("🧠 Vehicle type: \(label), Confidence: \(confidence)")

            // Update UI di main thread
            DispatchQueue.main.async {
                self.currentVehicleType = label
                self.currentConfidence = confidence
                self.detectionStatus = "Mengklasifikasi: \(label)"
            }

            // Trigger detection untuk semua kendaraan (tidak hanya truck)
            if confidence > 0.5 && !self.isRunningDetection {
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
    
    // MARK: - Public Methods untuk UI
    func resetDetection() {
        DispatchQueue.main.async {
            self.currentVehicleType = ""
            self.currentGolongan = 0
            self.currentWheelCount = 0
            self.currentConfidence = 0.0
            self.shouldActivateGolongan = false
            self.detectionStatus = "Menunggu kendaraan..."
        }
    }
    
    func confirmVehicle() -> VehicleDetection {
        return VehicleDetection(
            vehicleType: currentVehicleType,
            confidence: currentConfidence,
            wheelCount: currentWheelCount,
            golongan: currentGolongan,
            timestamp: Date()
        )
    }
}
