import SwiftUI

struct ContentView: View {

    var body: some View {

        NavigationView {
            VStack {
                NavigationLink(destination: Heartbeat()) {
                    Text("\nFréquence de rythme cardiaque")
                }
                        .navigationTitle("")

                NavigationLink(destination: Heartbeat()) {
                    Text("\nTemps moyen de marche")
                }


                NavigationLink(destination: Heartbeat()) {
                    Text("\nCalories dépensées")
                }



            }
        }
    }
}

