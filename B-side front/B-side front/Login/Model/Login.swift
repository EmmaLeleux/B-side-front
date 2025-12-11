//
//  Login.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: User
}
