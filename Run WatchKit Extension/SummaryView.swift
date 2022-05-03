//
//  SummaryView.swift
//  Run WatchKit Extension
//
//  Created by Cancel Gabriel on 29/04/2022.
//

import SwiftUI

struct SummaryView: View {
    @State private var durationFormatter:
        DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: .leading){
                SummaryMetricView(
                    title: "Total Time",
                    value: durationFormatter.string(from: 40 * 60 + 12) ?? ""
                )
                .accentColor(Color.yellow)
                SummaryMetricView(
                    title: "Total Distance",
                    value: Measurement(
                                value: 6728,
                                unit: UnitLength.kilometers
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                )
                .accentColor(Color.green)
                
                SummaryMetricView(
                    title: "Total Energy",
                    value: Measurement(
                            value: 728,
                            unit: UnitEnergy.kilocalories
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout
                            )
                        )
                )
                .accentColor(Color.pink)
                SummaryMetricView(title: "Avg. Heart Rate",
                                    value: 123
                                        .formatted(
                                            .number.precision(
                                                .fractionLength(0)
                                            )
                                    )
                                    + " bpm"
                                    
                ).accentColor(Color.red)
                Button("Done"){
                }
            }
            .scenePadding()
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(Color.accentColor)
        Divider()
    }
}
