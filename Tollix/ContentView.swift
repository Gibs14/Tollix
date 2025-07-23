//
//  ContentView.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 17/07/25.
//

import SwiftUI
import Vision
import CoreML
import AppKit
import CoreVideo

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var classificationResult: String = "-"
    @State private var detectedWheels: Int = 0
    @State private var finalCategory: String = "I"
    @State private var confidence: Double = 0.0
    @State private var isTruck: Bool = false
    @State private var isProcessing: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var vehicleCount: [String: Int] = ["I": 0, "II": 0, "III": 0, "IV": 0, "V": 0]
    @State private var currentTime = Date()
    @State private var paymentStatus = "BELUM TERBAYAR"
    @State private var tariff = "Rp9.500"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // HEADER
                headerSection(geometry: geometry)
                
                HStack(spacing: 0) {
                    // KIRI KAMERA
                    cameraSection(geometry: geometry)
                    
                    // KANAN KONTEN
                    contentSection(geometry: geometry)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(hex: "f8f9fa"), Color(hex: "e9ecef")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func headerSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: geometry.size.width * 0.015) {
                    // Logo dengan gradient background
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 70, height: 70)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "4338ca"), Color(hex: "6366f1")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: "car.2.fill")
                                .foregroundColor(.white)
                                .font(.title)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tollix")
                            .bold()
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "1f2937"))
                        Text("Smart Toll Classification System")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "6b7280"))
                    }
                }
                Spacer()
                
                // Time section with enhanced design
                VStack(alignment: .trailing, spacing: 8) {
                    Text(DateFormatter.dayFormatter.string(from: currentTime))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "374151"))
                    Text(DateFormatter.timeFormatter.string(from: currentTime))
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "4338ca"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "4338ca").opacity(0.1))
                        )
                }
                .padding(.trailing, geometry.size.width * 0.03)
            }
            .padding(.horizontal, geometry.size.width * 0.04)
            .padding(.vertical, geometry.size.height * 0.025)
            
            // Enhanced divider
            Rectangle()
                .frame(height: 3)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "4338ca"), Color(hex: "8b5cf6"), Color(hex: "4338ca")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func cameraSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 4) {
            
            Group {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.clear)
                    .frame(height: geometry.size.height * 0.35)
                    .overlay(
                        KameraGandarView()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                VStack {
                                    HStack {
                                        Label("KAMERA GANDAR", systemImage: "camera.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(.black.opacity(0.7))
                                            )
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(12)
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

            }
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.clear)
                .frame(height: geometry.size.height * 0.35)
                .overlay(
                    KameraLajurView()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            VStack {
                                HStack {
                                    Label("KAMERA LAJUR", systemImage: "camera.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.black.opacity(0.7))
                                        )
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(12)
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

        }
        .frame(width: geometry.size.width * 0.42)
        .padding(.leading, geometry.size.width * 0.015)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .padding(.trailing, geometry.size.width * 0.005)
    }
    
    private func contentSection(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            classificationSection(geometry: geometry)
            
            
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.clear, Color(hex: "d1d5db"), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, geometry.size.width * 0.015)
                .padding(.vertical, geometry.size.height * 0.02)
            
            
            bottomSection(geometry: geometry)
            
            Spacer()
        }
        .frame(width: geometry.size.width * 0.56)
        .background(Color.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.top, 16)
        .padding(.trailing, geometry.size.width * 0.015)
        .padding(.bottom, 24)
    }
    
    private func classificationSection(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: geometry.size.height * 0.025) {
            
            HStack(spacing: geometry.size.width * 0.01) {
                ForEach(1...5, id: \.self) { idx in
                    let categoryKey = getRomanNumeral(idx)
                    let isActive = finalCategory == categoryKey
                    let percentage = isActive ? String(format: "%.0f%%", confidence * 100) : "0%"
                    
                    VStack(spacing: 6) {
                        Text("Gol. \(idx)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(isActive ? .white : Color(hex: "6b7280"))
                        Text(percentage)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(isActive ? .white : Color(hex: "374151"))
                            .minimumScaleFactor(0.8)
                    }
                    .frame(width: geometry.size.width * 0.075, height: geometry.size.width * 0.075)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                isActive ?
                                LinearGradient(
                                    colors: [Color(hex: "10b981"), Color(hex: "059669")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color(hex: "f3f4f6"), Color(hex: "e5e7eb")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: isActive ? Color(hex: "10b981").opacity(0.3) : .black.opacity(0.05),
                           radius: isActive ? 6 : 2, x: 0, y: isActive ? 3 : 1)
                    .scaleEffect(isActive ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, geometry.size.width * 0.015)
            
            
            VStack(spacing: 12) {
                DetailCard(title: "Golongan", value: finalCategory, color: Color(hex: "4338ca"))
                DetailCard(title: "Tarif", value: tariff, color: Color(hex: "059669"))
                DetailCard(title: "Status", value: paymentStatus,
                          color: paymentStatus == "BELUM TERBAYAR" ? Color(hex: "dc2626") : Color(hex: "059669"))
                DetailCard(title: "Waktu", value: DateFormatter.timeOnlyFormatter.string(from: currentTime),
                          color: Color(hex: "7c3aed"))
                if isTruck {
                    DetailCard(title: "Jumlah Roda", value: "\(detectedWheels)", color: Color(hex: "ea580c"))
                }
            }
            .padding(.horizontal, geometry.size.width * 0.02)
        }
        .padding(.vertical, geometry.size.height * 0.03)
    }
    
    private func bottomSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.025) {
            
            Text("Tol Pondok Aren 1")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "4338ca"), Color(hex: "7c3aed")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.vertical, geometry.size.height * 0.02)
            
            HStack(alignment: .top, spacing: geometry.size.width * 0.02) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Jumlah Kendaraan")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "374151"))
                        .padding(.bottom, 6)
                    
                    VStack(spacing: 6) {
                        ForEach(["I", "II", "III", "IV", "V"], id: \.self) { g in
                            HStack {
                                Text("Gol. \(g)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "6b7280"))
                                Spacer()
                                Text("\(vehicleCount[g] ?? 0)")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(hex: "374151"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(hex: "f3f4f6"))
                                    )
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
               
                VStack(alignment: .trailing, spacing: 12) {
                   
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color(hex: "7c3aed"))
                        Text("Shift: 1 (06.00-14.00)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "374151"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "7c3aed").opacity(0.1))
                    )
                    
                 
                    HStack(spacing: 12) {
                        StaffCard(name: "Gibran Shevaldo", role: "Operator 1")
                        StaffCard(name: "Jonathan Tjahjadi", role: "Operator 2")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, geometry.size.width * 0.02)
        }
        .padding(.bottom, geometry.size.height * 0.03)
    }
}

// MARK: - Custom Components
struct DetailCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6b7280"))
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 4, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}

struct StaffCard: View {
    let name: String
    let role: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "f3f4f6"), Color(hex: "e5e7eb")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 90, height: 90)
                .overlay(
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 35))
                        .foregroundColor(Color(hex: "9ca3af"))
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            VStack(spacing: 2) {
                Text(name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "374151"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text(role)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(hex: "6b7280"))
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Machine Learning Functions
extension ContentView {
    func selectImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg, .heic]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        panel.begin { response in
            if response == .OK, let url = panel.url, let image = NSImage(contentsOf: url) {
                DispatchQueue.main.async {
                    self.selectedImage = image
                    self.resetResults()
                    self.classifyVehicle(image: image)
                }
            }
        }
    }
    
    private func resetResults() {
        classificationResult = "-"
        detectedWheels = 0
        finalCategory = "I"
        confidence = 0.0
        isTruck = false
        errorMessage = ""
        showError = false
        paymentStatus = "BELUM TERBAYAR"
    }
    
    func classifyVehicle(image: NSImage) {
        isProcessing = true
        
        
        guard let model = try? VNCoreMLModel(for: VehClassNWST().model),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else {
            showErrorMessage("Gagal memuat model klasifikasi atau mengkonversi gambar")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { req, err in
            DispatchQueue.main.async {
                if let error = err {
                    self.showErrorMessage("Error klasifikasi: \(error.localizedDescription)")
                    return
                }
                
                guard let result = req.results?.first as? VNClassificationObservation else {
                    self.showErrorMessage("Tidak dapat mengklasifikasi gambar")
                    return
                }
                
                self.classificationResult = result.identifier
                self.confidence = Double(result.confidence)
                self.isTruck = result.identifier.lowercased().contains("truk") ||
                               result.identifier.lowercased().contains("truck")
                
                if self.isTruck {
                    self.detectWheels(image: image)
                } else {
                    self.finalCategory = "I"
                    self.updateTariff()
                    self.updateVehicleCount()
                    self.paymentStatus = "PROSES"
                    self.isProcessing = false
                }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.showErrorMessage("Error memproses gambar: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func detectWheels(image: NSImage) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let pixelBuffer = cgImage.pixelBuffer(width: 416, height: 416)
        else {
            showErrorMessage("Gagal mengkonversi gambar untuk deteksi roda")
            return
        }
        
        
        guard let model = try? WheelDetect(configuration: MLModelConfiguration()) else {
            showErrorMessage("Gagal memuat model deteksi roda")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let prediction = try model.prediction(
                    imagePath: pixelBuffer,
                    iouThreshold: 0.45,
                    confidenceThreshold: 0.25
                )
                
                let confidenceArray = prediction.confidence
                var wheelCount = 0
                
                for i in 0..<confidenceArray.count {
                    let confidenceValue = confidenceArray[i].doubleValue
                    if confidenceValue >= 0.25 {
                        wheelCount += 1
                    }
                }
                
                DispatchQueue.main.async {
                    self.detectedWheels = wheelCount
                    self.finalCategory = self.determineCategory(wheelCount: wheelCount)
                    self.updateTariff()
                    self.updateVehicleCount()
                    self.paymentStatus = "PROSES"
                    self.isProcessing = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.showErrorMessage("Error deteksi roda: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func determineCategory(wheelCount: Int) -> String {
        switch wheelCount {
        case 2: return "II"
        case 3: return "III"
        case 4: return "IV"
        case 5...: return "V"
        default: return "I"
        }
    }
    
    private func updateTariff() {
        switch finalCategory {
        case "I": tariff = "Rp9.500"
        case "II": tariff = "Rp14.500"
        case "III": tariff = "Rp19.500"
        case "IV": tariff = "Rp24.500"
        case "V": tariff = "Rp29.500"
        default: tariff = "Rp9.500"
        }
    }
    
    private func updateVehicleCount() {
        if let currentCount = vehicleCount[finalCategory] {
            vehicleCount[finalCategory] = currentCount + 1
        }
    }
    
    private func getRomanNumeral(_ number: Int) -> String {
        switch number {
        case 1: return "I"
        case 2: return "II"
        case 3: return "III"
        case 4: return "IV"
        case 5: return "V"
        default: return "I"
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isProcessing = false
    }
}

// MARK: - Custom Styles
struct ModernButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .semibold))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: color.opacity(0.3), radius: configuration.isPressed ? 2 : 5,
                   x: 0, y: configuration.isPressed ? 1 : 3)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Date Formatters
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    static let timeOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

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

// MARK: - Preview
#Preview {
    ContentView()
}
