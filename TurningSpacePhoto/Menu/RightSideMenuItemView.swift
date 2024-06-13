//
//  RightSideMenuItemView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 13/06/2024.
//

import SwiftUI

struct RightSideMenuItemView: View {
    @EnvironmentObject var rightSideMenuItemVM: RightSideMenuItemViewModel
   
    let maxWidth = RightSideBackgroundWidth().width
    let name: String
    init (_ name: String) {
        self.name = name
    }
    var body: some View {
            Button( action: {
                rightSideMenuItemVM.setShowRightSideMenuFalse()
              
                if name == "folder.fill" {
                }
                if name == "photo" {
                    rightSideMenuItemVM.setShowPhotoMenuTrue()
                }
                if name == "arrow.clockwise" {
                }
                if name == MenuIcon.chairTool {
                    rightSideMenuItemVM.toggleShowChairMenuStatus()
                }
                
            })  {
                Image(systemName: self.name)
//                .font(.largeTitle)
           }
            .buttonStyle(TopNavigationBlueButton())
            //.buttonStyle(PlainButtonStyle())
    }
}
    
