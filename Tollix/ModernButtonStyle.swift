//
//  ModernButtonStyle.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 23/07/25.
//

import SwiftUI

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
