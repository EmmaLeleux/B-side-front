//
//  User.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let username: String
    let money: Int
    let picture: String
    let playlists: [Playlist]
    let badges: [Badge]
}
