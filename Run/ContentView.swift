import SwiftUI
import SwiftUICharts
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

        }



//        getTodaysSteps(completion: { (steps) in
//            print(steps)
//        })


    }


    var body: some View {

        TabView {
            Resume()
                    .tabItem {
                        Image(systemName: "heart.circle")
                        Text("Resume")
                    }
            Infos()
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("Infos")
                    }
        }
    }
}


struct Resume: View {

    let healthStore = HKHealthStore()

    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        _ = Date()
        //let startOfDay = Calendar.current.startOfDay(for: now)
        //let startOfDay = format.date(from: "2022-05-26T12:39:00Z")


        let date = Date()
        let startOfDay = Calendar.current.date(byAdding: .day, value: -2, to: date)!
        let end = Calendar.current.date(byAdding: .day, value: -1, to: date)!


        print("================")
        print(startOfDay)
        print("================")


        let predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: end,
                options: .strictStartDate
        )

        let query = HKStatisticsQuery(
                quantityType: stepsQuantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
        print(query)

    }


    func activitySummaryQuery() -> Array<Double> {
        var exerciseTime = Array<HKQuantity>()
        var lastWeekExerciseTime = Array<Int>()

        if #available(iOS 9.3, *) {
            let query = HKActivitySummaryQuery.init(predicate: nil) { (query, summaries, error) in
                let calendar = Calendar.current
                for summary in summaries! {
                    let dateComponents = summary.dateComponents(for: calendar)

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let date = dateComponents.date

                    print("Date: \(dateFormatter.string(from: date!)), Active Energy Burned: \(summary.activeEnergyBurned), Active Energy Burned Goal: \(summary.activeEnergyBurnedGoal)")
                    print("Date: \(dateFormatter.string(from: date!)), Exercise Time: \(summary.appleExerciseTime), Exercise Goal: \(summary.appleExerciseTimeGoal)")
                    print("Date: \(dateFormatter.string(from: date!)), Stand Hours: \(summary.appleStandHours), Stand Hours Goal: \(summary.appleStandHoursGoal)")
                    print("----------------")

                    exerciseTime.append(summary.appleExerciseTime)


                }

                for i in 1...7 {

                    let str = "\(exerciseTime[exerciseTime.count - i])"

                    lastWeekExerciseTime.append(Int(str.split(separator: " ")[0])!)
                }

                lastWeekExerciseTime.reverse()
                print(lastWeekExerciseTime)

            }
            healthStore.execute(query)
        }
        return lastWeekExerciseTime.map { Double($0) }
    }


    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {

                VStack {

                    Text("")
                            .padding(.vertical, 20)


                    HStack {
                        //PieChartView(data: , title: "Title", legend: "", style: Styles.barChartStyleNeonBlueDark)
                        BarChartView(data: ChartData(values: [("",1), ("2019 Q1", 50900), ("2019 Q2", 77550), ("2019 Q3", 79600), ("2019 Q4", 92550)]), title: "Exercice time", legend: "in minute") // legend is optional

                    }
                            .padding(.vertical, 15)

                    BarChartView(data: ChartData(points: activitySummaryQuery()), title: "Exercice Time", form: ChartForm.large)
                            .frame(height: 200)


                    MultiLineChartView(data: [(activitySummaryQuery(), GradientColors.green), ([90, 99, 78, 111, 70, 60, 77], GradientColors.purple), ([34, 56, 72, 38, 43, 100, 50], GradientColors.orngPink)], title: "Progession")


                    PieChartView(data: [8, 23, 44, 30, 2, 10], title: "Title", legend: "", style: Styles.barChartStyleNeonBlueDark)
                    MultiLineChartView(data: [([8, 32, 11, 23, 40, 28], GradientColors.green), ([90, 99, 78, 111, 70, 60, 77], GradientColors.purple), ([34, 56, 72, 38, 43, 100, 50], GradientColors.orngPink)], title: "Progession")
                    BarChartView(data: ChartData(values: [("2018 Q4", 63150), ("2019 Q1", 50900), ("2019 Q2", 77550), ("2019 Q3", 79600), ("2019 Q4", 92550)]), title: "Sales", legend: "Quarterly") // legend is optional

                }
            }
                    .navigationTitle("Resume Health Data")

        }

    }
}

struct Infos: View {
    var body: some View {
        VStack {
            Text("App created by: Clément Addario & Gabriel Cancel")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()


    }
}
