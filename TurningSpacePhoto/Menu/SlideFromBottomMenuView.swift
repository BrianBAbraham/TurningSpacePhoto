//
//  SlideFromBottom.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI
//
//struct SlideFromBottomMenuView<Content: View>: View {
//    @EnvironmentObject var navigationViewModel: NavigationViewModel
//    @EnvironmentObject var scalingCompletedVM: ScalingCompletedViewModel
//    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
//    @EnvironmentObject var slideFromBottomViewModel: SlideFromBottomMenuViewModel
//    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
//    @State var showingPopover = false
//    var menuName: String
//    var menuHeight: CGFloat
//    let content: Content
//
//    init (_ menuName: String, _ menuHeight: CGFloat, @ViewBuilder _ content: () -> Content) {
//        self.menuName = menuName
//        self.menuHeight = menuHeight
//        self.content = content()
//    }
//
//    var body: some View {
//        let unscaledImageSoPreventDismiss =
//        !scalingCompletedVM.scalingCompleted &&
//            menuName == "photo" &&
//            (slideFromBottomViewModel.chosenPhotoStatus
//            )
//        
//    return
//        VStack {
//            Spacer()
//            ZStack(alignment: .topLeading) {
//               
//                Color(UIColor(named: "MiddleMenu")!)
//               
//                VStack(alignment: .leading) {
//                    ZStack {
//                        Button(action: {//dismiss button
//                            navigationViewModel.setShowMenu(false)
//                            
//                            if self.menuName == "openFile" {
//                                // Handle openFile action
//                            }
//                            if self.menuName == "photo" {
//                                photoMenuVM.setMenuActiveStatus(false)
//                            }
//                            if self.menuName == "arrow.clockwise" {
//                                // Handle arrow.clockwise action
//                            }
//                            if self.menuName == MenuIcon.chairTool {
//                                menuChairViewModel.toggleShowMenuStatus()
//                            }
//                        }, label: {
//                            if unscaledImageSoPreventDismiss {//results are nonsense if not scaled
//                                ActionNpDismissForUnscaledImageStyle()
//                            } else {
//                                ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray : .blue)
//                            }
//                        })
//                        .disabled(unscaledImageSoPreventDismiss)
//                    }
//                    
//                    self.content//the relevant menu
//                }
//            }
//            .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
//        }
//        .modifier(ActionSlideStyle())
//    }
//}



struct SlideFromBottomMenuView<Content: View>: View {
    @State var showingPopover = false
    var menuName: String
    var menuHeight: CGFloat
    let content: Content

    init (_ menuName: String, _ menuHeight: CGFloat, @ViewBuilder _ content: () -> Content) {
        self.menuName = menuName
        self.menuHeight = menuHeight
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .topLeading) {
                Color(UIColor(named: "MiddleMenu")!)
                VStack(alignment: .leading) {
                    ZStack {
                        SlideFromBottomMenuDismissView(menuName: menuName)
                    }
                    self.content
                }
            }
            .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
        }
        .modifier(ActionSlideStyle())
    }
}



struct SlideFromBottomMenuDismissView: View {

    @EnvironmentObject var slideFromBottomDismissVM: SlideFromBottomMenuDismissViewModel
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
    
    var menuName: String
    
    var body: some View {
        let unscaledImageSoPreventDismiss =
        slideFromBottomDismissVM.preventDismiss && menuName == "photo"

        Button(action: {
            slideFromBottomDismissVM.setShowMenu(false)
            
            
            slideFromBottomDismissVM.setShowRightSideMenuFalse()
            
            
            if self.menuName == "openFile" {
                // Handle openFile action
            }
            if self.menuName == "photo" {
                slideFromBottomDismissVM.setShowPhotoMenuFalse()
            }
            if self.menuName == "arrow.clockwise" {
                // Handle arrow.clockwise action
            }
            if self.menuName == MenuIcon.chairTool {
                menuChairViewModel.toggleShowMenuStatus()
            }
        }, label: {
            if unscaledImageSoPreventDismiss {
                ActionNpDismissForUnscaledImageStyle()
            } else {
                ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray : .blue)
            }
        })
        .disabled(unscaledImageSoPreventDismiss)
    }
}
