//
//  NeonStyle.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

struct NeonStyle: ViewModifier {
    let glowColor: Color
    @State private var flickerOpacity: Double = 1.0
    @State private var glowRadius: CGFloat = 10
    
    // On peut activer/désactiver l'animation
    var isAnimated: Bool = true

    func body(content: Content) -> some View {
        content
            .shadow(color: glowColor.opacity(isAnimated ? 0.6 : 0.4), radius: isAnimated ? glowRadius : 5)
            .shadow(color: glowColor.opacity(0.4), radius: 2) // Lueur interne (tube)
            .opacity(isAnimated ? flickerOpacity : 1.0)
            .onAppear {
                guard isAnimated else { return }
                
                // Effet de scintillement aléatoire réaliste
                withAnimation(.linear(duration: 0.1).repeatForever(autoreverses: true)) {
                    flickerOpacity = 0.8
                    glowRadius = 12
                }
                
                // Ajout d'irrégularités (simulation de vieux néon)
                Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...4), repeats: true) { _ in
                    withAnimation(.easeOut(duration: 0.15)) {
                        flickerOpacity = 0.4
                        glowRadius = 2
                    }
                    withAnimation(.easeIn(duration: 0.1).delay(0.15)) {
                        flickerOpacity = 1.0
                        glowRadius = 15
                    }
                }
            }
    }
}

extension View {
    func neonGlow(color: Color = .purple, animated: Bool = true) -> some View {
        modifier(NeonStyle(glowColor: color, isAnimated: animated))
    }
}
