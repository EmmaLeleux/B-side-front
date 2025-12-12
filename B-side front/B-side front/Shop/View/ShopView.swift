////
////  ShopView.swift
////  B-side front
////
////  Created by Chab on 11/12/2025.
////
//
//
//import SwiftUI
//

import SwiftUI

struct ShopView: View {
    
    @State private var vm = ShopViewModel()
    @State private var isPressed = false
    @Environment(LoginViewModel.self) var loginVM
    var body: some View {
        ZStack {
            Image(.woodyBG)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            if !vm.playlists.isEmpty {
                
                if let user = loginVM.currentUser{
                    VStack(spacing: 15) {
                        
                        // Porte monnaie user (Top)
                        HStack {
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Text("\(vm.isBuy ? user.money - vm.selectedPrice : user.money)")
                                    .bold()
                                    .foregroundColor(.white)
                                Image(.coins)
                            }
                                    .frame(width: 100, height: 60)
                                    .background(
                                        Capsule()
                                            .fill(Color.black.opacity(0.4))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    .padding(.top, 40)
                                    .padding(.trailing, 30)
                            }
                        
                        
                        
                        Spacer()
                        
                        
                        // Carousel Cover flow
                        CarouselView(items: vm.playlists, selectedIndex: $vm.selectedIndex)
                            .padding(.top, -20)
                        
                        
                        // Prix article
                        HStack(spacing: 6) {
                            Text("\(vm.selectedPrice)")
                                .bold()
                                .foregroundColor(.white)
                            Image(.coins)
                        }
                        .frame(width: 95, height: 50)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.4))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .padding(.top, -10)
                        
                        
                        // Description article (STABILISÉE)
                        VStack(spacing: 12) {
                            Text(vm.selectedPlaylist.name)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Text(vm.selectedPlaylist.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 6)
                        }
                        .padding()
                        .frame(width: 300, height: 160)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.4))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, -10)
                        
                        
                        // Boutton Acheter
                        Button {
                            withAnimation(.easeInOut(duration: 0.12)) {
                                isPressed = true
                            }
                            
                            vm.buySelectedItem()
                            loginVM.currentUser?.money -= vm.selectedPrice
                            vm.isBuy = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeInOut(duration: 0.12)) {
                                    isPressed = false
                                }
                            }
                        } label: {
                            ZStack {
                                Image(isPressed ? .pinkBuzzerOn : .pinkBuzzerOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300)
                                
                                
                                
                                Text("ACHETER")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                                    .offset(y: 70)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .task{
            vm.fetchPlaylist()
        }
    }
}


#Preview {
    ShopView().environment(LoginViewModel())
}

