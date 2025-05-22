!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

Var installScope

; 语言
!insertmacro MUI_LANGUAGE "SimpChinese"

; 第一步：安装范围选择页
Page custom SelectScopePage ScopePageLeave

; 第二步：目标文件夹选择页
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; ========== 自定义页面函数 ==========

Function SelectScopePage

  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ; 页面标题
  ${NSD_CreateLabel} 0 0 100% 20u "请选择安装范围："
  Pop $1

  ; 当前用户
  ${NSD_CreateRadioButton} 20u 30u 80% 10u "为当前用户安装（默认）"
  Pop $2
  ${NSD_SetState} $2 ${BST_CHECKED}

  ; 所有用户
  ${NSD_CreateRadioButton} 20u 48u 80% 10u "为所有用户安装（需管理员权限）"
  Pop $3

  nsDialogs::Show
FunctionEnd

Function ScopePageLeave
  ${NSD_GetState} $2 $installScope
  ${If} $installScope = ${BST_CHECKED}
    ; 当前用户
    SetShellVarContext current
  ${Else}
    ; 所有用户
    SetShellVarContext all
  ${EndIf}
FunctionEnd

