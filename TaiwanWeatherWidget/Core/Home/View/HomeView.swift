//
//  HomeView.swift
//  TaiwanWeatherWidget
//
//  Created by 黃弘諺 on 2023/3/19.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: MainViewModel = MainViewModel()
    @StateObject var sharedInfo = SharedInfoManager.shared
    @State var isShowAllCitySection: Bool = false
    @State var isShowAllTownSection: Bool = false
    @State var isShowElementNameSection: Bool = false
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack {
                authorizationSection
                selectedSection
                weatherInfoSection
                
                Spacer()
            }
            seletCitySection
            selectTownSection
            selectElementSection
        }
        .overlay {
            if sharedInfo.isProcessing {
                LoadingView(waitingInfo: "請稍候", isProgressView: true)
            }
            if sharedInfo.isProcessError {
                ErrorMessageShowView(message: sharedInfo.processErrorMessage)
            }
            if vm.isShowSuccessSaveAuthorizationCode {
                checkAnimationMark
            }
        }
    }
    
    private var backgroundImage: some View {
        GeometryReader { geo in
            Image("MainViewBackground")
              .resizable()
              .scaledToFill()
              .ignoresSafeArea(.all)
              .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private var authorizationSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("專屬授權碼:")
                    .font(.headline)
                TextField("輸入授權碼", text: $vm.authorizationCode)
                    .font(.headline)
                    .padding(8)
                    .frame(height: 55)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                Image(systemName: "paperplane.fill")
                    .onTapGesture { Task { await vm.saveAuthorizationCode() } }
            }
            Text("從象局獲取自己的授權碼可以保證持續更新天氣資料")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.secondary)
                .font(.headline)
            Text("使用公用授權碼，當次數達到上限時當天將不再更新")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.secondary)
                .font(.headline)
            HStack {
                Spacer()
                Link(destination: URL(string: "https://opendata.cwb.gov.tw/devManual/insrtuction")!) {
                    HStack {
                        Image(systemName: "link.circle")
                        Text("獲取連結")
                    }
                }
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding()
    }
    
    private var selectedSection: some View {
        VStack {
            HStack {
                Text("城市:")
                Text(vm.selectedCity)
                    .frame(width: 120)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            isShowAllCitySection.toggle()
                        }
                    }
                
                Text("鄉鎮:")
                Text(vm.selectedTown)
                    .frame(width: 120)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .onTapGesture {
                        if vm.selectedCity != "-" {
                            withAnimation {
                                isShowAllTownSection.toggle()
                            }
                        }
                    }
            }
