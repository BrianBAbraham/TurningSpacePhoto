//
//  MovementEditMenuContainerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 27/06/2024.
//

import Foundation
import SwiftUI





struct MovementEditMenuContainerView: View {
    @EnvironmentObject var vm: MovementEditMenuContainerViewModel
    var body: some View {
        //Edit Menu
        VStack(spacing: 5 ){

            MovementPickerView()
            
            HStack {
                MovementAnglePickerView()
                   
                MovementAngleStepperView()
                Spacer()
            }
            .opacity(vm.isNotTurning ? 0.3: 1.0)
            .disabled(vm.isNotTurning)
            
            HStack{
                Spacer()
            
                Text("turn tightness")
                    .foregroundColor(vm.isNotTurning ? .gray: .primary)
                    .colorScheme(.light)
                
                MovementOriginStepperView()
                
                Spacer()
            }
            .disabled(vm.isNotTurning)
        }
        .backgroundModifier()
        .transition(.move(edge: .bottom))
    }
}


