#Include "Protheus.CH"
#Include "TOTVS.CH"
#include "fwmvcdef.ch"
#include "topconn.ch"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

Static oFont06	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Static oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Static oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Static oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Static oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Static oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Static oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
Static oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

Static cRETGERVR

#DEFINE MODULE_PIXEL_SIZE 12
#DEFINE lAdjustToLegacy  .F.
#DEFINE lDisableSetup    .T.   
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




User Function STFSLIB()
RETURN

//--------------------------------------------------------------
/*/{Protheus.doc} Function LibGerF3
Description                                                     
 Procura Customizada padrão 
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.CRLF                                             
@since 30/08/2019   
@Observação
Parametros	pTabela  - Informar a Tabela real ou informar um nome	  
            paFields - Array de 2 linhas a primeira visual e a segunda
            		   para efetuar busca conforme nome na tabela     
            pChave   - Campos utilizados para dbSeek        		  
            pbFilter - Condição para Filtro, em caso de usar tabela   
            pcQry    - Informando Query, irá desconsiderar as tabelas 
Exemplo:
 cAlias  := 'SW7'                             
 aCampos := { {'Codigo','Descrição'},;        
              {'B1_COD','B1_DESC'} }          
 cChave  := 'XFILIAL('SB1')+SC6->C6_PRODUTO   ==> Usado para Tabelas
 cFilter := "B1_GRUPO = 'CAMADA'"             ==> Usado para Tabelas
 cQry    := "SELECT B1_COD, B1_DESC FROM "+RETSQLNAME('SB1')+" SB1 WHERE SB1.D_E_L_E_T_ = ''"  ==> Se usar cQry será desconsiderado as tabelas

 u_ProcCust(cAlias, aCampos, cChave, cFilter, cQry)
/*/                                                             
//--------------------------------------------------------------       
User Function BUSCAF3(pTABELA, aCampos, cChave, cFilter, cQry, nRetCol)

    //Local  aCampos := { {'Codigo','Descrição'},;        
    //                    {'W7_COD_I','B1_DESC'} }   

	 LibGerF3(pTABELA, aCampos, cChave, cFilter, cQry, nRetCol)
	 
Return


/*/{Protheus.doc} LibGerF3
    (long_description)
    Rotina para montagem da consulta específica padrão
    @type  Function
    @author user
    Valdemir Rabelo
    @since 11/09/2019
    @version version
    @param 
/*/
Static Function LibGerF3(pTABELA, paFields, pchave, pbFilter, pcQry, pnRetCol)
Local oBtProc
Local oBTSair
Local oCampo
Local oCBCampo
Local aCampos  := {paFields[1][1],paFields[1][2]}
Local nCBCampo := 1
Local ogConteudo
Local cReadVar := ReadVar()
Local uVarRet

Private aListBox := {}
Private cgConteudo := space(30)
Private oListBox   
Private oBTOk

Static oDlg  

  // Obtem o conteúdo do campo utilizado na Consulta Padrao Customizada
  uVarRet := GetMemVar(cReadVar)

  if Len(paFields) < 2
     apMsgInfo('Atenção a procura precisa ter dois campos com duas linhas para serem apresentados',"Informação")
     Return
  Endif
  
  aCampos  := {paFields[1][1],paFields[1][2]}
  
  DEFINE MSDIALOG oDlg TITLE "Procura" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL
//
    @ 009, 006 SAY oCampo PROMPT "Campo" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 026 MSCOMBOBOX oCBCampo 	VAR nCBCampo 	ITEMS {paFields[1][1],paFields[1][2]}  On Change ChangeCB(aCampos,oCBCampo) SIZE 058, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 089 MSGET ogConteudo 	VAR cgConteudo 	PICTURE "@!"	SIZE 110, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 006, 201 BUTTON oBtProc PROMPT "Procura" SIZE 037, 012 OF oDlg ACTION {Localiz(pTABELA, cgConteudo, oCBCampo:nAt),oBTOk:SetFocus()} PIXEL
    
    fListBox(pTABELA, paFields, pchave, pbFilter, pcQry)
    
    @ 225, 081 BUTTON oBTOk 	PROMPT "OK"	 SIZE 037, 012 OF oDlg ACTION {OkConf(@uVarRet, cReadVar, pTABELA, pnRetCol), oDlg:End()} PIXEL
    @ 226, 130 BUTTON oBTSair 	PROMPT "Sair" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
	ogConteudo:SetFocus()
  ACTIVATE MSDIALOG oDlg CENTERED       
 
Return


Static Function OkConf(uVarRet, cReadVar, cAlias, pnRetCol)
	Local aArea := GetArea()
	Local nUlt  := Len(aListBox[1])
	
	(cAlias)->( dbGoto(aListBox[oListBox:nAt,nUlt]))   // 11/05/2016

	if Type("nGetIDROM") == "U" //Valtype(nGetIDROM) == "U" ajustado chamado 20221024019634
	   nGetIDROM := 0
	endif

	nGetIDROM := aListBox[oListBox:nAt,nUlt]			// Criar essa variavel como private no fonte da chamada

    uVarRet := Alltrim(aListBox[oListBox:nAt, pnRetCol])
    
	// Atualiza a Variável de Retorno
	cRETGERVR    := uVarRet
	//------------------------------------------------------------------------------------------------
	// Atualiza a Variável de Memória com o Conteúdo do Retorno
	SetMemVar(cReadVar,cRETGERVR)
    //VAR_IXB := uVarRet
	//------------------------------------------------------------------------------------------------
	// Força a atualização dos Componentes (Provavelmente não irá funcionar). A solução. ENTER
	SysRefresh(.T.)         
    
    // Atualiza os componentes
    GetDRefresh()

	RestArea( aArea )

Return .t.


//------------------------------------------------ 
Static Function fListBox(pTABELA, paFields, pchave, pbFilter, pcQry)
//------------------------------------------------ 
	Local    _cFields := ""
	Local    nX       := 0
	Local    nLin     := 0
	Local    aTMP     := {}
	Local    cCabec   := ""
	Local    cColSize := ""
	Default  pTABELA  := "TPROC"

	oListBox := Nil
	aListBox := {} 
	
	if !Empty(pcQry)           
	    pTABELA := "TPROC"
		If Select(pTABELA)>0
			(pTABELA)->(dbCloseArea())
		EndIf
		tcQuery pcQry New Alias "TPROC"
		dbSelectArea("TPROC")			
	Else
		dbSelectArea(pTabela)
		(pTabela)->(dbSetFilter({|| &pbFilter}, pbFilter)) 
		dbSeek(pchave)
	Endif

	if eof()
		For nX := 1 to Len(paFields[2])
			Aadd(aTMP,"" )	
		Next
		Aadd(aTMP, 0)
		aAdd(aListBox, aTMP)
	else
                         
		While !Eof() 
			nLin := Len(aListBox)
			For nX := 1 to Len(paFields[2])+1
				if nX = Len(paFields[2])+1
					aAdd(aTMP, (pTabela)->REG)
				else
					aAdd(aTMP, (pTabela)->&(paFields[2][nX]) )
				endif
			Next
			aAdd(aListBox, aTMP)
			aTMP := {}
			dbSkip()
		EndDo
	
	endif
	
	cCabec   := "{'"
	cColSize := "{'"
	_cFields := "{ "
	For nX := 1 to Len(paFields[1])
	    if nX > 1
		   cCabec   += "','"
		   cColSize += ","
		   _cFields += ","
		endif
		cCabec += paFields[1][nX]
		_cFields += "aListBox[oListBox:nAT]["+StrZero(nX, 2)+"]"
		if (At("_",paFields[2][nX]) > 0)
			cColSize += cValToChar(TamSX3(paFields[2][nX])[1])
		else
			cColSize += '10'
		endif
	Next
	if Len(cCabec) > 2
		cCabec   += "'}"
		cColSize += "'}"
		_cFields += " }"
	Endif

	oListBox := TWBrowse():New( 023, 007, 234, 191,,;
		&(cCabec),&(cColSize), oDlg, ,,,,;
		{||},,,,,,,.F.,,.T.,,.F.,,, )

    oListBox:SetArray(aListBox)
	oListBox:bLine := {|| &(_cFields) }
    oListBox:bLDblClick := {|| oBTOk:SetFocus(),(pTABELA)->( dbGoto(aListBox[oListBox:nAt,Len(aListBox[oListBox:nAt])])),;    // DoubleClick event
      						oListBox:DrawSelect()}

