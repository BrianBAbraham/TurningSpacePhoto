//
//  BottomMenuDismissView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 13/06/2024.
//

import SwiftUI


struct DismissBottomMenuView: View {

    @EnvironmentObject var dismissBottomMenuVM: DismissBottomMenuViewModel
      
    var menuName: String
    
    var body: some View {


        Button(action: {
            dismissBottomMenuVM.setMenu(menuName)
           
        }
               , label:{
                ActionDismissStyle(color: .blue)

        }
        )
    }
}

