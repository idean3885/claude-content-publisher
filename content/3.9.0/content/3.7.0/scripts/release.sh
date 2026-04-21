#!/bin/bash
# content-publisher 릴리스 파이프라인
# 버전 범프(plugin.json + marketplace.json) → 커밋 → 태그 → push → 마켓플레이스 업데이트 → 플러그인 업데이트 → 캐시 검증
#
# 사용법: ./scripts/release.sh [patch|minor|major] ["커밋 메시지"]
# 기본값: patch

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_JSON="$REPO_DIR/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$REPO_DIR/.claude-plugin/marketplace.json"
MARKETPLACE_NAME="claude-content-publisher"
PLUGIN_NAME="content"

BUMP_TYPE="${1:-patch}"
MESSAGE="${2:-}"

cd "$REPO_DIR"

# 1. 현재 버전 읽기
CURRENT_VERSION=$(python3 -c "import json; print(json.load(open('$PLUGIN_JSON'))['version'])")
echo "현재 버전: $CURRENT_VERSION"

# 2. 버전 범프 (plugin.json + marketplace.json 동시)
NEW_VERSION=$(python3 -c "
import json

def bump(version, bump_type):
    parts = version.split('.')
    if bump_type == 'major':
        parts[0] = str(int(parts[0]) + 1); parts[1] = '0'; parts[2] = '0'
    elif bump_type == 'minor':
        parts[1] = str(int(parts[1]) + 1); parts[2] = '0'
    else:
        parts[2] = str(int(parts[2]) + 1)
    return '.'.join(parts)

# plugin.json
with open('$PLUGIN_JSON') as f:
    pj = json.load(f)
new_ver = bump(pj['version'], '$BUMP_TYPE')
pj['version'] = new_ver
with open('$PLUGIN_JSON', 'w') as f:
    json.dump(pj, f, indent=2, ensure_ascii=False)
    f.write('\n')

# marketplace.json
with open('$MARKETPLACE_JSON') as f:
    mj = json.load(f)
for plugin in mj.get('plugins', []):
    if plugin.get('name') == '$PLUGIN_NAME':
        plugin['version'] = new_ver
with open('$MARKETPLACE_JSON', 'w') as f:
    json.dump(mj, f, indent=2, ensure_ascii=False)
    f.write('\n')

print(new_ver)
")
echo "새 버전: $NEW_VERSION"

# 3. 커밋
git add -A
COMMIT_MSG="chore: bump v${NEW_VERSION}"
if [ -n "$MESSAGE" ]; then
    COMMIT_MSG="$MESSAGE (v${NEW_VERSION})"
fi
git commit -m "$COMMIT_MSG

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
echo "커밋 완료"

# 4. 태그
git tag "v${NEW_VERSION}"
echo "태그: v${NEW_VERSION}"

# 5. Push
git push origin main
git push origin "v${NEW_VERSION}"
echo "Push 완료"

# 6. 마켓플레이스 업데이트
claude plugin marketplace update "$MARKETPLACE_NAME" 2>&1 | tail -1
echo "마켓플레이스 업데이트 완료"

# 7. 플러그인 업데이트 (캐시 갱신)
claude plugin update "${PLUGIN_NAME}@${MARKETPLACE_NAME}" 2>&1 | tail -1
echo "플러그인 업데이트 완료"

# 8. 캐시 검증
CACHE_DIR="$HOME/.claude/plugins/cache/${MARKETPLACE_NAME}/${PLUGIN_NAME}"
CACHE_VERSION=$(ls -1 "$CACHE_DIR" | sort -V | tail -1)
CACHE_PLUGIN_VER=$(python3 -c "import json; print(json.load(open('${CACHE_DIR}/${CACHE_VERSION}/.claude-plugin/plugin.json'))['version'])")

if [ "$CACHE_PLUGIN_VER" = "$NEW_VERSION" ]; then
    echo "검증 완료: 캐시 v${CACHE_PLUGIN_VER}"
else
    echo "검증 실패: 캐시 v${CACHE_PLUGIN_VER} != 기대 v${NEW_VERSION}"
    exit 1
fi

echo ""
echo "릴리스 완료: v${NEW_VERSION}"
