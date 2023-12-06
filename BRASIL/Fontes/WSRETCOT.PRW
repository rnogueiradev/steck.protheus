#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WSRETCOT	ºAutor  ³Renato Nogueira     º Data ³  29/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Webservice retornar as cotações   	   					  º±±
±±º          ³	    							 	 		        	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Estrutura que retorna cotações pendentes
WSSTRUCT Cotacoes
	
	WSDATA cEmp			AS STRING
	WSDATA cFil			AS STRING
	WSDATA cCot			AS STRING
	WSDATA cItem			AS STRING
	WSDATA cProd			AS STRING
	WSDATA cDesc			AS STRING
	WSDATA nQuant			AS FLOAT
	WSDATA nPreco 		AS FLOAT
	WSDATA nTotal 		AS FLOAT
	WSDATA nRegistro		AS FLOAT
	WSDATA cForn		AS STRING
	WSDATA cObs1		AS STRING
	WSDATA cObs2		AS STRING
	
ENDWSSTRUCT
//Estrutura com dados para atualizar retorno das cotações
WSSTRUCT Cots
	
	WSDATA cEmp			AS STRING
	WSDATA nRegistro	AS FLOAT
	WSDATA cStatus		AS STRING
	WSDATA cObs2		AS STRING
	
ENDWSSTRUCT
//Definição da estrutura da array
WSSTRUCT CotEstru
	
	WSDATA aRetCot		AS ARRAY OF Cots
	
ENDWSSTRUCT

WSSERVICE WSRETCOT DESCRIPTION "Serviço para retornar cotações pendentes"
	//Utilizado nos dois métodos
	WSDATA _cLogin		AS STRING
	WSDATA _cPassword	AS STRING
	//Utilizado no método RetCot
	WSDATA aCots   		AS ARRAY OF Cotacoes
	//Utilizado no método UpdCot
	WSDATA cotacoes		AS CotEstru
	WSDATA lRetorno  	AS BOOLEAN
	
	WSMETHOD RetCot DESCRIPTION "Método que retorna as cotações pendentes"
	WSMETHOD UpdCot DESCRIPTION "Atualiza status das cotações"
	
ENDWSSERVICE

WSMETHOD RetCot WSRECEIVE _cLogin,_cPassword WSSEND aCots WSSERVICE WSRETCOT
	
	Local _lContinua		:= .T.
	Local _cQuery			:= ""
	Local _cAlias			:= "QRYTEMP"
	Local _i				:= 1
	
	::aCots	:= {}
	
	// indice 2 - por login
	PswOrder(2)
	
	If PswSeek(::_cLogin,.T.)
		// retorna array com dados do usuario
		_aUser := PswRet()
		// verifico se a senha esta correta
		If PswName(::_cPassword)
			_lContinua    := .T.
		Else
			_lContinua    := .F.
		Endif
	Else
		_lContinua   := .F.
	Endif
	
	If !_lContinua //Login inválido
		Return .T.
	EndIf
	
	_cQuery := " SELECT * FROM ( "
	_cQuery += " SELECT 'SP' EMPRESA, C7_FILIAL FILIAL, C7_NUM NUMERO, A2_NOME FORN, C7_ITEM ITEM, C7_PRODUTO PRODUTO, B1_DESC DESCRI, C7_QUANT QTDE, C7_PRECO PRECO, C7_TOTAL TOTAL, C7.R_E_C_N_O_ REGISTRO, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(C7_XOBS1, 2000, 1)),' ') OBS1, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(C7_XOBS2, 2000, 1)),' ') OBS2 "
	_cQuery += " FROM SC7010 C7 "
	_cQuery += " LEFT JOIN SB1010 B1 "
	_cQuery += " ON B1_COD=C7_PRODUTO "
	_cQuery += " LEFT JOIN SA2010 A2 "
	_cQuery += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA "
	_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND C7_XSTATUS='P' "
	_cQuery += " AND C7_XUSRPOR='"+::_cLogin+"' "
	_cQuery += " UNION ALL "
	_cQuery += " SELECT 'AM' EMPRESA, C7_FILIAL FILIAL, C7_NUM NUMERO, A2_NOME FORN, C7_ITEM ITEM, C7_PRODUTO PRODUTO, B1_DESC DESCRI, C7_QUANT QTDE, C7_PRECO PRECO, C7_TOTAL TOTAL, C7.R_E_C_N_O_ REGISTRO, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(C7_XOBS1, 2000, 1)),' ') OBS1, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(C7_XOBS2, 2000, 1)),' ') OBS2 "
	_cQuery += " FROM SC7030 C7 "
	_cQuery += " LEFT JOIN SB1030 B1 "
	_cQuery += " ON B1_COD=C7_PRODUTO "
	_cQuery += " LEFT JOIN SA2030 A2 "
	_cQuery += " ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA "
	_cQuery += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND C7_XSTATUS='P' "
	_cQuery += " AND C7_XUSRPOR='"+::_cLogin+"' "
	_cQuery += " ) "
	_cQuery += " ORDER BY EMPRESA, NUMERO, ITEM
	
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
	
	While (_cAlias)->(!Eof())
		
		aAdd(::aCots,WSClassNew("Cotacoes"))
		::aCots[_i]:cEmp 		:= (_cAlias)->EMPRESA
		::aCots[_i]:cFil 		:= (_cAlias)->FILIAL
		::aCots[_i]:cCot 		:= (_cAlias)->NUMERO
		::aCots[_i]:cItem 	:= (_cAlias)->ITEM
		::aCots[_i]:cProd 	:= (_cAlias)->PRODUTO
		::aCots[_i]:cDesc 	:= (_cAlias)->DESCRI
		::aCots[_i]:nQuant 	:= (_cAlias)->QTDE
		::aCots[_i]:nPreco 	:= (_cAlias)->PRECO
		::aCots[_i]:nTotal 	:= (_cAlias)->TOTAL
		::aCots[_i]:nRegistro:= (_cAlias)->REGISTRO
		::aCots[_i]:cForn 	:= (_cAlias)->FORN
		::aCots[_i]:cObs1 	:= (_cAlias)->OBS1
		::aCots[_i]:cObs2 	:= (_cAlias)->OBS2
		
		_i++
		
		(_cAlias)->(DbSkip())
	EndDo
	
