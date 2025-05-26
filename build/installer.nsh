; 启用 Unicode
Unicode true

!include "MUI2.nsh"
!include "nsDialogs.nsh"

!define PRODUCT_PUBLISHER "ccccltd, Inc."
!define PRODUCT_WEB_SITE "https://c4ai.ccccltd.cn/"

Var Dialog
Var AutoStartCheckbox
Var DesktopShortcutCheckbox
Var TaskbarPinCheckbox
Var AutoStartState
Var TaskbarPinCheckState

; ✅ 你希望的引导顺序
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
Page custom SetOptions SetOptionsLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


; 自定义选项页
Function SetOptions
  nsDialogs::Create 1018
  Pop $Dialog

  ${NSD_CreateLabel} 0 0 100% 12u "安装选项 - 请选择需要的安装选项"
  Pop $0

  ${NSD_CreateCheckbox} 0 20u 100% 12u "创建桌面快捷方式"
  Pop $DesktopShortcutCheckbox
  ${NSD_SetState} $DesktopShortcutCheckbox ${BST_CHECKED}

  ${NSD_CreateCheckbox} 0 40u 100% 12u "开机自动启动"
  Pop $AutoStartCheckbox
  ${NSD_SetState} $AutoStartCheckbox ${BST_CHECKED}

  ${NSD_CreateCheckbox} 0 60u 100% 12u "固定到任务栏"
  Pop $TaskbarPinCheckbox
  ${NSD_SetState} $TaskbarPinCheckbox ${BST_CHECKED}

  nsDialogs::Show
FunctionEnd

Function SetOptionsLeave
  ${NSD_GetState} $DesktopShortcutCheckbox $0
  ${NSD_GetState} $AutoStartCheckbox $AutoStartState
  ${NSD_GetState} $TaskbarPinCheckbox $TaskbarPinCheckState
FunctionEnd

Section -Post
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${executableName}.exe"
  ${EndIf}
  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}" '"$INSTDIR\${executableName}.exe"'
  ${EndIf}
  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${executableName}.exe" c:5386'
  ${EndIf}
SectionEnd
