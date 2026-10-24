#!/data/data/com.termux/files/usr/bin/bash
# 朱峰 · Mihon 自动下载器 v2（优化版）
# 对比 v1 的优化：
#  1. 镜像优先：GitHub 直连国内基本必挂，v2 把 gh-proxy 等镜像放最前
#  2. 硬超时：每源 curl --max-time 60，不再干等 2 分钟才发现 size=0
#  3. 失败快速切换：超时/404 立即换下一个源
#  4. 下载后校验 PK 头 + 最小体积，防假成功
#  5. 全部失败时自动用浏览器打开镜像兜底链接
set -u
OUT=/sdcard/Download/朱峰智能体
APK="$OUT/Mihon.apk"
TMP="$APK.part"
say(){ echo "[$(date '+%H:%M:%S')] $*"; }

rm -f "$TMP"
say "=== mihon_dl v2 start ==="

# 1) 版本 tag：镜像 API 优先，GitHub API 兜底（10 秒超时）
TAG=''
for A in 'https://gh-proxy.com/https://api.github.com/repos/mihonapp/mihon/releases/latest' \
         'https://api.github.com/repos/mihonapp/mihon/releases/latest'; do
  say "TAG-TRY $A"
  TAG=$(curl -sL --max-time 10 "$A" 2>/dev/null | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/.*"tag_name": *"//;s/"//')
  [ -n "$TAG" ] && break
done
[ -z "$TAG" ] && TAG='v0.21.2'
say "tag=$TAG"

# 2) CPU 架构
ABI=$(uname -m)
case "$ABI" in
  aarch64|arm64) FLAVOR=arm64-v8a ;;
  armv7*|armv8l) FLAVOR=armeabi-v7a ;;
  x86_64)        FLAVOR=x86_64 ;;
  *)             FLAVOR=arm64-v8a ;;
esac
say "abi=$ABI flavor=$FLAVOR"

# 3) 源列表：镜像在前，文件名两种组合
BASE="mihonapp/mihon/releases/download/$TAG"
NAMES="app-$FLAVOR-release.apk app-$FLAVOR.apk"
HOSTS="https://gh-proxy.com/ https://gh.llkk.cc/ https://github.com/"
OK=0
for N in $NAMES; do
  for H in $HOSTS; do
    U="${H}${BASE}/${N}"
    say "TRY $U (max 60s)"
    curl -L --max-time 60 --connect-timeout 10 --retry 1 -o "$TMP" "$U" 2>/dev/null
    SZ=$(stat -c %s "$TMP" 2>/dev/null || echo 0)
    MAGIC=$(head -c 2 "$TMP" 2>/dev/null)
    if [ "$SZ" -gt 1000000 ] && [ "$MAGIC" = 'PK' ]; then
      mv -f "$TMP" "$APK"
      say "APK 就绪 magic=PK size=$SZ ($U)"
      OK=1
      break 2
    fi
    say "  失败 size=$SZ，换下一个源"
  done
done

if [ "$OK" != 1 ]; then
  say '!! 全部源下载失败'
  say "兜底：浏览器打开 https://gh-proxy.com/https://github.com/$BASE 手动点下载"
  termux-open-url "https://gh-proxy.com/https://github.com/$BASE" 2>/dev/null || true
  exit 1
fi

# 4) 三级兜底拉起安装器
termux-open "$APK" 2>/dev/null \
  || termux-am start -a android.intent.action.VIEW -d "file://$APK" -t 'application/vnd.android.package-archive' 2>/dev/null \
  || am start -a android.intent.action.VIEW -d "file://$APK" -t 'application/vnd.android.package-archive' 2>/dev/null \
  || say '自动拉起失败，请到 Download/朱峰智能体/ 手动点 Mihon.apk 安装'
say '=== done ==='
