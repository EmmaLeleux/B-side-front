//
//  JukeBox.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

// --- LE STYLE ANIMÉ (INCHANGÉ) ---
struct NeonGlitchStyle: ViewModifier {
    @State private var isOn: Bool = true
    private let colorGradient = LinearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom)
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorGradient)
            .opacity(isOn ? 1.0 : 0.6)
            .shadow(color: .pink.opacity(0.8), radius: isOn ? 15 : 4)
            .shadow(color: .purple, radius: 2)
            .onAppear {
                withAnimation(.linear(duration: 0.08).repeatForever(autoreverses: true)) {
                    isOn.toggle()
                }
            }
    }
}

extension View {
    func neonGlitch() -> some View { modifier(NeonGlitchStyle()) }
}

// --- LA VUE PRINCIPALE ---
struct JukeBox: View {
    // NOUVEAU : Paramètres pour contrôler l'apparition indépendante
    var showBody: Bool
    var showNeon: Bool

    var body: some View {
        ZStack {
            // 1. Image de fond (Le boitier)
            Image("Juke")
                .imageScale(.large)
                .ignoresSafeArea()
                // On contrôle son apparition ici
                .opacity(showBody ? 1 : 0)
                // Petite animation fluide quand le corps apparait
                .animation(.easeIn(duration: 2.0), value: showBody)

            // 2. Le Néon Vectoriel
            GeometryReader { geo in
                JukeNeonShape(part: .all)
                    .neonGlitch()
                    .frame(width: 315, height: 437)
                    .offset(y: -39)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    // On contrôle le néon ici (Instant pour le glitch)
                    .opacity(showNeon ? 1 : 0)
            }
            .ignoresSafeArea()
        }
        .background(Color.clear)
    }
}

// Preview mise à jour pour tester l'état "tout allumé"
#Preview {
    JukeBox(showBody: true, showNeon: true)
    .background(.black)
}
