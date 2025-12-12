////
////  CarouselView.swift
////  B-side front
////
////  Created by Chab on 11/12/2025.
////
//
//
//import SwiftUI

import SwiftUI

struct CarouselView: View {
    let items: [Playlist]
    @Binding var selectedIndex: Int
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let centerX = width / 2
            
            ZStack {
                ForEach(-1...1, id: \.self) { position in
                    let index = (selectedIndex + position + items.count) % items.count
                    let offset = CGFloat(position) * 140 + dragOffset
                    let absOffset = abs(offset)
                    
                    // Calculs pour l'effet 3D
                    let scale: CGFloat = position == 0 ? 1.0 : 0.75
                    let rotation = Double(offset) * 8.0
                    let zIndex = position == 0 ? 100.0 : 50.0 - absOffset
                    let xOffset = offset * 1.0
                    
                    AsyncImage(url: URL(string: items[index].picture)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 200)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                            .scaleEffect(scale)
                            .rotation3DEffect(
                                .degrees(rotation),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.5
                            )
                    } placeholder: {
                        ProgressView()
                    }
                        
                        .offset(x: centerX + xOffset - 140)
                        .zIndex(zIndex)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                if position == -1 {
                                    selectedIndex = (selectedIndex - 1 + items.count) % items.count
                                } else if position == 1 {
                                    selectedIndex = (selectedIndex + 1) % items.count
                                }
                            }
                        }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        let velocity = value.predictedEndTranslation.width - value.translation.width
                        
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            if value.translation.width > threshold || velocity > 100 {
                                // Swipe vers la droite - carte précédente
                                selectedIndex = (selectedIndex - 1 + items.count) % items.count
                            } else if value.translation.width < -threshold || velocity < -100 {
                                // Swipe vers la gauche - carte suivante
                                selectedIndex = (selectedIndex + 1) % items.count
                            }
                            dragOffset = 0
                        }
                    }
            )
        }
        .frame(height: 260)
    }
}
