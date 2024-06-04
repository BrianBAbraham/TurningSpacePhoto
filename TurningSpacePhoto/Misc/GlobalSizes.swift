//
//  ScreenSize.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import SwiftUI
import UIKit

struct SizeOf {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static var centre: CGPoint  {
        CGPoint(x: screenWidth/2, y: screenHeight/2)
    }

    static let tool: Double = 300.0
    static let fontProportionOfTool = 2.0/3.5
    static let selectedOpacity = 0.9
    static let unSelectedOpacity = 0.2
    static var zoomScale = 1.0
    
}
