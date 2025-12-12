//
//  View.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

struct VinylCarouselView: View {
    @State private var vm = CarouselViewModel()
    @Environment(LoginViewModel.self) var loginVM
    @State private var dragOffset: Double = 0
    @State var selectedPlaylist: Playlist? = nil
    // État pour gérer l'animation de pression
    @State private var pressedGenre: MusicGenre? = nil
    
    // CONFIGURATION
    private let radiusX: CGFloat = 160
    private let radiusY: CGFloat = 70
    private let iconSize: CGFloat = 90
    
    var body: some View {
        ZStack {
            if let user = loginVM.currentUser{
                ForEach(Array(user.playlists.enumerated()), id: \.offset) { index, playlist in
                    let baseAngle = Double(index) * vm.anglePerItem
                    let currentAngleDegrees = baseAngle + vm.rotationAngle + dragOffset
                    let radians = currentAngleDegrees * .pi / 180
                    
                    // Calcul de position
                    let xOffset = radiusX * cos(radians)
                    let yOffset = radiusY * sin(radians)
                    
                    // Calcul de profondeur
                    let heightFactor = -sin(radians)
                    let isVisible = heightFactor > -0.2
                    
                    // FACTEUR D'ÉCHELLE DU CARROUSEL (Loupe au centre)
                    let carouselScale = 0.8 + (0.5 * max(0, heightFactor))
                    
                    // FACTEUR D'ÉCHELLE DE PRESSION (Si on appuie dessus)
                    let pressScale = (selectedPlaylist == playlist) ? 0.9 : 1.0
                    
                    if isVisible {
                        VStack {
                            AsyncImage(url: URL(string: playlist.picture)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconSize, height: iconSize)
                                    .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .scaleEffect(carouselScale * pressScale)
                        .opacity(0.5 + (0.5 * max(0, heightFactor)))
                        .zIndex(heightFactor)
                        .offset(x: xOffset, y: yOffset)
                        .onTapGesture {
                            animatePress(for: playlist)
                        }
                    }
                }
            }
        }
        .frame(width: 380, height: 200)
        .offset(y: 50)
        .clipped()
        .contentShape(Rectangle())
        // Le DragGesture reste sur le conteneur global
        .gesture(
            DragGesture()
                .onChanged { value in
                    let sensitivity: Double = 0.8
                    dragOffset = Double(value.translation.width) * sensitivity
                }
                .onEnded { _ in
                    vm.rotationAngle += dragOffset
                    dragOffset = 0
                    vm.snapToNearest()
                }
        )
        // Petit retour haptique pour le style (optionnel)
        .sensoryFeedback(.selection, trigger: selectedPlaylist)
    }
    
    // Fonction pour gérer l'effet "Ressort" du bouton
    private func animatePress(for genre: Playlist) {
        // 1. On enfonce le bouton
        withAnimation(.easeOut(duration: 0.1)) {
            selectedPlaylist = genre
        }
        
        // 2. On le relâche (rebond)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pressedGenre = nil
            }
            
            // ICI : Action à déclencher (ex: Sélectionner le genre ou lancer le jeu)
            print("Genre sélectionné : \(genre.name)")
            // Si tu veux que le tap fasse tourner la roue vers cet item, on pourrait l'ajouter ici.
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VinylCarouselView().environment(LoginViewModel())
    }
}