Return .t.


/*****************************************************
* Ajusta Ordenação conforme seleção
******************************************************/
Static Function ChangeCB(paCampo,pCBCampo)
	Local nCBO := pCBCampo:nAT 
		
	aSort(aListBox,,,{ |X,Y| X[nCBO] < Y[nCBO]} )
    
    oListBox:Refresh()
    oListBox:nAt := 1

Return .t.
            


/*****************************************************
* Localiza Registro conforme conteudo
*****************************************************/
Static Function Localiz(pTABELA, cgConteudo, nCBCampo)
	Local nPos    := 0
	Local nUltCol := 0
    
	if !Empty(cgConteudo)
		if nCBCampo = 1
			nPos := aScan(aListBox, {|X| alltrim(X[nCBCampo])==alltrim(cgConteudo)} )
		else
			nPos := aScan(aListBox, {|X| alltrim(cgConteudo) $ alltrim(X[nCBCampo])} )	
		endif   
		if nPos > 0
             nUltCol := Len(aListBox[nPos])
            (pTABELA)->( dbGoto(aListBox[nPos,nUltCol]))
            
            oListBox:nAt := nPos    
        else 
            FWMsgRun(,{|| Sleep(3000)},'Informação','Registro não encontrado. Verifique se informou o conteudo correto')
        endif 
	Endif
	oListBox:SetFocus()
	
Return .t.


/*********************************************************************
* Necessário criar para ser adicionado no retorno da consulta padrão
*********************************************************************/
User Function RETGERVR()
Return (cRETGERVR)      //(VAR_IXB)

/*/{Protheus.doc} Cabec
    (long_description)
    Cria cabeçalho padrão
    @type  Function
    @author user
    Valdemir Rabelo
    @since 11/09/2019
    @version version
    @param 
/*/
Static Function TITULOCABEC(oPrint, pTITULO, pSubTit ,pSubTit1, pTipo, pCont, pnTamF)
	Local cFont      := oFont10
	Local nReturn    := 045
	Local nColPix
	Local nCol       := 0
	
	Local nUltColPos := 0
	Local aPosTitulo := {}
	Local oFontTit   := TFont():New("Arial",pnTamF,pnTamF,,.T.,,,,.T.,.F.)

	nCol    := if(Len(aPosTitulo)==0, 5, aPosTitulo[1])
	
	if Len(aPostitulo) > 0
		nUltColPos := aPosTitulo[17]
	else 
		ultCol := 650
	endif 
	
	nUltColCab :=  if(pTipo=="P",if(Len(aPosTitulo) < 32,700, ultCol), 1400)
	
	oPrint:StartPage() 						// Inicia uma nova pagina
	
	m_pag++
	          
	cLogoD   := FisxLogo("1")
	oPrint:SayBitmap(nReturn-15 ,nCol+5,cLogoD,0078,0028 )   //50,60 - ,0098,0038
	                             
	//-----------------------------
	nColPix := Char2Pix('W',oFont16)
	//-----------------------------
	if pTipo == 'P'  // Portrait                                      
	    oPrint:Say(nReturn+16,(480-((len(alltrim(pTITULO))/2)*nColPix))+100, alltrim(pTITULO),oFontTit)
	Else
		oPrint:say(nReturn ,(500 / 2),Padc(TRIM(pTITULO),80),oFontTit)    //
	endif
	// 1o. Subtitulo
	if TRIM(pSubTit) != ""                        
		//-----------------------------
		nColPix := Char2Pix('W',oFont09)
		//-----------------------------
		nReturn += 10
		if pTipo == 'P' 
		    oPrint:Say(nReturn,(550-((len(alltrim(pSubTit))/2)*nColPix)),alltrim(pSubTit),oFont09)      // 1696
		else
			oPrint:say (nReturn ,(650-((len(alltrim(pSubTit))/2)*nColPix)),TRIM(pSubTit), oFont09)     //350 oFont07b
		endif
	Endif

    //Cabeçalho 1
	oPrint:say(nReturn ,if(pTipo=="P",if(Len(aPosTitulo) < 32,700, ultCol),(if(Len(aPosTitulo) < 32, ultCol, ultCol)-60) ),(RPTFOLHA+" "+StrZero(m_pag,3)),cFont)			// +if(pCont > 0,cSubPag,'')
	nReturn += 10

	// 2o. Subtitulo
	if TRIM(pSubTit1) != ""                        
	    oPrint:Say(nReturn,(2000-((len(alltrim(pSubTit1))/2)*nColPix)),alltrim(pSubTit1),oFont09)      // 1696
	Endif
	nReturn += 24 
	oPrint:say(nReturn+8 ,010 ,"SIGA / "+FunName()+" - "+SM0->M0_NOME,cFont)
	oPrint:say (nReturn+8 , if(pTipo=="P", if( Len(aPosTitulo) < 32,700, ultCol), if(Len(aPosTitulo) < 32,ultCol,ultCol)-80),("DATA: "+dtoc(DDATABASE)+" "+Time()),cFont)
	nReturn += 10 //60
	
Return( nReturn )



Static Function Char2Pix(cTexto,oFont)
Return(GetTextWidht(0,cTexto,oFont)*2)



/******************************************************************************************************
* Função que criará no arquvio de perguntas, respeitando o array que será passado como parametro.
* Existe dois parametros, um para as perguntas e outro para o help                               
******************************************************************************************************/
User Function SX1Parametro(aP,aHelp,lAtiva)
Local i := 0
Local cSeq
Local cMvCh
Local cMvPar
Local CRLFET

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
cOrdem,;
cPergunt,cPerSpa,cPerEng,;
cVar,;
cTipo,;
nTamanho,;
nDecimal,;
nPresel,;
cGSC,;
cValid,;
cF3,;
cGrpSxg,;
cPyme,;
cVar01,;
cDef01,cDefSpa1,cDefEng1,;
cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,;
cHelp)

Característica do vetor p/ utilização da função SX1
---------------------------------------------------
[n,1] --> texto da pergunta
[n,2] --> tipo do dado
[n,3] --> tamanho
[n,4] --> decimal
[n,5] --> objeto G=get ou C=choice
[n,6] --> validacao
[n,7] --> F3
[n,8] --> definicao 1
[n,9] --> definicao 2
[n,10] -> definicao 3
[n,11] -> definicao 4
[n,12] -> definicao 5
***/

/*  ---------------------------------------- Exemplo de Criação de Array para os Parametros ------------------------------------------
aAdd(aP,{"Ano Base           ?"      ,"C",  4,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Mês De             ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Mês Até            ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Visão              ?"      ,"N", 01,0,"C","",""      , "BIO","TEC","" ,"", ""})  //
aAdd(aP,{"C.Custo De         ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"C.Custo Ate        ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta De           ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta Ate          ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})

aAdd(aHelp,{"Digite a data base do Movimento."})
aAdd(aHelp,{"Informe o mês inicial"})
aAdd(aHelp,{"Informe o mês final"})
aAdd(aHelp,{"Selecione o item contábil, BIO OU TEC"})
aAdd(aHelp,{"Informe o C.Custo Inicial"})
aAdd(aHelp,{"Informe o C.Custo Final"})
aAdd(aHelp,{"Informe o Numero da Conta Inicial"})
aAdd(aHelp,{"Informe o Numero da Conta Final"})
//  ---------------------------------------- */


For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	cMvPar := "mv_par"+cSeq
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	{},;
	"")
Next i

CRLFET := Pergunte(cPerg,lAtiva)

Return CRLFET


