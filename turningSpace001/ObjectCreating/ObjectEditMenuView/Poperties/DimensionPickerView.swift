//
//  DimensionPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 02/07/2024.
//

import SwiftUI

struct DimensionPickerView: View {
    @EnvironmentObject var dimensionPickerVM: DimensionPickerViewModel

    var body: some View {
        Picker(
            "dimension",
            selection: dimensionPickerVM.dimensionPropertyBinding
        ) {
            ForEach(
                dimensionPickerVM.editableDimension,
                id: \.self
            ) { side in
                Text(
                    side.rawValue
                )
            }
        }
        .pickerStyle(
            .segmented
        )
        .colorScheme(
            .light
        )
        .disabled(
            dimensionPickerVM.disabled
        )
    }
}



