#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STATUSB1	ºAutor  ³Renato Nogueira     º Data ³  27/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job utilizado para atualizar campos na sb1					 º±±
±±º          ³									    				      		 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STATUSB1()

	Local aArea				:= GetArea()
	Local _cQuery			:= ""
	Private cWCodEmp    	:= "01"
	Private cWCodFil    	:= "01"
	Private nErrQry

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "SB1"
	//giovani zago comentei este update pois esta impactando em compras
	/*
	_cQuery := " UPDATE "+RetSqlName("SB1")+" B1 "
	_cQuery += " SET B1.B1_XCUSCOM=B1.B1_UPRC,  "
	_cQuery += " B1.B1_XDTCOM=B1.B1_UREV"
	_cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_UPRC>0 AND B1_UCOM<>' ' "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
	EndIf
	*/
	
	//Chamado 002157 - Correção da unidade de medida
	
	_cQuery := " UPDATE "+RetSqlName("SD2")+" D2 "
	_cQuery += " SET D2.D2_UM=(SELECT B1_UM FROM "+RetSqlName("SB1")+" B1 "
	_cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=D2.D2_COD) "
	_cQuery += " WHERE D2.D_E_L_E_T_=' ' AND D2.D2_UM=' ' "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
	EndIf
	
	//Chamado 002124 - INSERIR O CAMPO B1_XDESEXD NO CONSULTA GENERICOS - SC7

	_cQuery := " UPDATE SC7010 C7 "
	_cQuery += " SET C7__XDESEX=(SELECT Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) B1_XDESEXD FROM SB1010 WHERE D_E_L_E_t_=' ' AND B1_COD=C7.C7_PRODUTO AND Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) IS NOT NULL) "
	_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_PRODUTO=(SELECT B1_COD B1_XDESEXD FROM SB1010 WHERE D_E_L_E_t_=' ' AND B1_COD=C7.C7_PRODUTO AND Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) IS NOT NULL) "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
	EndIf

	_cQuery := " UPDATE SC7030 C7 "
	_cQuery += " SET C7__XDESEX=(SELECT Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) B1_XDESEXD FROM SB1030 WHERE D_E_L_E_t_=' ' AND B1_COD=C7.C7_PRODUTO AND Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) IS NOT NULL) "
	_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_PRODUTO=(SELECT B1_COD B1_XDESEXD FROM SB1030 WHERE D_E_L_E_t_=' ' AND B1_COD=C7.C7_PRODUTO AND Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( B1_XDESEXD ,240 ) ) ) IS NOT NULL) "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
	EndIf

	
	RestArea(aArea)
	
Return()