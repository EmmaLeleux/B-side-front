//
//  AudioManager.swift
//  NoxiumFront
//
//  Created by Mounir Emahoten on 03/11/2025.
//

import AVFoundation
import Observation

@Observable
class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    
    private init() { }
    
    func playLocalFile(at url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("❌ Impossible de lire le fichier local :", error)
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }
}

