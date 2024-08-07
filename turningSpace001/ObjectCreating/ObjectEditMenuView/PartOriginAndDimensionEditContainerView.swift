//
//  PartOriginAndDimensionEditView.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/03/2024.
//

import SwiftUI


struct PartOriginAndDimensionEditContainerView: View {

    var body: some View {
        
        HStack{
            BilateralPartSidePickerView()
            
            BilateralPartSidePresenceView()
            
            UnilateralPartPresenceView()
        }
   
            VStack {
                HStack {
                    DimensionPickerView()

                    DimensionStepperView()
                }
                
                HStack {
                    OriginPickerView()
                    OriginStepperView()
                }
                
            }
        
        PropertyAngleEditView()
    }
}












