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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
