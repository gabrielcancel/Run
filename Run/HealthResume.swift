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

class Resume_Data {
    var exerciseTime = Array<HKQuantity>()
    var energyBurned = Array<HKQuantity>()
    var standsHours = Array<HKQuantity>()
    static var lastWeekExerciseTime = Array<Int>()
    static var lastWeekEnergyBurned = Array<Int>()
    static var lastWeekStandHours = Array<Int>()
    static var lastWeekSteps = Array<Int>()
}

class Days {

    static var j7: Double = 0
    static var j6: Double = 0
    static var j5: Double = 0
    static var j4: Double = 0
    static var j3: Double = 0
    static var j2: Double = 0
    static var j1: Double = 0
}

struct Resume: View {


    var resume = Resume_Data()

    let healthStore = HKHealthStore()


    func getStepsCount(forSpecificDate: Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = getWholeDate(date: forSpecificDate)

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }

        healthStore.execute(query)

    }

    func getWholeDate(date: Date) -> (startDate: Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate: Date = startDate.addingTimeInterval(length)
        return (startDate, endDate)
    }


    func activitySummaryQuery() -> Array<Double> {


        let query = HKActivitySummaryQuery(predicate: nil) { (query, summaries, error) in
            for summary in summaries! {
                //print("Date: \(dateFormatter.string(from: date!)), Active Energy Burned: \(summary.activeEnergyBurned), Active Energy Burned Goal: \(summary.activeEnergyBurnedGoal)")
                //print("Date: \(dateFormatter.string(from: date!)), Exercise Time: \(summary.appleExerciseTime), Exercise Goal: \(summary.appleExerciseTimeGoal)")
                //print("Date: \(dateFormatter.string(from: date!)), Stand Hours: \(summary.appleStandHours), Stand Hours Goal: \(summary.appleStandHoursGoal)")
                //print("----------------")
                resume.exerciseTime.append(summary.appleExerciseTime)
                resume.energyBurned.append(summary.activeEnergyBurned)
                resume.standsHours.append(summary.appleStandHours)
            }

            Resume_Data.lastWeekExerciseTime.reverse()
            Resume_Data.lastWeekEnergyBurned.reverse()
            Resume_Data.lastWeekStandHours.reverse()


            for i in 1...7 {

                let strExercise = "\(resume.exerciseTime[resume.exerciseTime.count - i])"
                Resume_Data.lastWeekExerciseTime.append(Int(strExercise.split(separator: " ")[0])!)

                let strEnergy = "\(resume.energyBurned[resume.energyBurned.count - i])"
                Resume_Data.lastWeekEnergyBurned.append(Int(strEnergy.split(separator: " ")[0].split(separator: ".")[0])!)

                let strStand = "\(resume.standsHours[resume.standsHours.count - i])"
                Resume_Data.lastWeekStandHours.append(Int(strStand.split(separator: " ")[0].split(separator: " ")[0])!)

                print("strEnergy: \(strEnergy.split(separator: " ")[0]), strStand: \(strStand)")
            }


            DispatchQueue.main.async {

//                Days.j1 = Double(Resume_Data.lastWeekExerciseTime[0])
//                Days.j2 = Double(Resume_Data.lastWeekExerciseTime[1])
//                Days.j3 = Double(Resume_Data.lastWeekExerciseTime[2])
//                Days.j4 = Double(Resume_Data.lastWeekExerciseTime[3])
//                Days.j5 = Double(Resume_Data.lastWeekExerciseTime[4])
//                Days.j6 = Double(Resume_Data.lastWeekExerciseTime[5])
//                Days.j7 = Double(Resume_Data.lastWeekExerciseTime[6])

                print("==== INTO THE MAIN QUEUE ==== ")

                print("Resume_Data.lastWeekExerciseTime: \(Resume_Data.lastWeekExerciseTime)")
                getStepsCount(forSpecificDate: Date()) { (steps) in
                    if steps == 0.0 {
                        print("steps :: \(steps)")
                    }
                    else {
                        DispatchQueue.main.async {
                            print("steps : \(steps)")

                        }
                    }
                }
                print("Resume_Data.lastWeekEnergyBurned: \(Resume_Data.lastWeekEnergyBurned)")

                print("Resume_Data.lastWeekStandHours: \(Resume_Data.lastWeekStandHours)")
                //print([Days.j1, Days.j2, Days.j3, Days.j4, Days.j5, Days.j6, Days.j7])

                //print("==== OUT OF THE MAIN QUEUE ==== ")


            }
        }


        healthStore.execute(query)

        print("====Days.j1====")
        print(Days.j1)
        print("===============\n")


        do {

            print("====DO=====")
            print(Days.j1)

            print("===========")
            if Resume_Data.lastWeekExerciseTime.count == 0 {
                print(Resume_Data.lastWeekExerciseTime)
                return [12, 42, 13, 24, 3, 44, 19]
            } else {
                print(Resume_Data.lastWeekExerciseTime.map {
                    Double($0)
                })
//                return Resume_Data.lastWeekExerciseTime.map {
//                    Double($0)
//                }
            }
        }

        return []
    }




