//
//  Data.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//

import Foundation

enum MusicGenre: String, CaseIterable, Identifiable {
    case kpop = "VinylKPOP"
    case rapUS = "VinylRapUS"
    case rnb = "VinylRNB"
    case rock = "VinylROCK"
    case tv = "VinylTV"
    case plus = "VinylPlus" // bouton d'ajout
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .plus: return "AJOUTER" // Titre spécial pour le bouton +
        default: return rawValue.replacingOccurrences(of: "Vinyl", with: "").uppercased()
        }
    }
}