/*/{Protheus.doc} STPesqGD()
	(long_description)
	Pesquisa padrão para Grids
	@type  Static Function
	@author user
	Valdemir Rabelo - SigaMat
	@since date
	24/01/2020
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
		Campos que irão aparecer na seleção de pesquisa
		aCampos := {{"Codigo"   ,1 ,"C",15,"@!"},;
					{"Descricao",2,"C",20,"@!"} }
		Campo que será a chave de ordenação, caso exista mais
		de uma, só adicionar respeitando as colunas
		aCPOCHV := {{"Nota Fiscal",NPOSDOC,    "C",09,"@!"}}

	@see (links_or_references)
/*/
User Function STPesqGD(oObJList, aObjDados, aCampos, aCPOCHV)
	Local oBTCancela
	Local oBTOk
	Local oCBO
	Local nCBO := 1
	Local cConteudo := Space(20)
	Local oSay1
	Local aCBO := {}
	Local oWPesq
	Private oConteudo
	Private cPict := "@!"
	Static oDlgP	

	aEval(aCampos, {|X| aAdd(aCBO, X[1]) })

  DEFINE MSDIALOG oDlgP TITLE "Pesquisa" FROM 000, 000  TO 150, 350 COLORS 0, 16777215 PIXEL  STYLE nOR( WS_VISIBLE, WS_POPUP )
    oDlgPanel := tPanel():New(0,0,"",oDlgP,,,,,RGB(132,172,196),100,100)
    oDlgPanel:align := CONTROL_ALIGN_ALLCLIENT

	oFWLMain := FWLayer():New()
	oFWLMain:Init( oDlgPanel, .T. )
	oFWLMain:AddLine("LineSup",100,.T.)
	oFWLMain:AddCollumn( "ColSP01", 100, .T.,"LineSup" )
	oFWLMain:AddWindow( "ColSP01", "WinSP01", "Pesquisa", 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oWPesq := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )

    @ 010, 012 SAY oSay1 PROMPT "Campo" SIZE 025, 007 OF oWPesq COLORS 0, 16777215 PIXEL
    @ 019, 012 MSCOMBOBOX oCBO VAR nCBO ITEMS aCBO SIZE 055, 010 OF oWPesq COLORS 0, 16777215 ON CHANGE SelChange(oObJList, aObjDados, oCBO, nCBO, aCBO, oWPesq, oBTOk, aCPOCHV,oConteudo,aCampos,@cConteudo) PIXEL
    @ 010, 073 SAY oSay1 PROMPT "Conteudo" SIZE 025, 007 OF oWPesq COLORS 0, 16777215 PIXEL
    @ 019, 073 MSGET oConteudo VAR cConteudo Picture cPict SIZE 086, 010 OF oWPesq COLORS 0, 16777215 PIXEL

    @ 039, 042 BUTTON oBTOk PROMPT "OK" SIZE 037, 012 OF oWPesq ACTION (LocReg(aObjDados, oCBO, cConteudo, oObJList, aCampos), oDlgP:End()) PIXEL
    @ 039, 088 BUTTON oBTCancela PROMPT "Cancelar" SIZE 037, 012 OF oWPesq ACTION oDlgP:End() PIXEL
	oCBO:nAT := 1

	oBTOk:cToolTip 		 := "Confirma a pesquisa"
	oBTCancela:cToolTip  := "Cancela e volta a tela anterior"
	oConteudo:cPlaceHold := "Informe o conteudo a pesquisar"
	oConteudo:cToolTip  := oConteudo:cPlaceHold

	oBTOk:SetCss( CSSBOTAO )
	oBTCancela:SetCss( CSSBOTAO )

  ACTIVATE MSDIALOG oDlgP CENTERED

Return .T.



Static Function SelChange(oObJList, aObjDados, oCBO, nCBO, aCBO, oWPesq, oBTOk, aCPOCHV, oConteudo, aCampos, cConteudo)
	Local nX      := 0
	Local aCHV    := {}
	Local cMacroX := ""
	Local cMacroY := ""
	Local cMacro  := ""
	Local cTMP    := ""
	Local nPos    := 0
	Local NPOSTPFRET := 6

	cConteudo := nil

	if funname()=="STFATROM" .AND. oCBO:aItems[oCBO:nAT]=="Tipo Frete"
	   aCPOCHV := {{"Tipo Frete",	NPOSTPFRET,"C",03,"@!"}}
	else 
		aEVAL(aCPOCHV, {|X| aAdd(aCHV, X[2])})
	endif 

	For nX := 1 to Len(aCHV)
	    cTMP += cValToChar(aCHV[nX])
		if nX > 1
		   cMacroX += "+"
		   cMacroY += "+"
		Endif
        cMacroX += "X["+cValToChar(aCHV[nX])+"]"
        cMacroY += "Y["+cValToChar(aCHV[nX])+"]"
	Next
	// Se opção for diferente da minha chave, acrescento
	if !(cValToChar(oCBO:nAT) $ cTmp)
		cMacroX += "+X["+cValToChar(oCBO:nAT)+"]"
		cMacroY += "+Y["+cValToChar(oCBO:nAT)+"]"
	endif
	if funname()=="STFATROM" 
	   nOPC := 0
	   if oCBO:aItems[oCBO:nAT]=="Tipo Frete"
	      nOPC := 6
	   elseif oCBO:aItems[oCBO:nAT]=="Nota Fiscal"
	      nOPC := 2
	   elseif oCBO:aItems[oCBO:nAT]=="Nome Cliente"
	      nOPC := 10
	   elseif oCBO:aItems[oCBO:nAT]=="Dt Emissao"
	      nOPC := 12		  
	   endif
	   if oCBO:aItems[oCBO:nAT]=="Dt Emissao"
	      cMacroX := "dtos(X["+cValtoChar(nOPC)+"])"
		  cMacroY := "dtos(Y["+cValtoChar(nOPC)+"])"
	   else
	      cMacroX :="X["+cValtoChar(nOPC)+"]"
		  cMacroY := "Y["+cValtoChar(nOPC)+"]"
	   endif 
	   if oCBO:aItems[oCBO:nAT] != "Nota Fiscal"
	      cMacroX += "+X[2]"
	      cMacroY += "+Y[2]"
	   endif 
	endif 

	cMacro := cMacroX + " < " + cMacroY

	// Ordena conforme seleção
	aSort(aObjDados,,,{ |X,Y| &cMacro} )
	oObJList:nAt := 1
	oObJList:Refresh()
	
	nPos := aScan(aCampos, { |X| upper(Alltrim(X[1]))==upper(Alltrim(aCBO[oCBO:nAT]))})

	if aCampos[nPos][3]=="C"
		cConteudo := Space( aCampos[nPos][4] )
		cPict    := "@!"
	elseif aCampos[nPos][3]=="D"
		cConteudo := CtoD(space(aCampos[nPos][4])) 
		cPict     := "@D 99/99/9999"
	elseif aCampos[nPos][3]=="N"
		cPict     := "@E 999,999,999.99"
		cConteudo := 0
	endif

	oConteudo:Refresh()
	oConteudo:SetFocus()
Return .T.



Static Function LocReg(aObjDados, oCBO, cConteudo, oObJList, aCampos)
	Local nPos := 0

	oObJList:nAt := 1
	If (oCBO:nAT == 0)
		apMsgInfo('Para efetaur uma pesquisa, precisa ser selecionado o campo','Atenção')
		Return
	EndIf

	if aCampos[oCBO:nAT][3] == "N"
		nPos := aScan(aObjDados, { |x| Val(StrTran(x[ aCampos[oCBO:nAT][2] ],',','.')) == cConteudo} )
	elseif aCampos[oCBO:nAT][3] == "D"
	    if !Empty(Left(dtoc(cConteudo),2))
		   nPos := aScan(aObjDados, { |x|  dtos(cConteudo) == dtos(x[ aCampos[oCBO:nAT][2] ]) } )
		endif 
	Else
		nPos := aScan(aObjDados, { |x|  Alltrim(cConteudo) $ Alltrim(x[ aCampos[oCBO:nAT][2] ]) } )
	Endif
	If nPos > 0
		oObJList:Refresh()
		oObJList:nAT := nPos
	EndIf
	oObJList:SetFocus()

Return



User function PrxDiaUt(dData,nDias)
	Local nCont := 0

	For nCont :=1 to nDias

		dData += nCont
		If dow(dData)== 1 		//domingo
			dData += 1
		ElseIf dow(dData)== 7 	//sabado
			dData += 2
		EndIf

	Next

Return dData



