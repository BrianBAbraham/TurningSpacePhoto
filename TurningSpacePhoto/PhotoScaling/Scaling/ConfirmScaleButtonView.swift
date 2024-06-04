//
//  ConfirmScaleButtonView.swift
//  FirstDraft2_5_22
//
//  Created by Brian Abraham on 02/05/2022.
//
import SwiftUI

struct ConfirmScaleButtonView: View {

    @EnvironmentObject  var confirmScaleButtonViewModel: ConfirmScaleButtonViewModel
        
    var body: some View {
        Button(action: {
        
           confirmScaleButtonViewModel.setScalingCompleted()
            
        }) {Text(" Go ") }
            .buttonStyle(PictureScaleBlueButton())
            .opacity(confirmScaleButtonViewModel.notShowing ? 0.1: 1.0)
            .modifier(MenuButtonWithTextFont())
            .disabled(confirmScaleButtonViewModel.notShowing)
    }
}


import Combine

class ConfirmScaleButtonViewModel: ObservableObject {
   
    @Published private (set) var notShowing = true

    private let mediator = ShowScalingDimensionSelectorMediator.shared
    private var cancellables: Set<AnyCancellable> = []
    init() {

        
        ShowViewService.shared.$scalingDimensionSelectorView
            .sink { [weak self] newData in
                self?.notShowing = newData
        }
        .store(in: &cancellables)
    }
    

    func setScalingCompleted(){
       
        ScaleService.shared.setScalingCompleted()
    }
}


class ShowScalingDimensionSelectorMediator {
    
    static let shared = ShowScalingDimensionSelectorMediator()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private (set) var notShowing = true
    private var scalingCompleted = ScaleService.shared.scalingCompleted
    private var photoStatus = PhotoService.shared.photoStatus
 
    init() {
      
        //other processes may set scalingCompleted
        ScaleService.shared.$scalingCompleted
            .sink { [weak self] newData in
                self?.scalingCompleted = newData
                self?.setShowing()
                
        }
        .store(in: &cancellables)
        
        PhotoService.shared.$photoStatus
            .sink { [weak self] newData in
                self?.photoStatus = newData
                self?.setShowing()
               
        }
        .store(in: &cancellables)
    }
    
    func setShowing()  {
        if photoStatus == true && scalingCompleted == false {
            notShowing = false
        } else {
            notShowing = true
        }
        ShowViewService.shared.setScalingDimensionSelectorView(notShowing)
    }
    
}
