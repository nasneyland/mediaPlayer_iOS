## dogDiary_iOS
유튜브 뮤직을 벤치마킹 한 미디어 플레이어 앱입니다.<br/><br/>
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_01.jpg"  width="110"> <img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_02.jpg"  width="110">
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_03.jpg"  width="110">
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_04.jpg"  width="110">
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_05.jpg"  width="110">
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_06.jpg"  width="110">
<img src="https://raw.githubusercontent.com/nasneyland/nasneyland/main/mediaplayer_07.jpg"  width="110"><br/>

### 디자인 패턴
- MVC 패턴 사용 (플레이어만 MVP 패턴 사용)
- 컨트롤러에서 뷰를 구성하고, 데이터 통신으로 받아온 객체들을 모델에 저장해 관리
- 음악 재생 클래스는 한 클래스에서 여러개의 뷰에 상태나 변화를 알려줘야 하므로 Presenter를 이용해 구현 (MVP 패턴)

### 레이아웃 구성
- 코드로 레이아웃 구현 : SnapKit
- 홈화면: 테이블 안에 테이블 구현 + 핫 10 음악 캐로셀 페이징처리
- 관심 노래 선택 화면 : 컬렉션 뷰로 음악 셀 구현 후 클릭 시 관련 노래 3개 추가로 로드

### 데이터 통신
- Alamofire을 이용한 데이터 통신 (get, post, put, delete)
- API 매니저를 이용하여 메인 URL과 토큰 관리
- 액세스토큰과 리프레시토큰 키 체인에 저장하여 자동로그인 구현
- API 통신 에러 코드와 메시지 JSON 변환

### 주요 기능
- 소셜로그인 : 구글 / 카카오 / 네이버 / 애플 로그인 구현
- 다국어처리 : **Localizable**을 이용하여 다국어처리 (+ 파이썬으로 파파고 연동하여 자동 번역 해주는 코드 구현)
- 로그 전송 : **Firebase**로 로그정보 전송, 로그 매니저에 로그전송 함수 구현 후 각 액션마다 로그 전송
- 캐시 기록 : 들었던 오디오 정보 기록하기 위해 기기(UserDefaults)에 재생기록 저장
- 오디오 병합 : **AVMutableComposition** 을 이용하여 두 오디오 파일 병합