user Function AddEVLog(pNomeArq, pMensagem)
	Local _cArq  := pNomeArq
	Local _compl := dtos(dDatabase)
	Default pNomeArq := 'EVError_'+_compl

	mkdir('\arquivos\')
	LjWriteLog( '\arquivos\'+_cArq+'_'+_compl+'.log', pMensagem )

Return



// Inicio ----------------------------------------------------- Classe Parâmetros -------------------------------------------------------------------

/* {Protheus.doc} Classe EVParame
    Description
    Biblioteca de Classe EV Solution System
    @author Valdemir Rabelo / Eduardo Silva
    @since 23/03/2020
	Parametros:
    1º Grupo de Perguntas
    2º String em formato Json
    3º Array do Help

	Exenplo Chamada:
    cAllPerg := '{"AllPerg": [ '
    cAllPerg += '{"X1_PERGUNT": "Data de",        "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Data até",       "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Cliente",        "X1_TIPO": "C", "X1_TAMANHO": 6, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SA1", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Tipo Relatório", "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Impresso", "X1_DEF02": "Planilha", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}  '
    cAllPerg += '] }    '

    aAdd(aHelp, "Informe a data inicial")
    aAdd(aHelp, "Informe a data final")
    aAdd(aHelp, "Informe o código do cliente")
    aAdd(aHelp, "Informe o tipo do relatório")

    oParamet := EVParame():New("VALDEMIR03", cAllPerg, aHelp)
    if !oParamet:Activate(.T.)      // Parâmetro Activate .T. = ACRLFe tela de parametro, .F. = Carrega em memoria sem aCRLFir a tela
       oParamet:Dispose()           // Removendo da Memoria o objeto
	   Return
	Endif
    oParamet:Dispose()    
*/
Class EVParame
	Data cPergClass	As String
	Data aPergHlp	As Array
	Data cPerg  	As String

    Method New( ) Constructor
    Method AddGrupo()
    Method getGrupo()
    Method AddPerg()
    Method AddHlp()
    Method GetPerg()
    Method SetPerg()
    Method SetPergClass()
    Method GetPergClass()
    Method SetPergHlp()    
    Method GetPergHlp()
    Method Activate()
    Method Dispose()
EndClass

Method New(pPerg, paPerg, paPergHlp) Class EVParame
    ::cPerg      := pPerg
    ::SetPergClass(paPerg)
    ::aPergHlp   := paPergHlp
Return .T.

Method GetPerg() Class EVParame
Return(Self:cPerg)

Method SetPerg(pPerg) Class EVParame
    Self:cPerg := pPerg
Return .T.

Method SetPergClass(paPergClass) Class EVParame
    Self:cPergClass := paPergClass
Return .T.

Method GetPergClass() Class EVParame
Return(Self:cPergClass)

Method SetPergHlp(paPergHlp) Class EVParame
    Self:aPergHlp := paPergHlp
Return .T.

Method GetPergHlp()  Class EVParame
Return(Self:aPergHlp)

Method Dispose() Class EVParame
    //FreeObj(Self)
Return .T.

Method Activate(lLogico) Class EVParame
    Local oJson   := nil
    Local lRet    := .T.
    Local nX      := 0
    Local _cGrupo := ""    
    Local aAreaSX1:= GetArea()

    dbSelectArea("SX1")
    _cGrupo := Padr( Self:cPerg,Len(SX1->X1_GRUPO))

    if Empty(Self:cPerg)
       MsgInfo("Atenção!","Não foi informado o código do grupo de pergunta")
       Return .F.
    endif
    if Empty(Self:GetPergClass())
       MsgInfo("Atenção!","Não foi informado a Lista de perguntas em formato json")
       Return .F.
    endif

    FwJSONDeserialize(FwNoAccent(Self:GetPergClass()), @oJSON)

    For nX := 1 to Len(oJson:AllPerg)
        U_EVPutSX1(_cGrupo, StrZero(nX,2), oJson:AllPerg[nX]:X1_PERGUNT, 'MV_PAR'+StrZero(nX,2), 'mv_ch'+cValToChar(nX), oJson:AllPerg[nX]:X1_TIPO, oJson:AllPerg[nX]:X1_TAMANHO, oJson:AllPerg[nX]:X1_DECIMAL, oJson:AllPerg[nX]:X1_GSC,;
                 oJson:AllPerg[nX]:X1_VALID, oJson:AllPerg[nX]:X1_F3 , "@!", oJson:AllPerg[nX]:X1_DEF01, oJson:AllPerg[nX]:X1_DEF02, oJson:AllPerg[nX]:X1_DEF03, oJson:AllPerg[nX]:X1_DEF04, oJson:AllPerg[nX]:X1_DEF05, Self:aPergHlp[nX])
    Next

    RestArea( aAreaSX1 )

    lRET := Pergunte(_cGrupo, lLogico)

Return lRet

/*
    Exemplo de Chamada
*/
/*
User Function EVParam()
    Local cAllPerg := ""
    Local aHelp    := {}
    Local cAllhlp  := ""
    Local oParamet := Nil

	// Chamada via Json
    cAllPerg := '{"AllPerg": [ '
    cAllPerg += '{"X1_PERGUNT": "Data de",        "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Data até",       "X1_TIPO": "D", "X1_TAMANHO": 8, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Cliente",        "X1_TIPO": "C", "X1_TAMANHO": 6, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SA1", "X1_PYME": "S"}, '
    cAllPerg += '{"X1_PERGUNT": "Tipo Relatório", "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Impresso", "X1_DEF02": "Planilha", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}  '
    cAllPerg += '] }    '

    aAdd(aHelp, "Informe a data inicial")
    aAdd(aHelp, "Informe a data final")
    aAdd(aHelp, "Informe o código do cliente")
    aAdd(aHelp, "Informe o tipo do relatório")

    oParamet := EVParame():New("VALDEMIR03", cAllPerg, aHelp)
    if !oParamet:Activate(.T.)
	   Return
	Endif

Return
*/
// FIM ----------------------------------------------------- Classe Parâmetros -------------------------------------------------------------------




 
/*/{Protheus.doc} EVPutSX1
Função para criar Grupo de Perguntas
@author Valdemir Rabelo
@since 03/03/2020
@type function
    @param cGrupo,    characters, Grupo de Perguntas       (ex.: X_TESTE)
    @param cOrdem,    characters, Ordem da Pergunta        (ex.: 01, 02, 03, ...)
    @param cTexto,    characters, Texto da Pergunta        (ex.: Produto De, Produto Até, Data De, ...)
    @param cMVPar,    characters, MV_PAR?? da Pergunta     (ex.: MV_PAR01, MV_PAR02, MV_PAR03, ...)
    @param cVariavel, characters, Variável da Pergunta     (ex.: MV_CH0, MV_CH1, MV_CH2, ...)
    @param cTipoCamp, characters, Tipo do Campo            (C = Caracter, N = Numérico, D = Data)
    @param nTamanho,  numeric,    Tamanho da Pergunta      (Máximo de 60)
    @param nDecimal,  numeric,    Tamanho de Decimais      (Máximo de 9)
    @param cTipoPar,  characters, Tipo do Parâmetro        (G = Get, C = Combo, F = Escolha de Arquivos, K = Check Box)
    @param cValid,    characters, Validação da Pergunta    (ex.: Positivo(), u_SuaFuncao(), ...)
    @param cF3,       characters, Consulta F3 da Pergunta  (ex.: SB1, SA1, ...)
    @param cPicture,  characters, Máscara do Parâmetro     (ex.: @!, @E 999.99, ...)
    @param cDef01,    characters, Primeira opção do combo
    @param cDef02,    characters, Segunda opção do combo
    @param cDef03,    characters, Terceira opção do combo
    @param cDef04,    characters, Quarta opção do combo
    @param cDef05,    characters, Quinta opção do combo
    @param cHelp,     characters, Texto de Help do parâmetro
    @obs Função foi criada, pois a partir de algumas versões do Protheus 12, a função padrão PutSX1 não funciona (por medidas de segurança)
    @example Abaixo um exemplo de como criar um grupo de perguntas
/*/ 
User Function EVPutSX1(cGrupo, cOrdem, cTexto, cMVPar, cVariavel, cTipoCamp, nTamanho, nDecimal, cTipoPar, cValid, cF3, cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, cHelp)
    Local aArea       := GetArea()
    Local cChaveHelp  := ""
    Local nPreSel     := 0
    Default cGrupo    := Space(10)
    Default cOrdem    := Space(02)
    Default cTexto    := Space(30)
    Default cMVPar    := Space(15)
    Default cVariavel := Space(6)
    Default cTipoCamp := Space(1)
    Default nTamanho  := 0
    Default nDecimal  := 0
    Default cTipoPar  := "G"
    Default cValid    := Space(60)
    Default cF3       := Space(6)
    Default cPicture  := Space(40)
    Default cDef01    := Space(15)
    Default cDef02    := Space(15)
    Default cDef03    := Space(15)
    Default cDef04    := Space(15)
    Default cDef05    := Space(15)
    Default cHelp     := ""
     
    //Se tiver Grupo, Ordem, Texto, Parâmetro, Variável, Tipo e Tamanho, continua para a criação do parâmetro
    If !Empty(cGrupo) .And. !Empty(cOrdem) .And. !Empty(cTexto) .And. !Empty(cMVPar) .And. !Empty(cVariavel) .And. !Empty(cTipoCamp) .And. nTamanho != 0
         
        //Definição de variáveis
        cGrupo     := PadR(cGrupo, Len(SX1->X1_GRUPO), " ")           //Adiciona espaços a direita para utilização no DbSeek
        cChaveHelp := "P." + AllTrim(cGrupo) + AllTrim(cOrdem) + "."  //Define o nome da pergunta
        cMVPar     := Upper(cMVPar)                                   //Deixa o MV_PAR tudo em maiúsculo
        nPreSel    := Iif(cTipoPar == "C", 1, 0)                      //Se for Combo, o pré-selecionado será o Primeiro
        cDef01     := Iif(cTipoPar == "F", "56", cDef01)              //Se for File, muda a definição para ser tanto Servidor quanto Local
        nTamanho   := Iif(nTamanho > 60, 60, nTamanho)                //Se o tamanho for maior que 60, volta para 60 - Limitação do Protheus
        nDecimal   := Iif(nDecimal > 9,  9,  nDecimal)                //Se o decimal for maior que 9, volta para 9
        nDecimal   := Iif(cTipoPar == "N", nDecimal, 0)               //Se não for parâmetro do tipo numérico, será 0 o Decimal
        cTipoCamp  := Upper(cTipoCamp)                                //Deixa o tipo do Campo em maiúsculo
        cTipoCamp  := Iif(! cTipoCamp $ 'C;D;N;', 'C', cTipoCamp)     //Se o tipo do Campo não estiver entre Caracter / Data / Numérico, será Caracter
        cTipoPar   := Upper(cTipoPar)                                 //Deixa o tipo do Parâmetro em maiúsculo
        cTipoPar   := Iif(Empty(cTipoPar), 'G', cTipoPar)             //Se o tipo do Parâmetro estiver em CRLFanco, será um Get
        nTamanho   := Iif(cTipoPar == "C", 1, nTamanho)               //Se for Combo, o tamanho será 1
     
        DbSelectArea('SX1')
        SX1->(DbSetOrder(1)) // Grupo + Ordem
     
        //Se não conseguir posicionar, a pergunta será criada
        If ! SX1->(DbSeek(cGrupo + cOrdem))
            RecLock('SX1', .T.)
                X1_GRUPO   := cGrupo
                X1_ORDEM   := cOrdem
                X1_PERGUNT := cTexto
                X1_PERSPA  := cTexto
                X1_PERENG  := cTexto
                X1_VAR01   := cMVPar
                X1_VARIAVL := cVariavel
                X1_TIPO    := cTipoCamp
                X1_TAMANHO := nTamanho
                X1_DECIMAL := nDecimal
                X1_GSC     := cTipoPar
                X1_VALID   := cValid
                X1_F3      := cF3
                X1_PICTURE := cPicture
                X1_DEF01   := cDef01
                X1_DEFSPA1 := cDef01
                X1_DEFENG1 := cDef01
                X1_DEF02   := cDef02
                X1_DEFSPA2 := cDef02
                X1_DEFENG2 := cDef02
                X1_DEF03   := cDef03
                X1_DEFSPA3 := cDef03
                X1_DEFENG3 := cDef03
                X1_DEF04   := cDef04
                X1_DEFSPA4 := cDef04
                X1_DEFENG4 := cDef04
                X1_DEF05   := cDef05
                X1_DEFSPA5 := cDef05
                X1_DEFENG5 := cDef05
                X1_PRESEL  := nPreSel
                 
                //Se tiver Help da Pergunta
                If !Empty(cHelp)
                    X1_HELP    := ""                     
                    EVPutHlp(cChaveHelp, cHelp)
                EndIf
            SX1->(MsUnlock())
        EndIf
    EndIf
     
    RestArea(aArea)
Return


Static Function EVPutHlp(cKey, cHelp, lUpdate)
    Local cFilePor  := "SIGAHLP.HLP"
    Local cFileEng  := "SIGAHLE.HLE"
    Local cFileSpa  := "SIGAHLS.HLS"
    Local nRet      := 0
    Default cKey    := ""
    Default cHelp   := ""
    Default lUpdate := .F.
     
    //Se a Chave ou o Help estiverem em CRLFanco
    If Empty(cKey) .Or. Empty(cHelp)
        Return
    EndIf
     
    //**************************** Português
    nRet := SPF_SEEK(cFilePor, cKey, 1)     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFilePor, cKey, , , cHelp)     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
        EndIf
    EndIf
     
     
     
    //**************************** Inglês
    nRet := SPF_SEEK(cFileEng, cKey, 1)     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFileEng, cKey, , , cHelp)     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
        EndIf
    EndIf
     
     
     
    //**************************** Espanhol
    nRet := SPF_SEEK(cFileSpa, cKey, 1)     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFileSpa, cKey, , , cHelp)     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
        EndIf
    EndIf
