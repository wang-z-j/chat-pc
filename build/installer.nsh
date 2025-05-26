; 启用Unicode支持
Unicode true

; 只做页面和变量声明，不重复主流程
!include "nsDialogs.nsh"
Var AutoStartCheckbox
Var AutoStartState
Var DesktopShortcutCheckbox
Var TaskbarPinCheckbox
Var TaskbarPinCheckState

; 自定义选项页
Page custom SetOptions SetOptionsLeave

Function SetOptions
  !insertmacro MUI_HEADER_TEXT "安装选项" "选择需要的安装选项"
  nsDialogs::Create 1018
  Pop $0
  ${NSD_CreateCheckbox} 0 0 100% 30u "创建桌面快捷方式"
  Pop $DesktopShortcutCheckbox
  ${NSD_SetState} $DesktopShortcutCheckbox ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 40u 100% 30u "开机自启动"
  Pop $AutoStartCheckbox
  ${NSD_SetState} $AutoStartCheckbox ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 80u 100% 30u "固定到任务栏"
  Pop $TaskbarPinCheckbox
  ${NSD_SetState} $TaskbarPinCheckbox ${BST_CHECKED}
  nsDialogs::Show
FunctionEnd

Function SetOptionsLeave
  ${NSD_GetState} $DesktopShortcutCheckbox $0
  ${NSD_GetState} $AutoStartCheckbox $AutoStartState
  ${NSD_GetState} $TaskbarPinCheckbox $TaskbarPinCheckState
FunctionEnd

; 安装后执行的动作（electron-builder 的主 Section 会调用这里）
Section -Post
  ; 创建桌面快捷方式
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${productName}.lnk" "$INSTDIR\${executableName}.exe"
  ${EndIf}

  ; 设置开机启动
  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}" '"$INSTDIR\${executableName}.exe"'
  ${EndIf}

  ; 固定到任务栏
  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${executableName}.exe" c:5386'
  ${EndIf}
SectionEnd
