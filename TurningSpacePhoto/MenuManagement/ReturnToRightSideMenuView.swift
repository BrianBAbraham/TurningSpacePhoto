//
//  ReturnToRightSideMenuView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 12/06/2024.
//

import SwiftUI

//Chevron >
struct ReturnToRightSideMenuView: View {
    @EnvironmentObject var returnToRightSideMenuVM: ReturnToRightSideMenuViewModel

    let maxWidth = RightSideBackgroundWidth().width
    var body: some View {
        ZStack {
            VStack {
                Button( action: {
                   
                    returnToRightSideMenuVM.retunToRightSideMenu()
                    
                    print("ALERT")

                }) {
                    Spacer()
                    ZStack{
                        Color(UIColor(named:"MiddleMenu")!)
                            .frame(maxWidth: maxWidth,maxHeight: maxWidth, alignment: .trailing)
                            .opacity(0.5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }
//                .buttonStyle(DefaultButtonStyle())
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
        }
    }
}

