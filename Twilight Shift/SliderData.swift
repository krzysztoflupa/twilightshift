//
//  SliderData.swift
//  Twilight Shift
//
//  Created by Krzysztof Lupa on 06/08/2023.
//

import Foundation

class SliderData: ObservableObject {
    @Published var sliderValues: [Double] = Array(repeating: 0.5, count: 24)
    
    init() {
        loadSliderValues()
    }
    
    func saveSliderValues() {
        UserDefaults.standard.set(sliderValues, forKey: "SliderValuesKey")
    }
    
    func loadSliderValues() {
        if let savedValues = UserDefaults.standard.array(forKey: "SliderValuesKey") as? [Double] {
            sliderValues = savedValues
        }
    }
}
