//
//  ViewModel.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import SwiftUI

@Observable
class CarouselViewModel {
    let items = MusicGenre.allCases
    
    // Rotation globale en degrés.
    // On commence à -90 pour que le premier item soit pile en haut au démarrage.
    var rotationAngle: Double = -90
    
    // L'écart angulaire entre chaque vinyle.
    // 360 / 6 items = 60 degrés chacun.
    // Cela crée une boucle parfaite.
    var anglePerItem: Double {
        360.0 / Double(items.count)
    }
    
    // Détermine l'item sélectionné (celui qui est le plus proche de -90°, le haut du cercle)
    var selectedGenre: MusicGenre {
        // On normalise l'angle pour qu'il reste compréhensible (modulo 360)
        let normalizedAngle = rotationAngle.truncatingRemainder(dividingBy: 360)
        
        // On cherche quel index aurait un angle proche de -90
        // C'est une approximation pour l'UI, la vraie selection se fait visuellement
        // Astuce simple : on prend l'index opposé à l'angle actuel
        let approximateIndex = Int(round((-normalizedAngle - 90) / anglePerItem))
        
        // Gestion des index négatifs ou > count pour la boucle array
        let count = items.count
        let index = (approximateIndex % count + count) % count
        return items[index]
    }
    
    // Magnétisme : Arrondir l'angle à la case la plus proche quand on relâche
    func snapToNearest() {
        let targetIndex = round(rotationAngle / anglePerItem)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            rotationAngle = targetIndex * anglePerItem
        }
    }
}
