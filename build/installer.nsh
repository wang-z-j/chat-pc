!include "MUI2.nsh"

; === 界面图像 ===
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "build/icon.ico"
; === 安装页面顺序 ===
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "build/license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; === 语言 ===
!insertmacro MUI_LANGUAGE "SimpChinese"
