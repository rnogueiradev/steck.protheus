#INCLUDE "rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TbiConn.ch"

//-----------------------//
//CADASTRO:
//-----------------------//
/*==========================================================================
|Funcao    | FCADZ92           | Flávia Rocha          | Data | 23/11/2021 |
============================================================================
|Descricao | Cadastro Agrupamento de Produtos Nível 1      				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
//FR - 23/11/2021 - Ticket #20211119024862 - Nova estrutura de oferta Steck
// + APOEMA para 2022
==========================================================================*/
User Function fCadZ92()
	Local cAlias
	Local aCampos
	//Local aCores
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina   := {{"Pesquisar" 		,"AxPesqui"    ,0 ,1} ,;
    	         		{"Visualizar"		,"U_fCadAgrup"  ,0 ,2} ,;
    	         		{"Incluir"          ,"U_fCadAgrup"  ,0 ,3} ,;  
            	 		{"Alterar" 			,"U_fCadAgrup"  ,0 ,4} ,;            	 	
            	 		{"Excluir" 			,"U_fCadAgrup"  ,0 ,5} } //,;            	 		

	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro Agrupamento Produtos Nivel 2"
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z92"
	aCampos 	:= {}
		  
	
	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(1)) 
	xArea       := GetArea()	
	mBrowse( 6,1,22,75,cAlias)
	
	RestArea(xArea)

Return


