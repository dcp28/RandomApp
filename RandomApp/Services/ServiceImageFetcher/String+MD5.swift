//
//  String+MD5.swift
//  RandomApp
//
//  Created by Random Inc. on 5/4/22.
//

import CryptoKit
import Foundation

extension String {
    func toMD5Hash() -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }

        let digest = Insecure.MD5.hash(data: data)

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
