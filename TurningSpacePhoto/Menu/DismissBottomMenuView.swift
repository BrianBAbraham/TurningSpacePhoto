//
//  BottomMenuDismissView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 13/06/2024.
//

import SwiftUI

//what happens when the bottom menu is diismissed
///logiic required to prevent use of photo which is not scaled
struct DismissBottomMenuView: View {

    @EnvironmentObject var dismissBottomMenuVM: DismissBottomMenuViewModel
      
    var menuName: String
    
    var body: some View {
        let unscaledImageSoPreventDismiss =
        dismissBottomMenuVM.preventPhotoMenuDismiss && menuName == "photo"

        Button(action: {
                
                if menuName == "openFile" {
                   
                }
                if menuName == "photo" {
                
                    dismissBottomMenuVM.setShowPhotoMenuFalse()
                }
                if menuName == "arrow.clockwise" {
                   
                }
                if menuName == MenuIcon.chairTool {
                    dismissBottomMenuVM.setShowChairMenuFalse()
                }
                
                
          //  }
           

        }, label: {
            if unscaledImageSoPreventDismiss {
                ActionNpDismissForUnscaledImageStyle()
            } else {
                ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray : .blue)
            }
        })
    }
}

