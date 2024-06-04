//
//  ViewModifier.swift
//  turningSpace001
//
//  Created by Brian Abraham on 20/10/2022.
//

import SwiftUI

//struct ForInitialImageSize: ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//
//        }
//}

extension Image {
    //Must be applied both to image in select photo and to the that image when saved as a background or scaling is wrong
    func initialImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: SizeOf.screenWidth, height: SizeOf.screenHeight)
    }
}




struct ConditionalChairSelectedMenuButtonWithSymbol: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    var grayOut: Color {
        vm.getIsAnyChairSelected() ? .blue: .gray
    }
    func body(content: Content) -> some View {
        content
            .foregroundColor(grayOut)
            .modifier(MenuButtonWithSymbolFont())
    }
}

struct ConditionalThreeMovmentMenuButtonTextFont: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    var grayOutButton: Bool {
        var midwayChairExists = false
        if vm.getIsAnyChairSelected() {
          let chairIndex = vm.getSelectedChairIndexAfterEnsuringThatOneChairIsSelected()
            midwayChairExists = vm.model.chairManoeuvres[chairIndex].movements.count == 3 ? true: false
        }
        return midwayChairExists
    }
    func body(content: Content) -> some View {
        content
            .foregroundColor(grayOutButton ? .blue: .gray)
            .modifier(MenuButtonWithSymbolFont())
    }
}

struct ConditionalChairSelectedMenuButtonTextFont: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    var grayOut: Color {
        vm.getIsAnyChairSelected() ? .black: .gray
    }
    func body(content: Content) -> some View {
        content
            .foregroundColor(grayOut)
            .modifier(MenuButtonTextFont())
    }
}

struct ConditionalMenuButtonWithTextFont: ViewModifier {
    let status: Bool
    func body(content: Content) -> some View {
        content
            .modifier(MenuButtonWithTextFont())
            .opacity(status ? 1: 0.3)
    }
}

struct MenuButtonWithRedTextFont: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    func body(content: Content) -> some View {
        content
            .font(horizontalSizeClass == .compact ? .footnote: .subheadline )
            .foregroundColor(.red)
    }
}

struct MenuButtonWithTextFont: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    func body(content: Content) -> some View {
        content
            .font(horizontalSizeClass == .compact ? .body: .body )
            .foregroundColor(.blue)
    }
}

struct MenuButtonWithSymbolFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.blue)
    }
}

struct MenuButtonTextFont: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.black)
    }
}



struct PopOverBodyFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .padding()
    }
}

struct PopOverTitleFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .multilineTextAlignment(.leading)
//            .frame(alignment: .leading)
    }
}

struct SliderAccentColor: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    var grayOutSlider: Color {
        vm.getIsAnyChairSelected() ? .blue: .gray
    }
    func body(content: Content) -> some View {
        content
            .accentColor(grayOutSlider)
    }
}

struct SliderTextFont: ViewModifier {
    @EnvironmentObject var vm: ChairManoeuvreProjectVM
    var grayOutSlider: Color {
        vm.getIsAnyChairSelected() ? .black: .gray
    }
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(grayOutSlider)
    }
}


    
