import Foundation
import SwiftUI
import SwiftUICharts
import HealthKit

let healthStore = HKHealthStore()


struct Run: View {


    var body: some View {
        LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")

    }

}
