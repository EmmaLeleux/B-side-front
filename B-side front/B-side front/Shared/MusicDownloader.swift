//
//  MusicDownloader.swift
//  B-side front
//
//  Created by Mounir Emahoten on 12/12/2025.
//

import Foundation

class FileDownloader {
    static func downloadFile(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                print("❌ Erreur téléchargement :", error?.localizedDescription ?? "Inconnue")
                completion(nil)
                return
            }
            
            // Destination dans Documents/
            let filename = UUID().uuidString + ".mp3"
            let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(filename)
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: destination)
                completion(destination)
            } catch {
                print("❌ Erreur copie du fichier :", error)
                completion(nil)
            }
        }.resume()
    }
}
