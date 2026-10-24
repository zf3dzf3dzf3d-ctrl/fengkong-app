#!/data/data/com.termux/files/usr/bin/bash
# 朱峰桥 v4：单实例锁 + 命令防重复 + 状态回执 + watchdog
BASE="/sdcard/Download/朱峰智能体/mailbox"
CMDIR="$BASE/cmds"
OUTDIR="$BASE/cmd_out"
LOCK="$BASE/bridge.lock"
LOG="$BASE/bridge.log"
HB="$BASE/heartbeat.txt"
mkdir -p "$CMDIR" "$OUTDIR"

# ---- 1) 单实例：防止 v2/v3/v4 混跑、重复消费 ----
if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  echo "$(date '+%m-%d %H:%M:%S') [桥v4] 已有实例 PID $(cat $LOCK) 在跑，本实例退出" >> "$LOG"
  exit 0
fi
echo $$ > "$LOCK"

log(){ echo "$(date '+%m-%d %H:%M:%S') $*" >> "$LOG"; }
log "[桥v4] 启动 PID $$"

# ---- 2) watchdog：心跳超时由 crontab/自拉起兜底 ----
while true; do
  echo "$(date '+%m-%d %H:%M:%S') | PID $$ | v4 running" > "$HB"

  # 通知通道
  if [ -f "$BASE/notify.txt" ]; then
    title=$(head -n1 "$BASE/notify.txt" 2>/dev/null)
    body=$(tail -n +2 "$BASE/notify.txt" 2>/dev/null)
    if [ -n "$title" ]; then
      termux-notification --title "📥 ${title:0:40}" --content "${body:0:200}" >/dev/null 2>&1
      log "[桥v4] 送达: ${title:0:30}"
    fi
    rm -f "$BASE/notify.txt"
  fi

  # 命令通道：原子消费（先改名再执行，杜绝重复执行）
  for f in "$CMDIR"/*.cmd; do
    [ -e "$f" ] || continue
    name=$(basename "$f" .cmd)
    busy="$CMDIR/$name.running"
    mv "$f" "$busy" 2>/dev/null || continue   # 原子抢占，另一实例抢不到

    out="$OUTDIR/$name.out"
    {
      echo "--- cmd[$name] $(date '+%F %T') ---"
      bash "$busy" 2>&1
      echo "--- exit:$? ---"
    } > "$out" 2>&1 &
    OUT_PID=$!

    # 命令级超时 120s，防止死命令堵死通道
    ( sleep 120; kill $OUT_PID 2>/dev/null ) & WATCHDOG=$!
    wait $OUT_PID 2>/dev/null
    kill $WATCHDOG 2>/dev/null
    rm -f "$busy"
    log "[桥v4] 命令 $name 已执行（回执 $name.out）"
  done

  sleep 3
done
