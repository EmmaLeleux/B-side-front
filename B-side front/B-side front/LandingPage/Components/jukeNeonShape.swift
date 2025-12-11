//
//  jukeNeonShape.swift
//  B-side front
//
//  Created by Larderet on 11/12/2025.
//
import SwiftUI

struct JukeNeonShape: Shape {
    // Si tu veux dessiner tout, ou juste une partie
    enum Part { case top, bottom, all }
    var part: Part = .all

    func path(in rect: CGRect) -> Path {
        // Le SVG original est sur une base de 315x432.
        // On calcule un ratio pour que ça s'adapte à la frame SwiftUI
        let scaleX = rect.width / 315
        let scaleY = rect.height / 432
        
        var path = Path()

        // --- PARTIE HAUTE (Les arches) ---
        if part == .top || part == .all {
            // Path 1 (Haut Droite)
            path.move(to: CGPoint(x: 184.5 * scaleX, y: 28 * scaleY))
            path.addLine(to: CGPoint(x: 196 * scaleX, y: 0 * scaleY))
            path.addCurve(to: CGPoint(x: 314.5 * scaleX, y: 159.5 * scaleY),
                          control1: CGPoint(x: 290 * scaleX, y: 20.4 * scaleY),
                          control2: CGPoint(x: 318.5 * scaleX, y: 120.5 * scaleY))
            path.addLine(to: CGPoint(x: 284.5 * scaleX, y: 159.5 * scaleY))
            path.addCurve(to: CGPoint(x: 184.5 * scaleX, y: 28 * scaleY),
                          control1: CGPoint(x: 279.7 * scaleX, y: 68.7 * scaleY),
                          control2: CGPoint(x: 215.833 * scaleX, y: 33.3333 * scaleY))
            
            // Path 3 (Haut Gauche)
            path.move(to: CGPoint(x: 128 * scaleX, y: 28 * scaleY))
            path.addLine(to: CGPoint(x: 120.5 * scaleX, y: 0 * scaleY))
            path.addCurve(to: CGPoint(x: 1.5 * scaleX, y: 158 * scaleY),
                          control1: CGPoint(x: 22.5 * scaleX, y: 22.8 * scaleY),
                          control2: CGPoint(x: -4 * scaleX, y: 114 * scaleY))
            path.addLine(to: CGPoint(x: 29 * scaleX, y: 158 * scaleY))
            path.addCurve(to: CGPoint(x: 128 * scaleX, y: 28 * scaleY),
                          control1: CGPoint(x: 30.5 * scaleX, y: 68.5 * scaleY),
                          control2: CGPoint(x: 93.5 * scaleX, y: 36.5 * scaleY))
        }

        // --- PARTIE BASSE (Les barres verticales) ---
        if part == .bottom || part == .all {
            // Path 2 (Bas Droite)
            path.move(to: CGPoint(x: 314 * scaleX, y: 213 * scaleY))
            path.addLine(to: CGPoint(x: 285 * scaleX, y: 213 * scaleY))
            path.addLine(to: CGPoint(x: 284.5 * scaleX, y: 428.5 * scaleY))
            path.addLine(to: CGPoint(x: 314 * scaleX, y: 432 * scaleY))
            path.closeSubpath()

            // Path 4 (Bas Gauche)
            path.move(to: CGPoint(x: 29 * scaleX, y: 213 * scaleY))
            path.addLine(to: CGPoint(x: 0 * scaleX, y: 213 * scaleY))
            path.addLine(to: CGPoint(x: 0 * scaleX, y: 431.5 * scaleY))
            path.addLine(to: CGPoint(x: 29 * scaleX, y: 427.5 * scaleY))
            path.closeSubpath()
        }
        
        return path
    }
}
