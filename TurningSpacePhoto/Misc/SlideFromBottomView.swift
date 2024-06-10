//
//  SlideFromBottom.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

struct SlideFromBottomView<Content: View>: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var scalingCompletedVM: ScalingCompletedViewModel
    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
    @EnvironmentObject var slideFromBottomViewModel: SlideFromBottomViewModel
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
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
        let unscaledImageSoPreventDismiss =
        //!scaleButtonVM.getScalingCompletedStatus() &&
        !scalingCompletedVM.scalingCompleted &&
            menuName == "photo" &&
            (slideFromBottomViewModel.chosenPhotoStatus
            )
        
//        print("unscaledImageSoPreventDismiss: \(unscaledImageSoPreventDismiss)")
//        print("menuName: \(menuName)")
//        print("photoScaleVM.getBackgroundPictureSatus(): \(photoScaleVM.getBackgroundPictureSatus())")
//        print("photoScaleVM.getImagePickerStatus(): \(photoScaleVM.getImagePickerStatus())")
//        print("scaleButtonVM.getScalingCompletedStatus(): \(scaleButtonVM.getScalingCompletedStatus())")
return
        VStack {
            Spacer()
            ZStack(alignment: .topLeading) {
                // Check opacity of this color
                Color(UIColor(named: "MiddleMenu")!)
                VStack(alignment: .leading) {
                    ZStack {
                        Button(action: {
                            navigationViewModel.setShowMenu(false)
                            if self.menuName == "openFile" {
                                // Handle openFile action
                            }
                            if self.menuName == "photo" {
                                photoMenuVM.setMenuActiveStatus(false)
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
                    self.content
                }
            }
            .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
        }
        .modifier(ActionSlideStyle())
    }
}


//struct SlideFromBottom<Content: View>: View {
//    @EnvironmentObject var navigationViewModel: NavigationViewModel
//    @EnvironmentObject var scaleButtonVM: ScaleButtonViewModel
//    @EnvironmentObject var scaleMenuVM: ScaleMenuViewModel
//    @EnvironmentObject var photoScaleVM: PhotoScaleViewModel
//    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
//    @State var showingPopover = false
//    var menuName: String
//    var menuHeight: CGFloat
//    let content: Content
//
//    init (_ menuName:String, _ menuHeight: CGFloat,  @ViewBuilder _ content: ()-> Content){
//        self.menuName = menuName
//        self.menuHeight = menuHeight
//        self.content = content()
//       
//    }
//    
// 
//    var body:some View {
//        let unscaledImageSoPreventDismiss =
//        !scaleButtonVM.getScalingCompletedStatus() &&
//            menuName == "photo" &&
//                (photoScaleVM.getBackgroundPictureSatus() ||
//                 photoScaleVM.getImagePickerStatus())
//        
//        VStack {
//            Spacer()
//                ZStack (alignment: .topLeading) {
//                    Color(UIColor(named:"MiddleMenu")!)
//                    VStack (alignment: .leading) {
//                        ZStack {
//
//
//                            Button(action: {
//                                navigationViewModel.setShowMenu(false)
//                                if self.menuName == "openFile" {
//                                }
//                                if self.menuName == "photo" {
//                                    scaleMenuVM.setMenuActiveStatus(false)
//                                }
//                                if self.menuName == "arrow.clockwise" {
//                                }
//                                if self.menuName == MenuIcon.chairTool {
//                                    menuChairViewModel.toggleShowMenuStatus()
//                                }
//                            }, label: {
//                                if unscaledImageSoPreventDismiss {
//                                    ActionNpDismissForUnscaledImageStyle()
//                                } else {
//                                    ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray: .blue)
//                                }
//                            }
//                            )
//                            .disabled(unscaledImageSoPreventDismiss)
//
//                        }
//
//                        self.content
//                    }
//                }
//                .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
//        }
//        .modifier(ActionSlideStyle())
//    }
//}



//                            Button(action: {
//                                if self.menuName == "photo" {
//                                    menuPictureScaleViewModel.toggleShowMenuStatus()
//                                }
//                            }, label: {
//                                ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray: .blue)
//                            }
//                            )

//                                .popover(isPresented: $showingPopover) {
//                                    Text("You need to ...")
//                                        .modifier(PopOverBodyFont())
//                                        .padding()
//                        }
