#!/usr/bin/env bash
# scan-commits.sh - 扫描指定目录下所有 git 仓库的 commit 记录
# 用法: ./scan-commits.sh <repo_root> <author> <since> <until> [projects...]
#   repo_root : 代码仓库根目录
#   author    : git 用户名（用于 --author 过滤）
#   since     : 起始日期（YYYY-MM-DD 或 git 支持的相对格式，如 "14 days ago"）
#   until     : 结束日期（YYYY-MM-DD）
#   projects  : 可选，只扫描匹配的项目名（空格分隔）。不传则扫描全部

set -euo pipefail

REPO_ROOT="${1:?用法: scan-commits.sh <repo_root> <author> <since> <until> [projects...]}"
AUTHOR="${2:?缺少 author}"
SINCE="${3:?缺少 since}"
UNTIL="${4:?缺少 until}"
shift 4
PROJECTS="$*"

if [ ! -d "$REPO_ROOT" ]; then
  echo "错误: 仓库目录不存在: $REPO_ROOT" >&2
  exit 1
fi

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

find "$REPO_ROOT" -maxdepth 3 -name ".git" -type d -exec dirname {} \; 2>/dev/null | while IFS= read -r dir; do
  project=$(basename "$dir")
  # 如果指定了项目名，跳过不匹配的
  if [ -n "$PROJECTS" ]; then
    match=false
    for p in $PROJECTS; do
      [ "$p" = "$project" ] && match=true && break
    done
    $match || continue
  fi
  commits=$(git -C "$dir" log --author="$AUTHOR" \
    --since="$SINCE" --until="$UNTIL" \
    --format="%ad %s" --date=short --no-merges 2>/dev/null || true)
  [ -z "$commits" ] && continue
  touch "$tmpfile"
  echo "=== $project ==="
  echo "$commits"
  echo ""
done

if [ ! -f "$tmpfile" ]; then
  echo "未找到匹配的 commit 记录。请检查：仓库路径 ($REPO_ROOT)、作者名 ($AUTHOR)、日期范围 ($SINCE ~ $UNTIL)" >&2
fi
