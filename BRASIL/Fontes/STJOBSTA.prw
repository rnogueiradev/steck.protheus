#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STJOBSTA	ºAutor  ³Renato Nogueira     º Data ³  02/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job utilizado atualizar status dos pedidos 			      º±±
±±º          ³									    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STJOBSTA()

	Local aArea			:= GetArea()
	Local cWCodEmp    	:= "01"
	Local cWCodFil    	:= "02"
	Local _cQuery		:=	""
	Local _cAlias 		:= 	"QRYTEMP"
	Local _cQuery1		:=	""
	Local _cAlias1 		:= 	"QRYTEMP1"

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil TABLES "SC5","PA1"

 

	_cQuery	:= " SELECT R_E_C_N_O_ REGISTRO "
	_cQuery += " FROM "+RetSqlName("PA1")+" PA1 "
	_cQuery	+= " WHERE PA1.D_E_L_E_T_=' ' AND PA1_QUANT=0 AND PA1_TIPO='1' AND PA1_FILIAL='02' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	DbSelectArea("PA1")

	While !(_cAlias)->(Eof())
	
		PA1->(DbGoTop())
		PA1->(DbGoTo((_cAlias)->REGISTRO))
	
		If PA1->(!Eof())
		
			PA1->(RecLock("PA1",.F.))
			PA1->(DbDelete())
			PA1->(MsUnLock())
		
		EndIf
	
		(_cAlias)->(DbSkip())
	 
	EndDo

	_cQuery	:= " SELECT R_E_C_N_O_ REGISTRO "
	_cQuery += " FROM "+RetSqlName("PA2")+" PA2 "
	_cQuery	+= " WHERE PA2.D_E_L_E_T_=' ' AND PA2_QUANT=0 AND PA2_TIPO='1' AND PA2_FILRES='02' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	DbSelectArea("PA2")

	While !(_cAlias)->(Eof())
	
		PA2->(DbGoTop())
		PA2->(DbGoTo((_cAlias)->REGISTRO))
	
		If PA2->(!Eof())
		
			PA2->(RecLock("PA2",.F.))
			PA2->(DbDelete())
			PA2->(MsUnLock())
		
		EndIf
	
		(_cAlias)->(DbSkip())
	 
	EndDo

	_cQuery1	:= " SELECT C5_NUM "
	_cQuery1 	+= " FROM "+RetSqlName("SC5")+" C5 "
	_cQuery1	+= " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='02' AND C5_ZFATBLQ<>'1'
	_cQuery1    += " AND SUBSTR(C5_NOTA,1,1)<>'X'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While !(_cAlias1)->(Eof())
	
		U_STGrvSt((_cAlias1)->C5_NUM,Nil)
	
		(_cAlias1)->(DbSkip())
	
	EndDo
 
	RestArea(aArea)

Return
