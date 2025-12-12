//
//  ContentView.swift
//  B-side front
//
//  Created by Emma on 10/12/2025.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
  @State var loginVM = LoginViewModel()
    var body: some View {
        VStack{
            if loginVM.isAuthenticated{
                LandingView()
                
                Button(action: {
                    loginVM.logout()
                }, label: {
                    Text("déconnexion")
                })
            }
            else{
                LoginView()
            }
        }
        .environment(loginVM)
    }
}

#Preview {
    ContentView()
}
