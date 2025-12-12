//
//  LandingView.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

struct LandingView: View {
    
    // ViewModel du jeu
    @State var gameVM = GameViewModel()
    @Environment(LoginViewModel.self) var loginVM
    
    // --- ÉTATS D'ANIMATION (Séquence d'intro) ---
    @State private var showNeon = false      // Étape 1 : Les tubes et le TITRE s'allument
    @State private var showJukeBody = false  // Étape 2 : Le corps du Jukebox apparait
    @State private var showRoom = false      // Étape 2 : Le mur et l'interface apparaissent
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Layer 0 : Noir Absolu (Base)
                Color.black.ignoresSafeArea()
                
                // MARK: - Layer 1 : Background (Mur)
                Image("BrickWall")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: -4)
                    .opacity(showRoom ? 1 : 0) // Fade In
                
                // MARK: - Layer 2 : Jukebox (Artwork)
                VStack {
                    JukeBox(showBody: showJukeBody, showNeon: showNeon)
                        .offset(y: 90)
                }
                
                // MARK: - Layer 2 BIS : TITRE D'INTRO (B-SIDE)
                // Apparait avec le néon, disparait quand la salle s'allume
                VStack {
                    if showNeon && !showRoom {
                        NeonTitle()
                            // Transition fluide quand il disparait
                            .transition(.opacity.animation(.easeOut(duration: 0.5)))
                    }
                    Spacer()
                }
                .padding(.top, 110) // Positionné en haut
                .zIndex(10) // Au dessus du Jukebox sombre
                
                // MARK: - Layer 3 : Carousel (Selection)
                VStack {
                    VinylCarouselView()
                        .environment(LoginViewModel())
                        .environment(gameVM)
                        .padding(.top, 60)
                    Spacer()
                }
                .opacity(showRoom ? 1 : 0)
                
                // MARK: - Layer 4 : UI Controls (Buttons)
                VStack {
                    // --- Zone Haute : Profil & Shop ---
                    HStack {
                        NavigationLink(destination: ProfilView().environment(loginVM)) {
                            CircleButton(icon: "person.fill")
                        }
                        Spacer()
                        NavigationLink(destination: Text("Page Shop à créer")) {
                            CircleButton(icon: "cart.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // --- Zone Basse : Bouton Jouer ---
                    NavigationLink {
                        RoomView()
                            .environment(gameVM)
                    } label: {
                        PlayButton()
                    }
                    .padding(.bottom, 365)
                }
                .opacity(showRoom ? 1 : 0)
            }
            // MARK: - Séquence d'Animation (Intro)
            .task {
                // 1. Noir total initial
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                
                // 2. Les Néons s'allument + TITRE
                withAnimation(.easeOut(duration: 0.2)) {
                    showNeon = true
                }
                
                // 3. On laisse briller pendant 2.5 secondes (temps de lire le titre)
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                
                // 4. La lumière éclaire le reste et le TITRE disparait
                withAnimation(.easeIn(duration: 2.0)) {
                    showJukeBody = true
                    showRoom = true
                }
            }
        }
        .tint(.white)
    }
}

// MARK: - Subviews & Styles (Composants UI)

// 1. LE TITRE "FUNKY" AVEC EFFET SHINE
struct NeonTitle: View {
    @State private var shinePhase: CGFloat = -1.0 // Position de départ du reflet (gauche hors écran)
    
    var body: some View {
        ZStack {
            // A. Lueur globale (Glow)
            Text("B-SIDE")
                .font(.system(size: 90, weight: .black, design: .rounded))
                .italic() // Le côté Funky
                .foregroundStyle(.purple.opacity(0.6))
                .blur(radius: 15)
            
            // B. Le Texte Principal
            Text("B-SIDE")
                .font(.system(size: 90, weight: .black, design: .rounded)) // Très épais
                .italic()
                // Dégradé de base du texte
                .foregroundStyle(
                    LinearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom)
                )
                // C. L'Effet de Brillance (Shimmer)
                .overlay {
                    GeometryReader { geo in
                        // Le faisceau lumineux
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: .clear, location: 0),
                                        .init(color: .white.opacity(0.8), location: 0.5), // Centre blanc brillant
                                        .init(color: .clear, location: 1)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            // On l'incline un peu pour faire stylé
                            .rotationEffect(.degrees(20))
                            // On le déplace de gauche à droite
                            .offset(x: -geo.size.width + (geo.size.width * 3 * shinePhase))
                            // MASQUE CRITIQUE : L'effet ne s'affiche QUE sur la forme du texte
                            .mask(
                                Text("B-SIDE")
                                    .font(.system(size: 90, weight: .black, design: .rounded))
                                    .italic()
                            )
                    }
                }
        }
        .onAppear {
            // Animation en boucle du reflet
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                shinePhase = 1.0 // Va vers la droite hors écran
            }
        }
    }
}

// 2. Bouton Rond (Profil / Shop)
struct CircleButton: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.title3.bold())
            .foregroundStyle(.white)
            .frame(width: 50, height: 50)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

// 3. Gros Bouton JOUER
struct PlayButton: View {
    let horizontalPadding: CGFloat = 52
    let verticalPadding: CGFloat = 19
    let cornerRadius: CGFloat = 5
    
    var body: some View {
        Text("JOUER")
            .font(.system(size: 24, weight: .heavy, design: .rounded))
            .kerning(2)
            .foregroundStyle(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .pink.opacity(0.5), radius: 20, x: 0, y: 10)
            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    LandingView()
}
