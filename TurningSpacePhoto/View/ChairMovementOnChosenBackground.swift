//
//  ChairMovementOnChosenBackground.swift
//  TurningSpacePhoto
//
//  Created by Brian Abraham on 24/06/2024.
//

import SwiftUI

struct ChairMovementOnChosenBackground: View {
    @EnvironmentObject var chairManoeuvreProjectVM: ChairManoeuvreProjectVM
   
    let zoom: Double
    
    init(_ zoom: Double) {
        self.zoom = zoom
        
    }
    
    var arrayOfForEachMovementOfOneChairArrayChairMovementPart:  [(chairIndex: Int, chairMovementsParts: [Type.ChairMovementParts])] {
        chairManoeuvreProjectVM.getForEachMovementOfOneChairArrayChairMovementPart()
    }

    var body: some View {
        ZStack{
          ChosenPhotoView()
             
            VStack{
                ForEach( arrayOfForEachMovementOfOneChairArrayChairMovementPart, id: \.chairIndex) { item in
                    ChairMovementsView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                    TurnHandleConditionalView(forEachMovementOfOneChairArrayChairMovementPart: item.chairMovementsParts)
                }
            }
        }
        .scaleEffect(zoom)
    }
}
