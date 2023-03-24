//
//  LoadingView.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/22.
//

import Foundation
import SwiftUI

/// 讀取中畫面
struct LoadingView: View {
    
    var textColor: Color
    var textFont: Font
    var backgroundColor: Color
    var isTextWithAnimation: Bool
    var isProgressView: Bool
    var isLineMode: Bool
    var viewWidth: CGFloat
    @Binding var progressSchedule: Double
    
    @State var textAnimationCount: Int = -1
    
    @State private var textAnimationTimer: Timer? = nil
    private var textInfo: [(Int, String)] = []
    
    init(waitingInfo: String, textColor: Color = .black, textFont: Font = .headline, backgroundColor: Color = .white, isTextWithAnimation: Bool = true, isProgressView: Bool = false, isLineMode: Bool = false, viewWidth: CGFloat = 150, progressSchedule: Binding<Double> = .constant(0.0)) {
        for s in waitingInfo { textInfo.append((textInfo.count, String(s))) }
        self.textColor = textColor
        self.textFont = textFont
        self.backgroundColor = backgroundColor
        self.isTextWithAnimation = isTextWithAnimation
        self.isProgressView = isProgressView
        self.isLineMode = isLineMode
        self.viewWidth = viewWidth
        self._progressSchedule = Binding(projectedValue: progressSchedule)
    }
    
    var body: some View {
        ZStack {
            
            Color.white.opacity(0.01)
                .background(TransparentBackground())
            
            VStack(spacing: 16) {
                if isProgressView && !isLineMode {
                    ProgressView()
                }
                HStack(spacing: 0) {
                    ForEach(textInfo, id: \.self.0) { info in
                        Text(info.1)
                            .font(textFont)
                            .foregroundColor(textColor)
                            .offset(y: textAnimationCount == info.0 ? -10 : 0)
                    }
                }
                if isProgressView && isLineMode {
                    ProgressView(value: progressSchedule, total: 1.01)
                        .progressViewStyle(.linear)
                }
            }
            .frame(width: viewWidth)
            .padding(36)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(backgroundColor)
                    .shadow(radius: 5)
            )
        }
        .onAppear {
            if isTextWithAnimation {
                textAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    withAnimation(.linear(duration: 0.5)) {
                        self.textAnimationCount += 1
                        self.textAnimationCount %= self.textInfo.count
                    }
                }
            }
        }
    }
}
