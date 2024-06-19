//
//  MenuChairView.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/09/2022.
//

import Foundation
import SwiftUI



//struct SubMenuForPickManoeuvreView: View {
//    @EnvironmentObject var vm: ChairManoeuvreProjectVM
//    var movements = MovementNames.allCases.map {$0.rawValue}// ["only wheelchair", "tightest turn", "medium turn", "slow turn"]
//    @State private var movementType = MovementNames.slowQuarterTurn
//
//    var body: some View {
//        Picker("Movements", selection: $movementType) {
//            ForEach(MovementNames.allCases) { movement in
//                Text(movement.rawValue)
//            }
//        }
//        .onChange(of: movementType) {tag in
//            vm.modifyManoeuvreForNextChairAdd(tag.rawValue)
//        }
//    }
//}

struct SubMenuForPickManoeuvreView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @EnvironmentObject var menuChairVM: MenuChairViewModel
var movements = MovementNames.allCases.map {$0}// ["only wheelchair", "tightest turn", "medium turn", "slow turn"]
    @State private var movementType = MovementNames.position
    
    var currentMovementType: MovementNames {
        menuChairVM.getCurrentMovementType()
    }

    var body: some View {
        let boundMovementType = Binding(
            get: {menuChairVM.getCurrentMovementType()},
            set: {self.movementType = $0}
        )
        
        Picker("movements",selection: boundMovementType) {
            ForEach(movements) { movement in
                Text(movement.rawValue)
            }
            .modifier(MenuButtonWithSymbolFont())
        }
        .onChange(of: movementType) {tag in
            self.movementType = tag
            vm.modifyManoeuvreForNextChairAdd(tag.rawValue)
//print("PICKER \(tag.rawValue)")
            menuChairVM.setCurrentMovementType(tag)
        }
    }
}

struct ModifyNumberOfManouevre: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let buttonText: String
    var body: some View {
        HStack {
            Button(action: {
                buttonText == "+" ? vm.addChairManoeuvre(): vm.removeChairManoeuvre()
//print("scaling:\(menuPictureScaleViewModel.getScalingCompletedStatus())   image:\(pictureScaleViewModel.getBackgroundImage() != nil)")
            })  {
                if buttonText == "+" {
                    Text(buttonText).modifier(MenuButtonWithSymbolFont())
                } else {
                    Text(buttonText).modifier(ConditionalChairSelectedMenuButtonWithSymbol())
                }
            }
        }
//        .font(horizontalSizeClass == .compact ? .footnote: .title)
        .environmentObject(vm)
    }
}



struct AddInbetweenerMovementView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingPopover = false
    var grayOut: Color {
        vm.getIsAnyChairSelected() ? .blue: .gray
    }
    var body: some View {
        HStack {
            Button(action: {
                if vm.getIsAnyChairSelected() {
                    vm.addRotationMovementWithInterpolation()
                } else {
                    showingPopover = true
               }
            })  {Text( "+").modifier(ConditionalChairSelectedMenuButtonWithSymbol())}
            Button(action: {
                vm.removeIntbetweenerRotationMovement()
            })  {Text ( "-").modifier(ConditionalThreeMovmentMenuButtonTextFont())}
            Text("midway chair")
                .modifier(ConditionalChairSelectedMenuButtonTextFont())
        }
        .foregroundColor(grayOut)
        .font(horizontalSizeClass == .compact ? .footnote: .title)
        .popover(isPresented: $showingPopover) {
            Text("You need to add one chair and select it")
                .modifier(PopOverBodyFont())
                .padding()
        }
    }
}

//struct InbetweenToggleView: View {
//    @EnvironmentObject var vm: ChairManoeuvreProjectVM
//    @State private var showExtra = false
//    var  chairSelected: Bool {
//        vm.getIsAnyChairSelected()
//    }
//    var body: some View {
//        Toggle(isOn: $showExtra) {
//        Text("Extra")
//                .opacity(chairSelected ? 1: 0.1)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//        }
//        .disabled(chairSelected == false)
//        .onChange(of: showExtra) { value in
//            if showExtra {
//print("ADD EXTRA")
//                if vm.getIsAnyChairSelected() {
//print(vm.getIsAnyChairSelected())
//                    vm.addRotationMovementWithInterpolation()
//                }
//            } else {
//print("REMOVE EXTRA")
//                vm.removeInterpolatedRotationMovement()
//            }
//        }
//    }
//}

 


struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content

    init(horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        Group {
            if sizeClass == .compact {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
    }
}




struct AddManoeuvreOrInbetweenerView: View {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM

    var body: some View {
        Spacer()
        AdaptiveStack{
            HStack{
                ModifyNumberOfManouevre(buttonText: "+")
                SubMenuForPickManoeuvreView()
                ModifyNumberOfManouevre(buttonText: "-")
                    .disabled(vm.chairManoeuvres.count == 0)
            }
            Spacer()
            AddInbetweenerMovementView( )
            Spacer()
//            InbetweenToggleView()
//
        }
        .environmentObject(vm)
        .padding()

    }
}

struct MenuForChairView: View {
    @EnvironmentObject var menuChairViewModel: MenuChairViewModel
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    @State var proposedChairExternalWidthMeasurement = DefaultMeasurements.wheelchair(.chairWidth)
    @State var proposedChairLengthMeasurement = DefaultMeasurements.wheelchair(.chairLength)

    @State private var showingPopover = false
    
    let alwaysText = Text("MENU TOOLS\nTap '+'to add a 'slow 1/4 turn'\nTap 'slow 1/4 turn' for different preset turns")
    let selectingText = Text("SELECTING TOOLS\nTap chair blue to select\nTap selected chair orange to unselect\nTap both chairs blue to select both")
    let dragText = Text("DRAG CHAIR") + Text(Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")).foregroundColor(.red)
    
    let whenChairSelectedText = Text("WHEN CHAIR SELECTED\nTap '+/- midway' to add/remove third chair\nTap '-'to remove turn")
    
    let toolsWhenZoomedInText =
    Text("XTRA TOOLS APPEAR AFTER ZOOMING\nSelect chair and tap and drag ") +
    Text(Image(systemName: "arrow.triangle.2.circlepath")) +
    Text("to turn") + Text("\nTurn tightness:") +
    Text(Image(systemName: "lock")) +
    Text(", drag chair towards") +
    Text(Image(systemName: "arrow.left.and.right")).foregroundColor(.red) +
    Text("\nLeft-right/top-bottom flip") +
    Text(Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")) +
    Text(Image(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down"))
    
    let tipsText =
    Text("TIPS\nPinch expand (zoom) for more tools") +
    Text("\nTo drag chair:") + Text(Image(systemName: "lock.open")) +
    Text("and") +
    Text(Image(systemName: "arrow.triangle.2.circlepath")).foregroundColor(.gray) +
    Text(" not ") +
    Text(Image(systemName: "lock")) +
    Text(" or ") +
    Text(Image(systemName: "arrow.triangle.2.circlepath"))
     
    
//    var lockOpenView: some View {
//        ZStack{
//            Circle()
//                .strokeBorder(Color.black)
//                .background(Circle().foregroundColor(Color.white))
//                .frame(width: 30, height: 30)
//            Image(systemName: "lock.open")
//        }
//        .offset(x: -20, y: 5.0)
//    }
    
    var helpButton: some View {
    Button(action: {
        showingPopover = true
    })
        {Text("?")}
        .modifier(MenuButtonWithSymbolFont())
        .popover(isPresented: $showingPopover) {
            VStack(alignment: .leading){
                Group{
                    tipsText

                    dragText
                    toolsWhenZoomedInText
                    alwaysText
                    selectingText
                    whenChairSelectedText

                }
                .modifier(PopOverBodyFont())
                .lineSpacing(-5)
            }
        }
    }
    
    
    func sliderChairWidth(_ boundWidth: Binding<Double>) -> some View {
        Slider(value: boundWidth, in: 300.0...1000.0, step: 10)
            .onChange(of: proposedChairExternalWidthMeasurement) { value in
                vm.replacePartsInExistingChairManoeuvre(proposedChairExternalWidthMeasurement, .chairWidth)
            }
    }

    func sliderChairLength(_ boundLength: Binding<Double>) -> some View {
        Slider(value: boundLength, in: 500.0...2500.0, step: 10
        )
            .onChange(of: proposedChairLengthMeasurement) { value in
                vm.replacePartsInExistingChairManoeuvre(proposedChairLengthMeasurement, .chairLength)
        }
    }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass//    func getImageRequired() -> some View {
    
    var body: some View {
        let boundLength = Binding(
            get: {vm.getSelectedChairMeasurement(.chairLength)},
            set: {self.proposedChairLengthMeasurement = $0}
        )
        let boundWidth = Binding(
            get: {vm.getSelectedChairMeasurement(.chairWidth)},
            set: {self.proposedChairExternalWidthMeasurement = $0}
        )

        if menuChairViewModel.getShowMenuStatus() {
            BottomMenuView(MenuIcon.chairTool, 230) {
                VStack{
                    HStack {
                        sliderChairLength(boundLength)
                        Text("length \(Int( vm.getSelectedChairMeasurement(.chairLength))) mm")
                            .modifier(SliderTextFont())
                    }
                    .modifier(SliderAccentColor())
                    .padding([.leading, .trailing])
                    HStack {
                        sliderChairWidth(boundWidth)
                        Text("width: \(Int(vm.getSelectedChairMeasurement(.chairWidth))) mm")
                            .modifier(SliderTextFont())
                    }
                    .modifier(SliderAccentColor())
                    .padding([.leading, .trailing])
                    HStack{
                        AddManoeuvreOrInbetweenerView()
                        helpButton
                        Spacer()
                    }

                }
            }
        }
    }
    
}
