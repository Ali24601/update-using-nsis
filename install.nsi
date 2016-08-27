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
var P1  ; file pointer, used to "remember" the position in the Version1 string
var P2  ; file pointer, used to "remember" the position in the Version2 string
var V1  ;version number from Version1
var V2  ;version number from Version2
Var Reslt   ; holds the return flag
Var UNINSTALL_PROG
Var OLD_VER
Var CMP
Var Dialog                   ;自定义
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
Page custom nsDialogsPage
; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
;!insertmacro MUI_PAGE_LICENSE "c:\path\to\licence\YourSoftwareLicence.txt"
; 安装目录选择页面
!define MUI_PAGE_CUSTOMFUNCTION_show Pageshow
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\V-life.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

;部分属性在文件属性-详细信息中不显示，做屏蔽处理
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
OutFile "${PRODUCT_NAME}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails nevershow
ShowUnInstDetails nevershow
BrandingText "${PRODUCT_PUBLISHER} "
CompletedText "${PRODUCT_NAME}已完成安装"

;删除\安装所有用户下的快捷方式。首先添加RequestExecutionLevel admin
;然后在创建快捷方式和删除快捷方式的地方加上SetShellVarContext all即可
RequestExecutionLevel admin #NOTE: You still need to check user rights with UserInfo!

Section "MainSection" SEC01
  ;删除\安装所有用户下的快捷方式。首先添加RequestExecutionLevel admin
  ;然后在创建快捷方式和删除快捷方式的地方加上SetShellVarContext all即可
  SetShellVarContext all
  
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  ;手动添加卸载程序
  File "C:\Users\Ali\Desktop\Release\uninst.exe"
    /******************************
    *  以下需填放向导生成的文件  *
    ******************************/
    /*****************************/
    /******************************
    *  以上需填放向导生成的文件  *
    ******************************/
SectionEnd

;sll 2015.11.24 安装渲染器区段
Section "RenderSection" SEC02
  ;sll 2015.11.24
  ${GetRoot} "$INSTDIR" $1   ;获取安装根目录
  StrCpy $RenderDir "$1\errenderclient"
  SetOutPath $RenderDir
    /******************************
    *  以下需填放向导生成的文件  *
    ******************************/
    /*****************************/
    /******************************
    *  以上需填放向导生成的文件  *
    ******************************/
SectionEnd

;sll 2015.11.24 桌面、开始目录的链接
Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  WriteIniStr "$SMPROGRAMS\${PRODUCT_NAME}\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

;sll 2015.11.24 写注册表，文件关联
Section hom
DetailPrint "关联 hom 文件..."
SectionIn 1
WriteRegStr HKCR ".hom" "" "homfile"
WriteRegStr HKCR "homfile" "" "场景文件"
WriteRegStr HKCR "homfile\DefaultIcon" "" "$INSTDIR\V-life.exe,0"
WriteRegStr HKCR "homfile\shell" "" ""
WriteRegStr HKCR "homfile\shell\open" "" ""
WriteRegStr HKCR "homfile\shell\open\command" "" '"$INSTDIR\V-life.exe" "%1"'
SectionEnd

;sll 2015.11.24 写注册表，程序卸载信息
Section -Post
  ;WriteUninstaller "$INSTDIR\uninst.exe" 以及事先建立了卸载程序并在MainSection中添加过了，无需自动建立
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\V-life.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\V-life.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  System::Call 'shell32.dll::SHChangeNotify(i ${SHCNE_ASSOCCHANGED}, i ${SHCNF_IDLIST}, i 0, i 0)'
  ;文件类型关联发生了变化后调用SHChangeNotify并指定SHCNE_ASSOCCHANGED标志来指示外壳去刷新缓存和搜索新的处理程序
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/
 
/*由于采用nsis生成的uinst.exe代替了可选的自动生成的卸载程序，此段取消*/

/******************************
 *  以上是安装程序的卸载部分  *
 ******************************/
 
#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

;-------------检测计算机上是否已安装此程序及版本情况----------
Function .onInit
  ClearErrors
  ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  IfErrors  ExitCheckOldProc

  ReadRegStr $OLD_VER ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  ${VersionCheck} $OLD_VER ${PRODUCT_VERSION} $CMP
  ${Switch} $CMP
  ${Case} 0
    MessageBox MB_OKCANCEL|MB_DEFBUTTON2 "您的系统中已安装了 ${PRODUCT_NAME}  版本为 $OLD_VER 与当前安装盘版本一致。您确定要覆盖此程序吗？" IDOK ExitCheckOldProc IDCANCEL DoCancel
    ${Break}
  ${Case} 1
    MessageBox MB_OK "您的系统中已安装了 ${PRODUCT_NAME}的版本$OLD_VER高于当前安装盘版本${PRODUCT_VERSION}。不能安装此程序，请卸载后再安装。"
		Quit
    ${Break}
  ${Default}
    MessageBox MB_OKCANCEL|MB_DEFBUTTON1 "您的系统中已安装了${PRODUCT_NAME} 的较低版本 $OLD_VER，当前安装盘版本为${PRODUCT_VERSION}。您确定要用新版程序覆盖旧版程序吗？" IDOK ExitCheckOldProc IDCANCEL DoCancel
    ${Break}
