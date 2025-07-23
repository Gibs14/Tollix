//
//  TollixApp.swift
//  Tollix
//
//  Created by Muhammad Ardiansyah Asrifah on 17/07/25.
//

import SwiftUI

@main
struct TollixApp: App {
    var body: some Scene {
        WindowGroup {
            Hi_Fi()
        }
        .windowStyle(DefaultWindowStyle())
        .windowResizability(.contentSize)
    }
}
