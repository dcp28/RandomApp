//
//  UserListViewModel.swift
//  RandomApp
//
//  Created by Random Inc. on 3/4/22.
//

import Foundation
import RandomAPI
import SwiftUI

class UserListViewModel: ObservableObject {
    @Published var dataSource: [User] = []
    private let randomAPI = RandomAPI(environment: .pro)

    func fetchUsersData() async throws {
        let service = ServiceUserFetcher(
            apiService: randomAPI,
            imageServiceFetcher: ServiceImageFetcher(apiService: randomAPI)
        )
        let users = try await service.getUsers()
        DispatchQueue.main.async {
            self.dataSource = users
        }
    }
}
