import SwiftUI
import SwiftUICharts

struct ContentView: View {

    var body: some View {


        List {

            Text("Fréquence de rythme cardiaque")

            Text("Temps moyen de marche")

            Text("Calories dépensés")

            Text(" .... ")
            
            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Progession")

        }
    }
}
