#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "totvs.ch"

Static cSelecao := 2
Static cCaminho := "C:\Temp"
Static aCabTMP  := {}
Static aColTMP  := {}
Static cCPOEX6  := "C6_ITEM/C6_PRODUTO/C6_DESCRI/C6_QTDVEN/C6_PRCVEN/C6_VALOR/C6_OPER/C6_TES"      // Campos que deverão ser considerados
Static cCPOEXK  := "CK_ITEM/CK_PRODUTO/CK_DESCRI/CK_QTDVEN/CK_PRCVEN/CK_VALOR/CK_OPER/CK_TES"      // Campos que deverão ser considerados
Static cAlias   := ""

/*/{Protheus.doc} STExpImp
Rotina que fará tanto a importação quanto exportação de Pedidos de Venda
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@return variant, logico
/*/
User Function STExpImp(pAlias)
	Local aPergs  := {}
	Local aRet    := {}
	Local lRet    := .T.
	Local lEnd    := .F.
	Local cCPOEMP := ""
	Local aButtons:= {}
	Local oProcess                  //incluído o parâmetro lEnd para controlar o cancelamento da janela
	Private lWhen   := .F.
	Private cCPFSEL := ""

	cAlias := pAlias

	aAdd( aPergs ,{3,"Selecione o Tipo",cSelecao, {"1-Exportar para preenchimento", "2-Importar"}, 80,'.T.',.T.})
	aAdd( aPergs ,{6,"Arquivo:",cCaminho,"","","",80,.T.,"Arquivos CSV|*.CSV| Arquivo TXT|*.txt"})
	AAdd(aButtons, {11, {|| cCPFSEL := u_stExImpB(cAlias)}, 'Seleção de Campos para Exportar/Importar'            }) // botão Editar
	
	If ParamBox(aPergs ,"- Informe os Dados -",@aRet,,aButtons,,,,,,.F.)
		cCPOEMP := gCPOSEL()
		if !Empty(cCPOEMP)
			cCPOEX := cCPOEMP 
		ELSE 
		   if (cAlias=="SC6")
		      cCPOEX := cCPOEX6
		   else
		      cCPOEX := cCPOEXK
		   endif 
		Endif 

		cSelecao := Left(iif(ValType(aRet[1])=="N",CValToChar(aRET[1]),aRET[1]),1)
		cCaminho := aRet[2]
		if cSelecao=="1"
		    // Exporta campos SC6 para planilha, onde deverá seguir o layout
			FWMsgRun(,{|| ExpPedVen()},"Aguarde...","Carregando Dados")
		else
		    // Valida campos do cabeçalho do pedido, antes de permitir a importação
			lRET := VLDCAB() 
			if lRET
				oProcess := MsNewProcess():New({|lEnd| ImpPedVen(@oProcess,@lEnd,cAlias) },"Aguarde...","Importando Itens do Pedido",.T.)
				oProcess:Activate()
			else 
				FWAlertInfo("O(s) campo(s) do cabeçalho não está preenchido, eles são: "+getTitCpo()+" Favor preencher para realizar a importação/exportação","Atenção!")
			endif 
		endif
	Else
		lRet := .F.
	EndIf

Return lRet


/*/{Protheus.doc} getTitCpo
Rotina que valida o campo que não foi informado e retorna
o nome do campo
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@return variant, String - Nome dos campos
/*/
Static Function getTitCpo()
	Local cRET   := "<B>"+CRLF
	Local cCampo := ""
    Local aCampo := {} 
	Local nX     := 0

	if cAlias=="SC6"
	   aCampo := {"C5_CLIENTE","C5_LOJACLI","C5_TIPO","C5_TRANSP","C5_TIPOCLI","C5_CONDPAG","C5_TABELA","C5_VEND1"} 
	else 
	   aCampo := {"CJ_CLIENTE","CJ_LOJA","CJ_CONDPAG","CJ_TABELA","CJ_CLIENT","CJ_LOJAENT","CJ_TXMOEDA","CJ_TIPOCLI","CJ_XTPED","CJ_XNATURE"} 
	endif 

	For nX := 1 to Len(aCampo)
		cCampo := aCampo[nX]
		if (Empty(M->&(cCampo)))
			cRET += FWSX3Util():GetDescription(cCampo)+CRLF
		Endif 
	Next 
	cRET += "</B>"

