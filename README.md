# DoodleZip

![Image](https://github.com/user-attachments/assets/08d6fb15-3368-4ea4-bb84-ebe01357cdfd)

### 다양한 메모를 나만의 컬러와 스타일로 기록해보세요.

> 제목과 내용을 손쉽게 작성하고, 원하는 배경을 설정하며, 작성한 메모를 빠르게 검색할 수 있는 감각적인 메모 앱입니다.
> 

---

## ⭐️ 주요 기능

- 간편한 메모 작성
    - 별도의 화면 이동 없이 메모 작성, 수정, 삭제 가능 (애니메이션과 오버레이를 활용)
- 배경 컬러 설정
    - 원하는 색상으로 메모 배경을 설정하여 개성 있는 메모 작성
- 빠른 메모 검색
    - 키워드를 입력해 작성한 메모를 손쉽게 찾아보기 가능

---

## 💻 개발 환경

- **개발 기간**: 2025.02.12 ~ 2025.02.13
- **앱 지원 iOS SDK**: iOS 17.0 이상
- **Xcode**: 15.0 이상
- **Swift 버전**: 5.8 이상

---

## ⚙️ 아키텍처

- **TCA(The Composable Architecture)**
    - **일관된 상태 관리** – 단방향 데이터 흐름을 적용해 상태 변화와 로직을 명확하게 관리
    - **재사용성과 모듈화** – 기능을 독립적인 모듈로 구성하여 유지보수 및 확장 용이
    - **애니메이션 및 UI 업데이트 최적화** – 상태 기반 업데이트로 불필요한 화면 갱신 방지
    - **의존성 주입 및 테스트 가능성 강화** – 의존성을 명확하게 정의하여 유닛 테스트 용이

---

## 📋 설계 패턴

- **싱글턴 패턴**: 전역적으로 관리가 필요한 객체를 재사용하기 위해 사용

---

## 🛠️ 기술 스택

### **기본 구성**

- **SwiftUI**: iOS 사용자 인터페이스 구성
- **Codebase UI**: SwiftUI 기반으로 코드에서 뷰 설계, Storyboard 의존성 제거

### **데이터 관리**

- **Realm**: 경량 데이터베이스로 로컬 데이터 관리

### 테스트

- **XCTest**: 단위 테스트 및 UI 테스트를 통해 안정적인 앱 동작 검증

---

## 🗂️ 파일 디렉토리 구조

```
DoodleZip
 ┣ Assets.xcassets
 ┃ ┣ AccentColor.colorset
 ┃ ┃ ┗ Contents.json
 ┃ ┣ AppIcon.appiconset
 ┃ ┃ ┣ Contents.json
 ┃ ┃ ┗ 두들집 로고.png
 ┃ ┗ Contents.json
 ┣ Extension
 ┃ ┣ Color+Extension.swift
 ┃ ┗ View+Extension.swift
 ┣ Feature
 ┃ ┗ NoteFeature.swift
 ┣ Manager
 ┃ ┗ DateFormatterManager.swift
 ┣ Model
 ┃ ┗ Note.swift
 ┣ Preview Content
 ┃ ┗ Preview Assets.xcassets
 ┃ ┃ ┗ Contents.json
 ┣ Realm
 ┃ ┗ RealmClient.swift
 ┣ View
 ┃ ┗ HomeView.swift
 ┣ ContentView.swift
 ┗ DoodleZipApp.swift

DoodleZipTests
 ┣ DoodleZipTests.swift
 ┗ NoteFeatureTests.swift
```
