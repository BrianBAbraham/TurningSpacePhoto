//
//  ChairMovementOnChosenBackground.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 24/06/2024.
//

import SwiftUI

struct MovementOnPhotoContainerView: View {
    var body: some View {
        ZStack{
            ChosenPhotoView()
    
            ObjectAndRulerContainerView(displayStyle: .edit)
        }
    }
}
