//
//  CatDetailedView.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 18.05.2026.
//

import SwiftUI
import Networking
import FirebaseCrashlytics

struct CatDetailedView: View {
    let catData: AnimalData
    @State private var fetchedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
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
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
            
            Text(catData.name)
                .foregroundStyle(.brown)
                .font(.system(size: 24, weight: .semibold))
            
            Spacer()
        }
        .onAppear {
            Crashlytics.crashlytics().setCustomValue(
                Date().getDateAndTime(),
                forKey: "user_entered_detailed_view_screen"
            )
        }
        .padding(.horizontal, 16)
        .task {
            let image = await getImageFromUrl(catData.urlString)
            await MainActor.run {
                fetchedImage = image
            }
        }
    }
}
