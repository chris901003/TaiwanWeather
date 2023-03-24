//
//  TransparentBackground.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/22.
//

import Foundation
import SwiftUI

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