${EndSwitch}
 DoCancel:
 Quit
 ExitCheckOldProc:
FunctionEnd
;-------------检测计算机上是否已安装此程序及版本情况  结束----------


;Function un.onInit
;  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
;  Abort
;FunctionEnd

;Function un.onUninstSuccess
;  HideWindow
;  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
;FunctionEnd

;判断是否为覆盖安装，是的话则跳过欢迎以及目录选择界面
;从当前页面算起，跳过2个页面
;然后把SendMessage $HWNDPARENT 0x408 2 0改为SendMessage $HWNDPARENT 0x408 1 0
;即只跳过这个自定义页面
Function nsDialogsPage
	nsDialogs::Create /NOUNLOAD 1018
	Pop $Dialog
	${If} $Dialog == error
		Abort
	${EndIf}
	ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  ${If} $UNINSTALL_PROG == ""
	SendMessage $HWNDPARENT 0x408 1 0
  ${Else}
	SendMessage $HWNDPARENT 0x408 3 0
  ${EndIf}
	nsDialogs::Show
FunctionEnd

;读注册表，判断是不是覆盖安装，如果是就不能更改安装目录
Function Pageshow
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString"
  ${If} $0 == ""
  ${Else}
  ;禁用浏览按钮
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1001
  EnableWindow $0 0
  ;禁用编辑的目录
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1019
  EnableWindow $0 0
  FindWindow $0 "#32770" "" $HWNDPARENT
  GetDlgItem $0 $0 1006
  ;SendMessage $0 ${WM_SETTEXT} 0 "STR:您已经安装过 ${PRODUCT_NAME} ，现在进行的覆盖安装不能更改安装目录，如果您需要更改安装目录，请先卸载已经安装的版本之后再运行此安装程序！"
  ${EndIf}
FunctionEnd


;-------------网上下载的函数，功能是比较2个版本号x.x.x.x----------
;  From:http://nsis.sourceforge.net/Comparing_Two_Version_Numbers
;  Created 1/5/05 by Comperio
;
;   Usage:
;   ${VersionCheck} "Version1" "Version2" "outputVar"
;       Version1 = 1st version number
;       Version2 = 2nd version number
;       outputVar = Variable used to store the ouput
;
;   Return values:
;       0 = both versions are equal
;       1 = Version 1 is NEWER than version 2
;       2 = Version1 is OLDER than version 2
;   Rules for Version Numbers:
;       Version numbers must always be a string of numbers only.  (A dot
;       in the name is optional).
;
;   [Variables]



