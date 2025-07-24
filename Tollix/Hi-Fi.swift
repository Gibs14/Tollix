import SwiftUI

struct Hi_Fi: View {
    
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack(spacing: 0) {

                // HEADER
                HStack {
                    HStack(spacing: geometry.size.width * 0.012) {
                        Image("logo_Tica_blue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geometry.size.height * 0.045
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tollix")
                                .font(.system(size: geometry.size.width * 0.013, weight: .semibold))
                            Text("Classification Assistant")
                                .font(.system(size: geometry.size.width * 0.010))
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(DateFormatter.dayFormatter.string(from: currentTime))
                            .font(.system(size: geometry.size.width * 0.010, weight: .regular))
                        Text(DateFormatter.timeFormatter.string(from: currentTime))
                            .font(.system(size: geometry.size.width * 0.013, weight: .semibold))
                            .foregroundColor(Color(hex: "1E88E5"))
//                            .padding(.horizontal, 8)
                    }
                    .onReceive(timer) { input in
                        currentTime = input
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.015)
                .padding(.vertical, geometry.size.height * 0.015)
                .background(Color.white)
                .overlay(Rectangle().frame(height: 4).foregroundColor(.blue), alignment: .bottom)

                // MAIN CONTENT
                HStack(spacing: geometry.size.width * 0.015) {

                    // KIRI: KAMERA
                    VStack(spacing: geometry.size.height * 0.015) {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.clear)
                            .frame(height: geometry.size.height * 0.425)
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
                        
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.clear)
                            .frame(height: geometry.size.height * 0.425)
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
                    // KANAN: KONTEN
                        
                    VStack(spacing: geometry.size.height * 0.05) {
                        VStack {
                            Text("PONDOK AREN - GD.05")
                                .font(.system(size: geometry.size.width * 0.025, weight: .bold))
                                .padding(.top, geometry.size.height * 0.05)
                            HStack(spacing: geometry.size.width * 0.008) {
                                ForEach(["I", "II", "III", "IV", "V"], id: \.self) { item in
                                    Text(item)
                                        .frame(height: geometry.size.width * 0.082)
                                        .frame(maxWidth: .infinity)
                                        .background(item == "IV" ? Color.yellow : Color.gray.opacity(0.3))
                                        .foregroundColor(item == "IV" ? .black : .gray)
                                        .cornerRadius(16)
                                        .shadow(radius: 1)
                                        .font(.system(size: geometry.size.width * 0.025, design: .rounded))
                                }
                            }

                            // Legend
                            HStack(spacing: 24) {
                                HStack(spacing: 8) {
                                    Circle().fill(Color.green).frame(width: 16, height: 16)
                                    Text("Sangat Yakin").font(.system(size: geometry.size.width * 0.01, weight: .regular))
                                }
                                HStack(spacing: 8) {
                                    Circle().fill(Color.yellow).frame(width: 16, height: 16)
                                    Text("Perlu Ditinjau").font(.system(size: geometry.size.width * 0.01, weight: .regular))
                                }
                            }
                        }
                        .frame(height: geometry.size.height * 0.5)
                        .frame(maxWidth: .infinity)
                        
                        // Divider
                        Divider()
                            .frame(height: 2)
                            .background(Color.gray.opacity(0.6))
                            .padding(.vertical, geometry.size.height * 0.015)

                        // KONTEN UTAMA BAWAH
                        HStack(alignment: .top, spacing: geometry.size.width * 0.04) {
                            

                            // LEFT: INFO GRID
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.02) {
                                // Grid 2x2
                                LazyVGrid(
                                    columns: [
                                        GridItem(.fixed(geometry.size.width * 0.12)),
                                        GridItem(.fixed(geometry.size.width * 0.12))
                                    ],
                                    spacing: geometry.size.height * 0.01
                                ) {
                                    InfoBox(title: "Golongan", value: "IV", color: .blue, geometry: geometry)
                                    InfoBox(title: "Tarif", value: "Rp9.500", color: .blue, geometry: geometry)
                                    InfoBox(title: "Waktu", value: "00:00:00", color: .blue, geometry: geometry)
                                    InfoBox(title: "Kartu Pembayaran", value: "Flazz", color: .blue, geometry: geometry)
                                }

                                // Full-width payment status
                                InfoBox(
                                    title: "Status Pembayaran",
                                    value: "BELUM TERBAYAR",
                                    color: .red,
                                    geometry: geometry,
                                    isLarge: true,
                                    isFullWidth: true
                                )
                            }

                            // RIGHT: SHIFT PANEL
                            VStack(alignment: .center, spacing: geometry.size.height * 0.015) {
                                Text("Shift 1\nPeriode 1")
                                    .font(.system(size: geometry.size.width * 0.015, weight: .semibold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, geometry.size.height * 0.012)

                                ForEach(1...2, id: \.self) { _ in
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: geometry.size.width * 0.06, height: geometry.size.width * 0.08)
                                        Text("Nama Lengkap")
                                            .font(.system(size: geometry.size.width * 0.011))
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer(minLength: 0)
                            }
                            .frame(width: geometry.size.width * 0.14)
                            .frame(height: geometry.size.height * 0.45)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .padding(.top, geometry.size.height * 0.0005)

                        }
                        .frame(height: geometry.size.height * 0.5)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, (geometry.size.width * 0.015))
                .padding(.horizontal, (geometry.size.width * 0.015))
            }
            .background(Color.gray.opacity(0.1))
        }
        
        
    }
}

extension DateFormatter {
    static let tollixTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    static let tollixDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter
    }()
}

@ViewBuilder
func InfoBox(
    title: String,
    value: String,
    color: Color,
    geometry: GeometryProxy,
    isLarge: Bool = false,
    isFullWidth: Bool = false
) -> some View {
    VStack(alignment: .leading, spacing: 4) {
        Text(title)
            .font(.system(size: geometry.size.width * 0.012))
            .foregroundColor(.gray)
        Text(value)
            .font(.system(size: isLarge ? geometry.size.width * 0.025 : geometry.size.width * 0.02, weight: .bold))
            .foregroundColor(color)
    }
    .padding()
    .frame(
        maxWidth: isFullWidth ? .infinity : geometry.size.width * 0.2,
        alignment: .leading
    )
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: .black.opacity(0.07), radius: 4, x: 0, y: 2)
}

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


#Preview {
    Hi_Fi()
}
