//
//  CatsListScreen.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 17.05.2026.
//

import SwiftUI
import FirebaseCrashlytics

struct CatsListScreen: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    Button("Crash") {
                      fatalError("Crash was triggered")
                    }
                    ForEach(Array(vm.animalsData.enumerated()), id: \.element.id) { index, catData in
                        NavigationLink {
                            CatDetailedView(catData: catData)
                        } label: {
                            CatRow(catData: catData)
                                
                        }
                        .simultaneousGesture(TapGesture().onEnded({
                            Crashlytics.crashlytics().log("user_tapped_on_row: \(index + 1)")
                            Crashlytics.crashlytics().setCustomValue(
                                Date().getDateAndTime(),
                                forKey: "tap_time"
                            )
                        }))
                        
                    }
                }
                .onAppear {
                    Crashlytics.crashlytics().setCustomValue(
                        Date().getDateAndTime(),
                        forKey: "user_entered_list_screen"
                    )
                    

                }
            }
        }
    }
}

#Preview {
    CatsListScreen()
}
