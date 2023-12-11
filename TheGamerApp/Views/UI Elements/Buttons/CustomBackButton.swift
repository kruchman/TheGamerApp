//
//  CustomBackButton.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 4/12/23.
//

import SwiftUI

struct CustomBackButton: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.backward.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            
            Text("Back")
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}
