//
//  PhotoScalingMenuView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 31/05/2024.
//

import SwiftUI

struct PhotoMenuView: View {

    @EnvironmentObject  var scaleValueProviderVM: ScaleValueProviderViewModel
 
    var body: some View {
        Group {
             SlideFromBottom("photo", 200) {
                 VStack{

                    PhotoPickerButtonView()

                     HStack{
                         ResetPositionButtonView()
                          .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                         
                         RemovePhotoView()
                     }
                    
                     
                     ScalingDimensionSelectorView()

                    }
             }
         }
     }
}

