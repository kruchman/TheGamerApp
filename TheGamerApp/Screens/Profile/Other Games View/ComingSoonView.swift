//
//  ComingSoonView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 11/11/23.
//

import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        ZStack {
            GradientBackgroundView()
            Text("Coming Soon")
                .font(.title)
        }
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
    }
}
