#!/bin/bash
# تشغيل مشروع IDEC Mobile App من WSL
# Run IDEC Mobile App from WSL

echo "═══════════════════════════════════════════════════"
echo "🚀 تشغيل مشروع IDEC Mobile App من WSL"
echo "═══════════════════════════════════════════════════"
echo ""

# الانتقال إلى مجلد المشروع
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# التحقق من المعاملات
DEVICE="chrome"
PORT=8080
MODE="web"

if [ "$1" == "android" ]; then
    MODE="android"
elif [ "$1" == "edge" ]; then
    DEVICE="edge"
elif [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "الاستخدام:"
    echo "  ./run-from-wsl.sh [chrome|edge|android|help] [port]"
    echo ""
    echo "أمثلة:"
    echo "  ./run-from-wsl.sh              # تشغيل على Chrome"
    echo "  ./run-from-wsl.sh edge         # تشغيل على Edge"
    echo "  ./run-from-wsl.sh android      # تشغيل على Android"
    echo "  ./run-from-wsl.sh chrome 3000  # تشغيل على Chrome بمنفذ 3000"
    exit 0
fi

if [ -n "$2" ]; then
    PORT="$2"
fi

echo "📂 المجلد: $(pwd)"
echo ""

# تشغيل من Windows PowerShell
if [ "$MODE" == "android" ]; then
    echo "🤖 تشغيل على Android..."
    powershell.exe -Command "cd D:\\IDEC\\IDEC2.4\\mobile-app; flutter pub get; flutter run -d android"
else
    echo "🌐 تشغيل على $DEVICE (المنفذ: $PORT)..."
    powershell.exe -Command "cd D:\\IDEC\\IDEC2.4\\mobile-app; flutter pub get; flutter run -d $DEVICE --web-port=$PORT"
fi

echo ""
echo "✅ انتهى التشغيل"






