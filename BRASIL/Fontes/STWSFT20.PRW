#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STWSFT20         | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|Descrição | Montagem de querys para graficos de vendas						          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STWSFT20(_cVend)

	Local _cQuery1 		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local _nCount 		:= 0
	Local _cRetorno		:= "<ranking>"
	Private cAliasLif   := GetNextAlias()

	DbSelectArea("Z22")
	Z22->(DbSetOrder(2))

	_cQuery1 := " SELECT Z22_CODIGO
	_cQuery1 += " FROM "+RetSqlName("Z22")+" Z22
	_cQuery1 += " WHERE Z22.D_E_L_E_T_=' '
	_cQuery1 += " AND Z22_STATUS='A'
	
	If AllTrim(_cVend)=="Z00002"
		_cQuery1 += " AND Z22_TIPO='I'
	Else
		_cQuery1 += " AND Z22_TIPO='E'
	EndIf
	
	cONOUT(_cQuery1)

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())

		If Z22->(DbSeek(xFilial("Z22")+(_cAlias1)->Z22_CODIGO))

			U_RSTFA_C8() //Processar query

			DbSelectArea(cAliasLif)
			(cAliasLif)->(DbGoTop())

			If  Select(cAliasLif) > 0

				While 	(cAliasLif)->(!Eof())

					_nCount++

					_cRetorno += "<vend>
					_cRetorno += "<posicao>"+cValToChar(_nCount)+"</posicao>
					_cRetorno += "<nome>"+Alltrim((cAliasLif)->A3_NOME)+"</nome>
					_cRetorno += "<percent>"+cValToChar((cAliasLif)->PERCENT)+"</percent>
					_cRetorno += "</vend>

					If _nCount==5
						Exit
					EndIf

					(cAliasLif)->(dbskip())
				EndDo

			EndIf
		EndIf
	EndIf

	_cRetorno += "</ranking>"

Return(_cRetorno)