//
//  TeamView.swift
//  Buildkite
//
//  Created by Aaron Sky on 6/25/20.
//

import SwiftUI
import Combine
import Buildkite

struct TeamView: View {
    @EnvironmentObject var service: BuildkiteService
    @EnvironmentObject var emojis: Emojis
    
    @State var team: Fragments.Team
    
    @State private var selectedUserIDFromSearching: String?
    @State private var presentingSearchUsersModal = false
    
    @ViewBuilder var body: some View {
        content
            .navigationTitle(emojis.replacingEmojiIdentifiers(in: team.name))
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        presentingSearchUsersModal = true
                    }, label: {
                        Label("Add Person", systemImage: "person.badge.plus")
                            .labelStyle(IconOnlyLabelStyle())
                    })
                }
            }
    }
    
    var content: some View {
        Form {
            Section {
                Text(team.privacy.rawValue)
                EmojiLabel(team.description ?? "")
            }
            Section(header: Text("MEMBERS")) {
                ForEach(team.members.nodes) { member in
                    NavigationLink(destination: UserView(userID: member.id)) {
                        Text(member.user.name ?? "")
                    }
                }
                .onDelete { offsets in
                    Task {
                        await deleteMembers(at: offsets)
                    }
                }
            }
        }
        .task {
            await reloadTeam()
        }
        .sheet(isPresented: $presentingSearchUsersModal, onDismiss: onDismissSearchUserModal) {
            VStack {
                Text("// TODO: Search Field goes here")
                UsersList(teamSlug: team.slug,
                          onUserSelection: { user in
                            presentingSearchUsersModal = false
                            selectedUserIDFromSearching = user.user.id
                          })
            }.environmentObject(service)
        }
    }
    
    func onDismissSearchUserModal() {
        guard let userID = selectedUserIDFromSearching else {
            return
        }
        
        Task {
            await addMember(with: userID)
        }
    }
    
    func reloadTeam() async {
        guard let response = try? await service.sendQuery(TeamGetQuery(organization: service.organization, team: team.slug)),
              let data = try? response.get() else {
                  return
              }
        self.team = data.team
    }
    
    func addMember(with userID: String) async {
        guard let response = try? await service.sendQuery(TeamCreateMemberMutation(teamID: team.id, userID: userID)),
              case .some(_) = try? response.get() else {
                  return
              }
        await reloadTeam()
    }
    
    func deleteMembers(at offsets: IndexSet) async {
        let ids = offsets.compactMap { team.members.edges?[$0].node.id }
        try? await withThrowingTaskGroup(of: TeamDeleteMemberMutation.Response.self) { group in
            for id in ids {
                group.addTask {
                    let response = try await service.sendQuery(TeamDeleteMemberMutation(id: id))
                    return try response.get()
                }
            }
            for try await deletedMember in group {
                self.team.members.edges?.removeAll(where: { $0.node.id == deletedMember.teamMemberDelete.deletedTeamMemberID })
            }
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static let teams = [Team](assetNamed: "v2.teams").map(Fragments.Team.init)
    
    static var previews: some View {
        NavigationView {
            TeamView(team: teams[1])
        }
        .frame(height: 700)
        .previewLayout(.sizeThatFits)
        .environmentObject(BuildkiteService())
        .environmentObject(Emojis())
    }
}
