//
//  Models.swift
//  cyrptoTracker
//
//  Created by Doğukan Ahi on 26.07.2023.
//

import Foundation

struct Crypto : Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon : String?
    
}

struct Icon: Codable {
    let asset_id: String
    let url: String
    
}
