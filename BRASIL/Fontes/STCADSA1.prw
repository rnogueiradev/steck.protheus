#Include "Protheus.ch"
#Include "Totvs.ch"

/*/Protheus.doc STCADSA1
(long_description) Leitura de arquivo CSV para atualização do cadastro de clientes
@author Eduardo Pereira - Sigamat
@since 08/06/2020
@version 12.1.27
/*/

User Function STCADSA1()

    Processa({|| STCADSAA()}, "Carregando os registros...")

Return

Static Function STCADSAA()

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
	Private cCaminho 	:= ""
	Private cArquivo	:= ""

	cCaminho := Substr(cDir,1,RAt("\",cDir))	// Apenas o caminho onde se encontra o CSV

	cArquivo := RetFileName(cDir) + ".csv"	// Apenas o arquivo csv

	If !File(cCaminho + cArquivo)
		MsgStop("O arquivo " + cCaminho + cArquivo + " não foi encontrado. A importação será abortada!","[STCADSA1] - ATENCAO")
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

	If Len(aDados) = 0
		Aviso( "Carga de Dados", "Nao existe registro no arquivo a consultar", {"Ok"} )
		Return
	EndIf

	For i := 1 to Len(aDados)
		SA1->( dbSetOrder(1) ) // A1_FILIAL + A1_COD + A1_LOJA
		If SA1->( dbSeek(xFilial("SA1") + Strzero(Val(aDados[i,1]),6) + Strzero(Val(aDados[i,2]),2)) )
            IncProc("Atualizando cliente: " + SA1->A1_COD + " - " + Alltrim(SA1->A1_NREDUZ))
			RecLock("SA1", .F.)
            SA1->A1_XCENCOB := aDados[i,3]
            SA1->A1_XCOBRAD := Alltrim(aDados[i,4])
            MsUnLock()
		Else
			ApMsgInfo("Código do Cliente do arquivo: " + Alltrim(aDados[i,1]),"[STCADSA1] - NAO ENCONTRADO")
		EndIf
    Next i

    ApMsgInfo("Atualização concluída com sucesso!","[STCADSA1] - SUCESSO")

Return
