//
//  CameraPreviewView.swift
//  Tollix
//
//  Created by Jonathan Tjahjadi on 22/07/25.
//

import SwiftUI
import AVFoundation

struct KameraGandarView: NSViewRepresentable {
    private let coordinator = VideoCaptureCoordinator() // 👈 New coordinator

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor

        // Preview layer from coordinator
        let previewLayer = AVCaptureVideoPreviewLayer(session: coordinator.session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        previewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        view.layer?.addSublayer(previewLayer)

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct KameraLajurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor

        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        let videoDevices = AVCaptureDevice.devices(for: .video)
        let selectedDevice = videoDevices.first(where: { $0.localizedName.contains("C270") }) ??
                             videoDevices.first

        print("Available video devices:")
        videoDevices.forEach {
            print(" - \($0.localizedName), ID: \($0.uniqueID), Model: \($0.modelID)")
        }

        if let device = selectedDevice {
            print("Using camera: \(device.localizedName)")
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = view.bounds
                previewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
                view.layer?.addSublayer(previewLayer)

                session.startRunning()
            } catch {
                print("Error setting up camera: \(error)")
            }
        } else {
            print("⚠️ No video devices found.")
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}




