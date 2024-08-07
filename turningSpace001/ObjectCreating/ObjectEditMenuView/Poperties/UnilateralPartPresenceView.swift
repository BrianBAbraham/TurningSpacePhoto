//
//  UnilateralPartPresenceView.swift
//  CreateObject
//
//  Created by Brian Abraham on 19/07/2024.
//

import SwiftUI

struct  UnilateralPartPresenceView: View {
    @EnvironmentObject var  unilateralPartPresenceViewModel: UnilateralPartPresenceViewModel
    
    var body: some View {
        if unilateralPartPresenceViewModel.showMenu {
            Toggle("", isOn:  unilateralPartPresenceViewModel.partBinding)
        } else {
            EmptyView()
        }
    }
    
}
