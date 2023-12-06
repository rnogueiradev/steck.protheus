#INCLUDE "XMLXFUN.CH"
#Include "PROTHEUS.CH"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "Rwmake.ch"
#include "APVT100.CH"

#define CRLF	CHR(13)+CHR(10)

/*/{Protheus.doc} B0003001
Rotina para exclusão de arquivos Titulos Financeiros
BPO Folha de pagamento - Ticket 20221213021800
@type function
@version  1.0
@author livia.corte
@since 23/12/2022
/*/
user function B0003001()
local cPar:= ""
Private _cRotina  := "B0003001"
Private cPerg     := "B0003001"

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule

		PREPARE ENVIRONMENT EMPRESA "11" FILIAL "01" MODULO "FAT"
	EndIf

IF EMPTY(MV_PAR01)
	ValidPerg()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
ENDIF

	cPar:= MV_PAR01
	EB0003001(cPar)

return .t.


static function EB0003001(cPar)
	Local nDlgHeight
	Local nGDHeight
	Local _aSvAr      := GetArea()                                             
	Local aSize       := {}
	Local aCordW      := {}
	Local nSizeHeader := 100
	Local _x          := 0
	Local _z          := 0
	local _CVALIDO := ""
	local oDlg 
	Private oBrowse
	Private oText
	Private aBrowse   := {}
	Private _cArqXML  := ""
	Private cError    := ""
	Private cWarning  := ""
	Private oXmlx     := ""
	Private _cTitulo  := "Limpeza  de Arquivos"
	Private _cRotina  := "B0003001"
	Private cPerg     := "B0003001"
	Private cPerg2    := "B0003001"
	Private _cMotivo  := ""
	Private oOk	      := LoadBitMap(GetResources(),'LBTIK')
	Private oNo	      := LoadBitMap(GetResources(),'LBNO')

	Private xVariable := 1
    Private cPathCus := "" //"D:\TOTVS\Microsiga\Protheus12\PROTHEUS_DATA_DIST\arquivos\SFTP-INTEGRAÇÕES\RH\" //SuperGetMv("ST_SFTP"+AllTrim(Str(nPasta)) )

	Private _aDir     :=  {} //EVAL({|| IIF(!ExistDir(cPathCus),MakeDir(cPathCus),nil), Directory(cPathCus+"*.xml")})
	Private _cArquivo := ""
	Private _nPosIni  := 0

	Private	_dataArq := ""
	Private	_HoraArq := ""
	private cArqStatus := ""
    private nTipo
	Private lSchedule 	:= .F.


	Default cEmp	  	:= '11'
	Default cFil	  	:= '01'

	cEmp	  	:= '11'
	cFil	  	:= '01'
	cPar:= cPar

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

    cPathCus += SuperGetMv("ST_SFTP"+cvaltochar(cPar),,"C:\Temp\") 
 

 	//cPathCus:= "C:\tmp"
	aBrowse:=  GerBrownser(cPathCus)

	If Len(aBrowse) == 0
		MsgStop("Nenhum arquivo no diretório especificados!!!",_cRotina+"_001")
		RestArea(_aSvAr)
		if valtype(oDlg)<> "U"
		  oDlg:End()
		endif
		return
	EndIf
	If SetMDIChild()
		oMainWnd:ReadClientCoors()
		nDlgHeight := 500
		nGDHeight  := oMainWnd:nBottom
	Else
		nDlgHeight := 420
		nGDHeight  := 70
	EndIf
	//superior,lateral esquerda,inferior lateral direita
	aCordW         := {0,0,oMainWnd:nClientHeight-30,oMainWnd:nClientWidth-20}
	nSizeHeader    := 110
	Aadd(aSize,nSizeHeader)

	DEFINE DIALOG oDlg TITLE _cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd
		//lateral esquerda,superior,lateral direita,inferior
		aCordB := {10,10,oDlg:nwidth/2.05,oDlg:nheight/2.5}
		oBrowse    := TWBrowse():New(aCordB[1],aCordB[2],aCordB[3],aCordB[4],;
										{|| {" "," "," "," "," "} },;
										{"deletar?","Nome Arquivo","Local","Data","Hora"},;
										{200,20,20,160,160};
										,oDlg,,,,,,,,,,,,,,.T.,,,,,)
		oBrowse:SetArray(aBrowse)
		oBrowse:bLDblClick := {||PutVencto(), oBrowse:DrawSelect()}
		oBrowse:SetArray(aBrowse)
				oBrowse:Refresh()
     	oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,2],aBrowse[oBrowse:nAt,3],aBrowse[oBrowse:nAt,4],aBrowse[oBrowse:nAt,5]}}
		oBrowse:Refresh()

        oBtnPar := TButton():New(aCordB[4]+20,350,"&PARAMETRO ",oDlg,{|| MV_PAR01:= "" , u_B0003001()},C(060),C(014),,,,.T.,,"",,,,.F. )	
	    oBtnFEC := TButton():New(aCordB[4]+20,450,"&FECHAR "   ,oDlg,{|| oDlg:End()},C(060),C(014),,,,.T.,,"",,,,.F. )
		oBtnDEL := TButton():New(aCordB[4]+20,550,"&DELETAR "  ,oDlg,{||Processa({||DeleteArq(aBrowse,cPar),"Excluindo..."}), oDlg:End()},C(060),C(014),,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED

	RestArea(_aSvAr)
   
	If lSchedule
		RESET ENVIRONMENT
	Endif


return

static  Function DeleteArq(aBrowse,cPar)	
local nY:= 0
local nX:= 0
local nU:= 0
local nC:= 0
Local cArqApaga:=""
local cPar:= cPar
local aBrowse1:={}
For nY:= 1 to len(aBrowse)


	if aBrowse[nY][1] == .T.	
		nC:= len(aBrowse[nY][3])
		cArqApaga := (substr(alltrim(aBrowse[nY][3]),nC,nC)=="\", aBrowse[nY][3], aBrowse[nY][3]+"\")+aBrowse[nY][2]
		If FERASE(cArqApaga ) ==0
			nX++ //conta se apagou, caso nao tenha apagado, aparecera novamente no browser
		else
			aadd(aBrowse1,aBrowse)
		endIf	
		nU++
	endif
next
nY := nU -  nX
msgalert("Foram selecionados " + cvaltochar(nU)+ " arquivos e foram deletados " + cvaltochar(nX) +" arquivos. ")


Return(aBrowse1)

static function ValidPerg()
	local _sAlias := GetArea()
	local aRegs   := {}
	local i       := 0
	local j       := 0
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg         := PADR(cPerg,len(SX1->X1_GRUPO))
	//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","FTP da Filial:","","","mv_ch1","C",01,0,0,"C","naovazio()","mv_par01","1 - ARUJA","","","","","2 - GUARAREMA","","","","","3 - LIMAO","","","","","4 - MANAUS","","","","","","","","","","","",""})
	for i := 1 to len(aRegs)
	    If !SX1->(dbSeek(cPerg+aRegs[i,2]))
	        while !RecLock("SX1",.T.) ; enddo
		        for j := 1 to FCount()
		            If j <= Len(aRegs[i])
		                FieldPut(j,aRegs[i,j])
		            EndIf
		        next
	        SX1->(MsUnLock())
	    EndIf
	next
	RestArea(_sAlias)
return 


static function GerBrownser(cPathCus)

   _aDir:= Directory(cPathCus+"\*.*")
	ASORT(_aDir,,,{|X,Y|X[4] > Y[4]})
	For _z := 1 to Len(_aDir) //Percorre os xmls da pasta local (c:\xml\)
		_cArquivo := alltrim(_aDir[_z,1])
		_dataArq := _aDir[_z,3]
		_HoraArq := alltrim(_aDir[_z,4])
		_nPosIni  := 0                        
		For _x := 1 to Len(_cArquivo)
			If Substr(_cArquivo,_x,1) == "\"
				_nPosIni := _x
			EndIf
		Next         

		_aLinha := {}
		AADD(_aLinha,.T.       )
		AADD(_aLinha,_cArquivo )
		AADD(_aLinha, cPathCus )
		AADD(_aLinha, _dataArq )
		AADD(_aLinha, _HoraArq )
		AADD(aBrowse, _aLinha  )	 
		
	Next
	ASORT(aBrowse,,,{|X,Y|X[5] < Y[5]})

return  aBrowse


Static Function RetbLine(oLbx,aDocs)
	Local nx
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" )
	Local aRet	:= {}

	For nX := 1 to len(aDocs[oLbx:nAt])
		If nX==1
			If aDocs[oLbx:nAt,1]
				aadd(aRet,oOk)
			Else
				aadd(aRet,oNo)
			EndIf
		Else
			aadd(aRet,aDocs[oLbx:nAt,nX])
		EndIf
	Next
Return aclone(aRet)



static function PutVencto()

	If !aBrowse[oBrowse:nAt][1] 
			aBrowse[oBrowse:nAt][1] := aBrowse[oBrowse:nAt][1]
	Else
		aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1]
	EndIf
return
