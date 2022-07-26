//
//  SettingsList.swift
//  Buildkite
//
//  Created by prmdev on 7/3/20.
//

import SwiftUI

struct SettingsList: View {
    @EnvironmentObject var service: BuildkiteService

    var body: some View {
        List {
            NavigationLink(destination: ChangelogList()) {
                Text("Changelog")
                // if viewer.hasUnreadChangelogs {
                //     Text("< NEW")
                // }
            }
        }
        .listStyle(InsetListStyle())
    }
}

struct SettingsList_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList()
    }
}
