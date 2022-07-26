//
//  UsersSearchQuery.swift
//  Shared
//
//  Created by prmdev on 5/25/20.
//  Copyright © 2020 prmdev. All rights reserved.
//

import Foundation
import Buildkite

struct UsersSearchQuery: GraphQLQuery {
    static var query = """
query UsersSearch($organization: ID!, $first: Int!, $search: String, $selector: TeamSelector) {
  organization(slug: $organization) {
    members(first: $first, search: $search, team: $selector) {
      edges {
        node {
          id
          role
          user {
            id
            name
            email
            avatar {
              url
            }
          }
        }
      }
    }
  }
}
"""

    var organizationSlug: String
    var search: String?
    var teamSlug: String?

    var variables: [String: JSONValue] {
        var vars: [String: JSONValue] = [
            "organization": .string(organizationSlug),
            "first": 50
        ]

        if let search = self.search { vars["search"] = .string(search) }
        if let teamSlug = self.teamSlug { vars["teamSlug"] = .string(teamSlug) }

        return vars
    }

    init(organization: String, search: String?, notInTeam team: String?) {
        self.organizationSlug = organization
        self.search = search
        self.teamSlug = team
    }

    struct Response: Decodable {
        var organization: Fragments.Organization
    }
}
