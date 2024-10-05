//
//  ViewExt.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

extension View {
    func onLoad(perform action: @escaping (() -> Void)) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
