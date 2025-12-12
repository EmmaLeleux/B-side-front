//
//  Artist.swift
//  B-side front
//
//  Created by Emma on 12/12/2025.
//

import Foundation

struct Artist: Codable, Identifiable, Equatable {
    var id: UUID
    var names: [ArtistName]
}
