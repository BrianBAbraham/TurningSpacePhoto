//
//  CurrentDimensionView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 22/06/2024.
//

import SwiftUI

struct CurrentDimensionView: View {
   
    @EnvironmentObject var currentDimensionVM: CurrentDimensionViewModel
   let test = 1
    
    var dimensionOnPlan: Int {
        Int(currentDimensionVM.dimensionOnPlan)
    }
    var body: some View {
        Text("\(dimensionOnPlan) mm (between triangle tips)")
            .modifier(MenuButtonTextFont())
            .opacity(currentDimensionVM.notShowing ? 0.1 : 1)
    }
}