Return


/*
	Autor:		Valdemir Rabelo
	Data:		10/03/2020
	Descrição:	Envio de e-mail WF
*/
User Function EMailST(pPara, pCC, pAssunto, paCorpo)
	
	Local cTo   		:= pPara
	Local cCC   		:= pCC	
	Local cBody			:= STMsgWF(pAssunto, paCorpo)
	Local cSubject		:= pAssunto

	U_STMAILTES(cTo, cCC, cSubject, cBody, {}, "")

Return


/*
	Autor:		Valdemir Rabelo
	Data:		10/03/2020
	Descrição:	Corpo do e-mail
*/
Static Function STMsgWF(pAssunto, paCorpo)
	Local cMsg      := ""		
    Local _nLin     := 0
	Local _aMsg     := aClone(paCorpo)
	Local _cAssunto := pAssunto

	//A Definicao do cabecalho do email                                             
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
	//A Definicao do texto/detalhe do email                                         
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email                                               
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
Return cMsg


User Function vMemoToA(cTexto, nMaxCol, cQueCRLFa, lTiraCRLFa)
    Local aArea     := GetArea()
    Local aTexto    := {}
    Local aAux      := {}
    Local nAtu      := 0
    Default cTexto  := ''
    Default nMaxCol := 80
    Default cQueCRLFa := ';'
    Default lTiraCRLFa:= .T.
 
    //QueCRLFando o Array, conforme -Enter-
    aAux:= StrTokArr(cTexto,Chr(13))
     
    //Correndo o Array e retirando o tabulamento
    For nAtu:=1 TO Len(aAux)
        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
    Next
     
    //Correndo as linhas queCRLFadas
    For nAtu:=1 To Len(aAux)
     
        //Se o tamanho de Texto, for maior que o número de colunas
        If (Len(aAux[nAtu]) > nMaxCol)
         
            //Enquanto o Tamanho for Maior
            While (Len(aAux[nAtu]) > nMaxCol)
                //Pegando a queCRLFa conforme texto por parâmetro
                nUltPos:=RAt(cQueCRLFa,SubStr(aAux[nAtu],1,nMaxCol))
                 
                //Caso não tenha, a última posição será o último espaço em CRLFanco encontrado
                If nUltPos == 0
                    nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
                EndIf
                 
                //Se não encontrar espaço em CRLFanco, a última posição será a coluna máxima
                If(nUltPos==0)
                    nUltPos:=nMaxCol
                EndIf
                 
                //Adicionando Parte da Sring (de 1 até a Úlima posição válida)
                aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
                 
                //QueCRLFando o resto da String
                aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
            EndDo
             
            //Adicionando o que soCRLFou
            aAdd(aTexto,aAux[nAtu])
        Else
            //Se for menor que o Máximo de colunas, adiciona o texto
            aAdd(aTexto,aAux[nAtu])
        EndIf
    Next
     
    //Se for para tirar os CRLFancos
    If lTiraCRLFa
        //Percorrendo as linhas do texto e aplica o AllTrim
        For nAtu:=1 To Len(aTexto)
            aTexto[nAtu] := Alltrim(aTexto[nAtu])
        Next
    EndIf
     
    RestArea(aArea)
Return aTexto


