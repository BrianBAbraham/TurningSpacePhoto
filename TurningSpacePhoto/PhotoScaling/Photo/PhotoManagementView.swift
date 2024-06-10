//
//  PictureManagementView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.sd
//


import SwiftUI


struct PhotoManagementView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            ScalingPhotoView()
            
            ScalingToolView()
                
            PhotoMenuView()
        }
    }
}






