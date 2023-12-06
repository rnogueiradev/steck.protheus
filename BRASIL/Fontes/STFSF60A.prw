#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

#Define STR_PULA		Chr(13)+Chr(10)

//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
/*
Static aIDEnt	 	:= {}							// IDENT da tabela SPED000 para NFC-e e NF-e
Static aMVTSS	 	:= Nil
Static oLjNFCe	 	:= Nil
Static aICMSST	 	:= {}
Static aNFCeW02  	:= {}
Static aNFCeW17  	:= {}
Static aTotNaoFis	:= {0,0,0}						// [1]Reserva [2]Garantia Estendida [3]Serviço
Static lEndFis   	:= GetNewPar("MV_SPEDEND",.F.) 	// Se estiver como F refere-se ao endereço de Cobrança se estiver T  ao  endereço de Entrega.
Static lRetrNFCe 	:= .F.
Static oXML 	 	:= NIL 							// Utilizada para capturar dados da nfce
Static aMVTSS2	 	:= {}
Static aItensNFCe	:= Nil
Static lShowMsg		:= .T.							// Validação para exibir a mensagem de validação da versão da NFC-e somente a primeira vez que acessar o sistema
Static aUrls		:= {"", {}}						// Array que contém o Ambiente da NFC-e e as Urls para geração do XML | { Ambiente NFC-e , Array com URLs }
Static cMsgConting	:= ""
*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION


#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"
//---------------------------------------------------------------------------------------------------------//
//Alteração - Flávia Rocha - Sigamat Consultoria
//FR - 09/08/2022 - Comentado e colocado logo mais abaixo como Private, no R.33 não funciona mais Static
//Ticket #20220808015306 - Romaneios e notas sem imprimir
//Static aFieldTMP := {"PD1_CODROM", "PD1_PLACA", "PD1_DTEMIS", "PD1_MOTORI", "QTDNOTAS","PD1_PBRUTO","PD1_QTDVOL"} //FR - 09/08/2022
//---------------------------------------------------------------------------------------------------------//

//--------------------------------------------------------------
/*/{Protheus.doc} Function STFSF60B
Description                                                     
Interface para ser informado as impressões a serem realizadas
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br                                             
@since 26/08/2019                                                   
/*/                                                             
//--------------------------------------------------------------
User Function STFSF60B(pRoma, plFiltra)
    Local oBotao
    Local lRet     := .T.
    Local bMark    := {}
    Local aCabec   := {}
    Local aTam     := {}
    Local bOk      := {}
    Local bCancel  := {}
    Local aButtons := {}
    Local oFont1   := TFont():New("MS Sans Serif",,030,,.T.,,,,,.F.,.F.)
    Local nColuna  := 0
    Local aFiltro  := {}
    Local aConfig  := {}

    //Local aCoordenadas := MsAdvSize(.T.) 
    //Static oDialog
    Private oDialog     //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    
    Private aVetor   := {}
    Private oOk	     := LoadBitmap(GetResources(), "CHECKED")               
    Private oNo	     := LoadBitmap(GetResources(), "UNCHECKED")    
    Private oPnBotoes
    Private oPnTitulo
    Private oPnCentral     
    Private aFILBRW := {'SF2' ,''}    
    Private	_NotaFer015 := ""
    Private	_SeriFer015 := ""
    Private	oBrDoc

//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
Private aIDEnt	 	:= {}							// IDENT da tabela SPED000 para NFC-e e NF-e
Private aMVTSS	 	:= Nil
Private oLjNFCe	 	:= Nil
Private aICMSST	 	:= {}
Private aNFCeW02  	:= {}
Private aNFCeW17  	:= {}
Private aTotNaoFis	:= {0,0,0}						// [1]Reserva [2]Garantia Estendida [3]Serviço
Private lEndFis   	:= GetNewPar("MV_SPEDEND",.F.) 	// Se estiver como F refere-se ao endereço de Cobrança se estiver T  ao  endereço de Entrega.
Private lRetrNFCe 	:= .F.
Private oXML 	 	:= NIL 							// Utilizada para capturar dados da nfce
Private aMVTSS2	 	:= {}
Private aItensNFCe	:= Nil
Private lShowMsg		:= .T.							// Validação para exibir a mensagem de validação da versão da NFC-e somente a primeira vez que acessar o sistema
Private aUrls		:= {"", {}}						// Array que contém o Ambiente da NFC-e e as Urls para geração do XML | { Ambiente NFC-e , Array com URLs }
Private cMsgConting	:= ""

Private aFieldTMP := {"PD1_CODROM", "PD1_PLACA", "PD1_DTEMIS", "PD1_MOTORI", "QTDNOTAS","PD1_PBRUTO","PD1_QTDVOL"}
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION

    cFilAnt := Right(cNumEmp,2)    // Adicionado devido a problema de não estar pegando corretamente a filial - Valdemir Rabelo 29/08/2019

    // Valdemir Rabelo 24/01/2020
    if Empty(pRoma)
       aFiltro := U_getParBox() //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION

        If !ParamBox(aFiltro,"Informe o Período",@aConfig, {|| .T.},,.F.,50,15)
            Return .T.
        Endif
    Endif

    // Carrega Registros
    aVetor := U_MntDoc(pRoma, plFiltra,,aConfig)    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION

	If empty(aVetor)
		aAdd(aVetor, {.F., 0,.F.,0,"","","","","","",0,0} )
		lRet := .F.
    Endif
        
	// Monta tela de entrada.
    DEFINE MSDIALOG oDialog TITLE "Gerenciador Impressão" FROM 0, 0 TO 500, 950 OF oMainWnd  PIXEL STYLE DS_MODALFRAME
    oDialog:lEscClose := .F.

	// Browser 
	aCabec := {"Danfe", "Nº Copias", "Romaneio", "Nº Copias", "Nº Romaneio","Veículo", "Emissão", "Motorista","Qtd Notas", "Peso","Volumes"}
    aTam   := {45, 35, 45, 35, 30, 70, 60, 90, 30, 30,30}
    
    U_MntComp(oDialog)  //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    @ 002,010 SAY oSay2 PROMPT "IMPRESSÃO EM LOTE" SIZE 150, 012 OF oPnTitulo FONT oFont1 COLORS 15120473, 16777215 PIXEL
	oBrDoc       := TWBrowse():New(0, 0, 0, 0,, aCabec, aTam, oPnCentral)
    oBrDoc:Align := CONTROL_ALIGN_ALLCLIENT
    
	//bMark := {|lMark, nLinha|  aVetor[nLinha, nColuna] := If(!aVetor[nLinha, nColuna], oOk, oNo)  }
    
    If lRet
        oBrDoc:blDblClick   := {|| if( oBrDoc:ColPos==1, aVetor[oBrDoc:nAt, 1] := !aVetor[oBrDoc:nAt, 1],;
                                   if( oBrDoc:ColPos==3, aVetor[oBrDoc:nAt, 3] := !aVetor[oBrDoc:nAt, 3], nil )) ,;
                                    oBrDoc:Refresh()}        
        oBrDoc:bHeaderClick := { |o,nCol| nColuna := nCol, if(nCol==1 .or. nCol==3, aEval(aVetor, {|X| X[nColuna] := If(!X[nColuna], .T., .F.)  }) ,nil), oBrDoc:Refresh() }
	Endif

    U_AtuBDGrid()   //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    oBrDoc:nAt  := 1

    // Botões.
    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    @ 001, 005 BUTTON oBotaoED  PROMPT "Editar"    SIZE 037, 012 OF oPnBotoes ACTION ( U_DLCEBALT(aVetor,oBrDoc) ) PIXEL
    @ 001, 042 BUTTON oBotaoRL  PROMPT "Relatorio" SIZE 037, 012 OF oPnBotoes ACTION ( U_RSTFAT31() ) PIXEL     // STFSR60B()
    @ 001, 079 BUTTON oBotaoRL  PROMPT "Filtro"    SIZE 037, 012 OF oPnBotoes ACTION ( U_FiltroRom(), U_AtuBDGrid() ) PIXEL     // STFSR60B()
    @ 001, 127 BUTTON oBotaoOK  PROMPT "Confirmar" SIZE 037, 012 OF oPnBotoes ACTION ( U_FSF60AOK(aVetor), oDialog:End() ) PIXEL
    @ 001, 164 BUTTON oBotaoCan PROMPT "Fechar"    SIZE 037, 012 OF oPnBotoes ACTION oDialog:End() PIXEL
    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    
    oBotaoOk:SetCSS(CSSBOTAO)
    oBotaoOK:cToolTip := "Confirmar para iniciar a ação escolhida"
    oBotaoCan:SetCSS(CSSBOTAO)
    oBotaoCan:cToolTip := "Fecha a tela voltando a tela anterior"
    oBotaoED:cToolTip := "Editar numero de cópias"
    oBotaoRL:cToolTip := "Relatório de Romaneio"

    ACTIVATE MSDIALOG oDialog CENTERED // 
    
Return NIL


/*/{Protheus.doc}  Function DLCEBALT
    (long_description)
    Evento para editar celula
    @author user
    Valdemir Rabelo - SigaMat
    @since 26/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function DLCEBALT(aWBrowse1,oWBrowse1)
