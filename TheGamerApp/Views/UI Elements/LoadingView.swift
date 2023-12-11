//
//  LoadingView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 15/11/23.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = UIColor(white: 1, alpha: 1)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
    
}

struct LoadingView: View {

    var body: some View {
        ZStack {
            Color("thirdBackgroundColor")
                .ignoresSafeArea()
            
            ActivityIndicator()
        }
    }
    
}

