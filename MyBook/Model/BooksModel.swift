//
//  BooksModel.swift
//  MyBook
//
//  Created by Subendran on 29/11/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import Foundation

struct BooksModel: Codable {
    let kind: String?
    let totalItems: Int?
    var items: [Items]?
    
    enum CodingKeys: String, CodingKey {
        
        case kind = "kind"
        case totalItems = "totalItems"
        case items = "items"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        totalItems = try values.decodeIfPresent(Int.self, forKey: .totalItems)
        items = try values.decodeIfPresent([Items].self, forKey: .items)
    }
    
}

struct Items: Codable {
    let volumeinfo: VolumeInfo?
    let saleInfo: SaleInfo?
    
    enum CodingKeys: String, CodingKey {
        case volumeinfo = "volumeInfo"
        case saleInfo = "saleInfo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        volumeinfo = try values.decodeIfPresent(VolumeInfo.self, forKey: .volumeinfo)
        saleInfo = try values.decodeIfPresent(SaleInfo.self, forKey: .saleInfo)
        
    }
}

struct VolumeInfo: Codable {
    let title: String?
    let subtitle: String?
    let imageLinks: ImageLinks?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subtitle = "subtitle"
        case imageLinks = "imageLinks"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        imageLinks = try values.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)
    }
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail = "smallThumbnail"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        smallThumbnail = try values.decodeIfPresent(String.self, forKey: .smallThumbnail)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
    }
    
}

struct SaleInfo: Codable {
    let saleability: String?
    let retailPrice: RetailPrice?
    
    enum CodingKeys: String, CodingKey {
        case retailPrice = "retailPrice"
        case saleability = "saleability"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        saleability = try values.decodeIfPresent(String.self, forKey: .saleability)
        retailPrice = try values.decodeIfPresent(RetailPrice.self, forKey: .retailPrice)
    }
}

struct RetailPrice: Codable {
    let amount: Double?
    let currencyCode: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case currencyCode = "currencyCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        currencyCode = try values.decodeIfPresent(String.self, forKey: .currencyCode)
    }
}

