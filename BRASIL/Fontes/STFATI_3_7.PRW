#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFAI_3_7      | Autor | GIOVANI.ZAGO               | Data | 09/01/2013  |
|=====================================================================================|
|Descrição | Validação do sx1 do matr540, vendedor interno e externo                  |
|          | Filtro do sxB do matr540, vendedor interno e externo                     |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFAI_3_7                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------------------------------*
User Function STFAI_3_7(cCodVend)
*---------------------------------------------------*

Local aArea      := GetArea()
Local aAreaSa3   := SA3->(GetArea())
Local lret       := .F.
Local cQuery     := ''
Local cAliasLif  := ''

If Type('cCodVenTip') != 'C'
	Public cCodVenTip := ''
EndIf

If cCodVend = 'FILTROSA3'
	If !Empty(cCodVenTip)
		
		If substr(cCodVenTip,1,1) <> 'I'
			If SA3->A3_COD  = substr(cCodVenTip,2,6)
				lret    := .T.
			EndIf
			If cCodVenTip = '1234567'
				lret    := .T.
			EndIf
		Else
			lret    := .T.
		EndIf
	Else
		cAliasLif := 'TMP1'
		cQuery := " SELECT A3_COD AS CODUSR ,A3_TPVEND as TPVEND ,A3_CODUSR from  "+RetSqlName('SA3')+" WHERE A3_FILIAL = '  ' AND D_E_L_E_T_ = ' 'AND A3_CODUSR = '"+__CUSERID+"'
		cQuery := ChangeQuery(cQuery)
		
		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		
		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			cCodVenTip:= (cAliasLif)->TPVEND + (cAliasLif)->CODUSR
		EndIf
		
		If Empty(alltrim(cCodVenTip))
			cCodVenTip:='1234567'
			lret    := .T.
		EndIf
		If substr(cCodVenTip,1,1) <> 'I'
			If SA3->A3_COD  = substr(cCodVenTip,2,6)
				lret    := .T.
			EndIf
		Else
			lret := .T.
		EndIf
	EndIf
Else
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+RetCodUsr()))
		
		If SA3->A3_TPVEND <> 'I'  .And. cCodVend = SA3->A3_COD
			lret:= .T.
		ElseIf SA3->A3_TPVEND = 'I'
			lret:= .T.
		Else
			msgInfo(alltrim(SA3->A3_NREDUZ)+' Utilize Seu Codigo De Vendedor ( '+SA3->A3_COD+' ) !!!!')
		EndIf
	Else
		lret:= .T.
	EndIf
EndIf

Restarea(aArea)
SA3->(Restarea(aAreaSa3))
Return(lRet)