Return cRET


/*/{Protheus.doc} ImpPedVen
Rotina que faz a importação dos Itens
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@param oProcess, object, Regua de Processamento
@param lEnd, logical, Variavel que aborta processamento
@return variant, Nil
/*/
Static Function ImpPedVen(oProcess,lEnd,pAlias)
	Local nLin     := 0
	Local nCPO     := 0
	Local nItem    := 0
	Local cItem    := "01"
	Local _oObj    := oGetDad
	Local aColsBKP := {}
	Local lVldImp  := .F.
	Local lAdic    := .F.
	
	DbSelectArea("SX7")
    SX7->(DbSetOrder(1)) //Campo + Sequencia

	DbSelectArea("SX6")
    SX6->(DbSetOrder(1)) //Campo + Sequencia

	if pAlias=="SC6"
		aColsBKP := aClone(aCols)
	endif 

	aCabTMP := Separa(cCPOEX,"/")                    
	aColTMP := gDadosImp(oProcess,lEnd)

	// Valida a estrutura do arquivo
	if !(Len(aColTMP[1])==Len(aCabTMP))
	   FWAlertHelp("Arquivo informado com LayOut diferente do sistema","Verifique se o arquivo está correto, ou se precisa ser ajustado o layout.")
	   Return
	endif 

	if (pAlias=="SCK")
	   aColTMP := getSckUpd(aCabTMP,aColTMP)
	else 
	   aColTMP := getSc6Upd(aCabTMP,aColTMP)
	endif 

	aCols   := {}
	oProcess:SetRegua2(Len(aColTMP))

	For nLin := 1 To Len(aColTMP)
		If (oProcess:lEnd)
			Exit
		EndIf
		if (pAlias=="SC6")
			aAdd(aCols, aClone(aColsBKP[1]))
		    IF (aScan(aCabTMP,{|X| X=="C6_ITEM"})== 0)
			   aCols[nLin][01] := StrZero(Len(aCols), TamSX3(Right(pAlias,2)+"_ITEM")[1])
			ENDIF 
		else 
		    if nLin == 1
			   if nITEM==1
				   TMP1->(DBGOTO(nITEM+1))
			   else 
				   TMP1->(DBGOTO(nITEM+1))
				   lAdic := .T.
			   endif 
			   oGetDad:AddLine()
			endif 
			IF (aScan(aCabTMP,{|X| X=="CK_ITEM"})== 0)
				TMP1->CK_ITEM := cItem                //StrZero(nItem, TamSX3(Right(pAlias,2)+"_ITEM")[1])
			ENDIF
			RecLock("TMP1",.F.)
		endif 

	   nItem++
		n := nLin 
		cItem := Soma1(cItem)
		oProcess:IncRegua2("Importando Item: " + Strzero(nLin,4))
		For nCPO := 1 to Len(aCabTMP)
		    if FWSX3Util():GetFieldType( aCabTMP[nCPO] ) == "N"
			   cConteudo := val(StrTran(StrTran(cValToChar(aColTMP[nLin, nCPO]),".",""),",","."))
			else 
			   cConteudo := aColTMP[nLin, nCPO]
			endif
			if (pAlias=="SC6")
				lVldImp := (aCols[ Len(aCols), gdFieldPos(aCabTMP[nCPO]) ] != cConteudo)  
				aCols[Len(aCols), gdFieldPos(aCabTMP[nCPO])] := cConteudo
			else 
				lVldImp := (TMP1->&(aCabTMP[nCPO]) != cConteudo)  
				TMP1->&(aCabTMP[nCPO]) := cConteudo
			endif 
			cConteudo := ""		
			if (pAlias=="SC6")
			   EvalTrigger()
			endif
		Next
		// Validação dos campos
	    For nCPO := 1 to Len(aCabTMP)
		    n := nLin
			if (pAlias=="SC6")
				cConteudo := aCols[Len(aCols)]
			else 
			    cConteudo := TMP1->&(aCabTMP[nCPO])
			endif 
			GASX7CPO(aCabTMP[nCPO], cConteudo) 
			
		Next
		if (pAlias=="SCK")
		   MsUnlock()
		   if nLin <= Len(aColTMP)
		      oGetDad:AddLine()
		   endif 
		   oGetDad:Refresh()
		endif 
	Next
	if (pAlias!="SC6")
       oGetDad:Refresh()     //oGetDad:AddLine()		   
	endif 
	For nLin := 1 To Len(aColTMP)
		if (pAlias=="SC6")
			lVldImp := A410LINOK()
		else 
		    lVldImp := A415LinOk(oGetDad)
		endif 
	Next

	if (pAlias=="SC6")
	   if lVldImp
	      A410TudOk()	   
	   endif 
	else 
	   if lVldImp
	      A415TudOk(oGetDad)
		  oGetDad:Refresh()    
		  TMP1->( dbGotop() )
	   endif 	 
	endif

	IF (pAlias=="SCK") .and. lAdic    
		nBrLin := nItem + 1
		oGetDad:nCount := nItem + 1
		oGetDad:ForceRefresh()
	ENDIF
	
	SYSREFRESH()
	_oObj:Refresh()	
	
