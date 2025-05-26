; 启用Unicode支持
Unicode true

; MUI 1.67 compatible ------
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"

; MUI Settings
!define MUI_ABORTWARNING
; 不需要重复定义图标等信息，electron-builder.yml 中已经配置

; 界面配置
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
Page custom SetOptions SetOptionsLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


; 变量
Var Dialog
Var AutoStartCheckbox
Var AutoStartState
Var DesktopShortcutCheckbox
Var TaskbarPinCheckbox
Var TaskbarPinCheckState

; 安装器名称和目标目录由 electron-builder 自动注入
; Name "${productName} ${version}"
; OutFile 也由 electron-builder 自动管理
; InstallDir 由 electron-builder 自动管理

; 自定义选项页面
Function SetOptions
  !insertmacro MUI_HEADER_TEXT "安装选项" "选择需要的安装选项"
  nsDialogs::Create 1018
  Pop $Dialog

  ${NSD_CreateCheckbox} 0 0 100% 30u "创建桌面快捷方式"
  Pop $DesktopShortcutCheckbox
  ${NSD_SetState} $DesktopShortcutCheckbox ${BST_CHECKED}

  ${NSD_CreateCheckbox} 0 40u 100% 30u "开机自动启动"
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

Section "MainSection"
  SetShellVarContext current
  SetOutPath "$INSTDIR"

  ; syspin.exe、license.txt 等由 electron-builder 自动放到 $INSTDIR
  ; 这里只处理快捷方式、自启动等逻辑

  ; 创建桌面快捷方式
  ${If} $0 == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\${productName}.lnk" "$INSTDIR\${productName}.exe"
  ${EndIf}

  ; 设置开机启动
  ${If} $AutoStartState == ${BST_CHECKED}
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}" '"$INSTDIR\${productName}.exe"'
  ${EndIf}

  ; 创建开始菜单项
  CreateDirectory "$SMPROGRAMS\${productName}"
  CreateShortCut "$SMPROGRAMS\${productName}\${productName}.lnk" "$INSTDIR\${productName}.exe"

  ; 固定到任务栏（调用 syspin.exe）
  ${If} $TaskbarPinCheckState == ${BST_CHECKED}
    ExecShell taskbarpin "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
    ;ExecWait '"$INSTDIR\syspin.exe" "$INSTDIR\${productName}.exe" c:5386'
  ${EndIf}
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${productName}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${productName}\Website.lnk" "$INSTDIR\${productName}.url"
  CreateShortCut "$SMPROGRAMS\${productName}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${productName}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${productName}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${version}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) 及其所有组件？" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${productName}.url"
  Delete "$SMPROGRAMS\${productName}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${productName}\Website.lnk"
  Delete "$DESKTOP\${productName}.lnk"
  Delete "$SMPROGRAMS\${productName}\${productName}.lnk"
  RMDir "$SMPROGRAMS\${productName}"
  RMDir "$INSTDIR"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${productName}"
  Delete "$INSTDIR\uninst.exe"
  SetAutoClose true
SectionEnd