User Function DLCEBALT(aWBrowse1,oWBrowse1)
    
    IF (oWBrowse1:COLPOS == 2) .OR. (oWBrowse1:COLPOS == 4)
	    lEditCell( @aWBrowse1, oWBrowse1, "@E 999", oWBrowse1:COLPOS )
    ELSE
       FWMsgRun(,{|| sleep(3000)},"Atenção","Coluna selecionada não editavel...") 
    ENDIF 
    oWBrowse1:Refresh()
Return


/*/{Protheus.doc} MntDoc()
    (long_description)
    Carrega registros para que possa ser selecionado e impresso conforme seleção
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 26/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function MntDoc(pCODROM, plFiltra, plDanfe, paPer)
User Function MntDoc(pCODROM, plFiltra, plDanfe, paPer)
    Local aRET    := {}
    Local cQry    := ""
    Local nX      := 0
    Local nXOPC   := 0
    Local aTMP    := {}   
    Local aArea   := GetArea()
    Local aCabec  := {"PD1_STATUS","PD1_CODROM","PD1_DTEMIS","PD1_QTDVOL","PD1_PLIQ","PD1_PBRUTO","PD1_PLACA","PD1_MOTORI","PD1_AJUDA1","PD2_NFS","PD2_SERIES","PD2_CLIENT","PD2_LOJCLI","PD2_REGIAO"}  // 
    DEFAULT pCODROM := ""    
    DEFAULT plFiltra:= .F.
    DEFAULT plDanfe := .F.
    DEFAULT paPer   := {}

    cQry += "SELECT              " + CRLF
    IF plDanfe
       cQry += "    PD1.PD1_STATUS, " + CRLF
    Endif
    cQry += "    PD1.PD1_CODROM, " + CRLF
    cQry += "    PD1.PD1_DTEMIS, " + CRLF
    if plDanfe
        cQry += "    PD1.PD1_QTDVOL, " + CRLF
        cQry += "    PD1.PD1_PLIQ,   " + CRLF
        cQry += "    PD1.PD1_PBRUTO, " + CRLF
    else
        cQry += "    SUM(PD1.PD1_QTDVOL) PD1_QTDVOL, " + CRLF
        cQry += "    SUM(PD1.PD1_PLIQ) PD1_PLIQ,     " + CRLF
        cQry += "    SUM(PD1.PD1_PBRUTO) PD1_PBRUTO, " + CRLF
        cQry += "    COUNT(PD2.PD2_NFS) QTDNOTAS, " + CRLF
    endif
    cQry += "    PD1.PD1_PLACA,  " + CRLF
    cQry += "    PD1.PD1_MOTORI, " + CRLF
    cQry += "    PD1.PD1_AJUDA1 " + CRLF

    if plDanfe
      cQry += "    ,PD2.PD2_NFS,   " + CRLF
      cQry += "    PD2.PD2_SERIES, " + CRLF
      cQry += "    PD2.PD2_CLIENT, " + CRLF
      cQry += "    PD2.PD2_LOJCLI, " + CRLF
      cQry += "    PD2.PD2_REGIAO  " + CRLF
    Endif
    cQry += "FROM " + RETSQLNAME('PD1') + " PD1      " + CRLF
    cQry += "INNER JOIN " + RETSQLNAME('PD2') + " PD2" + CRLF
    cQry += "ON PD2.PD2_FILIAL=PD1.PD1_FILIAL AND PD2.PD2_CODROM=PD1.PD1_CODROM AND PD2.D_E_L_E_T_ = ' ' " + CRLF
    cQry += "WHERE PD1.D_E_L_E_T_ = ' ' " + CRLF
    
    nXOPC := 2
    if Empty(pCODROM)
        If (ValType(paPer[3])=="N")
            nXOPC := paPer[3]
        else
            if paPer[3]=="Nao"
                nXOPC := 2
            Endif
        Endif
    Endif

    if (nXOPC == 2)       // Valdemir Rabelo 06/02/2020
    //    cQry += "AND PD1.PD1_STATUS <> '3'  " + CRLF   Removido conforme solicitação feita por Jefferson 27/10/2021
    Endif
    
    cQry += "AND PD1.PD1_FILIAL = '"+XFILIAL('PD1')+"'  " + CRLF
    if !Empty(pCODROM)
        cQry += "AND PD1.PD1_CODROM = '" +pCODROM+ "'  " + CRLF
    endif 
    if Len(paPer) > 0   // VALDEMIR RABELO 24/01/2020
        cQry += "AND PD1.PD1_DTEMIS BETWEEN '"+DTOS(paPer[1])+"' AND '"+DTOS(paPer[2])+"' " + CRLF
    Endif
    if !plDanfe
        cQry += "GROUP BY PD1_CODROM,PD1_DTEMIS,PD1_PLACA,PD1_MOTORI,PD1_AJUDA1 " + CRLF   // PD1_STATUS,
        cQry += "ORDER BY 2                " + CRLF
    else
      cQry += "ORDER BY PD2_ORDROT                " + CRLF
      cQry += "    ,PD2.PD2_NFS, PD2.PD2_SERIES  " + CRLF
    endif

    IF SELECT("TPD") > 0
       TPD->( dbCloseArea() )
    ENDIF 

    TcQuery cQry new alias "TPD"
    TCSETFIELD( "TPD", "PD1_DTEMIS", "D", 8)

    While !Eof()
       if (Empty(pCODROM) .AND. !plFiltra) .OR. (!Empty(pCODROM) .AND. plFiltra)
            aAdd(aTMP, .F. )
            aAdd(aTMP, 1 )
            aAdd(aTMP, .F. )
            aAdd(aTMP, 1 )
            For nX := 1 to Len(aFieldTMP)
                aAdd(aTMP, TPD->&(aFieldTMP[nX]) )
            Next
            aAdd(aRET, aClone(aTMP))
       else 
            For nX := 1 to Len(aCabec)
                aAdd(aTMP, TPD->&(aCabec[nX]) )
            Next
            aAdd(aRET, aClone(aTMP))
       endif
        aTMP := {}
        dbSkip()
    ENDDO

    IF SELECT("TPD") > 0
       TPD->( dbCloseArea() )
    ENDIF 

    if (!Empty(pCODROM)) .AND. (!plFiltra)
        aRET := {aCabec, aClone(aRET)}
    endif 

    RestArea( aArea )

Return aRET



/*/{Protheus.doc} FSF60AOK
    (long_description)
    Confirmação para impressão Danfe / Romaneio
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 26/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//static Function FSF60AOK(aVetor)
User Function FSF60AOK(aVetor)
    Local nX      := 0
    Local nY      := 0
    Local lTrue   := .F.
    Local aAreaOK := GetArea()
    Local cPasta  := "C:\relatorio_romaneio\"
    Local lDireto := .F.
    Local nPrint  := 0
    Local cMsg    := "Qual opção desejada? " + CRLF+CRLF+ "PDF - Gera arquivo direto na pasta" + CRLF + "IMPRESSORA - Envia documentos para impressora"

    if !ExistDir(cPasta)
       MAKEDIR( cPasta )
    endif
 
    nPrint := Aviso("Selecione a ação", cMsg, {"PDF", "IMPRESSORA", "Cancelar"}, 1, "")

    if nPrint = 3
       Return
    else
       lDireto := (nPrint==2)
    endif

    For nX := 1 to Len(aVetor)
        // Imprime Romaneio
        if aVetor[nX][3]
            MAKEDIR( cPasta+aVetor[nX][5] )
            For nY := 1 to aVetor[nX][4]
                U_ImpRoma(aVetor[nX], lDireto)  //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
                lTrue   := .T.
            Next
        endif    
        // Imprime a Nota         
        if aVetor[nX][1]
            MAKEDIR( cPasta+aVetor[nX][5] )
            //For nY := 1 to aVetor[nX][2]
                U_ImpDanfe(aVetor[nX], lDireto) //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
                lTrue   := .T.
            //Next            
        endif 
    Next 

    if !lTrue
        FWMsgRun(,{|| sleep(3000)},"Informação","Não foi selecionado nenhum registro para ser impresso.")
    endif 
    
    if !lDireto
       ShellExecute("open", cPasta, "", "", 1)
    else 
       if lTrue
          LjMsgRun("Impressão finalizada...",,{|| Sleep(3000)})
       endif 
    Endif 

