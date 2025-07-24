////
////  ContentView.swift
////  Tollix
////
////  Created by Muhammad Ardiansyah Asrifah on 17/07/25.
//
//
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var videoCaptureCoordinator = VideoCaptureCoordinator()
//    @State private var selectedGolongan: Int = 0
//    @State private var tarif: String = "Rp9.500"
//    @State private var vehicleCount: [String: Int] = ["I": 0, "II": 0, "III": 0, "IV": 0, "V": 0]
//    @State private var currentTime = Date()
//    @State private var paymentStatus = "BELUM TERBAYAR"
//    @State private var isAwaitingConfirmation: Bool = false
//    @State private var pendingGolongan: Int?
//    @State private var showConfirmationAlert = false
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    
//    private let tarifGolongan = [
//        0: "Rp0",
//        1: "Rp9.500",
//        2: "Rp12.000",
//        3: "Rp15.500",
//        4: "Rp18.000",
//        5: "Rp22.000"
//    ]
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//                // HEADER
//                headerSection(geometry: geometry)
//                
//                HStack(spacing: 0) {
//                    // KIRI KAMERA
//                    cameraSection(geometry: geometry)
//                    
//                    // KANAN KONTEN
//                    contentSection(geometry: geometry)
//                }
//            }
//            .background(
//                LinearGradient(
//                    colors: [Color(hex: "f8f9fa"), Color(hex: "e9ecef")],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//        }
//        .onReceive(timer) { _ in
//            currentTime = Date()
//        }
//        .onChange(of: videoCaptureCoordinator.currentGolongan) { newGolongan in
//            if videoCaptureCoordinator.shouldActivateGolongan && newGolongan > 0 {
//                selectedGolongan = newGolongan
//                pendingGolongan = newGolongan
//                isAwaitingConfirmation = true
//                paymentStatus = "KONFIRMASI DENGAN TOMBOL 1–5"
//            }
//        }
//        .overlay(
//            KeyPressView { key in
//                confirmGolongan(with: key)
//            }
//        )
//        .alert("Konfirmasi Berhasil", isPresented: $showConfirmationAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text("Golongan telah dikonfirmasi dan data kendaraan telah diperbarui.")
//        }
//    }
//    
//    
//    
//    func headerSection(geometry: GeometryProxy) -> some View {
//        VStack(spacing: 0) {
//            HStack {
//                HStack(spacing: geometry.size.width * 0.015) {
//                    // Logo dengan gradient background
//                    RoundedRectangle(cornerRadius: 12)
//                        .frame(width: 70, height: 70)
//                        .foregroundStyle(
//                            LinearGradient(
//                                colors: [Color(hex: "4338ca"), Color(hex: "6366f1")],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .overlay(
//                            Image(systemName: "car.2.fill")
//                                .foregroundColor(.white)
//                                .font(.title)
//                        )
//                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Tollix")
//                            .bold()
//                            .font(.system(size: 32, weight: .bold, design: .rounded))
//                            .foregroundColor(Color(hex: "1f2937"))
//                        Text("Smart Toll Classification System")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(Color(hex: "6b7280"))
//                    }
//                }
//                Spacer()
//                
//                
//                VStack(alignment: .trailing, spacing: 8) {
//                    Text(DateFormatter.dayFormatter.string(from: currentTime))
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(Color(hex: "374151"))
//                    Text(DateFormatter.timeFormatter.string(from: currentTime))
//                        .font(.system(size: 24, weight: .bold, design: .monospaced))
//                        .foregroundColor(Color(hex: "4338ca"))
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color(hex: "4338ca").opacity(0.1))
//                        )
//                }
//                .padding(.trailing, geometry.size.width * 0.03)
//            }
//            .padding(.horizontal, geometry.size.width * 0.04)
//            .padding(.vertical, geometry.size.height * 0.025)
//            
//            
//            Rectangle()
//                .frame(height: 3)
//                .foregroundStyle(
//                    LinearGradient(
//                        colors: [Color(hex: "4338ca"), Color(hex: "8b5cf6"), Color(hex: "4338ca")],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//        }
//        .background(Color.white)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//    
//    func cameraSection(geometry: GeometryProxy) -> some View {
//        VStack(spacing: 4) {
//            
//            Group {
//                KameraGandarView()
//                    .foregroundColor(.clear)
//                    .frame(height: geometry.size.height * 0.35)
//                    .overlay(
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.2))
//
//
//                            .clipShape(RoundedRectangle(cornerRadius: 16))
//                            .overlay(
//                                VStack {
//                                    HStack {
//                                        Label("KAMERA GANDAR", systemImage: "camera.fill")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 14, weight: .semibold))
//                                            .padding(.horizontal, 12)
//                                            .padding(.vertical, 6)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 20)
//                                                    .fill(.black.opacity(0.7))
//                                            )
//                                        Spacer()
//                                    }
//                                    Spacer()
//                                }
//                                .padding(12)
//                            )
//                    )
//                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//
//            }
//            
//            KameraLajurView()
//                .foregroundColor(.clear)
//                .frame(height: geometry.size.height * 0.35)
//                .overlay(
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
//                        .overlay(
//                            VStack {
//                                HStack {
//                                    Label("KAMERA LAJUR", systemImage: "camera.fill")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 14, weight: .semibold))
//                                        .padding(.horizontal, 12)
//                                        .padding(.vertical, 6)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 20)
//                                                .fill(.black.opacity(0.7))
//                                        )
//                                    Spacer()
//                                }
//                                Spacer()
//                            }
//                            .padding(12)
//                        )
//                )
//                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//
//        }
//        .frame(width: geometry.size.width * 0.42)
//        .padding(.leading, geometry.size.width * 0.015)
//        .padding(.top, 16)
//        .padding(.bottom, 24)
//        .padding(.trailing, geometry.size.width * 0.005)
//    }
//    
//    func contentSection(geometry: GeometryProxy) -> some View {
//        VStack(alignment: .leading, spacing: 0) {
//            
//            classificationSection(geometry: geometry)
//            
//            
//            Rectangle()
//                .frame(height: 2)
//                .foregroundStyle(
//                    LinearGradient(
//                        colors: [Color.clear, Color(hex: "d1d5db"), Color.clear],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//                .padding(.horizontal, geometry.size.width * 0.015)
//                .padding(.vertical, geometry.size.height * 0.02)
//            
//            
//            bottomSection(geometry: geometry)
//            
//            Spacer()
//        }
//        .frame(width: geometry.size.width * 0.56)
//        .background(Color.white.opacity(0.7))
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
//        .padding(.top, 16)
//        .padding(.trailing, geometry.size.width * 0.015)
//        .padding(.bottom, 24)
//    }
//    
//    func classificationSection(geometry: GeometryProxy) -> some View {
//        VStack(alignment: .leading, spacing: geometry.size.height * 0.025) {
//            
//            HStack(spacing: geometry.size.width * 0.01) {
//                ForEach(1...5, id: \.self) { idx in
//                    let categoryKey = getRomanNumeral(idx)
//                    let isActive = videoCaptureCoordinator.currentGolongan == idx && videoCaptureCoordinator.shouldActivateGolongan
//                    let percentage = isActive ? String(format: "%.0f%%", videoCaptureCoordinator.currentConfidence * 100) : "0%"
//                    
//                    VStack(spacing: 6) {
//                        Text("Gol. \(idx)")
//                            .font(.system(size: 11, weight: .medium))
//                            .foregroundColor(isActive ? .white : Color(hex: "6b7280"))
//                        Text(percentage)
//                            .font(.system(size: 16, weight: .bold, design: .monospaced))
//                            .foregroundColor(isActive ? .white : Color(hex: "374151"))
//                            .minimumScaleFactor(0.8)
//                    }
//                    .frame(width: geometry.size.width * 0.075, height: geometry.size.width * 0.075)
//                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .fill(
//                                isActive ?
//                                LinearGradient(
//                                    colors: [Color(hex: "10b981"), Color(hex: "059669")],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                ) :
//                                LinearGradient(
//                                    colors: [Color(hex: "f3f4f6"), Color(hex: "e5e7eb")],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                )
//                            )
//                    )
//                    .shadow(color: isActive ? Color(hex: "10b981").opacity(0.3) : .black.opacity(0.05),
//                           radius: isActive ? 6 : 2, x: 0, y: isActive ? 3 : 1)
//                    .scaleEffect(isActive ? 1.05 : 1.0)
//                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
//                    .onTapGesture {
//                        selectedGolongan = idx
//                        updateTarif(for: idx)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .padding(.horizontal, geometry.size.width * 0.015)
//            
//            
//            VStack(spacing: 12) {
//                DetailCard(title: "Golongan",
//                          value: videoCaptureCoordinator.shouldActivateGolongan ?
//                                getRomanNumeral(videoCaptureCoordinator.currentGolongan) : "I",
//                          color: Color(hex: "4338ca"))
//                DetailCard(title: "Tarif", value: tarif, color: Color(hex: "059669"))
//                DetailCard(title: "Status", value: paymentStatus,
//                          color: paymentStatus == "BELUM TERBAYAR" ? Color(hex: "dc2626") : Color(hex: "059669"))
//                DetailCard(title: "Waktu", value: DateFormatter.timeOnlyFormatter.string(from: currentTime),
//                          color: Color(hex: "7c3aed"))
//            }
//            .padding(.horizontal, geometry.size.width * 0.02)
//        }
//        .padding(.vertical, geometry.size.height * 0.03)
//    }
//    
//    func bottomSection(geometry: GeometryProxy) -> some View {
//        VStack(spacing: geometry.size.height * 0.025) {
//            
//            Text("Tol Pondok Aren 1")
//                .font(.system(size: 28, weight: .bold, design: .rounded))
//                .foregroundStyle(
//                    LinearGradient(
//                        colors: [Color(hex: "4338ca"), Color(hex: "7c3aed")],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//                .padding(.vertical, geometry.size.height * 0.02)
//            
//            HStack(alignment: .top, spacing: geometry.size.width * 0.02) {
//                
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Jumlah Kendaraan")
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(Color(hex: "374151"))
//                        .padding(.bottom, 6)
//                    
//                    VStack(spacing: 6) {
//                        ForEach(["I", "II", "III", "IV", "V"], id: \.self) { g in
//                            HStack {
//                                Text("Gol. \(g)")
//                                    .font(.system(size: 14, weight: .medium))
//                                    .foregroundColor(Color(hex: "6b7280"))
//                                Spacer()
//                                Text("\(vehicleCount[g] ?? 0)")
//                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
//                                    .foregroundColor(Color(hex: "374151"))
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 3)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 6)
//                                            .fill(Color(hex: "f3f4f6"))
//                                    )
//                            }
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 6)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color.white)
//                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
//                            )
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                
//               
//                VStack(alignment: .trailing, spacing: 12) {
//                   
//                    HStack {
//                        Image(systemName: "clock.fill")
//                            .foregroundColor(Color(hex: "7c3aed"))
//                        Text("Shift: 1 (06.00-14.00)")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(Color(hex: "374151"))
//                    }
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(hex: "7c3aed").opacity(0.1))
//                    )
//                    
//                 
//                    HStack(spacing: 12) {
//                        StaffCard(name: "Gibran Shevaldo", role: "Operator 1")
//                        StaffCard(name: "Jonathan Tjahjadi", role: "Operator 2")
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .padding(.horizontal, geometry.size.width * 0.02)
//        }
//        .padding(.bottom, geometry.size.height * 0.03)
//    }
//    
//    private func updateTarif(for golongan: Int) {
//        tarif = tarifGolongan[golongan] ?? "Rp9.500"
//    }
//    
//    private func updateVehicleCount(for category: String) {
//        if let currentCount = vehicleCount[category] {
//            vehicleCount[category] = currentCount + 1
//        }
//    }
//    
//    private func getRomanNumeral(_ number: Int) -> String {
//        switch number {
//        case 1: return "I"
//        case 2: return "II"
//        case 3: return "III"
//        case 4: return "IV"
//        case 5: return "V"
//        default: return "I"
//        }
//    }
//    
//    private func confirmGolongan(with key: Int) {
//        guard isAwaitingConfirmation,
//              let golongan = pendingGolongan,
//              key == golongan else { return }
//
//        updateTarif(for: golongan)
//        updateVehicleCount(for: getRomanNumeral(golongan))
//        paymentStatus = "TERDETEKSI & DIKONFIRMASI"
//        isAwaitingConfirmation = false
//        pendingGolongan = nil
//        showConfirmationAlert = true
//    }
//
//}
//
//
//
//#Preview {
//    ContentView()
//        .frame(width: 1200, height: 800)
//}

