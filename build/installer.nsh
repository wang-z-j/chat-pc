; 启用Unicode支持
Unicode true

!include "nsDialogs.nsh"
Var Dialog
Var AutoStartCheckbox
Var DesktopShortcutCheckbox
Var TaskbarPinCheckbox
Var AutoStartState
Var TaskbarPinCheckState

; 自定义选项页
Page custom SetOptions SetOptionsLeave

Function SetOptions
  ; 创建自定义对话框
  nsDialogs::Create 1018
  Pop $Dialog

  ; 标题 (Label)
  ${NSD_CreateLabel} 0 0 100% 12u "安装选项 - 请选择需要的安装选项"
  Pop $0

  ; 创建桌面快捷方式
  ${NSD_CreateCheckbox} 0 20u 100% 12u "创建桌面快捷方式"
  Pop $DesktopShortcutCheckbox
  ${NSD_SetState} $DesktopShortcutCheckbox ${BST_CHECKED}

  ; 创建开机自启动
  ${NSD_CreateCheckbox} 0 40u 100% 12u "开机自动启动"
  Pop $AutoStartCheckbox
  ${NSD_SetState} $AutoStartCheckbox ${BST_CHECKED}

  ; 创建固定到任务栏
  ${NSD_CreateCheckbox} 0 60u 100% 12u "固定到任务栏"
  Pop $TaskbarPinCheckbox
  ${NSD_SetState} $TaskbarPinCheckbox ${BST_CHECKED}

  ; 显示对话框
  nsDialogs::Show
FunctionEnd

Function SetOptionsLeave
  ${NSD_GetState} $DesktopShortcutCheckbox $0
  ${NSD_GetState} $AutoStartCheckbox $AutoStartState
  ${NSD_GetState} $TaskbarPinCheckbox $TaskbarPinCheckState
FunctionEnd

; 安装后执行动作
Section -Post
  ; 创建桌面快捷方式
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${productName}.lnk" "$INSTDIR\${executableName}.exe"
  ${EndIf}

  ; 开机启动
  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}" '"$INSTDIR\${executableName}.exe"'
  ${EndIf}

  ; 固定到任务栏
  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ;ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${executableName}.exe" c:5386'
  ${EndIf}
SectionEnd
