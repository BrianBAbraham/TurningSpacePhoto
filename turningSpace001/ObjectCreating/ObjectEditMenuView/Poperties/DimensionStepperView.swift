//
//  DimensionStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI



struct DimensionStepperView: View {
    
    @EnvironmentObject var dimensionStepperVM: DimensionStepperViewModel
 
    var body: some View {
        Stepper("", value: dimensionStepperVM.stepperValueBinding, step: 10.0)
                .colorScheme(.light)
                .fixedSize()
                .disabled(dimensionStepperVM.disabled)
    }
}

