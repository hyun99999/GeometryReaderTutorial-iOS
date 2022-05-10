# GeometryReaderTutorial-iOS

Apple Developer 에서 제공하는 SwiftUI 튜토리얼를 진행하면서 GeoametryReader 에 대해서 다음과 같이 설명하는 것을 읽었습니다.
GeometryReader 는 무엇일까요?

> 🧬 To provide relative size information of a parent view to its child views, you can use a GeometryReader.
> 
> : 상위 뷰의 상대적 크기 정보를 하위 뷰에 제공하려면 GeometryReader 를 사용할 수 있습니다.


### 왜 사용하나요?

저희가 VStack, HStack, ZStack 과 같은 View Builder 에 하위뷰들을 넣게되면 별도의 설정없이 화면에 자동으로 보여줍니다. 이것은 Parent View 상위뷰가 Child View 하위뷰에게 위치와 크기를 제안해주기 때문입니다.

그리고, 맘에 들지 않을 때 하위 뷰는 상위 뷰의 제안을 무시하고 선언할 수 있습니다.

이때 사용되는 것이 GeometryReader 입니다.

## GeometryReader

*Structure*

A container view that defines its content as a function of its own size and coordinate space.

**Overview**

This view returns a flexible preferred size to its parent layout.
→ 상위뷰의 컨테이너의 크기를 통해서 하위뷰의 위치 및 크기를 선언하는데 사용!

### 코드 맛보기..!

<img width="230" alt="1" src="https://user-images.githubusercontent.com/69136340/167630994-68129c53-dd6e-48dd-9085-34fadda4650a.png">

```swift
// 클로저의 매개변수 네이밍으로 보통 proxy 혹은 geometry 를 사용하더라구요.
return GeometryReader { **proxy** in
            HStack(alignment: .bottom, spacing: **proxy.size.width** / 120) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, observation in
                    GraphCapsule(
                        index: index,
                        color: color,
                        height: **proxy.size.height**,
                        range: observation[keyPath: path],
                        overallRange: overallRange
                    )
                        .animation(.ripple(index: index))
                }
                .offset(x: 0, y: **proxy.size.height** * heightRatio)
            }
        }
// 출처: Landmark 튜토리얼 앱(HikeGraph)
```

GeometryReader 는 아래와 같은 이니셜라이저를 통해서 사용합니다. 그래서 클로저의 매개변수로 GeometryProxy 를 전달해주고 있어요.(그래서 네이밍도 그러한가 봅니다.)

```swift
init(content: @escaping (GeometryProxy) -> Content)
```

## [GeometryProxy](https://developer.apple.com/documentation/swiftui/geometryproxy)

*Structure*

container view 의 크기 및 좌표공간에 대한 액세스를 위한 proxy(대리인) 입니다.

<img width="600" alt="2" src="https://user-images.githubusercontent.com/69136340/167631168-79d0c2c4-06fb-4501-baca-59d0a1272c90.png">

위와 같이 하나의 메서드, 두개의 프로퍼티, 하나의 서브스크팁를 제공하여 geometry reader 의 레이아웃 정보를 자식뷰에게 제공할 수 있습니다.

| 구분 | 설명 |
| --- | --- |
| frame(in:) | 특정 좌표계를 기준으로 한 프레임 정보를 제공합니다. |
| size | geometry reader 의 크기를 반환합니다. |
| safeAreaInsets | geometry reader 가 사용된 환경에서의 안전 영역에 대한 크기를 반환합니다. |
| subscript(anchor:) | 자식 뷰에서 anchorePreference 수식어를 이용해 제공한 좌표나 프레임을 geometry reader 의 좌표계를 기준으로 다시 변환하여 사용하는 서브스크립트입니다. 이때 Anchor 의 제네릭 매개 변수에는 CGRect 또는 CGPoint 타입 두 가지를 사용할 수 있습니다. |

## 정리

### 🔥 GeometryReader 로 뷰를 감싼 상위뷰 컨테이너의 frame, size, safeAreaInsets 를 사용해서 하위뷰의 크기정보를 전달할 수 있다!

## 사용해보자!

### Size, SafeAreaInsets

