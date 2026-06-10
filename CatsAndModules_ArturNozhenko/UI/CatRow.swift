//
//  CatRow.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 17.05.2026.
//

import SwiftUI
import Networking
import FirebasePerformance

struct CatRow: View {
    
    let catData: AnimalData
    @State private var fetchedImage: UIImage?
    
    var body: some View {
        HStack {
            Group {
                if let image = fetchedImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
            
            Text(catData.name)
                .foregroundStyle(.brown)
                .font(.system(size: 18, weight: .semibold))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .task {
            let trace = Performance.startTrace(name: "fetching image")
            let image = await getImageFromUrl(catData.urlString)
            trace?.stop()
            
            await MainActor.run {
                fetchedImage = image
            }
        }
    }
}