Return


/*/{Protheus.doc} gDadosImp
Rotina que carrega os dados da planilha
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@param oProcess, object, Regua de processamento
@param lEnd, logical, variavel que aborta processamento
/*/
Static Function gDadosImp(oProcess, lEnd)
	Local aRET   := {}
	Local cLinha := ""

	//Definindo o arquivo a ser lido
	oFile := FWFileReader():New(cCaminho)
	
	//Se o arquivo pode ser aberto
	If (oFile:Open())

		oProcess:SetRegua1(oFile:getFileSize())
	
		//Se não for fim do arquivo
		If ! (oFile:EoF())
		
			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())
				If (oProcess:lEnd)
					Break
				EndIf			
				//Buscando o texto da linha atual
				cLinha := oFile:GetLine()
				oProcess:IncRegua1("Bytes lidos....: " + cValToChar(oFile:getBytesRead()))		
				NL     := 0
				aTMP   := Separa(cLinha,";")
				aEval(aTMP, {|X| iif(!Empty(X),NL++,0)})
				
				if (NL = 1) .or. Left(aTMP[1],3)=="C6_"
					FT_FSKIP()
					Loop
				Endif 		

				cLinha := StrTran(cLinha,"'","")

				AADD(aRET,Separa(cLinha,";",.T.))

				If SubStr(cLinha,1,1) = ';'
					Exit
				EndIf

				//Mostrando a linha no console.log
				ConOut("Linha: " + cLinha)
			EndDo
		EndIf
		
		//Fecha o arquivo e finaliza o processamento
		oFile:Close()
	EndIf	

Return aRET


/*/{Protheus.doc} ExpPedVen
Rotina que fará a exportação dos dados
@type function
@version  12.1.33
@author valdemir rabelo
@since 20/10/2022
@return variant, Logico
/*/
Static Function ExpPedVen()
    Local aHeadTMP := {}
	Local nX       := 0
    
    aCabTMP := aClone(aHeader)
	aColTMP := {}

	For nX := 1 to Len(aCabTMP)
		IF (Alltrim(aCabTMP[nX][2]) $ cCPOEX)
			aAdd(aHeadTMP, aCabTMP[nX][2])
        Endif 
    Next
    aCabTMP := aClone(aHeadTMP)
	aadd(aColTMP, Array(Len(aCabTMP)))

	FWMsgRun(,{|| ExpMsExcel(aCabTMP, aColTMP, "Exporta Pedido Venda")},"Aguarde!","Exportando Planilha")

