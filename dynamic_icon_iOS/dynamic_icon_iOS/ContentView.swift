//
//  ContentView.swift
//  dynamic_icon_iOS
//
//  Created by jeongan-gn on 11/17/25.
//

import SwiftUI

struct ContentView: View {
    @State var currentIcon: Image? = nil
    
    var body: some View {
        VStack {
            if UIApplication.shared.supportsAlternateIcons {
                Text("이 앱은 대체 아이콘으로 전환 가능합니다.")
                    .padding()
                HStack{
                    Text("현재 아이콘:")
                    currentIcon
                        .padding()
                }
            }
            Button("Default Icon") {
                UIApplication.shared.setAlternateIconName(nil)
                getCurrentIcon()
            }
            .padding()
            Button("Blue Icon") {
                UIApplication.shared.setAlternateIconName("BlueIcon")
                getCurrentIcon()
            }
            .padding()
            Button("Yellow Icon") {
                UIApplication.shared.setAlternateIconName("YellowIcon")
                getCurrentIcon()
            }
            .padding()
            Button("Red Icon") {
                UIApplication.shared.setAlternateIconName("RedIcon")
                getCurrentIcon()
            }
            .padding()
        }
        .padding()
        .onAppear{
            getCurrentIcon()
        }
    }
    
    func getCurrentIcon() {
        let currentIconName = UIApplication.shared.alternateIconName
        let icon = IconName(rawValue: currentIconName ?? "AppIcon") ?? .AppIcon
        currentIcon = Image(icon.fileName)
    }
}

enum IconName: String {
    case BlueIcon
    case YellowIcon
    case RedIcon
    case AppIcon
    
    var fileName: String {
        switch self {
        case .BlueIcon:
            return "myblueimg"
        case .YellowIcon:
            return "myyellowimg"
        case .RedIcon:
            return "myredimg"
        case .AppIcon:
            return "mydefaultimg"
        }
    }
}
