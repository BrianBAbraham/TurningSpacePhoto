//
//  PhotoMenuView.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 31/05/2024.
//

import SwiftUI

struct PhotoMenuView: View {
    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
    var body: some View {
        
        if photoMenuVM.showMenu{
            Group {
                
                BottomMenuViewBuilder("photo", 200) {
                
                    VStack{
                        
                        PhotoPickerButtonView()
                        
                        HStack{
                            CentrePhotoButtonView()
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            
                            RemovePhotoButtonView()
                        }
                        
                        ScalingDimensionSelectorView()
                    }
                }
            }
        } else {
            EmptyView()
        }
     }
}



