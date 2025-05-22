!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "nsDialogs.nsh"

Var installScope

; 👇 解决语言加载冲突的关键修改
!insertmacro MUI_LANGUAGEEX "SimpChinese" "CHS"

Page custom SelectScopePage ScopePageLeave
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

Function SelectScopePage
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 20u "请选择安装范围："
  Pop $1

  ${NSD_CreateRadioButton} 20u 30u 80% 10u "为当前用户安装（默认）"
  Pop $2
  ${NSD_SetState} $2 ${BST_CHECKED}

  ${NSD_CreateRadioButton} 20u 48u 80% 10u "为所有用户安装（需管理员权限）"
  Pop $3

  nsDialogs::Show
FunctionEnd

Function ScopePageLeave
  ${NSD_GetState} $2 $installScope
  ${If} $installScope = ${BST_CHECKED}
    SetShellVarContext current
  ${Else}
    SetShellVarContext all
  ${EndIf}
FunctionEnd
