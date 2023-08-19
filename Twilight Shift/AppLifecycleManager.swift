//
//  AppLifecycleManager.swift
//  Twilight Shift
//
//  Created by Krzysztof Lupa on 08/08/2023.
//

import SwiftUI
import Foundation
import Cocoa

class AppLifecycleManager: ObservableObject {
    @Published var appDidLaunch = false
    @StateObject var sliderData = SliderData()
    
    init() {
        setupAppOnLaunch()
    }
    
    func setupAppOnLaunch() {
        setBlueLightStrength(in: sliderData)
        let interval: TimeInterval = 600
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            setBlueLightStrength(in: self.sliderData)
        }
        appDidLaunch = true
    }
}
