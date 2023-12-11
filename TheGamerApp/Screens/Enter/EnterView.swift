//
//  ContentView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/11/23.
//

import SwiftUI
import Firebase

struct EnterView: View {
    
    @StateObject private var viewModel = EnterViewModel()
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            
            VStack {
                
                Spacer()
                
                Image("PSImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                
                
                
                VStack {
                    CustomTextField(title: "Email",
                                    text: $viewModel.email,
                                    prompt: viewModel.loginPrompt)
                    
                    CustomTextField(title: "Password",
                                    text: $viewModel.password,
                                    prompt: viewModel.passwordPrompt,
                                    isSecure: true)
                }
                
                Spacer()
                
                VStack(spacing: 20) {

                    Button {
                        viewModel.logIn()
                    } label: {
                        CustomButton(buttonTitle: "Log In")
                    }
                    
                    Button {
                        viewModel.signUp()
                    } label : {
                        CustomButton(buttonTitle: "Sign Up")
                    }
                    
                    .alert(viewModel.errorMessage, isPresented: $viewModel.alertIsShown) {
                        
                    }
                    
                    .navigationDestination(isPresented: $viewModel.isUserLoggedIn) {
                        GameSelectionView()
                    }
                    .navigationBarBackButtonHidden()  
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
