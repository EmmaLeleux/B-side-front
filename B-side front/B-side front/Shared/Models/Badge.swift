//
//  Badges.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import Foundation

struct Badge: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let picture: String
    let nbMoney: Int
}
