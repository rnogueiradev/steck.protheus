#INCLUDE "PROTHEUS.CH"

/*/Protheus.doc STIMPCMO
description
Rotina de Importar Dados da planilha CSV
Ticket: 20201113010557
@type function
@version 12.1.25
@author Valdemir Jose
@since 06/01/2021
/*/

User Function STIMPCMO()

	Local _aParamBox  := {}
	Local _aRet       := {}
	Local aDadosArq   := {}
	Local cPath       := "C:\Temp\"
	Local cArError    := cPath + DtoS(dDatabase) + StrTran(Time(),":","") + ".htm"
	PRIVATE aErrorLog := {}

	aAdd(_aParamBox,{6,"Buscar arquivo a importar",Space(100),"","","",70,.F.,"Todos os arquivos (*.csv) |*.csv"})
	If !ParamBox(_aParamBox,"Importar Arquivo",@_aRet,,,.T.,,500)
		Return .F.
	EndIf

	If !File(MV_PAR01)
		FWMsgRun(,{|| Sleep(3000)},'Informação','Arquivo informado, não encotrado. Por favor, verifique...')
		Return
	EndIf

	Processa({|| aDadosArq := ImpLerArq(MV_PAR01)}, "Aguarde Processando a leitura do arquivo...")
	Processa({|| GrvDados(aDadosArq) }, "Aguarde, Gravando registros...")

	If Len(aErrorLog)
		geraLog(cArError, aErrorLog)
	EndIf

Return

/*/Protheus.doc ImpLerArq
description
Rotina para importar arquivo CSV
@type function
@version 12.1.25
@author Valdemir Jose
@since 06/01/2021
return Array - aRET
/*/

Static Function ImpLerArq(pArquivo)

	Local aRET    := {}
	Local lPrim   := .T.
	Local cLinha  := ""
	Local nLinha  := 1
	Local aCampos := {}

	// Colunas a serem respeitadas
	// 01-Código fornecedor
	// 02-Loja Fornecedor
	// 03-Código da tabela
	// 04-Data De
	// 05-Data Ate
	// 06-Condição de pagto
	// 07-Produto
	// 08-Preço

	FT_FUSE( Alltrim(pArquivo) )
	ProcRegua( FT_FLASTREC() )
	FT_FGOTOP()
	Do While !FT_FEOF()
		IncProc('Carregando Linha: ' + cValTochar(nLinha))
		cLinha := FT_FREADLN()
		If lPrim
			aCampos	:= Separa(cLinha,";",.T.)
			lPrim	:= .F.
		Else
			aDados := Separa(cLinha,";",.T.)
			aAdd(aRET, CamposTabPrecoCMO():New())
			nUltLin := Len(aRET)
			aRET[nUltLin]:CODFOR   := aDados[1]
			aRET[nUltLin]:LOJA     := aDados[2]
			aRET[nUltLin]:CODTAB   := aDados[3]
			aRET[nUltLin]:DATADE   := CtoD(aDados[4])
			aRET[nUltLin]:DATAATE  := CtoD(aDados[5])
			aRET[nUltLin]:CONDPAG  := aDados[6]
			aRET[nUltLin]:PRODUTO  := aDados[7]
			aRET[nUltLin]:PRECO    := Val(StrTran(StrTran(aDados[8],".",""),",","."))
			aRET[nUltLin]:PRECO2UM := Val(StrTran(StrTran(aDados[9],".",""),",","."))
			aDados := {}
		EndIf
		If SubStr(cLinha,1,1) = ';'
			Exit
		EndIf
		FT_FSKIP()
	EndDo

	FT_FUSE()
	FRename(pArquivo, alltrim(pArquivo) + ".old")

Return aRET

/*/Protheus.doc GrvDados
description
Rotina grava Dados
@type function
@version 12.1.25
@author Valdemir Jose
@since 06/01/2021
/*/

