#Include "Protheus.ch"
#Include "Totvs.ch"

/*/Protheus.doc STCRGSB1
(long_description) Leitura de arquivo CSV para atualização do cadastro de Produto.
@author Eduardo Pereira - Sigamat
@since 14/06/2021
@version 12.1.27
/*/

User Function STCRGSB1()

    Processa({|| STCRGSBA()}, "Carregando os registros...")

Return

Static Function STCRGSBA()

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
	Local i             := 0
    //Local cMensag       := ""
	Private cCaminho 	:= ""
	Private cArquivo	:= ""

	cCaminho := Substr(cDir,1,RAt("\",cDir))	// Apenas o caminho onde se encontra o CSV

	cArquivo := RetFileName(cDir) + ".csv"	// Apenas o arquivo csv

	If !File(cCaminho + cArquivo)
		MsgStop("O arquivo " + cCaminho + cArquivo + " não foi encontrado. A importação será abortada!","[STCRGSB1] - ATENCAO")
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
		SB1->( dbSetOrder(1) ) // B1_FILIAL + B1_COD
		If SB1->( dbSeek(xFilial("SB1") + aDados[i,1]) )
            IncProc("Atualizando Produto: " + Alltrim(SB1->B1_COD) + " - " + Alltrim(SB1->B1_DESC))
			RecLock("SB1", .F.)
			// Ticket 20210517008090 - Carga campo Descricao em Ingles - Eduardo Pereira Sigamat - 16.06.2021 - Inicio
			/*
			If !Empty(SB1->B1_DESC_I)
                cMensag := CRLF + Alltrim(aDados[i,2])
            Else
                cMensag := aDados[i,2]
            EndIf
            MSMM(SB1->B1_DESC_I,,,cMensag,1,,,"SB1", "B1_DESC_I",,.T.)
			*/
			// Ticket 20210517008090 - Carga campo Descricao em Ingles - Eduardo Pereira Sigamat - 16.06.2021 - Fim
			// Ticket 20210616010199 - Atualização do ES e Média de Cons.. - Eduardo Pereira Sigamat - 17.06.2021 - Inicio
			SB1->B1_ESTSEG	:= Val(Strtran(Strtran(Alltrim(aDados[i,3]),".",""),",","."))
			SB1->B1_XCONS	:= Val(Strtran(Strtran(Alltrim(aDados[i,2]),".",""),",","."))
			// Ticket 20210616010199 - Atualização do ES e Média de Cons.. - Eduardo Pereira Sigamat - 17.06.2021 - Fim
			MsUnLock()
 		Else
			//ApMsgInfo("Produto do arquivo: " + Alltrim(aDados[i,1]),"[STCRGSB1] - NAO ENCONTRADO")
			MsgRun("Produto do arquivo: " + Alltrim(aDados[i,1]) + " - [STCRGSB1] - NAO ENCONTRADO",,{|| Sleep(1000) })
		EndIf
    Next i

    ApMsgInfo("Atualização concluída com sucesso!","[STCRGSB1] - SUCESSO")

Return
