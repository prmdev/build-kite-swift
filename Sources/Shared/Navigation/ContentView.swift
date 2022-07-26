//
//  ContentView.swift
//  Shared
//
//  Created by prmdev on 6/25/20.
//

import SwiftUI

struct ContentView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif

    var body: some View {
        ZStack {
#if os(iOS)
            if horizontalSizeClass == .compact {
                AppTabNavigation()
            } else {
                AppSidebarNavigation()
            }
#else
            AppSidebarNavigation()
                .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
#endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
