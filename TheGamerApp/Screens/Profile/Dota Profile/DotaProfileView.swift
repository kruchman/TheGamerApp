//
//  DotaProfileView.swift
//  TheGamerApp
//
//  Created by Юрий Кручинин on 17/11/23.
//

import SwiftUI
import Firebase

struct DotaProfileView: View {
    
    @StateObject private var viewModel = DotaProfileViewModel()

    var body: some View {
        if viewModel.dataAreLoading {
            LoadingView()
        } else {
            if viewModel.userHasDotaProfile {
                DotaProfileExistingView()
            } else {
                DotaProfileSetUpFirstView()
            }
        }
    }
}

struct DotaProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DotaProfileView()
    }
}
