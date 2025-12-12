//
//  ProfilView.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import SwiftUI

struct ProfilView: View {
    
    @State var isUpdateProfilButtonPressed: Bool = false
    @State var isDeconnectedButtonPressed: Bool = false
    @State var isDeleteButtonPressed: Bool = false
    
    @Environment(LoginViewModel.self) var loginVM
    
    var body: some View {
        ZStack{
            
            Image(.woodyBG)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                ZStack(alignment: .center){
                    Image(.vinylTV)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: 126, height: 126)
                        .clipped()
                    
                    
                    AsyncImage(url: URL(string: loginVM.currentUser?.picture ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 126, height: 126)
                            .cornerRadius(100)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }.padding(.top, 60)
                Spacer()
                
                HStack{
                    ForEach(loginVM.currentUser?.badges ?? []){ badge in
                        
                        AsyncImage(url: URL(string: badge.picture)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .cornerRadius(100)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }.padding(.leading, -30)
                        
                    }
                    
                    Spacer()
                    
                }.padding(.leading, 70)
                
                VStack{
                    Button(action: {
                    }, label:{
                        VStack{
                            Image(isUpdateProfilButtonPressed ? .purpleBuzzerOn : .purpleBuzzerOff)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                                .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                    isUpdateProfilButtonPressed = pressing
                                }, perform: {
                                    print("Bouton cliqué!")
                                })
                            
                        }.padding(.top, 20)
                    })
                    Text("MODIFIER MON PROFL")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                        .padding(.top, -20)
                    
                }
                
                HStack{
                    
                    VStack{
                        Button(action: {
                            
                            loginVM.logout()
                            
                        }, label:{
                            VStack{
                                Image(isDeconnectedButtonPressed ? .pinkBuzzerOn : .pinkBuzzerOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                        isDeconnectedButtonPressed = pressing
                                    }, perform: {
                                        print("Bouton cliqué!")
                                    })
                                
                            }.padding(.top, 20)
                        })
                        Text("ME DÉCONNECTER")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.white)
                            .padding(.top, -20)
                        
                    }
                    VStack{
                        Button(action: {
                        }, label:{
                            VStack{
                                Image(isDeleteButtonPressed ? .redBuzzerOn : .redBuzzerOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                        isDeleteButtonPressed = pressing
                                    }, perform: {
                                        print("Bouton cliqué!")
                                    })
                                
                            }.padding(.top, 20)
                        })
                        Text("SUPPRIMER MON COMPTE")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.white)
                            .padding(.top, -20)
                        
                    }

                    
                }.padding(.bottom, 100)
                Spacer()

                
                
            }
        }.environment(loginVM)
        
    }
}

#Preview {
    ProfilView().environment(LoginViewModel())
}
