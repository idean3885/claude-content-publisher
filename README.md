# claude-content-publisher

Content Publishing Plugin for Claude Code

콘텐츠 작성, 검증, Jekyll 블로그 발행을 통합하는 Claude Code 플러그인입니다.

## 스킬

| 스킬 | 커맨드 | 역할 |
|------|--------|------|
| write | `/content:write` | 범용 콘텐츠 작성 엔진 (문서 성격 파악, 시리즈 구조, 인라인 검증) |
| verify | `/content:verify` | 콘텐츠 검증 (품질 3축 + 가독성 24규칙, 이중 모드) |
| publish | `/content:publish` | Jekyll 블로그 변환 발행 |

## 참조 문서

| 문서 | 경로 | 설명 |
|------|------|------|
| 가독성 규칙 | `references/readability.md` | 마크다운 가독성 24개 규칙 + 콘텐츠 유형별 프로필 |

## 설치

```bash
# 마켓플레이스 등록
/plugin marketplace add https://github.com/idean3885/claude-content-publisher.git

# 설치
/plugin install content
```

## 설정

`/content:publish`는 어떤 디렉토리에서든 실행 가능합니다.
초회 실행 시 글로벌 설정 파일을 자동 생성합니다.

```
~/.claude/blog-publisher.json
```

```json
{
  "blogRepo": "/path/to/blog-repo"
}
```

## 설계 원칙

- **대외/사내 분리**: 이 플러그인은 범용 콘텐츠 엔진만 제공, 사내 코드(API, pageId 등)는 toolkit으로 분리
- **가독성 규칙 원천**: 모든 마크다운 콘텐츠(블로그, 위키, 로컬 `.md`)의 가독성 기준을 이 플러그인이 관리
- **디렉토리 무관**: 글로벌 설정 기반, 빈 디렉토리에서도 동작
- **범용성**: 특정 콘텐츠 소스에 종속되지 않음
