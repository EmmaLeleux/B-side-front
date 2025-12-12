//
//  LobbyView.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import SwiftUI

struct LobbyView: View {
    @Environment(GameViewModel.self) var gameVM
    @State var isLoading : Bool = false
    
    var body: some View {
        ZStack {
            
            Image("WoodyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ZStack {
                
                VStack(spacing: 20){
                    Text("Lobby")
                        .foregroundStyle(.white)
                        .font(.system(size: 24))
                        .bold()
                    
                    
                    VStack{
                        ForEach(gameVM.players, id: \.id){ player in
                            Text(player.name)
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
                        
                        if gameVM.role == .host {
                            Button {
                                isLoading = true
                                gameVM.preloadMusic {
                                    isLoading = false
                                    gameVM.startGame()
                                }
                            } label: {
                                VStack {
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
                                    
                                    Text("Lancer")
                                        .foregroundStyle(.white)
                                }
                            }
                            
                        } else {
                            Text("En attente de l'hôte...")
                                .foregroundColor(.white)
                        }
                        
                        
                        Button("Quitter") {
                            gameVM.cleanMusic()
                            gameVM.leaveLobby()
                        }
                        .foregroundStyle(.red)
                        .padding()
                        
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: Binding(
                    get: { gameVM.gameStarted },
                    set: { gameVM.gameStarted = $0 }
                )) {
                    BuzzerView()
                        .environment(gameVM)
                }
                
                if isLoading {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView("Téléchargement des musiques…")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            
        }
    }
    
}

#Preview {
    LobbyView()
        .environment(GameViewModel())
}
