//
//  StaffCard.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 23/07/25.
//

import SwiftUI

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
