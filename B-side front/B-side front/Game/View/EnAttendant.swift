////
////  EnAttendant.swift
////  B-side front
////
////  Created by Mounir Emahoten on 11/12/2025.
////
//
//import SwiftUI
//
//struct EnAttendant: View {
//    @Binding var gameVM: GameViewModel
//
//    var body: some View {
//        NavigationStack {
//            VStack{
//                
//                TextField("Username BG", text: $gameVM.username)
//                    .textFieldStyle(.roundedBorder)
//                    .frame(width: 300)
//                
//                HStack(spacing: 50){
//                    
//                    Button {
//                        gameVM.chooseHost()
//                    } label: {
//                        Text("Create")
//                            .foregroundStyle(.white)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundStyle(.green)
//                                    .frame(width: 100, height: 50)
//                            )
//                    }
//                    
//                    Button {
//                        gameVM.chooseClient()
//                    } label: {
//                        Text("Join")
//                            .foregroundStyle(.white)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundStyle(.green)
//                                    .frame(width: 100, height: 50)
//                            )
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $gameVM.showLobby) {
//                LobbyView()
//            }
//           
//
//        
//        }
//    }
//}
//
//#Preview {
//    EnAttendant(gameVM: .constant(GameViewModel()))
//}
