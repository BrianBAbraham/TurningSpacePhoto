//
//  DefaultMeasurements.swift
//  turningSpace001
//
//  Created by Brian Abraham on 27/09/2022.
//

import Foundation
struct DefaultMeasurements {
    
    static func wheelchair(_ measurement: ChairMeasurements)->Double {
        switch measurement {
        case .chairLength:
            return 1200.0
        case .chairWidth:
            return 650.0
        case .footPlateWidth:
            return 150.0
        case .seatDepth:
            return 500.0
        case .wheelLength:
            return 600.0
        }
    }
}
