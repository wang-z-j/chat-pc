Unicode true

!include "MUI2.nsh"
!define MUI_ABORTWARNING


!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_INSTFILES
; ⚠️ 覆盖安装完成页默认的执行
!undef MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN "$INSTDIR\lanyiAI.exe"
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection"
  SetOutPath "$INSTDIR"
SectionEnd

Section "Uninstall"
SectionEnd
