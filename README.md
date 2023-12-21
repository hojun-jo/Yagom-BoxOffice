# 🎬🍿박스오피스🍿🎬

> 팀 프로젝트 기간 : 2023.07. ~ 2023.08.<br>리팩토링 : 2023.12. ~

## 📖 목차
1. [소개](#소개)
2. [팀원](#팀원)
3. [타임라인](#타임라인)
4. [프로젝트 구조](#프로젝트-구조)
5. [실행 화면](#실행-화면)
6. [트러블 슈팅](#트러블-슈팅)
7. [참고 링크](#참고-링크)


<br>

## 소개

영화진흥위원회의 박스오피스 `open API`를 사용해 박스오피스 정보를 가져와 `CollectionView`를 사용하여 사용자에게 영화정보를 보여줍니다.  
캘린더를 이용해 특정 날짜의 박스오피스를 확인할 수 있습니다. 또한 박스오피스 정보를 리스트 형태로 보여줄 지 아이콘 형태로 보여줄 지 레이아웃을 선택할 수 있습니다.  
다이나믹 타입이 변경되거나 디바이스의 방향이 변경되면 영화정보를 효과적으로 보여주기 위해 레이아웃이 자동으로 조절됩니다.  
메인 화면에서 영화를 선택하면 `Daum 이미지 API`를 사용하여 영화 포스터와 함께 상세 정보를 보여줍니다.  

주요개념: `CollectionView`, `Indicator`, `URLSession`, `async/await`, `Compositional Layout`, `Dynamic Type`, `Device Orientation`


<br>

## 팀원

| minsup | Etial Moon |
| :--------: | :--------: |
| <Img src = "https://avatars.githubusercontent.com/u/79740398?v=4" width="200"> |<Img src="https://avatars.githubusercontent.com/u/86751964?v=4" width="200" height="200"> |
|[Github](https://github.com/agilestarskim) |[Github](https://github.com/hojun-jo) |

<br>

## 타임라인

|날짜|내용|
|:--:|--|
|2023.07.24| BoxOffice DTO 생성 | 
|2023.07.25| NetworkManager 생성 |
|2023.07.27| URLSession을 async/await 방식으로 변경 |
|2023.07.27| Movie DTO 생성 |
|2023.07.31| NetworkManager와 Decoder의 역할 분리 |
|2023.07.31| CollectionView, Cell 생성 및 레이아웃 |
|2023.08.02| navi title, 악세사리, separator 생성 |
|2023.08.02| AttributedString을 통해 데이터별 String 다르게 생성 |
|2023.08.03| 데이터 로딩 간 Indicator, RefreshControl 추가, 에러 시 alert 생성 |
|2023.08.08| FetchImage구현, Detail 화면 구현 |
|2023.08.09| APIKey 숨기기, Detail 레이아웃, Indicator 생성 |
|2023.08.10| 영화 포스터 이미지 높이 조절|
|2023.08.15| CalendarViewController 구현 |
|2023.08.16| 아이콘 레이아웃 추가 및 Orientation, DynamicType 대응 |
|2023.08.18| 리팩토링 |



<br>

## 프로젝트 구조

### 폴더 구조
    BoxOffice
    ├── Appication
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    ├── Controller
    │   ├── BoxOfficeCalendarViewController.swift
    │   ├── BoxOfficeMainViewController.swift
    │   ├── MovieDetailViewController.swift
    │   └── Protocol
    │       └── BoxOfficeCalendarViewControllerDelegate.swift
    ├── Model
    │   ├── AlertBuilder.swift
    │   ├── Error
    │   │   ├── DecodingError.swift
    │   │   └── NetworkError.swift
    │   ├── Extension
    │   │   ├── Array+.swift
    │   │   ├── Bundle+.swift
    │   │   ├── Date+.swift
    │   │   └── String+.swift
    │   ├── Network
    │   │   ├── API
    │   │   │   ├── BoxOffice
    │   │   │   │   ├── BoxOfficeAPI.swift
    │   │   │   │   └── DTO
    │   │   │   │       ├── BoxOffice.swift
    │   │   │   │       ├── BoxOfficeItem.swift
    │   │   │   │       └── BoxOfficeResult.swift
    │   │   │   ├── DaumImage
    │   │   │   │   ├── DTO
    │   │   │   │   │   ├── Image.swift
    │   │   │   │   │   └── ImageDocument.swift
    │   │   │   │   └── DaumImageAPI.swift
    │   │   │   ├── Interface
    │   │   │   │   └── APIType.swift
    │   │   │   ├── JustURL.swift
    │   │   │   └── MovieInformation
    │   │   │       ├── DTO
    │   │   │       │   ├── Movie.swift
    │   │   │       │   ├── MovieInformation.swift
    │   │   │       │   └── MovieResult.swift
    │   │   │       └── MovieInformationAPI.swift
    │   │   └── NetworkManager.swift
    │   └── RankChangeState.swift
    ├── Resource
    │   ├── APIKey.plist
    │   ├── Assets.xcassets
    │   │   ├── AccentColor.colorset
    │   │   │   └── Contents.json
    │   │   ├── AppIcon.appiconset
    │   │   │   └── Contents.json
    │   │   ├── Contents.json
    │   │   └── boxOfficeTestSample.dataset
    │   │       ├── Contents.json
    │   │       └── boxOfficeTestSample.json
    │   ├── Base.lproj
    │   │   └── LaunchScreen.storyboard
    │   └── Info.plist
    └── View
        ├── BoxOfficeCollectionViewIconCell.swift
        ├── BoxOfficeCollectionViewListCell.swift
        ├── BoxOfficeMainView.swift
        ├── Extension
        │   ├── UICollectionView+.swift
        │   ├── UICollectionViewCell+.swift
        │   ├── UIFont+.swift
        │   └── UILabel+.swift
        ├── MovieDetailView.swift
        └── Protocol
            └── Reusable.swift

<br>

### 다이어그램
<img width="2752" alt="boxoffice" src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/3c56fc4a-283d-4913-b234-b1092daa2c40">

<br>
<br>

## 실행 화면

|당겨서 새로고침|네트워크 통신 중 로딩UI 표시|
|:---:|:---:|
|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/9abfbe6e-14c5-431b-a9cb-f16ccb1477be" width="300">|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/e1b20079-99cb-407c-a9fa-f9aa1078c4b0" width="300">|

|영화 상세 정보 화면|날짜 선택|
|:---:|:---:|
|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/2209e40e-30c3-46a9-a1eb-adfe41f68809" width="300">|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/f8aff43c-9680-4dc5-a05e-b039df11456a" width="300">|

|화면 모드 변경|아이콘 화면 회전|
|:---:|:---:|
|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/a5705666-7af3-40af-b414-23d8a977332d" width="300">|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/b06d184c-8902-40fe-a631-3a636b7f3bc1" width="300">|

|리스트 화면 다이나믹 타입|아이콘 화면 다이나믹 타입|
|:---:|:---:|
|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/aef68d4d-111c-446e-932e-3e2d107e4fc2" width="300">|<img src="https://github.com/hojun-jo/Yagom-BoxOffice/assets/86751964/730891e2-5b9d-4f81-bc2c-2d0603a2046f" width="300">|


<br>

## 트러블 슈팅
### 1️⃣ Completion Handler에서 async/await으로

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
async await은 위와 같은 문제 뿐만 아니라 URLSession의 쓰레드 문제, 버그발생이 쉬운 문제를 해결할 수 있습니다.

```swift
static func fetchData<T: APIType>(api: T) async throws -> Data {
    let request = try createRequest(api: api)
    
    guard let (data, response) = try? await URLSession.shared.data(for: request) else {
        throw NetworkError.requestFailed
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidHTTPResponse
    }
    
    guard (200..<300) ~= httpResponse.statusCode else {
        throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
    }
    
    return data
}
```

async await 덕분에 네트워크 통신 함수를 깔끔하게 정리할 수 있었고 원하는 방식으로 리턴값을 받을 수 있게 되었습니다.


### 2️⃣ separator

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

### 3️⃣ separator 기본 공백

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

### 4️⃣ API key 구분 및 은닉

#### 🔒 문제점
네트워크 매니저에서 박스오피스 정보만 불러올 때는 API key를 URL에 포함하여 URL만 사용했습니다. 하지만 영화 포스터 이미지를 불러오기 위해 필요한 URL 형식이 다르기 때문에 API별로 분리가 필요했습니다.
| 영화진흥위원회 | 다음 이미지 검색 |
|:-:|:-:|
|API key가 URL 쿼리에 포함|API key가 헤더에 포함|

#### 🔑 해결 방법
URLRequest를 만드는 메소드를 분리하며 URLQueryItem과 헤더를 만들게 되었습니다.
```swift
static private func createRequest(fetchType: FetchType) -> URLRequest? {
    guard var urlComponents = URLComponents(string: fetchType.url) else {
        return nil
    }
    
    switch fetchType {
    case .boxOffice(let date):
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: Bundle.main.kobisAPIKey),
            URLQueryItem(name: "targetDt", value: date)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
        ...
    }
}
```
아울러 API key를 숨기기 위해 plist에 키를 저장하고 gitignore를 활용하는 방법을 찾았습니다.
```swift
extension Bundle {
    var kakaoAPIKey: String {
        return fetchPropertyList(domain: "KAKAO")
    }
    
    var kobisAPIKey: String {
        return fetchPropertyList(domain: "KOBIS")
    }
    
    private func fetchPropertyList(domain: String) -> String {
        guard let file = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource[domain] as? String else { fatalError("APIKey.plist에 \(domain) API키를 등록하세요")}
        
        return key
    }
}
```

### 5️⃣ 이미지의 불필요한 공백

#### 🔒 문제점
이미지를 불러왔을 때 이미지 크기와 다르게 공백이 생기는 문제가 있었습니다.

<img src="https://hackmd.io/_uploads/ByRPbKgnn.png" width=300>

#### 🔑 해결 방법
이미지 뷰의 가로와 원본 이미지의 가로를 통해 비율을 구한 후, 이 비율을 통해 높이를 구하여 이미지 뷰의 높이를 고정했습니다.

```swift
func injectMovieInformation(_ movieInformation: MovieInformation?, image: UIImage?) {
    posterImageView.image = image
    updatePosterImageViewConstraints()
   ...
}

private func updatePosterImageViewConstraints() {
    guard let imageWidth = posterImageView.image?.size.width,
          let imageHeight = posterImageView.image?.size.height else { return }
    let ratio = posterImageView.frame.width / imageWidth
    let height = ratio * imageHeight
    posterImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
}
```

### 6️⃣ async let을 이용한 비동기 작업

#### 🔒 문제점
현재 코드에선 데이터를 불러오는 방식으로 async/await을 사용중입니다.

```swift
let movie = await fetchMovie()
let poster = await fetchPoster()
detailView.injectMovieInformation(movie, poster)
```

해당 코드는 순차적으로 실행되기 때문에 movie의 값을 받을 때 까지 기다린 후 movie 데이터를 다 받으면 poster를 받기 시작합니다.

두 개는 서로 전혀 관계가 없고 오래 걸리는 작업이기 때문에 순차적으로 실행하며 기다리는 것은 손해라고 판단하였습니다.

#### 🔑 해결 방법
 async let을 이용하여 문제를 해결하였습니다.
```swift
async let movie = fetchMovie()
async let poster = fetchPoster()

detailView.injectMovieInformation(await movie, await poster)
```

async let을 사용해서 비동기적으로 movie와 poster를 fetch할 수 있다는 사실을 배웠습니다. 


<br>

## 참고 링크
[🍎Apple Docs: UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)  
[🍎Apple Docs: URLSession](https://developer.apple.com/documentation/foundation/urlsession)  
[🍎Apple Docs: Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)  
[🍎Apple Docs: UIRefreshControl](https://developer.apple.com/documentation/uikit/uirefreshcontrol)  
[🍎Apple Docs: UIActivityIndicatorView](https://developer.apple.com/documentation/uikit/uiactivityindicatorview)  
[🍎Apple Docs: UICalendarView](https://developer.apple.com/documentation/uikit/uicalendarview)  
[📼Apple WWDC: Meet async/await in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/)  
[📼Apple WWDC: Use async/await with URLSession](https://developer.apple.com/videos/play/wwdc2021/10095/)  
[📘blog: [Swift] Actor 뿌시기](https://sujinnaljin.medium.com/swift-actor-%EB%BF%8C%EC%8B%9C%EA%B8%B0-249aee2b732d)  
[📗야곰닷넷: Swift Concurrency Programming](https://yagom.net/courses/swift-concurrency-programming/)  
