//
//  CustomTextField.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 3/11/23.
//

import SwiftUI

struct CustomTextField: View {
    
    private var title: String
    private var text: Binding<String>
    private var prompt: String?
    private var isSecure: Bool
    
    init(title: String, text: Binding<String>, prompt: String? = nil, isSecure: Bool = false) {
        self.title = title
        self.text = text
        self.prompt = prompt
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack {
            if isSecure {
                SecureField(title, text: text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .tint(.black)
                    .cornerRadius(12)
            } else {
                TextField(title, text: text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .tint(.black)
                    .cornerRadius(12)
                    
            }
            if let prompt = prompt {
                Text(prompt)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
        }
    }
}


struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Title", text: .constant("Something"))
    }
}
