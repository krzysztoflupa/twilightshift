//
//  Twilight_ShiftApp.swift
//  Twilight Shift
//
//  Created by Krzysztof Lupa on 29/07/2023.
//
//
import SwiftUI
import Foundation
import Cocoa

@main
struct swiftui_menu_barApp: App {
    @StateObject var sliderData = SliderData()
    @StateObject private var appLifecycleManager = AppLifecycleManager()

    var body: some Scene {
        MenuBarExtra {
            let sliderData = SliderData()
            VStack{
                HStack {
                    Text("App allows you to adjust night-shift mode smoothly based on time").padding(.leading, 20)
                    
                    Spacer()
                    Button("Buy author the coffee", action: {
                        if let url = URL(string: "https://www.buymeacoffee.com/lovecoffe") {
                            NSWorkspace.shared.open(url)
                        }
                    })

                    Button("Mail", action: {
                        let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
                        service.recipients = ["twilight.shift.manager@gmail.com"]
                        service.subject = "Dear Kris, I deeply admire and appreciate everything you are doing"
                        service.perform(withItems: ["Hi Kris, Your efforts and contributions are truly remarkable, and I cannot express enough how much I value your work. Thank you for all that you do."])
                        
                    })
                    Button("Quit", action: {
                        exit(0)
                    })
                    .padding(.trailing, 20)
                }.padding(.top, 50)
                
                VerticalSliderView(sliderData: sliderData)
                    .frame(height: 250)
                    .offset(x: 0, y: -30)
            }.frame(width: 740,height: 260)
        }
    label: {
            Image("lamp28")
        }.menuBarExtraStyle(.window)
    }
}


func setBlueLightStrength(in sliderData: SliderData) {
    let client = CBBlueLightClient()
    client.setEnabled(true)
    let currentTime = Date()
    let estimatedValue = calculateEstimatedNightShiftValue(for: currentTime, in: sliderData)
    client.setStrength(estimatedValue, commit: true)
}

func calculateEstimatedNightShiftValue(for currentTime: Date, in sliderData: SliderData) -> Float {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: currentTime)
    guard let hour = components.hour, let minute = components.minute else {
        return 0.5
    }
    
    var godzinaZero = hour + 1
    if godzinaZero == 24 {
        godzinaZero = 0
    }
    
    let estimatedValueMin = sliderData.sliderValues[hour]
    let estimatedValueMax = sliderData.sliderValues[godzinaZero]
    let percentage = Double(minute) / 60.0
    let estimatedValueBetween = (1 - percentage) * estimatedValueMin + percentage * estimatedValueMax
    return Float(estimatedValueBetween)
}
