Unicode true

!include "MUI2.nsh"
!define MUI_ABORTWARNING

!define PRODUCT_NAME "${productName}"
!define PRODUCT_VERSION "${version}"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection"
  SetOutPath "$INSTDIR"
SectionEnd

Section "Uninstall"
SectionEnd