//    let res = activitySummaryQuery()
//        days.j1 = res[0]
//        days.j2 = res[1]
//        days.j3 = res[2]
//        days.j4 = res[3]
//        days.j5 = res[4]
//        days.j6 = res[5]
//        days.j7 = res[6]
//
//        print(res)


    var body: some View {

        let exerciseTime = activitySummaryQuery()
        NavigationView {
            ScrollView(showsIndicators: false) {

                VStack {

                    Text("")
                            .padding(.vertical, 20)


                    HStack {
                        VStack{
                            Text("M'entraîner")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)

                            Text("En heure")
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .padding(.bottom, 5)

                        }
                                .offset(x: -55)


                        VStack{
                            Text("Bouger")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)

                            Text("En Kcal")
                                    .font(.title3)
                                    .fontWeight(.light)
                                    .padding(.bottom, 5)

                        }
                                .offset(x: 35)

                    }
                    HStack {
                        let barChartStyle1 = ChartStyle(backgroundColor: Color.white, accentColor: Colors.LegendColor, secondGradientColor: Colors.OrangeEnd, textColor: Color.black, legendTextColor: Colors.LegendDarkColor, dropShadowColor: Color.gray )
                        let barChartStyle2 = ChartStyle(backgroundColor: Color.white, accentColor: Colors.OrangeEnd, secondGradientColor: Colors.LegendColor, textColor: Color.black, legendTextColor: Colors.LegendDarkColor, dropShadowColor: Color.gray )


                        BarChartView(data: ChartData(values: [("J-7", exerciseTime[0]), ("J-6", exerciseTime[1]),
                                                              ("J-5", exerciseTime[2]), ("J-4", exerciseTime[3]),
                                                              ("J-3", exerciseTime[4]), ("J-2", exerciseTime[5]),
                                                              ("J-1", exerciseTime[6])]),
                                title: "M'entraîner", legend: "En minute", style: barChartStyle1)

                        BarChartView(data: ChartData(values: [("J-7", 132), ("J-6", 434),
                                                              ("J-5", 393), ("J-4", 445),
                                                              ("J-3", 230), ("J-2", 93),
                                                              ("J-1", 263)]),
                                title: "Bouger", legend: "En KCal", style: barChartStyle2)

                    }
                            .padding(.vertical, 15)

                    Text("Me lever")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 10)

                    Text("En minutes")
                            .font(.title3)
                            .fontWeight(.light)
                            .padding(.bottom, 5)

                    let meLeverStyle = ChartStyle(backgroundColor: Color.white, accentColor: Colors.IndicatorKnob, secondGradientColor: Colors.LegendColor, textColor: Color.black, legendTextColor: Colors.LegendDarkColor, dropShadowColor: Color.gray )

                    BarChartView(data: ChartData(points: [3, 12, 11, 16, 11, 1, 9]), title: "Me lever",legend: "En heure", style: meLeverStyle, form: ChartForm.extraLarge)
                            .frame(height: 200)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 30)


                    Text("Nombres de pas")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 15)

                    Text("Sur la semaine")
                            .font(.title3)
                            .fontWeight(.light)
                            .padding(.bottom, 5)

                    let chartStyle = ChartStyle(backgroundColor: Color.white, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.black, legendTextColor: Color.orange, dropShadowColor: Color.gray )
                    PieChartView(data: [1797, 10000], title: "Nombre de pas quotidien", legend: "", style: chartStyle, dropShadow: true)
                            .padding(.vertical, 20)

                }

                    Text("À venir ...")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                            .padding(.vertical, 20)

                Text("Comparaison du rythme cardique")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 15)

                Text("Sur 3 jours")
                        .font(.title3)
                        .fontWeight(.light)
                        .padding(.bottom, 5)

                MultiLineChartView(data: [([8, 32, 11, 23, 40, 28], GradientColors.green), ([90, 99, 78, 111, 70, 60, 77], GradientColors.purple), ([34, 56, 72, 38, 43, 100, 50], GradientColors.orngPink)], title: "         🩺 🫀")



            }
                    .navigationTitle("Resume Health Data")

        }

    }
}

struct Infos: View {
    var body: some View {
        ZStack {
            Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)).ignoresSafeArea()


            VStack {
                Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 44, height: 44)
                Text("Clément Addario").bold()
                Text("Gabriel Cancel").bold()
                Capsule()
                        .frame(height: 44)
                        .overlay(Text("Sign up")
                                .foregroundColor(.black))
                        .foregroundColor(.white)

            }
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 1)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()


    }
}
