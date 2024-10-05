//
//  ViewDidLoadModifier.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var isViewDidLoad = false
    
    private let action: (() -> Void)
    
    init(perform action: @escaping (() -> Void)) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if isViewDidLoad == false {
                isViewDidLoad = true
                action()
            }
        }
    }
}
