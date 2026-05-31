#!/bin/sh
input=$(cat)

user=$(whoami)
host=$(hostname -s)
dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

git_branch=""
if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && git_branch=" [$branch]"
fi

ctx=""
[ -n "$used" ] && ctx=" ctx:$(printf '%.0f' "$used")%"

printf "%s@%s %s%s | %s%s\n" "$user" "$host" "$dir" "$git_branch" "$model" "$ctx"
