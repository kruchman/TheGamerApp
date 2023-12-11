//
//  GradientBackgroundView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 4/11/23.
//

import SwiftUI

struct GradientBackgroundView: View {
    
    @State private var gradientColors: [Color] = [Color("firstBackgroundColor"),
                                                  Color("secondBackgroundColor"),
                                                  Color("thirdBackgroundColor")]
    @State private var start = UnitPoint(x: -0.5, y: 0.5)
    @State private var end = UnitPoint(x: 1.5, y: 1)
    @State var animateGradient = false
    
    var body: some View {
        LinearGradient(colors: gradientColors,
                       startPoint: start,
                       endPoint: end)
        .ignoresSafeArea()
        .hueRotation(.degrees(animateGradient ? 45 : 0))
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct GradientBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundView()
    }
}