Return .T.


/*/{Protheus.doc} ImpDanfe
    (long_description)
Impressão da Danfe conforme nota informada no item do romaneio
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 27/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function ImpDanfe(paVetor, plDireto)
User Function ImpDanfe(paVetor, plDireto)
    Local aAreaImp := GetArea()
    Local aPrinc   := U_MntDoc(paVetor[5],.f.,.T.)  //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
    Local aCab     := aPrinc[1]
    Local aDetalhe := aPrinc[2]
    Local nX       := 0
    Local nY       := 0
    Local nPosNF   := aScan(aCab, {|X| alltrim(X)=="PD2_NFS"})
    Local nPosSr   := aScan(aCab, {|X| alltrim(X)=="PD2_SERIES"}) 
    Local nPosCli  := aScan(aCab, {|X| alltrim(X)=="PD2_CLIENT"})
    Local nPosLJ   := aScan(aCab, {|X| alltrim(X)=="PD2_LOJCLI"})
    Local cDOC     := ""
    Local cSerie   := ""    
    Local cClient  := ""
    Local cLojaCl  := ""
    Local cAntNota := ""
    Local cPasta   := "\relatorio_romaneio\"    // "C:\relatorio_romaneio\"+paVetor[5]+"\"
    Local cArquivo := ""
    Local lRET     := .F.
    Private cCodRom:= alltrim(paVetor[5])

    if Empty(cCodRom)    // 11/10/2022 - Valdemir Rabelo
      cCodRom := "000000"
    endif 

    dbSelectArea("SF2")
    dbSetOrder(1)

    aFilBrw	    :=	{'SF2',"F2_FILIAL=='"+xFilial("SF2")+"'"}
    For nX := 1 To Len(aDetalhe)
        cDOC     := aDetalhe[nX][nPosNF]
        cSerie   := aDetalhe[nX][nPosSr]
        cClient  := aDetalhe[nX][nPosCli]
        cLojaCl  := aDetalhe[nX][nPosLJ]
        if (cAntNota != cDOC)    // Só imprime a danfe se ainda não foi impressa
            if dbSeek(xFilial("SF2")+cDOC+cSerie+cClient+cLojaCl)
                _NotaFer015 := SF2->F2_DOC
                _SeriFer015 := SF2->F2_SERIE			
                For nY := 1 to 	paVetor[2]	
                    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION				
                    MsgRun("Aguarde... Gerando Danfe... Copia: "+cValToChar(nY),,{ || cArquivo := U_STDANFENFe(_NotaFer015, _SeriFer015, cPasta, plDireto) }) 	
                    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
                    
                    cAntNota := cDOC
                    // Apago o arquivo XML 
                    If cPasta <> Nil .and. cArquivo <> Nil               
                        if file(cPasta+cArquivo+".xml")
                            FErase(cPasta+cArquivo+".xml")
                            lRET := .T.
                        endif
                    Endif 
                Next
            Endif
        Endif
    Next 

    RestArea( aAreaImp )
Return lRET


/*/{Protheus.doc} ImpRoma
    (long_description)
    Faz impressão do romaneio
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 27/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function ImpRoma(paVetor, plDireto)
User Function ImpRoma(paVetor, plDireto)
    
    MsgRun("Aguarde... Imprimindo romaneio... ",,{ || u_STFSR60C(paVetor[5], paVetor[5], plDireto) })

