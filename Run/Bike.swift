import Foundation
import SwiftUI
import SwiftUICharts


struct Bike: View {

    var body: some View {
        BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly") // legend is optional
        Text("Bike")
    }

}