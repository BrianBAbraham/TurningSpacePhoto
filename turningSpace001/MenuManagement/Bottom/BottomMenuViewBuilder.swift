//
//  SlideFromBottom.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI



struct BottomMenuViewBuilder<Content: View>: View {
    
    var menuName: String
    let content: Content
    
    @State private var contentHeight: CGFloat = 0
    
    init (_ menuName: String, @ViewBuilder _ content: () -> Content) {
        self.menuName = menuName
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Spacer()// push to bottom of screen
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    DismissBottomMenuView(menuName: menuName)
                        .padding(.top, 5)
                        .padding(.leading, 5)
                    self.content
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        self.contentHeight = geometry.size.height
                                    }
                            }
                        )
                }
            }
            .backgroundModifier()
            .frame(minWidth: SizeOf.screenWidth, maxHeight: contentHeight)

        }
        .modifier(ActionSlideStyle())
    }
}
