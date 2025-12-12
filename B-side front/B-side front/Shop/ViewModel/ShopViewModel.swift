//
//  ShopViewModel.swift
//  B-side front
//
//  Created by Chab on 11/12/2025.
//


import SwiftUI

@Observable
class ShopViewModel {
    
// TEST EN STATIQUE
    // solde de l'utilisateur
    var coins: Int = 325
    
    // playlist sélectionnée dans le carrousel
    var selectedIndex: Int = 0
    
    // PLAYLISTS utilisées par la boutique
    var playlists: [Playlist] = [
        Playlist(id: UUID(),
                 name: "Variété",
                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                 picture: "cover1"),
        
        Playlist(id: UUID(),
                 name: "Pop",
                 description: "Suspendisse potenti. Sed sed nisi libero.",
                 picture: "cover2"),
        
        Playlist(id: UUID(),
                 name: "Jazz",
                 description: "Proin at augue nec justo sodales sodales.",
                 picture: "cover3"),
        
        Playlist(id: UUID(),
                 name: "Jazz",
                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                 picture: "cover4"),
        
        Playlist(id: UUID(),
                 name: "Pop",
                 description: "Suspendisse potenti. Sed sed nisi libero.",
                 picture: "cover5"),
        
        Playlist(id: UUID(),
                 name: "Jazz",
                 description: "Proin at augue nec justo sodales sodales.",
                 picture: "cover3")
    ]
    
    // prix associés
    var prices: [UUID: Int] = [:]
    
    init() {
        for playlist in playlists {
            prices[playlist.id] = Int.random(in: 100...300)
        }
    }
    
    var selectedPlaylist: Playlist {
        playlists[selectedIndex]
    }
    
    var selectedPrice: Int {
        prices[selectedPlaylist.id] ?? 0
    }
    
    func buySelectedItem() {
        let cost = selectedPrice
        if coins >= cost {
            coins -= cost
        }
    }
}

