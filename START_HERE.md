# 🚀 ابدأ من هنا - تشغيل IDEC Mobile App

## ⚡ التشغيل السريع من WSL

```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -File run.ps1
```

هذا كل شيء! التطبيق سيفتح في Chrome على المنفذ 8080.

---

## 📋 الملفات المتاحة للتشغيل

| الملف | الوصف | الاستخدام |
|------|-------|-----------|
| `run.ps1` | سكريبت PowerShell | `powershell.exe -File run.ps1` |
| `run.bat` | سكريبت CMD | `cmd.exe /c run.bat` |
| `run-from-wsl.sh` | سكريبت Bash | `./run-from-wsl.sh` |

---

## 🌐 الخيارات المتاحة

```bash
# Chrome (افتراضي)
powershell.exe -File run.ps1

# Edge
powershell.exe -File run.ps1 -Device edge

# Windows Desktop
powershell.exe -File run.ps1 -Device windows

# منفذ مخصص
powershell.exe -File run.ps1 -Port 3000
```

---

## 📱 الأجهزة المتاحة

✅ Windows (desktop)  
✅ Chrome (web)  
✅ Edge (web)

---

## 💡 نصائح

- اضغط `r` لإعادة التحميل السريع
- اضغط `R` لإعادة التشغيل الكامل
- اضغط `q` للخروج
- استخدم `Ctrl+C` لإيقاف التطبيق

---

## 📚 لمزيد من المعلومات

راجع `RUN_FROM_WSL.md` للتعليمات التفصيلية.






