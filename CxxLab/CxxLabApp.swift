//
//  CxxLabApp.swift
//  CxxLab
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

import CoreMIDI
import SwiftUI

@main
class CxxLabApp: App {
    @ObservedObject private var hostModel = AudioUnitHostModel()

    required init() {}

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
