//
//  LandingView.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

struct LandingView: View {
    
    @State var gameVM = GameViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Layer 1 : Background
                Image("BrickWall")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: -4)
                
                // MARK: - Layer 2 : Jukebox (Artwork)
                VStack {
                    JukeBox()
                        .offset(y: 90)
                }
                
                // MARK: - Layer 3 : Carousel (Selection)
                VStack {
                    VinylCarouselView()
                        .padding(.top, 60)
                    Spacer()
                }
                
                // MARK: - Layer 4 : UI Controls (Buttons)
                VStack {
                    // --- Zone Haute : Profil & Shop ---
                    HStack {
                        // Bouton Profil (Gauche)
                        NavigationLink(destination: Text("Page Profil à créer")) {
                            CircleButton(icon: "person.fill")
                        }
                        
                        Spacer()
                        
                        // Bouton Shop (Droite)
                        NavigationLink(destination: Text("Page Shop à créer")) {
                            CircleButton(icon: "cart.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60) // Alignement avec le haut du carrousel
                    
                    Spacer() // Pousse le bouton Jouer vers le bas
                    
                    // --- Zone Basse : Bouton Jouer ---
                    NavigationLink {
                        EnAttendant(gameVM: $gameVM)
                            
                    } label: {
                        PlayButton()
                    }
                    .padding(.bottom, 50)

                }
            }
        }
        // Pour cacher la barre de navigation système et garder ton design pur
        .tint(.white)
    }
}

// MARK: - Subviews & Styles (Composants UI)

// 1. Bouton Rond (Profil / Shop)
struct CircleButton: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(width: 50, height: 50)
            .background(.ultraThinMaterial) // Effet de verre flouté
            .clipShape(Circle())
            // Bordure néon subtile
            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

// 2. Gros Bouton JOUER
struct PlayButton: View {
    var body: some View {
        Text("JOUER")
            .font(.system(size: 24, weight: .heavy, design: .rounded))
            .kerning(2) // Espacement des lettres
            .foregroundStyle(.white)
            .padding(.horizontal, 60)
            .padding(.vertical, 18)
            .background(
                // Dégradé Electrique (Rose vers Violet)
                LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(Capsule())
            // Double Ombre pour l'effet de lueur (Glow)
            .shadow(color: .pink.opacity(0.5), radius: 20, x: 0, y: 10)
            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 2)
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    LandingView()
}
