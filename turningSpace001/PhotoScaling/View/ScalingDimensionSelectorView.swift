//
//  PlanDimensionSelectorView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 30/05/2024.
//

import SwiftUI


struct ScalingDimensionSelectorView: View {
   
    var body: some View {
        VStack {
            
            HStack{
                ConfirmScaleButtonView()

                CurrentDimensionView()
            }

            PhotoDimensionSelectorView()
                .padding(EdgeInsets(top: -20, leading: 0, bottom: 50, trailing: 0))

            Spacer()
        }
    }
}




