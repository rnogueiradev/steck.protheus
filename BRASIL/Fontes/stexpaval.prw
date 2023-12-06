#Include "Protheus.ch"

/*/{Protheus.doc} stexpaval
    Rotina Exporta Avaliação
    @author Valdemir Rabelo
    @since 25/11/2019
/*/ 
User Function stexpaval()
    Local cCaminho := GetSrvProfString("RootPath","")+GetSrvProfString("StartPath","")
    Local cArquivo := "Modelo_Avaliacao.xml"
    Local cArqSyst := GetSrvProfString("StartPath","")+"Modelo_Avaliacao.xml"
    Local aAreaZ49 := GetArea()
    Local cCamTMP  := SuperGetMV("ST_CAMAVAL",.f.,"C:\Temp\AVALIACAO_MAT"+Z49->Z49_MAT+".xml")
    Local aResulta := {0,0,0,0,0}
	Local nY := 0
	Local nX := 0
	Local cConteud := ""
	Local cCoringa := ""
    // Atenção o arquivo ao ser gerado é criado no temporario do usuário e na pasta definida no parâmetro acima.
    // CAso o usuário salve o arquivo que será apresentado, estará salvando na pasta temporaria da maquina do usuário
    MsgInfo("O arquivo será salvo no caminho parametrizado"+CRLF+cCamTMP+CRLF+CRLF+"Pressione <ENTER> para continuar","Atenção!")

    dbSelectArea("Z49")

    if File(cCamTMP+"AVALIACAO_MAT"+Z49->Z49_MAT+".xml")                   // Verifico a existencia do arquivo
       if !File(cArqSyst)                       // Se não existir na system, faço a copia para ela
         If !CpyT2S(cCamTMP+"AVALIACAO_MAT"+Z49->Z49_MAT+".xml", GetSrvProfString("StartPath",""), .T.)
            MsgAlert("Não foi possível copiar o arquivo template Excel para o diretório System.")
            Return
         EndIf
       Endif
    Endif
    if file(GetTempPath()+cArquivo)         // Se existir o arquivo na temporaria do usuário apago
       FErase(GetTempPath()+cArquivo)
    EndIf

    //... Estanciando objeto excel
    oExcelXml :=  StzExcelXML():New(.F.)                                  // Instância o Objeto
    oExcelXml:SetOrigem( cArqSyst )                                     // Indica o caminho do arquivo Origem (que será aberto e clonado)
    oExcelXml:SetDestino(GetTempPath()+cArquivo)                        // Indica o caminho do arquivo Destino (que será gerado)
    oExcelXML:CopyTo(cCamTMP)                                          // Adiciona caminho de cópia que será gerado ao montar o arquivo

    if cEmpAnt == '03'
       cSP  := ""
       CMA  := "X"
    else
       cSP  := "X"
       CMA  := ""
    Endif

    IF SRA->( dbSeek(xFilial('SRA')+Z49->Z49_MAT))
        if !Empty(SRA->RA_DEPTO)
            cCargo    := SRA->RA_CARGO
            cAdmissao := dtoc(SRA->RA_ADMISSA)
            cCCusto   := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
            if !SQB->( dbSeek(xFilial('SQB')+SRA->RA_DEPTO) )
                FWMsgRun(, {|| sleep(3000)},"Informativo","Departamento não encontrado. Por favor, verifique.")
                Return
            endif
            cArea := SQB->QB_DESCRIC
            IF !SRA->( dbSeek(SQB->QB_FILRESP+SQB->QB_MATRESP))
                FWMsgRun(, {|| sleep(3000)},"Informativo","Responsável não encontrado. Por favor, verifique.")
                Return               
            Endif            
            cAvaliador := SRA->RA_NOME
        Endif
    ELSE
       FWMsgRun(, {|| sleep(3000)},"Informativo","Colaborador não encontrado. Por favor, verifique.")
       Return
    Endif

    oExcelXML:AddExpression("#SP", cSP)                             //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#AM", CMA)                             //Adiciona expressão que será substituída

    oExcelXML:AddExpression("#NOMAVAL",    Z49->Z49_NOME)     //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#CARGO",       cCargo)            //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#MATRICULA",   Z49->Z49_MAT)      //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#AREA",        cArea)             //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#DATAADM",     cAdmissao)         //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#AVALIADOR",   cAvaliador)        //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#CCUSTO",      cCCusto)            //Adiciona expressão que será substituída
    cCoringa := ""
    cConteud := ""
    For nX := 1 to 11
        if nX <= 10
          _Pergunta := "Z49->Z49_C"+STRZERO(nX,2)
            For nY := 1 to 5
                cCoringa := "#P"+cValToChar(nX)+cValToChar(nY)
                cConteud := if(&(_Pergunta)==cValToChar(nY), "X","")
                oExcelXML:AddExpression(cCoringa, cConteud )            //Adiciona expressão que será substituída
                aResulta[nY] += 1
            Next
        else
          _Pergunta := "Z49->Z49_C"+STRZERO(nX,2)
            For nY := 1 to 5
                cCoringa := "#PZ"+cValToChar(nY)
                cConteud := if(&(_Pergunta)==cValToChar(nY), "X","")
                oExcelXML:AddExpression(cCoringa, cConteud )            //Adiciona expressão que será substituída
                if !Empty(cConteud)
                   aResulta[nY] += 1
                endif
            Next
        endif
    Next
    nPorc := (aResulta[1]+aResulta[2]+aResulta[3]+aResulta[4]+aResulta[5]) / 55
    oExcelXML:AddExpression("#PORC",    nPorc )  
    oExcelXML:AddExpression("#A1",      FwNoAccent(Z49->Z49_PON01) )            //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#A2",      "")                                     //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#B1",      FwNoAccent(Z49->Z49_PON02) )            //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#B2",      "")                                     //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#C1",      Z49->Z49_ORIENT )           //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#C2",      "")                                     //Adiciona expressão que será substituída
    cAno := alltrim(Str(Year(dDATABASE)))
    oExcelXML:AddExpression("#EFETIVAR",      IiF(Z49->Z49_DECISA = "1","X","") )                        //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#DEMITIDO",      IiF(Z49->Z49_DECISA = "2","X","") )                        //Adiciona expressão que será substituída
    oExcelXML:AddExpression("#Ano",           cAno    )                                       //Adiciona expressão que será substituída
    
    oExcelXML:MountFile()                                              // Monta o arquivo
    oExcelXML:ViewSO()                                                 // Abre o .xml conforme configuração do Sistema Operacional,
                                                                       // ou seja, se tiver Linux + LibreOffice ele irá abrir
    //oExcelXML:View()                                                 // Utilizar apenas se não for utilizado o método ViewSO
                                                                       // pois dessa forma é forçado a abrir pelo Excel
    oExcelXml:Destroy(.F.)                                             // Destrói os atributos do objeto
    oExcelXml:ShowMessage("Exportação realizado com sucesso",.T.)      // Testa demonstração de mensagem em branco

    RestArea( aAreaZ49 )

Return