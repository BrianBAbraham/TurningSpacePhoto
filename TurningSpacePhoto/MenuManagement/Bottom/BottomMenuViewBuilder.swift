//
//  SlideFromBottom.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI



struct BottomMenuViewBuilder<Content: View>: View {
    @State var showingPopover = false
    var menuName: String
    var menuHeight: CGFloat
    let content: Content

    init (_ menuName: String, _ menuHeight: CGFloat, @ViewBuilder _ content: () -> Content
    ) {
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
               
                    DismissBottomMenuView(menuName: menuName)
                 
                    self.content
                }
            }
            .frame(minWidth: SizeOf.screenWidth, maxHeight: self.menuHeight)
        }
        .modifier(ActionSlideStyle())
    }
}


//struct BottomMenuView: View {
//    @State var showingPopover = false
//    var menuName: String
//    var menuHeight: CGFloat
//
//    var body: some View {
//        VStack {
//            Spacer()
//            ZStack(alignment: .topLeading) {
//                Color(UIColor(named: "MiddleMenu")!)
//                VStack(alignment: .leading) {
//                    DismissBottomMenuView(menuName: menuName)
//                    
//                    // Directly embedding the specific content
//                    VStack {
//                        PhotoPickerButtonView()
//                        
//                        HStack {
//                            CentrePhotonButtonView()
//                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//                            
//                            RemovePhotoButtonView()
//                        }
//                        
//                        ScalingDimensionSelectorView()
//                    }
//                }
//            }
//            .frame(minWidth: SizeOf.screenWidth, maxHeight: menuHeight)
//        }
//        .modifier(ActionSlideStyle())
//    }
//}