Return


// ---------+---------------------------------------------------------------------
// Autor    : Valdemir Rabelo - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+---------------------------------------------------------------------
Static Function ExpMsExcel(paCabec1, paItens1, pcTable)
	Local cArq       := ""
	Local cDirTmp    := GetTempPath()
	Local cWorkSheet := ""
	Local cTable     := pcTable
	Local oFwMsEx    := FWMsExcel():New()
	Local aHeadTMP   := {}
	Local nX         := 0
	Local nC         := 0
	Local nL         := 0

	Local cAlign  := ""
	Local cForm   := ""
	Private aAlgn := {}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Private aForm := {}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	SX3->( dbSetOrder(2) )

	cAlign := "{"
	cForm  := "{"
	For nX := 1 to Len(paCabec1)
		IF (alltrim(paCabec1[nX]) $ cCPOEX)
			aAdd(aHeadTMP, paCabec1[nX])
			SX3->( dbSeek(paCabec1[nX]) )
			if nX > 1
				cAlign += ","
				cForm  += ","
			endif
			if SX3->X3_TIPO == "C"
				cAlign += "1"
				cForm  += "1"
			elseif SX3->X3_TIPO == "N"
				cAlign += "3"
				cForm  += "2"
			elseif SX3->X3_TIPO == "D"
				cAlign += "2"
				cForm  += "4"
			elseif SX3->X3_TIPO == "L"
				cAlign += "2"
				cForm  += "1"
			else
				cAlign += "1"
				cForm  += "1"
			endif
		Endif
	Next
	cAlign += "}"
	cForm  += "}"
	//
	paCabec1 := aClone(aHeadTMP)
	aAlgn := &cAlign
	aForm := &cForm

	cWorkSheet := "Registros Gerados"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:SetTitleSizeFont(13)
	oFwMsEx:AddTable( cWorkSheet, cTable )

	oFwMsEx:SetTitleBold(.T.)

	For nC := 1 to Len(paCabec1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , paCabec1[nC] , aAlgn[nC], aForm[nC] )
	Next

	For nL := 1 to Len(paItens1)
		oFwMsEx:AddRow(cWorkSheet,cTable, paItens1[nL] )
	Next

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando Planilha, aguarde...", cTable, {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		IncProc("Carregando planilha")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
	Endif

Return

