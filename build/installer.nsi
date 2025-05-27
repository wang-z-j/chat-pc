;----------------  基本配置  ----------------
Unicode true
!include "MUI2.nsh"
!include "nsDialogs.nsh"

;!define PRODUCT_NAME   "${productName}"
;!define PRODUCT_VER    "${version}"
;!define EXE_NAME       "${executableName}.exe"

;----------------  页面顺序  ----------------
!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_LICENSE "build\\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
Page custom Page_Options Page_Options_Leave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
;!insertmacro MUI_LANGUAGE "SimpChinese"

;----------------  自定义选项页  ----------------
Var CHK_DESKTOP
Var CHK_AUTOSTART
Var CHK_PIN
Var VAL_DESKTOP
Var VAL_AUTOSTART
Var VAL_PIN

Function Page_Options
  nsDialogs::Create 1018
  Pop $0
  ${NSD_CreateLabel} 0 0 100% 12u "安装选项"
  Pop $0
  ${NSD_CreateCheckbox} 0 20u 100% 12u "创建桌面快捷方式"
  Pop $CHK_DESKTOP
  ${NSD_SetState} $CHK_DESKTOP ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 40u 100% 12u "开机自动启动"
  Pop $CHK_AUTOSTART
  ${NSD_SetState} $CHK_AUTOSTART ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 60u 100% 12u "固定到任务栏"
  Pop $CHK_PIN
  ${NSD_SetState} $CHK_PIN ${BST_UNCHECKED}
  nsDialogs::Show
FunctionEnd

Function Page_Options_Leave
  ${NSD_GetState} $CHK_DESKTOP  $VAL_DESKTOP
  ${NSD_GetState} $CHK_AUTOSTART $VAL_AUTOSTART
  ${NSD_GetState} $CHK_PIN       $VAL_PIN
FunctionEnd

;----------------  主安装节  ----------------
Section "Install"
  SetOutPath "$INSTDIR"
  File /r "dist\\*.*"
  File "build\\syspin.exe"

  ; 桌面快捷方式
  ${If} $VAL_DESKTOP == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\\${PRODUCT_NAME}.lnk" "$INSTDIR\\${EXE_NAME}"
  ${EndIf}

  ; 开机启动
  ${If} $VAL_AUTOSTART == ${BST_CHECKED}
    WriteRegStr HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Run" "${PRODUCT_NAME}" '"$INSTDIR\\${EXE_NAME}"'
  ${EndIf}

  ; 任务栏固定
  ${If} $VAL_PIN == ${BST_CHECKED}
    ExecWait '"$INSTDIR\\syspin.exe" "$INSTDIR\\${EXE_NAME}" c:5386'
  ${EndIf}

  ; 卸载信息
  WriteUninstaller "$INSTDIR\\uninst.exe"
SectionEnd

;--------------  卸载节（可选精简）  --------------
Section "Uninstall"
  Delete "$DESKTOP\\${PRODUCT_NAME}.lnk"
  DeleteRegValue HKCU "Software\\Microsoft\\Windows\\CurrentVersion\\Run" "${PRODUCT_NAME}"
  RMDir /r "$INSTDIR"
SectionEnd