// ---------+---------------------------------------------------------------------
// Autor    : Valdemir Rabelo - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+---------------------------------------------------------------------
User Function ExpotMsExcel(paCabec1, paItens1,aTipo, pcTable)
	Local cArq       := ""                             
	Local cDirTmp    := GetTempPath()
	Local cWorkSheet := ""
	Local cTable     := pcTable
	Local oFwMsEx    := FWMsExcel():New()
    Local nX         := 0
    Local nC         := 0
    Local nL         := 0
        
	Local cAlign  := ""
	Local cForm   := ""
    Private aAlgn := {}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
    Private aForm := {}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	cAlign := "{"
	cForm  := "{"
	For nX := 1 to Len(aTipo)
	    if nX > 1
		   cAlign += ","
		   cForm  += ","
		endif
		if aTipo[nX] == "C"
		   cAlign += "1"
		   cForm  += "1"
		elseif  aTipo[nX] == "N"
		   cAlign += "3"
		   cForm  += "2"
		elseif  aTipo[nX] == "D"
		   cAlign += "2"
		   cForm  += "4"
		elseif  aTipo[nX] == "L"
		   cAlign += "2"
		   cForm  += "1"
		else
		   cAlign += "1"
		   cForm  += "1"
		endif
	Next
	cAlign += "}"
	cForm  += "}"
	//
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
        //FR - 26/10/2022 - Erro ao exportar Excel: só adicionar a linha se possuir o mesmo número de colunas do cabeçalho 
        If Len(paItens1[nL]) == Len(paCabec1)        
      oFwMsEx:AddRow(cWorkSheet,cTable, paItens1[nL] )
        Endif
        //FR - 26/10/2022 - Flávia Rocha - Sigamat Consultoria
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

/*/{Protheus.doc} UPTabEV
description
@type function
@version 
@author Valdemir Rabelo
@since 23/04/2020
@param pTabela', param_type, param_description
@param aCampo, array, param_description
@param aCONDICAO, array, param_description
@return return_type, return_description
/*/
User Function UPTabEV(pTabela, aCampo, aCONDICAO)
	Local nX        := 0
	Local cMensErro := ""
	Local lRET      := .T.
	Local cQry      := " UPDATE " + RETSQLNAME(pTabela)

	cQry += ' SET '

	// Campos a serem atualizados
	For nX := 1 to Len(aCampo)
	    if nX > 1
		   cQry += ','
		endif 
		if ValType(aCampo[nX][2])=="C"
			cQry += aCampo[nX][1]+"='"+aCampo[nX][2]+"' "
		elseif ValType(aCampo[nX][2])=="N"
			cQry += aCampo[nX][1]+"= "+cValToChar(aCampo[nX][2])+" "
		elseif ValType(aCampo[nX][2])=="D"
			cQry += aCampo[nX][1]+"= '"+dtoc(aCampo[nX][2])+"' "
		endif
	Next

	cQry += " WHERE D_E_L_E_T_ = ' ' AND "

	// Adicionando condições
	For nX := 1 to Len(aCONDICAO)
	    if nX > 1
		   cQry += ' AND '
		endif 
		cQry += aCONDICAO[nX][1]+"='"+aCONDICAO[nX][2]+"' "
	Next

	If (TcSqlExec(cQry) < 0)
		cMensErro := TCSQLError() + " ocorrida função " +ProcName(-1)+ " na linha " +cValtoChar(ProcLine(-1))+ ". "
		UserException(cMensErro)
		lRET := .F.
	EndIf

Return lRET


User Function GetSetCSS(pComp, pcImg, pTipo)
	Local cRET    := ""
	Default pcImg := "rpo:yoko_sair.png"
	Default pTipo := "Botao CRLFanco"

	if pComp == "GROUP"
		cRET +="QGroupBox {";
			+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
			+CRLF+"                    stop: 0 #E0E0E0, stop: 1 #FFFFFF); /*cor de fundo*/";
			+CRLF+"  border: 2px solid gray; /*cor da borda*/";
			+CRLF+"  border-radius: 5px;  /*arredondamento da borda*/";
			+CRLF+"  margin-top: 2px; /*espaco ao topo para o titulo*/";
			+CRLF+"}";
			+CRLF+"/* Caracterissticas do titulo */";
			+CRLF+"QGroupBox::title {";
			+CRLF+"  color: red;";
			+CRLF+"  subcontrol-origin: margin; /*margem*/";
			+CRLF+"  padding: 0 3px; /*espacamento*/";
			+CRLF+"  subcontrol-position: top center; /*posiciona texto ao topo+centro*/";
			+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
			+CRLF+"                    stop: 0 #FFOECE, stop: 1 #FFFFFF); /*cor de fundo*/";
			+CRLF+"}"
	Elseif pComp == "BUTTOM"
		If cTipo == "Success"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#28a745;border-color:#28a745 "
			cRET += "}"
		EndIf

		If cTipo == "Primary"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#007bff;border-color:#007bff "
			cRET += "}"
		EndIf

		If cTipo == "Danger"
			cRET := "QPushButton {"
			cRET += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
			cRET += "}"
		EndIf
	Elseif pComp == "LISTBOX"
		cRET +=	 CRLF+"QAbstractItemView {";
				+CRLF+"  font-size: 12px; /*tamanho da fonte*/";
				+CRLF+"  color: #0d65d4; /*cor da fonte*/";
				+CRLF+"  border: 2px solid #0d65d4; /*cor da borda*/";
				+CRLF+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
				+CRLF+"			stop: 0 #aed1fc, stop: 1 #deecfc); /*Cor de fundo*/";
				+CRLF+"";
				+CRLF+"  /* Caracteristicas quando selecionado*/";
				+CRLF+"  selection-color: #953734; /*cor da fonte*/";
				+CRLF+"  selection-background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
				+CRLF+"			stop: 0 #C4BD97, stop: 1 #DDD9C3); /*cor de fundo*/";
				+CRLF+"}"
	Endif

Return cRET


/*
    Funcao      : STIMPXLS
    Objetivos   : Função chamada para realizar a conversão de XLS para um array
    Parâmetros  :  cArqE    - Nome do arquivo XLS a ser carregado
                   cOrigemE - Local onde está o arquivo XLS
                   nLinTitE - Quantas linhas de cabeçalho que não serão integradas possui o arquivo
                   cTipoRet - 'A' - Retorna Array 'C' - Salva como CSV na pasta temp do usuário                 
    Autor       : Valdemir Rabelo
    Data/Hora   : 01/07/2020
	Observação  : Para rodar sem problema na pasta de smatclient, precisa conter um arquivo executavel
	              com nome AvgXML2DBF.exe
*/
User Function STIMPXLS(cArqE,cOrigemE,nLinTitE,lTela,cTipoRet)
    Local bOk        := {||lOk:=.T.,oDlg:End()}
    Local bCancel    := {||lOk:=.F.,oDlg:End()}
    Local lOk        := .F.
    Local nLin       := 40
    Local nCol1      := 15
    Local nCol2      := nCol1+30
    Local cMsg       := ""
    Local oDlg
    Local oArq
    Local oOrigem
    Local oMacro

    Default lTela    := .T.
    Default cTipoRet := "C"

    Private cArq       := If(ValType(cArqE)=="C",cArqE,"")
    Private cArqMacro  := "XLS2DBF.XLA"
    Private cTemp      := GetTempPath()                                 //pega caminho do temp do client
    Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))       //Pega o caminho do sistema
    Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
    Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
    Private aArquivos  := {}
    Private aRet       := {}


    cArq       += Space(50-(Len(cArq)))
    cOrigem    += Space(99-(Len(cOrigem)))

    If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))

        Define MsDialog oDlg Title 'Integração de Excel' From 7,10 To 19,50 OF oMainWnd


        @ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
        @ nLin,nCol2  MsGet    oArq   Var cArq                 Size 80,09 Of oDlg Pixel

        nLin += 15

        @ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
        nLin += 10
        @ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel

        nLin += 15

        // @ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel
        // nLin += 10
        // @ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel

        Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel) Centered
    Else
        lOk := .T.
    EndIf

    If lOk
        cMsg := validaCpos()
        If Empty(cMsg)
            aAdd(aArquivos, cArq)
            IntegraArq()
        Else
            MsgStop(cMSg)
            Return
        EndIf
    EndIf
    
Return aRet


/*
Funcao      : IntegraArq
Objetivos   : Faz a chamada das rotinas referentes a integração
Autor       : Valdemir Rabelo
Data/Hora   : 01/07/2020
*/
Static Function IntegraArq()
    Local lConv      := .F.
    //converte arquivos xls para csv copiando para a pasta temp
    MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),;
                   lConv := convArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
    If lConv
        //carrega do xls no array
        ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
        ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
        Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,;
            "Aguarde, carregando planilha..."+CRLF+"Pode demorar")
        ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
        //
    EndIf