/*/{Protheus.doc} GASX7CPO
Rotina que faz o gatilho dos campos
@type function
@version  12.1.33
@author valdemir rabelo
@since 25/10/2022
@param pCPOCab, variant, Campo
@param paCols, variant, Array das colunas
@return variant, Nil
/*/
Static Function GASX7CPO(pCPOCab,paCols)
	Local aAreaSX7   := GetArea()
	Local cChave     := ""

	if cAlias == "SC6"
		if (pCPOCab=="C6_PRODUTO")
			cChave    := paCols[GDFIELDPOS("C6_PRODUTO", aHeader)]
			SetPrvt("C6_PRODUTO")
			IF !(A093Prod().And.A410MultT()).And.TESAutoCol("SC6")      // .And.a410Produto()
			   Return 
			Endif 
			IF SC6->( FIELDPOS('C6_DESCRI') ) > 0
				paCols[GDFIELDPOS("C6_DESCRI", aHeader)] := gContDom("SB1",1,cChave,"SB1->B1_DESC")
			Endif 
			paCols[GDFIELDPOS("C6_UM", aHeader)] 	  := gContDom("SB1",1,cChave,"SB1->B1_UM")
			paCols[GDFIELDPOS("C6_REVPROD", aHeader)] := gContDom("SB5",1,cChave,"SB5->B5_VERSAO")
			paCols[GDFIELDPOS("C6_SERVIC",  aHeader)] := gContDom("SB5",1,cChave,"SB5->B5_SERVSAI")
			paCols[GDFIELDPOS("C6_ENDPAD",  aHeader)] := gContDom("SB5",1,cChave,"SB5->B5_ENDSAI")			
			paCols[GDFIELDPOS("C6_TPESTR", aHeader)]  := gContDom("SBE",9,cChave,"SBE->BE_ESTFIS")
			IF Empty(paCols[GDFIELDPOS("C6_TES", aHeader)])
			   paCols[GDFIELDPOS("C6_TES", aHeader)]  := gContDom("SB1",1,cChave,"SB1->B1_TS")
			Endif 
			paCols[GDFIELDPOS("C6_CLASFIS", aHeader)] := gContDom("SB1",1,cChave,"SB1->B1_CLASFIS")
			paCols[GDFIELDPOS("C6_CF", aHeader)]      := gContDom("SF4",1,paCols[GDFIELDPOS("C6_TES", aHeader)] ,"SF4->F4_CF")

			cChave    := M->C5_TABELA+paCols[GDFIELDPOS("C6_PRODUTO", aHeader)]
			paCols[GDFIELDPOS("C6_PRUNIT", aHeader)] := gContDom("DA1",1,cChave,"DA1->DA1_PRCVEN*(100-M->C5_XDESCUE)/100") 
			paCols[GDFIELDPOS("C6_LOCAL", aHeader)]  := IIF(M->C5_XTPED=="N","03","01") 
			paCols[GDFIELDPOS("C6_PRCVEN", aHeader)] := gContDom("DA1",1,cChave,"U_DISFTC01(DA1->DA1_PRCVEN,"+cValToChar(paCols[GDFIELDPOS('C6_XDESCUE', aHeader)])+","+cValToChar(paCols[GDFIELDPOS('C6_DESCONT', aHeader)])+")") 
			paCols[GDFIELDPOS("C6_ENTREG", aHeader)] := M->C5_FECENT
			paCols[GDFIELDPOS("C6_CC", aHeader)]     := '114102'
		Endif 

		if (pCPOCab=="C6_QTDVEN") .or. (pCPOCab=="C6_UNSVEN") .or. (pCPOCab=="C6_XDESCUE")
			cChave    := M->C5_TABELA+paCols[GDFIELDPOS("C6_PRODUTO", aHeader)]
			paCols[GDFIELDPOS("C6_PRUNIT", aHeader)] := gContDom("DA1",1,cChave,"U_DISFTC02(DA1->DA1_PRCVEN,"+cValToChar(paCols[GDFIELDPOS('C6_XDESCUE', aHeader)])+")") 
			paCols[GDFIELDPOS("C6_PRCVEN", aHeader)] := gContDom("DA1",1,cChave,"U_DISFTC01(DA1->DA1_PRCVEN,"+cValToChar(paCols[GDFIELDPOS('C6_XDESCUE', aHeader)])+","+cValToChar(paCols[GDFIELDPOS('C6_DESCONT', aHeader)])+")") 
			paCols[GDFIELDPOS("C6_VALOR", aHeader)]  := paCols[GDFIELDPOS("C6_QTDVEN", aHeader)]*paCols[GDFIELDPOS("C6_PRCVEN", aHeader)] 
			paCols[GDFIELDPOS("C6_LOCAL", aHeader)]  := IIF(M->C5_XTPED=="N","03","01") 
		Endif 
		if (pCPOCab=="C6_PROJPMS")
			paCols[GDFIELDPOS("C6_TASKPMS", aHeader)]  := SPACE(TamSX3("C6_TASKPMS")[1])
			paCols[GDFIELDPOS("C6_EDTPMS", aHeader)]   := SPACE(TamSX3("AFC_EDT")[1])  
		endif  
		if (pCPOCab=="C6_TES") .or. (pCPOCab=="C6_VALOR")
			paCols[GDFIELDPOS("C6_LOCAL", aHeader)]  := IIF(M->C5_XTPED=="N","03","01")
		endif
	else 
		if (pCPOCab=="CK_PRODUTO") .OR. (pCPOCab=="CK_QTDVEN")
			cChave    := TMP1->CK_PRODUTO
			SetPrvt("CK_PRODUTO")
			IF SCK->( FIELDPOS('CK_DESCRI') ) > 0
				TMP1->CK_DESCRI := gContDom("SB1",1,cChave,"SB1->B1_DESC")
			Endif 
			TMP1->CK_UM	     := gContDom("SB1",1,cChave,"SB1->B1_UM")
			TMP1->CK_TES     := gContDom("SB1",1,cChave,"SB1->B1_TS")						//'650'
			TMP1->CK_CLASFIS := gContDom("SB1",1,cChave,"SB1->B1_CLASFIS")

			cChave    	    := M->CJ_TABELA+TMP1->CK_PRODUTO
			TMP1->CK_PRUNIT := gContDom("DA1",1,cChave,"DA1->DA1_PRCVEN*(100-M->CJ_XDESCUE)/100")    //a415Tabela(TMP1->CK_PRODUTO,M->CJ_TABELA,TMP1->CK_QTDVEN)
			TMP1->CK_PRCVEN := TMP1->CK_PRUNIT
			TMP1->CK_VALDESC:= 0
			TMP1->CK_DESCONT:= 0
			TMP1->CK_VALOR  := TMP1->CK_QTDVEN*TMP1->CK_PRCVEN
			TMP1->CK_DESCONT:= FtRegraDesc(2)
			TMP1->CK_LOCAL  := IIF(M->CJ_XTPED=="N","03","01") 

			TMP1->CK_ZB2QATU:= U_COLGSAL(TMP1->CK_PRODUTO,TMP1->CK_LOCAL)
		Endif 
		IF (pCPOCab=="CK_OPER")
		    if !Empty(TMP1->CK_OPER)
			//	TMP1->CK_TES     := MaTesInt(2,TMP1->CK_OPER,M->CJ_CLIENTE,M->CJ_LOJA,"C",TMP1->CK_PRODUTO,"CK_TES")            
			endif 
			TMP1->CK_CLASFIS := CodSitTri()
		Endif 
	endif

	RestArea( aAreaSX7)

