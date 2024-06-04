//
//  PictureScaleModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation
import SwiftUI

struct ChosenPhotoModel {
    var finalPhotoZoom: Double = 1.0
    var currentPhotoZoom: Double
    var chosenPhoto: Image?
    var chosenPhotoStatus = false
    var chosenPhotoLocation = SizeOf.centre
    var scalingCompleted = false
}
