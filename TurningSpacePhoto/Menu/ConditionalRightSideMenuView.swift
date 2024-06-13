//
//  NavigationView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI

struct ConditionalRightSideMenuView: View {
    @EnvironmentObject var conditionalRightSideMenuVM: ConditionalRightSideMenuViewModel
    var body: some View {
            if conditionalRightSideMenuVM.showRightSideMenu {
                ShowRightSideMenuView (content: RightSideMenuView())
            }
    }
}



struct ShowRightSideMenuView<Content: View>: View {
    let content: Content
    init(content: Content) {
        self.content = content
    }
    var body:some View {
       HStack {
           self.content
        }
        .transition(.move(edge: .trailing))
        .onAppear{
            withAnimation(Animation.easeInOut(duration: 1.5)) {}
        }
    }
}



struct RightSideMenuView: View {
    var body: some View {
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
                    MainHelpView()//helpButton
                    Spacer()
                }
            }
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
















struct DismissRightSideMenuView: View {
    @EnvironmentObject var dismissRightSideMenuVM: DismissRightSideMenuViewModel
    var body: some View {
        Button(action: {
            dismissRightSideMenuVM.setShowMenu(false)
        }, label: {
            ActionDismissStyle(color: .blue)
                .padding(.top, 2)
                .padding(.leading, 5)
            }
        )
        .buttonStyle(DefaultButtonStyle())
        .offset(y: 5)
//        .buttonStyle(PlainButtonStyle())
    }
}

struct RightSideBackgroundWidth {
    let width = 58.0
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
