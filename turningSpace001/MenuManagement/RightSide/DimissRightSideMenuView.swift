//
//  DimissRightSideMenuView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 22/06/2024.
//

import SwiftUI



struct DismissRightSideMenuView: View {
    @EnvironmentObject var dismissRightSideMenuVM: DismissRightSideMenuViewModel
    var body: some View {
        Button(action: {
            dismissRightSideMenuVM.setShowRightSideMenuFalse()
        }, label: {
            ActionDismissStyle(color: .blue)
            }
        )
        .buttonStyle(TopNavigationBlueButton())
    }
}




struct RightSideBackgroundWidth {
    let width = 58.0
}

