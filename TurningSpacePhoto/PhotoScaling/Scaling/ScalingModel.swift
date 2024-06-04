//
//  ConfirmScaleButtonModel.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//

import Foundation


struct ScalingModel {
    var buttonIsDisabled = true
    var scalingCompleted = false
    var showScalingTool: Bool {
        buttonIsDisabled || scalingCompleted
    }
    var scale = 1.0

}
