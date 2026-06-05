//
//  ContentView.swift
//  Water Tracker
//
//  Created by Eren on 04.06.26.
//

import SwiftUI

struct ContentView: View {
    
    private let waterKey = "waterIntake"
    @State private var waterIntake: Double = 0
    private let dailyGoal = 2000
    private let dateKey = "lastDate"
    @State private var waveOffSet = Angle(degrees: 0)
    
    var body: some View {
        ZStack{
            Wave(offSet: waveOffSet, percent: progress * 100)
                .fill(Color.blue)
                .ignoresSafeArea(.all)
                .onAppear{
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)){
                        self.waveOffSet = Angle(degrees: 360)
                    }
                }
            
            VStack {
                Text("🚰 Water Tracker")
                    .font(.largeTitle)
                    .bold()
                Text("\(Int(waterIntake)) ml / \(dailyGoal) ml")
                    .font(.title2)
                ProgressView(value: progress)
                    .tint(.blue)
                    .scaleEffect(0.9)
                    .padding()
                Spacer()
                
                Button("Add 250ml"){
                    waterIntake += 250
                    UserDefaults.standard.set(waterIntake, forKey: waterKey)
                    UserDefaults.standard.set(Date(), forKey: dateKey)
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(30)
                
                Button("Remove 250ml"){
                    waterIntake = max(0, waterIntake - 250)
                    UserDefaults.standard.set(waterIntake, forKey: waterKey)
                    UserDefaults.standard.set(Date(), forKey: dateKey)
                }
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .cornerRadius(30)
                Spacer()
            }
            .padding()
        }
        
    }
    init() {
        let savedValue = UserDefaults.standard.integer(forKey: waterKey)
        _waterIntake = State(initialValue: Double(savedValue))
        let savedDate = UserDefaults.standard.object(forKey: dateKey) as? Date ?? Date.distantPast
        if isSameDay(savedDate, Date()) {
            _waterIntake = State(initialValue: 0)
        }
    }
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    var progress: Double{
        min(Double(waterIntake) / Double(dailyGoal), 1.0)
    }
}

#Preview {
    ContentView()
}
