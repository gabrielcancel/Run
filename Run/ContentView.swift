import SwiftUI
import HealthKit

struct ContentView: View {

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            let workoutType = HKObjectType.workoutType()

            //reading
            let readingTypes = Set([
                HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKSampleType.quantityType(forIdentifier: .height)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType(),
                HKObjectType.quantityType(forIdentifier: .stepCount)!
            ])


            if healthStore.authorizationStatus(for: workoutType) == .notDetermined {
                healthStore.requestAuthorization(toShare: nil, read: readingTypes) { (success, error) in
                    if success {
                        print("success")
                    } else {
                        print("error")
                    }
                }
            }

            let workout = HKWorkout(activityType: .running, start: Date(), end: Date(), duration: 0,
                    totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 0),
                    totalDistance: HKQuantity(unit: .meter(), doubleValue: 0),
                    metadata: [HKMetadataKeyIndoorWorkout: false])
            print(workout)



//            let sampleType2 = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
//
          
//            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
//            let sampleQuery = HKSampleQuery(sampleType: sampleType2, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
//
//                for result in results! {
//                    print("/===================Run=======================/")
//                    print(result)
//                    print("\\==========================================================\\\n")
//                }
//
//            }
//
//
//            let sortDescriptor = NSSortDescriptor(
//                    key: HKSampleSortIdentifierEndDate,
//                    ascending: false)
//
//            let heartRateType = HKSampleType.quantityType(forIdentifier: .heartRate)!
//            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, results, error) in
//                for result in results! {
//                    print("/=================HearthRate======================/")
//                    print(result)
//                    print("\\==========================================================\\\n")
//                }
//            }
//
//            healthStore.execute(sampleQuery)
//            healthStore.execute(query)



            func testActivitySummaryQuery() {
                //let exerciseTime = [HKObjectType]
                if #available(iOS 9.3, *) {
                    let query = HKActivitySummaryQuery.init(predicate: nil) { (query, summaries, error) in
                        let calendar = Calendar.current
                        for summary in summaries! {
                            let dateComponants = summary.dateComponents(for: calendar)

                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"

                            let date = dateComponants.date

                            print("Date: \(dateFormatter.string(from: date!)), Active Energy Burned: \(summary.activeEnergyBurned), Active Energy Burned Goal: \(summary.activeEnergyBurnedGoal)")
                            print("Date: \(dateFormatter.string(from: date!)), Exercise Time: \(summary.appleExerciseTime), Exercise Goal: \(summary.appleExerciseTimeGoal)")
                            print("Date: \(dateFormatter.string(from: date!)), Stand Hours: \(summary.appleStandHours), Stand Hours Goal: \(summary.appleStandHoursGoal)")
                            print("Date: \(dateFormatter.string(from: date!)), Activity Move time: \(summary.appleMoveTime) , Activity Move time Goal: \(summary.appleMoveTimeGoal)")
                            print("----------------")

                            //exerciseTime.append(summary.appleExerciseTime)



                        }
                    }
                    healthStore.execute(query)
                } else {
                    // Fallback on earlier versions
                }

                //print(exerciseTime)

            }

            testActivitySummaryQuery()


        }


    }

    var body: some View {


        NavigationView {
            VStack {
                NavigationLink(destination: Run()) {
                    Text("\nRun")
                }
                        .navigationTitle("")

                NavigationLink(destination: Bike()) {
                    Text("\nBike")
                }


                NavigationLink(destination: Walk()) {
                    Text("\nWalk")
                }


            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
