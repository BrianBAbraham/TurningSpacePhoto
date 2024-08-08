//
//  TurningSpacePhotoApp.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 23/05/2024.
//

import SwiftUI



@main

struct TurningSpace001App: App {
    //MENU MANAGEMENT a - z
    @StateObject var rightSideMenuViewModel = RightSideMenuViewModel()
    @StateObject var conditionalUnscaledPhotoAlertViewModel = ConditionalUnscaledPhotoAlertViewModel()
    @StateObject var dismissBottomMenuViewModel = DismissBottomMenuViewModel()
    @StateObject var dismissRightSideMenuViewModel = DismissRightSideMenuViewModel()
    @StateObject var returnToRightSideMenuViewModel = ReturnToRightSideMenuViewModel()
    @StateObject var rightSideMenuItemViewModel = RightSideMenuItemViewModel()
    @StateObject var unscaledPhotoAlertViewModel = UnscaledPhotoAlertViewModel()
    
   //MISC
    @StateObject var vm = ChairManoeuvreProjectVM()
    @StateObject var menuChairViewModel = MenuChairViewModel()
    
    
    //OBJECT CONTROL
    @StateObject var dragBackgroundPhotoAndChairsGestureMediator = DragPhotoAndChairsGestureMediator()
    
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
    @StateObject var scalingPhotoViewModel = ScalingPhotoViewModel()
    @StateObject var scalingToolViewModel = ScalingToolViewModel()
    
    
    
    ///ObjectCreation
    //ObjectEditMenuView
        //Properties
    @StateObject var bilateralPartSidePickerVM = BilateralPartSidePickerViewModel()
    @StateObject var bilateralPartPresenceVM = BilateralPartSidePresenceViewModel()
    @StateObject var dimensionPickerVM = DimensionPickerViewModel()
    @StateObject var dimensionStepperVM = DimensionStepperViewModel()
    @StateObject var originPickerVM = OriginPickerViewModel()
    @StateObject var originStepperVM = OriginStepperViewModel()
    @StateObject var propertyAngleEditVM =  PropertyAngleEditViewModel()
    @StateObject var unilateralPartPresenceVM =  UnilateralPartPresenceViewModel()
    @StateObject var menuForObjectEditViewModel =
    MenuForObjectEditViewModel()
    
        //Selections
    @StateObject var objectPickerVM = ObjectPickerViewModel()
    @StateObject var partPickerVM = PartPickerViewModel()
    
    
//MovementEditMenuView
    @StateObject var movementAnglePickerVM = MovementAnglePickerViewModel()
    @StateObject var movementAngleStepperVM = MovementAngleStepperViewModel()
    @StateObject var movementOriginStepperVM = MovementOriginStepperViewModel()
    @StateObject var movementPickerVM = MovementPickerViewModel()
    @StateObject var movementEditMenuContainerVM = MovementEditMenuContainerViewModel()
    @StateObject var menuForMovementEditViewModel = MenuForMovementEditViewModel()
    
    
//ObjectView
    @StateObject var partViewModel = AllPartViewModel()
    @StateObject var allArcWithStaticPointVM = AllArcWithStaticPointViewModel()
    @StateObject var allPartWithArcContainerVM = AllPartWithArcContainerViewModel()

 
    @StateObject var rulerVM = RightAngleRulerViewModel()

    @StateObject var objectAndRulerVM = ObjectAndRulerViewModel()
  
    @StateObject var recenterVM = ObjectRulerRepositionViewModel()
        
 
    var body: some Scene {
        WindowGroup {
            ContentView()
               
                //MENU MANAGEMENT a - z
                .environmentObject(rightSideMenuViewModel)
                .environmentObject(conditionalUnscaledPhotoAlertViewModel)
                .environmentObject(dismissBottomMenuViewModel)
                .environmentObject(dismissRightSideMenuViewModel)
                .environmentObject(returnToRightSideMenuViewModel)
                .environmentObject(rightSideMenuItemViewModel)
                .environmentObject(unscaledPhotoAlertViewModel)
            
                //MISC
                .environmentObject(vm)
                .environmentObject(menuChairViewModel)
             
            
                //OBJECT CONTROL
                .environmentObject(dragBackgroundPhotoAndChairsGestureMediator)

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
                .environmentObject(scalingPhotoViewModel)
                .environmentObject(scalingToolViewModel)
            
            
            ///ObjectCreation
            //ObjectEditMenuView
                //Properties
                .environmentObject(bilateralPartSidePickerVM)
                .environmentObject(bilateralPartPresenceVM)
                .environmentObject(dimensionPickerVM)
                .environmentObject(dimensionStepperVM)
                .environmentObject(originPickerVM)
                .environmentObject(originStepperVM)
                .environmentObject(propertyAngleEditVM)
                .environmentObject(unilateralPartPresenceVM)
                .environmentObject(menuForObjectEditViewModel)
                
                //Selection
                .environmentObject(objectPickerVM)
                .environmentObject(partPickerVM)
            
            
            
            //MovementEditMenuView
                .environmentObject(movementAnglePickerVM)
                .environmentObject(movementAngleStepperVM)
                .environmentObject(movementOriginStepperVM)
                .environmentObject(movementPickerVM)
                .environmentObject(movementEditMenuContainerVM)
                .environmentObject(menuForMovementEditViewModel)
            
            //ObjectView
                .environmentObject(partViewModel)
                .environmentObject(allArcWithStaticPointVM)
                .environmentObject(allPartWithArcContainerVM)
            
                .environmentObject(rulerVM)
            
               .environmentObject(objectAndRulerVM)
                
                .environmentObject(recenterVM)
        }
    }
}

