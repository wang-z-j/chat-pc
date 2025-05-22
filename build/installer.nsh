!include "MUI2.nsh"

!insertmacro MUI_PAGE_DIRECTORY    ; 👈 仅此页面：选择安装目录
!insertmacro MUI_PAGE_INSTFILES    ; 安装进度页
!insertmacro MUI_PAGE_FINISH       ; 完成页

!insertmacro MUI_LANGUAGE "SimpChinese"

Section
  SetOutPath "$INSTDIR"
  ; 放置你要复制的文件逻辑（electron-builder 会处理，不需要你写）
SectionEnd
