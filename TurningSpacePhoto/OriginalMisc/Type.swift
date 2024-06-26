//
//  Type.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//

import Foundation
struct Type {
    typealias ChairMovementsParts =
    (chair: ChairManoeuvre.Chair, movements: [ChairManoeuvre.Movement], parts: [ChairManoeuvre.Part])
    
    typealias ChairMovementParts = (chair: ChairManoeuvre.Chair, movement: ChairManoeuvre.Movement, parts: [ChairManoeuvre.Part])
    
    typealias PartsDictionary = [String: [String: Double]]
}