Return

/*
    Funcao      : convArqs
    Objetivos   : converte os arquivos .xls para .csv
    Autor       : Valdemir Rabelo 
    Data/Hora   : 01/07/2020
*/
Static Function convArqs(aArqs)
    Local oExcelApp
    Local cNomeXLS  := ""
    Local cFile     := ""
    Local cExtensao := ""
    Local i         := 1
    Local j         := 1
    Local aExtensao := {}

    cOrigem := AllTrim(cOrigem)

    //Verifica se o caminho termina com "\"
    If !Right(cOrigem,1) $ "\"
        cOrigem := AllTrim(cOrigem)+"\"
    EndIf


    //loop em todos arquivos que serão convertidos
    For i := 1 To Len(aArqs)

        If !"." $ AllTrim(aArqs[i])
            //passa por aqui para verifica se a extensão do arquivo é .xls ou .xlsx
            aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
            For j := 1 To Len(aExtensao)
                If "XLS" $ Upper(aExtensao[j][1])
                    cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
                    Exit
                EndIf
            Next j
        EndIf

        //recebe o nome do arquivo corrente
        cNomeXLS := AllTrim(aArqs[i])
        cFile    := cOrigem+cNomeXLS+cExtensao

        If !File(cFile,1,.f.)
            MsgInfo("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")
            Return .F.
        EndIf

        //verifica se existe o arquivo na pasta temporaria e apaga
        If File(cTemp+cNomeXLS+cExtensao)
            fErase(cTemp+cNomeXLS+cExtensao)
        EndIf

        //Copia o arquivo XLS para o Temporario para ser executado        
        If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.)
            MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
            Return .F.
        EndIf
        if !File(cTemp+cNomeXLS)                    // Se não copiou tento novamente
           cTmp := Substr(cFile, At("\Schneider",cFile), Len(cFile))
            CpyS2T( cTmp, cTemp )         // Copia do Protheus para Temporario da maquina
        Endif 

        //apaga macro da pasta temporária se existir
         If File(cTemp+cArqMacro)
            fErase(cTemp+cArqMacro)
        EndIf

        //Copia o arquivo XLA para o Temporario para ser executado
        If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
            MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
            Return .F.
        EndIf

        //Exclui o arquivo antigo (se existir)
         If File(cTemp+Left(cNomeXLS,At(".",cNomeXLS)-1)+".csv")
            fErase(cTemp+Left(cNomeXLS,At(".",cNomeXLS)-1)+".csv")
        EndIf

        //Inicializa o objeto para executar a macro
        oExcelApp := MsExcel():New()
        //define qual o caminho da macro a ser executada
        oExcelApp:WorkBooks:Open(cTemp+cArqMacro)
        //executa a macro passando como parametro da macro o caminho e o nome do excel corrente
        oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
        //fecha a macro sem salvar
        oExcelApp:WorkBooks:Close('savechanges:=False')
        //sai do arquivo e destrói o objeto
        oExcelApp:Quit()
        oExcelApp:Destroy()

        //Exclui o Arquivo excel da temp
        fErase(cTemp+cNomeXLS+cExtensao)
        fErase(cTemp+cArqMacro)             //Exclui a Macro no diretorio temporario
        
    Next i

Return .T.

/*
    Funcao      : CargaDados
    Objetivos   : carrega dados do csv no array pra retorno
    Parâmetros  : cArq - nome do arquivo que será usado      
    Autor       : Valdemir Rabelo
    Data/Hora   : 24/05/2012
*/   
Static Function CargaArray(cArq)

    Local cLinha  := ""
    Local nLin    := 1
    Local aDados  := {}
    Local cArqTMP := Left(cArq, At('.',cArq)-1)
    Local cFile   := cTemp + cArqTMP + ".csv"
    Local nHandle := 0

    //abre o arquivo csv gerado na temp
    nHandle := Ft_Fuse(cFile)
    If nHandle == -1
        Return aDados
    EndIf
    Ft_FGoTop()
    nLinTot := FT_FLastRec()-1
    ProcRegua(nLinTot)
    //Pula as linhas de cabeçalho
    While nLinTit > 0 .AND. !Ft_FEof()
        Ft_FSkip()
        nLinTit--
    EndDo

    //percorre todas linhas do arquivo csv
    Do While !Ft_FEof()
        //exibe a linha a ser lida
        IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
        nLin++
        //le a linha
        cLinha := Ft_FReadLn()
        //verifica se a linha está em branco, se estiver pula
        If Empty(AllTrim(StrTran(cLinha,';','')))
            Ft_FSkip()
            Loop
        EndIf
        //transforma as aspas duplas em aspas simples
        cLinha := StrTran(cLinha,'"',"'")
        cLinha := '{"'+cLinha+'"}'
        //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
        cLinha := StrTran(cLinha,';','","')
        aAdd(aDados, &cLinha)

        //passa para a próxima linha
        FT_FSkip()
        
    EndDo

    //libera o arquivo CSV
    FT_FUse()

    //Exclui o arquivo csv
    If File(cFile)
        //FErase(cFile)
    EndIf

Return aDados


/*
    Funcao      : validaCpos
    Objetivos   : faz a validação dos campos da tela de filtro
    Autor       : Valdemir Rabelo 
    Data/Hora   : 24/05/2012
*/
Static Function validaCpos()
    Local cMsg := ""

    If Empty(cArq)
        cMsg += "Campo Arquivo deve ser preenchido!"+CRLF
    EndIf

    If Empty(cOrigem)
        cMsg += "Campo Caminho do arquivo deve ser preenchido!"+CRLF
    EndIf

    If Empty(cArqMacro)
        cMsg += "Campo Nome da Macro deve ser preenchido!"
    EndIf

Return cMsg



/*/{Protheus.doc} getLista
    description
    Rotina com Lista para Etiquetas de Produtos
    @type function
    @version 
    @author Valdemir Jose
    @since 16/09/2020
    @return return_type, return_description
/*/
User Function getLista()
    Local cRET   := ""
    Local cCompl := ""

    if FWIsInCallStack("U_OPETQ002")
        cCompl := " U_EXECETIQ" //"StaticCall (OPMNTBAL,EXECETIQ,"
    else 
        cCompl := " U_EXECETIQ" //"StaticCall (OPMNTBAL,EXECETIQ,"
    Endif 
/*
    // Produto, Sentido, Rotina    ExecEtiq(pModelo)
    aAdd(aRET, {"S70110304",    "H", cCompl+"'V9130400')"})      // ORION - MODELO: EAV9130400 * - 
    aAdd(aRET, {"S70110324",    "V", cCompl+"'E8525400')"})      // ORION - MODELO: EAV8525400 *
    aAdd(aRET, {"S734103859",   "H", cCompl+"'NHA4940502')"})    // ORION BLISTER - MODELO: NHA4940502
    aAdd(aRET, {"S3B70340",     "H", cCompl+"'UNSCHIME')"})      // SATYA - MODELO: UNSCHIME
    //aAdd(aRET, {"S3B10290",     "H", cCompl+"'V9130400')"})      // MILUZ - MODELO: HRB1068200 (Será utilizado modelo Orion: EAV8525400 / EAV9130400)
    aAdd(aRET, {"PRM044011",    "H", cCompl+"'QGH5230900')"})    // FLOW PACKS - MODELO: QGH5230900 *
    aAdd(aRET, {"S730100004",   "H", cCompl+"'EAV1459702')"})    // FLOW PACKS - MODELO: EAV1459702
    aAdd(aRET, {"S70110104",    "H", cCompl+"'HRB8045002')"})    // FLOW PACKS - MODELO: HRB8045002
    aAdd(aRET, {"HRB11490",     "H", cCompl+"'HRB1068200')"})    // MODELO: HRB1068200 - Miluz - Verificar qual produto deste layout
    aAdd(aRET, {"HRB15036",     "H", cCompl+"'NHA6862601')"})    // MODELO: NHA6862601 - Miluz - Verificar qual produto deste layout
    aAdd(aRET, {"SCE367773",    "H", cCompl+"'HUETIQUETAS')"})   // MODELO: HU - ETIQUETAS
*/  
    if !Empty(SB1->B1_XMODETI)    
        cRET := cCompl+"('"+ALLTRIM(SB1->B1_XMODETI)+"')"
    Endif 