Static Function GrvDados(aDados)

	Local nLin          := 0
	Local nCalc2UM      := 0
	Local _aCab         := {}
	Local _aIte         := {}
	Local nOPC          := 0
	Local aAreaB        := GetArea()
	Local cDProd        := ""
	Local cItem         := ""
	PRIVATE lMsErroAuto := .F.

	// Cabeçalho da Tabela de Preço
	dbSelectArea("AIA")
	dbSetOrder(1)	// AIA_FILIAL + AIA_CODFOR + AIA_LOJFOR + AIA_CODTAB
	// Itens da Tabela de Preço
	dbSelectArea("AIB")

	ProcRegua(Len(aDados))
	For nLin := 1 to Len(aDados)
		IncProc('Gravando Registro: ' + cValTochar(nLin))
		cItem  := ""
		If !VldDados(aDados[nLin], nLin)
			Loop
		EndIf
		If AIA->( !dbSeek(xFilial("AIA") + aDados[nLin]:CODFOR + aDados[nLin]:LOJA + aDados[nLin]:CODTAB))
			nOPC := 3
		Else
			nOPC := 4
			AIB->( dbSetOrder(2) )	// AIB_FILIAL + AIB_CODFOR + AIB_LOJFOR + AIB_CODTAB + AIB_CODPRO
			If AIB->( dbSeek(xFilial("AIA") + aDados[nLin]:CODFOR + aDados[nLin]:LOJA + aDados[nLin]:CODTAB + Alltrim(aDados[nLin]:PRODUTO)) )
				RecLock('AIB',.F.)
				AIB->( dbDelete() )
				MsUnlock()
			EndIf
		EndIf
		Begin Transaction
			aCabec := {}
			aAdd(aCabec,{"AIA_CODFOR"	, aDados[nLin]:CODFOR	,})
			aAdd(aCabec,{"AIA_LOJFOR"	, aDados[nLin]:LOJA		,})
			aAdd(aCabec,{"AIA_CODTAB"	, aDados[nLin]:CODTAB	,})
			aAdd(aCabec,{"AIA_DESCRI"	, "TABELA DE PRECO"		,})
			aAdd(aCabec,{"AIA_CONDPG"	, aDados[nLin]:CONDPAG	,})
			aAdd(aCabec,{"AIA_DATDE"	, aDados[nLin]:DATADE	,})
			aAdd(aCabec,{"AIA_DATATE"	, aDados[nLin]:DATAATE	,})
			cDProd := Posicione("SB1",1,xFilial('SB1') + aDados[nLin]:PRODUTO, "B1_DESC")
			If aDados[nLin]:PRECO2UM > 0
				nCalc2UM := CONVUM(aDados[nLin]:PRODUTO,1,1,2) * aDados[nLin]:PRECO2UM
				aDados[nLin]:PRECO := nCalc2UM
			EndIf
			aItens := {}
			aAdd(aItens,{})
			aAdd(aItens[Len(aItens)],{"AIB_CODPRO"	, aDados[nLin]:PRODUTO	,})
			aAdd(aItens[Len(aItens)],{"AIB_DESCRI"	, cDProd				,})
			aAdd(aItens[Len(aItens)],{"AIB_PRCCOM"	, aDados[nLin]:PRECO	,})
			aAdd(aItens[Len(aItens)],{"AIB_XPRC2"	, aDados[nLin]:PRECO2UM	,})
			aAdd(aItens[Len(aItens)],{"AIB_XTOT2"	, nCalc2UM				,})
			aAdd(aItens[Len(aItens)],{"AIB_DATVIG"	, aDados[nLin]:DATADE	,})
			aAdd(aItens[Len(aitens)],{"AIB_QTDLOT"	, 999999.99				,})
			aAdd(aItens[Len(aitens)],{"AIB_INDLOT"	, "000000000999999.99  ",})
			If !Empty(cItem)	// Utilizar o LINPOS para alteração e AUTDELETA para exclusão (S ou N)
				aAdd(aItens,{"LINPOS"      ,"AIB_ITEM"	, cItem})
				aAdd(aItens,{"AUTDELETA"   ,"N"         , Nil})
			EndIf
			_aCab := aClone(aCabec)
			_aIte := aClone(aItens)
			//3-Inclusão / 4-Alteração / 5-Exclusão
			MSExecAuto({|x,y,z| coma010(x,y,z)}, nOPC, _aCab, _aIte)
			If !lMsErroAuto
				ConOut("Registro Incluído com sucesso!   Registo: "+cValToChar(nLin))
				RecLock('AIB',.F.)
				AIB->AIB_XTOT2 := nCalc2UM
				MSUnLock()
				nCalc2UM := 0
			Else
				MostraErro()
				Break
			EndIf
			ConOut("Fim: " + Time())
		End Transaction
	Next

	RestArea( aAreaB )

Return

/*/Protheus.doc CamposTabPrecoCMO 
    (long_description)
    Criação da Classe 
    @author user
    @since 06/01/2021
    @version 12.1.25
/*/

Class CamposTabPrecoCMO

	DATA CODFOR AS CHARACTER
	DATA LOJA   AS CHARACTER
	DATA CODTAB AS CHARACTER
	DATA DATADE AS CHARACTER
	DATA DATAATE AS CHARACTER
	DATA CONDPAG AS CHARACTER
	DATA PRODUTO AS CHARACTER
	DATA PRECO  AS NUMERIC
	DATA PRECO2UM AS NUMERIC

	Method New() CONSTRUCTOR

