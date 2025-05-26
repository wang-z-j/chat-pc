; 启用Unicode支持
Unicode true

!include "nsDialogs.nsh"
Var Dialog
Var AutoStartCheckbox
Var DesktopShortcutCheckbox
Var TaskbarPinCheckbox
Var AutoStartState
Var TaskbarPinCheckState

; 只插入自定义选项页（不会和 electron-builder 模板冲突）
Page custom SetOptions SetOptionsLeave

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

; 安装后执行动作
Section -Post
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${productName}.lnk" "$INSTDIR\${executableName}.exe"
  ${EndIf}

  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}" '"$INSTDIR\${executableName}.exe"'
  ${EndIf}

  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ;ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${executableName}.exe" c:5386'
  ${EndIf}
SectionEnd
