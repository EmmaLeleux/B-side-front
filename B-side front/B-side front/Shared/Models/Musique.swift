//
//  Musique.swift
//  B-side front
//
//  Created by Emma on 12/12/2025.
//

import Foundation

struct Musique: Codable, Identifiable, Equatable {
    var id: UUID
    var son: String
    var names: [MusiqueName]
    var artistes: [Artist]
}
