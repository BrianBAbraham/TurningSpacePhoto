//
//  TurningSpacePhotoApp.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 23/05/2024.
//

import SwiftUI



@main
struct TurningSpacePhotoApp: App {
    
    //MENU MANAGEMENT a - z
    @StateObject var conditionalRightSideMenuViewModel = ConditionalRightSideMenuViewModel()
    @StateObject var dismissBottomMenuViewModel = DismissBottomMenuViewModel()
    @StateObject var dismissRightSideMenuViewModel = DismissRightSideMenuViewModel()
    @StateObject var returnToRightSideMenuViewModel = ReturnToRightSideMenuViewModel()
    @StateObject var rightSideMenuItemViewModel = RightSideMenuItemViewModel()
    @StateObject var unscaledPhotoAlertViewModel = UnscaledPhotoAlertViewModel()
    
   //MISC
    @StateObject var vm = ChairManoeuvreProjectVM()
    @StateObject var menuChairViewModel = MenuChairViewModel()
    @StateObject var alertVM = AlertViewModel()
    @StateObject var visibleToolViewModel = VisibleToolViewModel()
    
    //PHOTO SELECTION a - z
    @StateObject var chosenPhotoViewModel = ChosenPhotoViewModel()
    @StateObject var removePhotoViewModel = RemovePhotoButtonViewModel()
    @StateObject var photoPickerVM = PhotoPickerViewModel()
    
    //SCALING MANAGEMENT a - z
    @StateObject var confirmScaleButtonViewModel = ConfirmScaleButtonViewModel()
    @StateObject var currentDimensionViewModel = CurrentDimensionViewModel()
    @StateObject var planDimensionSelectorViewModel = PhotoDimensionSelectorViewModel()
    @StateObject var resetPositionButtonViewModel = CenterPhotoButtonViewModel()
    @StateObject var scaleDimensionLineViewModel = ScaleDimensionLineViewModel()
    @StateObject var scaleMenuViewModel = PhotoMenuViewModel()
    @StateObject var scaleValueProviderMediator = ScaleValueProviderMediator()
    @StateObject var scalingCompletedViewModel = ScalingCompletedViewModel()
    @StateObject var scalingPhotoViewModel = ScalingPhotoViewModel()
    @StateObject var scalingToolViewModel = ScalingToolViewModel()
 
    var body: some Scene {
        WindowGroup {
            ContentView()
               
                //MENU MANAGEMENT a - z
                .environmentObject(conditionalRightSideMenuViewModel)
                .environmentObject(dismissBottomMenuViewModel)
                .environmentObject(dismissRightSideMenuViewModel)
                .environmentObject(returnToRightSideMenuViewModel)
                .environmentObject(rightSideMenuItemViewModel)
                .environmentObject(unscaledPhotoAlertViewModel)
            
                //MISC
                .environmentObject(vm)
                .environmentObject(menuChairViewModel)
                .environmentObject(alertVM)
                .environmentObject(visibleToolViewModel)

                //PHOTO SELECTION a - z
                .environmentObject(chosenPhotoViewModel)
                .environmentObject(removePhotoViewModel)
                .environmentObject(photoPickerVM)

                //SCALING MANAGEMENT a - z
                .environmentObject(confirmScaleButtonViewModel)
                .environmentObject(currentDimensionViewModel)
                .environmentObject(planDimensionSelectorViewModel)
                .environmentObject(resetPositionButtonViewModel)
                .environmentObject(scaleDimensionLineViewModel)
                .environmentObject(scaleMenuViewModel)
                .environmentObject(scaleValueProviderMediator)
                .environmentObject(scalingCompletedViewModel)
                .environmentObject(scalingPhotoViewModel)
                .environmentObject(scalingToolViewModel)
        }
    }
}

