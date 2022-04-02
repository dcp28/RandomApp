//
//  ServiceImageFetcher.swift
//  RandomApp
//
//  Created by Random Inc. on 5/4/22.
//

import Foundation
import RandomAPI

enum FileSystemPathConfiguration {
    private static var userDocumentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    case userDocumentDirectory

    func getFilePath() -> URL? {
        switch self {
        case .userDocumentDirectory:
            return Self.userDocumentDirectoryPath
        }
    }
}

final class ServiceImageFetcher: ServiceImageFetchable {
    private let apiService: RandomAPIProtocol
    private let defaultSystemPath: FileSystemPathConfiguration = .userDocumentDirectory
    private var filePath: URL? {
        defaultSystemPath.getFilePath()
    }

    private let store: Storable

    init(
        apiService: RandomAPIProtocol,
        store: Storable = DefaultStore()
    ) {
        self.apiService = apiService
        self.store = store
    }

    func getImage(from url: URL) async throws -> Data {
        if let data = try? getImageFromFileSystem(from: url) {
            return data
        }

        return try await fetchImageAndStore(from: url)
    }

    private func getImageFromFileSystem(from url: URL) throws -> Data {
        guard var filePath = filePath else {
            throw ServiceUserFetcherError.unknown
        }

        filePath.appendPathComponent(try getFileName(from: url))

        return try store.loadElement(from: filePath)
    }

    private func getFileName(from url: URL) throws -> String {
        guard let fileName = url.absoluteString.toMD5Hash() else {
            throw ServiceUserFetcherError.failingWhenHashingURL
        }

        return fileName
    }

    private func fetchImageAndStore(from url: URL) async throws -> Data {
        let imageData: Data = try await apiService.downloadImage(from: url)

        guard var filePath = filePath else {
            throw ServiceUserFetcherError.unknown
        }

        filePath.appendPathComponent(try getFileName(from: url))

        try store.saveElement(element: imageData, to: filePath)

        return imageData
    }
}