Return 


/*/{Protheus.doc} MntComp
    (long_description)ok
    Complemento da tela
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 26/08/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function MntComp(poDlg)
User Function MntComp(poDlg)
    oFWLMain := FWLayer():New()
    oFWLMain:Init( poDlg, .F. )
    oFWLMain:AddLine("LineSup",017,.T.)
    oFWLMain:AddLine("LineInf",084,.T.)    
    oFWLMain:AddCollumn( "ColSP01", 050, .T.,"LineSup" )
    oFWLMain:AddCollumn( "ColSP02", 048, .T.,"LineSup" )
    oFWLMain:AddWindow( "ColSP01", "WinSP01", , 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
    oFWLMain:AddWindow( "ColSP02", "WinSP02", , 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
    oPnTitulo  := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )
    oPnBotoes  := oFWLMain:GetWinPanel('ColSP02','WinSP02',"LineSup" )
    oFWLMain:AddCollumn( "Col01", 098, .T.,"LineInf" )
    oFWLMain:AddWindow( "Col01", "Win01", "Selecione os Registros",100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
    oPnCentral := oFWLMain:GetWinPanel('Col01','Win01',"LineInf" )
Return




/*/{Protheus.doc} STDANFENFe
    (long_description)
    Gera Danfe da Nota informada
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 09/09/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function STDANFENFe(cNota, cSerie, cPasta, plDireto)
User Function STDANFENFe(cNota, cSerie, cPasta, plDireto)
    Local aArea     := GetArea()
    Local cIdent    := ""
    Local cArquivo  := ""
    Local oDanfe    := Nil
    Local lEnd      := .F.
	Local lAdjustToLegacy := .F.
	Local lDisableSetup   := .T.

    Local nTamNota  := TamSX3('F2_DOC')[1]
    Local nTamSerie := TamSX3('F2_SERIE')[1]
    
    //-------------------------------------------------------------------------------------------------------------//
    //FR - 23/08/2022 - Flávia Rocha - Sigamat Consultoria - Comentado porque a impressora precisa seguir a regra: 
    // "\\nome servidor\nome compartilhamento impressora"
    // este nome da impressora ficará dentro do parâmetro FS_ROMEXPE
    //-------------------------------------------------------------------------------------------------------------//
    Local cImpress  := "" //Upper(Alltrim(iif(FWIsInCall("U_STTNTCOL") .or. FWIsInCall("u_STIMPROM"),GetMV("FS_ROMEXPE",.F.,"F02 - Expedicao"), GetMV("FS_XIMPRES",.F.,"DIRECAO") )))   // Valdemir Rabelo 08/11/2021
    //FR - 23/08/2022

    Local lServer   := FWIsInCall("u_STIMPROM")  .or. FWIsInCall("u_STFATROM") .or. FWIsInCall("u_STMRKPV")    // "Lexmark X656de - VENDAS on 10.152.10.11 (redirected 6)"    //
    Local cRET      := ""
   	Local aImpres   := GetImpWindows(lServer)    // Busco as impressoras .T. = Server .F. = Local -  Valdemir 16/11/2021
    Local DIRECAO   := IF(plDireto, IMP_SPOOL, IMP_PDF)
    Local cCamPDF   := if(FWIsInCall("u_STMRKPV"), cPasta, '\arquivos\relatorio_romaneio\')
    Private PixelX
    Private PixelY
    Private nConsNeg
    Private nConsTex
    Private oRetNF
    Private nColAux
    Default cNota   := ""
    Default cSerie  := ""
    Default cPasta  := GetTempPath()
    Default plDireto := .F.

    //cImpress:= GetNewPar("FS_ROMEXPE" , "\\sw2012h01\F02-Transportes") //deu certo, essa é a regra, \\nome servidor\nome compartilhamento da impressora
    if !FWIsInCall("u_STMRKPV")   // Valdemir Rabelo 04/09/2022 - Projeto Simulação PV
        // Valdemir 16/11/2021 - Ticket: 20211116024527
	    //QDO A IMPRESSÃO VEIO DA ROTINA DO COLETOR:
	    If FWIsInCall(Alltrim(Upper("U_STIMPROM")))
			cImpress := GetNewPar("FS_ROMEXP2","\\sw2012h01\F02-Bancada")	//FR - 31/08/2022 - FIXAR APENAS UMA IMPRESSORA
	
		//QDO A IMPRESSÃO DO ROMANEIO É ORIGEM APENAS PROTHEUS (STFATROM)
		Elseif FWIsInCall(Alltrim(Upper("U_STFATROM")))
			cImpress := GetNewPar("FS_ROMEXPE","\\sw2012h01\F02-Transportes")
		Endif 		
	EndIf

    If plDireto       
        //cImpress:= GetNewPar("FS_ROMEXPE" , "\\sw2012h01\F02-Transportes")
        lServer := .F.
        //cImpress:= "EPSONDDEC5B (L3150 Series)" //FR teste    - deu certo impressora local RETIRAR DEPOIS
        //cImpress := "Lexmark International Lexmark X656de"    - impressora instalada na maquina do Euler
        //cImpress := "F02-Transportes"                         - só o nome de compartilhamento não funciona tem q vir antes o nome do servidor
        
        //FR - 01/09/2022
        if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0         // Procuro no servidor
            aImpres := GetImpWindows(.F.)												// Verifico Impressora Local
            if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0
                MsgInfo("Impressora: "+cImpress+" não encontrada"+CRLF+;
                        "Verifique se existe impressora com nome: "+cImpress+", ou se está desligada.")
                Return nil 
            endif 
            lServer := .F.
        endif
        //FR - 01/09/2022
    Endif 
    

    // Valdemir 16/11/2021 - Ticket: 20211116024527
    /*
    if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0         // Procuro no servidor
        aImpres := GetImpWindows(.F.)												// Verifico Impressora Local
        if aScan(aImpres, {|X| alltrim(upper(X))==alltrim(upper(cImpress))})==0
            MsgInfo("Impressora: "+cImpress+" não encontrada"+CRLF+;
                    "Verifique se existe impressora com nome: "+cImpress+", ou se está desligada.")
            Return nil 
        endif 
        lServer := .F.
    endif
    */ 

    //Se existir nota
    If ! Empty(cNota)
        //Pega o IDENT da empresa
        cIdent := RetIdEnti()
         
        //Se o último caracter da pasta não for barra, será barra para integridade
        If SubStr(cPasta, Len(cPasta), 1) != "\"
            cPasta += "\"
        EndIf

        If IsInCallStack("U_STSIMPV")
            cCodRom := ""
        EndIf
         
        //Gera o XML da Nota
        cArquivo := cCodRom + "_" + cNota + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
        U_STSpedXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
         
        //Define as perguntas da DANFE
        Pergunte("NFSIGW",.F.)
        MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
        MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
        MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
        MV_PAR04 := 2                          //NF de Saida
        MV_PAR05 := 1                          //Frente e Verso = Sim
        MV_PAR06 := 2                          //DANFE simplificado = Nao
         
        //FR TESTE - 09/08/2022
        If plDireto  //direto na impressora
            //lDisableSetup := .F.      //se estiver .F. , aparece a janela de setup de impressora
                                        //se estiver .T. , a janela de setup fica desabilitada
                                        //testar assim e depois tirar para ver de que jeito funciona
            cPath:= "C:\relatorio_romaneio\"
            if !ExistDir(cPath)
                MAKEDIR( cPath )
            endif

            if !ExistDir(cPasta)
                MAKEDIR( cPasta )
            endif

            //teste totvs
            oDanfe := FWMSPrinter():New(cArquivo+".pdf"    ,IMP_SPOOL,.F.             ,cPath                         ,.T.            ,,,cImpress,.F.    ,.F.,   ,.F.)
            //teste totvs

        Else 
            cPath := '\arquivos\relatorio_romaneio\'
            //Cria a Danfe 
            oDanfe := FWMSPrinter():New(cArquivo+".pdf"   , DIRECAO , lAdjustToLegacy, '\arquivos\relatorio_romaneio\', lDisableSetup,,,cImpress,lServer,   ,   ,.F.)
        Endif 
        //FR TESTE - 09/08/2022
        
        //Propriedades da DANFE
        oDanfe:SetResolution(78)
        oDanfe:SetPortrait()
        oDanfe:SetPaperSize(DMPAPER_A4)
        oDanfe:SetMargin(60, 60, 60, 60)
         
        //Força a impressão em PDF / SPOOL
        If !FWIsInCall("u_STMRKPV")                 // Valdemir Rabelo 04/09/2022 - Simulador Pedido
            oDanfe:nDevice  := DIRECAO     //6   
            oDanfe:SetParm( cImpress)       //FR - TESTE TOTVS
            oDanfe:cPathPDF := cPath //'\arquivos'+cPasta     
        
            //FR - 09/08/2022 - Flávia Rocha - Sigamat Consultoria - ticket #20220808015306 
            If plDireto
                oDanfe:cPrinter := cImpress       
            Else 
                oDanfe:lServer  := lServer
            Endif
        else 
            oDanfe:cPathPDF := cCamPDF  
            oDanfe:lServer  := lServer
        Endif 

        //oDanfe:Setup()  //FR - TESTE TOTVS MOSTRA JANELA SETUP IMPRESSÃO
        //FR - 09/08/2022 - Flávia Rocha - Sigamat Consultoria - ticket #20220808015306 
        
        oDanfe:lViewPDF := .F.
       
        //Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
        PixelX    := oDanfe:nLogPixelX()
        PixelY    := oDanfe:nLogPixelY()
        nConsNeg  := 0.4
        nConsTex  := 0.5
        oRetNF    := Nil
        nColAux   := 0
        cArqEV    := ""

        //Chamando a impressão da danfe no RDMAKE        
        //RptStatus({|lEnd| DanfeProc(@oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
        //FR - 09/08/2022 - Substituí por esta função abaixo, pois a Danfeproc acima, não estava entrando no danfeii
        //a função abaixo U_FDanfePro está dentro do fonte DANFEii.prw
        RptStatus({|lEnd| cArqEV := U_FDanfePro(@oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
        oDanfe:Print()

        // Valdemir Rabelo 24/11/2021 - Ticket: 20210617010297
        if file('\arquivos\relatorio_romaneio\'+cArquivo+".pdf")
            If !FWIsInCall("u_STMRKPV")             // Valdemir Rabelo 04/09/2022 - Simulador Pedido
                __CopyFile('\arquivos\relatorio_romaneio\'+cArquivo+".pdf", "C:\relatorio_romaneio\"+cCodRom+"\"+cArquivo+".pdf")
            endif 
        endif         
    EndIf
     
    RestArea(aArea)

    cRET := cArquivo

Return cRET

/*/{Protheus.doc} STSpedXML
    (long_description)
    que gera o arquivo xml da notaormada
    @author user
    Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
    @since 09/09/2019
/*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function STSpedXML(cDocumento, cSerie, cArqXML, lMostra)
User Function STSpedXML(cDocumento, cSerie, cArqXML, lMostra)
    Local aArea        := GetArea()
    Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)  
    Local oWebServ
    
    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC
    Local cIdEnt       := "" //_StaticCall(SPEDNFE, GetIdEnt)  
    //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC

    Local cTextoXML    := ""
    Default cDocumento := ""
    Default cSerie     := ""
    Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
    Default lMostra    := .F.
     
    //Pega o IDENT da empresa
    cIdent := RetIdEnti()
    
    //Se tiver documento
    If !Empty(cDocumento)
        cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
        cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
         
        //Instancia a conexão com o WebService do TSS    
        oWebServ:= WSNFeSBRA():New()
        oWebServ:cUSERTOKEN        := "TOTVS"
        oWebServ:cID_ENT           := cIdEnt
        oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
        oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
        aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
        aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
        oWebServ:nDIASPARAEXCLUSAO := 0
        oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"   
         
        //Se tiver notas
        If oWebServ:RetornaNotas()
         
            //Se tiver dados
            If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
             
                //Se tiver sido cancelada
                If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
                     
                //Senão, pega o xml normal
                Else
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
                EndIf
                 
                //Gera o arquivo
                MemoWrite(cArqXML, cTextoXML)
                 
                //Se for para mostrar, será mostrado um aviso com o conteúdo
                If lMostra
                    Aviso("zSpedXML", cTextoXML, {"Ok"}, 3)
                EndIf
                 
            //Caso não encontre as notas, mostra mensagem
            Else
                ConOut("zSpedXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...")
                 
                If lMostra
                    Aviso("zSpedXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
                EndIf
            EndIf
         
        //Senão, houve erros na classe
        Else
            ConOut("zSpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
             
            If lMostra
                Aviso("zSpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
            EndIf
        EndIf
    EndIf
    RestArea(aArea)
Return


//-------------------------------------------------- Relatorio Endereço Romaneio ------------------------------------------

*************************************************************************************
*	Autor		:	Valdemir José
*	Descrição	:	Relatório de Endereço Romaneio ( CEP )
*	Modulo		:	Faturamento
*	Data		:	11/09/2019
*************************************************************************************
/*
Static Function STFSR60B()

Local aArea   := GetArea()
Local oReport
Local lEmail  := .F.
Local lResp   := .T.
Local cPara   := ""
Private cPerg := "STFSR60B  "

U_StPutSx1(cPerg, "01","Romaneio de" 		 ,"mv_par01","mv_ch1","C",10,0,"G")
U_StPutSx1(cPerg, "02","Romaneio ate"		 ,"mv_par02","mv_ch2","C",10,0,"G")
U_StPutSx1(cPerg, "03","Quebra por Romaneio","mv_par03","mv_ch3","C",01,0,"C","","","","S=Sim","N=Nao")
lResp := Pergunte(cPerg, .T.)

if !lREsp
    Return 
Endif

//Cria as definições do relatório
oReport := fReportDef()

//Será enviado por e-Mail?
If lEmail
    oReport:nRemoteType := NO_REMOTE
    oReport:cEmail := cPara
    oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
    oReport:SetPreview(.F.)
    oReport:Print(.F., "", .T.)
//Senão, mostra a tela
Else
    oReport:PrintDialog()
EndIf

RestArea(aArea)
Return
*/

/*-------------------------------------------------------------------------------*
| Func:  fReportDef                                                             |
| Desc:  Função que monta a definição do relatório                              |
*-------------------------------------------------------------------------------*/
/*
Static Function fReportDef()
Local oReport
Local oSectDad := Nil
Local oBreak   := Nil
Local aFields  := {}

//Criação do componente de impressão
oReport := TReport():New(	"STFSR60B",;		//Nome do Relatório
                            "Relatório de Endereço Romaneio ( CEP )",;		//Título
                            cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
                            {|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
                            )		//Descrição
oReport:SetTotalInLine(.F.)
oReport:lParamPage := .t.
oReport:oPage:SetPaperSize(9) //Folha A4
oReport:SetPortrait()

//Criando a seção de dados
oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
                                "Dados",;		//Descrição da seção
                                {"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha

//Colunas do relatório
TRCell():New(oSectDad, "FILIAL",    "QRY_AUX", "Filial",        ,  2, ,,,,,,,,,)

//TRCell():New(oSectDad, "ROMANEIO",  "QRY_AUX", "Romaneio",      /*Picture, 25, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,/*lBold)
//TRCell():New(oSectDad, "NFS",       "QRY_AUX", "Nfs",           /*Picture, 20, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,/*lBold)
//TRCell():New(oSectDad, "ORDSEP",    "QRY_AUX", "Ordsep",        /*Picture, 15, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,/*lBold)
//TRCell():New(oSectDad, "ENDEREC",   "QRY_AUX", "Enderec",       /*Picture,  9, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,/*nClrFore,/*lBold)
//TRCell():New(oSectDad, "CEP",       "QRY_AUX", "CEP",           /*Picture, 15, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,/*nClrFore,/*lBold)
//TRCell():New(oSectDad, "QUANTIDADE","QRY_AUX", "Quantidade",    /*Picture, 15, /*lPixel,/*{|| code-block de impressao },/*cAlign,/*lLineBreak,/*cHeaderAlign ,lCellBreak,nColSpace,lAutoSize,nClrBack,/*nClrFore,/*lBold)
/*
IF VALTYPE(MV_PAR03)=="C"
   MV_PAR03 := 2
ENDIF

//Definindo a quebra
IF MV_PAR03==1
    oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(ROMANEIO) },{|| "SEPARACAO DO RELATORIO" })
    oSectDad:SetHeaderBreak(.T.)
Endif 

Return oReport
*/

/*-------------------------------------------------------------------------------*
| Func:  fRepPrint                                                              |
| Desc:  Função que imprime o relatório                                         |
*-------------------------------------------------------------------------------*/
/*
Static Function fRepPrint(oReport)
Local aArea    := GetArea()
Local cQryAux  := ""
Local oSectDad := Nil
Local nAtual   := 0
Local nTotal   := 0

//Pegando as seções do relatório
oSectDad := oReport:Section(1)

//Montando consulta de dados
cQryAux := MntQry()

TCQuery cQryAux New Alias "QRY_AUX"
Count to nTotal
oReport:SetMeter(nTotal)
//TCSetField("QRY_AUX", "Z5_DTEMISS", "D")

//Enquanto houver dados
oSectDad:Init()
QRY_AUX->(DbGoTop())
While ! QRY_AUX->(Eof())
    //Incrementando a régua
    nAtual++
    oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
    oReport:IncMeter()
    
    //Imprimindo a linha atual
    oSectDad:PrintLine()
    
    QRY_AUX->(DbSkip())
EndDo
oSectDad:Finish()
QRY_AUX->(DbCloseArea())
//oTable:Delete()

RestArea(aArea)
Return


*************************************************************************************
*	Autor		:	Valdemir José
*	Descrição	:	Montagem do Filtro
*	Modulo		:	Faturamento
*	Data		:	11/09/2019
*************************************************************************************
Static Function MntQry()
    Local cRET 	   := ""
    Local nResp    := 0

    cRET := "DROP TABLE STAB01"
    nRESP := TCSQLEXEC( cRET )

    cRET := "CREATE TABLE STAB01 AS "+ CRLF
    cRET += "SELECT * " + CRLF
    cRET += "FROM " + CRLF
    cRET += "  (SELECT FILIAL, " + CRLF
    cRET += "          ROMANEIO, " + CRLF
    cRET += "          NFS, " + CRLF
    cRET += "          ORDSEP, " + CRLF
    cRET += "          ENDEREC, " + CRLF
    cRET += "          SUM(QUANTIDADE) QUANTIDADE " + CRLF
    cRET += "   FROM " + CRLF
    cRET += "     (SELECT DISTINCT PD2_FILIAL FILIAL, " + CRLF
    cRET += "                      PD2_CODROM ROMANEIO, " + CRLF
    cRET += "                      PD2_NFS NFS, " + CRLF
    cRET += "                      C9_ORDSEP ORDSEP, " + CRLF
    cRET += "        (SELECT MAX(Z5_ENDEREC) " + CRLF
    cRET += "         FROM " + RetSqlName('SZ5') + CRLF
    cRET += "         WHERE D_E_L_E_T_=' ' " + CRLF
    cRET += "           AND Z5_FILIAL=C9_FILIAL " + CRLF
    cRET += "           AND C9_ORDSEP=Z5_ORDSEP) ENDEREC, " + CRLF
    cRET += "                      Z5_DTEMISS, " + CRLF
    cRET += "        (SELECT SUBSTR(CB3_DESCRI, 1, 6) " + CRLF
    cRET += "         FROM " + RetSqlName('CB3') + " CB3 " + CRLF
    cRET += "         WHERE CB3.D_E_L_E_T_=' ' " + CRLF
    cRET += "           AND CB6_TIPVOL=CB3_CODEMB " + CRLF
    cRET += "           AND CB6_FILIAL=CB3_FILIAL) TIPOVOL, " + CRLF
    cRET += "        (SELECT COUNT(CB6_TIPVOL) " + CRLF
    cRET += "         FROM " + RetSqlName('CB6') + " CB61 " + CRLF
    cRET += "         WHERE CB6.D_E_L_E_T_=' ' " + CRLF
    cRET += "           AND CB6.CB6_FILIAL=CB61.CB6_FILIAL " + CRLF
    cRET += "           AND CB6.CB6_XORDSE=CB61.CB6_XORDSE " + CRLF
    cRET += "           AND CB6.CB6_PEDIDO=CB61.CB6_PEDIDO " + CRLF
    cRET += "           AND CB6.CB6_TIPVOL=CB61.CB6_TIPVOL) QUANTIDADE " + CRLF
    cRET += "      FROM " + RetSqlName('SC9') + " C9 " + CRLF
    cRET += "      LEFT JOIN " + RetSqlName('PD2') + " PD2 ON PD2_FILIAL=C9_FILIAL " + CRLF
    cRET += "      AND PD2_NFS=C9_NFISCAL " + CRLF
    cRET += "      AND PD2_SERIES=C9_SERIENF " + CRLF
    cRET += "      AND PD2_CLIENT=C9_CLIENTE " + CRLF
    cRET += "      AND PD2_LOJCLI=C9_LOJA " + CRLF
    cRET += "      LEFT JOIN " + RetSqlName('SZ5') + " Z5 ON C9_FILIAL=Z5_FILIAL " + CRLF
    cRET += "      AND C9_ORDSEP=Z5_ORDSEP " + CRLF
    cRET += "      AND Z5.D_E_L_E_T_=' ' " + CRLF
    cRET += "      LEFT JOIN " + RetSqlName('CB6') + " CB6 ON CB6_FILIAL=PD2_FILIAL " + CRLF
    cRET += "      AND CB6_PEDIDO=C9_PEDIDO " + CRLF
    cRET += "      AND CB6_XORDSE=C9_ORDSEP " + CRLF
    cRET += "      WHERE CB6.D_E_L_E_T_=' ' " + CRLF
    cRET += "        AND PD2.D_E_L_E_T_=' ' " + CRLF
    cRET += "        AND C9.D_E_L_E_T_=' ' " + CRLF
    cRET += "        AND PD2_CODROM BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "' " + CRLF
    cRET += "      ORDER BY PD2_FILIAL, " + CRLF
    cRET += "               PD2_CODROM, " + CRLF
    cRET += "               PD2_NFS, " + CRLF
    cRET += "               C9_ORDSEP, " + CRLF
    cRET += "               Z5_DTEMISS DESC) " + CRLF
    cRET += "   GROUP BY FILIAL, " + CRLF
    cRET += "            ROMANEIO, " + CRLF
    cRET += "            NFS, " + CRLF
    cRET += "            ORDSEP, " + CRLF
    cRET += "            ENDEREC) XXX " + CRLF
    cRET += "WHERE FILIAL<>' ' " + CRLF
    cRET += "  AND ENDEREC LIKE '%FROTA%' " + CRLF

    nRESP := TCSQLEXEC( cRET )


    cRET := "SELECT FILIAL, ROMANEIO, ORDSEP, ENDEREC, NFS, CEP, QUANTIDADE  " + CRLF 
    cRET += "FROM ( " + CRLF 
    cRET += "   SELECT DISTINCT FILIAL, ROMANEIO, ORDSEP, ENDEREC, NFS, C5_ZCEPE CEP, QUANTIDADE " + CRLF 
    cRET += "   FROM STAB01 A " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC9') + " SC9 " + CRLF 
    cRET += "   ON SC9.C9_NFISCAL=A.NFS AND SC9.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC5') + " SC5 " + CRLF 
    cRET += "   ON SC5.C5_FILIAL=SC9.C9_FILIAL AND SC5.C5_NUM=SC9.C9_PEDIDO AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   WHERE SC5.C5_ZCEPE <> ' ' " + CRLF 
    cRET += "   UNION " + CRLF 
    cRET += "   SELECT DISTINCT FILIAL, ROMANEIO, ORDSEP, ENDEREC, NFS, A1_CEP CEP, QUANTIDADE " + CRLF 
    cRET += "   FROM STAB01 A " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC9') + " SC9 " + CRLF 
    cRET += "   ON SC9.C9_NFISCAL=A.NFS AND SC9.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC5') + " SC5 " + CRLF 
    cRET += "   ON SC5.C5_FILIAL=SC9.C9_FILIAL AND SC5.C5_NUM=SC9.C9_PEDIDO AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SA1') + " SA1 " + CRLF 
    cRET += "   ON SA1.A1_COD=SC5.C5_CLIENT AND SA1.A1_LOJA=SC5.C5_LOJAENT AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   WHERE SC5.C5_ZCEPE = ' ' " + CRLF 
    cRET += "   UNION " + CRLF 
    cRET += "   SELECT DISTINCT FILIAL, ROMANEIO, ORDSEP, ENDEREC, NFS, A1_CEP CEP, QUANTIDADE " + CRLF 
    cRET += "   FROM STAB01 A " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC9') + " SC9 " + CRLF 
    cRET += "   ON SC9.C9_NFISCAL=A.NFS AND SC9.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   INNER JOIN " + RetSqlName('SC5') + " SC52 " + CRLF 
    cRET += "   ON SC52.C5_FILIAL=SC9.C9_FILIAL AND SC52.C5_NUM=SC9.C9_PEDIDO AND SC52.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   INNER JOIN SA1010 SA1 " + CRLF 
    cRET += "   ON SA1.A1_COD=SC52.C5_CLIENTE AND SA1.A1_LOJA=SC52.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
    cRET += "   WHERE SC52.C5_ZCEPE = ' ' AND SC52.C5_LOJAENT=' ' " + CRLF 
    cRET += "   ) x " + CRLF 
    cRET += "ORDER BY CEP, ROMANEIO  " + CRLF 

Return cRET


*************************************************************************************
*	Autor		:	Valdemir José
*	Descrição	:	Montagem dos Parâmetros
*	Modulo		:	Compras
*	Data		:	25/08/2016
*************************************************************************************
Static Function ValidSX1(cPerg)
Local aP    := {}
Local aHelp := {}
	
	dbselectarea("SX1")
	dbsetOrder(1)

	aAdd(aP,{"Romaneio de"			,"C", 10    ,0,"G", ""				,"" 		, ""        ,""	      	  , ""     		,""   , ""})   	// 01
	aAdd(aP,{"Romaneio até"			,"C", 10    ,0,"G", ""				,"" 		, ""        ,""	      	  , ""     		,""   , ""})   	// 02
    aAdd(aP,{"Quebra por Romaneio"  ,"N", 01    ,0,"C", ""              ,""         , "SIM"     ,"NÃO"        , ""          ,""   , ""})    // 03

	aAdd(aHELP,{"Informe o Romaneio inicial"})
	aAdd(aHELP,{"Informe o Romaneio Final"})
	aAdd(aHELP,{"Realiza Quebra por Romaneio"})
	
	
	StaticCall(STFSLIB, SX1Parametro, aP, aHelp, .F.)

Return
*/
//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function FiltroRom()
User Function FiltroRom()
    Local cRom    := ""
    Local lExit   := .F.
    Local lFiltro := .T.
    Local aFiltro := {}
    Local aConfig := {}
    Local aArea   := GetArea()

    While Empty(cRom) .And. (!lExit)
        cRom := FWInputBox("Informe o Numero do Romaneio","")
        if !Empty(cRom)
            dbSelectArea("PD1")
            dbSetOrder(1)
            lExit := dbSeek(XFilial('PD1')+cRom)
            if !lExit
        		FWMsgRun(,{|| sleep(3000)},"Informativo","Romaneio não encontrado. Por favor, verifique!")
                cRom := ""        
            endif
        else
            lExit := .T.
        Endif
    EndDo
    if Empty(cRom)
       if !MsgYesNo("Não foi informado o romaneio. Deseja zerar o filtro?"+CRLF+;
                    "Ao zerar o filtro, será apresentado todos os romaneios existentes."+CRLF+CRLF+;
                    "Tem certeza?","Aviso")
          Return .T.
       endif

       aFiltro := U_getParBox()     //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
       If !ParamBox(aFiltro,"Informe o Período",@aConfig, {|| .T.},,.F.,50,15)
          Return .T.
       Endif
       lFiltro := .F.
    Endif

    RestArea( aArea )

    FWMsgRun(,{|| aVetor := U_MntDoc(cRom, lFiltro,,aConfig) }, "Informativo","Carregando registros, aguarde...")   //FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION

Return .T.

//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function AtuBDGrid()
User Function AtuBDGrid()
    oBrDoc:SetArray(aVetor)
    oBrDoc:bLine      := {|| {IIf(	aVetor[oBrDoc:nAt,01],oOK, oNO),;
                                    aVetor[oBrDoc:nAt,02],;
                                    IIf(aVetor[oBrDoc:nAt,03],oOK, oNO),;
                                    aVetor[oBrDoc:nAt,04],;
                                    aVetor[oBrDoc:nAt,05],;
                                    aVetor[oBrDoc:nAt,06],;
                                    aVetor[oBrDoc:nAt,07],;
                                    aVetor[oBrDoc:nAt,08],;
                                    aVetor[oBrDoc:nAt,09],;
                                    aVetor[oBrDoc:nAt,10],;
                                    aVetor[oBrDoc:nAt,11];
                            } }
Return                         

//FR - 09/08/2022 - ALTERAÇÃO VISANDO R.33 NÃO ACEITA MAIS STATIC, ALTERADO PARA USER FUNCTION
//Static Function getParBox()
User Function getParBox()
    Local aRET := {}
    aAdd(aRET, {1,"Emissão De:"	,STOD(" ")						,"@D","","","",60,.F.})
    aAdd(aRET, {1,"Emissão Ate:"	,dDatabase						,"@D","","","",60,.T.})
    aAdd(aRET, {2,"Considera Encerrados", 1, {"Sim", "Nao"}      , 50    ,'.T.',.T.})   
Return aRET
