#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFDISTRES³Autor  ³ Leonardo Kichitaro ³ Data ³  28/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para realizar distribuicao da reserva.              º±±
±±º          ³ (Chamada pelo Menu)     DISTRIBUIÇÃO DE RESERVA GERAL      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFDISTRES()
	MsgAlert("Rotina desativada")
	Return

	If MsgYesNo("Deseja continuar ?")
		//MsgRun("Aguarde, distribuindo reservas ",,{||xSTFDISTRES() })
			Processa({|| xSTFDISTRES() },'Aguarde - distribuindo reservas')
	EndIf
Return()

Static Function xSTFDISTRES()
	Local _nx := 0
	Local _nRecou:= 0
	Local _cMsg  := ' '
	DbSelectArea("SB1")
	SB1->(DbGoTop())
	_nRecou:= SB1->(RecCount())
	ProcRegua( _nRecou )
	While SB1->(!Eof())
		_nx++
		IncProc(cvaltochar(_nx)+" / "+ cvaltochar(_nRecou))
		If SB1->B1_COD = 'PA' //.And. SB1->B1_LOCPAD = '03'
			DbSelectArea("SB2")
			SB2->(DbSetOrder(1))
			If SB2->(dbSeek(xFilial('SB2')+SB1->B1_COD+'03'))
				If SB2->B2_QATU > 0
				_cMsg += SB1->B1_COD+"-"
					
				EndIf
			EndIf
		EndIf
		SB1->(DbSkip())

	EndDo
MsgInfo(_cMsg)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STJOBDIS	³Autor  ³Renato Nogueira     ³ Data ³ 28/05/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para realizar distribuicao da reserva. (JOB)        º±±
±±º          ³ 					                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STJOBDIS()

	Local _cQuery			:= ""
	Local xcAlias			:= "STJOBDIS"
	Local _aArea			:= {}
	Private cWCodEmp    	:= "11"
	Private cWCodFil    	:= "01"

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "SB1"

	_cQuery	:= " SELECT FILIAL, CODIGO, QATU-EMPENHO-RESERVA-ENDERECAR AS SALDO, "
	_cQuery	+= " FALTA, B1.R_E_C_N_O_ REGISTRO "
	_cQuery	+= " FROM ( "
	_cQuery	+= " SELECT B2_FILIAL FILIAL, B2_COD CODIGO, B2_QATU QATU, B2_LOCAL, B2_QACLASS ENDERECAR, "
	_cQuery	+= " NVL((SELECT SUM(DC_QUANT) FROM " +RetSqlName("SDC")+ " DC WHERE DC.D_E_L_E_T_=' ' AND DC_FILIAL='01' AND DC_PRODUTO=B2_COD AND DC_QUANT>0),0) EMPENHO, "
	_cQuery	+= " NVL((SELECT SUM(PA1_QUANT) FROM " +RetSqlName("PA1")+ " PA1 WHERE PA1.D_E_L_E_T_=' ' AND PA1_TIPO='1' AND PA1_FILIAL='01' AND PA1_CODPRO=B2_COD),0) FALTA, "
	_cQuery	+= " NVL((SELECT SUM(PA2_QUANT) FROM " +RetSqlName("PA2")+ " PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='1' AND PA2_FILRES='01' AND PA2_CODPRO=B2_COD),0) RESERVA "
	_cQuery	+= " FROM " +RetSqlName("SB2")+ " B2 "
	_cQuery	+= " LEFT JOIN " +RetSqlName("SB1")+ " B1 "
	_cQuery	+= " ON B1_COD=B2_COD WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	_cQuery	+= " AND B2_LOCAL=B1_LOCPAD AND B2_FILIAL='01' ) "
	_cQuery	+= " LEFT JOIN " +RetSqlName("SB1")+ " B1 ON CODIGO=B1_COD "
	_cQuery	+= " WHERE B1.D_E_L_E_t_=' '        AND QATU-EMPENHO-RESERVA-ENDERECAR>0 AND FALTA>0 "


