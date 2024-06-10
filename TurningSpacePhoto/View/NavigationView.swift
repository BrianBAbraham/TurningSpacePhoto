//
//  NavigationView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI





struct Navigation: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var showingPopover = false
    
    
    var helpButton: some View {
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
    var body: some View {
        ZStack (alignment: .trailing) {
                NavigationBackground()
            VStack{
                Group{
                    DismissNavigation()
                    Spacer()
                    Icon("photo")
                    Spacer()
                    Icon(MenuIcon.chairTool)
                    Spacer()
                    helpButton
                    Spacer()
                }
            }
        }
    }
}

struct Icon: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var scaleButtonVM: ScalingCompletedViewModel
    @EnvironmentObject  var scaleMenuVM: PhotoMenuViewModel
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel

    
    let maxWidth = NavigationBackGroundWidth().width
    let name: String
    init (_ name: String) {
        self.name = name
    }
    var body: some View {
            Button( action: {
                navigationViewModel.setShowMenu(false)
                if name == "folder.fill" {
                }
                if name == "photo" {
                    
                    //print("active menu \(scaleMenuVM.getMenuActiveStatus())")
                    scaleMenuVM.setMenuActiveStatus(true)
                }
                if name == "arrow.clockwise" {
//print("No menu")
                }
                if name == MenuIcon.chairTool {
                    menuChairViewModel.toggleShowMenuStatus()
                    
                }
                
            })  {
                Image(systemName: self.name)
//                .font(.largeTitle)
           }
            .buttonStyle(TopNavigationBlueButton())
            //.buttonStyle(PlainButtonStyle())
    }
}
    

struct SlideNavigationFromTrailing<Content: View>: View {
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


struct NavigationBackground: View {
    let maxWidth = NavigationBackGroundWidth().width
    var body: some View {
        HStack{
            Spacer()
            Color(UIColor(named:"MiddleMenu")!)
            .frame(maxWidth: maxWidth, alignment: .trailing)
            .opacity(1)
        }
    }
}

struct ReturnToNavigation: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
    @EnvironmentObject var photoMenuVM: PhotoMenuViewModel
   // @EnvironmentObject var chosenPhotoViewModel: ChosenPhotoViewModel
// @EnvironmentObject var openFileViewModel: OpenFileViewModel
    let maxWidth = NavigationBackGroundWidth().width
    var body: some View {
        ZStack {
            VStack {
                Button( action: {
                    navigationViewModel.setShowMenu(true)
                    menuChairViewModel.setShowMenuStatus(false)
                    if photoMenuVM.showMenu {
                        photoMenuVM.setMenuActiveStatus(false)

                    }
//print("MENU PRESS \(menuPictureScaleViewModel.getScalingCompletedStatus())")
                }) {
                    Spacer()
                    ZStack{
                        Color(UIColor(named:"MiddleMenu")!)
                            .frame(maxWidth: maxWidth,maxHeight: maxWidth, alignment: .trailing)
                            .opacity(0.5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                }
//                .buttonStyle(DefaultButtonStyle())
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
        }
    }
}

struct DismissNavigation: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    var body: some View {
        Button(action: {
            navigationViewModel.setShowMenu(false)
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

struct NavigationBackGroundWidth {
    let width = 58.0
}

struct NavigationView: View {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    var body: some View {
        
        ZStack {
            if navigationViewModel.getShowToggle() {
                SlideNavigationFromTrailing (content: Navigation())
            }
        }
    }
}


struct CancelButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
    }
}
