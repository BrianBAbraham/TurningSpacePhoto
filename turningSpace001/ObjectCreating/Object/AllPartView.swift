//
//  AllPartView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

//import Foundation
import SwiftUI


struct AllPartView: View {
    @EnvironmentObject var vm: AllPartViewModel
    let displayStyle: ObjectDisplayStyle
    
    var body: some View {
        ForEach(vm.partModels) { partModel in
            let partVM = PartViewModel(
                corners: partModel.points,
                color: partModel.color,//getColor(partModel.id),
                opacity: partModel.opacity,
                lineWidth: partModel.lineWidth,
                cornerRadius: partModel.cornerRadius,
                displayStyle: displayStyle
            )
            
            PartView(vm: partVM)
                .zIndex(partModel.screenDepth)
        }
    }
}
