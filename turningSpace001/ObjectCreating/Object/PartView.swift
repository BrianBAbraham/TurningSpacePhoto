//
//  PartView.swift
//  CreateObject
//
//  Created by Brian Abraham on 29/07/2024.
//

import SwiftUI

struct PartView: View {
    @ObservedObject var vm: PartViewModel
    var body: some View {
        ZStack {
            vm.path()
                .fill(vm.color)
                .opacity(vm.opacity)
            
            vm.path()
                .stroke(Color.black, lineWidth: vm.lineWidth)
        }
    }
}
