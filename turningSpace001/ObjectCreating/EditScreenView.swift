//
//  EditScreenViewFile.swift
//  CreateObject
//
//  Created by Brian Abraham on 30/07/2024.
//

import Foundation
import SwiftUI
struct EditScreenView<EditableView:View>: View {
 
    @EnvironmentObject var vm: EditScreenViewModel
    @State private var uniqueKey = 0
    
    var injectedView: EditableView
    var objectDisplayStyle: ObjectDisplayStyle
    var body: some View {
        
        VStack {
            VStack{
                ObjectRulerRepositionView()
                
                ObjectAndRulerView(
                    objectDisplayStyle
                )
                .position(RecenterObjectsOnScreenService.initialRulerPosition)
                .onChange(of: vm.recenter) {
                    uniqueKey += 1
                }
                .id(uniqueKey)//ensures redraw
            }
            
           injectedView
        }
    }
}
