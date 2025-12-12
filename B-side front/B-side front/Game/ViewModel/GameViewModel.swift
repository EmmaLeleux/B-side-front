//
//  GameViewModel.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import Foundation
import MultipeerConnectivity

@Observable
final class GameViewModel: NSObject {
    var role: Role = .none
    var username : String = ""
    var showLobby = false
    var gameStarted = false
    var currentAnswerSong: String = ""
    var currentAnswerArtist: String = ""
    var song : String = "You & I"
    var artist: String = "Dabeull"
    var musicOn : Bool = false
    var selectedPlaylist: Playlist? = nil
    var localMusicURLs: [URL] = []
    
    func preloadMusic(completion: @escaping () -> Void) {
        guard let playlist = selectedPlaylist else { return }
        
        localMusicURLs = []
        
        let group = DispatchGroup()
        
        for music in playlist.musiques {
            group.enter()
            FileDownloader.downloadFile(from: music.son) { localURL in
                if let localURL = localURL {
                    DispatchQueue.main.async {
                        self.localMusicURLs.append(localURL)
                        print("✔️ Musique téléchargée :", localURL)
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("✅ Toutes les musiques sont téléchargées !")
            completion()
        }
    }

    
    func cleanMusic() {
        for url in localMusicURLs {
            try? FileManager.default.removeItem(at: url)
        }
        localMusicURLs = []
    }
    
    var players : [Player] = []
    
    // devient optionnel : on l'instanciera quand l'utilisateur clique Create/Join
    var multipeerService: MultipeerService? = nil
    
    override init() {
        super.init()
    }
    
    func chooseHost() {
        role = .host
        print(role)
        multipeerService = MultipeerService(displayName: username.isEmpty ? UIDevice.current.name : username)
        // définit le delegate pour recevoir events/session
        multipeerService?.session.delegate = self
        multipeerService?.startHosting()
        addPlayer(peerID: multipeerService!.peerID)
        showLobby = true
        print("Hosting as \(multipeerService?.peerID.displayName ?? "unknown")")
    }
    
    func chooseClient() {
        role = .client
        multipeerService = MultipeerService(displayName: username.isEmpty ? UIDevice.current.name : username)
        multipeerService?.session.delegate = self
        multipeerService?.joinSession()
        addPlayer(peerID: multipeerService!.peerID)
        showLobby = true
        print("Joining as \(multipeerService?.peerID.displayName ?? "unknown")")
    }
    
    
    func addPlayer(peerID: MCPeerID) {
        let colorList = ["#006AF6", "#F60000", "#F6F600", "#29F600"]
        let index = players.count % colorList.count
        
        let newPlayer = Player(id: peerID.displayName,
                               name: peerID.displayName,
                               hasBuzzed: false,
                               points: 0, colorHex: colorList[index])
        
        DispatchQueue.main.async {
            if !self.players.contains(where: { $0.id == newPlayer.id }) {
                self.players.append(newPlayer)
            }
        }
    }
    
    func removePlayer(peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.players.removeAll { $0.id == peerID.displayName }
        }
    }
    
    //    func sendPlayersList(to peer: MCPeerID) {
    //        guard let service = multipeerService else { return }
    //
    //        let names = players.map { $0.name }
    //        if let data = try? JSONEncoder().encode(names) {
    //            try? service.session.send(data, toPeers: [peer], with: .reliable)
    //        }
    //    }
    
    func sendPlayersList(to peer: MCPeerID) {
        guard let service = multipeerService else { return }
        
        // Encode les players avec toutes les infos y compris colorHex
        if let data = try? JSONEncoder().encode(players) {
            try? service.session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    func leaveLobby() {
        guard let service = multipeerService else { return }
        
        removePlayer(peerID: service.peerID)
        
        service.session.disconnect()
        
        showLobby = false
    }
    
    func buzz(playerID: String) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        
        // Le joueur qui buzz peut repondre
        players[index].hasBuzzed = true
        players[index].canAnswer = true
        
        // Désactiver les autres
        for i in players.indices where players[i].id != playerID {
            players[i].isDisabled = true
        }
        
        // Notifier tous les joueurs
        sendBuzzerUpdate()
    }
    
    func sendBuzzerUpdate() {
        guard let service = multipeerService else { return }
        if let data = try? JSONEncoder().encode(players) {
            try? service.session.send(data, toPeers: service.session.connectedPeers, with: .reliable)
        }
    }
    
    
    // Quand on reçoit la liste mise à jour
    func updatePlayersFromData(_ data: Data) {
        if let updatedPlayers = try? JSONDecoder().decode([Player].self, from: data) {
            DispatchQueue.main.async {
                self.players = updatedPlayers.map { received in
                    if let existing = self.players.first(where: { $0.id == received.id }) {
                        return Player(
                            id: received.id,
                            name: received.name,
                            hasBuzzed: received.hasBuzzed,
                            points: received.points,
                            isDisabled: received.isDisabled,
                            canAnswer: received.canAnswer,
                            colorHex: existing.colorHex // garde la couleur locale
                        )
                    } else {
                        return received // pour un nouveau joueur, garde la couleur reçue
                    }
                }
            }
        }
    }
    
    
    
    func startGame() {
        guard role == .host else { return }
        gameStarted = true
        
        // Notifier tous les clients
        guard let service = multipeerService else { return }
        if let data = try? JSONEncoder().encode(["gameStarted": true]) {
            try? service.session.send(data, toPeers: service.session.connectedPeers, with: .reliable)
        }
    }
    
    func isAnswerCorrect(song: String, artiste: String) -> Bool {
        let correctSong = (song.lowercased() == self.song.lowercased())
        let correctArtist = (artiste.lowercased() == self.artist.lowercased())
        
        return correctSong || correctArtist
    }
    
    
    func wrongAnswer(playerID: String) {
        // Débloquer tous les buzzers si reponse fausse
        for i in players.indices {
            players[i].hasBuzzed = false
            players[i].isDisabled = false
            players[i].canAnswer = false
        }
        
        sendBuzzerUpdate()
    }
    
    func validateAnswer(playerID: String, song: String, artist: String) -> (correct: Bool, points: Int){
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return (false, 0) }
        
        var pointsToAdd = 0
        
        if song.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            == self.song.lowercased() {
            pointsToAdd += 2
        }
        
        if artist.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            == self.artist.lowercased() {
            pointsToAdd += 2
        }
        
        // Appliquer les points
        players[index].points += pointsToAdd
        
        // Reset buzzer state
        for i in players.indices {
            players[i].hasBuzzed = false
            players[i].canAnswer = false
            players[i].isDisabled = false
        }
        
        // Broadcast nouvelle liste à tout le monde
        broadcastPlayersList()
        
        return (pointsToAdd > 0, pointsToAdd)
    }
    
    
    func broadcastPlayersList() {
        guard let service = multipeerService else { return }
        
        if let data = try? JSONEncoder().encode(players) {
            try? service.session.send(
                data,
                toPeers: service.session.connectedPeers,
                with: .reliable
            )
        }
    }
    
    
    
}



extension GameViewModel: MCSessionDelegate {
    
    // 1) état de connexion d'un peer
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("MCSession didChange state: \(peerID.displayName) -> \(state.rawValue)")
        
        switch state {
            
        case .connected:
            if role == .host {
                addPlayer(peerID: peerID)
                
                broadcastPlayersList()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.broadcastPlayersList()
                }
            }
            
            
            
        case .notConnected:
            if self.role == .host {
                print("Host : joueur \(peerID.displayName) déconnecté")
                removePlayer(peerID: peerID)
            }
            
        default:
            break
        }
    }
    
    // 2) réception de Data (messages)
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // Début de partie
        if let dict = try? JSONDecoder().decode([String: Bool].self, from: data),
           let started = dict["gameStarted"], started {
            DispatchQueue.main.async {
                self.gameStarted = true
            }
            return
        }
        
        // Mise à jour complète des players
        if let updatedPlayers = try? JSONDecoder().decode([Player].self, from: data) {
            DispatchQueue.main.async {
                self.players = updatedPlayers
                
                // Ajoute le player local si pas déjà présent
                if let myPeerID = self.multipeerService?.peerID,
                   !self.players.contains(where: { $0.id == myPeerID.displayName }) {
                    self.addPlayer(peerID: myPeerID)
                }
            }
            return
        }
        
        // Sinon texte simple (debug)
        if let text = String(data: data, encoding: .utf8) {
            print("MCSession didReceive data from \(peerID.displayName): \(text)")
        }
    }
    
    
    // 3) réception de stream (non utilisé ici, mais requis)
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // noop
    }
    
    // 4) début réception d'une ressource (fichier)
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // noop
    }
    
    // 5) fin réception d'une ressource
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // noop
    }
}



