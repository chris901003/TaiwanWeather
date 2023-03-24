//
//  AnimationCheckView.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation
import SwiftUI

struct AnimatedCheckMarkView: View {
    
    @State var outerTrimEnd: Double = 0
    @State var innerTrimEnd: CGFloat = 0
    @State private var strokeColor: Color = .blue
    @State private var scale = 1.0
    var shouldScale: Bool = true
    var animationDuration: Double = 0.75
    var size: CGSize = .init(width: 300, height: 300)
    var innerShapeSizeRatio: CGFloat = 1 / 3
    var startColor: Color = .blue
    var endColor: Color = .green
    var strokeStyle: StrokeStyle = .init(lineWidth: 24, lineCap: .round, lineJoin: .round)
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: outerTrimEnd)
                .rotation(Angle(degrees: -90))
                .stroke(strokeColor, style: strokeStyle)
            CheckMark()
                .trim(from: 0, to: innerTrimEnd)
                .stroke(strokeColor, style: strokeStyle)
                .frame(width: size.width * innerShapeSizeRatio, height: size.height * innerShapeSizeRatio)
            
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            strokeColor = startColor
            startAnimate()
        }
        .onTapGesture {
            outerTrimEnd = 0
            innerTrimEnd = 0
            strokeColor = startColor
            scale = 1
            startAnimate()
        }
        .scaleEffect(scale)
    }
    
    private func startAnimate() {
        
        if shouldScale {
            withAnimation(.linear(duration: 0.4 * animationDuration)) {
                outerTrimEnd = 1.0
            }
            
            withAnimation(
                .linear(duration: 0.3 * animationDuration)
                .delay(0.4 * animationDuration)) {
                    innerTrimEnd = 1.0
                }
            
            withAnimation(
                .linear(duration: 0.2 * animationDuration)
                .delay(0.7 * animationDuration)) {
                    strokeColor = endColor
                    scale = 1.1
                }
            
            withAnimation(
                .linear(duration: 0.1 * animationDuration)
                .delay(0.9 * animationDuration)) {
                    scale = 1
                }
        } else {
            withAnimation(.linear(duration: animationDuration * 0.5)) {
                outerTrimEnd = 1
            }
            
            withAnimation(
                .linear(duration: animationDuration * 0.3)
                .delay(animationDuration / 2.0)) {
                    innerTrimEnd = 1
                }
            
            withAnimation(
                .linear(duration: animationDuration * 0.2)
                .delay(animationDuration * 0.8)) {
                    strokeColor = endColor
                }
        }
    }
}

struct CheckMark: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let width = rect.size.width
        let height = rect.size.height
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.4, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        return path
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCheckMarkView()
    }
}

