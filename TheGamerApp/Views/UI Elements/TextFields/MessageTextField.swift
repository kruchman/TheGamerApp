//
//  MessageTextField.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 1/12/23.
//

import SwiftUI

struct MessageTextField: View {
    
    @EnvironmentObject var viewModel: ChatsViewModel
    @State private var message = ""
    
    var body: some View {
        HStack {
            SecondCustomTextField(placeholder: Text("Enter your message here"), text: $message)
            
            Button {
                viewModel.sendMessage(text: message, myNickname: viewModel.userProfile?.nickName ?? "")
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("paperplane"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
    }
}

struct SecondCustomTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .tint(.black)
        }
    }
    
}

struct MessageTextField_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextField()
            .environmentObject(ChatsViewModel())
    }
}
