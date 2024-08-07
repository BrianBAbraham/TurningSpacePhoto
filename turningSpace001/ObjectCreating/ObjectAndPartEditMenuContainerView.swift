//
//  ObjectAndPartEditMenuContainerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 19/07/2024.
//

import SwiftUI

struct ObjectAndPartEditMenuContainerView: View {
    var body: some View {
        ZStack{
            VStack (alignment: .leading) {
                
                HStack{
                    MovementPickerView()
                    
                    ObjectPickerView()
                    
                    PartPickerView()
                }
                
                PartOriginAndDimensionEditContainerView()
                
            }
        }
        .padding(.horizontal)
        .backgroundModifier()
        .transition(.move(edge: .bottom))
    }
}
