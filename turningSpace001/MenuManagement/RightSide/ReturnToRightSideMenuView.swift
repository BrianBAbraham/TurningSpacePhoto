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
                }) {
                    Spacer()
                    ZStack{
                        Color("Orange")
                            .frame(maxWidth: maxWidth,maxHeight: maxWidth, alignment: .trailing)
                            //.opacity(0.5)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 5, y: 5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(PlainButtonStyle())


                Spacer()
            }
        }
    }
}

