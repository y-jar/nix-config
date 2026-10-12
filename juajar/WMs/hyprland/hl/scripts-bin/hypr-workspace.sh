#!/usr/bin/env bash
# Per-monitor workspace dispatcher
# Orders monitors by position (x, then y), assigns 10 workspaces each.
# Usage: hypr-workspace.sh <focus|move> <target>
#   target: 1-10 (absolute within monitor), r+1/r-1 (relative), e+1/e-1 (cycle)

ACTION="$1"
TARGET="$2"
WORKSPACES_PER_MONITOR=10

if [ -z "$ACTION" ] || [ -z "$TARGET" ]; then
    echo "Usage: $0 <focus|move> <target>" >&2
    exit 1
fi

# Get current workspace info
ACTIVE_JSON=$(hyprctl activeworkspace -j 2>/dev/null)
if [ -z "$ACTIVE_JSON" ]; then
    exit 1
fi

ACTIVE_WS=$(echo "$ACTIVE_JSON" | jq -r '.id')
ACTIVE_MONITOR=$(echo "$ACTIVE_JSON" | jq -r '.monitor')

# Get all monitors sorted by position (x, then y)
MONITORS_JSON=$(hyprctl monitors -j 2>/dev/null)
if [ -z "$MONITORS_JSON" ]; then
    exit 1
fi

# Build sorted monitor list: "name x y" lines, sorted by x then y
SORTED_MONITORS=$(echo "$MONITORS_JSON" | jq -r '.[] | "\(.name) \(.x) \(.y)"' | sort -k2 -n -k3 -n)

# Find current monitor's index (0-based)
MONITOR_INDEX=0
IDX=0
while IFS= read -r line; do
    MON_NAME=$(echo "$line" | awk '{print $1}')
    if [ "$MON_NAME" = "$ACTIVE_MONITOR" ]; then
        MONITOR_INDEX=$IDX
        break
    fi
    IDX=$((IDX + 1))
done <<< "$SORTED_MONITORS"

OFFSET=$((MONITOR_INDEX * WORKSPACES_PER_MONITOR))

case "$TARGET" in
    [0-9]|10)
        # Absolute workspace within monitor
        ABS_WS=$((OFFSET + TARGET))
        if [ "$ABS_WS" -lt 1 ]; then ABS_WS=1; fi
        if [ "$ACTION" = "focus" ]; then
            hyprctl dispatch workspace "$ABS_WS"
        elif [ "$ACTION" = "move" ]; then
            hyprctl dispatch movewindow workspace "$ABS_WS"
        fi
        ;;
    r+1|r-1)
        # Relative: move by 1 within monitor bounds
        CURRENT_OFFSET=$((ACTIVE_WS - OFFSET))
        if [ "$TARGET" = "r+1" ]; then
            NEW_OFFSET=$((CURRENT_OFFSET + 1))
        else
            NEW_OFFSET=$((CURRENT_OFFSET - 1))
        fi
        # Clamp to 1-10
        if [ "$NEW_OFFSET" -lt 1 ]; then NEW_OFFSET=1; fi
        if [ "$NEW_OFFSET" -gt "$WORKSPACES_PER_MONITOR" ]; then NEW_OFFSET=$WORKSPACES_PER_MONITOR; fi
        ABS_WS=$((OFFSET + NEW_OFFSET))
        if [ "$ACTION" = "focus" ]; then
            hyprctl dispatch workspace "$ABS_WS"
        elif [ "$ACTION" = "move" ]; then
            hyprctl dispatch movewindow workspace "$ABS_WS"
        fi
        ;;
    e+1|e-1)
        # Cycle: wrap around within monitor bounds
        CURRENT_OFFSET=$((ACTIVE_WS - OFFSET))
        if [ "$TARGET" = "e+1" ]; then
            NEW_OFFSET=$(( (CURRENT_OFFSET % WORKSPACES_PER_MONITOR) + 1 ))
        else
            NEW_OFFSET=$(( CURRENT_OFFSET - 1 ))
            if [ "$NEW_OFFSET" -lt 1 ]; then
                NEW_OFFSET=$WORKSPACES_PER_MONITOR
            fi
        fi
        ABS_WS=$((OFFSET + NEW_OFFSET))
        if [ "$ACTION" = "focus" ]; then
            hyprctl dispatch workspace "$ABS_WS"
        elif [ "$ACTION" = "move" ]; then
            hyprctl dispatch movewindow workspace "$ABS_WS"
        fi
        ;;
    *)
        echo "Invalid target: $TARGET" >&2
        exit 1
        ;;
esac
