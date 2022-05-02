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
    var builder: HKLiveWorkoutBuilder?

    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) {(success, error) in
            // Workout started
        }
    }


}
    