Return 


/*/{Protheus.doc} gContDom
Rotina que posiciona registro
@type function
@version  12.1.33
@author valdemir rabelo
@since 25/10/2022
@param cAlias, character, Tabela
@param nOrd, numeric, Ordem
@param cChave, character, Campo Chave
@param pRetorno, variant, Campo Retorno
@return variant, Conteudo da Resposta
/*/
Static Function gContDom(cAlias,nOrd,cChave,pRetorno)
	Local cRET

	dbSelectArea(cAlias)
	dbSetOrder(nOrd)
	dbSeek(xFilial(cAlias)+cChave)
	cRET := &(pRetorno) 

Return cRET


/*/{Protheus.doc} gCPOSEL
Rotina para efetuar leitura do arquivo de campos
@type function
@version  12.1.33
@author valdemir rabelo
@since 21/10/2022
@return variant, String - Contendo os campos da empresa
/*/
Static Function gCPOSEL()
    Local cRET    := ""
    Local nHandle := 0
    Local cArqSEL := cAlias+"_"+cEmpAnt+".cpo"

    if File(cArqSEL)
        nHandle := FT_FUSE(cArqSEL)
		If nHandle = -1
		   Return cRET
		Endif        
        FT_FGOTOP()
    	While !FT_FEOF()
           cRET := FT_FREADLN()
           FT_FSKIP()
        EndDo
        FT_FUSE()
    Endif 

