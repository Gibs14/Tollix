//
//  CGImage.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 23/07/25.
//

import SwiftUI
import CoreVideo
import CoreImage


// MARK: - CGImage to PixelBuffer Helper
extension CGImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ] as CFDictionary
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        
        if let context = context {
            context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        return buffer
    }
}


extension CVPixelBuffer {
    func resize(to size: CGSize) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: self)
        let context = CIContext()

        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: size.width / CGFloat(CVPixelBufferGetWidth(self)),
                                                               y: size.height / CGFloat(CVPixelBufferGetHeight(self))))

        var outputBuffer: CVPixelBuffer?
        let options: [CFString: Any] = [kCVPixelBufferCGImageCompatibilityKey: true,
                                        kCVPixelBufferCGBitmapContextCompatibilityKey: true]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32BGRA,
                                         options as CFDictionary,
                                         &outputBuffer)

        guard status == kCVReturnSuccess, let dstBuffer = outputBuffer else { return nil }

        context.render(scaled, to: dstBuffer)
        return dstBuffer
    }
}
