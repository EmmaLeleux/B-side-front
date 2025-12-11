//
//  JukeBox.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

// --- LE STYLE ANIMÉ (MODIFIER) ---
struct NeonGlitchStyle: ViewModifier {
    @State private var isOn: Bool = true
    
    // Dégradé Violet/Rose demandé
    private let colorGradient = LinearGradient(
        colors: [.purple, .pink],
        startPoint: .top,
        endPoint: .bottom
    )
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorGradient)
            // Effet électrique saccadé
            .opacity(isOn ? 1.0 : 0.6)
            .shadow(color: .pink.opacity(0.8), radius: isOn ? 15 : 4) // Gros halo rose quand allumé
            .shadow(color: .purple, radius: 2) // Petit halo violet constant
            .onAppear {
                // Animation rapide et aléatoire
                withAnimation(.linear(duration: 0.08).repeatForever(autoreverses: true)) {
                    isOn.toggle()
                }
            }
    }
}

extension View {
    func neonGlitch() -> some View {
        modifier(NeonGlitchStyle())
    }
}

// --- LA VUE PRINCIPALE ---
struct JukeBox: View {
    var body: some View {
        ZStack {
            // 1. Image de fond
            Image("Juke")
                .imageScale(.large)
                .ignoresSafeArea()

            // 2. Le Néon Vectoriel (Entier)
            GeometryReader { geo in
                // On dessine TOUT le néon (.all) en un seul bloc
                // pour que l'animation soit parfaitement synchronisée
                JukeNeonShape(part: .all)
                    .neonGlitch() // Application du style Violet/Rose animé
                    .frame(width: 315, height: 437)
                    .offset(y: -39)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            .ignoresSafeArea()
        }
        // Fond sombre pour bien voir l'effet en preview
        .background(Color.clear)
    }
}

#Preview {
    JukeBox()
}
