//
//  Screen.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/04/2023.
//

import Foundation
import SwiftUI

struct Screen {
    
    static let safeAreaAlllowance = 50.0
   static let height = Double(UIScreen.main.bounds.height)
     - safeAreaAlllowance
   static let width = Double(UIScreen.main.bounds.width)
    - safeAreaAlllowance

    static let smallestDimension = [height, width].min() ?? height

}
  
