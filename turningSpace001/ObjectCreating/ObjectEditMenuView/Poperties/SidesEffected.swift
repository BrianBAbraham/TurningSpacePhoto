//
//  SidesEffected.swift
//  turningSpace001
//
//  Created by Brian Abraham on 27/06/2024.
//

import Foundation

enum SidesAffected: String, CaseIterable, Equatable {
    case both = "L&R"
    case left = "L"
    case right = "R"
    case none = "none"
    
    
    func getOneId() -> PartTag {
        switch self {
        case .both:
            return .id0
        case .left:
            return .id0
        case .right:
            return .id1
        case .none:
            fatalError("sides required but none exists")
        }
    }
    
    func asArray() -> [SidesAffected] {
        switch self {
        case .both:
            return [.both, .left, .right]
        case .left:
            return [.left]
        case .right:
            return [.right]
        case .none:
            return [.none]
        }
    }
}
