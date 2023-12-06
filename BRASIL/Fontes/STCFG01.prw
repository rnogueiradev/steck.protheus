#include 'TopConn.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_STCFG01

Grava log de Movimentações

@type function
@author Everson Santana
@since 06/03/2020
@version Protheus 12 - Generico

@history  ,
/*/

User Function STCFG01(_cDoc,_cTipo,cHist)

	RecLock("ZH1",.T.)
		ZH1->ZH1_FILIAL	:= XFILIAL()
		ZH1->ZH1_DOC		:= _cDoc	
		ZH1->ZH1_TIPO		:= _cTipo
		ZH1->ZH1_DATA		:= Date()
		ZH1->ZH1_HORA		:= Strtran(Time(),":","")
		ZH1->ZH1_USERP	:= CUSERNAME
		ZH1->ZH1_USERM	:= LogUserName()
		ZH1->ZH1_PC		:= ComputerName()
		ZH1->ZH1_HIST		:= cHist
	MsUnlock()
Return

User Function STCFG01A(cDoc,cTipo)

	Local 	oDlg
	Local 	oLbx
	Local 	cTitulo 	:= ""
	Private aItem		:= {}

	cTitulo := "Histórico de Movimentações - " + AllTrim(cDoc)

// Seleção das informações a ser apresentado na tela
	RunQry(cDoc,cTipo)

// Inicia a montagem do diálogo
	oDlg           := MSDialog():New( 089,232,608,1070,cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oDlg:lCentered := .T.

// Listbox do Histórico
	oLbx := TCBrowse():New(008,008,405,243,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,)
	oLbx:AddColumn( TcColumn():New( "Data"	 				,{ || aItem[oLbx:nAt,01] },"@!"	,,,"LEFT" ,035,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Hora"	 				,{ || aItem[oLbx:nAt,02] },"@!"	,,,"LEFT" ,030,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Usuário Protheus"	,{ || aItem[oLbx:nAt,03] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Usuário Windows"	,{ || aItem[oLbx:nAt,04] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Micro"	 			,{ || aItem[oLbx:nAt,05] },""	,,,"LEFT" ,050,.f.,.f.,,,,.f.,) )
	oLbx:AddColumn( TcColumn():New( "Histórico"	  		,{ || aItem[oLbx:nAt,06] },""	,,,"LEFT" ,150,.f.,.f.,,,,.f.,) )
	oLbx:SetArray( @aItem )

// Finaliza a montagem do dialogo
	oDlg:Activate(,,,.T.)

Return


/// #######################################################################
// -----------------------------------------------------------------------
// -- Função: RunQry
// -- Data  : 06/03/2020
// -- Autor : Everson Santana
// -- Descr.: Funcao chamada na execucao, diferenciando o que eh 
// --       : solicitacao de compras de pedido de compras. Sempre que for 
// --       : acrescentado um tipo de documento (SC, PC, cotacao, etc.) deve
// --       : ser incluido na query e em seu respectivo Ponto de Entrada
// #######################################################################
// -----------------------------------------------------------------------


Static Function RunQry(cDoc,cTipo)
	Local cQuery		:= ""
	Local cData		:= ""
	Local cHora		:= ""
	
	cQuery := "SELECT "
	cQuery += "* "
	cQuery += "FROM " + RetSqlName("ZH1") + " ZH1 "
	cQuery += "WHERE "
	cQuery += "ZH1_FILIAL = '" + xFilial("ZH1") + "' AND "
	cQuery += "ZH1_DOC = '" + cDoc + "' AND "
	
	If Alltrim(cTipo) == "SC"
		cQuery += "ZH1_TIPO = 'SC' AND "
	ElseIf Alltrim(cTipo) == "PC"
		cQuery += "ZH1_TIPO = 'PC' AND "
	ElseIf Alltrim(cTipo) == "X6"
	EndIf
	
	cQuery += " D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY ZH1_DATA,ZH1_HORA "

	TcQuery cQuery New Alias "TZH1"

	While TZH1->(!Eof())
 
		cHora :=Substr(TZH1->ZH1_HORA,1,2)+":"+Substr(TZH1->ZH1_HORA,3,2)+":"+Substr(TZH1->ZH1_HORA,5,2)
		If Empty(TZH1->ZH1_HORA)
			cHora := ""
		Endif
		If !Empty(TZH1->ZH1_DATA)
			cData := Stod(TZH1->ZH1_DATA)
		Else
			cData := ""
		Endif
		
		aAdd ( aItem, {	cData  				,;
			cHora									,;
			TZH1->ZH1_USERP						,;
			TZH1->ZH1_USERM						,;
			TZH1->ZH1_PC							,;
			TZH1->ZH1_HIST							})
		
		TZH1->(DbSkip())
	
	EndDo

	TZH1->(DbCloseArea())

Return
