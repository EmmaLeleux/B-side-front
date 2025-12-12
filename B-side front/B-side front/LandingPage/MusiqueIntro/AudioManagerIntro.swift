//
//  AudioManager.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import AVFoundation

class AudioManagerIntro {
    // Singleton : Une seule instance pour toute l'app
    static let shared = AudioManagerIntro()
    
    var player: AVAudioPlayer?
    
    // Fonction pour lancer la musique
    // Par défaut, l'extension est "mp3", donc on passe juste le nom
    func playIntro(filename: String, fileExtension: String = "mp3") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("ERREUR AUDIO : Le fichier '\(filename).\(fileExtension)' est introuvable dans le Bundle.")
            print("Astuce : Vérifie que le fichier est bien coché dans 'Target Membership' dans l'inspecteur à droite.")
            return
        }
        
        do {
            // Permet de jouer le son même si l'iPhone est en mode silencieux (optionnel mais recommandé pour les jeux)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // -1 = Boucle infinie
            player?.volume = 0 // On commence à 0 pour le fade-in
            player?.prepareToPlay()
            player?.play()
            
            // Fade In progressif sur 2 secondes
            player?.setVolume(1.0, fadeDuration: 2.0)
            
        } catch {
            print("ERREUR LECTURE : \(error.localizedDescription)")
        }
    }
    
    // Fonction pour arrêter proprement (Fade Out)
    func stopIntro() {
        // Baisse le volume sur 1 seconde
        player?.setVolume(0, fadeDuration: 1.0)
        
        // Coupe le moteur après le fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.player?.stop()
            self.player = nil
        }
    }
}
