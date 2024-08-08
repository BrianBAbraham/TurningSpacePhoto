//
//  ObjectAndPartEditMenuContainerView.swift
//  CreateObject
//
//  Created by Brian Abraham on 19/07/2024.
//

import SwiftUI
import Combine

struct ObjectAndPartEditMenuContainerView: View {
   
    
    var body: some View {
     
            ZStack{
                VStack (alignment: .leading) {
                    
                    HStack{
                        MovementPickerView()
                        
                        ObjectPickerView()
                        
                        PartPickerView()
                    }
                    
                    PartOriginAndDimensionEditContainerView()
                    
                }
            }
            .padding(.horizontal)
            .backgroundModifier()
            .transition(.move(edge: .bottom))
    }
}


class MenuForObjectEditViewModel: ObservableObject {
    @Published var showMenu = BottomMenuDisplayService.shared.showObjectEditMenu
    
    
    internal var cancellables: Set<AnyCancellable> = []
    
    init () {
        BottomMenuDisplayService.shared.$showObjectEditMenu
            .receive(on: DispatchQueue.main)
            .assign(to: \.showMenu,on: self)
            .store(in: &cancellables)
    }
}
