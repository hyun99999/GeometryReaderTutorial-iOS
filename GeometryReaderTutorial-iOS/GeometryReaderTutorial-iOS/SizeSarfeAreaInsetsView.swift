//
//  SizeSarfeAreaInsetsView.swift
//  GeometryReaderTutorial-iOS
//
//  Created by kimhyungyu on 2022/05/10.
//

import SwiftUI

struct SizeSarfeAreaInsetsView: View {
    var body: some View {
        VStack {
            // => iOS 14부터는 GeometryReader가 직접 안전 영역에 맞닿은 면에 한해 그 크기를 가져옵니다.
            // 즉, bottom 은 다른 뷰에 접해있고 top 만 안전 영역에 닿아 있다면 bottom 은 0이고 top 만 알맞은 값을 가집니다.
//            Rectangle()
            GeometryReader { geomotry in
                Text("Geometry Reader")
                    .font(.largeTitle).bold()
                    .position(x: geomotry.size.width / 2,   // geometry reader 너비의 절반.
                              y: geomotry.safeAreaInsets.top)   // 상단 안전 영역의 크기.
                VStack {
                    Text("Size").bold()
                    Text("width : \(Int(geomotry.size.width))")
                    Text("height : \(Int(geomotry.size.height))")
                }
                .position(x: geomotry.size.width / 2, y: geomotry.size.height / 2.5)
                
                VStack {
                    Text("SafeAreaInsets").bold()
                    Text("top : \(Int(geomotry.safeAreaInsets.top))")
                    Text("bottom : \(Int(geomotry.safeAreaInsets.bottom))")
                }
                .position(x: geomotry.size.width / 2, y: geomotry.size.height / 1.4)
            }
            .font(.title)
            .frame(height: 500)
            .border(Color.green, width: 5)
            
            // GeometryReader 가 safe area top 에 닿을 수 있도록 하기 위한 view.
            Rectangle()
        }
    }
}

struct SizeSarfeAreaInsetsView_Previews: PreviewProvider {
    static var previews: some View {
        SizeSarfeAreaInsetsView()
    }
}
