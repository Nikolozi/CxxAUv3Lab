//
//  CxxLabExtensionMainView.swift
//  CxxLabExtension
//
//  Created by Nikolozi Meladze on 7/6/2023.
//

import SwiftUI

struct CxxLabExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
