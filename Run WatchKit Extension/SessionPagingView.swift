//
//  SessionPagingView.swift
//  Run WatchKit Extension
//
//  Created by Cancel Gabriel on 29/04/2022.
//

import SwiftUI

struct SessionPagingView: View {
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controle,  metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection){
            Text("Controls").tag(Tab.controle)
            Text("Metrics").tag(Tab.metrics)
            Text("Now Playing").tag(Tab.nowPlaying)
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
