//
//  PartPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI
struct PartPickerView: View {

    @EnvironmentObject var partPickerVM: PartPickerViewModel
  
    var body: some View {
        ZStack {
            Picker("", selection: partPickerVM.partBinding
            ) {
                ForEach(partPickerVM.oneOfAllEditablePartWithMenuNamesForObjectBeforeEdit, id: \.self) { item in
                    Text(item)
                }
            }

        }
    }
}

