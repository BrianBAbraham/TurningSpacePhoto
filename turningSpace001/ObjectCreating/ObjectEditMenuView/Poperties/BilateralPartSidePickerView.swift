//
//  BilateralPartPicker.swift
//  CreateObject
//
//  Created by Brian Abraham on 11/03/2024.
//

import SwiftUI




struct BilateralPartSidePickerView: View {
    @EnvironmentObject var vm: BilateralPartSidePickerViewModel
   
    var body: some View {

        if vm.showMenu {
            Picker("", selection: vm.binding
            ) {
                ForEach(vm.scopeOfEditForSide.asArray(), id: \.self) { side in
                    Text(side.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.light)
            .fixedSize()
        } else {
            EmptyView()
        }

    }
}



