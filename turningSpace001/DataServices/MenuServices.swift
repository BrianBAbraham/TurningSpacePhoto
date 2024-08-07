//
//  MenuServices.swift
//  turningSpace001
//
//  Created by Brian Abraham on 07/08/2024.
//

import Foundation

class RightSideMenuDisplayService {
    static let shared = RightSideMenuDisplayService()
    
    @Published var showRightSideMenu = true

    func setShowRightSideMenuFalse() {
        showRightSideMenu = false
    }
    

    func setShowRightSideMenuTrue() {
        showRightSideMenu = true
    }
    

    
    func setShowRightSideMenu(_ value: Bool) {
        showRightSideMenu = value
    }
}


class BottomMenuDisplayService {
    static let shared = BottomMenuDisplayService()
    
    @Published var showPhotoMenu = false
    @Published var showChairMenu = false
    @Published var preventPhotoMenuDimsiss = false
    
    
    func setShowPhotoMenuFalse() {
        showPhotoMenu = false
    }
    
    
    func setShowChairMenuFalse() {
        showChairMenu = false
    }
    
    
    func setShowPhotoMenu(_ value: Bool) {
        showPhotoMenu = value
    }
    
    func setShowPhotoMenuTrue() {
        showPhotoMenu = true
    }
    
    func setShowChairMenu(_ value: Bool) {
        showChairMenu = value
    }
    
    
    func setPreventPhotoMenuDismissFalse() {
        preventPhotoMenuDimsiss = false
    }
    
    
    func setPreventPhotoMenuDismissTrue() {
        preventPhotoMenuDimsiss = true
    }
    
    
    func setShowChairMenuTrue() {
        showChairMenu = true
    }
    
    
    func toggleShowChairMenu() {
        showChairMenu.toggle()
    }
}

