//
//  SessionPagingView.swift
//  Run WatchKit Extension
//
//  Created by Cancel Gabriel on 29/04/2022.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controle,  metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection){
            ControlsView().tag(Tab.controle)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
