//
//  Networking.swift
//  Networking
//
//  Created by Artur Nozhenko on 17.05.2026.
//

import UIKit

private let dogApiKey = "live_mxlPyWySx6cspuoIPV5Mh3zGiyoKZRoBufWTMC4SyRQe0coTodyzC1yGlSsdS1xV"

public func getImageFromUrl(_ stringURL: String) async -> UIImage? {
    guard let url = URL(string: stringURL) else {
        print("Bad url")
        return nil
    }
    
    guard let (data, response) = try? await URLSession.shared.data(from: url) else {
        print("Error getting data")
        return nil
    }
    
    guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
        print("Bad response")
        return nil
    }
    
    guard let uiImage = UIImage(data: data) else {
        print("Error getting image")
        return nil
    }
    
    return uiImage
}

public func getCats() async -> [String] {
    let baseURL = "https://api.thecatapi.com/v1/images/search?limit=10"
    
    guard let url = URL(string: baseURL) else {
        print("Bad url")
        return []
    }
    
    
    guard let (data, response) = try? await URLSession.shared.data(from: url) else {
        print("Error getting data")
        return []
    }
    
    
    guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
        print("Bad response")
        return []
    }
    
    guard let cats = try? JSONDecoder().decode([AnimalImage].self, from: data) else {
        print("Error decoding")
        return []
    }
    
    return cats.compactMap { $0.url }
}

public func getDogs() async -> [String] {
    let baseUrl = "https://api.thedogapi.com/v1/images/search?limit=10"
    guard let url = URL(string: baseUrl) else {
        print("Bad url")
        return []
    }
    
    var request = URLRequest(url: url)
    request.setValue(dogApiKey, forHTTPHeaderField: "x-api-key")
    
    guard let (data, response) = try? await URLSession.shared.data(for: request) else {
        print("Error getting data")
        return []
    }
    
    guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
        print("Bad response")
        return []
    }
    
    guard let dogs = try? JSONDecoder().decode([AnimalImage].self, from: data) else {
        print("Error decoding")
        return []
    }
    
    return dogs.compactMap { $0.url }
}


private struct AnimalImage: Codable {
    let url: String
}
