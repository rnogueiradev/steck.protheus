#INCLUDE "rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TbiConn.ch"

//-----------------------//
//FUNÇÕES PARA CADASTRO:
//-----------------------//

/*==========================================================================
|Funcao    | fCADZ81            | Flávia Rocha          | Data | 22/04/2021|
============================================================================
|Descricao | Cadastro de Grupos de Equipamentos - CD       				   |
|Cliente   | STECK                                                         |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fCADZ81()
	Local cAlias
	Local xArea

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//
	Private aRotina := { {"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"AxVisual",0,2} ,;
						{"Incluir"		,"AxInclui",0,3} ,;
						{"Alterar"		,"AxAltera",0,4} ,;
						{"Excluir"		,"AxDeleta",0,5} }          	 	
           
	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro de Grupos de Equipamentos"
		
	cAlias  	:= "Z81"
	
	DbSelectArea(cAlias)	
	xArea := GetArea()
	(cAlias)->(OrdSetFocus(1)) 
	
	mBrowse( 6,1,22,75,cAlias)
	
	RestArea(xArea)
	
Return

/*==========================================================================
|Funcao    | fCADZ82            | Flávia Rocha          | Data | 23/04/2021|
============================================================================
|Descricao | Cadastro de Equipamentos - CD              				   |
|Cliente   | STECK                                                         |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fCADZ82()
	Local cAlias
	Local aCampos
	Local aCores
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina   := {{"Pesquisar" 		,"AxPesqui"    ,0 ,1} ,;
    	         		{"Visualizar"		,"U_fManutEQ"  ,0 ,2} ,;
    	         		{"Incluir"          ,"U_fManutEQ"  ,0 ,3} ,;  
            	 		{"Alterar" 			,"U_fManutEQ"  ,0 ,4} ,;            	 	
            	 		{"Excluir" 			,"U_fManutEQ"  ,0 ,5} ,;
            	 		{"Legenda"  		,"U_fEquiLeg"  ,0 ,7} }            	 		
            	 	
	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro de Equipamentos"
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z82"
	aCampos 	:= {}
	
	aCores := {	{ 'Z82->Z82_FIMUSR <> " " '   ,'BR_VERMELHO' },;  	//Equipamento uso finalizado 							
           		{ 'Z82->Z82_FIMUSR == " " '   ,'ENABLE'      }; 	//Equipamento em uso
           	  } 	
	
	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(1)) 
	xArea       := GetArea()	
	MBrowse( 6,1,22,75,"Z82",, "Z82_FIMUSR")
	
	RestArea(xArea)

Return


/*==========================================================================
|Funcao    | fCADZ83            | Flávia Rocha          | Data | 23/04/2021|
============================================================================
|Descricao | Cadastro de Motivos de Manutenção - CD        				   |
|Cliente   | STECK                                                         |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fCADZ83()
	Local cAlias
	Local xArea

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//
	Private aRotina := { {"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"AxVisual",0,2} ,;
						{"Incluir"		,"AxInclui",0,3} ,;     //nOpcA := AxInclui( cAlias, nReg, 3,,"U_A110LeReg()",,,,,aButtons,,,.T.)
						{"Alterar"		,"AxAltera",0,4} ,;
						{"Excluir"		,"AxDeleta",0,5} }          	 	
           
	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Cadastro de Motivos de Manutenção"
		
	cAlias  	:= "Z83"
	
	DbSelectArea(cAlias)	
	xArea := GetArea()
	(cAlias)->(OrdSetFocus(1)) 
	
	mBrowse( 6,1,22,75,cAlias)
	
	RestArea(xArea)
	
Return


/*==========================================================================
|Funcao    | FMANUTZ84         | Flávia Rocha          | Data | 23/04/2021 |
============================================================================
|Descricao | Browse das Ordens de Manutenção               				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fManutZ84()
	Local cAlias
	Local aCampos
	Local aCores
	Local xArea := {}

	//======================================================================//
	// Monta um aRotina proprio                                             //
	//======================================================================//

	Private aRotina   := {{"Pesquisar" 		,"AxPesqui"    ,0 ,1} ,;
    	         		{"Visualizar"		,"U_fManutOM"  ,0 ,2} ,;
    	         		{"Incluir"          ,"U_fManutOM"  ,0 ,3} ,;  
            	 		{"Alterar" 			,"U_fManutOM"  ,0 ,4} ,;            	 	
            	 		{"Excluir" 			,"U_fManutOM"  ,0 ,5} ,;
            	 		{"Encerrar" 		,"U_fManutOM"  ,0 ,6} ,;             	 	
            	 		{"Legenda"  		,"U_fManutLeg" ,0 ,7}  }

	Private cDelFunc	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cCadastro	:= "Ordens de Manutenção"
	Private bFiltraBrw	:= {|| Nil}	
	
	cAlias  	:= "Z84"
	aCampos 	:= {}
	
	
	//1=Retrabalho;2=Garantia;3=Recarga;4=Desmonte 
                                                                     
	aCores := {	{ 'Z84->Z84_DTFECH <> " " '   ,'BR_VERMELHO' },;  	//OM encerrada 							
           		{ 'Z84->Z84_DTFECH == " " '   ,'ENABLE'      }; 	//OM aberta
           	  } 	
	    
	
	DbSelectArea(cAlias)
	(cAlias)->(OrdSetFocus(1)) 
	xArea       := GetArea()
	MBrowse( 6,1,22,75,"Z84",, "Z84_DTFECH")
	
	RestArea(xArea)

Return

/*==========================================================================
|Funcao    | fManutLeg          | Flávia Rocha          | Data | 26/04/2021|
============================================================================
|Descricao | Legenda do Browse das Ordens de Manutenção    				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fManutLeg()

BrwLegenda(cCadastro,,{{"ENABLE"      ,"Ordem de Manutenção Em aberto"},;
   					   {"BR_VERMELHO" ,"Ordem de Manutenção Encerrada"} } )						

	                          
Return .T.

/*==========================================================================
|Funcao    | fEquiLeg          | Flávia Rocha          | Data | 29/04/2021|
============================================================================
|Descricao | Legenda do Browse dos Equipamentos          				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fEquiLeg()

BrwLegenda(cCadastro,,{{"ENABLE"      ,"Equipamento Em Uso" },;
   					   {"BR_VERMELHO" ,"Equipamento Uso Finalizado"} } )						

	                          
Return .T.  


/*==========================================================================
|Funcao    | fManutOM           | Flávia Rocha          | Data | 26/04/2021|
============================================================================
|Descricao | Tela principal de Manutenção das Ordens de Manutenção		   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fManutOM(cAlias,nRec,nOpc)
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
	Private cNumOM		:= Space(6)
	Private cCodEqp		:= Space(7)
	Private cCodMot		:= Space(3)
	Private cDescMot	:= Space(50)
	Private cNomusr     := Space(40)
	Private dDtAber     := Ctod("  /  /    ")
	Private dDtPrev     := Ctod("  /  /    ")
	Private dDtFech     := Ctod("  /  /    ")
	Private cObs        := Space(50)
	Private cRespon     := Space(30)
	Private nCustPC     := 0
	Private nCustMO     := 0
		
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
	cFili		:= Iif(nOpc = 3, xFilial("Z84"), Z84->Z84_FILIAL)
	cNumOM		:= Space(6)
	cCodEqp		:= Space(7)
	cCodMot		:= Space(3)
	cDescMot	:= Space(50)
	cNomusr     := Space(40)
	dDtAber     := Ctod("  /  /    ")
	dDtPrev     := Ctod("  /  /    ")
	dDtFech     := Ctod("  /  /    ")
	cObs        := Space(50)
	cRespon     := Space(30)
	nCustPC     := 0
	nCustMO     := 0
		
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
			
	Elseif nOpc = 6
		cOpcao    := "ENCERRAR"
		lEdita    := .F. 
			
	Else
		cOpcao := "VISUALIZAÇÃO"
		lEdita := .F.	
	Endif 
	
	xArea       := GetArea()
	Z84->(OrdSetFocus(1)) 		
                   
	RegToMemory("Z84",Iif(nOpc <> 3,.F.,lEdita))   				//Cabeçalho da Contagem, chama as variáveis de memória para os gets	
					
	cFili		:= Iif(nOpc = 3, xFilial("Z84"), Z84->Z84_FILIAL)
	cNumOM		:= Iif(nOpc = 3, M->Z84_NUMORD , Z84->Z84_NUMORD)
	cCodEqp		:= Iif(nOpc = 3, M->Z84_CODEQP , Z84->Z84_CODEQP)
	cCodMot		:= Iif(nOpc = 3, M->Z84_CODMOT , Z84->Z84_CODMOT)
	cDescMot	:= Iif(nOpc = 3, M->Z84_DSCMOT , Z84->Z84_DSCMOT)
	cNomusr     := Iif(nOpc = 3, M->Z84_NOMUSR , Z84->Z84_NOMUSR) 
	dDtAber     := Iif(nOpc = 3, M->Z84_DTABER , Z84->Z84_DTABER) 
	dDtPrev     := Iif(nOpc = 3, M->Z84_DTPREV , Z84->Z84_DTPREV) 
	dDtFech     := Iif(nOpc = 3, M->Z84_DTFECH , Z84->Z84_DTFECH)
	cObs        := Iif(nOpc = 3, M->Z84_OBS    , Z84->Z84_OBS)  
	cRespon     := Iif(nOpc = 3, M->Z84_RESPON , Z84->Z84_RESPON)  
	nCustPC     := Iif(nOpc = 3, M->Z84_CUSTPC , Z84->Z84_CUSTPC)
	nCustMO     := Iif(nOpc = 3, M->Z84_CUSTMO , Z84->Z84_CUSTMO)    
   	
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
	
	If nOpc = 6 .or. nOpc = 4 .or. nOpc = 5   //encerrar , alterar ou excluir
		If !Empty(Z84->Z84_DTFECH)  //já foi encerrada
			MsgAlert("Ordem de Manutenção Já Encerrada !!!")
			Return .F.
		Endif
	Endif	
		
	DEFINE MSDIALOG oDlg TITLE "Ordem de Manutenção - " + cOpcao From nLiIni, nCoIni  TO nLiFim, nCoFim OF oMainWnd PIXEL STYLE DS_MODALFRAME 	
	
	aPos1 := U_fFRTela(oDlg,"TOT") 
	//Medidas do aPos1:
	/*
	aPos1[1] 		//1
	aPos1[2]		//1
	aPos1[3]		//269.5
	aPos1[4]		//891.5
	*/
		
	//Tela com os Gets de campos da tabela: Z84
	oTela := MsMget():New("Z84",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.)  
	oTela:Refresh() 
	
	nLin1 := aPos1[1] 	    //1
	nCol1 := aPos1[2]     	//1
	nLin2 := aPos1[3]-30	//269.5-30=239.5
	nCol2 := aPos1[4]-100 	//891.5-100=791.5    	
    		
	DEFINE SBUTTON oBtOk      FROM nLin2,nCol2-80 TYPE 1 OF oDlg  ENABLE ACTION  Processa( {|| lOk := fGRaVZ84(nOpc,cCodEqp,cCodMot,dDtFech), Iif(lOk,oDlg:End(),.F.) } )		
	DEFINE SBUTTON oBtCancela FROM nLin2,nCol2-40 TYPE 2 OF oDlg  ENABLE ACTION  ( iif(fFecha(nOpc),oDlg:End(),.F.))  

	ACTIVATE MSDIALOG oDlg Centered

	RestArea( xArea ) 
    
