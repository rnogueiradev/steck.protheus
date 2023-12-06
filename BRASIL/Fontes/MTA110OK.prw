#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MTA110OK        | Autor | RENATO.NOGUEIRA            | Data | 17/01/2016 |
|=====================================================================================|
|Descrição | Validar solicitação de compras 										  |
|          | 																		  |
|          | 																		  |
|=====================================================================================|
|Sintaxe   | 																		  |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MTA110OK()

	Local _aArea    	:= GetArea()
	Local _lRet			:= .T.
	Local nPosNum		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_NUM" })
	Local nPosCnpj		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_XCNPJ" })
	Local nPosNf		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_XNF" })
	Local nPosSer		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_XSERIE" })
	Local nPosVal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_XVALOR" })
	Local nPosVenc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C1_XVENCNF" })
	Local _nX			:= 0
	Local _lAnexo 		:= .F.
	Local _lNf			:= .F.
	Local nTamMax   	:= 5
	Local _cServerDir 	:= "\arquivos\anexossolic\"
	Local nMB       	:= 1024

	If IsInCallStack("MATA110") .And. !IsBlind()

		For _nX:=1 to Len(aCols)

			If !Empty(aCols[_nX,nPosCnpj]) .Or. !Empty(aCols[_nX,nPosNf]) .Or. !Empty(aCols[_nX,nPosSer]);
			.Or. !Empty(aCols[_nX,nPosVal]) .Or. !Empty(aCols[_nX,nPosVenc])

				_lNf := .T.

				If Empty(aCols[_nX,nPosCnpj])
					MsgAlert("Atenção, preencher o campo CNPJ!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosNf])
					MsgAlert("Atenção, preencher o campo NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosSer])
					MsgAlert("Atenção, preencher o campo Série NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosVal])
					MsgAlert("Atenção, preencher o campo Valor NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosVenc])
					MsgAlert("Atenção, preencher o campo Vencto NF!")
					Return(.F.)
				EndIf

			EndIf

		Next

		If _lNf

			_lTemNf := .F.

			//Solicitar anexo
			While !_lTemNf
				MsgAlert("Favor anexar a nota na próxima tela, essa operação é obrigatória...")
				If U_STCOM016(cA110Num)
					_lTemNf := .T.
				EndIf
			EndDo

		EndIf

	EndIf

	RestArea(_aArea)

Return(_lRet)