EndClass

/*/Protheus.doc New 
    (long_description)
    @author user
    @since 06/01/2021
    @version 12.1.25
/*/

Method New() Class CamposTabPrecoCMO

	::CODFOR  := ""
	::LOJA    := ""
	::CODTAB  := ""
	::DATADE  := ""
	::DATAATE := ""
	::CONDPAG := ""
	::PRODUTO := ""
	::PRECO   := 0
	::PRECO2UM:= 0

Return .T.

/*/Protheus.doc VldDados
description
Rotina para validar o registro da planilha
@type function
@version 12.1.25
@author Valdemir Jose
@since 06/01/2021
/*/

Static Function VldDados(paDados, pnLin)

	Local aAreaVLD := GetArea()
	Local lRET     := .T.

	// VALIDA TAMANHO DO CAMPO
	If (Len(paDados:CODFOR) != TamSX3("A2_COD")[1])
		paDados:CODFOR := PadR(paDados:CODFOR,TamSX3("A2_COD")[1],"")
	EndIf

	If (Len(paDados:LOJA) != TamSX3("A2_LOJA")[1])
		paDados:LOJA := PadR(paDados:LOJA,TamSX3("A2_LOJA")[1],"")
	EndIf

	If (Len(paDados:CONDPAG) != TamSX3("E4_CODIGO")[1])
		paDados:CONDPAG := PadR(paDados:CONDPAG,TamSX3("E4_CODIGO")[1],"")
	EndIf

	If (Len(paDados:PRODUTO) != TamSX3("B1_COD")[1])
		paDados:PRODUTO := PadR(paDados:PRODUTO,TamSX3("B1_COD")[1],"")
	EndIf

	// Validando Dados da linha de registro da planilha
	dbSelectArea("SA2")
	dbSetOrder(1)
	If !dbSeek(xFilial('SA2') + paDados:CODFOR+paDados:LOJA)
		aAdd(aErrorLog, {"Linha: " + StrZero(pnLin, 4) + "  - Fornecedor+Loja:",paDados:CODFOR + paDados:LOJA, "Fornecedor Não Encontrado (SA2)"})
		lRET := .F.
	EndIf

	dbSelectArea("SE4")
	dbSetOrder(1)
	If !dbSeek(xFilial('SE4') + paDados:CONDPAG)
		aAdd(aErrorLog, {"Linha: " + StrZero(pnLin, 4) + "  - Cond.Pagto:",paDados:CONDPAG, "Cond. Pagto. Não Encontrado (SE4)"})
		lRET     := .F.
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial('SB1') + paDados:PRODUTO)
		aAdd(aErrorLog, {"Linha: " + StrZero(pnLin,4) + "  - Produto:",paDados:PRODUTO, "Produto Não Encontrado (SB1)"})
		lRET     := .F.
	EndIf

	RestArea( aAreaVLD )

Return lRET

/*/Protheus.doc geraLog
description
Rotina para gerar o Log de erro em formato HTML.
@type function
@version 12.1.25
@author Valdemir Jose
@since 06/01/2021
/*/

Static Function geraLog(cArError, _aMsg)

	Local cMsg := ""
	Local _nLin

	// Definicao do cabecalho do email                                             ³
	cMsg := ""
	cMsg += '<html>'
	cMsg += '	<head>'
	cMsg += '		<title>Inconsistências no Arquivo de Importação</title>'
	cMsg += '	</head>'
	cMsg += '	<body>'
	cMsg += '		<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '		<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '			<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>Inconsistências no Arquivo de Importação</FONT> </Caption>'

	// Definicao do texto/detalhe                                      ³
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '			<TR BgColor=#B0E2FF>'
		Else
			cMsg += '			<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '					<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '					<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '					<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '			</TR>'
	Next

	// Definicao do rodape                                                ³
	cMsg += '		</Table>'
	cMsg += '		<P>'
	cMsg += '		<Table align="center">'
	cMsg += '			<tr>'
	cMsg += '				<td colspan="10" align="center"><font color="red" size="3">Por favor, informar o responsável das inconsistências a serem corrigidas - <font color="red" size="1">(STIMPCMO)</td>'
	cMsg += '			</tr>'
	cMsg += '		</Table>'
	cMsg += '		<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '	</body>'
	cMsg += '</html>'

	Memowrite(cArError, cMsg)

	ShellExecute("open", cArError, "", "", 1)

Return
