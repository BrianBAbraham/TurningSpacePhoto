//
//  TurningSpacePhotoApp.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 23/05/2024.
//

import SwiftUI

@main
struct TurningSpacePhotoApp: App {
    @StateObject var vm = ChairManoeuvreProjectVM()
    @StateObject var navigationViewModel = NavigationViewModel()
    @StateObject var scaleButtonViewModel = ScalingViewModel()
    @StateObject var scaleValueProviderVM = ScaleValueProviderViewModel()
    @StateObject var scaleMenuViewModel = ScaleMenuViewModel()
    @StateObject var chosenPhotoViewModel = ChosenPhotoViewModel()
    @StateObject var scalingPhotoViewModel = ScalingPhotoViewModel()
    @StateObject var menuChairViewModel = MenuChairViewModel()
    @StateObject var alertVM = AlertViewModel()
    @StateObject var removePhotoViewModel = RemovePhotoButtonViewModel()
    @StateObject var scaleDimensionLineViewModel = ScaleDimensionLineViewModel()
    @StateObject var visibleToolViewModel = VisibleToolViewModel()
    @StateObject var photoPickerVM = PhotoPickerViewModel()
    @StateObject var resetPositionButtonViewModel = ResetPositionButtonViewModel()
    @StateObject var scalingToolViewModel = ScalingToolViewModel()
    @StateObject var confirmScaleButtonViewModel = ConfirmScaleButtonViewModel()
    @StateObject var planDimensionSelectorViewModel = PlanDimensionSelectorViewModel()
    @StateObject var currentDimensionViewModel = CurrentDimensionViewModel()
   
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationViewModel)
                .environmentObject(scaleButtonViewModel)
                .environmentObject(scaleMenuViewModel)
                .environmentObject(chosenPhotoViewModel)
                .environmentObject(scalingPhotoViewModel)
                .environmentObject(scaleValueProviderVM)
                .environmentObject(vm)
//                .environmentObject(backgroundViewModel)
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

        }
    }
}
