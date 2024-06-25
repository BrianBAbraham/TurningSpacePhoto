//
//  FirstDraft2_5_22App.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

@main
struct FirstDraft2_5_22App: App {
    @StateObject var vm = ChairManoeuvreProjectVM()
    @StateObject var navigationViewModel = NavigationViewModel()
    @StateObject var menuPictureScaleViewModel = MenuPictureScaleViewModel()
    @StateObject var pictureScaleViewModel = PictureScaleViewModel()
    @StateObject var photoScaleSettingViewModel = PhotoScaleSettingViewModel()
    @StateObject var menuChairViewModel = MenuChairViewModel()
    @StateObject var alertVM = AlertViewModel()
    @StateObject var visibleToolViewModel = VisibleToolViewModel()
//    @StateObject var photoPickerVM = PhotoPickerViewModel()

 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationViewModel)
                .environmentObject(menuPictureScaleViewModel)
                .environmentObject(pictureScaleViewModel)
                .environmentObject(photoScaleSettingViewModel)
                .environmentObject(vm)
//                .environmentObject(backgroundViewModel)
                .environmentObject(menuChairViewModel)
                .environmentObject(alertVM)
                .environmentObject(visibleToolViewModel)
//                .environmentObject(photoPickerVM)

        }
    }
}