//            HStack {
//                Text("選擇資訊內容:")
//                Text(vm.selectedElementNameShow)
//                    .lineLimit(1)
//                    .frame(width: 150)
//                    .padding(8)
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(10)
//                    .onTapGesture {
//                        vm.selectedElementNamesTmp = vm.selectedElementNames
//                        withAnimation {
//                            isShowElementNameSection.toggle()
//                        }
//                    }
//            }
        }
        .font(.headline)
        .minimumScaleFactor(0.8)
    }
    
    private var seletCitySection: some View {
        VStack {
            if isShowAllCitySection {
                ZStack {
                    Color.black.opacity(0.01)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture { withAnimation { isShowAllCitySection.toggle() } }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.headline)
                                .onTapGesture { withAnimation { isShowAllCitySection.toggle() } }
                        }
                        .padding(.bottom, 8)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(CityCodeModel.allCity, id: \.self) { cityName in
                                Text(cityName)
                                    .foregroundColor(cityName == vm.selectedCity ? Color.blue : Color.black)
                                    .bold(cityName == vm.selectedCity)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                                    )
                                    .padding(4)
                                    .onTapGesture {
                                        if cityName != vm.selectedCity {
                                            vm.selectedTown = "-"
                                        }
                                        vm.selectedCity = cityName
                                        withAnimation { isShowAllCitySection.toggle() }
                                    }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.white.opacity(0.9).shadow(.drop(radius: 5)))
                    )
                    .padding()
                }
            }
        }
    }
    
    private var selectTownSection: some View {
        VStack {
            if isShowAllTownSection {
                ZStack {
                    Color.black.opacity(0.01)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture { withAnimation { isShowAllTownSection.toggle() } }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.headline)
                                .onTapGesture { withAnimation { isShowAllTownSection.toggle() } }
                        }
                        .padding(.bottom, 8)
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(TownCodeModel.townCode[vm.selectedCity]!, id: \.self) { townName in
                                    Text(townName)
                                        .foregroundColor(townName == vm.selectedTown ? Color.blue : Color.black)
                                        .bold(townName == vm.selectedTown)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                                        )
                                        .padding(4)
                                        .onTapGesture {
                                            vm.selectedTown = townName
                                            withAnimation { isShowAllTownSection.toggle() }
                                        }
                                }
                            }
                        }
                        .frame(height: 300)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.white.opacity(0.9).shadow(.drop(radius: 5)))
                    )
                    .padding()
                }
            }
        }
    }
    
    private var selectElementSection: some View {
        VStack {
            if isShowElementNameSection {
                ZStack {
                    Color.black.opacity(0.01)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture { withAnimation { isShowElementNameSection.toggle() } }
                    
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .onTapGesture { withAnimation { isShowElementNameSection.toggle() } }
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .onTapGesture {
                                    vm.updateSelectedElementName()
                                    withAnimation { isShowElementNameSection.toggle() }
                                }
                        }
                        .padding(.bottom, 8)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(ElementNameCodeModel.elementNames, id: \.self) { elementName in
                                Text(elementName)
                                    .foregroundColor( vm.selectedElementNamesTmp.contains(elementName) ? Color.blue : Color.black)
                                    .bold(vm.selectedElementNamesTmp.contains(elementName))
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                                    )
                                    .padding(4)
                                    .onTapGesture {
                                        vm.updateSelectedElementNameTmp(selectElementName: elementName)
                                    }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.white.opacity(0.9).shadow(.drop(radius: 5)))
                    )
                    .padding()
                }
            }
        }
    }
    
    private var checkAnimationMark: some View {
        VStack {
            AnimatedCheckMarkView(animationDuration: 0.75, size: CGSize(width: 100, height: 100), strokeStyle: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        }
        .padding(32)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
    
    private var weatherInfoSection: some View {
        VStack {
            if vm.isValidSelect {
                if vm.isLoadingWeatherInfo {
                    weatherInfoLoadSection
                } else {
                    weatherDetailInfoSection
                }
            }
        }
        .padding()
    }
    
    private var weatherInfoLoadSection: some View {
        VStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
    
    private var weatherDetailInfoSection: some View {
        VStack {
            Text(vm.selectedTown)
                .font(Font.custom("ChalkboardSE-Bold", size: 20))
                .bold()
                .padding(.horizontal)
                .padding(.top, 8)
            Text("\(vm.temperature.first?.0 ?? 0)° C")
                .font(Font.custom("ChalkboardSE-Bold", size: 50))
                .foregroundColor(Color.getTemperatureColor(temperature: vm.temperature.first?.0 ?? 0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Image(systemName: "clock")
                        Image(systemName: "thermometer.medium")
                        Image(systemName: "medical.thermometer")
                        Image(systemName: "cloud.rain")
                        Spacer()
                    }
                    ForEach(vm.timeLine.indices, id: \.self) { idx in
                        VStack(spacing: 8) {
                            Text(vm.timeLine[idx].formateToHour())
                            Text("\(vm.temperature[idx].0)°")
                                .foregroundColor(Color.getTemperatureColor(temperature: vm.temperature[idx].0))
                            Text("\(vm.bodyTemperature[idx].0)°")
                                .foregroundColor(Color.getTemperatureColor(temperature: vm.temperature[idx].0))
                            Text("\(vm.getRainRate(targetTime: vm.timeLine[idx]))%")
                                .foregroundColor(Color.getRainRateColor(rainRate: vm.getRainRate(targetTime: vm.timeLine[idx])))
                            Spacer()
                        }
                    }
                }
            }
            .bold()
            .padding(8)
            .padding(.bottom, -12)
            .background(Color.white.cornerRadius(10))
            .padding(.top, -32)
            .padding(.horizontal)
            Text("資料來自中央氣象局")
                .foregroundColor(Color.secondary)
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 280)
        .background(.regularMaterial)
        .cornerRadius(10)
    }
}
