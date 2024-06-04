//
//  PictureManagementView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.sd
//


import SwiftUI







struct PhotoManagementView: View {
    @EnvironmentObject var scaleButtonVM: ScalingViewModel
    @EnvironmentObject private var photoPickerVM: PhotoPickerViewModel
    @EnvironmentObject private var scalingPhotoVM: ScalingPhotoViewModel
    @EnvironmentObject var scaleMenuVM: ScaleMenuViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
 
    
    var body: some View {
        ZStack {
            ScalingPhotoView()

            if !scaleButtonVM.scalingModel.showScalingTool {
            
            ScalingToolView()
            }
            
            if scaleMenuVM.getMenuActiveStatus(){
                PhotoMenuView()
            }
        }
    }
}










 



//@State private var showingPopover = false
//var helpButton: some View {
//Button(action: {
//    showingPopover = true
//})
//    {Text("?")}
//        .buttonStyle(PictureScaleBlueButton())
//    .modifier(MenuButtonWithSymbolFont())
//    .popover(isPresented: $showingPopover) {
//        VStack (alignment: .leading){
//            Text("'TRY ME'\nPractice with example plan\nReproduce the plan wheelchair positions\nAlso see Scale and 'Confirm'")
//            Text("\n'Import'\nImported photo must be:\n To scale\n Have one known horizontal dimension(mm)\n Also see Scale and 'Confirm'")
//            Text("\nScale and 'Confirm'\nTo make chairs and plan the same scale\n Drag and zoom plan\n Position dash-lines at dimension ends\n Use triangle-box to drag dash-lines\n Set nearest dimension with slider and '+'/'-'\n Tap 'Confirm' to finish")
//            Text("\n'Remove'\nTo remove plan")
//            Text("\n'Center plan/triangle'\nReset plan/ scaling triangles to original position")
//        }
//
//        .modifier(PopOverBodyFont())
//
//    }
//}


//    @State private var showPicker = false
//    var buttonToShowImagePicker: some View {
//
//            Button(action: {
//                showPicker = true
//             //   image = nil
//                menuPhotoScaleVM.setScalingCompletedStatus(false)
//               // showingImagePicker = true
//                // Additional actions can be added here
//            }) {
//                Text("Import")
//            }
//            .photosPicker(isPresented: $showPicker, selection: $photoPickerVM.imageSelection, matching: .images)
//            .onChange(of: showPicker) { newValue in
////                        if !newValue {
////                            // Actions to perform when the picker is dismissed
////                            if image != nil {
//                               // showScalingRuler = true
//                menuPhotoScaleVM.setShowMenuStatus(true)
//
//                pictureScaleViewModel.setImagePickerStatus(true)
////
////                                imageLoadFailed = false
////                            } else {
////                                imageLoadFailed = true
////                            }
////                           // pictureScaleViewModel.setBackgroundImageToNil()
////                        }
//                    }
//
//    }

