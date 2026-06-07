#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TRACKING_FILE="$SKILLS_DIR/.opencode/upstream.json"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ ! -f "$TRACKING_FILE" ]; then
  echo "Error: tracking file not found at $TRACKING_FILE"
  exit 1
fi

has_update=0

for row in $(jq -c '.upstream[]' "$TRACKING_FILE"); do
  owner=$(echo "$row" | jq -r '.owner')
  repo=$(echo "$row" | jq -r '.repo')
  branch=$(echo "$row" | jq -r '.branch')
  is_local=$(echo "$row" | jq -r '.local // false')
  recorded=$(echo "$row" | jq -r '.head // ""')
  skills=$(echo "$row" | jq -r '.skills | join(", ")')
  url=$(echo "$row" | jq -r '.url')

  echo -e "${YELLOW}${owner}/${repo} (${branch})${NC}"
  echo "  Skills: $skills"

  if [ "$is_local" = "true" ]; then
    echo -e "  ${GREEN}Local source — no upstream check needed${NC}"
    echo
    continue
  fi

  echo "  Recorded: $recorded"

  latest=$(curl -s "https://api.github.com/repos/${owner}/${repo}/commits/${branch}?per_page=1" | jq -r '.sha')

  if [ -z "$latest" ] || [ "$latest" = "null" ]; then
    echo -e "  ${RED}ERROR: Failed to fetch latest commit${NC}"
    echo "  Rate limit may be exceeded. Try again later."
    echo
    continue
  fi

  echo "  Latest:   $latest"

  if [ "$recorded" = "$latest" ]; then
    echo -e "  ${GREEN}Up to date${NC}"
  else
    echo -e "  ${RED}UPDATE AVAILABLE${NC}"
    echo "  Compare: $url/compare/$recorded...$latest"
    has_update=1
  fi
  echo
done

if [ "$has_update" -eq 0 ]; then
  echo -e "${GREEN}All skills are up to date with their upstream sources.${NC}"
else
  echo -e "${RED}Some upstream repos have new commits.${NC}"
  echo "To update the recorded HEAD:"
  echo "  Update '.opencode/upstream.json' with the new SHAs shown above,"
  echo "  then review and merge any changes from upstream."
  exit 1
fi