//
//  ContentView.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 17/07/25.


import SwiftUI

struct ContentView: View {
    @StateObject private var videoCaptureCoordinator = VideoCaptureCoordinator()
    @State private var selectedGolongan: Int = 0
    @State private var tarif: String = "Rp9.500"
    @State private var vehicleCount: [String: Int] = ["I": 0, "II": 0, "III": 0, "IV": 0, "V": 0]
    @State private var currentTime = Date()
    @State private var paymentStatus = "BELUM TERBAYAR"
    @State private var isAwaitingConfirmation: Bool = false
    @State private var pendingGolongan: Int?
    @State private var showConfirmationAlert = false
    @State private var confirmedGolongan: String = ""

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let tarifGolongan = [
        0: "Rp0",
        1: "Rp9.500",
        2: "Rp12.000",
        3: "Rp15.500",
        4: "Rp18.000",
        5: "Rp22.000"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                
                // Custom Alert Overlay
                if showConfirmationAlert {
                    CustomSuccessAlert(
                        isPresented: $showConfirmationAlert,
                        golongan: confirmedGolongan,
                        tarif: tarif
                    )
                }
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onChange(of: videoCaptureCoordinator.currentGolongan) { newGolongan in
            if videoCaptureCoordinator.shouldActivateGolongan && newGolongan > 0 {
                selectedGolongan = newGolongan
                pendingGolongan = newGolongan
                isAwaitingConfirmation = true
                paymentStatus = "KONFIRMASI DENGAN TOMBOL 1–5"
            }
        }
        .overlay(
            KeyPressView { key in
                confirmGolongan(with: key)
            }
        )
    }
    
