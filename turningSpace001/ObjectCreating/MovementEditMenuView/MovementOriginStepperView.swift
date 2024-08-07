//
//  MovementOriginSetterView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI
import Combine
//
struct MovementOriginStepperView: View {
    @EnvironmentObject var vm: MovementOriginStepperViewModel

    var body: some View {
            Stepper("", value: vm.binding, step: 10.0)
                .colorScheme(.light)
    }
}


