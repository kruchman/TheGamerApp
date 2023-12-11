//
//  CustomButton.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import SwiftUI

struct CustomButton: View {
    
    let buttonTitle: String
    
    var body: some View {
        Text(buttonTitle)
        .frame(width: 200, height: 60)
        .background(Color("GuestButtonColor"))
        .cornerRadius(40)
        .foregroundColor(.white)
        .font(.system(.title3, weight: .medium))
        .shadow(radius: 7)
        
    }
}





struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(buttonTitle: "Tap Me")
    }
}
