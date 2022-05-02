//
//  WorkoutManager.swift
//  Run WatchKit Extension
//
//  Created by Cancel Gabriel on 02/05/2022.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    var selectedWorkoout: HKWorkoutActivityType?
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKWorkoutBuilder?




}
    
