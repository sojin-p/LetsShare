<img src="https://github.com/sojin-p/LetsShare/assets/140357450/c7e15d3c-76d0-4ead-a399-f06167f3c018" width="150" height="150"/>

# Let's Share! - 관심사 공유 플랫폼
![iPhone Screenshot](https://github.com/sojin-p/LetsShare/assets/140357450/5f466708-584f-4aa0-a4b8-b9190815b428)

<Br>

## 목차
:link: [개발 기간 및 환경](#개발-기간-및-환경)  
:link: [사용 기술 및 라이브러리](#사용-기술-및-라이브러리)  
:link: [핵심 기능](#핵심-기능)  
:link: [고려했던 사항](#고려했던-사항)  
:link: [트러블 슈팅](#트러블-슈팅)  
:link: [회고](#회고)  

<Br>

## 개발 기간 및 환경
- 개인 프로젝트
- 23.11.12 ~ 23.01.27 (약 2개월)
- Xcode 15.0.1 / Swfit 5.9 / iOS 16+
 
<Br>

## 사용 기술 및 라이브러리
| Kind         | Stack                                                          |
| ------------ | -------------------------------------------------------------- |
| 아키텍쳐     | `MVC` `MVVM` `Input-Output` `Singleton`                          |
| 프레임워크   | `Foundation` `UIKit`                                              | 
| 라이브러리   | `RxSwift` `SnapKit` `Moya` `Kingfisher` `SideMenu` `TextFieldEffects` `Toast` `Request Interceptor` |
| 의존성관리   | `Swift Package Manager`                                           |
| ETC.         | `CodeBasedUI`                                                  |  

<Br>

## 핵심 기능
- **회원가입, 이메일 중복확인** : 정규식을 활용한 유효성 검사 로직
- **로그인** : RxSwfit와 Input-Output 패턴 활용
- **Interceptor**를 활용한 **토큰 갱신** 로직
- **포스트 조회 및 작성** : MultipartFormData를 활용한 네트워크 통신
- Cursur 기반 **Pagination**
- 서버 통신 시 **Activity Indicator**로 사용자 경험 향상
- **Toast 알림** : 즉각적인 피드백 제공

<Br>

## 고려했던 사항

- **유지 보수성** 향상 및 코드의 **재사용성**
  - API 에러 코드를 **열거형**으로 정의
  - **APIManager** 파일에서 CallRequest 메서드를 **제네릭**으로 관리
  - **MVVM** 아키텍처를 **Input-Output 패턴**으로 추상화
  - 재사용되는 Input-Output 패턴 **Protocol**로 구조화
  - 유효성 검사 정규식과 에러 메세지를 **열거형**으로 정의

 - **안정성** 및 **최적화**
   -  **Interceptor**를 활용한 **토큰 갱신** 로직 구현
   -  **UserDefaults**의 Key, Value를 **제네릭 구조체**로 추상화 후 **열거형** 정의
   - Cursur 기반 **Pagination**

- 편리한 **사용자 경험**
   - 서버 통신 로딩 시 **Activity Indicator**로 사용자 경험 향상
   - **Toast** 알림으로 **즉각적인 피드백** 제공
   - 버튼 상태에 따른 색상 변경으로 **직관적**인 안내 제공
 
<Br>

## 트러블 슈팅
1. 피드 화면 TableView에서 스크롤 시 이미지가 사라지는 이슈
   - **원인** : 이미지가 없을 때 썸네일 ImageView를 hidden 처리 하였는데, Cell의 재사용 매커니즘에 의해 hidden 처리가 반복되어 발생
   - **해결** : Cell의 prepareForReuse 메서드에 imageView의 hidden을 초기화하여 해결
```swift
override func prepareForReuse() {
        thumbImageView.image = nil
        thumbImageView.isHidden = false
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
```

<Br>

2. 포스트 작성 네트워크 통신 시 Status code 400번 오류
   - **원인** : 이미지 용량이 제한사항보다 커서 발생
   - **해결** : 이미지를 압축하여 해결
```swift
func imageToData(_ image: UIImage) -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return Data() }
        return imageData
    }
```

<Br>

3. 게시글 날짜 Label에 nil이 할당되는 이슈
   - **원인** : 서버에서 받은 날짜 형식과 date format이 일치하지 않아서 발생
   - **해결** : date format을 변경하여 해결
     
```swift
extension String {
    
    func toDate(to type: DateFormatType) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.dateFormat = type.description //"yyyy.MM.dd HH:mm" -> "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: self)
    }
    
}
```

<Br>

## 회고
- RxSwift와 Input-Output 패턴을 학습한 이후 처음으로 해당 프로젝트에 적용하였습니다. 회원가입 시 사용자가 실시간으로 유효성 검사 결과를 확인할 수 있으면 좋겠다는 생각으로 RxSwift를 선택하였는데, Input-Output 패턴도 도입하면서 코드가 훨씬 가독성이 높아지고, 간결해졌습니다. 아직은 RxSwift가 익숙하지 않아 회원가입 및 로그인 뷰에 그쳤지만, 앞으로는 RxSwift를 더욱 깊이있게 학습하여 프로젝트 전체에 적용할 계획입니다.
- Kingfisher로 사진을 불러오면서 다양한 옵션을 활용할 수 있다는 것을 알게 되었습니다. 이전에는 단순히 사진을 불러오는 용도로만 사용하였지만, 이번 프로젝트에서는 이미지 요청 시 사용자 인증 정보를 함께 요청하고, 이미지 로드 시 Activity indicator와 Fade 효과를 적용하여 사용자 경험을 높였습니다. 그러나 캐싱 기능을 구현하지 못해 아쉬웠습니다. 앞으로는 캐싱 기능을 보완하여 불필요한 네트워크 요청을 줄여 더 나은 사용자 경험을 제공할 계획입니다.
- 서버 통신 중 네트워크가 원활하지 않은 상황에 대한 대응이 부족하다고 느꼈습니다. 시간 제약으로 구현하지 못했지만, 추후 NWPathMonitor를 대입하여 서버 통신 실패 시 네트워크 확인이나, 재연결 알림을 띄우는 등 대응할 계획입니다.
