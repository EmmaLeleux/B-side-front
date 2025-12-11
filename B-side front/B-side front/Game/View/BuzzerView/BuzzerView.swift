//
//  BuzzerView.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import SwiftUI
import MultipeerConnectivity

struct BuzzerView: View {
    @Binding var gameVM : GameViewModel
    @State private var showAnswerPopup = false
    
    var body: some View {
        ZStack {
            Image("WoodyBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Buzzers des autres joueurs
                HStack(spacing: 20) {
                    ForEach(gameVM.players.filter { $0.id != gameVM.multipeerService?.peerID.displayName }) { player in
                        VStack {
                            Text(player.name)
                                .foregroundColor(.white)
                                .padding()
                                .background(player.isDisabled ? Color.gray : Color(hex: player.colorHex))
                                .cornerRadius(10)
                            
                            Text("\(player.points)")
                                .foregroundStyle(player.isDisabled ? Color.gray : Color(hex: player.colorHex))
                            
                            ZStack {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 60, height: 60)
                                Circle()
                                    .fill(
                                        player.isDisabled
                                        ? AnyShapeStyle(Color.gray)
                                        : AnyShapeStyle(
                                            RadialGradient(
                                                gradient: Gradient(colors: [Color(hex: player.colorHex), .black]),
                                                center: .center,
                                                startRadius: 15,
                                                endRadius: 150
                                            )
                                        )
                                    )
                                    .frame(width: 52, height: 52)
                            }
                        }
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Play/Pause
                Button {
                    gameVM.musicOn.toggle()
                } label: {
                    ZStack {
                        Image("Vinyl")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        
                        Circle()
                            .frame(width: 75)
                            .foregroundStyle(Color(hex: "#C21D67"))
                        
                        Image(systemName: gameVM.musicOn ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                }
                
                Spacer()
                
                // Mon propre buzzer
                if let me = gameVM.players.first(where: { $0.id == gameVM.multipeerService?.peerID.displayName }) {
                    Button {
                        gameVM.buzz(playerID: me.id)
                        // Affiche le popup pour répondre
                        showAnswerPopup = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 130, height: 130)
                            Circle()
                                .fill(
                                    me.isDisabled
                                    ? AnyShapeStyle(Color.gray)
                                    : AnyShapeStyle(
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color(hex: me.colorHex), .black]),
                                            center: .center,
                                            startRadius: 15,
                                            endRadius: 150
                                        )
                                    )
                                )
                                .frame(width: 120, height: 120)
                        }
                    }
                    
                    
                    Text("Score : \(me.points)")
                        .foregroundStyle(me.isDisabled ? Color.gray : Color(hex: me.colorHex))
                        .font(.system(size: 30))
                        .padding(.bottom, 50)
                }
            }
            .padding()
            
            
            if showAnswerPopup,
               let me = gameVM.players.first(where: { $0.id == gameVM.multipeerService?.peerID.displayName }) {
                
                AnswerPopupView(
                    songAnswer: $gameVM.currentAnswerSong,
                    artistAnswer: $gameVM.currentAnswerArtist,
                    gameVM: gameVM,
                    playerID: me.id
                ) {
                    showAnswerPopup = false
                    //next song plus tard
                }
            }

        }
        .animation(.spring(), value: showAnswerPopup)
    }
}



#Preview {
    let mockVM = GameViewModel()
    
    // Ajout de joueurs mock
    mockVM.players = [
        Player(id: "1", name: "Alice", hasBuzzed: false, points: 0, colorHex: "#006AF6"),
        Player(id: "2", name: "Bob", hasBuzzed: false, points: 0, colorHex: "#F60000"),
        Player(id: "3", name: "Charlie", hasBuzzed: false, points: 0, colorHex: "#F6F600")
    ]
    
    // Simuler que je suis Alice
    mockVM.multipeerService = MultipeerService(displayName: "1")
    
    return BuzzerView(gameVM: .constant(mockVM))
}