Return

/*==========================================================================
|Funcao    | fManutEQ           | Flávia Rocha          | Data | 29/04/2021|
============================================================================
|Descricao | Tela principal de Cadastro de Equipamentos         		   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fManutEQ(cAlias,nRec,nOpc)
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
	Private cCodEqp		:= Space(7)
	Private cDescEq 	:= Space(50)
	Private dIniU       := Ctod("  /  /    ")
	Private dFimU       := Ctod("  /  /    ")
	Private dIniOp      := Ctod("  /  /    ")
	Private dFimOp      := Ctod("  /  /    ")
	Private cRespon     := Space(30)
		
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
	cFili		:= ""
	cCodEqp		:= Space(7)
	cDescEq 	:= Space(50)
	dIniU       := Ctod("  /  /    ")
	dFimU       := Ctod("  /  /    ")
	dIniOp      := Ctod("  /  /    ")
	dFimOp      := Ctod("  /  /    ")
	cRespon     := Space(30)
		
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
			
	Else
		cOpcao := "VISUALIZAÇÃO"
		lEdita := .F.	
	Endif 
	
	xArea       := GetArea()
	Z82->(OrdSetFocus(1)) 		
                   
	RegToMemory("Z82",Iif(nOpc <> 3,.F.,lEdita))   				//Cabeçalho da Contagem, chama as variáveis de memória para os gets	
	
	cFili		:= Iif(nOpc = 3, xFilial("Z82"), Z82->Z82_FILIAL)
	cCodEqp		:= Iif(nOpc = 3, M->Z82_CODEQP , Z82->Z82_CODEQP)
	cDescEq 	:= Iif(nOpc = 3, M->Z82_DESCRI , Z82->Z82_DESCRI)
	dIniU       := Iif(nOpc = 3, M->Z82_INIUSR , Z82->Z82_INIUSR)   //início usuário
	dFimU       := Iif(nOpc = 3, M->Z82_FIMUSR , Z82->Z82_FIMUSR)   //fim usuário
	dIniOp      := Iif(nOpc = 3, M->Z82_DTINI  , Z82->Z82_DTINI)    //início operação
	dFimOp      := Iif(nOpc = 3, M->Z82_DTFIM  , Z82->Z82_DTFIM)    //fim operação
	cRespon     := Iif(nOpc = 3, M->Z82_RESPON , Z82->Z82_RESPON)   
   	
   	//M->Z82_CODUSR := __CUSERID
   	
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
	
		
	DEFINE MSDIALOG oDlg TITLE "Cadastro Equipamentos - " + cOpcao From nLiIni, nCoIni  TO nLiFim, nCoFim OF oMainWnd PIXEL STYLE DS_MODALFRAME 	
	
	aPos1 := U_fFRTela(oDlg,"TOT") 
	//Medidas do aPos1:
	/*
	aPos1[1] 		//1
	aPos1[2]		//1
	aPos1[3]		//269.5
	aPos1[4]		//891.5
	*/
		
	//Tela com os Gets de campos da tabela: Z84
	oTela := MsMget():New("Z82",nRec,nOpc,,,,,aPos1,,3,,,,,,,,,.F.)  
	oTela:Refresh() 
	
	nLin1 := aPos1[1] 	    //1
	nCol1 := aPos1[2]     	//1
	nLin2 := aPos1[3]-30	//269.5-30=239.5
	nCol2 := aPos1[4]-100 	//891.5-100=791.5    	
    		
	DEFINE SBUTTON oBtOk      FROM nLin2,nCol2-80 TYPE 1 OF oDlg  ENABLE ACTION  Processa( {|| lOk := fGRaVZ82(nOpc,cCodEqp,dIniU), Iif(lOk,oDlg:End(),.F.) } )		
	DEFINE SBUTTON oBtCancela FROM nLin2,nCol2-40 TYPE 2 OF oDlg  ENABLE ACTION  ( iif(fFecha(nOpc),oDlg:End(),.F.))  

	ACTIVATE MSDIALOG oDlg Centered

	RestArea( xArea ) 
    
