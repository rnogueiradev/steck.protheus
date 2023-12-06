#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "RWMake.ch"

/*/Protheus.doc STELREPV
(long_description) Elimina residuo em massa do pedido de venda através da leitura de um CSV - Função chamada do P.E. MT410ALT
@author Eduardo Pereira - Sigamat
@since 23/06/2021
@version 12.1.25
/*/

User Function STELREPV()

    Processa({|| STELRE01()}, "Carregando os registros...")

Return

Static Function STELRE01()

	Local cDir          :=  cGetFile("Arquivo CSV|*.csv|"           ,;	//[ cMascara],
                            "Selecao de Arquivos"					,;  //[ cTitulo],
                            0										,;  //[ nMascpadrao],
                            ""										,;  //[ cDirinicial],
                            .F.										,;  //[ lSalvar],
                            GETF_LOCALHARD  + GETF_NETWORKDRIVE		,;  //[ nOpcoes],
                            .T.									 	 )  //[ lArvore]
	Local cLinha        := ""
	Local lPrim         := .T.
	Local aCampos       := {}
	Local aDados        := {}
    Local l             := 0
	Local i             := 0
    Local aHeader       := {}
    Local aLine         := {}
    Local aItens        := {}
    Local aIndice       := {}
    Local nQtdAtua      := 0
    Local lCabec        := .T.
    Local lErro         := .F.
    Local aErroAuto     := {}
    Local cLogErro      := ""
    Local nCount        := 0
	Private cCaminho 	:= ""
	Private cArquivo	:= ""
    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.

	cCaminho := Substr(cDir,1,RAt("\",cDir))	// Apenas o caminho onde se encontra o CSV

	cArquivo := RetFileName(cDir) + ".csv"	// Apenas o arquivo csv

	If !File(cCaminho + cArquivo)
		MsgStop("O arquivo " + cCaminho + cArquivo + " não foi encontrado. A importação será abortada!","[STELREPV] - Atencao")
		Return
	EndIf

	FT_FUSE(cCaminho + cArquivo)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()
		IncProc("Lendo arquivo texto...")
		cLinha := FT_FREADLN()
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			aAdd(aDados,Separa(cLinha,";",.T.))
		EndIf
		FT_FSKIP()
	End

	If Len(aDados) == 0
		Aviso( "Carga de Dados", "Nao existe registro no arquivo a consultar", {"Ok"} )
		Return
	EndIf

    For i := 1 to Len(aDados)
        If aScan(aIndice,{|x| AllTrim(x[1]) == aDados[i,1] }) == 0
            aAdd(aIndice,{aDados[i,1]})
        EndIf
    Next i

    For l := 1 to Len(aIndice)
        For i := 1 to Len(aDados)
            If aIndice[l,1] == aDados[i,1]
                If lCabec
                    // Posiciono no Cabeçalho
                    SC5->( dbSetOrder(1) )  // C5_FILIAL + C5_NUM
                    If SC5->( dbSeek(xFilial("SC5") + Strzero(Val(aDados[i,1]),6)) )
                        IncProc("Atualizando Pedido: " + Strzero(Val(aDados[i,1]),6))
                        // Cabeçalho
                        aAdd(aHeader, {"C5_NUM"     , SC5->C5_NUM        , Nil})
                        aAdd(aHeader, {"C5_TIPO"    , SC5->C5_TIPO       , Nil})
                        aAdd(aHeader, {"C5_CLIENTE" , SC5->C5_CLIENTE    , Nil})
                        aAdd(aHeader, {"C5_LOJACLI" , SC5->C5_LOJACLI    , Nil})
                        aAdd(aHeader, {"C5_LOJAENT" , SC5->C5_LOJAENT    , Nil})
                        aAdd(aHeader, {"C5_CONDPAG" , SC5->C5_CONDPAG    , Nil})
                        aAdd(aHeader, {"C5_ZCONDPG" , SC5->C5_ZCONDPG    , Nil})
                        aAdd(aHeader, {"C5_XTIPO"   , SC5->C5_XTIPO      , Nil})
                        aAdd(aHeader, {"C5_XTIPF"   , SC5->C5_XTIPF      , Nil})
                        lCabec := .F.
                    EndIf
                EndIf
                // Posiciono nos Itens
                SC6->( dbSetOrder(1) )  // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
                If SC6->( dbSeek(xFilial("SC5") + SC5->C5_NUM + aDados[i,2]) )
                    nQtdAtua := SC6->C6_QTDVEN - Val(aDados[i,3])
                    // Itens
                    aLine   := {}
                    aAdd(aLine,{"LINPOS"    , "C6_ITEM"                 , SC6->C6_ITEM})
                    aAdd(aLine,{"AUTDELETA" , "N"                       , Nil})
                    aAdd(aLine,{"C6_PRODUTO", SC6->C6_PRODUTO           , Nil})
                    aAdd(aLine,{"C6_LOCAL"  , SC6->C6_LOCAL             , Nil})
                    aAdd(aLine,{"C6_QTDVEN" , nQtdAtua                  , Nil})
                    aAdd(aLine,{"C6_PRCVEN" , SC6->C6_PRCVEN            , Nil})
                    aAdd(aLine,{"C6_VALOR"  , SC6->C6_PRCVEN * nQtdAtua , Nil})
                    aAdd(aLine,{"C6_TES"    , SC6->C6_TES               , Nil})
                    aAdd(aLine,{"C6_PRUNIT" , SC6->C6_PRUNIT            , Nil})
                    //aAdd(aLine,{"C6_XBASE" , "S"                        , Nil})
                    aAdd(aItens, aLine)
                Else
                    MsgRun("Item: " + Strzero(Val(aDados[i,2]),2) + " - [STELREPV] - Nao Encontrado",,{ || Sleep(1000) })
                EndIf
            EndIf
        Next i
        MsExecAuto({|x,y,z|Mata410(x,y,z)},aHeader,aItens,4)
        //MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aHeader, aItens, 4, .F.)
        If !lMsErroAuto
            MsgRun("Pedido atualizado com sucesso! " + SC5->C5_NUM,,{ || Sleep(1000) })
            ConOut("Pedido atualizado com sucesso! " + SC5->C5_NUM)
        Else
            lErro := .T.
            ConOut("Erro na alteração!")
            aErroAuto := GetAutoGRLog()
            cLogErro := ""
            For nCount := 1 To Len(aErroAuto)
                cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + CRLF
                ConOut(cLogErro)
            Next nCount
            MsgInfo(cLogErro)
        EndIf
        aHeader := {}
        aItens  := {}
        lCabec  := .T.
    Next l

    If !lErro
        ApMsgInfo("Atualização concluída com sucesso!","[STELREPV] - Sucesso")
    EndIf

Return