    func headerSection(geometry: GeometryProxy) -> some View {
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
    
    func cameraSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 4) {
            Group {
                KameraGandarView()
                    .foregroundColor(.clear)
                    .frame(height: geometry.size.height * 0.35)
                    .overlay(
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
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
            
            KameraLajurView()
                .foregroundColor(.clear)
                .frame(height: geometry.size.height * 0.35)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
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
    
    func contentSection(geometry: GeometryProxy) -> some View {
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
    
    func classificationSection(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: geometry.size.height * 0.025) {
            HStack(spacing: geometry.size.width * 0.01) {
                ForEach(1...5, id: \.self) { idx in
                    let categoryKey = getRomanNumeral(idx)
                    let isActive = videoCaptureCoordinator.currentGolongan == idx && videoCaptureCoordinator.shouldActivateGolongan
                    let percentage = isActive ? String(format: "%.0f%%", videoCaptureCoordinator.currentConfidence * 100) : "0%"
                    
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
                    .onTapGesture {
                        selectedGolongan = idx
                        updateTarif(for: idx)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, geometry.size.width * 0.015)
            
            VStack(spacing: 12) {
                DetailCard(title: "Golongan",
                          value: videoCaptureCoordinator.shouldActivateGolongan ?
                                getRomanNumeral(videoCaptureCoordinator.currentGolongan) : "I",
                          color: Color(hex: "4338ca"))
                DetailCard(title: "Tarif", value: tarif, color: Color(hex: "059669"))
                DetailCard(title: "Status", value: paymentStatus,
                          color: paymentStatus == "BELUM TERBAYAR" ? Color(hex: "dc2626") : Color(hex: "059669"))
                DetailCard(title: "Waktu", value: DateFormatter.timeOnlyFormatter.string(from: currentTime),
                          color: Color(hex: "7c3aed"))
            }
            .padding(.horizontal, geometry.size.width * 0.02)
        }
        .padding(.vertical, geometry.size.height * 0.03)
    }
    
    func bottomSection(geometry: GeometryProxy) -> some View {
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
    
    private func updateTarif(for golongan: Int) {
        tarif = tarifGolongan[golongan] ?? "Rp9.500"
    }
    
    private func updateVehicleCount(for category: String) {
        if let currentCount = vehicleCount[category] {
            vehicleCount[category] = currentCount + 1
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
    
    private func confirmGolongan(with key: Int) {
        guard isAwaitingConfirmation,
              let golongan = pendingGolongan,
              key == golongan else { return }

        confirmedGolongan = getRomanNumeral(golongan)
        updateTarif(for: golongan)
        updateVehicleCount(for: getRomanNumeral(golongan))
        paymentStatus = "TERDETEKSI & DIKONFIRMASI"
        isAwaitingConfirmation = false
        pendingGolongan = nil
        showConfirmationAlert = true
    }
}

// Custom Success Alert Component
struct CustomSuccessAlert: View {
    @Binding var isPresented: Bool
    let golongan: String
    let tarif: String
    @State private var animationOffset: CGFloat = -200
    @State private var animationOpacity: Double = 0
    @State private var checkmarkScale: CGFloat = 0
    @State private var rippleScale: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissAlert()
                }
            
            // Alert container
            VStack(spacing: 0) {
                // Header with animated checkmark
                ZStack {
                    // Ripple effect
                    Circle()
                        .fill(Color(hex: "10b981").opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(rippleScale)
                    
                    // Main circle background
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "10b981"), Color(hex: "059669")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color(hex: "10b981").opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Checkmark icon
                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(checkmarkScale)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                // Title
                Text("Konfirmasi Berhasil!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1f2937"))
                    .padding(.bottom, 8)
                
                // Subtitle
                Text("Kendaraan telah berhasil dikonfirmasi")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "6b7280"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                // Vehicle details
                VStack(spacing: 12) {
                    DetailRow(icon: "car.2.fill", title: "Golongan", value: golongan, color: Color(hex: "4338ca"))
                    DetailRow(icon: "banknote.fill", title: "Tarif", value: tarif, color: Color(hex: "059669"))
                    DetailRow(icon: "clock.fill", title: "Waktu", value: DateFormatter.timeOnlyFormatter.string(from: Date()), color: Color(hex: "7c3aed"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "f8f9fa"))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Close button
                Button(action: dismissAlert) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Selesai")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "4338ca"), Color(hex: "6366f1")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: Color(hex: "4338ca").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 30)
            }
            .frame(width: 380)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .offset(y: animationOffset)
            .opacity(animationOpacity)
        }
        .onAppear {
            showAlert()
        }
    }
    
    private func showAlert() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            animationOffset = 0
            animationOpacity = 1
        }
        
        // Animate checkmark with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                checkmarkScale = 1.0
            }
        }
        
        // Animate ripple effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                rippleScale = 1.0
            }
        }
        
        // Auto dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            dismissAlert()
        }
    }
    
    private func dismissAlert() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            animationOffset = -200
            animationOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isPresented = false
        }
    }
}

// Detail Row Component for Alert
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6b7280"))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(Color(hex: "1f2937"))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.1))
                )
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1200, height: 800)
}
