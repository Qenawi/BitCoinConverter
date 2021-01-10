//
//  BtsData.swift
//  byteCoinConverter
//
//  Created by Qenawi on 1/10/21.
//  Copyright © 2021 qenawi. All rights reserved.
//

import Foundation
struct BtsData:Decodable {
    var  data:[Btsitem]?
    enum CodingKeys:String , CodingKey
    {
        
        case data = "rates"
    }
}
struct Btsitem:Decodable {
    var name:String?
    var rate:Double?
    enum CodingKeys: String, CodingKey {
        case name = "asset_id_quote"
        case rate
        
    }
}
struct BtsExchangeValue:Decodable {
    var rate:Double?
    var fromCoin:String?
    var toCoin:String?
    enum CodingKeys:String,CodingKey {
        case rate
        case fromCoin = "asset_id_base"
        case toCoin = "asset_id_quote"
    }
}
