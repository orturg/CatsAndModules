//
//  Time + Ext.swift
//  CatsAndModules_ArturNozhenko
//
//  Created by Artur Nozhenko on 21.05.2026.
//

import Foundation

extension Date {
    func getDateAndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: self)
    }
}
