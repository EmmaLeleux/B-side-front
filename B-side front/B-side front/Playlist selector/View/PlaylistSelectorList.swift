//
//  PlaylistSelectorList.swift
//  B-side front
//
//  Created by Lucie Grunenberger  on 11/12/2025.
//

import SwiftUI

struct PlaylistSelectorList: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @Environment(LoginViewModel.self) var loginVM
    var body: some View {
        
        ZStack{
            Image(.woodyBG)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Mes playlists")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.white))
                    .padding(.top, 60)
                
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(loginVM.currentUser?.playlists ?? []){ playlist in
                            
                            Button(action: {}, label:{
                                AsyncImage(url: URL(string: playlist.picture)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 135)
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                }.padding(.top, 80)
                                
                                
                            })
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PlaylistSelectorList().environment(LoginViewModel())
}
