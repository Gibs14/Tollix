//
//  DetailCard.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 23/07/25.
//

import SwiftUI

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
//            RoundedRectangle(cornerRadius: 6)
//                .fill(color)
//                .frame(width: 4)
        }
        
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
            
        )
    }
}

