//
//  ObjectPickerOptionsView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/05/2023.
//

import SwiftUI


struct PropertyAngleEditView: View {
    @EnvironmentObject var vm: PropertyAngleEditViewModel
    var body: some View {
        ZStack{
            HStack{
                Text("angle")
                    .colorScheme(.light)

                Slider(value: vm.sliderValueBinding, in: vm.min...vm.max, step: 1.0)

                Text(" deg: \( Int(vm.max - vm.sliderValueBinding.wrappedValue))")
                    .colorScheme(.light)
            }
        }
        .opacity(vm.showMenu ? 1 : 0)
    }
}
