//
//  VerticalSliderView.swift
//  Twilight Shift
//
//  Created by Krzysztof Lupa on 06/08/2023.
//

import SwiftUI
import Foundation
import Cocoa


struct VerticalSliderView: View {
    @ObservedObject var sliderData: SliderData
    @State private var currentHour: Int = 0
    @State private var currentMinute: Int = 0
    @State private var currentTimeXPos: CGFloat = 0
    
    init(sliderData: SliderData) {
        self.sliderData = sliderData
        _currentHour = State(initialValue: Calendar.current.component(.hour, from: Date()))
        _currentMinute = State(initialValue: Calendar.current.component(.minute, from: Date()))
    }
    
    private func updateTimePosition(in geometry: GeometryProxy) {
        currentHour =  Calendar.current.component(.hour, from: Date())
        currentMinute = Calendar.current.component(.minute, from: Date())
        let xPos1 = geometry.size.width / CGFloat(sliderData.sliderValues.count + 1)
        let currentHourOffset = CGFloat(currentHour + 1)
        let currentMinuteOffset = CGFloat(currentMinute) / CGFloat(60)
        let xPos2 = xPos1 * (currentHourOffset + currentMinuteOffset)
        currentTimeXPos = xPos2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Path { path in
                    let xPos = currentTimeXPos
                    path.move(to: CGPoint(x: xPos, y: 65))
                    path.addLine(to: CGPoint(x: xPos, y: geometry.size.height-210))
                }
                .stroke(Color.red, lineWidth: 3)
                /*
                Path { path in
                    for index in 0..<sliderData.sliderValues.count {
                        let xPos = geometry.size.width / CGFloat(sliderData.sliderValues.count + 1) * CGFloat(index + 1)
                        let yPos = (geometry.size.height / 2 - CGFloat(sliderData.sliderValues[index]) * (geometry.size.width / CGFloat(sliderData.sliderValues.count + 1))) * 4.4
                        let point = CGPoint(x: xPos, y: yPos)
                        if index == 0 {
                            path.move(to: point)
                        } else {
                            let previousXPos = geometry.size.width / CGFloat(sliderData.sliderValues.count + 1) * CGFloat(index)
                            let previousYPos = (geometry.size.height / 2 - CGFloat(sliderData.sliderValues[index - 1]) * (geometry.size.width / CGFloat(sliderData.sliderValues.count + 1))) * 4.4
                            let controlPointX1 = previousXPos + (xPos - previousXPos) * 0.25
                            let controlPointY1 = previousYPos
                            let controlPointX2 = previousXPos + (xPos - previousXPos) * 0.5
                            let controlPointY2 = previousYPos
                            let controlPointX3 = xPos - (xPos - previousXPos) * 0.25
                            let controlPointY3 = yPos
                            path.addQuadCurve(to: point, control: CGPoint(x: controlPointX1, y: controlPointY1))
                            path.addQuadCurve(to: point, control: CGPoint(x: controlPointX2, y: controlPointY2))
                            path.addQuadCurve(to: point, control: CGPoint(x: controlPointX3, y: controlPointY3))
                        }
                    }
                }
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(y: -geometry.size.height * 1.325)
                */
                
                ForEach(0..<sliderData.sliderValues.count, id: \.self) { index in
                    VStack {
                        Text("\(hourLabel(for: index))")
                            .font(.system(size: 10))
                            .font(.headline)
                            .padding(.bottom, 80)
                            .rotationEffect(.degrees(-45))
                            .offset(x: 35, y: 0)
                        
                        Slider(value: Binding(
                            get: { sliderData.sliderValues[index] },
                            set: { newValue in
                                sliderData.sliderValues[index] = newValue
                                sliderData.saveSliderValues()
                            }
                        ))
                        .rotationEffect(.degrees(-90))
                        .frame(height: geometry.size.width / CGFloat(sliderData.sliderValues.count + 1))
                        .padding(.horizontal, 7)
                        .tint(Color(red: 0.6, green: 0.8, blue: 1.0))
                        .onChange(of: sliderData.sliderValues[index]) { newValue in
                            setBlueLightStrength(in:sliderData)
                        }
                    }
                    .frame(width: geometry.size.height-90)
                    .position(x: geometry.size.width / CGFloat(sliderData.sliderValues.count + 1) * CGFloat(index + 1),
                              y: (geometry.size.height / 2) * 0.8) // Adjust the Y position by 30%
                }
            }
            .onAppear {
                updateTimePosition(in: geometry)
                let interval: TimeInterval = 600
                Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    updateTimePosition(in: geometry)
                }
                
            }
            .onChange(of: currentHour) { _ in
                updateTimePosition(in: geometry)
            }
        }
    }
    
    func hourLabel(for index: Int) -> String {
        let hour = index % 24
        return String(format: "%02d:00", hour)
    }
}

struct VerticalSliderView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSliderView(sliderData: SliderData())
    }
}