Return .T.

WSMETHOD UpdCot WSRECEIVE cotacoes,_cLogin,_cPassword WSSEND lRetorno WSSERVICE WSRETCOT
	
	Local _lContinua		:= .T.
	Local i					:= 0
	Private _aProcAm		:= {}
	Private _aProcSp		:= {}
	
	// indice 2 - por login
	PswOrder(2)
	
	If PswSeek(::_cLogin,.T.)
		// retorna array com dados do usuario
		_aUser := PswRet()
		// verifico se a senha esta correta
		If PswName(::_cPassword)
			_lContinua    := .T.
		Else
			_lContinua    := .F.
		Endif
	Else
		_lContinua   := .F.
	Endif
	
	If !_lContinua //Login inválido
		::lRetorno	:= .F.
		Return .T.
	EndIf
	
	For i=1 To Len(::cotacoes:aRetCot)
		
		Do Case
		Case AllTrim(::cotacoes:aRetCot[i]:cEmp)=="AM"
			AADD(_aProcAm,{::cotacoes:aRetCot[i]:nRegistro,::cotacoes:aRetCot[i]:cStatus,::cotacoes:aRetCot[i]:cObs2})
		Case AllTrim(::cotacoes:aRetCot[i]:cEmp)=="SP"
			AADD(_aProcSP,{::cotacoes:aRetCot[i]:nRegistro,::cotacoes:aRetCot[i]:cStatus,::cotacoes:aRetCot[i]:cObs2})
		EndCase
		
	Next
	
	Begin Transaction
		
		//Prepara o ambiente de AM
		RPCClearEnv()
		RPCSetType(3)
		RPCSetEnv("03","01")
		
		DbSelectArea("SC7")
		SC7->(DbGoTop())
		
		For i=1 To Len(_aProcAm)
			
			SC7->(DbGoTo(_aProcAm[i][1]))
			If SC7->(!Eof())
				SC7->(RecLock("SC7",.F.))
				SC7->C7_XDTINT	:= Date()
				SC7->C7_XHRINT	:= Time()
				SC7->C7_XUSRINT	:= ::_cLogin
				SC7->C7_XSTATUS	:= _aProcAm[i][2]
				SC7->C7_XOBS2	:= _aProcAm[i][3]
				SC7->(MsUnLock())
			EndIf
			
		Next
		
		//Prepara o ambiente de SP
		RPCClearEnv()
		RPCSetType(3)
		RPCSetEnv("01","01")
		
		DbSelectArea("SC7")
		SC7->(DbGoTop())
		
		For i=1 To Len(_aProcSp)
			
			SC7->(DbGoTo(_aProcSp[i][1]))
			If SC7->(!Eof())
				SC7->(RecLock("SC7",.F.))
				SC7->C7_XDTINT	:= Date()
				SC7->C7_XHRINT	:= Time()
				SC7->C7_XUSRINT	:= ::_cLogin
				SC7->C7_XSTATUS	:= _aProcSp[i][2]
				SC7->C7_XOBS2	:= _aProcSp[i][3]
				SC7->(MsUnLock())
			EndIf
			
		Next
		
	End Transaction
	
	::lRetorno	:= .T.
	
Return .T.
