//
//  CameraModel.swift
//  Tollix
//
//  Created by Jonathan Tjahjadi on 22/07/25.
//

import AVFoundation

struct CameraDevice: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let device: AVCaptureDevice
}


