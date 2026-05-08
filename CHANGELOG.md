# Changelog

형식: [Semantic Versioning](https://semver.org/)

## [3.11.0] - 2026-05-08

### Added
- **저자 톤 T13 추가**: 사례·관찰 서술은 1인칭 회상으로 통일 (readability.md § 8)
  - 저자 직접 관여 작업·관찰·판단은 1인칭 회상 톤(`확인했습니다`, `예상했습니다`, `추적했습니다`, `재현했습니다`)
  - 3인칭 기계식(`브라우저가 자체 추정으로 진입했습니다`) 또는 익명 수동태(`재현되었습니다`, `검출되지 않았습니다`) 회피
  - 시스템·표준 일반 동작 정의는 3인칭 현재형 허용 (`브라우저는 ... 안 합니다`, `Swift는 ... 발급합니다`)
  - 검증 체크리스트(T13) + 콘텐츠 유형별 프로필표(필수●)에 반영
  - verify SKILL.md의 T1~T12 참조를 T1~T13으로 갱신
  - 배경: 글을 쓰는 시점에 저자는 이미 1인칭. 사례 회상을 시스템 보고서처럼 3인칭 기계식으로 묘사하면 저자성·신뢰도가 떨어짐

## [3.10.0] - 2026-05-08

### Added
- **저자 톤 T12 추가**: 분석 틀 라벨 헤딩 노출 금지 (readability.md § 8)
  - PAAR/STAR/ABCDE 같은 분석 프레임워크의 단계 표시(`P.`, `A1.`, `R.`)를 헤딩에 노출하지 않는다
  - 순차 단계 번호(`Step N:`, `Phase N:`), 알파벳 분류 표지(`A./B./C.`)도 동일 적용
  - 자동 판별 가능: 헤딩이 `^[A-Z][0-9]?\.\s` 또는 `^Step \d+:` 또는 `^Phase \d+:` 패턴인지 검사
  - 검증 체크리스트(T12) + 콘텐츠 유형별 프로필표(필수●)에 반영
  - verify SKILL.md의 T1~T11 참조를 T1~T12로 갱신
  - 배경: 분석 틀은 글을 조직하는 사고의 도구이지 독자에게 보이는 표지가 아님. 라벨을 가시화하면 AI 생성 텍스트 신호로 인식됨

## [3.3.0] - 2026-04-17

### Fixed
- content:publish Phase 2의 `date` 설정 규칙 강화 (버그 수정)
  - 기준 타임존을 KST(+0900)로 고정
  - **현재 시각보다 과거** 필수, 최소 5분 이전 권장
  - 커밋 직전 `date` 명령으로 재확인 절차 명시
  - 배경: 미래 시각 설정 시 Jekyll `future: false` 기본값에 걸려 빌드에서 제외 → 배포 404 발생 (실제 장애 사례 발생)
- 변환 발행 모드의 발행 날짜 기본값도 동일 규칙으로 정합화

## [3.2.0] - 2026-04-03

### Added
- content:verify를 리더빌리티 + 톤의 검증 단일 소스로 명시
- content:verify 축 2에 저자 톤 검증 3항목 추가 (합쇼체, 주어 생략, 감정어 최소화)
- content:write에 금지 패턴(4건) + verify 위임 게이트 + 체크포인트 추가
- content:publish에 금지 패턴(3건) + 변환 입력 게이트 + verify 위임 게이트 + 체크포인트 추가
- README.md에 릴리스 금지 패턴 추가
- scripts/release.sh 문서화 (v3.1.1에서 추가)

### Changed
- content:write Phase 3-2: 리더빌리티 자체 적용 → content:verify(inline) 위임
- content:publish Phase 4 가독성: 자체 적용 → content:verify(standalone) 위임

## [3.0.0] - 2026-03-25

### Breaking Changes
- 플러그인 리네임: `blog` → `content` (claude-content-publisher)
- `/blog:write` → `/content:publish` (Jekyll 변환 발행)
- `/blog:verify` → `/content:verify` (이중 모드: standalone 사후 + inline 사전)
- NEW: `/content:write` (범용 콘텐츠 작성 엔진)

### Added
- `content:write` 스킬: 문서 성격 파악, 시리즈 구조, 작성 원칙, 인라인 검증 통합
- `content:verify` inline 모드: 작성 중 가독성 규칙 즉시 적용
- `content:publish` 스킬: 구 `/blog:write`를 발행 전용으로 분리

### Changed
- `content:verify`: 사내 의존 제거 (위키 URL 입력 제거, 본문/파일만 허용)

### Removed
- 위키 URL/페이지 ID 직접 조회 (오케스트레이터 책임으로 이동)

## [2.0.0] - 2026-03-19

### Breaking Changes
- `/blog:post` + `/blog:publish` → `/blog:write` 통합
  - 직접 작성 모드: 저자 소재 수집 → 작성 → 비평가 검토 → Jekyll 변환 → 커밋
  - 변환 발행 모드: 콘텐츠 제공 시 Jekyll 변환만 수행 (오케스트레이션 패턴)

### Added
- `/blog:verify` 스킬: 포스팅 전용 3축 검증 (사실 정확성, 구조/완성도, 독립 가치)

### Removed
- `/blog:post` 스킬 (→ `/blog:write` 직접 작성 모드로 흡수)
- `/blog:publish` 스킬 (→ `/blog:write` 변환 발행 모드로 흡수)

## [1.0.0] - 2026-03-16

### Added
- `/blog:publish` 스킬: 클린 콘텐츠 → Jekyll 블로그 변환 발행
  - 글로벌 설정 (`~/.claude/blog-publisher.json`)으로 디렉토리 무관 실행
  - Chirpy 테마 형식 변환 (front matter, TL;DR, 스타일링)
- `/blog:post` 스킬: 블로그 포스팅 직접 작성
  - 저자 소재 수집 → 본문 작성 → 비평가 검토 워크플로우
  - 품질 기준 7개 + 가독성 기준 7개
  - 참조 프로젝트 추적
- 마켓플레이스 플러그인 구조