;   [Functions]
Function VersionCheckF
    Exch $1 ; $1 contains Version 1
    Exch
    Exch $2 ; $2 contains Version 2
    Exch
    Push $R0
    ;   initialize Variables
    StrCpy $V1 ""
    StrCpy $V2 ""
    StrCpy $P1 ""
    StrCpy $P2 ""
    StrCpy $Reslt ""
    ;   Set the file pointers:
    IntOp $P1 $P1 + 1
    IntOp $P2 $P2 + 1
    ;  ******************* Get 1st version number for Ver1 **********************
    V11:
    ;   I use $1 and $2 to help keep identify "Ver1" vs. "Ver2"
    StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
    IntOp $P1 $P1 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V11end 0  ;check for empty string
    strCmp $R0 "." v11end 0
    strCpy $V1 "$V1$R0"
    Goto V11
    V11End:
    StrCmp $V1 "" 0 +2
    StrCpy $V1 "0"
    ;  ******************* Get 1st version number for Ver2 **********************
    V12:
    StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
    IntOp $P2 $P2 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V12end 0  ;check for empty string
    strCmp $R0 "." v12end 0
    strCpy $V2 "$V2$R0"
    Goto V12
    V12End:
    StrCmp $V2 "" 0 +2
    StrCpy $V2 "0"
    ;   At this point, we can compare the results.  If the numbers are not
    ;       equal, then we can exit
    IntCmp $V1 $V2 cont1 older1 newer1
    older1: ; Version 1 is older (less than) than version 2
    StrCpy $Reslt 2
    Goto ExitFunction
    newer1: ; Version 1 is newer (greater than) Version 2
    StrCpy $Reslt 1
    Goto ExitFunction
    Cont1: ;Versions are the same.  Continue searching for differences
    ;   Reset $V1 and $V2
    StrCpy $V1 ""
    StrCpy $V2 ""
    ;  ******************* Get 2nd version number for Ver1 **********************
    V21:
    StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
    IntOp $P1 $P1 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V21end 0  ;check for empty string
    strCmp $R0 "." v21end 0
    strCpy $V1 "$V1$R0"
    Goto V21
    V21End:
    StrCmp $V1 "" 0 +2
    StrCpy $V1 "0"
    ;  ******************* Get 2nd version number for Ver2 **********************
    V22:
    StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
    IntOp $P2 $P2 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V22end 0  ;check for empty string
    strCmp $R0 "." V22end 0
    strCpy $V2 "$V2$R0"
    Goto V22
    V22End:
    StrCmp $V2 "" 0 +2
    StrCpy $V2 "0"
    ;   At this point, we can compare the results.  If the numbers are not
    ;       equal, then we can exit
    IntCmp $V1 $V2 cont2 older2 newer2
    older2: ; Version 1 is older (less than) than version 2
    StrCpy $Reslt 2
    Goto ExitFunction
    newer2: ; Version 1 is newer (greater than) Version 2
    StrCpy $Reslt 1
    Goto ExitFunction
    Cont2: ;Versions are the same.  Continue searching for differences
    ;   Reset $V1 and $V2
    StrCpy $V1 ""
    StrCpy $V2 ""
    ;  ******************* Get 3rd version number for Ver1 **********************
    V31:
    StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
    IntOp $P1 $P1 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V31end 0  ;check for empty string
    strCmp $R0 "." v31end 0
    strCpy $V1 "$V1$R0"
    Goto V31
    V31End:
    StrCmp $V1 "" 0 +2
    StrCpy $V1 "0"
    ;  ******************* Get 3rd version number for Ver2 **********************
    V32:
    StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
    IntOp $P2 $P2 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V32end 0  ;check for empty string
    strCmp $R0 "." V32end 0
    strCpy $V2 "$V2$R0"
    Goto V32
    V32End:
    StrCmp $V2 "" 0 +2
    StrCpy $V2 "0"
    ;   At this point, we can compare the results.  If the numbers are not
    ;       equal, then we can exit
    IntCmp $V1 $V2 cont3 older3 newer3
    older3: ; Version 1 is older (less than) than version 2
    StrCpy $Reslt 2
    Goto ExitFunction
    newer3: ; Version 1 is newer (greater than) Version 2
    StrCpy $Reslt 1
    Goto ExitFunction
    Cont3: ;Versions are the same.  Continue searching for differences
    ;   Reset $V1 and $V2
    StrCpy $V1 ""
    StrCpy $V2 ""
    ;  ******************* Get 4th version number for Ver1 **********************
    V41:
    StrCpy $R0 $1 1 $P1 ;$R0 contains the character at position $P1
    IntOp $P1 $P1 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V41end 0  ;check for empty string
    strCmp $R0 "." v41end 0
    strCpy $V1 "$V1$R0"
    Goto V41
    V41End:
    StrCmp $V1 "" 0 +2
    StrCpy $V1 "0"
    ;  ******************* Get 4th version number for Ver2 **********************
    V42:
    StrCpy $R0 $2 1 $P2 ;$R0 contains the character at position $P1
    IntOp $P2 $P2 + 1   ;increments the file pointer for the next read
    StrCmp $R0 "" V42end 0  ;check for empty string
    strCmp $R0 "." V42end 0
    strCpy $V2 "$V2$R0"
    Goto V42
    V42End:
    StrCmp $V2 "" 0 +2
    StrCpy $V2 "0"
    ;   At this point, we can compare the results.  If the numbers are not
    ;       equal, then we can exit
    IntCmp $V1 $V2 cont4 older4 newer4
    older4: ; Version 1 is older (less than) than version 2
    StrCpy $Reslt 2
    Goto ExitFunction
    newer4: ; Version 1 is newer (greater than) Version 2
    StrCpy $Reslt 1
    Goto ExitFunction
    Cont4:
    ;Versions are the same.  We've reached the end of the version
    ;   strings, so set the function to 0 (equal) and exit
    StrCpy $Reslt 0
    ExitFunction:
    Pop $R0
    Pop $1
    Pop $2
    Push $Reslt
FunctionEnd


Function .onGUIEnd
 BrandingURL::Unload
FunctionEnd

Function onGUIInit
 BrandingURL::Set /NOUNLOAD "0" "0" "200" "${PRODUCT_WEB_SITE}"
FunctionEnd

