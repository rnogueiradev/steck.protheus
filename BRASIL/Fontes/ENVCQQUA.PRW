
#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENVCQQUA  ºAutor  ³ Everaldo Gallo     º Data ³  04/26/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA ONDE EXISTE A DECISAO DE MANDAR OU NAO NF º±±
±±º          ³ PARA A QUALIDADE                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION ENVCQQUA
Private _cret:= ' '
_lret :=.t.

IF SD1->D1_TIPO $ "CIP"
	_lret :=.f.
endif

IF SD1->D1_FORNECE $ GETMV("ST_FORNCQ")
	_lret :=.f.
endif

If Alltrim(SD1->D1_FORNECE)+Alltrim(SD1->D1_LOJA) = '00576402'
	_cret:=  STRETRAB()
	If _cret ='1'
		_lret :=.T.
	EndIf
	
	
EndIf


RETURN   _lret

Static Function STRETRAB()

Local cAliasLif  := 'TMPB2'
Local cQuery     := ' '
Local _cRetrab   := ' '

cQuery += " SELECT
cQuery += " SC5.C5_XRETRAB
cQuery += " FROM SD2010 SD2
cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
cQuery += " ON SC5.D_E_L_E_T_ = ' '
cQuery += " AND SC5.C5_NUM = SD2.D2_PEDIDO
cQuery += " AND SC5.C5_FILIAL = SD2.D2_FILIAL
cQuery += " AND SC5.C5_XRETRAB = '1'
cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
cQuery += " AND SD2.D2_CLIENTE = '033467'
cQuery += " AND SD2.D2_LOJA    = '01'
cQuery += " AND SD2.D2_FILIAL = '02'
cQuery += " AND SD2.D2_DOC   = '"+SD1->D1_DOC+"'
cQuery += " AND SD2.D2_SERIE = '"+SD1->D1_SERIE+"'


cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
dbSelectArea(cAliasLif)
If  Select(cAliasLif) > 0
	(cAliasLif)->(dbgotop())
	
	_cRetrab 	:= (cAliasLif)->C5_XRETRAB
	
EndIf


If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf


Return (_cRetrab)
