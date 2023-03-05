//
//  Article Struct.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/3/5.
//

import Foundation

struct ArticleResponese: Decodable {
    let articles: [Item]
}

struct Item: Decodable {
    let title: String
    let url: URL
    let urlToImage: URL
}
