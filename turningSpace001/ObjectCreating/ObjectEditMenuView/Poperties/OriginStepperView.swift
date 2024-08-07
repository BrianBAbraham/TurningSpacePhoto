//
//  OriginStepperView.swift
//  CreateObject
//
//  Created by Brian Abraham on 08/07/2024.
//

import SwiftUI


struct OriginStepperView: View {
    
    @EnvironmentObject var originStepperVM: OriginStepperViewModel
 
    var body: some View {
        if originStepperVM.editableOriginExist {
            Stepper("", value: originStepperVM.stepperValueBinding, step: 10.0)
                .colorScheme(.light)
                .fixedSize()
                .disabled(originStepperVM.disabled)
        } else  {
            EmptyView()
        }
    }
}
