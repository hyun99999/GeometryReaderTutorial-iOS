//
//  FrameView.swift
//  GeometryReaderTutorial-iOS
//
//  Created by kimhyungyu on 2022/05/10.
//

import SwiftUI

struct FrameView: View {
    var body: some View {
        HStack {
            Rectangle().fill(Color.yellow)
                .frame(width: 30)
            
            VStack {
                Rectangle().fill(Color.blue)
                    .frame(height: 200)
                
                GeometryReader {
                    self.contents(geometry: $0)
                        .position(x: $0.size.width / 2, y: $0.size.height / 2)
                }
                .background(Color.green)
                .border(Color.red, width: 4)
            }
            .coordinateSpace(name: "VStackCS")
        }
        .coordinateSpace(name: "HStackCS")
    }
    
    func contents(geometry g: GeometryProxy) -> some View {
        VStack {
            Text("Local").bold()
            Text(stringFormat(for: g.frame(in: .local).origin))
                .padding(.bottom)
            // local 은 자신에 대한 bounds 값을 반환. (0,0)
            
            Text("Global").bold()
            Text(stringFormat(for: g.frame(in: .global).origin))
                .padding(.bottom)
            
            Text("Named VStackCS").bold()
            Text(stringFormat(for: g.frame(in: .named("VStackCS")).origin))
                .padding(.bottom)
            
            Text("Named HStackCS").bold()
            Text(stringFormat(for: g.frame(in: .named("HStackCS")).origin))
                .padding(.bottom)
        }
    }
    
    func stringFormat(for point: CGPoint) -> String {
        String(format: "(x: %.f, y: %.f)", arguments: [point.x, point.y])
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
