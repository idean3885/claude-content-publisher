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
- **검증 단일 소스**: content:verify가 리더빌리티 + 톤의 유일한 검증 지점. write와 publish는 verify에 위임
- **디렉토리 무관**: 글로벌 설정 기반, 빈 디렉토리에서도 동작
- **범용성**: 특정 콘텐츠 소스에 종속되지 않음

## 릴리스 규칙 (HARD CONSTRAINTS)

| 금지 행위 | 이유 | 올바른 방법 |
|----------|------|------------|
| plugin.json 버전 직접 편집 | marketplace.json과 불일치 발생 | `./scripts/release.sh` 사용 |
| marketplace.json 버전 직접 편집 | plugin.json과 불일치 발생 | `./scripts/release.sh` 사용 |
| VERSION 파일 생성 | 이중 소스 발생 (v3.1.0에서 삭제됨) | plugin.json이 단일 소스 |
| git push 후 캐시 검증 생략 | 로컬 설치 버전과 리모트 불일치 미감지 | release.sh가 자동 검증 |

릴리스 절차: `./scripts/release.sh [patch|minor|major] ["메시지"]`
