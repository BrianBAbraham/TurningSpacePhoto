//
//  MovementAnglePickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 20/07/2024.
//

import SwiftUI
import Combine

struct MovementAnglePickerView: View {

    @EnvironmentObject var vm: MovementAnglePickerViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Picker(
                    "",
                    selection: vm.binding
                ) {
                    ForEach(
                        vm.menuItems,
                        id: \.self
                    ) { item in
                        Text(
                            item
                        )
                    }
                }
                //Start work around: removes grey background from iPhone 13 mini
                //physical device
                .opacityAndScaleToHidePickerLabel()
                
                DuplicatePickerText(name: vm.objectAngleName)
            }
            //End work around

            Text("angle")
                .colorScheme(.light)
        }
    }
}



