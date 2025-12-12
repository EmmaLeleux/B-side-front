////
////  ShopViewModel.swift
////  B-side front
////
////  Created by Chab on 11/12/2025.
////
//
//
//import SwiftUI
//
//@Observable
//class ShopViewModel {
//    
//// TEST EN STATIQUE
//    // solde de l'utilisateur
//    var coins: Int = 325
//    
//    // playlist sélectionnée dans le carrousel
//    var selectedIndex: Int = 0
//    
//    // PLAYLISTS utilisées par la boutique
//    var playlists: [Playlist] = [
//        Playlist(id: UUID(),
//                 name: "Variété",
//                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
//                 picture: "cover1"),
//        
//        Playlist(id: UUID(),
//                 name: "Pop",
//                 description: "Suspendisse potenti. Sed sed nisi libero.",
//                 picture: "cover2"),
//        
//        Playlist(id: UUID(),
//                 name: "Jazz",
//                 description: "Proin at augue nec justo sodales sodales.",
//                 picture: "cover3"),
//        
//        Playlist(id: UUID(),
//                 name: "Jazz",
//                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
//                 picture: "cover4"),
//        
//        Playlist(id: UUID(),
//                 name: "Pop",
//                 description: "Suspendisse potenti. Sed sed nisi libero.",
//                 picture: "cover5"),
//        
//        Playlist(id: UUID(),
//                 name: "Jazz",
//                 description: "Proin at augue nec justo sodales sodales.",
//                 picture: "cover3")
//    ]
//    
//    // prix associés
//    var prices: [UUID: Int] = [:]
//    
//    init() {
//        for playlist in playlists {
//            prices[playlist.id] = Int.random(in: 100...300)
//        }
//    }
//    
//    var selectedPlaylist: Playlist {
//        playlists[selectedIndex]
//    }
//    
//    var selectedPrice: Int {
//        prices[selectedPlaylist.id] ?? 0
//    }
//    
//    func buySelectedItem() {
//        let cost = selectedPrice
//        if coins >= cost {
//            coins -= cost
//        }
//    }
//}
//


import SwiftUI

@Observable
class ShopViewModel {

    var playlists: [Playlist] = []
    var token: String? {
        didSet {
            if let token {
                saveToken(token)
            } else {
                clearToken()
            }
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .didLogin, object: nil)
        self.token = loadToken()
    }

    @objc private func onLogin() {
        
        self.token = loadToken()
    }
// TEST EN STATIQUE
    // solde de l'utilisateur
    var coins: Int = 325
    
    // playlist sélectionnée dans le carrousel
    var selectedIndex: Int = 0
    
    // PLAYLISTS utilisées par la boutique
    
    
    
    func fetchPlaylist(){
        guard let token,
              let url = URL(string: "http://localhost:8080/playlist") else {
            print("mauvais url")
            return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let decodedPlaylist = try JSONDecoder().decode([Playlist].self, from: data)
                    DispatchQueue.main.async {
                        self.playlists = decodedPlaylist
                        
                    }
                }
                catch {
                    print("Error decoding: \(error)")
                }
            }
            else if let error {
                print("Error: \(error)")
            }
        }
        .resume()
    }
    // prix associés
    var prices: [UUID: Int] = [:]
    
    
    
    var selectedPlaylist: Playlist {
        playlists[selectedIndex]
    }
    
    var selectedPrice: Int {
        if isBuy{
            return 0
        }
        else{
            return Int.random(in: 50..<300)
        }
    }
    
   var isBuy = false
    func buySelectedItem() {
        let cost = selectedPrice
        if coins >= cost {
            coins -= cost
        }
        
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    private func loadToken() -> String? {
        
        UserDefaults.standard.string(forKey: "authToken")
    }
    
    private func clearToken() {
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}

