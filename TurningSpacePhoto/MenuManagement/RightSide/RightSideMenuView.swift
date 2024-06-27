//
//  NavigationView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI



struct RightSideMenuView: View {
    @EnvironmentObject var rightSideMenuVM: RightSideMenuViewModel
    var body: some View {
        if rightSideMenuVM.showRightSideMenu {
            ZStack (alignment: .trailing) {
                RightSideMenuBackgroundView()
             
                
                VStack{
                    Group{
                        DismissRightSideMenuView()
                        Spacer()
                        // all sub menu below
                        RightSideMenuItemView("photo")
                        Spacer()
                        RightSideMenuItemView(MenuIcon.chairTool)
                        Spacer()
                        RightSideMenuItemView("figure.roll")
                        Spacer()
                        RightSideMenuItemView("circle")
                        Spacer()
                        RightSideMenuItemView("gear")
                        Spacer()
                        MainHelpView()//helpButton
                        Spacer()
                    }
                }
            }
        } else {
            ReturnToRightSideMenuView()
                .zIndex(11.0)
        }
    }
}


//the background
struct RightSideMenuBackgroundView: View {
    let maxWidth = RightSideBackgroundWidth().width
    var body: some View {
        HStack{
            Spacer()
            Color(UIColor(named:"MiddleMenu")!)
            .frame(maxWidth: maxWidth, alignment: .trailing)
            .opacity(1)
        }
    }
}

















//struct CancelButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .background(Color(red: 0, green: 0, blue: 0.5))
//            .foregroundColor(.white)
//    }
//}



struct MainHelpView: View {
    @State private var showingPopover = false
    var body: some View {
        Button(action: {
            showingPopover = true
        })  //{Text (Image(systemName: "questionmark.circle"))}
            {Text("?")}
                .font(.largeTitle)
    //        .modifier(MenuButtonWithSymbolFont())
            .popover(isPresented: $showingPopover) {
                VStack(alignment: .leading){
                    Text("BIG IDEA\nShow the wheelchair path on the plan")
                    Text("\nPHOTO MENU FEATURES\nImport a photo of a scaled plan\nor\nPractice with the TRY ME example plan")
                    Text("\n8WHEELCHAIR MENU FEATUREES\nAdd wheelchair\nAdd lots of wheelchairs\nDrag wheelchairs\nChange wheelchair length\nChange wheelchair width\nChange wheelchair start angle\nChange wheelchair end angle\nChange to any manoeuvre tightness\nAdd manoeuvres of preset tightness\nFlip wheelchair left to right\nFlip wheelchair top to bottom\nAdd midway wheelchair\nChange midway wheelchair angle")
                }
                .modifier(PopOverBodyFont())
                .padding()

            }
            .buttonStyle(TopNavigationBlueButton())
           // .buttonStyle(PlainButtonStyle())
        
    }
}
