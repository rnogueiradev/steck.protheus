#include "protheus.ch"
#include "topconn.ch"
#Define CR chr(13)+chr(10)
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : STALTSC5IT				| 	Fevereiro de 2018								  		     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Everson Santana 						                                        |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela customizada para escolha de NF e Lotes de origem na Devolução.              |
|-----------------------------------------------------------------------------------------------|
*/
User Function XSTALC5IT()

	Local _oDlg
	Local _aAlter   	:= {"ITEMPC","NUMPCOM"} //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
	Local _cMsg 		:= ""
	Local nX:= 1
	Local x:= 1
	private _cNumPed	:= SC5->C5_NUM
	private _cLoja	:= SC5->C5_LOJACLI
	private _cClient	:= SC5->C5_CLIENTE
	private _cNome	:= POSICIONE( "SA1", 1, xFilial("SA1")+_cClient+_cLoja, "A1_NOME" )
	private _aHeader:= {}
	private _aFields:= { ("C6_ITEM"),;
							("C6_PRODUTO"),;
							("C6_DESCRI"),;
							("C6_LOCAL"),;
							("C6_QTDVEN"),;
							("PRCVEN"),;
							("C6_VALOR"),;
							("ITEMPC"),;
							("NUMPCOM")}////Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

	private nOpcA	:= 0
	private bOk		:= {|| nOpcA:=1,_oDlg:End()}
	private bCancel	:= {|| nOpcA:=0,_oDlg:End()}

	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))

	for nX := 1 To len(_aFields)
		if SX3->(MsSeek(_aFields[nX],.T.,.F.))
			Aadd(_aHeader,{	AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO,;
				SX3->X3_VLDUSER})
		ElseIf _aFields[nX] $ "PRCVEN"
			Aadd(_aHeader,{	"Prc Unitario"				,"PRCVEN"		,"@E 99,999,999.99999" ,14,05,"u_ValAt()","€€€€€€€€€€€€€€","N","","R","","",""})
		ElseIf _aFields[nX] $ "ITEMPC" ////Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
			Aadd(_aHeader,{	"Item Ped. Com"				,"ITEMPC"		,"@!" ,06,0,"","€€€€€€€€€€€€€€","C","","R","","",""})
		ElseIf _aFields[nX] $ "NUMPCOM" ////Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
			Aadd(_aHeader,{	"Num Ped. Comp"				,"NUMPCOM"		,"@!" ,15,0,"","€€€€€€€€€€€€€€","C","","R","","",""})

		EndIf
	next nX

	nUsado := len(_aHeader)

	_nPC6_ITEM		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_ITEM"})
	_nPC6_PROD		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_PRODUTO"})
	_nPC6_DESC		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_DESCRI"})
	_nPC6_LOCAL	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_LOCAL"})
	_nPC6_QTDVEN	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_QTDVEN"})
	_nPC6_PRCVEN	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "PRCVEN"})
	_nPC6_VALOR	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_VALOR"})
	//>> Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
	_nPC6_ITPC		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "ITEMPC"})
	_nPC6_NPCOM	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "NUMPCOM"})
	//<< Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

	_aCols := retQuery(_cNumPed,_cLoja,_cClient)
	_aColsIni := aClone(_aCols)
	DEFINE MSDIALOG _oDlg TITLE "Manutenção Pedido de Venda - V. 20180215.001" FROM 000, 000  TO 580, 1040  PIXEL

	oSay1   := TSay():New( 040,015,{||"Pedido:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_BLUE,080,008)
	oSay2   := TSay():New( 040,035,{||_cNumPed},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

	oSay3   := TSay():New( 040,065,{||"Ciente:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_BLUE,080,008)
	oSay4   := TSay():New( 040,085,{||_cClient},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

	oSay5   := TSay():New( 040,105,{||"Loja:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_BLUE,080,008)
	oSay6   := TSay():New( 040,120,{||_cLoja},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oSay7   := TSay():New( 040,130,{||_cNome},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_BLUE,080,008)


	oMSNewGet := MsNewGetDados():New( 060, 015, 280, 510, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", ,_aAlter,, 999, "AllwaysTrue", "", "AllwaysTrue" , _oDlg, _aHeader, _aCols)

	ACTIVATE MSDIALOG _oDlg CENTER ON INIT EnchoiceBar(_oDlg,bOk,bCancel)

	if nOpcA == 1

		_cMsg	+= "Usuário: "+cUserName+" "+CR
		_cMsg	+= "Alteração de Preço em: "+DTOC(DDATABASE)+" "+TIME()+" "+CR
		_cMsg	+= "Campo | Produto           | Anterior                               | Novo                                   "+" "+CR

		for x:=1 to len(oMSNewGet:aCols)

			If oMSNewGet:aCols[x][06] <> _aCols[x][06];
				.OR. oMSNewGet:aCols[x][08] <> _aCols[x][08];
				.OR. oMSNewGet:aCols[x][09] <> _aCols[x][09]


				_cMsg += "PRCVEN  | "+_aCols[x][02]+"|"+ Str(_aCols[x][06])+ " | "+ Str(oMSNewGet:aCols[x][06])+" "+CR
				_cMsg += "VALOR   | "+_aCols[x][02]+"|"+ Str(_aCols[x][07])+ " | "+ Str(oMSNewGet:aCols[x][07])+" "+CR
				_cMsg += "ITEMPC  | "+_aCols[x][02]+"|"+ _aCols[x][08]+      " | "+ oMSNewGet:aCols[x][08]     +" "+CR //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
				_cMsg += "NUMPCOM | "+_aCols[x][02]+"|"+ _aCols[x][09]+      " | "+ oMSNewGet:aCols[x][09]     +" "+CR //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

				SC5->(RecLock("SC5",.F.))
				MSMM(SC5->C5_XALTCAB,,,_cMsg,1,,,"SC5","C5_XALTCAB",,.T.)
				SC5->(MsUnlock("SC5"))

				DbSelectArea("SC6")
				DbSetOrder(1)
				DbGotop()//Filial+Num+Item+Produto
				If DbSeek(xFilial("SC6")+_cNumPed+_aCols[x][01]+_aCols[x][02])
					SC6->(RecLock("SC6",.F.))
					
					//NÃO PODE LIBERAR ALTERAÇÃO DE PREÇO DIRETAMENTE
					//SC6->C6_PRCVEN := oMSNewGet:aCols[x][06]
					//SC6->C6_PRUNIT := oMSNewGet:aCols[x][06]
					//SC6->C6_VALOR	 := oMSNewGet:aCols[x][07]
					SC6->C6_ITEMPC := oMSNewGet:aCols[x][08] //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
					SC6->C6_NUMPCOM := oMSNewGet:aCols[x][09] //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

					SC6->(MsUnlock("SC6"))
				EndIf

				DbSelectArea("SC9")
				DbSetOrder(1)
				DbGotop()//Filial+Num+Item
				If DbSeek(xFilial("SC9")+_cNumPed+_aCols[x][01])
					SC9->(RecLock("SC9",.F.))

					//NÃO PODE LIBERAR ALTERAÇÃO DE PREÇO DIRETAMENTE
					//SC9->C9_PRCVEN := oMSNewGet:aCols[x][06]

					SC9->(MsUnlock("SC9"))

				EndIf

			EndIf
		next x

	endif

Return
/*
|-----------------------------------------------------------------------------------------------|
|	Function : RetQuery				| 	Fevereiro de 2018	    								  		|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Everson Santana 																		|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Executa a query de seleção das notas e devolve array para ser usado no ACOLS	|
|-----------------------------------------------------------------------------------------------|
*/
Static Function retQuery(_cNumPed,_cLoja,_cClient)

	local _cQuery	:= ""
	local _aCols 	:= {}

	_nPC6_ITEM		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_ITEM"})
	_nPC6_PROD		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_PRODUTO"})
	_nPC6_DESC		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_DESCRI"})
	_nPC6_LOCAL	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_LOCAL"})
	_nPC6_QTDVEN	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_QTDVEN"})
	_nPC6_PRCVEN	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "PRCVEN"})
	_nPC6_VALOR	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_VALOR"})
	_nPC6_ITPC		:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "ITEMPC"}) //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
	_nPC6_NPCOM	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "NUMPCOM"}) //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

	_cQuery := " "
	_cQuery += " SELECT * "
	_cQuery += " FROM " + RetSqlName("SC6") + " C6 "
	_cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' "
	_cQuery += " 	AND C6_NUM = '" + _cNumPed + "' "
	_cQuery += " 	AND C6_CLI = '" + _cClient + "' "
	_cQuery += " 	AND C6_LOJA = '" + _cLoja + "' "
	_cQuery += " 	AND D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY C6_ITEM "

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	tcQuery _cQuery new alias "TRB"

	do while ! TRB->(eof())

		aadd(_aCols, array(nUsado+1))

		_aCols[len(_aCols), _nPC6_ITEM]		:= TRB->C6_ITEM
		_aCols[len(_aCols), _nPC6_PROD]		:= TRB->C6_PRODUTO
		_aCols[len(_aCols), _nPC6_DESC]		:= TRB->C6_DESCRI
		_aCols[len(_aCols), _nPC6_LOCAL]  	:= TRB->C6_LOCAL
		_aCols[len(_aCols), _nPC6_QTDVEN] 	:= TRB->C6_QTDVEN
		_aCols[len(_aCols), _nPC6_PRCVEN]	:= TRB->C6_PRCVEN
		_aCols[len(_aCols), _nPC6_VALOR]  	:= TRB->C6_VALOR
		_aCols[len(_aCols), _nPC6_ITPC] 	:= TRB->C6_ITEMPC //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18
		_aCols[len(_aCols), _nPC6_NPCOM]	:= TRB->C6_NUMPCOM //Chamado 7092 - Adicionar os campo C6_ITEMPC e C6_NUMPCOM - Everson Santana - 26.03.18

		_aCols[len(_aCols), nUsado+1] := .F.

		TRB->(dbSkip())

	enddo

	TRB->(dbCloseArea())

Return _aCols
/*
|-----------------------------------------------------------------------------------------------|
|	Function : ValAt					| 	    Fevereiro 2018    								  		 |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Everson Santana				    												 |
|-----------------------------------------------------------------------------------------------|
|	Descrição : 	   																						  |
|-----------------------------------------------------------------------------------------------|
*/
User Function ValAt()

	Local _nPRCVEN 	:= 0
	Local _nVALOR 	:= 0
	Local _nQTDVEN 	:= 0
	Local _cTipo  	:= 0
	Local _lRet	  	:= .T.
	local _lTipo  	:= .T.

	_nPC6_VALOR	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_VALOR"})
	_nPC6_QTDVEN	:= aScan(_aHeader,{|x| Upper(allTrim(x[2])) == "C6_QTDVEN"})

	_nPRCVEN 	:= M->PRCVEN
	_nQTDVEN  	:= _aCols[n, _nPC6_QTDVEN]
	_nVALOR 	:= _nPRCVEN  * _nQTDVEN

	oMSNewGet:aCols[n, _nPC6_VALOR] := _nVALOR

	oMSNewGet:refresh()

Return _lRet
