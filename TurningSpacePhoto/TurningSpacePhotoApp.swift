//
//  TurningSpacePhotoApp.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 23/05/2024.
//

import SwiftUI



@main
struct TurningSpacePhotoApp: App {
    

    class ScalePhotoGroup: ObservableObject {
        @Published var scaleButtonViewModel = ScalingCompletedViewModel()
//        @StateObject var scaleValueProviderVM = ScaleValueProviderMediator()
//        @StateObject var scaleMenuViewModel = PhotoMenuViewModel()
//        @StateObject var chosenPhotoViewModel = ChosenPhotoViewModel()
//        @StateObject var scalingPhotoViewModel = ScalingPhotoViewModel()
//        @StateObject var scaleDimensionLineViewModel = ScaleDimensionLineViewModel()
//        
//        @StateObject var scalingToolViewModel = ScalingToolViewModel()
//        @StateObject var confirmScaleButtonViewModel = ConfirmScaleButtonViewModel()
//        @StateObject var planDimensionSelectorViewModel = PhotoDimensionSelectorViewModel()
    }

    class MenuGroup: ObservableObject {
        @Published var conditionalRightSideMenuViewModel = ConditionalRightSideMenuViewModel()
    }

    // Create an instance of the nested struct
    let scalePhotoGroup = ScalePhotoGroup()
    let menuGroup = MenuGroup()
    
    
   // @StateObject var scaleButtonViewModel = ScalingCompletedViewModel()
    
    @StateObject var vm = ChairManoeuvreProjectVM()
    
    
    @StateObject var navigationViewModel = DismissRightSideMenuViewModel()
    @StateObject var returnToRightSideMenuViewModel = ReturnToRightSideMenuViewModel()
    
    @StateObject var scaleValueProviderVM = ScaleValueProviderMediator()
    @StateObject var scaleMenuViewModel = PhotoMenuViewModel()
    @StateObject var chosenPhotoViewModel = ChosenPhotoViewModel()
    @StateObject var scalingPhotoViewModel = ScalingPhotoViewModel()
    
    @StateObject var menuChairViewModel = MenuChairViewModel()
    @StateObject var alertVM = AlertViewModel()
    
    
    @StateObject var removePhotoViewModel = RemovePhotoButtonViewModel()
    @StateObject var scaleDimensionLineViewModel = ScaleDimensionLineViewModel()
    
    
    @StateObject var visibleToolViewModel = VisibleToolViewModel()
    @StateObject var photoPickerVM = PhotoPickerViewModel()
    
    @StateObject var resetPositionButtonViewModel = CenterPhotoButtonViewModel()
    @StateObject var scalingToolViewModel = ScalingToolViewModel()
    @StateObject var confirmScaleButtonViewModel = ConfirmScaleButtonViewModel()
    @StateObject var planDimensionSelectorViewModel = PhotoDimensionSelectorViewModel()
    @StateObject var currentDimensionViewModel = CurrentDimensionViewModel()
    
    @StateObject var slideFromBottomMenuViewModel = SlideFromBottomMenuDismissViewModel()
   
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(scalePhotoGroup.scaleButtonViewModel)

            
                .environmentObject(navigationViewModel)
                .environmentObject(returnToRightSideMenuViewModel)
                
                .environmentObject(scaleMenuViewModel)
                .environmentObject(chosenPhotoViewModel)
                .environmentObject(scalingPhotoViewModel)
                .environmentObject(scaleValueProviderVM)
                .environmentObject(vm)
                .environmentObject(menuChairViewModel)
                .environmentObject(alertVM)
                .environmentObject(removePhotoViewModel)
                .environmentObject(visibleToolViewModel)
                .environmentObject(photoPickerVM)
                .environmentObject(scaleDimensionLineViewModel)
                .environmentObject(resetPositionButtonViewModel)
                .environmentObject(scalingToolViewModel)

                .environmentObject(confirmScaleButtonViewModel)
                .environmentObject(planDimensionSelectorViewModel)
                .environmentObject(currentDimensionViewModel)
                .environmentObject(slideFromBottomMenuViewModel)
                .environmentObject(menuGroup.conditionalRightSideMenuViewModel)


        }
    }
}

