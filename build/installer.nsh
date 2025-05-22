!include "MUI2.nsh"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${BUILD_RESOURCES_DIR}\icon.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${BUILD_RESOURCES_DIR}\icon.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${BUILD_RESOURCES_DIR}\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"
