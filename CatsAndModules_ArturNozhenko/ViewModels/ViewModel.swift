//
//  ViewModel.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 17.05.2026.
//

import Combine
import Networking
import Foundation
import FirebasePerformance

final class ViewModel: ObservableObject {
    @Published var animalsData: [AnimalData] = []
    
    init() {
        Task {
            
            guard let animal = Bundle.main.object(forInfoDictionaryKey: "ANIMAL") as? String else {
                await fetchData(animal: .cats)
                return
            }
            
            if animal == "DOGS" {
                await fetchData(animal: .dogs)
            } else {
                await fetchData(animal: .cats)
            }
            print(animal)
            
        }
    }
    
    private func fetchData(animal: AnimalType) async {
        let trace = Performance.startTrace(name: "fetching cats")
        var fetched: [String] = []
        if animal == .cats {
            fetched = await getCats()
        } else {
            fetched = await getDogs()
        }
            
        trace?.stop()
        await MainActor.run {
            animalsData = fetched.compactMap { AnimalData(id: UUID(), name: generateName(), urlString: $0) }
        }
    }
    
    
    private func generateName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        return String((0..<8).compactMap { _ in
            letters.randomElement()
        })
    }
}
