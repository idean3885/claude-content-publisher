# claude-blog-publisher

Blog Publishing Plugin for Claude Code

콘텐츠를 Jekyll 블로그 포스팅으로 변환 발행하는 Claude Code 플러그인입니다.

## 스킬

| 스킬 | 커맨드 | 역할 |
|------|--------|------|
| publish | `/blog:publish` | 클린 콘텐츠 → Jekyll 블로그 변환 발행 |
| post | `/blog:post` | 블로그 포스팅 직접 작성 |

## 설치

```bash
# 마켓플레이스 등록
/plugin marketplace add https://github.com/idean3885/claude-blog-publisher.git

# 설치
/plugin install blog
```

## 설정

`/blog:publish`는 어떤 디렉토리에서든 실행 가능합니다.
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

- **결과물과 도구의 분리**: 블로그 레포는 콘텐츠(`_posts/`)만, 이 플러그인은 도구만
- **형식 변환 전담**: 콘텐츠 검증·정제는 소스 측 책임, 이 플러그인은 변환만
- **디렉토리 무관**: 글로벌 설정 기반, 빈 디렉토리에서도 동작
- **범용성**: 특정 콘텐츠 소스에 종속되지 않음