/*==========================================================================
|Funcao    | fCadZ93           | Flávia Rocha          | Data | 23/11/2021 |
============================================================================
|Descricao | Cadastro Agrupamento de Produtos Nível 3      				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fCadZ93()
	Local cAlias
	Local aCampos	
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina   := {{"Pesquisar" 		,"AxPesqui"    ,0 ,1} ,;
    	         		{"Visualizar"		,"U_fCadAgrup"  ,0 ,2} ,;
    	         		{"Incluir"          ,"U_fCadAgrup"  ,0 ,3} ,;  
            	 		{"Alterar" 			,"U_fCadAgrup"  ,0 ,4} ,;            	 	
            	 		{"Excluir" 			,"U_fCadAgrup"  ,0 ,5} } //,;
            	 		//{"Legenda"  		,"U_fAgrupLg" ,0 ,6}  }

	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro Agrupamento Produtos Nivel 3"
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z93"
	aCampos 	:= {}
	    
	
	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(1)) 
	xArea       := GetArea()	
	mBrowse( 6,1,22,75,cAlias)
	
	RestArea(xArea)

Return


/*==========================================================================
|Funcao    | fCadAgrup           | Flávia Rocha          | Data | 26/04/2021|
============================================================================
|Descricao | Tela cadastro de Agrupamentos (serve para nivel 1 e 2)		   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fCadAgrup(cAlias,nRec,nOpc)
	Local   aPos1
	Local   aPos2
	Local   aPos3
	Local   aSizeAut
	Local   xArea
		
	Local   nLin1
	Local   nLin2
	Local   nCol1
	Local   nCol2
	Local   nOpca 

	Private oFont2
	Private oBtOk	
	Private oBtCancela	
	Private oOk   
	Private oNo
	Private oTela
	
	Private lOk
	Private lSai    
	Private lCriouVar   
	Private lEdita
	Private lClicaBotao
		     
	Private cOpcao      := ""
	Private cFili		:= ""
	Private cCodGrp     := Space(4)
	Private cDescGrp    := Space(30)
	Private nPesGrp     //:= 0
	
	Private cNomusr     := Space(40)
			
	Private aObjects:= {}								
	Private aSize   := {}  				
	Private aInfo   := {}								
	Private aPos    := {}		 

	Static oDlg
	
	oFont2		:= TFont():New("Arial",,014,,.F.,,,,,.F.,.F.)	
	oBtOk     
	oBtCancela
	
	lOk       	:= .T.
	lSai		:= .F.

	oNeutro    	:= LoadBitmap( GetResources(), "ENABLE" )
	oCons    	:= LoadBitmap( GetResources(), "BR_AMARELO" ) 
	oDev    	:= LoadBitmap( GetResources(), "BR_AZUL" )   
	oEncerr     := LoadBitmap( GetResources(), "BR_PRETO" )
	oOk       	:= LoadBitmap( GetResources(), "LBOK" )
	oNo       	:= LoadBitmap( GetResources(), "LBNO" )
	bLineIT   	:= Nil
	
	lEdita	    := .T.   	//FR - USADA NA CHAMADA REGTOMEMORY
	
	aPos1       := {}
	aPos2       := {}
	aPos3       := {}
	
	xArea       := {}
		
	cOpcao      := ""
	//cFili		:= Iif(nOpc = 3, xFilial("Z84"), Z84->Z84_FILIAL)
	
		
	oTela
	nOpca := 1
	
				
	If nOpc = 3 
		cOpcao := "INCLUSÃO"		
		lEdita := .T.
		
	ElseIf nOpc = 4
		cOpcao      := "ALTERAÇÃO"
		lEdita      := .T.  
		   
	Elseif nOpc = 5
		cOpcao := "EXCLUSÃO"
		lEdita := .F. 

		If !MsgYesNo("Confirma a Exclusão ? ")		
			Return  	
		Endif
			
	Else
		cOpcao := "VISUALIZAÇÃO"
		lEdita := .F.	
	Endif 
	
	xArea       := GetArea()
	//Z84->(OrdSetFocus(1)) 		
                   
	//RegToMemory("Z84",Iif(nOpc <> 3,.F.,lEdita))   				//Cabeçalho da Contagem, chama as variáveis de memória para os gets	

	If cAlias == "Z92"

		Z92->(OrdSetFocus(1)) 
		RegToMemory("Z92",Iif(nOpc <> 3,.F.,lEdita)) 
		cFili		:= Iif(nOpc = 3, xFilial("Z92"), Z92->Z92_FILIAL)
		cCodGrp     := Iif(nOpc = 3, M->Z92_CODGRP , Z92->Z92_CODGRP)
		cDescGrp    := Iif(nOpc = 3, M->Z92_DSCGRP , Z92->Z92_DSCGRP) 
		nPesGrp     := Iif(nOpc = 3, M->Z92_PESGRP , Z92->Z92_PESGRP) 
		cOpcao      += " - Nivel 2 "
		
	Elseif cAlias == "Z93"

		Z93->(OrdSetFocus(1)) 
		RegToMemory("Z93",Iif(nOpc <> 3,.F.,lEdita)) 
		cFili		:= Iif(nOpc = 3, xFilial("Z93"), Z93->Z93_FILIAL)
		cCodGrp     := Iif(nOpc = 3, M->Z93_CODGRP , Z93->Z93_CODGRP)
		cDescGrp    := Iif(nOpc = 3, M->Z93_DSCGRP , Z93->Z93_DSCGRP) 
		nPesGrp     := Iif(nOpc = 3, M->Z93_PESGRP , Z93->Z93_PESGRP) 
		cOpcao      += " - Nivel 3 "
		
	Endif 
	
   	aSizeAut := MsAdvSize(,.F.,400)
	/*
	//Medidas do aSizeAut:
	aSizeAut[1] =    0
	aSizeAut[2] =   30
	aSizeAut[3] =  953
	aSizeAut[4] =  446     ,	aSizeAut[5] = 1906
	aSizeAut[6] =  892
	aSizeAut[7] =    0
	aSizeAut[8] =    5
	*/
	
	//========================================//
	//GERA A DIALOG PRINCIPAL                   
	//========================================//
	nLiIni := aSizeAut[1] 		//0 
	nCoIni := aSizeAut[8] 		//5 					
	nLiFim := aSizeAut[4]+100 	//446+100=546
	nCoFim := aSizeAut[6]*2 	//892*2= 1784
	/*
	If nOpc = 6 .or. nOpc = 4 .or. nOpc = 5   //encerrar , alterar ou excluir
		If !Empty(Z84->Z84_DTFECH)  //já foi encerrada
			MsgAlert("Ordem de Manutenção Já Encerrada !!!")
			Return .F.
		Endif
	Endif	
	*/	
	DEFINE MSDIALOG oDlg TITLE "Agrupamento de Produtos - " + cOpcao From nLiIni, nCoIni  TO nLiFim, nCoFim OF oMainWnd PIXEL STYLE DS_MODALFRAME 	
	
	aPos1 := fFRTela(oDlg,"TOT") 
	//Medidas do aPos1:
	/*
	aPos1[1] 		//1
	aPos1[2]		//1
	aPos1[3]		//269.5
	aPos1[4]		//891.5
	*/
		
	//Tela com os Gets de campos
	If cAlias == "Z92"
		//oTela := MsMget():New("Z84",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.)  
		oTela := MsMget():New("Z92",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.) 
	Else
		oTela := MsMget():New("Z93",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.) 
	Endif

	oTela:Refresh() 
	
	nLin1 := aPos1[1] 	    //1
	nCol1 := aPos1[2]     	//1
	nLin2 := aPos1[3]-30	//269.5-30=239.5
	nCol2 := aPos1[4]-100 	//891.5-100=791.5    	
    		
	//DEFINE SBUTTON oBtOk      FROM nLin2,nCol2-80 TYPE 1 OF oDlg  ENABLE ACTION  Processa( {|| lOk := fGRaVZ84(nOpc,cCodEqp,cCodMot,dDtFech), Iif(lOk,oDlg:End(),.F.) } )		
	DEFINE SBUTTON oBtOk      FROM nLin2,nCol2-80 TYPE 1 OF oDlg  ENABLE ACTION  Processa( {|| lOk := fGRaVZNov(cAlias,nOpc), Iif(lOk,oDlg:End(),.F.) } )		
	DEFINE SBUTTON oBtCancela FROM nLin2,nCol2-40 TYPE 2 OF oDlg  ENABLE ACTION  ( iif(fFecha(nOpc),oDlg:End(),.F.))  

	ACTIVATE MSDIALOG oDlg Centered

	RestArea( xArea ) 
    
