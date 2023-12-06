#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH"


/*====================================================================================\
|Programa  | TMKCPG           | Autor | GIOVANI.ZAGO             | Data | 04/03/2013  |
|=====================================================================================|
|Descrição |  TMKCPG                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TMKCPG                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function TMKVPA(	 aValores		, aObj			, aItens		, cCodPagto		,;
oCodPagto		, cDescPagto	, oDescPagto	, cCodTransp	,;
oCodTransp		, cTransp		, oTransp		, cCob			,;
oCob			, cEnt			, oEnt			, cCidadeC		,;
oCidadeC		, cCepC			, oCepC			, cUfC			,;
oUfC			, cBairroE		, oBairroE		, cBairroC		,;
oBairroC		, cCidadeE		, oCidadeE		, cCepE			,;
oCepE			, cUfE			, oUfE			, nLiquido		,;
oLiquido		, nTxJuros		, oTxJuros		, nTxDescon		,;
oTxDescon		, aParcelas		, oParcelas		, nEntrada		,;
oEntrada		, nFinanciado	, oFinanciado	, nNumParcelas	,;
oNumParcelas	, nVlJur		,nOpc			,cNumTlv		,;
cCliente		,cLoja			,cCodCont		,cCodOper		,;
cCliAnt        , lTLVReg)
*-----------------------------*
Local aRetParc :={}
aadd(aRetParc,{ddatabase,aValores[8],'CH' ,'',0,''})
oCodPagto:= M->UA_CONDPG
oParcelas:= ACLONE(aRetParc)
oCodPagto:= cCodPagto
aParcelas:= ACLONE(aRetParc)
nEntrada := aValores[8]
cCodTransp:= M->UA_TRANSP
oCodTransp:= M->UA_TRANSP
cUfE     := M->UA_ESTE
oUfE     := M->UA_ESTE
cEnt     :=	M->UA_ENDENT
oEnt     :=	M->UA_ENDENT
cBairroE :=	M->UA_BAIRROE
oBairroE :=	M->UA_BAIRROE
cCepE    :=	M->UA_CEPE
oCepE    :=	M->UA_CEPE
oCidadeE :=	M->UA_MUNE
cCidadeE :=	M->UA_MUNE

   	Return   .t.
