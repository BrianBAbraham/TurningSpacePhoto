//
//  PickerLabelWorkAround.swift
//  CreateObject
//
//  Created by Brian Abraham on 13/05/2024.
//

import SwiftUI

struct DuplicatePickerText: View {
    let name: String
    var body: some View {
        Text(name)
            .allowsHitTesting(false)
            .foregroundColor(Color.blue)    }
}


extension View {
    func opacityAndScaleToHidePickerLabel() -> some View {
        self.modifier(OpacityAndScaleModifierForPicker(opacity: 0.015, scale: 0.8))
    }
}
