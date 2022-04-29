import SwiftUI

struct ContentView: View {

    var body: some View {

        NavigationView {

            NavigationLink(destination: Heartbeat()) {
                Text("Fréquence de rythme cardiaque")
            }
                    .navigationTitle("Fréquence de rythme cardiaque")

            NavigationLink(destination: Heartbeat()) {
                Text("Temps moyen de marche")
            }

            NavigationLink(destination: Heartbeat()) {
                Text("Calories dépensées")
            }


        }
    }
}

