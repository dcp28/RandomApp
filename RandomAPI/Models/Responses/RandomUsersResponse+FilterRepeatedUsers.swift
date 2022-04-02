//
//  RandomUsersResponse+FilterRepeatedUsers.swift
//  RandomAPI
//
//  Created by Random Inc. on 2/4/22.
//

import Foundation

extension Array where Element == Result {
    func filterRepeatedUsers() -> [Result] {
        reduce([]) { accumulatedResults, currentResult in
            if accumulatedResults.contains(currentResult) {
                return accumulatedResults
            }
            var cpAccumulatedResults = accumulatedResults
            cpAccumulatedResults.append(currentResult)
            return cpAccumulatedResults
        }
    }
}
