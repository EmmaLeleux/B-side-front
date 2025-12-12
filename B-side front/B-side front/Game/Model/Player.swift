//
//  Player.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import Foundation

struct Player: Identifiable, Equatable, Codable {
    var id : String
    var name : String
    var hasBuzzed : Bool
    var points : Int
    var isDisabled: Bool = false
    var canAnswer: Bool = false
    var colorHex: String = "#3498db"
    
}
