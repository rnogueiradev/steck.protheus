#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MTA110OK        | Autor | RENATO.NOGUEIRA            | Data | 17/01/2016 |
|=====================================================================================|
|Descri��o | Validar solicita��o de compras 										  |
|          | 																		  |
|          | 																		  |
|=====================================================================================|
|Sintaxe   | 																		  |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
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
					MsgAlert("Aten��o, preencher o campo CNPJ!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosNf])
					MsgAlert("Aten��o, preencher o campo NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosSer])
					MsgAlert("Aten��o, preencher o campo S�rie NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosVal])
					MsgAlert("Aten��o, preencher o campo Valor NF!")
					Return(.F.)
				EndIf
				If Empty(aCols[_nX,nPosVenc])
					MsgAlert("Aten��o, preencher o campo Vencto NF!")
					Return(.F.)
				EndIf

			EndIf

		Next

		If _lNf

			_lTemNf := .F.

			//Solicitar anexo
			While !_lTemNf
				MsgAlert("Favor anexar a nota na pr�xima tela, essa opera��o � obrigat�ria...")
				If U_STCOM016(cA110Num)
					_lTemNf := .T.
				EndIf
			EndDo

		EndIf

	EndIf

	RestArea(_aArea)

Return(_lRet)
