//
//  PreviewData.swift
//  Shared
//
//  Created by prmdev on 5/15/20.
//  Copyright © 2020 prmdev. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(Formatters.decodeISO8601)
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

extension Decodable {
    init(assetNamed name: String, bundle: Bundle = .main) {
        guard let asset = NSDataAsset(name: name, bundle: bundle) else {
            fatalError("MISSING ASSET \(name) in bundle \(bundle.bundlePath)")
        }

        let instance: Self
        do {
            instance = try decoder.decode(Self.self, from: asset.data)
        } catch {
            fatalError("DECODING ERROR for asset \(asset.name): \(error)")
        }
        
        self = instance
    }
}
