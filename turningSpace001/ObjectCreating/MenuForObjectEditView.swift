//
//  MenuForObjectEditView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 13/08/2024.
//

import Foundation
import SwiftUI

struct MenuForObjectEditView: View {
    @EnvironmentObject var vm: MenuForObjectEditViewModel
    var body: some View {
        if vm.showMenu {
            BottomMenuViewBuilder ("figure.roll", 300) {
                
                ObjectAndPartEditMenuContainerView()
            }
        }
    }
}
