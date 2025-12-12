//
//  LoginView.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(LoginViewModel.self) var loginVM
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isPasswordShown: Bool = false
    @State var isConnectButtonPressed: Bool = false
    @State var isPasswordButtonPressed: Bool = false
    @State var isCreateButtonPressed: Bool = false
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.wallBG)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: 500)
                
                VStack{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 284, height: 62)
                            .foregroundColor(.white)
                        
                        TextField("Nom d'utilisateur", text: $username)
                            .foregroundStyle(Color.black)
                            .padding(.leading, 110)
                    }.padding(20)
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
                    
                    VStack{
                        Button(action: {
                            Task{
                                await loginVM.login(username: username, password: password)
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
                    HStack {
                        VStack{
                            Button(action: {
                                
                            }, label:{
                                VStack{
                                    Image(isPasswordButtonPressed ? .redBuzzerOn : .redBuzzerOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                            isPasswordButtonPressed = pressing
                                        }, perform: {
                                            print("Bouton cliqué!")
                                        })
                                    
                                }.padding(.top, 20)
                            })
                            Text("MOT DE PASSE OUBLIÉ")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.white)
                                .padding(.top, -20)
                            
                        }
                        VStack{
                            
                            NavigationLink{
                                CreateAccountView().environment(loginVM)
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
                            
                            Text("CRÉER UN COMPTE")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.white)
                                .padding(.top, -20)
                            
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    LoginView().environment(LoginViewModel())
}
