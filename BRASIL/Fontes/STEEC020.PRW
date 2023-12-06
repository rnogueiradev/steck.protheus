#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STEEC020        | Autor | RENATO.OLIVEIRA           | Data | 30/07/2018  |
|=====================================================================================|
|Descrição | RESUMO DOS VALORES EMBALADOS			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado 006974																	      |
\====================================================================================*/

User Function STEEC020()

	Local _aOs 		:= {}
	Local _aHeader1 := {}
	Local _aCols1 	:= {}
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()
	Local _nTotal	:= 0
	Local nY		:= 0
	Private aRet            := {}
	Private aParamBox 		:= {}

	DbSelectArea("CB7")
	CB7->(DbSetOrder(2))
	CB7->(DbGoTop())
	CB7->(DbSeek(xFilial("CB7")+EE7->EE7_PEDFAT))

	While CB7->(!Eof()) .And. CB7->(CB7_FILIAL+CB7_PEDIDO)==xFilial("CB7")+EE7->EE7_PEDFAT

		If CB7->CB7_STATUS>="4"
			AADD(_aOS,CB7->CB7_ORDSEP)
		EndIf

		CB7->(DbSkip())
	EndDo

	If Len(_aOs)==0
		MsgAlert("Atenção, não foi encontrada nenhuma OS embalada para esse pedido, verifique")
		Return
	EndIf

	AADD(aParamBox,{2,"Selecione a OS",,_aOS,50,"",.T.})

	If !ParamBox(aParamBox,"Parâmetros...",@aRet)
		Return
	EndIf

	Aadd(_aHeader1,{"Filial"				,"CB8_FILIAL"	,"@!"						,TamSx3("CB8_FILIAL")[1]		,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Pedido"				,"CB8_PEDIDO"	,"@!"						,TamSx3("CB8_PEDIDO")[1]		,0				,"",,"C","R"})
	Aadd(_aHeader1,{"OS"					,"CB8_ORDSEP"	,"@!"						,TamSx3("CB8_ORDSEP")[1]		,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Item"		     		,"CB8_ITEM"		,"@!"						,TamSx3("CB8_ITEM")[1]			,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Produto"	     		,"CB8_PROD"		,"@!"						,TamSx3("CB8_PROD")[1]			,0				,"",,"C","R"})
	Aadd(_aHeader1,{"Quantidade"     		,"CB8_QTDORI"	,"@E 999,999,999.99"		,TamSx3("CB8_QTDORI")[1]		,0				,"",,"N","R"})
	Aadd(_aHeader1,{"Preço"     			,"C6_PRCVEN"	,"@E 99,999,999.99999"		,TamSx3("C6_PRCVEN")[1]			,0				,"",,"N","R"})
	Aadd(_aHeader1,{"Total"     			,"TOTAL"		,"@E 999,999,999.99"		,TamSx3("C6_VALOR")[1]			,0				,"",,"N","R"})

	_cQuery1 := " SELECT CB8_FILIAL, CB8_PEDIDO, CB8_ORDSEP, CB8_ITEM, CB8_PROD, CB8_QTDORI, C6_PRCVEN,
	_cQuery1 += " CB8_QTDORI*C6_PRCVEN TOTAL
	_cQuery1 += " FROM "+RetSqlName("CB8")+" CB8
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON CB8_FILIAL=C6_FILIAL AND CB8_PEDIDO=C6_NUM AND CB8_ITEM=C6_ITEM
	_cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND CB8_FILIAL='"+xFilial("CB8")+"'
	_cQuery1 += " AND CB8_ORDSEP='"+MV_PAR01+"'
	_cQuery1 += " ORDER BY CB8_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		AADD(_aCols1,Array(Len(_aHeader1)+1))

		For nY := 1 To Len(_aHeader1)

			DO CASE

				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_FILIAL"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_FILIAL
				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_PEDIDO"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_PEDIDO
				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_ORDSEP"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_ORDSEP
				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_ITEM"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_ITEM
				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_PROD"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_PROD
				CASE AllTrim(_aHeader1[nY][2]) =  "CB8_QTDORI"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->CB8_QTDORI
				CASE AllTrim(_aHeader1[nY][2]) =  "C6_PRCVEN"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->C6_PRCVEN
				CASE AllTrim(_aHeader1[nY][2]) =  "TOTAL"
				_aCols1[Len(_aCols1)][nY] := (_cAlias1)->TOTAL
				_nTotal += (_cAlias1)->TOTAL
			ENDCASE

		Next

		_aCols1[Len(_aCols1)][Len(_aHeader1)+1] := .F.

		(_cAlias1)->(DbSkip())
	EndDo

	AADD(_aCols1,Array(Len(_aHeader1)+1))

	For nY := 1 To Len(_aHeader1)

		DO CASE
			CASE AllTrim(_aHeader1[nY][2]) =  "TOTAL"
			_aCols1[Len(_aCols1)][nY] := _nTotal
		ENDCASE

	Next

	_aCols1[Len(_aCols1)][Len(_aHeader1)+1] := .F.

	DEFINE MSDIALOG oDlgEmail1 TITLE OemToAnsi("Valores") From  1,0 To 500,800 Pixel

	_oGet	:= MsNewGetDados():New(0,0,oDlgEmail1:nClientHeight/2-15,oDlgEmail1:nClientWidth/2-5,,"AllWaysTrue()","AllWaysTrue()",,,,Len(_aCols1),,, ,oDlgEmail1,_aHeader1,_aCols1)

	ACTIVATE MSDIALOG oDlgEmail1 CENTERED

Return