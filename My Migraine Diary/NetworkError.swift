//
//  NetworkError.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/17.
//

enum NetworkError: Error {
    case invalidUrl
    case requestFailed
    case responseFaild
    case jsonDecodeFailed
}
