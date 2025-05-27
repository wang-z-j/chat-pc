; 启用 Unicode 支持
Unicode true

; 引入常用模块
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"

; 应用信息
;!define PRODUCT_NAME "蓝翼AI门户"
;!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "ccccltd, Inc."
!define PRODUCT_WEB_SITE "https://c4ai.ccccltd.cn/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\lanyiAI.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; 声明变量
Var Dialog
Var DesktopShortcutCheckbox
Var AutoStartCheckbox
Var TaskbarPinCheckbox
Var AutoStartState
Var TaskbarPinCheckState

; 安装向导页面
!insertmacro MUI_PAGE_WELCOME
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "${BUILD_RESOURCES_DIR}\license.txt"
!insertmacro MUI_PAGE_DIRECTORY
Page custom SetOptions SetOptionsLeave
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\lanyiAI.exe"
!insertmacro MUI_PAGE_FINISH

; 卸载页面
!insertmacro MUI_UNPAGE_INSTFILES

; 语言
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装程序信息
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "lanyiAI_for_windows_${PRODUCT_VERSION}_setup.exe"
InstallDir "$PROGRAMFILES\ccccltd\lanyiAI"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

; 自定义选项页面
Function SetOptions
  !insertmacro MUI_HEADER_TEXT "安装选项" "请选择需要的安装选项"
  nsDialogs::Create 1018
  Pop $Dialog

  ${NSD_CreateCheckbox} 0 0 100% 12u "创建桌面快捷方式"
  Pop $DesktopShortcutCheckbox
  ${NSD_SetState} $DesktopShortcutCheckbox ${BST_CHECKED}

  ${NSD_CreateCheckbox} 0 20u 100% 12u "开机自动启动"
  Pop $AutoStartCheckbox
  ${NSD_SetState} $AutoStartCheckbox ${BST_CHECKED}

  ${NSD_CreateCheckbox} 0 40u 100% 12u "固定到任务栏"
  Pop $TaskbarPinCheckbox
  ${NSD_SetState} $TaskbarPinCheckbox ${BST_CHECKED}

  nsDialogs::Show
FunctionEnd

Function SetOptionsLeave
  ${NSD_GetState} $DesktopShortcutCheckbox $0
  ${NSD_GetState} $AutoStartCheckbox $AutoStartState
  ${NSD_GetState} $TaskbarPinCheckbox $TaskbarPinCheckState
FunctionEnd

; 安装部分
Section "Install"
  SetOutPath "$INSTDIR"
  DetailPrint "💡 APP_DIR = ${APP_DIR}"

  File /r "D:\a\chat-pc\chat-pc\dist\win-unpacked\*"


  ; 创建桌面快捷方式
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\lanyiAI.exe"
  ${EndIf}

  ; 设置开机自启
  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}" '"$INSTDIR\lanyiAI.exe"'
  ${EndIf}

  ; 固定到任务栏
  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\lanyiAI.exe" c:5386'
  ${EndIf}

  ; 创建开始菜单项
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\lanyiAI.exe"

  ; 写入卸载器
  WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; 额外快捷方式
Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

; 卸载部分
Section "Uninstall"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\lanyiAI.exe"
  Delete "$INSTDIR\syspin.exe"

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"

  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

; 卸载前提示
Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，及其所有组件？" IDYES +2
  Abort
FunctionEnd

; 卸载成功提示
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功从你的计算机中移除。"
FunctionEnd