_cQuery	:= " " 
_cQuery	+= " SELECT  
_cQuery	+= " DISTINCT
_cQuery	+= " B1_COD , SB1.R_E_C_N_O_ REGISTRO  
_cQuery	+= " FROM SB1110 SB1 
_cQuery	+= " INNER JOIN( SELECT * FROM PA1110) PA1
_cQuery	+= " ON PA1.D_E_L_E_T_ = ' '
_cQuery	+= " AND PA1.PA1_TIPO='1' AND PA1.PA1_FILIAL='01' AND PA1.PA1_CODPRO= SB1.B1_COD 
_cQuery	+= " INNER JOIN(SELECT * FROM SB2110)SB2
_cQuery	+= " ON SB2.D_E_L_E_T_ = ' ' AND SB2.B2_LOCAL=SB1.B1_LOCPAD
_cQuery	+= " AND SB1.B1_COD = SB2.B2_COD AND SB2.B2_FILIAL ='01' AND SB2.B2_QATU > 0
_cQuery	+= " WHERE SB1.D_E_L_E_T_ = ' '
_cQuery	+= " AND SB1.B1_MSBLQL <> '1' 
_cQuery	+= " ORDER BY B1_COD


	If !Empty(Select(xcAlias))
		DbSelectArea(xcAlias)
		(xcAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xcAlias,.T.,.T.)

	dbSelectArea(xcAlias)
	(xcAlias)->(dbGoTop())

	While (xcAlias)->(!Eof())
	
		DbSelectArea("SC5")
		DbSelectArea("SC2")
		DbSelectArea("PA1")
	
		DbSelectArea("SB1")
		SB1->(DbGoTo((xcAlias)->REGISTRO))
	
		If SB1->(!Eof())
			_aArea	:= (xcAlias)->(GetArea())
			
			RestArea(_aArea)
		EndIf
	
		(xcAlias)->(DbSkip())
	EndDo
	If !Empty(Select(xcAlias))
		DbSelectArea(xcAlias)
		(xcAlias)->(dbCloseArea())
	Endif
Return()


User Function 4STJOBDIS()

	Local _cQuery			:= ""
	Local xcAlias			:= "STJOBDIS"
	Local _aArea			:= {}
	Private cWCodEmp    	:= "01"
	Private cWCodFil    	:= "04"

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "SB1"

	_cQuery	:= " SELECT FILIAL, CODIGO, QATU-EMPENHO-RESERVA-ENDERECAR AS SALDO, "
	_cQuery	+= " FALTA, B1.R_E_C_N_O_ REGISTRO "
	_cQuery	+= " FROM ( "
	_cQuery	+= " SELECT B2_FILIAL FILIAL, B2_COD CODIGO, B2_QATU QATU, B2_LOCAL, B2_QACLASS ENDERECAR, "
	_cQuery	+= " NVL((SELECT SUM(DC_QUANT) FROM " +RetSqlName("SDC")+ " DC WHERE DC.D_E_L_E_T_=' ' AND DC_FILIAL='04' AND DC_PRODUTO=B2_COD AND DC_QUANT>0),0) EMPENHO, "
	_cQuery	+= " NVL((SELECT SUM(PA1_QUANT) FROM " +RetSqlName("PA1")+ " PA1 WHERE PA1.D_E_L_E_T_=' ' AND PA1_TIPO='1' AND PA1_FILIAL='04' AND PA1_CODPRO=B2_COD),0) FALTA, "
	_cQuery	+= " NVL((SELECT SUM(PA2_QUANT) FROM " +RetSqlName("PA2")+ " PA2 WHERE PA2.D_E_L_E_T_=' ' AND PA2_TIPO='1' AND PA2_FILRES='04' AND PA2_CODPRO=B2_COD),0) RESERVA "
	_cQuery	+= " FROM " +RetSqlName("SB2")+ " B2 "
	_cQuery	+= " LEFT JOIN " +RetSqlName("SB1")+ " B1 "
	_cQuery	+= " ON B1_COD=B2_COD WHERE B2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' "
	_cQuery	+= " AND B2_LOCAL=B1_LOCPAD AND B2_FILIAL='04' ) "
	_cQuery	+= " LEFT JOIN " +RetSqlName("SB1")+ " B1 ON CODIGO=B1_COD     "
	_cQuery	+= " WHERE B1.D_E_L_E_t_=' ' AND QATU-EMPENHO-RESERVA-ENDERECAR>0 AND FALTA>0 "

	If !Empty(Select(xcAlias))
		DbSelectArea(xcAlias)
		(xcAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),xcAlias,.T.,.T.)

	dbSelectArea(xcAlias)
	(xcAlias)->(dbGoTop())

	While (xcAlias)->(!Eof())
	
		DbSelectArea("SC5")
		DbSelectArea("SC2")
		DbSelectArea("PA1")
	
		DbSelectArea("SB1")
		SB1->(DbGoTo((xcAlias)->REGISTRO))
	
		If SB1->(!Eof())
			_aArea	:= (xcAlias)->(GetArea())
			
			RestArea(_aArea)
		EndIf
	
		(xcAlias)->(DbSkip())
	EndDo
	If !Empty(Select(xcAlias))
		DbSelectArea(xcAlias)
		(xcAlias)->(dbCloseArea())
	Endif
Return()
