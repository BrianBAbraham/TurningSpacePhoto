//
//  ActionDismissStyle.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//
import SwiftUI

struct ActionDismissStyle: View {
    let color: Color
    var body: some View {
    Image(systemName: "xmark")
        .foregroundColor(color)
        .padding(.top, 5)
        .padding(.leading, 5)
    }
}

struct ActionNpDismissForUnscaledImageStyle: View {
    var body: some View {
        HStack{
            ActionDismissStyle(color: .gray)
            Text("Confirm plan dimension to dismiss")
                .modifier(MenuButtonTextFont())
        }
        .padding(.top, 5)
        .padding(.leading, 5)
    }
}

//struct ActionDismissStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        ActionDismissStyle()
//    }
//}
