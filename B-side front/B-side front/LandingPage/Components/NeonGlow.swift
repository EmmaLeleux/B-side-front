//
//  NeonGlow.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

struct NeonGlow: ViewModifier {
    let color: Color
    @State private var isFlickering = false

    func body(content: Content) -> some View {
        content
            // 1. Force la couleur de l'image (si template)
            .foregroundStyle(color)
            // 2. Effet de flou pour simuler le halo lumineux interne
            .shadow(color: color, radius: isFlickering ? 2 : 1)
            // 3. Effet de flou large pour l'atmosphère néon
            .shadow(color: color.opacity(0.6), radius: isFlickering ? 15 : 10)
            // 4. Variation d'opacité pour l'effet électrique
            .opacity(isFlickering ? 1.0 : 0.8)
            .onAppear {
                // Animation de "respiration" irrégulière pour simuler le courant
                withAnimation(.easeIn(duration: 0.15).repeatForever(autoreverses: true)) {
                    isFlickering.toggle()
                }
                
                // Note : Pour un clignotement plus réaliste (buggy neon),
                // on utiliserait KeyframeAnimator (iOS 17+), mais restons simple.
            }
    }
}

extension View {
    func neonEffect(color: Color = .purple) -> some View {
        modifier(NeonGlow(color: color))
    }
}
