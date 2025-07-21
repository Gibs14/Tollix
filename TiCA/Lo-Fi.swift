import SwiftUI

struct Lo_Fi: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // HEADER
                VStack(spacing: geometry.size.height * 0.01) {
                    HStack {
                        HStack(spacing: geometry.size.width * 0.01) {
                            Rectangle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                                .overlay(Image(systemName: "square.fill")
                                    .foregroundColor(.white)
                                    .font(.title))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tollix")
                                    .bold()
                                    .font(.title)
                                Text("Classification Assistant")
                                    .font(.headline)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("Selasa, 15 Juli 2025")
                                .font(.title2)
                                .bold()
                            Text("08:55:30")
                                .font(.title2)
                                .bold()
                        }
                        .padding(.trailing, geometry.size.width * 0.04)
                    }
                    .padding(.horizontal, geometry.size.width * 0.04)

                    Divider()
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .background(Color.gray.opacity(0.5))
                }
                .padding(.top, geometry.size.height * 0.03)
                .padding(.bottom, geometry.size.height * 0.02)

                HStack(spacing: 0) {
                    // KIRI KAMERA
                    VStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.gray)
                            .overlay(Text("KAMERA GANDAR").foregroundColor(.white))
                        Divider()
                            .frame(height: 2)
                            .background(Color.white.opacity(0.5))
                        Rectangle()
                            .foregroundColor(.gray)
                            .overlay(Text("KAMERA LAJUR").foregroundColor(.white))
                    }
                    .frame(width: geometry.size.width * 0.45)
                    .padding(.leading, geometry.size.width * 0.02)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    .padding(.trailing, geometry.size.width * 0.01)

                    // KANAN KONTEN
                    VStack(alignment: .leading) {
                        // ATAS
                        VStack(alignment: .leading, spacing: geometry.size.height * 0.03) {
                            HStack(spacing: geometry.size.width * 0.015) {
                                ForEach(1...5, id: \.self) { idx in
                                    VStack {
                                        Text("Golongan \(idx)")
                                            .font(.caption2)
                                        Text(idx == 1 ? "80%" : "0%")
                                            .font(.title)
                                            .bold()
                                    }
                                    .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                                    .background(idx == 1 ? .green : .gray.opacity(0.2))
                                    .cornerRadius(24)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, geometry.size.height * 0.02)
                            .padding(.bottom, geometry.size.height * 0.02)

                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Golongan")
                                    Text("Tarif")
                                    Text("Status")
                                    Text("Waktu")
                                }
                                Spacer()
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("I").bold()
                                    Text("Rp9.500").bold()
                                    Text("BELUM TERBAYAR").bold()
                                    Text("00:00:00").bold()
                                }
                                Spacer()
                            }
                            .font(.title)
                            .padding(.horizontal, geometry.size.width * 0.05)
                        }
                        .padding(.bottom)
                        .padding(.leading, geometry.size.width * 0.01)
                        .padding(.trailing, geometry.size.width * 0.03)
                        .padding(.top, geometry.size.height * 0.03)

                        Divider()
                            .frame(height: 1)
                            .background(Color.gray.opacity(0.5))
                            .padding(.horizontal, geometry.size.width * 0.01)
                            .padding(.top, geometry.size.height * 0.015)

                        // BAGIAN KANAN BAWAH
                        VStack(spacing: geometry.size.height * 0.03) {
                            // JUDUL TENGAH
                            HStack {
                                Spacer()
                                Text("Tol Pondok Aren 1")
                                    .font(.largeTitle)
                                    .bold()
                                    .padding(.top, geometry.size.height * 0.04)
                                    .padding(.bottom, geometry.size.height * 0.02)
                                Spacer()
                            }
                            
                            HStack(alignment: .top) {
                                // KIRI: JUMLAH KENDARAAN
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Jumlah Kendaraan")
                                        .font(.title)
                                        .bold()
                                    ForEach(["I", "II", "III", "IV", "V"], id: \.self) { g in
                                        HStack {
                                            Text("Golongan \(g)")
                                                .font(.title2)
                                            Spacer()
                                            Text("0")
                                                .font(.title2)
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 4)
                                        .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                // KANAN: SHIFT + FOTO + NAMA
                                VStack(alignment: .trailing, spacing: 12) {
                                    Text("Shift: 1 (06.00-14.00)")
                                        .bold()
                                        .font(.title3)
                                    HStack(spacing: 16) {
                                        VStack {
                                            Rectangle()
                                                .foregroundColor(.gray.opacity(0.3))
                                                .frame(width: 130, height: 130)
                                            Text("Gibran Shevaldo")
                                                .font(.headline)
                                                .bold()
                                        }
                                        VStack {
                                            Rectangle()
                                                .foregroundColor(.gray.opacity(0.3))
                                                .frame(width: 130, height: 130)
                                            Text("Jonathan Tjahjadi")
                                                .font(.headline)
                                                .bold()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, geometry.size.width * 0.04)
                        }
                        .padding(.bottom, geometry.size.height * 0.03)

                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.55)
                    .padding(.top, geometry.size.height * 0.03)
                }
            }
            .background(Color.white)
        }
    }
}

#Preview {
    Lo_Fi()
}