Return


//-----------------------//
//GRAVAÇÃO:
//-----------------------//

/*==========================================================================
|Funcao    | fGravZNov             | Flávia Rocha       | Data | 27/04/2021|
============================================================================
|Descricao | Efetua validações e chama rotinas para gravação das           |
|          | informações de tela - tanto para Z92 qto Z93                  |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fGRaVZNov(xAlias,xOpc)
	Local lContinua   := .T.
    Local lDel        := .F.
	Local lNew        := .F.	
	Local cPrefCpo    := ""
	Local nInd        := 0	
	
	If xAlias == "Z92"
		cPrefCpo := "Z92_"
	Else
		cPrefCpo := "Z93_"
	Endif 
	  
	If xOpc = 3
		lNew     := .T. //lock que será feito na tabela, .T. para inclusão, .F. para alteração	
				
	Elseif xOpc = 4 .or. xOPc = 5 .or. xOpc = 6
		lNew := .F.
	
		If xOpc = 5
			lDel := .T.
		Endif		

	Endif
	    
	If xOpc <> 2
		cMsg      := 'Campos Obrigatórios: ' + CHR(13) + CHR(10) 
		
		If xOpc = 3 //.or. xOpc = 4   	//Incluir ou alterar
				
			//If Empty(M->Z84_CODEQP)
			If Empty(M->&(cPrefCpo+"CODGRP"))
		 		cMsg+= "É Necessário Preencher o campo 'Codigo Grupo' "+ CHR(13) + CHR(10) 
				lContinua  := .F.
			Endif
			
			If lContinua
				//If Empty(M->Z84_CODMOT)
				If Empty(M->&(cPrefCpo+"DSCGRP"))
			 		cMsg+= "É Necessário Preencher o campo 'Descrição Grupo' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif
			Endif
					
		Endif
				
		If lContinua
			//----------------------------------------------//
			//Checagem dos campos obrigatórios do cabeçalho
			//----------------------------------------------//
			SX3->(OrdSetFocus(2))
			//For nInd := 1 To Z84->(FCount())
			For nInd := 1 To (xAlias)->(FCount())
				cCpoCab := (xAlias)->(FieldName(nInd))
				
				If SX3->(dbSeek ( cCpoCab ) )
					If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V"
							
						If X3Obrigat(SX3->X3_CAMPO)     //se for obrigatório						
							If Empty( M->(&(cCpoCab)) ) 
								cMsg += "Campo: '" + SX3->X3_TITULO + "' -> Sem Preenchimento..." + CHR(13) + CHR(10)
								lContinua := .F.					
							EndIf								
						Endif
						
					Endif
				Endif
							
			Next
		Endif
		
		//----------------------------------------------//
		//Checagens finais antes da gravação de fato  
		//----------------------------------------------//	    
	   	If lContinua
		  
	   		lContinua := GrvCpoMem(xAlias,lNew,lDel) 		   		
			
		Endif
	
		If !lContinua			
			AutoGrLog(cMsg)
			MostraErro()
		Endif
		
	Else
		lContinua := .T.
	Endif

Return(lContinua)



/*==========================================================================
|Funcao    | GrvCpoMem            | Flávia Rocha        | Data | 27/04/2021|
============================================================================
|Descricao | Grava os campos de memória                                    |
|          | Usada na gravação da Ordem de Manutenção                      |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function GrvCpoMem(xAlias,xLock,xDel)	
	Local nInd		:= 0
	Local xConteudo := ""	
	Local lGravou   := .F.
	Local xArea     := GetArea() 

	DbSelectArea(xAlias)
	Begin Transaction
		&(xAlias)->(RecLock(xAlias,xLock))
		If xDel == .T. .AND. xLock == .F.
			&(xAlias)->(dbDelete())
			lGravou := .T.
		Else
			For nInd := 1 To &(xAlias)->(FCount())
				cCpoDest := &(xAlias)->(FieldName(nInd))
				If &(xAlias)->(FieldPos(cCpoDest)) > 0

					If "FILIAL" $ cCpoDest
						M->(&(cCpoDest)) := xFilial(xAlias)
						xConteudo        := xFilial(xAlias) 
						FieldPut(FieldPos(cCpoDest), xConteudo )			
					
					Else
						FieldPut(FieldPos(cCpoDest), M->(&(cCpoDest)) )			
					EndIf	
					
				EndIf
			Next
		
			&(xAlias)->(dbCommit())
			&(xAlias)->(MsUnlock())
			lGravou := .T.
		EndIf
		
	End Transaction
	
	RestArea(xArea)		

Return(lGravou) 



//-----------------------//
//VALIDAÇÃO:
//-----------------------//

/*==========================================================================
|Funcao    | fFecha             | Flávia Rocha          | Data | 31/08/2015|
============================================================================
|Descricao | Função auxiliar que determina o fechamento da Dialog Principal|
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fFecha(xOpc)
	Local lFecha := .F.
	
	If xOpc <> 5 .and. xOpc <> 2  		//qdo for Excluir ou Visualizar, não faz a pergunta
		If MsgYesNo("Deseja Realmente Sair ? ")		
			lFecha := .T.  	
		Endif
	Else
		lFecha := .T.
	Endif
	
Return(lFecha)  




//-----------------------//
//FUNÇÕES AUXILIARES:
//-----------------------//

/*==========================================================================
|Funcao    | fFRTela           | Flávia Rocha          | Data | 26/08/2015 |
============================================================================
|Descricao  | Função para posicionar todo o objeto na Dialog  			   | 
|Parametros | oBjet = Objeto a ser dimencionado                            |
|           | cTipo = Tipo de posicionamento                               |
|         	|		"UP"   = Posiciona na parte de cima da Dialog          |
|          	|		"DOWN" = Posiciona na parte de baixo da Dialog         |
|          	|		"TOT"  = Posiciona em toda Dialog                      |
|           |                                                              |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fFRTela(oBjet,cTipo,xVerMDI)

Local aPosicao := {}

Do Case
	Case cTipo = "TOT"
		aPosicao    := {1,1,(oBjet:nClientHeight-6)/2,(oBjet:nClientWidth-4)/2}
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)
		EndIf
		
	Case cTipo = "UP"
		aPosicao:= {1,1,(oBjet:nClientHeight-6)/4-1,(oBjet:nClientWidth-4)/2}
		//Versão MDI
		If Empty(xVerMDI)
			If SetMdiChild()
				aPosicao[3] += 4
				aPosicao[4] += 3
			EndIf
		EndIf
		
	Case cTipo = "DOWN"
		aPosicao:= {(oBjet:nClientHeight-6)/4+1,1,(oBjet:nClientHeight-6)/4-2,(oBjet:nClientWidth-4)/2}
		//Versão MDI
		If Empty(xVerMDI)
			aPosicao[3] -= Iif(SetMdiChild(),14,0)			
		EndIf

End Case

Return(aPosicao)


/*==========================================================================
|Funcao    | FRAviso            | Flávia Rocha          | Data | 23/04/2021|
============================================================================
|Descricao | Interface/Dialog de Aviso.                 				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function FRAviso(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
Local ny        := 0
Local nx        := 0
Local aSize  := {  {134,304,35,155,35,113,51},;  // Tamanho 1
				{134,450,35,155,35,185,51},; 	// Tamanho 2
				{227,450,35,210,65,185,99} } 	// Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet 
Local nPass := 0
Private oDlgAviso
Private nOpcAviso := 0

DEFAULT lEdit := .F.
If lEdit
	nSize := 3
EndIf

lMsHelpAuto := .F.

cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando for rotina automatica, envia o aviso ao Log.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('lMsHelpAuto') == 'U'
	lMsHelpAuto := .F.
EndIf

If !lMsHelpAuto
	If nSize == Nil
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o numero de botoes Max. 5 e o tamanho da Msg.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  Len(aBotoes) > 3
			If Len(cMensagem) > 286
				nSize := 3
			Else
				nSize := 2
			EndIf
		Else
			Do Case
				Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
					nSize := 2
				Case Len(cMensagem) >= 250
					nSize := 3
				OtherWise
					nSize := 1
			EndCase
		EndIf
	EndIf
	If nSize <= 3
		nLinha := nSize
	Else
		nLinha := 3
	EndIf
	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption OF oDlgAviso PIXEL
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
	If cBitmap <> Nil

		@ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	Else
		@ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	EndIf
	If nSize < 3
		@ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
	Else
		If !lEdit
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
		Else
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] MEMO
		EndIf
		
	EndIf
	If Len(aBotoes) > 1 .Or. nTimer <> Nil
		TButton():New(1000,1000," ",oDlgAviso,{||Nil},32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	EndIf
	ny := (aSize[nLinha][2]/2)-36
	For nx:=1 to Len(aBotoes)
		cAction:="{||nOpcAviso:="+Str(Len(aBotoes)-nx+1)+",oDlgAviso:End()}"
		bAction:=&(cAction)
		cMsgButton:= OemToAnsi(AllTrim(aBotoes[Len(aBotoes)-nx+1]))
		cMsgButton:= IF(  "&" $ Alltrim(cMsgButton), cMsgButton ,  "&"+cMsgButton )
		TButton():New(aSize[nLinha][7],ny,cMsgButton, oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		ny -= 35
	Next nx
	If nTimer <> Nil
		oTimer := TTimer():New(nTimer,{|| nOpcAviso := nOpcPadrao,IIf(nPass==0,nPass++,oDlgAviso:End()) },oDlgAviso)
		oTimer:Activate()       
		bAction:= {|| oTimer:DeActivate() }
		TButton():New(aSize[nLinha][7],ny,"Timer off", oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Endif
	ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
	If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
		cMensagem += " " + aBotoes[nRotAutDefault]
		nOpcAviso := nRotAutDefault
	Endif
	ConOut(Repl("*",40))
	ConOut(cCaption)
	ConOut(cMensagem)
	ConOut(Repl("*",40))
	AutoGrLog(cCaption)
	AutoGrLog(cMensagem)
EndIf

Return (nOpcAviso)


/*====================================================================================\
|Programa  | STIMPZ92        | Autor | Flávia Rocha              | Data | 24/11/2021  |
|=====================================================================================|
|Descrição | Importa planilha csv com cadastro de grupos novos, para gravar nas       |
|          | tabelas:                                                                 |
|          | Z92 - Cadastro Agrupamento Nivel 2;                                      |
|          | Z93 - Cadastro Agrupamento Nivel 2;                                      |
|          | SBM - Grupo novo gerado pela Z92;                                        |
|          | SB1 - Código do grupo (Z92) atualizado no BM_GRUPO                       |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPZ92()
Local _cLog    := ""
Local cArquivo := ""
	
	//RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	
	
	_cLog:= "IMPORTAÇÃO DADOS PARA TABELAS: Z92 / Z93 "+CHR(13) +CHR(10)

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)  //d:\temp\steck\teste_politica_preco.csv
		
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[STIMPZ92] - ATENCAO")
		Return
	Else
		MsgRun( "Atualizando Dados, aguarde...",, {|| fAtuZ92(cArquivo)} )		
	EndIf

	Reset Environment

Return

/************************************/
Static Function fAtuZ92(cArquivo)
/************************************/
Local cLinha  	:= ""
Local cItem   	:= ""
Local oDlg
Local i       	:= 0
Local lPrim   	:= .T.
Local aCampos 	:= {}
Local aDados  	:= {}
Local _cLog   	:= ""
Local _cCodGrp2 := ""
Local _cCodGrp3 := ""
Local _cB1Cod   := ""
Local _cB1Grp   := ""
Local _cDesBMGrp:= ""
Local _cB1XCateg:= ""
Local _cDscGrp2 := ""
Local _cDscGrp3 := ""
Local _nPesGrp2 := 0
Local _cNewSBM  := ""
//Local _nPesGrp3 := 0