GeometryReader 와 safe area 의 크기를 바탕으로 자식 뷰에 상대적인 크기나 위치를 지정해봅시다.(13 mini 기준)

<img src="https://user-images.githubusercontent.com/69136340/167631302-2b80dfcf-2451-4937-b597-fec35c6ea9f7.png" width ="250">

```swift
var body: some View {
        VStack {
            // => iOS 14부터는 GeometryReader가 직접 안전 영역에 맞닿은 면에 한해 그 크기를 가져옵니다.
            // 즉, bottom 은 다른 뷰에 접해있고 top 만 안전 영역에 닿아 있다면 bottom 은 0이고 top 만 알맞은 값을 가집니다.
            GeometryReader { geomotry in
                Text("Geometry Reader")
                    .font(.largeTitle).bold()
                    // 🔥
                    .position(x: geomotry.size.width / 2,   // geometry reader 너비의 절반.
                              y: geomotry.safeAreaInsets.top)   // 상단 안전 영역의 크기.
                VStack {
                    Text("Size").bold()
                    // 🔥
                    Text("width : \(Int(geomotry.size.width))")
                    Text("height : \(Int(geomotry.size.height))")
                }
                // 🔥
                .position(x: geomotry.size.width / 2, y: geomotry.size.height / 2.5)
                
                VStack {
                    Text("SafeAreaInsets").bold()
                    // 🔥
                    Text("top : \(Int(geomotry.safeAreaInsets.top))")
                    Text("bottom : \(Int(geomotry.safeAreaInsets.bottom))")
                }
                // 🔥
                .position(x: geomotry.size.width / 2, y: geomotry.size.height / 1.4)
            }
            .font(.title)
            .frame(height: 500)
            .border(Color.green, width: 5)
            
            // GeometryReader 가 safe area top 에 닿을 수 있도록 하기 위한 view.
            Rectangle()
        }
    }

// 출처: https://github.com/giftbott/SweetSwiftUIExamples
```

<img width="700" alt="6" src="https://user-images.githubusercontent.com/69136340/167631407-159b3f24-8cdc-45eb-af37-838f80f1cafb.png">

<img width="700" alt="7" src="https://user-images.githubusercontent.com/69136340/167631439-9a3f4520-9c33-460b-865e-b99e6ea1ffc7.png">

### Frame

<img width="700" alt="8" src="https://user-images.githubusercontent.com/69136340/167631477-8837b00b-f3b9-4d83-8bf0-0d57b03564e3.png">

여기서 `frame` 은 단순히 CGRect 을 전달하는 것이 아니라 CoordinateSpace 라는 열거형 타입입니다.

```swift
enum CoordinateSpace {
  case global                // 화면 전체 영역(window bounds)을 기준으로 한 좌표 정보
  case local                 // GeometryReader bounds 를 기준으로 한 좌표 정보
  case named(AnyHashable)    // 명시적으로 이름을 할당한 공간을 기준으로 한 좌표 정보
}	
```

[Apple Developer Documentation - coordinatespace](https://developer.apple.com/documentation/swiftui/coordinatespace)

뷰의 origin 이 서로 다른 좌표 공간상에서 어떤 식으로 계산되는지 알아보자!

<img src="https://user-images.githubusercontent.com/69136340/167631550-4ad5fa94-3fad-4f27-957f-9eda581780e6.png" width ="250">

```swift
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

/// GeometryProxy.frame 다루기
    func contents(geometry g: GeometryProxy) -> some View {
        VStack {
            // 🔥 GeometryReader 자신에 대한 bounds 값을 반환.(그래서 원점 (0,0) 반환)
            Text("Local").bold()
            Text(stringFormat(for: g.frame(in: .local).origin))
                .padding(.bottom)

            // 🔥 
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
    
/// CGPoint 를 가지고, String 으로 반환.
    func stringFormat(for point: CGPoint) -> String {
        String(format: "(x: %.f, y: %.f)", arguments: [point.x, point.y])
    }
}

// 출처: https://github.com/giftbott/SweetSwiftUIExamples
```

참고: 

[https://github.com/giftbott/SweetSwiftUIExamples](https://github.com/giftbott/SweetSwiftUIExamples)
