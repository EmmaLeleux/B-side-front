//
//  CreateAccountView.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(LoginViewModel.self) var loginVM
    @State var username: String = ""
    @State var password: String = ""
    @State var cPassword: String = ""
    @State var picture: String = ""
    @State var isPasswordShown: Bool = false
    @State var isCPasswordShown: Bool = false
    @State var isConnectButtonPressed: Bool = false
    @State var isCreateButtonPressed: Bool = false
    @State var isPasswordButtonPressed: Bool = false
    @State var showPopUp: Bool = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                Image(.wallBG)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
                    .frame(width: 500)
                
                VStack{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        
                        TextField("Nom d'utilisateur", text: $username)
                            .foregroundStyle(Color.black)
                            .padding(.leading, 120)
                    }
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        Button(action:{
                            showPopUp = true
                        }, label:{
                            HStack(alignment: .center){
                                Text("Photo de profil")
                                    .foregroundStyle(Color.gray.opacity(0.6))
                                    .padding(.leading, 20)
                                Spacer()
                                Text("+")
                                    .foregroundStyle(Color.gray.opacity(0.6))
                                    .font(.system(size: 40))
                                    .padding(.trailing, 20)

                            }.frame(width: 284)
                        }).popover(isPresented: $showPopUp) {
                            ZStack{
                                Color.black
                                    .ignoresSafeArea()
                                
                                VStack{
                                    Button(action:{
                                        picture = "https://i.ibb.co/ynQPnrRF/e1945156ce0d31056a0cc23ffa81c79b.jpg"
                                        showPopUp = false
                                     }, label : {
                                        AsyncImage(url: URL(string : "i.ibb.co/ynQPnrRF/e1945156ce0d31056a0cc23ffa81c79b.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(20)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                        }.padding(.top, 80)
                                        

                                    })
                                    Button(action:{
                                        picture = "https://i.ibb.co/bMpF0cs5/b8570c9c0e4444a9a48371f7b23a5356.jpg"
                                        showPopUp = false

                                    }, label : {
                                        AsyncImage(url: URL(string : "https://i.ibb.co/bMpF0cs5/b8570c9c0e4444a9a48371f7b23a5356.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(20)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                        }.padding(.top, 80)
                                        

                                    })
                                    Button(action:{
                                        picture = "https://i.ibb.co/PZpVPh53/aaa4313c3e26b944c227c3081583d1a6.jpg"
                                        showPopUp = false

                                    }, label : {
                                        AsyncImage(url: URL(string : "https://i.ibb.co/PZpVPh53/aaa4313c3e26b944c227c3081583d1a6.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(20)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                        }.padding(.top, 80)
                                        

                                    })
                                    Button(action:{
                                        picture = "https://i.ibb.co/HLNt14Xd/c981069c3ee84be932bfd8ff76c5cd27.jpg"
                                        showPopUp = false
                                        
                                    }, label : {
                                        AsyncImage(url: URL(string : "https://i.ibb.co/HLNt14Xd/c981069c3ee84be932bfd8ff76c5cd27.jpg")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(20)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                        }.padding(.top, 80)
                                        

                                    })
                                }
                            }

                        }

                    }.padding(20)
                    
                    if picture != ""{
                        
                        
                        AsyncImage(url: URL(string : picture)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(20)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }.padding(.bottom, 10)
                        
                    }

                    
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        
                        HStack{
                            if !isPasswordShown{
                                SecureField("Mot de passe", text: $password)
                                    .foregroundStyle(Color.black)
                                    .padding(.leading, 130)
                                    .id("passwordField")
                            } else {
                                TextField("Mot de passe", text: $password)
                                    .foregroundStyle(Color.black)
                                    .padding(.leading, 130)
                                    .id("passwordField")
                            }
                            
                            Button(action:{
                                isPasswordShown.toggle()
                            }, label: {
                                Image(systemName: isPasswordShown ? "eye.slash" : "eye")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 20)
                                    .foregroundStyle(Color.gray)
                                    .padding(.trailing, 120)
                            })
                        }
                        
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        
                        HStack{
                            if !isCPasswordShown{
                                SecureField("Confirmer le mot de passe", text: $cPassword)
                                    .foregroundStyle(Color.black)
                                    .padding(.leading, 130)
                                    .id("passwordField")
                            } else {
                                TextField("Mot de passe", text: $cPassword)
                                    .foregroundStyle(Color.black)
                                    .padding(.leading, 130)
                                    .id("passwordField")
                            }
                            
                            Button(action:{
                                isCPasswordShown.toggle()
                            }, label: {
                                Image(systemName: isCPasswordShown ? "eye.slash" : "eye")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 20)
                                    .foregroundStyle(Color.gray)
                                    .padding(.trailing, 120)
                            })
                        }
                        
                    }.padding(.top, 20)
                    
                    HStack {
                        VStack{
                            Button(action: {
                                Task{
                                    try await loginVM.createUser(username: username, password: password, picture: picture)
                                }
                                
                            }, label:{
                                VStack{
                                    Image(isConnectButtonPressed ? .greenBuzzerOn : .greenBuzzerOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                            isConnectButtonPressed = pressing
                                        }, perform: {
                                            print("Bouton cliqué!")
                                        })
                                    
                                }.padding(.top, 20)
                            })
                            Text("SE CONNECTER")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.white)
                                .padding(.top, -20)
                            
                        }
                        VStack{
                            
                            NavigationLink{
                                LoginView().environment(loginVM)
                            } label :{
                                Image(isCreateButtonPressed ? .pinkBuzzerOn : .pinkBuzzerOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                        isCreateButtonPressed = pressing
                                    }, perform: {
                                    }
                                    )
                                
                            }.padding(.top, 20)
                            
                            Text("J'AI DÉJÀ UN COMPTE")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.white)
                                .padding(.top, -20)
                            
                        }
                    }
                }
            }
            
        }.navigationBarBackButtonHidden()
        
    }
}

#Preview {
    CreateAccountView().environment(LoginViewModel())
}
