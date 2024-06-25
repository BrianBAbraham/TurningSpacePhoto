//
//  SlideFromBottom.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

struct SlideFromBottom<Content: View>: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var menuPictureScaleViewModel: MenuPictureScaleViewModel
    @EnvironmentObject var pictureScaleViewModel: PictureScaleViewModel
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
    @State var showingPopover = false
    var menuName: String
    var menuHeight: CGFloat
    let content: Content

    init (_ menuName:String, _ menuHeight: CGFloat,  @ViewBuilder _ content: ()-> Content){
        self.menuName = menuName
        self.menuHeight = menuHeight
        self.content = content()
       
    }
    
 
    var body:some View {
        let unscaledImageSoPreventDismiss =
        !menuPictureScaleViewModel.getScalingCompletedStatus() &&
            menuName == "photo" &&
                (pictureScaleViewModel.getBackgroundPictureSatus() ||
                 pictureScaleViewModel.getImagePickerStatus())
        
        VStack {
            Spacer()
                ZStack (alignment: .topLeading) {
                    Color(UIColor(named:"MiddleMenu")!)
                    VStack (alignment: .leading) {
                        ZStack {


                            Button(action: {
                                navigationViewModel.setShowMenu(false)
                                if self.menuName == "openFile" {
                                }
                                if self.menuName == "photo" {
                                    menuPictureScaleViewModel.setShowMenuStatus(false)
                                }
                                if self.menuName == "arrow.clockwise" {
                                }
                                if self.menuName == MenuIcon.chairTool {
                                    menuChairViewModel.toggleShowMenuStatus()
                                }
                            }, label: {
                                if unscaledImageSoPreventDismiss {
                                    ActionNpDismissForUnscaledImageStyle()
                                } else {
                                    ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray: .blue)
                                }
                            }
                            )
                            .disabled(unscaledImageSoPreventDismiss)
                            
//                            Button(action: {
//                                if self.menuName == "photo" {
//                                    menuPictureScaleViewModel.toggleShowMenuStatus()
//                                }
//                            }, label: {
//                                ActionDismissStyle(color: unscaledImageSoPreventDismiss ? .gray: .blue)
//                            }
//                            )
                        }

                        self.content
                    }
                }
                .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
        }
        .modifier(ActionSlideStyle())
    }
}


//                                .popover(isPresented: $showingPopover) {
//                                    Text("You need to ...")
//                                        .modifier(PopOverBodyFont())
//                                        .padding()
//                        }