Return cRET




/*/{Protheus.doc} ConfEtiq
    description
    Configuração principal para Etiquetas
    @type function
    @version 
    @author Valdemir Jose
    @since 04/09/2020
    @param pNome, param_type, param_description
    @return return_type, return_description
/*/
User Function ConfEtiq(pNome)
    Local oPrinter := nil 
    Local lVis     := .F.       // faço uma pergunta se deseja visualizar ou imprimir direto
    Local _nQtdCop := 1
    Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAliasLif   	:= pNome+cHora+ cMinutos+cSegundos+Alltrim(GetComputerName())

    If IsInCallStack("U_OPETQ002")
        _nQtdCop := MV_PAR04
    EndIf

    MAKEDIR( "C:\Temp\" )

    lServer  := .T.
    lVis := ( __cUserId $ AllTrim(GetMv("STFSLIB001",,"000639/001566")))
    if lVis
       cPathTMP := "C:\Temp\" 
       lServer  := .F.
    Else 
       cPathTMP := "/spool/" 
    Endif 

    cPathTMP := "C:\Temp\"    // Remover depois -

    //		  Ultimo ajuste - Valdemir Rabelo 09/03/2022
    oPrinter := FWMSPrinter():New(cAliasLif, ;      // < cFilePrintert >
                iif(!lVis,IMP_SPOOL,IMP_PDF), ;     // [ nDevice]
                lAdjustToLegacy, ;                  // [ lAdjustToLegacy]
                cPathTMP, ;                         // [ cPathInServer]
                lDisableSetup, ;                    // [ lDisabeSetup ]
                .F.,;                               // [ lTReport]
                 ,;                                 // [ @oPrintSetup]
                 UPPER(cUserName) ,;                // [ cPrinter]
                  lServer,;                         // [ lServer]
                   .T.,;                            // [ lPDFAsPNG]
                   .F.,;                            // [ lRaw]
                   .F.,;                            // [ lViewPDF]
                   _nQtdCop )                       // [ nQtdCopy]

    if lVis
        //Abre configuração de impressora
        //oPrinter:Setup()
        oPrinter:setDevice( IMP_PDF ) 
        oPrinter:lserver  := .F.
        oPrinter:lViewPDF := .T.
    Endif 

    if File("C:\Temp\"+pNome+".pdf")
       if !lVis
          FErase("C:\Temp\"+pNome+".pdf")          
       endif 
    endif

    oPrinter:setDevice( if(!lVis,IMP_SPOOL, IMP_PDF) )          // Define se envia para impressora ou visualiza em tela
    oPrinter:SetResolution(72)                                  // Resolução
    oPrinter:SetParm( "-RFS")                                   // Parâmetro de qualidade de fonte
    if !lServer
       oPrinter:cPathPDF := cPathTMP                              // Local a ser salvo o arquivo
    Endif    
    If UPPER(pNome)=="EAV1459702"  .Or.;
        UPPER(pNome)=="HRB8045002" .Or.;
        UPPER(pNome)=="QGH5230900"
        oPrinter:cPrinter := "VIDEOJET"                               // Forço a impressora que deverá ir a impressão
    Else
        If IsInCallStack("U_OPETQ001")
            oPrinter:cPrinter := "PEQBLISTER"                               // Forço a impressora que deverá ir a impressão
        ElseIf (IsInCallStack("U_EtiqueHU") ;
           .or. IsInCallStack("U_STFSFA30") )         // Valdemir Rabelo 10/11/2020 - Ticket: 20200922007743           
            oPrinter:cPrinter := "ETIQUETA"                               // Forço a impressora que deverá ir a impressão
        Elseif IsInCallStack("U_STEMBAM1")            // Valdemir Rabelo 24/11/2020 - Ticket: 20201116010613
            oPrinter:lserver  := .T.
            oPrinter:cPrinter := "PORTATIL" 
        Else
            oPrinter:cPrinter := UPPER(cUserName)                               // Forço a impressora que deverá ir a impressão
        EndIf
    EndIf
    oPrinter:SetMargin(001,001,001,001)                         // Margem de impressão

Return oPrinter                                                 // Retorno o objeto preparado a ser apresentado



/*/{Protheus.doc} STWFPRVC
description
Rotina padronizada de WFs 
@type function
@version 
@author Valdemir Jose
@since 20/10/2020
@param _aMsg, param_type, param_description
@param _cAssunto, param_type, param_description
@param _cEMail, param_type, param_description
@param _cCopia, param_type, param_description
@return return_type, return_description
/*/
User Function STWFPRVC(_aMsg, _cAssunto,_cEMail, _cCopia)
    Local _cFrom    := "protheus@steck.com.br"
    Local cFuncSent := "STWFPRVC"
    Local i         := 0
    Local cArq      := ""
    Local cMsg      := ""
    Local _nLin
    Local cAttach   := ''

    // Definicao do cabecalho do email                                             ³
    cMsg := ""
    cMsg += '<html>'
    cMsg += '<head>'
    cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
    cMsg += '</head>'
    cMsg += '<body>'
    cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
    cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
    cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

    // Definicao do texto/detalhe do email                                         ³
    For _nLin := 1 to Len(_aMsg)
        IF (_nLin/2) == Int( _nLin/2 )
            cMsg += '<TR BgColor=#B0E2FF>'
        Else
            cMsg += '<TR BgColor=#FFFFFF>'
        EndIF
        cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
        cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
        cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
        cMsg += '</TR>'
    Next

    // Definicao do rodape do email                                                ³
    cMsg += '</Table>'
    cMsg += '<P>'
    cMsg += '<Table align="center">'
    cMsg += '<tr>'
    cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
    cMsg += '</tr>'
    cMsg += '</Table>'
    cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
    cMsg += '</body>'
    cMsg += '</html>'

    If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
        MsgInfo("Email não Enviado..!!!!")
    EndIf

Return



/*/{Protheus.doc} getPedVen
description
Rotina que verifica a existencia do pedido na PP8
@type function
@version 
@author Valdemir Jose
@since 20/10/2020
@param pPedido, param_type, param_description
@return return_type, return_description
/*/
User Function getPedVen(pPedido)
    Local lRET := .F.
    Local cQry := ""

    cQry += "SELECT COUNT(*) REG " + CRLF
    cQry += "FROM " + RETSQLNAME("PP8") + " A " + CRLF
    cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
    cQry += " AND A.PP8_PEDVEN='" +pPedido+ "' " + CRLF

    if SELECT("TPED") > 0
        TPED->( DBCLOSEAREA() )
    endif

    tcQuery cQry New Alias "TPED"

    lRET := (TPED->REG > 0)

    if SELECT("TPED") > 0
        TPED->( DBCLOSEAREA() )
    endif 

Return lRET 



/*/{Protheus.doc} STUltNum
description
Rotina para gerar um sequencial
@type function
@version 
@author Valdemir Jose
@since 23/10/2020
@param cTab, character, param_description
@param cCampo, character, param_description
@param lSoma1, logical, param_description
@return return_type, return_description
/*/
User Function STUltNum(cTab, cCampo, lSoma1)
    Local aArea       := GetArea()
    Local cCodFull    := ""
    Local cCodAux     := ""
    Local cQuery      := ""
    Local nTamCampo   := 0
    Default lSoma1    := .T.
      
    //Definindo o código atual
    nTamCampo := TamSX3(cCampo)[01]
    cCodAux   := StrTran(cCodAux, ' ', '0')
    if Empty(cCodAux)
       cCodAux := "0"
    endif 
      
    //Faço a consulta para pegar as informações
    cQuery := " SELECT "
    cQuery += "   ISNULL(MAX("+cCampo+"), '"+cCodAux+"') AS MAXIMO "
    cQuery += " FROM "
    cQuery += "   "+RetSQLName(cTab)+" TAB "
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "QRY_TAB"
      
    //Se não tiver em branco
    If !Empty(QRY_TAB->MAXIMO)
        cCodAux := QRY_TAB->MAXIMO
        cCodAux := PadL(cCodAux, nTamCampo, "0")
    EndIf
      
    //Se for para atualizar, soma 1 na variável
    If lSoma1
        cCodAux := Soma1(cCodAux)
    EndIf
      
    //Definindo o código de retorno
    cCodFull := cCodAux
      
    QRY_TAB->(DbCloseArea())
    RestArea(aArea)
Return cCodFull
