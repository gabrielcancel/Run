//
//  MetricsView.swift
//  Run WatchKit Extension
//
//  Created by Cancel Gabriel on 29/04/2022.
//

import SwiftUI

struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("11:10:34")
                .foregroundColor(Color.green)
                .fontWeight(.semibold)
            Text(
                Measurement(
                    value: 47,
                    unit: UnitEnergy.kilocalories
                ).formatted(
                    .measurement(
                        width: .abbreviated,
                        usage: .workout
                    )
                )
            )
            Text(
                153.formatted(
                    .number.precision(.fractionLength(0))
                )
                + "bpm"
            )
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
