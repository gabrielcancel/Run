//
//  ContentView.swift
//  Run
//
//  Created by Cancel Gabriel on 29/04/2022.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var body: some View {
        Button(action: {
                    if HKHealthStore.isHealthDataAvailable() {
                        let healthStore = HKHealthStore()
                        let workoutType = HKObjectType.workoutType()

                        //reading
                        let readingTypes = Set([workoutType])
                        //writing
                        let writingTypes = Set([ workoutType])
                        //auth request
                        healthStore.requestAuthorization(toShare: writingTypes, read: readingTypes) { (success, error) -> Void in

                            if error != nil {
                                print("error \(String(describing: error?.localizedDescription))")
                            } else if success {
                                print("success")
                                //                    self.startButton.setEnabled(true)
                            } else if !success {
                                print("fail")

                                //                    self.startButton.setEnabled(false)
                            }
                        }
                    }
                }) {
                    Text("Button")
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