Local lNovo		:= .F.
Local lNovoGrp  := .F.
Local lSeekSBM  := .F.
Local aSeekSBM  := {}

	

FT_FUSE(cArquivo)                   // abrir arquivo
ProcRegua(FT_FLASTREC())             // quantos registros ler
FT_FGOTOP()                          // ir para o topo do arquivo
While !FT_FEOF()                     // faça enquanto não for fim do arquivo

	IncProc("Lendo arquivo texto...")
		
	cLinha := FT_FREADLN()           // lendo a linha
		
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf

	FT_FSKIP()
EndDo

ProcRegua(Len(aDados))

DbSelectArea("Z92")
Z92->(DbSetOrder(1))  //Z92_FILIAL+Z92_CODGRP  
	
_nQtd := 0

For i:=1 to Len(aDados)  //ler linhas da array
	
	conout(i)
	lNovoGrp := .F.
	//--------------//
	//GRAVA Z93
	//--------------//
	//pega a descrição:
	_cDscGrp3 := Alltrim(UPPER(aDados[i,2])) 
	
	
	DbSelectArea("Z93")
	Z93->(OrdSetFocus(2))  //Z92_DSCGRP - Descrição

	lNovo := .F.

	//pesquisa pela descrição:
	If Z93->( DbSeek(_cDscGrp3) )
		lNovo := .F.
		_cCodGrp3 := Z93->Z93_CODGRP		
	Else
		lNovo := .T.
		_cCodGrp3 := fProxZ93()  //PARA Z93 CRIA SEQUENCIAL
	Endif

	If lNovo
		Z93->(RecLock("Z93",lNovo)) 
		Z93->Z93_CODGRP := _cCodGrp3
		Z93->Z93_DSCGRP := _cDscGrp3			//DESCRIÇÃO
		//Z93->Z93_PESGRP := aDados[i,5]		//PESO DO GRUPO
		Z93->(MsUnLock())
	Endif 

	//-------------//
	//GRAVA Z92
	//-------------//
	lNovo := .F.
	_cCodGrp2 := Alltrim(UPPER(aDados[i,3]))	//código do grupo nivel 2
	//_cCodGrp2 := PADR(_cCodGrp2,4)

	DbSelectArea("Z92")	
	Z92->(OrdSetfocus(1))		//Z92_FILIAL + Z92_CODGRP
	//pesquisa pelo código (está na planilha)
	If Z92->(DbSeek(xFilial("Z92")+ _cCodGrp2))
		lNovo     := .F.
		//_cDscGrp2 := Z92->Z92_DSCGRP
		//_nPesGrp2 := Z92->Z92_PESGRP
	Else
		lNovo     := .T.
		_cDscGrp2 := UPPER(Alltrim(aDados[i,4]))
		_nPesGrp2 := Val(aDados[i,5])
	Endif 

	If lNovo 
		Z92->(RecLock("Z92",lNovo))
		Z92->Z92_CODGRP := _cCodGrp2		 	//CÓDIGO
		Z92->Z92_DSCGRP := _cDscGrp2			//DESCRIÇÃO
		Z92->Z92_PESGRP := _nPesGrp2			//PESO DO GRUPO
		Z92->(MsUnLock())
	Endif 
	//GRAVA NO SB1 a categoria de produto (BÁSICO, PRESCRITO, LANÇAMENTO...)
	_cDesBMGrp := UPPER(ALLTRIM(aDados[i,7]))  //descrição grupo (BM_GRUPO)

	If Alltrim(UPPER(aDados[i,9])) $ "PB/PL/PP"
		_cB1XCateg := Alltrim(UPPER(aDados[i,9]))	
	Else 
		_cB1XCateg := ""
	Endif 

	_cB1Cod    := Alltrim(aDados[i,10])	
	
	/*
	SB1->(OrdSetFocus(1)) //B1_FILIAL + B1_COD
	If SB1->(Dbseek(xFilial("SB1") + _cB1Cod))
		_cB1Grp   := SB1->B1_GRUPO
		
		RecLock("SB1", .F.)
		SB1->B1_XCATEG := _cB1XCateg
		SB1->B1_XATIVID := "PTSG2"
		SB1->(MsUnlock())	

	Endif
	*/

	DbSelectArea("SBM")
	SBM->(OrdSetFocus(2)) //BM_FILIAL + BM_DESC
	//LOCALIZA O GRUPO para gravar as informações nos campos BM_XAGRUP2 e BM_XAGRUP3
	//pesquisa pela descrição que está na planilha 
	//If SBM->(Dbseek(xFilial("SBM") + _cDesBMGrp))  
	lSeekSBM := .F.
	aSeekSBM := {}
	aSeekSBM := fTemSBM(_cDesBMGrp)
	/*
	Aadd(aRet, XF3TAB->BM_GRUPO)
	Aadd(aRet, XF3TAB->BM_DESC)
	Aadd(aRet, XF3TAB->RECSBM)
	Aadd(aRet, lTem)
	*/
	If Len(aSeekSBM) > 0
		lSeekSBM := aSeekSBM[4]
	Endif 

	If lSeekSBM
			
		//caso exista, alimenta apenas os campos novos de agrupamento
		lNovoGrp := .F.

		SBM->( Dbgoto(aSeekSBM[3]) )
		_cNewSBM        := SBM->BM_GRUPO

		RecLock("SBM" , .F.)			
		SBM->BM_XAGRUP2 := _cCodGrp2
		SBM->BM_XAGRUP3 := _cCodGrp3
		SBM->(MsUnlock())
		
		
	Else
		//caso não exista, cria um novo grupo
		lNovoGrp := .T.
		_cNewSBM := fProxSBM()		
		RecLock("SBM" , .T.)
		SBM->BM_GRUPO   := _cNewSBM
		SBM->BM_DESC    := Alltrim(UPPER(_cDesBMGrp))
		SBM->BM_XAGRUP2 := _cCodGrp2
		SBM->BM_XAGRUP3 := _cCodGrp3
		SBM->(MsUnlock())
	Endif 

	//atualiza SB1
	SB1->(OrdSetFocus(1)) //B1_FILIAL + B1_COD
	If SB1->(Dbseek(xFilial("SB1") + _cB1Cod))
		_cB1Grp   := SB1->B1_GRUPO
		
		RecLock("SB1", .F.)

		//se for diferente do que já está no B1_GRUPO, atualiza para o novo grupo
		//If lNovoGrp
			//If Alltrim(_cB1Grp) <> Alltrim(_cNewSBM)
				SB1->B1_GRUPO  :=  _cNewSBM
			//Endif 
		//Endif 

		SB1->B1_XCATEG := _cB1XCateg
		SB1->B1_XATIVID := "PTSG2"
		SB1->(MsUnlock()) 
	Endif 
	
