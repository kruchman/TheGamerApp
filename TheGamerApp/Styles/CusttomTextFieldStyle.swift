//
//  CusttomTextFieldStyle.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        return configuration
            .padding()
            .background(Color("textfield"))
            .cornerRadius(12)
            .frame(width: 300 , height: 50)
            .accentColor(.black)
            .foregroundColor(.black)
            .padding(.bottom, 10)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}
