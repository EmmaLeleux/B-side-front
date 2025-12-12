//
//  RoomView.swift
//  B-side front
//
//  Created by Mounir Emahoten on 12/12/2025.
//

import SwiftUI

struct RoomView: View {
    @Environment(GameViewModel.self) var gameVM

    var body: some View {
        NavigationStack {
            ZStack {
                Image("WoodyBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 30) {
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        
                        TextField("Saisir pseudo",text: Binding(
                            get: { gameVM.username},
                            set: { gameVM.username = $0 }
                        ))
                            .foregroundStyle(Color.black)
                            .padding(.leading, 120)
                    }
                    
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button {
                        gameVM.chooseHost()
                    } label: {
                        HStack(spacing: -20){
                            Image("YellowBuzzerOff")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 175)
                            
                            Text("Crée une partie")
                                .font(.system(size: 30))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(width: 350, height: 150)
                        .glassCard()
                    }
                    
                    
                    
                    Button {
                        gameVM.chooseClient()
                    } label: {
                        HStack(spacing: -20){
                            ZStack {
                                Image("BlueBuzzerOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                    .offset(x: -10, y: -20)
                                
                                Image("GreenBuzzerOff")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                    .offset(x: 20, y: 20)
                                
                            }
                            .padding()
                            
                            Text("Rejoindre une partie")
                                .font(.system(size: 30))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(width: 350, height: 150)
                        .glassCard()
                        
                    }
                    
                }
                .navigationDestination(isPresented: Binding(
                    get: { gameVM.showLobby },
                    set: { gameVM.showLobby = $0 }
                )) {
                    LobbyView()
                        .environment(gameVM)
                }
            }
        }
    }
}

#Preview {
    RoomView()
        .environment(GameViewModel())
}
