//
//  MenuChairView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/09/2022.


import Foundation
import SwiftUI


struct MenuForMovementEditView: View {
    @EnvironmentObject var vm: MenuForMovementEditViewModel
    var body: some View {
        if vm.showMenu {
            BottomMenuViewBuilder ( "arrow.clockwise", 300) {
                
               MovementEditMenuContainerView()
            }
        }
    }
}
