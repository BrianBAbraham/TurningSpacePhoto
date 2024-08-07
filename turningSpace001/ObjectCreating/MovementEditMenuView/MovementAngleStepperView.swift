//
//  AngleSetter.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI
import Combine
import SwiftUI


struct MovementAngleStepperView: View {

 @EnvironmentObject var vm: MovementAngleStepperViewModel

    var body: some View {
      Stepper("", value: vm.binding, step: 10.0)
                .colorScheme(.light)
    }
}






