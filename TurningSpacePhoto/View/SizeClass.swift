//
//  SizeClass.swift
//  turningSpace001
//
//  Created by Brian Abraham on 13/10/2022.
//

import SwiftUI

struct SizeClass: View {
        @Environment(\.horizontalSizeClass) var horizontalSizeClass

        var body: some View {
            if horizontalSizeClass == .compact {
                Text("Compact")
            } else {
                Text("Regular")
            }
        }
}

struct SizeClass_Previews: PreviewProvider {
    static var previews: some View {
        SizeClass()
    }
}
