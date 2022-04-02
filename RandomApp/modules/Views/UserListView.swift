//
//  UserListView.swift
//  RandomApp
//
//  Created by Random Inc. on 2/4/22.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dataSource, id: \.id) { user in
                    UserCellView(user: user)
                }
            }.onAppear(perform: {
                onLoadView()
            }).navigationTitle("Users")
        }
    }

    func onLoadView() {
        Task {
            do {
                try await viewModel.fetchUsersData()
            } catch {
                print("Failing fetch model with error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
