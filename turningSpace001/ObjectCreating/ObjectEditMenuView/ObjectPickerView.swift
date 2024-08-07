//
//  ObjectPickerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI


struct ObjectPickerView: View {
    @EnvironmentObject var vm: ObjectPickerViewModel

    var body: some View {
        ZStack{
            Picker("Equipment",selection: vm.objectPickerBinding
            ) {
                ForEach(vm.allObjectsName, id:  \.self)
                { equipment in
                    Text(equipment)
                }
            }
        }
    }
}






//Start work around: removes grey background from iPhone 13 mini
//physical device
//            .opacityAndScaleToHidePickerLabel()
//            DuplicatePickerText(name: objectName)
//End work around