Return cRET

/*/{Protheus.doc} VLDCAB
Rotina para validar cabeçalho
@type function
@version  12.1.33
@author valdemir rabelo
@since 31/10/2022
@return variant, .T. OK para Continuar .F. precisa informar dados importantes
/*/
Static Function VLDCAB() 
	Local lRET := .T.

	if (cAlias == "SC6")
		lRET := (!Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_LOJACLI) .AND. !EMPTY(M->C5_TIPO) .AND. !EMPTY(M->C5_TRANSP) .AND.;
				 !EMPTY(M->C5_TIPOCLI) .AND. !EMPTY(M->C5_CONDPAG) .AND. !EMPTY(M->C5_TABELA) .AND. !EMPTY(M->C5_VEND1) )
	else 
		lRET := (!Empty(M->CJ_CLIENTE) .AND. !Empty(M->CJ_LOJA) .AND. ;
				 !EMPTY(M->CJ_TIPOCLI) .AND. !EMPTY(M->CJ_CONDPAG) .AND. !EMPTY(M->CJ_TABELA) .AND.;
				 !Empty(M->CJ_CLIENT) .AND. !Empty(M->CJ_LOJAENT) .AND. !Empty(CJ_TXMOEDA) .AND.;
				 !Empty(M->CJ_XTPED) .AND. !Empty(CJ_XNATURE) )
	endif 						

Return lRET						


Static Function getSckUpd(aCabTMP,aColTMP)
	Local aRET := {}
	Local aTMP := {}
	Local nX   := 0
	Local lAdic:= .T.
	
	// Vejo os itens já existentes e carrego no array
	TMP1->( dbGotop() )
	While TMP1->( !Eof() )
		aTMP := {}
	    For nX := 1 to Len(aCabTMP)
		    if !Empty(TMP1->&(aCabTMP[nX]))
		       aAdd(aTMP, TMP1->&(aCabTMP[nX]))
			else 
			   lAdic := .F.
			   exit
			Endif 
		Next 
		if lAdic
	       aAdd(aRET, aClone(aTMP))
		endif 
		TMP1->( dbSkip() )
	EndDo 
	// Adiciono os novos itens importados
	For nX := 1 to Len(aColTMP)
	    aAdd(aRET, aColTMP[nX])
	Next 
	if Len(aRET) > 0
	   // Excluo os registros existentes para serem gravados os novos
	   TMP1->( dbGotop() )
	   While TMP1->( !Eof() )
	   	    RecLock("TMP1",.f.)
			TMP1->( dbDelete() )
			MsUnlock()
			oGetDad:Refresh()
			TMP1->( dbSkip() )
		EndDo
		oGetDad:ForceRefresh()
		//RecLock("TMP1", .T.) 	   
	endif 

Return aRET


Static function getSc6Upd(aCabTMP,aColTMP)
	Local aRET := {}
	Local aTMP := {}
	Local nX   := 0
	Local nC   := 0
	Local lAdic:= .T.

	For nC := 1 to Len(aCols)
		aTMP := {}
	    For nX := 1 to Len(aCabTMP)
		    if !Empty(aCols[nC,gdFieldPos(aCabTMP[nX])])
		       aAdd(aTMP, aCols[nC,gdFieldPos(aCabTMP[nX])])
			else 
			   lAdic := .F.
			   exit
			Endif 
		Next 	
		// Valida campo numerico
	    For nX := 1 to Len(aCabTMP)
		    if Valtype(aTMP[nX])=="N"
			   aTMP[nX] := StrTran(cValToChar(aTMP[nX]),".",",")
			endif 
		Next 
		if lAdic
	       aAdd(aRET, aClone(aTMP))
		endif 
	Next 
	// Adiciono os novos itens importados
	For nX := 1 to Len(aColTMP)
	    aAdd(aRET, aColTMP[nX])
	Next 

Return aRET 
