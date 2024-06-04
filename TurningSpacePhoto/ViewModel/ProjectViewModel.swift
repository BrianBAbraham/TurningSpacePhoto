//
//  ProjectViewModel.swift
//  turningSpace001
//
//  Created by Brian Abraham on 02/09/2022.
//
//
//import Foundation
//class ProjectVM: ObservableObject {
//    @Published private (set) var model: ProjectModel = ProjectModel()
//    
//    func getChairManoeuvreScale() -> Double {
//        model.chairsManoeuvreScale
//    }
//
//    func setChairManoeuvreScale(_ scale: Double) {
//        model.chairsManoeuvreScale = scale
//    }
//    
//    func setToScale(_ dimension: Double) -> Double{
//        dimension * model.chairsManoeuvreScale
//    }
//
//}
//
//struct Scale {
// var model: ProjectScaleModel = ProjectScaleModel()
//    
//    func getChairManoeuvreScale() -> Double {
//        ProjectScaleModel.chairsManoeuvreScale
//    }
//
//    mutating func setChairManoeuvreScale(_ scale: Double) {
//        model.setChairManeouvreScale(scale)
//    }
//    
//    func setToScale(_ dimension: Double) -> Double{
//        let scale = getChairManoeuvreScale()
//        return dimension * scale
//    }
//}