Return



//-----------------------//
//FUNÇÕES PARA GRAVAÇÃO:
//-----------------------//
/*==========================================================================
|Funcao    | fGravZ82              | Flávia Rocha       | Data | 29/04/2021|
============================================================================
|Descricao | Efetua validações e chama rotinas para gravação das           |
|          | informações de tela.                                          |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fGRaVZ82(xOpc,xCodEqp,xDIniU)           //fGRaV(nOpc,cCodEqp,cCodMot,dDtFech)
	Local lContinua   := .T.
    Local lDel        := .F.
	Local lNew        := .F.
	Local xAlias      := ""
	Local nInd
	
	xAlias := "Z82"
	  
	If xOpc = 3
		lNew     := .T. //lock que será feito na tabela, .T. para inclusão, .F. para alteração	
				
	Elseif xOpc = 4 .or. xOPc = 5 
		lNew := .F.
	
		If xOpc = 5
			lDel := .T.
		Endif		

	Endif
	    
	If xOpc <> 2
		cMsg      := 'Campos Obrigatórios: ' + CHR(13) + CHR(10) + CHR(13) + CHR(10) 
		
		If xOpc = 3 .or. xOpc = 4   	//Incluir ou alterar
		
			If Empty(M->Z82_CODEQP)
		 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Código Eqpto' "+ CHR(13) + CHR(10) 
				lContinua  := .F.
			Endif
			
			If lContinua
			
				If Empty(M->Z82_DESCRI)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Descrição' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif 
				
			Endif
			
			If lContinua
			
				If Empty(M->Z82_CODGRP)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Grupo' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif
				
			Endif
			
			If lContinua 
			
				If Empty(M->Z82_FABRIC)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Fabricante' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif
				
			Endif
			
			If lContinua
			
				If Empty(M->Z82_MODELO)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Modelo' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif
				
			Endif
			
			If lContinua 
			    If xOpc == 3 //incluir
					If Empty(M->Z82_INIUSR)
				 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Dt.Início Usuário' "+ CHR(13) + CHR(10) 
						lContinua  := .F.
					Else
						lContinua := U_fVLCPZ82(M->Z82_CODEQP,"Z82_INIUSR",M->Z82_INIUSR,M->Z82_RESPON)
					Endif
				Endif				
			Endif
			
			If lContinua
				dDini := iif(xOpc == 3 , M->Z82_INIUSR, Z82->Z82_INIUSR)
				If !Empty(M->Z82_FIMUSR)
					If M->Z82_FIMUSR < dDini  //a data de fim não pode ser menor que a data de início
						cMsg+= "Campo: 'Dt. Fim Usuário' Não Pode Ser Menor que 'Dt.Ini Usuário' "+ CHR(13) + CHR(10)
						lContinua := .F. 
					Endif 
				Endif
			Endif
			
			If lContinua
			
				If Empty(M->Z82_RESPON)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Operador' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Else
					lContinua := U_fValOper("Z82_RESPON",M->Z82_RESPON) 
					If !lContinua
						cMsg+= "Operador Não Cadastrado! "+ CHR(13) + CHR(10) 
						lContinua  := .F.	
					Endif
				Endif
				
			Endif
		
		Endif
		
							
		If lContinua
			//----------------------------------------------//
			//Checagem dos campos obrigatórios do cabeçalho
			//----------------------------------------------//
			SX3->(OrdSetFocus(2))
			For nInd := 1 To Z82->(FCount())
				cCpoCab := Z82->(FieldName(nInd))
				
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
	   		   				
	   		//grava itens - se tivesse itens, seria aqui primeira etapa	   	
	   		
		   	If lContinua //.and. xOpc <> 5 	//se gravou os itens, grava o cabeçalho
		   									//atende as opções: 3-Incluir, 4-Alterar , 5-Excluir
		   		lContinua := GrvCpoMem("Z82",lNew,lDel) 
		   	
		   	Endif	//lContinua		   			   		
		Endif 	//lContinua
	
		If !lContinua			
			AutoGrLog(cMsg)
			MostraErro()
		Endif
		
	Else
		lContinua := .T.
	Endif

Return(lContinua)

/*==========================================================================
|Funcao    | fGravZ84              | Flávia Rocha       | Data | 27/04/2021|
============================================================================
|Descricao | Efetua validações e chama rotinas para gravação das           |
|          | informações de tela.                                          |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
Static Function fGRaVZ84(xOpc,xCodEqp,xCodMot,xDtFech)           //fGRaV(nOpc,cCodEqp,cCodMot,dDtFech)
	Local lContinua   := .T.
    Local lDel        := .F.
	Local lNew        := .F.
	Local lTemRecor   := .F. 
	Local xAlias      := ""
	Local nInd
	
	xAlias := "Z84"
	  
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
		
		If xOpc = 3 .or. xOpc = 4   	//Incluir ou alterar
				
			If Empty(M->Z84_CODEQP)
		 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Equipamento' "+ CHR(13) + CHR(10) 
				lContinua  := .F.
			Endif
			
			If lContinua
				If Empty(M->Z84_CODMOT)
			 		cMsg+= "Para Incluir ou Alterar, É Necessário Preencher o campo 'Motivo' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Endif
			Endif
					
		Endif
		
		If xOpc = 6   //Encerrar 
		
			If Empty(M->Z84_DTFECH)
		 		cMsg+= "Para Encerrar, É Necessário Preencher o campo 'Dt.Fechamento' "+ CHR(13) + CHR(10) 
				lContinua  := .F.
			Else
				lContinua := U_fVLDTFECH(M->Z84_DTFECH)	
				If !lContinua
					cMsg += "Data de Fechamento Menor que a Data de Hoje!" + CHR(13) + CHR(10) 
				Endif
			Endif
			
			If lContinua
			
				If Empty(M->Z84_RESPON)
			 		cMsg+= "Para Encerrar, É Necessário Preencher o campo 'Responsável' "+ CHR(13) + CHR(10) 
					lContinua  := .F.
				Else
					lContinua := U_fValOper("Z84_RESPON",M->Z84_RESPON) 
					If !lContinua
						cMsg+= "Responsável Não Cadastrado! "+ CHR(13) + CHR(10) 
						lContinua  := .F.	
					Endif
				Endif
			Endif 
				
		Endif
						
		If lContinua
			//----------------------------------------------//
			//Checagem dos campos obrigatórios do cabeçalho
			//----------------------------------------------//
			SX3->(OrdSetFocus(2))
			For nInd := 1 To Z84->(FCount())
				cCpoCab := Z84->(FieldName(nInd))
				
				If SX3->(dbSeek ( cCpoCab ) )
					If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT != "V"
							
						If X3Obrigat(SX3->X3_CAMPO)     //se for obrigatório						
							If Empty( M->(&(cCpoCab)) ) 
								cMsg += "Cabeçalho: '" + SX3->X3_TITULO + "' -> Sem Preenchimento..." + CHR(13) + CHR(10)
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
	   		If xOpc = 5 //Verifica se pode Excluir	   	
	   			If !Empty(dDtFech)
	   				lContinua := .F.
	   				If !lContinua
	   					cMsg := "Impossível Excluir ... Ordem de Manutenção Já Encerrada !!!"
	   				Endif
	   			Endif
	   		Endif
	   				
	   		//grava itens	   	
	   		
		   	If lContinua //.and. xOpc <> 5 	//se gravou os itens, grava o cabeçalho
		   									//atende as opções: 3-Incluir, 4-Alterar , 5-Excluir
		   		lContinua := GrvCpoMem("Z84",lNew,lDel) 
		   		
		   		If lContinua .and. xOpc == 6 //se gravou e a opção foi Encerramento, verifica se tem recorrência para abrir automaticamente outra OM
		   			
		   			Z83->(OrdSetFocus(1))
		   			If Z83->(Dbseek(xFilial("Z83") + xCodMot))
		   				
		   				lTemRecor := (Z83->Z83_RECORR <> '0')  //0=Não Há;1=Semanal;2=Quinzenal;3=Mensal;4=Bimestral;5=Trimestral;6=Semestral;7=Anual;8=Bienal
		   				
		   				If lTemRecor  //abre uma nova no período da recorrência posicionada
		   					If Z83->Z83_RECORR == '1' //Semanal
		   						nDiasRecorr := 7
		   					Elseif Z83->Z83_RECORR == '2' //Quinzenal
		   						nDiasRecorr := 15
		   					Elseif Z83->Z83_RECORR == '3' //Mensal
		   						nDiasRecorr := 30
		   					Elseif Z83->Z83_RECORR == '4' //Bimestral
		   						nDiasRecorr := 60
		   					Elseif Z83->Z83_RECORR == '5' //Trimestral
		   						nDiasRecorr := 90
		   					Elseif Z83->Z83_RECORR == '6' //Semestral
		   						nDiasRecorr := 180
		   					Elseif Z83->Z83_RECORR == '7' //Anual
		   						nDiasRecorr := 365
		   					Elseif Z83->Z83_RECORR == '8' //Bienal
		   						nDiasRecorr := 730
		   					Endif
		   					
		   					fGrvEZ84(xAlias,xCodEqp,xCodMot,xDtFech,nDiasRecorr)  //abre uma nova OM ao encerrar esta
		   					
		   				Endif //ltemREcor	 
		   			
		   			Endif  //Dbseek Z83
		   			                                   
		   		Endif //lContinua e xOpc = 6-Encerrar
		   	Endif	//lContinua		   			   		
		Endif 	//lContinua
	
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
					Elseif "CODUSR" $ cCpoDest
							M->(&(cCpoDest)) := __CUSERID 
							xConteudo        := __CUSERID
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


/*==========================================================================
|Funcao    | fGrvEZ84             | Flávia Rocha        | Data | 27/04/2021|
============================================================================
|Descricao | Grava automaticamente uma nova Ordem de Manutenção            |
|          | Ao encerrar uma OM que tem recorrência                        |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/ 
Static Function fGrvEZ84(xAlias,xCodEqp,xCodMot,xDtFech,nDiasRecorr) 
	Local nInd		:= 0
	Local xConteudo := ""	
	Local lGravou   := .F.
	Local xArea     := GetArea()
	Local xLock     := .T. 
	Local cCpoDest  := ""
	Local xDtPrev   := Ctod("  /  /    ") 
	Local xDescMot  := "" 
	Local xNumOM    := ""
	Local xCodUser  := __CUSERID 
	Local xNomuser  := SUBSTR(CUSUARIO,7,15)
	
	xDtPrev := Date() + nDiasRecorr
	
	Z83->(OrdSetFocus(1))
	If Z83->(Dbseek(xFilial("Z83") + xCodMot))
		xDescMot := Z83->Z83_DESCRI
	Endif
	
	//obtém o próximo número de OM:
	xNumOM := GETSXENUM("Z84","Z84_NUMORD") 
	While Z84->( DbSeek( xFilial( "Z84" ) + xNumOM ) )
   		ConfirmSX8()
   		xNumOM := GETSXENUM("Z84","Z84_NUMORD") 
 	Enddo

	 
	DbSelectArea(xAlias)
	Begin Transaction
		&(xAlias)->(RecLock(xAlias,xLock))
		
		For nInd := 1 To &(xAlias)->(FCount())
			cCpoDest := &(xAlias)->(FieldName(nInd))
			If &(xAlias)->(FieldPos(cCpoDest)) > 0
			
				If "FILIAL" $ cCpoDest
					M->(&(cCpoDest)) := xFilial(xAlias)
					xConteudo        := xFilial(xAlias) 
					FieldPut(FieldPos(cCpoDest), xConteudo )				
				
				Elseif "NUMORD" $ cCpoDest
					M->(&(cCpoDest)) := xNumOM
					xConteudo        := xNumOM 
					FieldPut(FieldPos(cCpoDest), xConteudo )
					 
				Elseif "CODEQP" $ cCpoDest
					M->(&(cCpoDest)) := xCodEqp
					xConteudo        := xCodEqp 
					FieldPut(FieldPos(cCpoDest), xConteudo ) 
					
				Elseif "DTABER" $ cCpoDest 
					M->(&(cCpoDest)) := Date()
					xConteudo        := Date()
					FieldPut(FieldPos(cCpoDest), xConteudo )
					
				Elseif "DTPREV" $ cCpoDest //a data prevista recebe a data de fechamento + qtde dias recorrência
					M->(&(cCpoDest)) := xDtPrev
					xConteudo        := xDtPrev
					FieldPut(FieldPos(cCpoDest), xConteudo )
				
				Elseif "CODMOT" $ cCpoDest           //código motivo
					M->(&(cCpoDest)) := xCodMot
					xConteudo        := xCodMot
					FieldPut(FieldPos(cCpoDest), xConteudo )
					
				Elseif "DSCMOT" $ cCpoDest         //descrição motivo
					M->(&(cCpoDest)) := xDescMot
					xConteudo        := xDescMot
					FieldPut(FieldPos(cCpoDest), xConteudo ) 
				
				Elseif "CODUSR" $ cCpoDest         //código usuário logado
					M->(&(cCpoDest)) := xCodUser
					xConteudo        := xCodUser
					FieldPut(FieldPos(cCpoDest), xConteudo )
					
				Elseif "NOMUSR" $ cCpoDest         //nome usuário logado
					M->(&(cCpoDest)) := xNomuser
					xConteudo        := xNomuser
					FieldPut(FieldPos(cCpoDest), xConteudo )
				
				//Else
					//FieldPut(FieldPos(cCpoDest), M->(&(cCpoDest)) )			
				EndIf	
				
			EndIf
		Next
		
		&(xAlias)->(dbCommit())
		&(xAlias)->(MsUnlock())
		lGravou := .T.		
		
	End Transaction
	
	RestArea(xArea)
	
	If lGravou
		MsgInfo("Encerrado e gravada Nova Ordem de Manutenção : " + xNumOM + ", Com Previsão Encerrar Dia: " + Dtoc(xDtPrev) )
	Endif		

Return(lGravou) 


//-----------------------//
//FUNÇÕES PARA VALIDAÇÃO:
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


/*==========================================================================
|Funcao    | FVLDTFECH          | Flávia Rocha         | Data | 26/04/2021 |
============================================================================
|Descricao | Valida a data de fechamento digitada         				   |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fVLDTFECH(xDtFech)	
Local lOk     := .T. 
    
	If xDtFech < Date()
		lOk  := .F.	
	Endif

Return(lOk)

/*==========================================================================
|Funcao    | fVLCPZ82          | Flávia Rocha         | Data | 23/04/2021 |
============================================================================
|Descricao | Valida os campos do cadastro de Equipamentos  				   |
|          | Duplicidade de código de equipamento vale para operadores     |
|          | diferentes desde que a data de inicio operação seja maior que |
|          | data final operação do usuário existente com este mesmo       |
|          | equipamento.
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fVLCPZ82(xEqto,xCpo,xConteudo,xRespon)	 
Local lOk     := .T.
Local cQuery  := ""

If xCpo <> Nil
	If "INIUSR" $ xCpo
	
		cQuery := " SELECT Z82_CODEQP , Z82_INIUSR, Z82_FIMUSR, Z82_DESCRI, Z82_RESPON FROM " + RetSqlName("Z82") + " Z82 "
		cQuery += " WHERE Z82.D_E_L_E_T_ <> '*' "
		cQuery += " AND Z82_CODEQP = '" + Alltrim(xEqto) + "' "	
		cQuery += " AND (Z82_FIMUSR = ''  OR Z82_FIMUSR >= '" + Dtos(xConteudo) + "' )"
		cQuery += " AND Z82_FILIAL = '" + Alltrim(xFilial("Z82")) + "' "
		MemoWrite("C:\TEMP\fVLCPZ82.SQL" , cQuery)
		cQuery := ChangeQuery( cQuery )	
	
		If Select("TMPX") > 0
			dbSelectArea("TMPX")
			TMPX->(dbCloseArea())
		EndIf
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPX", .T., .F. )
		DbSelectArea("TMPX")
		DbGoTop() 
	
		If TMPX->(!Eof())
			While TMPX->(!EOF())
				lOk  := .F.	
				cMsg += "Equipamento: " + Alltrim(xEqto) + "-" + Alltrim(TMPX->Z82_DESCRI) + CHR(13) + CHR(10)+;
				        "Em Uso P/ o Operador: " + Alltrim(UPPER(TMPX->Z82_RESPON)) + "- Período: " + Dtoc(Stod(TMPX->Z82_INIUSR)) + " Até "+ Dtoc(Stod(TMPX->Z82_FIMUSR))
				TMPX->(DbSkip())
			Enddo				
		Endif
	
		dbSelectArea("TMPX")
		TMPX->(dbCloseArea()) 
		
		If !lOk
			U_FRAviso("ERRO",cMsg,{"Ok"},3)		
		Endif 
	Endif	

Endif  
Return(lOk) 

 
/*==========================================================================
|Funcao    | fValOper           | Flávia Rocha         | Data | 29/04/2021 |
============================================================================
|Descricao | Valida preenchimento do campo Operador                        |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/  
User Function fValOper(xCpo,xConteudo)	
Local lOk     := .F.
Local cQuery  := ""

If xCpo <> Nil
	If "RESPON" $ xCpo
	
		cQuery := " SELECT CB1_CODOPE, CB1_NOME FROM " + RetSqlName("CB1") + " CB1 "
		cQuery += " WHERE CB1.D_E_L_E_T_ <> '*' "
		cQuery += " AND UPPER( RTRIM(CB1_NOME) ) = '" + UPPER(Alltrim(xConteudo)) + "' "
		cQuery += " AND CB1_FILIAL = '" + Alltrim(xFilial("CB1")) + "' "
		
		cQuery := ChangeQuery( cQuery )	
		If Select("TMPX") > 0
			dbSelectArea("TMPX")
			TMPX->(dbCloseArea())
		EndIf
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPX", .T., .F. )
		DbSelectArea("TMPX")
		DbGoTop() 
	
		If !TMPX->(Eof())	
			lOk  := .T.			
		Endif
	
		dbSelectArea("TMPX")
		TMPX->(dbCloseArea()) 
		
		If !lOk
			//U_FRAviso("ERRO","Responsável Não Cadastrado!",{"Ok"},3)		
		Endif 
	Endif	

Endif

Return(lOk)

/*==========================================================================
|Funcao    | fVLDCPZ84          | Flávia Rocha         | Data | 27/04/2021 |
============================================================================
|Descricao | Valida campos na Ordem de Manutenção,                         |
|          | verifica se existem em seus respectivos cadastro              |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fVLDCPZ84(xCpo,xConteudo)		
Local lOk     := .F.
Local xEqto   := ""
Local xCodmot := ""
Local cQuery  := ""

If "Z84_CODEQP" $ ReadVar() //se foi este o campo digitado 

	xEqto		:= &(ReadVar()) 
    
	cQuery := " SELECT Z82_CODEQP , Z82_CODUSR, Z82_DESCRI, Z82_NOMUSR FROM " + RetSqlName("Z82") + " Z82 "
	cQuery += " WHERE Z82.D_E_L_E_T_ <> '*' "
	cQuery += " AND Z82_CODEQP = '" + Alltrim(xEqto) + "' "
	cQuery += " AND Z82_FILIAL = '" + Alltrim(xFilial("Z82")) + "' "
	
	cQuery := ChangeQuery( cQuery )	
	If Select("TMPZ82") > 0
		dbSelectArea("TMPZ82")
		TMPZ82->(dbCloseArea())
	EndIf
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPZ82", .T., .F. )
	DbSelectArea("TMPZ82")
	DbGoTop() 

	If TMPZ82->(!Eof())	
		lOk  := .T.			
	Endif

	dbSelectArea("TMPZ82")
	TMPZ82->(dbCloseArea()) 
	
	If !lOk
		U_FRAviso("ERRO","Código Equipamento Não Cadastrado!",{"Ok"},3)		
	Endif	
	
ElseIf "Z84_CODMOT" $ ReadVar() //se foi este o campo digitado 
  
	xCodmot := &(ReadVar()) 
	Z83->(OrdSetFocus(1))
	If Z83->(Dbseek(xFilial("Z83") + xCodmot))
		lOk := .T. 
	Endif
	
	If !lOk
		U_FRAviso("ERRO","Motivo Não Cadastrado!",{"Ok"},3)		
	Endif

Endif
 
Return(lOk)

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
User Function fFRTela(oBjet,cTipo,xVerMDI)

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
User Function FRAviso(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
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

/*==========================================================================
|Funcao    | fMaxOM             | Flávia Rocha          | Data | 03/05/2021|
============================================================================
|Descricao | Obtém o próximo número de Ordem de Manutenção 				   |
|          |                                                               |
============================================================================
|Observações: Estoque / custos											   |
==========================================================================*/
User Function fMaxOM()     

