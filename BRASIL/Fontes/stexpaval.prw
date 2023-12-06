#Include "Protheus.ch"

/*/{Protheus.doc} stexpaval
    Rotina Exporta Avalia��o
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
    // Aten��o o arquivo ao ser gerado � criado no temporario do usu�rio e na pasta definida no par�metro acima.
    // CAso o usu�rio salve o arquivo que ser� apresentado, estar� salvando na pasta temporaria da maquina do usu�rio
    MsgInfo("O arquivo ser� salvo no caminho parametrizado"+CRLF+cCamTMP+CRLF+CRLF+"Pressione <ENTER> para continuar","Aten��o!")

    dbSelectArea("Z49")

    if File(cCamTMP+"AVALIACAO_MAT"+Z49->Z49_MAT+".xml")                   // Verifico a existencia do arquivo
       if !File(cArqSyst)                       // Se n�o existir na system, fa�o a copia para ela
         If !CpyT2S(cCamTMP+"AVALIACAO_MAT"+Z49->Z49_MAT+".xml", GetSrvProfString("StartPath",""), .T.)
            MsgAlert("N�o foi poss�vel copiar o arquivo template Excel para o diret�rio System.")
            Return
         EndIf
       Endif
    Endif
    if file(GetTempPath()+cArquivo)         // Se existir o arquivo na temporaria do usu�rio apago
       FErase(GetTempPath()+cArquivo)
    EndIf

    //... Estanciando objeto excel
    oExcelXml :=  StzExcelXML():New(.F.)                                  // Inst�ncia o Objeto
    oExcelXml:SetOrigem( cArqSyst )                                     // Indica o caminho do arquivo Origem (que ser� aberto e clonado)
    oExcelXml:SetDestino(GetTempPath()+cArquivo)                        // Indica o caminho do arquivo Destino (que ser� gerado)
    oExcelXML:CopyTo(cCamTMP)                                          // Adiciona caminho de c�pia que ser� gerado ao montar o arquivo

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
                FWMsgRun(, {|| sleep(3000)},"Informativo","Departamento n�o encontrado. Por favor, verifique.")
                Return
            endif
            cArea := SQB->QB_DESCRIC
            IF !SRA->( dbSeek(SQB->QB_FILRESP+SQB->QB_MATRESP))
                FWMsgRun(, {|| sleep(3000)},"Informativo","Respons�vel n�o encontrado. Por favor, verifique.")
                Return               
            Endif            
            cAvaliador := SRA->RA_NOME
        Endif
    ELSE
       FWMsgRun(, {|| sleep(3000)},"Informativo","Colaborador n�o encontrado. Por favor, verifique.")
       Return
    Endif

    oExcelXML:AddExpression("#SP", cSP)                             //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#AM", CMA)                             //Adiciona express�o que ser� substitu�da

    oExcelXML:AddExpression("#NOMAVAL",    Z49->Z49_NOME)     //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#CARGO",       cCargo)            //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#MATRICULA",   Z49->Z49_MAT)      //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#AREA",        cArea)             //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#DATAADM",     cAdmissao)         //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#AVALIADOR",   cAvaliador)        //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#CCUSTO",      cCCusto)            //Adiciona express�o que ser� substitu�da
    cCoringa := ""
    cConteud := ""
    For nX := 1 to 11
        if nX <= 10
          _Pergunta := "Z49->Z49_C"+STRZERO(nX,2)
            For nY := 1 to 5
                cCoringa := "#P"+cValToChar(nX)+cValToChar(nY)
                cConteud := if(&(_Pergunta)==cValToChar(nY), "X","")
                oExcelXML:AddExpression(cCoringa, cConteud )            //Adiciona express�o que ser� substitu�da
                aResulta[nY] += 1
            Next
        else
          _Pergunta := "Z49->Z49_C"+STRZERO(nX,2)
            For nY := 1 to 5
                cCoringa := "#PZ"+cValToChar(nY)
                cConteud := if(&(_Pergunta)==cValToChar(nY), "X","")
                oExcelXML:AddExpression(cCoringa, cConteud )            //Adiciona express�o que ser� substitu�da
                if !Empty(cConteud)
                   aResulta[nY] += 1
                endif
            Next
        endif
    Next
    nPorc := (aResulta[1]+aResulta[2]+aResulta[3]+aResulta[4]+aResulta[5]) / 55
    oExcelXML:AddExpression("#PORC",    nPorc )  
    oExcelXML:AddExpression("#A1",      FwNoAccent(Z49->Z49_PON01) )            //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#A2",      "")                                     //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#B1",      FwNoAccent(Z49->Z49_PON02) )            //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#B2",      "")                                     //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#C1",      Z49->Z49_ORIENT )           //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#C2",      "")                                     //Adiciona express�o que ser� substitu�da
    cAno := alltrim(Str(Year(dDATABASE)))
    oExcelXML:AddExpression("#EFETIVAR",      IiF(Z49->Z49_DECISA = "1","X","") )                        //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#DEMITIDO",      IiF(Z49->Z49_DECISA = "2","X","") )                        //Adiciona express�o que ser� substitu�da
    oExcelXML:AddExpression("#Ano",           cAno    )                                       //Adiciona express�o que ser� substitu�da
    
    oExcelXML:MountFile()                                              // Monta o arquivo
    oExcelXML:ViewSO()                                                 // Abre o .xml conforme configura��o do Sistema Operacional,
                                                                       // ou seja, se tiver Linux + LibreOffice ele ir� abrir
    //oExcelXML:View()                                                 // Utilizar apenas se n�o for utilizado o m�todo ViewSO
                                                                       // pois dessa forma � for�ado a abrir pelo Excel
    oExcelXml:Destroy(.F.)                                             // Destr�i os atributos do objeto
    oExcelXml:ShowMessage("Exporta��o realizado com sucesso",.T.)      // Testa demonstra��o de mensagem em branco

    RestArea( aAreaZ49 )

Return