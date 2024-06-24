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
                .padding(.top, 2)
                .padding(.leading, 5)
            }
        )
        .buttonStyle(DefaultButtonStyle())
        .offset(y: 5)
//        .buttonStyle(PlainButtonStyle())
    }
}

struct RightSideBackgroundWidth {
    let width = 58.0
}

