; 必须首行
Unicode true
!include "MUI2.nsh"
!include "nsDialogs.nsh"

; -------- 页面顺序：欢迎 → 协议 → 目录 → 自定义 → 进度 → 完成 -------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${BUILD_RESOURCES_DIR}\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
Page custom Page_Options Page_Options_Leave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "SimpChinese"

; --------- 自定义选项页变量 ----------
Var chkDesktop
Var chkAuto
Var chkPin
Var vDesktop
Var vAuto
Var vPin

; ---------------- 自定义页实现 ----------------
Function Page_Options
  nsDialogs::Create 1018
  Pop $0
  ${NSD_CreateLabel} 0 0 100% 12u "安装选项"
  Pop $0
  ${NSD_CreateCheckbox} 0 20u 100% 12u "创建桌面快捷方式"
  Pop $chkDesktop
  ${NSD_SetState} $chkDesktop ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 40u 100% 12u "开机自动启动"
  Pop $chkAuto
  ${NSD_SetState} $chkAuto ${BST_CHECKED}
  ${NSD_CreateCheckbox} 0 60u 100% 12u "固定到任务栏"
  Pop $chkPin
  ${NSD_SetState} $chkPin ${BST_UNCHECKED}
  nsDialogs::Show
FunctionEnd

Function Page_Options_Leave
  ${NSD_GetState} $chkDesktop $vDesktop
  ${NSD_GetState} $chkAuto    $vAuto
  ${NSD_GetState} $chkPin     $vPin
FunctionEnd

; ---------------- 主 Section ----------------
Section "Install"
  SetOutPath "$INSTDIR"
  DetailPrint "💡 APP_DIR = ${APP_DIR}"
  ; ★ 复制完整应用文件。${APP_DIR} 由 electron-builder 注入，路径指向 win-unpacked
  IfFileExists "${APP_DIR}\*" 0 NoFiles
    DetailPrint "✅ APP_DIR 有文件"
    File /r "${APP_DIR}/*"
    Goto Done
  NoFiles:
    DetailPrint "⚠️ APP_DIR 为空或不存在"
  Done:
  ; 额外工具
  ;File "${BUILD_RESOURCES_DIR}\syspin.exe"

  ; 桌面快捷方式
  ${If} $vDesktop == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${productName}.lnk" "$INSTDIR\${executableName}.exe"
  ${EndIf}

  ; 开机自启
  ${If} $vAuto == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}" '"$INSTDIR\${executableName}.exe"'
  ${EndIf}

  ; 任务栏固定
  ${If} $vPin == ${BST_CHECKED}
    ;ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${executableName}.exe" c:5386'
  ${EndIf}

  WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd
