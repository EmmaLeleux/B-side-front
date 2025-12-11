//
//  Playlist.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import Foundation

struct Playlist: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let picture: String
}
