; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "赞云・云家"
!define PRODUCT_VERSION "1.0.0.2"
!define PRODUCT_PUBLISHER "常州赞云软件科技有限公司"
!define PRODUCT_WEB_SITE "http://www.yjia88.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\V-life.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor /SOLID lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "FileFunc.nsh" ;sll 2015.11.24

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "E:\文件-苏亮亮\交接\ico图标制作工具\InterFace.ico"
!define MUI_UNICON "E:\文件-苏亮亮\交接\ico图标制作工具\InterFace.ico"
!define SHCNE_ASSOCCHANGED 0x8000000
!define SHCNF_IDLIST 0
; branding url
!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit
Var UNINSTALL_PROG
Var OLD_VER
Var RenderDir                ;sll 2015.11.24

;   [Macros]
!macro VersionCheck Ver1 Ver2 OutVar
    ;   To make this work, one character must be added to the version string:
    Push "x${Ver2}"
    Push "x${Ver1}"
    Call VersionCheckF
    Pop ${OutVar}
!macroend
;   [Defines]
!define VersionCheck "!insertmacro VersionCheck"

;这个自定义页面的作用即是跳过下面的目录选择页面
;Page custom nsDialogsPage
; 欢迎页面
;!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
;!insertmacro MUI_PAGE_LICENSE "c:\path\to\licence\YourSoftwareLicence.txt"
; 安装目录选择页面
;!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow
;!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
;!define MUI_FINISHPAGE_RUN "$INSTDIR\V-life.exe"
;!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
;!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

;文件版本号
VIProductVersion "${PRODUCT_VERSION}"
;产品名称
VIAddVersionKey /LANG=${LANG_SimpChinese} "ProductName" "${PRODUCT_NAME}"
;备注
;VIAddVersionKey /LANG=${LANG_SimpChinese} "Comments" "备注"
;公司
VIAddVersionKey /LANG=${LANG_SimpChinese} "CompanyName" "${PRODUCT_PUBLISHER}"
;合法商标
;VIAddVersionKey /LANG=${LANG_SimpChinese} "LegalTrademarks" "合法商标"
;版权
;VIAddVersionKey /LANG=${LANG_SimpChinese} "LegalCopyright" ""
;描述
VIAddVersionKey /LANG=${LANG_SimpChinese} "FileDescription" "${PRODUCT_NAME}"
;文件版本号（不知在哪里体现）
VIAddVersionKey /LANG=${LANG_SimpChinese} "FileVersion" "${PRODUCT_VERSION}"
;产品版本号
VIAddVersionKey /LANG=${LANG_SimpChinese} "PRODUCTVERSION" "${PRODUCT_VERSION}"
; ------ Exe 文件添加版本信息 结束 ------

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "uninst.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
Caption  "${PRODUCT_NAME} 卸载"
BrandingText "${PRODUCT_PUBLISHER} "
CompletedText "${PRODUCT_NAME}已完成卸载"

;删除\安装所有用户下的快捷方式。首先添加RequestExecutionLevel admin
;然后在创建快捷方式和删除快捷方式的地方加上SetShellVarContext all即可
RequestExecutionLevel admin #NOTE: You still need to check user rights with UserInfo!

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/
Section "MainSection" SEC01
  ;删除\安装所有用户下的快捷方式。首先添加RequestExecutionLevel admin
  ;然后在创建快捷方式和删除快捷方式的地方加上SetShellVarContext all即可
	SetShellVarContext all
	
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete /REBOOTOK "$INSTDIR\uninst.exe" ;/REBOOTOK 任何当前不能删除的文件或目录将会在重启后被删除
 
    /******************************
    *  以下需填放向导生成删除文件  *
    ******************************/
    /*****************************/
    /******************************
    *  以上需填放向导生成的删除文件  *
    ******************************/
  ;卸载时处理注册表
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
  DeleteRegKey HKCR "homfile"
  DeleteRegValue HKCR ".hom" ""
  
  ;文件类型关联发生了变化后调用SHChangeNotify并指定SHCNE_ASSOCCHANGED标志来指示外壳去刷新缓存和搜索新的处理程序
  System::Call 'shell32.dll::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'
  
  SetAutoClose true
SectionEnd

;sll 2015.11.24 安装渲染器区段
Section "RenderSection" SEC02
 	;sll 2015.11.24
  ${GetRoot} "$INSTDIR" $1   ;获取安装根目录
  StrCpy $RenderDir "$1\errenderclient"
   /******************************
    *  以下需填放向导生成删除文件  *
    ******************************/
    /*注意把$INSTDIR替换为$RenderDir*/
    /******************************
    *  以上需填放向导生成的删除文件  *
    ******************************/

SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function .onInit
  ClearErrors
  ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  IfErrors NotInstalled
  ReadRegStr $OLD_VER ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 ${PRODUCT_NAME}$OLD_VER ，及其所有的组件？" IDYES ExitCheckOldProc IDNO DoCancel
	DoCancel:
	Quit
	NotInstalled:
	MessageBox MB_ICONINFORMATION|MB_OK "您尚未安装${PRODUCT_NAME}，无需卸载!" IDOK DoCancel
	Quit
	ExitCheckOldProc:
FunctionEnd

Function .onInstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME}$OLD_VER已成功地从您的计算机移除。"
FunctionEnd

Function .onGUIEnd
 BrandingURL::Unload
FunctionEnd

Function onGUIInit
 BrandingURL::Set /NOUNLOAD "0" "0" "200" "${PRODUCT_WEB_SITE}"
FunctionEnd
