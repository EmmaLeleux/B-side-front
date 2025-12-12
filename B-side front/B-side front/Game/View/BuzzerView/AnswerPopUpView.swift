//
//  AnswerPopUpView.swift
//  B-side front
//
//  Created by Mounir Emahoten on 11/12/2025.
//

import SwiftUI

struct AnswerPopupView: View {
    @Binding var songAnswer: String
    @Binding var artistAnswer: String
    var gameVM: GameViewModel
    var playerID: String
    var onContinue: () -> Void
    
    @State private var answerValidated = false
    @State private var isCorrect = false
    @State private var pointsGained = 0
    
    private var backgroundColor: Color {
        if !answerValidated {
            return Color(hex: "#C21D67")
        } else {
            return isCorrect ? .green : .red
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            ZStack {
                Image("Vinyl")
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 15) {
                    if !answerValidated {
                        TextField("Devine la musique", text: $songAnswer)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 160)
                        
                        TextField("Devine l'artiste", text: $artistAnswer)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 160)
                        
                        Button("Valider") {
                            print("Son : \(songAnswer)")
                            print("Artiste : \(artistAnswer)")
                            let result = gameVM.validateAnswer(
                                playerID: playerID,
                                song: songAnswer,
                                artist: artistAnswer
                            )
                            isCorrect = result.correct
                            pointsGained = result.points
                            answerValidated = true
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        
                    } else {
                        
                        if isCorrect {
                            VStack {
                                Text("+\(pointsGained)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Musique : \(gameVM.song)")
                                    .foregroundColor(.white)
                                Text("Artiste : \(gameVM.artist)")
                                    .foregroundColor(.white)
                                Text("Points gagnés : \(pointsGained)")
                                    .foregroundColor(.white)
                            }
                        } else {
                            VStack{
                                Text("FAUX")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding(25)
                        }
                        
                        Button("Continuer") {
                            resetPopup()
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    }
                }
                .padding(50)
                .background(
                    Circle().foregroundColor(backgroundColor)
                )
            }
        }
        .transition(.scale)
        .animation(.spring(), value: answerValidated)
    }
    
    private func resetPopup() {
        songAnswer = ""
        artistAnswer = ""
        answerValidated = false
        isCorrect = false
        pointsGained = 0
        onContinue()
    }
}



