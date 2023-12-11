//
//  LogOutButton.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 18/11/23.
//

import SwiftUI

struct LogOutButton: View {
    
    var body: some View {
        Text("Log Out")
        .frame(width: 80, height: 40)
        .foregroundColor(.white)
        .font(.system(.title3, weight: .medium))
    }
}

struct LogOutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogOutButton()
    }
}