Next
	
FT_FUSE()

_cLog := "Processo Finalizado, OK"
@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Processo Finalizado, OK'
@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

MsgInfo("Processo Finalizado, OK")

Return


//==================================================================================//
//Função  : fProxZ93  
//Autoria : Flávia Rocha
//Data    : 28/10/2021
//Objetivo: Função para trazer o próximo código para grupo da tabela Z93
//==================================================================================//
Static Function fProxZ93()
Local cQuery := ""
Local cCodRet:= ""

cQuery := " SELECT MAX(Z93_CODGRP) CODIGO
cQuery += " FROM " + RetSqlname("Z93") + " Z93 "
cQuery += " WHERE Z93.D_E_L_E_T_=' '  "

MemoWrite("D:\QUERY\PROXZ93.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	
	cCodRet := XF3TAB->CODIGO
	cCodRet := SOMA1(cCodRet)
	
Endif

If Empty(cCodRet)
	cCodRet := "0001" 	 
Endif 

Z93->(OrdSetFocus(1))
While Z93->( DbSeek( xFilial( "Z93" ) + cCodRet ) )
   ConfirmSX8()   
   cCodRet := SOMA1(cCodRet)
Enddo

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(cCodRet)


//==================================================================================//
//Função  : fTemSBM  
//Autoria : Flávia Rocha
//Data    : 06/12/2021
//Objetivo: Função para ver se já existe no SBM grupo com a descrição informada
//==================================================================================//
Static Function fTemSBM(_cDesBMGrp)
Local lTem   := .F.
Local cQuery := ""
Local aRet   := {}

/*
SELECT BM_GRUPO, BM_DESC
FROM SBM110 SBM 
WHERE SBM.D_E_L_E_T_=' '  
AND RTRIM(BM_DESC) = 'IDR'
*/

cQuery := " SELECT BM_GRUPO, BM_DESC, SBM.R_E_C_N_O_ RECSBM "
cQuery += " FROM " + RetSqlname("SBM") + " SBM "
cQuery += " WHERE SBM.D_E_L_E_T_ = ' '  "
cQuery += " AND RTRIM(BM_DESC) = '" + Alltrim(_cDesBMGrp) + "' "
MemoWrite("D:\QUERY\TEMSBM.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	
	lTem := .T.
	Aadd(aRet, XF3TAB->BM_GRUPO)
	Aadd(aRet, XF3TAB->BM_DESC)
	Aadd(aRet, XF3TAB->RECSBM)
	Aadd(aRet, lTem)
	
Endif

Return(aRet)


//==================================================================================//
//Função  : fProxSBM  
//Autoria : Flávia Rocha
//Data    : 06/12/2021
//Objetivo: Função para trazer o próximo código para grupo da tabela SBM
//==================================================================================//
Static Function fProxSBM()
Local cQuery := ""
Local cCodRet:= ""
//Local nGrupo := 0

/*
SELECT MAX(BM_GRUPO) FROM SBM110 WHERE D_E_L_E_T_ = '' 
AND BM_GRUPO NOT IN ('UNI', 'S48' , 'TBD', 'S42','OUT',
'ORI','OBS','MIL','LUN','LUM','LE1','IN5','DEC','999','998') 
AND BM_GRUPO >= '899'
*/

cQuery := " SELECT MAX(BM_GRUPO) CODIGO
cQuery += " FROM " + RetSqlname("SBM") + " SBM "
cQuery += " WHERE SBM.D_E_L_E_T_=' '  "
cQuery += " AND BM_GRUPO NOT IN ('UNI', 'S48' , 'TBD', 'S42','OUT', "
cQuery += " 'ORI','OBS','MIL','LUN','LUM','LE1','IN5','DEC','999','998') "
cQuery += " AND BM_GRUPO >= '899' "

MemoWrite("D:\QUERY\PROXSBM.SQL" , cQuery )

cQuery := ChangeQuery(cQuery)

Iif(Select("XF3TAB") # 0,XF3TAB->(dbCloseArea()),.T.)
	
TcQuery cQuery New Alias "XF3TAB"

XF3TAB->(dbSelectArea("XF3TAB"))
XF3TAB->(dbGoTop())
			
If !XF3TAB->(EOF())	
	
	cCodRet := Alltrim(XF3TAB->CODIGO)
	cCodRet := SOMA1(cCodRet)
	
Endif

If Empty(cCodRet)
	cCodRet := "900" 	 
Endif 

SBM->(OrdSetFocus(1))
While SBM->( DbSeek( xFilial( "SBM" ) + cCodRet ) )
   ConfirmSX8()   
   cCodRet := SOMA1(cCodRet)
Enddo

XF3TAB->(dbSelectArea("XF3TAB"))
DbCloseArea()

Return(cCodRet)

