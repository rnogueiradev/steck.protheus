#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "color.ch"
/*/{Protheus.doc} STARGPAG

Busca Arquivo de Configuração CNAB

@type function
@author Everson Santana
@since 31/01/19
@version Protheus 12 - Financeiro

@history , ,

/*/


User Function STARGPAG(l1Elem,lTipoRet)

	Local cTitulo	:= ""
	Local MvPar
	Local MvParDef	:= ""
	Local _cQry 	:= ""
	Local _cQry1 	:= ""
	Local _cBanco 	:= ""
	Local _cModelo	:= ""
	Local _cTpPg	:= ""

	Local _stru:={}
	Local aCpoBro := {}
	Local oDlg
	Local nOpcA 	:= 0
	Private lInverte := .F.
	Private cMark   := GetMark()   
	Private oMark

	Private aSit:={}

	l1Elem := If (l1Elem = Nil , .F. , .T.)

	Default lTipoRet := .T.

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=Rtrim(&(Alltrim(ReadVar())))			 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIf


	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT  EA_PORTADO,EA_MODELO,EA_TIPOPAG,COUNT(*) FROM "+RetSqlName("SEA") "
	_cQry += " WHERE EA_FILIAL = '" + xFilial("SEA") +"' "
	_cQry += " AND EA_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" '  "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	_cQry += " GROUP BY EA_PORTADO,EA_MODELO,EA_TIPOPAG "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	While !EOF()

		_cBanco 	:= TRD->EA_PORTADO
		_cModelo	:= TRD->EA_MODELO
		_cTpPg		:= TRD->EA_TIPOPAG

		TRD->(dbSkip())

	End

	AADD(_stru,{"OK"    	,"C"	,2		,0		})
	AADD(_stru,{"Banco"		,"C"	,10		,0		})
	AADD(_stru,{"Titulo"	,"C"	,100	,0		})
	AADD(_stru,{"Nexxer" 	,"C"	,20		,0		})

	cArq:=Criatrab(_stru,.T.)
	DBUSEAREA(.t.,,carq,"TTRB")//Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)

	If Select("TRc") > 0
		TRc->(DbCloseArea())
	Endif

	_cQry1 := " "
	_cQry1 += " SELECT * FROM "+RetSqlName("Z26") "
	_cQry1 += " WHERE SUBSTR(Z26_BANCO,1,3) IN('"+_cBanco+"')  "
	_cQry1 += " AND Z26_MODELO IN('"+_cModelo+"')  "
	_cQry1 += " AND Z26_TPPG IN('"+_cTpPg+"') "
	_cQry1 += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry1 New Alias "TRC"

	DbSelectArea("TRC")
	dbGoTop()

	While !EOF()

		DbSelectArea("TTRB")	
		RecLock("TTRB",.T.)		

		TTRB->Banco 	:= TRC->Z26_BANCO		
		TTRB->Titulo    := TRC->Z26_TITULO
		TTRB->Nexxer  	:= TRC->Z26_NEXXER

		MsunLock()

		DbSelectArea("TRC")
		dbSkip()

	EndDo


	aCpoBro	:= {{ "OK"			,, "Mark"       ,"@!"},;			
	{ "Banco"		,, "Banco"    ,"@!"},;			
	{ "Titulo"		,, "Titulo"       ,"@!"},;			
	{ "Nexxer"		,, "Nexxer"     ,"@!"}}

	DEFINE MSDIALOG oDlg TITLE "MarkBrowse c/Refresh" From 9,0 To 315,800 PIXEL
	DbSelectArea("TTRB")
	DbGotop()
	//Cria a MsSelect

	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{37,1,150,400},,,,,)
	oMark:bMark := {| | Disp()} 
	//Exibe a Dialog

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA := 1 , oDlg:End()},{|| oDlg:End()})

	If  nOpcA == 1

		DbSelectArea("TTRB")
		DbGotop()

		While !EOF()  

			If !Empty(TTRB->OK)

				MvParDef := Alltrim(TTRB->Nexxer)

			EndIf

			DbSelectArea("TTRB")
			DbSkip()

		End

	EndIF

	TTRB->(DbCloseArea())
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

	&MvRet := MvParDef //MvPar                                                                          // Devolve Resultado

Return IF( lTipoRet , .T. , MvParDef )


//Funcao executada ao Marcar/Desmarcar um registro.   

Static Function Disp()

	RecLock("TTRB",.F.)

	If Marked("OK")	
		TTRB->OK := cMark

	Else	
		TTRB->OK := ""

	Endif             

	MSUNLOCK()

	oMark:oBrowse:Refresh()

Return()
