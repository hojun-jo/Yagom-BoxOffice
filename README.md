# 🎬🍿박스오피스🍿🎬

## 📖 목차
1. [소개](#소개)
2. [팀원](#팀원)
3. [타임라인](#타임라인)
4. [프로젝트 구조](#프로젝트-구조)
5. [다이어그램](#다이어그램)
6. [실행 화면](#실행-화면)
7. [트러블 슈팅](#트러블-슈팅)
8. [참고 링크](#참고-링크)


<br>

## 소개

영화진흥위원회의 박스오피스 `open API`를 사용해 특정 날짜에 대한 박스오피스 정보를 가져와 `CollectionView`를 사용하여 사용자에게 영화정보를 보여줍니다. 

주요개념: `collectionView`, `Indicator`, `URLSession`, `async/await`


<br>

## 팀원

|  minsup | Etial Moon |
| :--------: | :--------: |
| <Img src = "https://avatars.githubusercontent.com/u/79740398?v=4" width="200"> |<Img src="https://avatars.githubusercontent.com/u/86751964?v=4" width="200" height="200"> |
|[Github](https://github.com/agilestarskim) |[Github](https://github.com/hojun-jo) |

<br>

## 타임라인

|날짜|내용|
|:--:|--|
|2023.07.24| BoxOfficeItem 생성, BoxOfficeResult 생성 | 
|2023.07.25| NetworkManager 생성 |
|2023.07.27| URLSession을 async/await 방식으로 변경 |
|2023.07.27| Movie, MovieResult, MovieInformation 타입 생성 |
|2023.07.31| NetworkManager와 Decoder의 역할 분리 |
|2023.07.31| CollectionView, Cell 생성 및 레이아웃 |
|2023.08.02| navi title, 악세사리, separator 생성 |
|2023.08.02| AttributedString을 통해 데이터별 String 다르게 생성 |
|2023.08.03| 데이터 로딩 간 Indicator, RefreshControl 추가, 에러 시 alert 생성 |




<br>

## 프로젝트 구조

    ├── Appication
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    ├── Controller
    │   └── BoxOfficeCollectionViewController.swift
    ├── Model
    │   ├── DTO
    │   │   ├── BoxOffice
    │   │   │   ├── BoxOffice.swift
    │   │   │   ├── BoxOfficeItem.swift
    │   │   │   └── BoxOfficeResult.swift
    │   │   └── Movie
    │   │       ├── Movie.swift
    │   │       ├── MovieInformation.swift
    │   │       └── MovieResult.swift
    │   ├── Error
    │   │   ├── DecodingError.swift
    │   │   └── NetworkError.swift
    │   ├── Extension
    │   │   ├── Date+.swift
    │   │   └── String+.swift
    │   └── Network
    │       └── NetworkManager.swift
    ├── Resource
    │   ├── Assets.xcassets       
    │   └── Info.plist
    └── View
        ├── Base.lproj
        │   └── LaunchScreen.storyboard
        ├── BoxOfficeCollectionViewCell.swift
        ├── Extension
        │   └── UIFont+.swift
        └── Protocol
            └── Reusable.swift

<br>

## 다이어그램
### Model
* NetworkManager
  
![](https://hackmd.io/_uploads/BkkOoAFs3.png)
* BoxOfficeItem

![](https://hackmd.io/_uploads/BJBVC0toh.png)
* MovieInformation

![](https://hackmd.io/_uploads/HJmz00Fs2.png)

* Error

![](https://hackmd.io/_uploads/B1Ie2CYin.png)

### Controller
* BoxOfficeCollectionViewController

![](https://hackmd.io/_uploads/r1gUnAts3.png)

### View
* BoxOfficeCollectionViewCell

![](https://hackmd.io/_uploads/S1V3nAYon.png)


<br>

## 실행 화면

|당겨서 새로고침|네트워크 통신 중 로딩UI 표시|
|:---:|:---:|
|![](https://hackmd.io/_uploads/BycKYJ9sn.gif)|![](https://hackmd.io/_uploads/SJqtFJ9j3.gif)|



<br>

## 트러블 슈팅
### 1️⃣ URLSession dataTask의 리턴

#### 🔒 문제점

URLSession.shared.dataTask() 메소드를 사용하게 되면 결과를 completion Handler를 통해 결과를 받습니다. 하지만 저희는 결과로 받은 데이터를 리턴하고 싶었습니다.
```swift
func getBoxOffice() -> BoxOffice {
    let task = URLSession.shared.dataTask(from: url) { data, response, error in 
    //생략...
        return data //compile error
    }
    task.resume()
}
```

`return data`는 dataTask가 받는 클로저의 return으로 들어가기 때문에 컴파일에러가 생깁니다.
따라서 data를 리턴하고 싶으면 또 completion Handler를 받아 전달해야합니다.

```swift
func getBoxOffice(completion: (BoxOffice) -> Void) {
    let task = URLSession.shared.dataTask(from: url) { data, response, error in 
        completion(data)
    }
    task.resume()
}
```

그러면 사용하는 곳에서 또 completion 을 전달해야합니다.
```swift
getBoxOffice { boxOffice in 
    print(boxoffice)
}
```

하지만 저희가 원하는 방식은 다음과 같습니다.
```swift
let boxOffice = getBoxOffice()
```

#### 🔑 해결 방법
원하는 방식을 고민하던 중 async await을 알게 되었습니다.
async await은 이와 같은 문제 뿐만 아니라 URLSession의 쓰레드 문제, 버그발생 문제를 해결할 수 있습니다.

```swift
static func fetchData<T: Decodable>(fetchType: FetchType) async throws -> T {

    guard let url = fetchType.url else {
        throw NetworkError.invalidURL
    }

    guard let (data, response) = try? await URLSession.shared.data(from: url) else {
        throw NetworkError.requestFailed
    }

    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidHTTPResponse
    }

    guard (200..<300) ~= httpResponse.statusCode else {
        throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
    }

    return try decode(from: data)
}
```

async await 덕분에 네트워크 통신 함수를 깔끔하게 정리할 수 있었고 원하는 방식으로 리턴값을 받을 수 있게 되었습니다.


### 2️⃣ HttpResponse 에러 구분

#### 🔒 문제점

네트워크 에러 발생시 response로 받은 statusCode를 에러와 함께 던지고 싶었습니다.

```swift
enum NetworkError: Error {
    case badStatusCode(statusCode: Int)
}

let (data,reponse) = try await URLSession.shared.data(from: url)
guard let httpResponse = response as? HTTPURLResponse,
    (200..<300) ~= httpResponse.statusCode else {
    throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
}
```

하지만 `guard let` 으로 만든 `httpResponse`는 `guard else` 문 밖에서 사용할 수 있습니다.
따라서 else문 안에서 httpResponse를 사용하면 scope에러가 발생합니다.

#### 🔑 해결 방법

guard문을 두개로 구분하고 Error타입도 새롭게 정의하였습니다.
덕분에 가독성도 좋아지고 status코드도 잘 전달할 수 있게 되었습니다.
```swift
guard let httpResponse = response as? HTTPURLResponse else {
    throw NetworkError.invalidHTTPResponse
}
        
guard (200..<300) ~= httpResponse.statusCode else {
    throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
}
```

### 3️⃣ URLSession.shared.data(from: url)의 에러 확인

#### 🔒 문제점

```URLSession.shared.data(from: url)```메소드는 실패 가능성이 있는 함수입니다.
저희는 실패했을 경우 `requestFailed`에러를 정의했고 그 에러가 잘 던져지나 테스트 해보고 싶었습니다.

```swift
guard let (data, response) = try? await URLSession.shared.data(from: url) else {
    throw NetworkError.requestFailed
}
```
하지만 url주소도 틀리게 해보았지만 `badStatusCode` 에러가 발생했습니다.

#### 🔑 해결 방법

“`https://www.a.com`”이라는 이상한 주소로 요청을 보냈더니 requestFailed 에러가 발생했습니다. 없는 엔드포인트로 요청을 해야 requestFailed이 발생하는 것을 배웠습니다.

### 4️⃣ separator

#### 🔒 문제점

요구사항 화면에 separator가 있는 것을 확인했습니다.
collectionView를 compositionalLayout으로 구현했더니 자동으로 separator가 만들어지지 않았습니다.
처음에는 셀에 border를 주었습니다. 하지만 border를 주는 방법 말고 다른 방법이 있어서 찾아보았습니다.

#### 🔑 해결 방법

compositionalLayout에 static method인 .list()를 사용하면 list configuration을 사용할 수 있게 됩니다. 이를 이용해 list 모양 형식을 그대로 collectionView에서도 사용할 수 있었습니다.
```swift
let config = UICollectionLayoutListConfiguration(appearance: .plain)
let layout = UICollectionViewCompositionalLayout.list(using: config)
        
collectionView.collectionViewLayout = layout
```

하지만 문제는 compositionalLayout으로 item과 section group을 설정했을 경우 listConfiguration을 사용하지 못한다는 한계가 있습니다. 이때는 cell에 border를 주는 것이 좋은 방법이라고 생각합니다.

### 5️⃣ separator 기본 공백

#### 🔒 문제점

![](https://hackmd.io/_uploads/H1g1qfYo3.png)

각 cell에 separator를 설정하였지만 위에 사진과 같이 약간의 공백이 생기는 문제가 생겼습니다.

#### 🔑 해결 방법

그 이유는 컨텐츠의 끝에 자동으로 줄 맞춤되기 때문입니다.

셀을 만들 때 UICollectionViewCell이 아닌 UICollectionViewListCell을 상속받으면 separator의 레이아웃을 잡을 수 있는 layoutGuide를 사용할 수 있게 됩니다. (disclosure accesary도 사용가능)

이 속성은 레이아웃을 .list()로 만든 레이아웃에서만 적용이 가능합니다.


```swift
separatorLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
```


### 6️⃣ 오토 레이아웃 문제

#### 🔒 문제점

![](https://hackmd.io/_uploads/ryD3wzKsh.jpg)
UILabel은 텍스트에 따라 크기를 가지기 때문에 크기에 관한 문제는 없을 것으로 생각했습니다. 시뮬레이터에서 화면은 정상적으로 보이지만 View Hierarchy를 확인했을 때 width ambiguous 경고가 표시되었습니다.

#### 🔑 해결 방법

레이블의 width를 40으로 고정시키는 것으로 경고를 없앤 상태입니다.
```swift
rankLabel.widthAnchor.constraint(equalToConstant: 40)
```
<!-- 
### 7️⃣ ㅁㄴㅇㄹ

#### 🔒 문제점

#### 🔑 해결 방법
 -->
<br>

## 참고 링크
* [🍎Apple Docs: UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
* [🍎Apple Docs: URLSession](https://developer.apple.com/documentation/foundation/urlsession)
* [🍎Apple Docs: Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
* [🍎Apple Docs: UIRefreshControl](https://developer.apple.com/documentation/uikit/uirefreshcontrol)
* [🍎Apple Docs: UIActivityIndicatorView](https://developer.apple.com/documentation/uikit/uiactivityindicatorview)
* [📼Apple WWDC: Meet async/await in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/)
* [📼Apple WWDC: Use async/await with URLSession](https://developer.apple.com/videos/play/wwdc2021/10095/)
* [📘blog: [Swift] Actor 뿌시기](https://sujinnaljin.medium.com/swift-actor-%EB%BF%8C%EC%8B%9C%EA%B8%B0-249aee2b732d)
* [📗야곰닷넷: Swift Concurrency Programming](https://yagom.net/courses/swift-concurrency-programming/)