Local cQry 		:= "" 
Local cMINZ84   := ""
Local cMAXZ84   := ""
Local cNumOM    := ""

//primeiro verifica na lista de deletados o menor número de Ordem de Manutenção (O Jefferson pediu para poder aproveitar os números que foram cancelados)
cQry := " SELECT MIN(Z84_NUMORD) as Z84_NUMORD "
cQry += " FROM " + RetSqlname("Z84") + " Z84 "
cQry += " WHERE Z84_FILIAL = '" + xFilial("Z84") + "' "
cQry += " AND Z84.D_E_L_E_T_  = '*' "  //Igual a deletado
Memowrite("C:\TEMP\MIN_Z84.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("TMPZ84") > 0
	DbSelectArea("TMPZ84")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "TMPZ84" 

TMPZ84->(DbGoTop())

If !TMPZ84->(EOF())
    cMINZ84 := TMPZ84->Z84_NUMORD
Endif

DbSelectArea("TMPZ84")
DbCloseArea() 

If !Empty(cMINZ84)
	cNumOM := cMINZ84
	Z84->(OrdSetFocus(1))
	If Z84->( DbSeek( xFilial( "Z84" ) + cNumOM ) )
		While Z84->( DbSeek( xFilial( "Z84" ) + cNumOM ) )
		   ConfirmSX8()
		   cNumOM := Strzero(Val(cNumOM) + 1,6)
		Enddo
    Endif
Else

	//se não encontrar nada na lista de deletados, verifica na lista de ativos, o maior número de Ordem de Manutenção, para poder calcular o número da próxima ordem de manutenção
	cQry := " SELECT MAX(Z84_NUMORD) as Z84_NUMORD "
	cQry += " FROM " + RetSqlname("Z84") + " Z84 "
	cQry += " WHERE Z84_FILIAL = '" + xFilial("Z84") + "' "
	cQry += " AND Z84.D_E_L_E_T_ <> '*' "  //Diferente de deletado
	Memowrite("C:\TEMP\MAX_Z84.SQL",cQry)
	
	cQry := ChangeQuery( cQry )
	
	If Select("TMPZ84") > 0
		DbSelectArea("TMPZ84")
		DbCloseArea()	
	EndIf
	
	TCQUERY cQry NEW ALIAS "TMPZ84" 

	TMPZ84->(DbGoTop())

	If !TMPZ84->(EOF())
	    cMAXZ84 := TMPZ84->Z84_NUMORD
	Endif
	
	DbSelectArea("TMPZ84")
	DbCloseArea("TMPZ84")
	
	//Redundância: verifica o código obtido de fato é novo e não existe:
	Z84->(OrdSetFocus(1))
	If Z84->( DbSeek( xFilial( "Z84" ) + cNumOM ) )
		While Z84->( DbSeek( xFilial( "Z84" ) + cNumOM ) )
		   ConfirmSX8()
		   cNumOM := Strzero(Val(cNumOM) + 1,6)
		Enddo
	Endif

Endif

Return(cNumOM)
