//
//  LobbyView.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import SwiftUI

struct LobbyView: View {
    var body: some View {
        ZStack {
            
            Image("WoodyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20){
                Text("Lobby")
                    .foregroundStyle(.white)
                    .font(.system(size: 24))
                    .bold()
                
                
                VStack{
                    Text("Joueur 1")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                    Text("Joueur 1")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                    Text("Joueur 1")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                    Text("Joueur 1")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                }
                .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                
                
                Button {
                    
                } label: {
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 60, height: 60)
                        Circle()
                            .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [.green, .black]),
                                        center: .center,
                                        startRadius: 15,
                                        endRadius: 150
                                    )
                                
                            )
                            .frame(width: 52, height: 52)
                    }
                }

            }
        }
    }
}

#Preview {
    LobbyView()
}
