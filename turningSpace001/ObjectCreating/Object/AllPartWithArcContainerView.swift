//
//  ObjectView.swift
//  CreateObject
//
//  Created by Brian Abraham on 10/04/2023.
//

import SwiftUI



//
//enum ObjectDisplayStyle {
//    case movement
//    case edit
//}


struct AllPartWithArcContainerView: View {
    @EnvironmentObject var vm: AllPartWithArcContainerViewModel

    let displayStyle: ObjectDisplayStyle
    
    var body: some View {
        ZStack{
            AllPartView(displayStyle: displayStyle)
            
//                ForEach(uniqueArcPointNames, id: \.self) { name in
//                    ArcPointView(
//                        position: dictionaryForScreen[name]
//                    )
//                }
                
            AllArcWithStaticPointView()

            }
            .modifier(
                ForObjectDrag (
                    frameSize: vm.onScreenMovementFrameSize, active: true)
            )
    }
}



























    

