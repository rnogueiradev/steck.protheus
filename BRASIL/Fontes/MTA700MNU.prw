#Include "Protheus.ch" 
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA700MNU บAutor  ณAntonio da Costa Jr. - Directa Solutions บ Data ณ  07/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na rotina de Precisao de Vendas. Utilizado para adicionar       บฑฑ
ฑฑบ          ณfuncoes a aRotina.                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                                                 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTA700MNU()

AADD(aRotina, {"Importar CSV","u_ImpSC4", 0 , 3, 0, nil})
AADD(aRotina, {"Excl. p/ Docto","u_ExcSC4", 0 , 4, 0, nil})

Return
                        
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
//&& Funcao para abertura da tela de configuracao       &&//
//&& das posicoes dos campos.                           &&//
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
User Function ImpSC4()

// Variaveis Locais da Funcao
Local ccArqCSV := Space(120)

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal

// Privates das NewGetDados
Private oGetDados1

// Array com todos os campos contendo se o mesmo eh obrigatorio ou nao
Private aCampos	:= {}

DEFINE MSDIALOG _oDlg TITLE "Importa็ใo de Previsใo de Vendas (arquivo CSV separado por ;)" FROM C(299),C(433) TO C(652),C(819) PIXEL

// Cria as Groups do Sistema
@ C(147),C(002) TO C(174),C(189) LABEL "" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(002),C(002) Say "Informe o local onde se encontra o arquivo para importa็ใo:" Size C(144),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
oBtnArq := tButton():New(C(012),C(125),"&Abrir",_oDlg,{|| ccArqCSV := DlgArq(ccArqCSV)},30,12,,,,.T.)
oGetArq := TGet():New(15,05,{|u| If(PCount()>0,ccArqCSV:=u,ccArqCSV)},_oDlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'ccArqCSV') 
@ C(030),C(002) Say "Informe as posi็๕es das colunas que contem as seguintes informa็๕es:" Size C(171),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(155),C(102) Button "&Importar" Action(fImport(ccArqCSV,oGetDados1:aCols),_oDlg:End()) Size C(037),C(012) PIXEL OF _oDlg
@ C(155),C(146) Button "&Cancelar" Action(_oDlg:End()) Size C(037),C(012) PIXEL OF _oDlg

// Chamadas das GetDados do Sistema
fGetDados1()

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfGetDados1()ณ Autor ณ Antonio da Costa Junior   ณ Data ณ08/08/2012ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณObservacao ณ O Objeto oGetDados1 foi criado como Private no inicio do Fonte   ณฑฑ
ฑฑณ           ณ desta forma voce podera trata-lo em qualquer parte do            ณฑฑ
ฑฑณ           ณ seu programa:                                                    ณฑฑ
ฑฑณ           ณ                                                                  ณฑฑ
ฑฑณ           ณ Para acessar o aCols desta MsNewGetDados: oGetDados1:aCols[nX,nY]ณฑฑ
ฑฑณ           ณ Para acessar o aHeader: oGetDados1:aHeader[nX,nY]                ณฑฑ
ฑฑณ           ณ Para acessar o "n"    : oGetDados1:nAT                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fGetDados1()
// Variaveis deste Form                                                                                                         

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsNewGetDados()      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Vetor responsavel pela montagem da aHeader
// Vetor com os campos que poderao ser alterados                                                                                
Local aAlter      := {"POSICAO","VLRFIX","FORMATO"}
Local nSuperior   := C(039)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda   := C(002)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior   := C(145)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita    := C(189)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc        := GD_UPDATE	      //GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk    := "u_VLIN700MNU()" //"AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk     := "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos    := ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                      // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                      // segundo campo>+..."                                                               
Local nFreeze     := 000              // Campos estaticos na GetDados.                                                               
Local nMax        := 999              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk    := "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk    := "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

// Objeto no qual a MsNewGetDados sera criada                                      
Local oWnd        := _oDlg

Private aHead     := {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Private aCol      := {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                
// Aadd(aHead,{ TITULO,	CAMPO,	PICTURE,	TAMANHO,	DECIMAL,	VALIDACAO,	RESERVADO, 	TIPO, 	RESERVADO,	RESERVADO})
Aadd(aHead,{ "Campo",		"CAMPO",	"",			15,	0,	,	, 	"C", 	,	})
Aadd(aHead,{ "Posi็ใo",		"POSICAO",	"@E 99",	2,	0,	,	, 	"N", 	,	})
Aadd(aHead,{ "Valor Fixo",	"VLRFIX",	"",			20,	0,	,	, 	"C", 	,	})
                    
DbSelectArea("SX3")
SX3->(DbSetOrder(1))
SX3->(DbSeek("SC4"))

While SX3->(!Eof()) .and. SX3->X3_ARQUIVO = "SC4"
   //
   If SX3->X3_CAMPO = "C4_FILIAL" .or. !X3USADO(SX3->X3_CAMPO) .or. SX3->X3_VISUAL = "V"
      SX3->(DbSkip())	
      Loop
   EndIf
   //
   aAux := {}
   //
   //cPode := X3OBRIGAT(SX3->`) //11/05/23 - alterado X3Reserv(SX3->X3_RESERV) - Fun็ใo X3Reserv() descontinuada
   //lObrig := IIf(!Empty(SubStr(cPode,7,1)),.T.,.F.)
   lObrig := IIF(SX3->X3_OBRIGAT=='  x     ',.T.,.F.)

   Aadd(aCampos, {SX3->X3_CAMPO, lObrig})
   //
   Aadd(aAux,AllTrim(RetTitle(SX3->X3_CAMPO)))
   Aadd(aAux,00)
   Aadd(aAux,Space(SX3->X3_TAMANHO+SX3->X3_DECIMAL))
   Aadd(aAux,.F.)
   //
   SX3->(DbSkip())
   Aadd(aCol,aAux)
EndDo
   
oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aCol)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes := oMainWnd:nClientWidth   // Resolucao horizontal do monitor     
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
   nTam *= 0.8                                                                
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
   nTam *= 1                                                                  
Else	// Resolucao 1024x768 e acima                                           
   nTam *= 1.28                                                               
EndIf                                                                         
                                                                                
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
//ณTratamento para tema "Flat"ณ                                               
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
If "MP8" $ oApp:cVersion                                                      
   If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
      nTam *= 0.90                                                            
   EndIf                                                                      
EndIf                                                                         

Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDlgArq    บAutor  ณAntonio da Costa Jr.ณData: |  08/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre dialog para selecao de arquivo CSV.	                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                   					  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DlgArq(cArquivo)

cType 	 := " (*.csv) |*.csv|"
cArquivo := cGetFile(cType, "Arquivo CSV")
If !Empty(cArquivo)
   cArquivo += Space(100-Len(cArquivo))
Else
   cArquivo := Space(100)
EndIf

Return cArquivo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValLin    บAutor  ณAntonio da Costa Jr.ณData: |  08/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao das Linhas.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                   					  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VLIN700MNU()
Local lRet := .T.
Local N	   := oGetDados1:nAt
Local aCol := oGetDados1:aCols

If aCampos[N][2]
   If aCol[N][2] = 0 .and. Empty(aCol[N][3])
      MsgStop("O campo "+aCol[N][1]+" ้ obrigat๓rio. Informe a coluna do arquivo CSV ou um valor fixo.","Campo Obrigatorio")
      lRet := .F.
   EndIf
   If aCol[N][2] <> 0 .and. !Empty(aCol[N][3])
      MsgStop("Preencha somente o numero da coluna que estแ o campo "+aCol[N][1]+" ou o valor fixo.","Coluna ou Vlr. Fixo")
      lRet := .F.
   EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImport   บAutor  ณAntonio da Costa Jr.ณData: |  08/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa a importacao do arquivo.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                   					  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fImport(cCaminho, aCols)
	
If !Empty(cCaminho)
   Processa({|| aImport := LerArq(cCaminho,aCols)},"Aguarde Processando a leitura do arquivo...","Aguarde")
Else
   MsgStop("Informe o caminho e nome do arquivo para ser importado.","Sem arquivo")
EndIf

Return()

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
//&& Antonio da Costa Jr. -                   - 02/08/12                        &&//
//&&Desc.     	ณ Processa a leitura do arquivo CSV.				&&//
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
//&&Parametros	 ณ cArquivo:	Caminho do arquivo a ser lido.			&&//
//&&		 ณ aCols:	Array contendo as posicoes de cada um dos 	&&//
//&&		 ณ campos.                    					&&//
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
//& Retorno   ณ aImport: Array com os registros a serem gravados.	        &&//
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
Static Function LerArq(cArquivo,aCols)
Local cLinha	:=	""
Local cTrecho	:=	""
Local nHdl	:=	0
Local nX	:=	0
Local nXErr	:=	0
Local _cPathErr	:= "\" + ALLTRIM(CURDIR()) + "\LOGS\"
Local _cArqErr	:= "IMPPV_"+DTOS(DDATABASE)+REPLACE(SUBSTRING(TIME(),1,5),":","")+".txt"
Private _lExcl	:= .F.
Private _lAlt	:= .F.
Private aDados	:= {}

lMsErroAuto	:= .F.

nHdl := FT_FUSE(cArquivo)
nTotReg := FT_FLASTREC()

FT_FGOTOP()

ProcRegua(nTotReg)

nX := 0
nXErr := 0
While !FT_FEOF()
	//
	_cMsgExt 	:= ""
	lMsErroAuto	:= .F.
	nX++
	cLinha := FT_FREADLN()
	//
	aInfos := {}
	While !Empty(cLinha)
        //
		cTrecho	:=	If(At(";",cLinha)>0,Substr(cLinha,1,At(";",cLinha)-1),cLinha)
		cLinha	:=	If(At(";",cLinha)>0,Substr(cLinha,At(";",cLinha)+1),"")
    	//  
    	AAdd(aInfos,cTrecho)
        //
	End
	//
	//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
	//&& Antonio da Costa Jr. - Directa Solutions - 18/09/12 &&//
	//&& Verificar se eh inclusao ou alteracao.              &&//
	//Produto	'					 &&//
	//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
	if Len(aInfos) > 0
		nPosProd	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_PRODUTO"})
		If !Empty(aCols[nPosProd][2])
			cProduto 	:= Padr(aInfos[aCols[nPosProd][2]],TamSX3("C4_PRODUTO")[1])
		Else
			cProduto 	:= Padr(aCols[nPosProd][3],TamSX3("C4_PRODUTO")[1])
		EndIf
	
		if nX > 1 .Or. !MsgYesNo("A primeira linha corresponde a cabe็alho?","Inicio")
			If SB1->(dbSeek(SB1->(XFILIAL()) + cProduto)) 
				//Data da Previsao
				nPosData	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_DATA"})
				If !Empty(aCols[nPosData][2])
					cData	:= CtoD(aInfos[aCols[nPosData][2]])//Padr(aInfos[aCols[nPosData][2]],TamSX3("C4_DATA")[1])
				Else
					cData 	:= CtoD(aCols[nPosData][3])//Padr(aCols[nPosData][3],TamSX3("C4_DATA")[1])
				EndIf
			
				//Quantidade
				nPosQtde	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_QUANT"})
				If !Empty(aCols[nPosQtde][2])
					cQuant	:= Val(aInfos[aCols[nPosQtde][2]])
				Else
					cQuant 	:= IIF(EMPTY(aCols[nPosQtde][3]), 0, Val(aCols[nPosQtde][3]))
				EndIf          
			
				//Local
				nPosLocal	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_LOCAL"})
				If !Empty(aCols[nPosLocal][2])
					cLocal 	:= Padr(aInfos[aCols[nPosLocal][2]],TamSX3("C4_LOCAL")[1])
				Else
					cLocal	:= Padr(aCols[nPosLocal][3],TamSX3("C4_LOCAL")[1])
				EndIf
				
				//Documento
				nPosDoc	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_DOC"})
				If !Empty(aCols[nPosDoc][2])
					cDoc 	:= Padr(aInfos[aCols[nPosDoc][2]],TamSX3("C4_DOC")[1])
				Else
					cDoc	:= Padr(aCols[nPosDoc][3],TamSX3("C4_DOC")[1])
				EndIf
			
				//Valor
				nPosValor	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_VALOR"})
				If !Empty(aCols[nPosValor][2])
					nValor 	:= Val(aInfos[aCols[nPosValor][2]])
				Else
					nValor	:= IIF(EMPTY(aCols[nPosValor][3]), 0, Val(aCols[nPosValor][3]))
				EndIf
			
				//Observa็ใo
				nPosObs	:= Ascan(aCampos,{|x| Alltrim(x[1])=="C4_OBS"})
				If !Empty(aCols[nPosObs][2])
					cObs 	:= Padr(aInfos[aCols[nPosObs][2]],TamSX3("C4_OBS")[1])
				Else
					cObs	:= Padr(aCols[nPosObs][3],TamSX3("C4_OBS")[1])
				EndIf
			
				aDados := {}			
				aAdd( aDados, { "C4_PRODUTO"	, IIF(!_lExcl .and. !_lAlt, cProduto, SC4->C4_PRODUTO)	, NIL } )
				aAdd( aDados, { "C4_LOCAL"		, IIF(!_lExcl .and. !_lAlt, cLocal, SC4->C4_LOCAL)		, NIL } )
				aAdd( aDados, { "C4_DOC"		, cDoc													, NIL } )
				aAdd( aDados, { "C4_QUANT"		, cQuant												, NIL } )
				aAdd( aDados, { "C4_VALOR"		, nValor												, NIL } )
				aAdd( aDados, { "C4_DATA"		, cData													, NIL } )
				aAdd( aDados, { "C4_OBS"		, cObs													, NIL } )

				MSExecAuto({|x,y| Mata700(x,y)},aDados,3) //Exclusao, Inclusao

			Else
				lMsErroAuto := .T.
				_cMsgExt := "Produto - " + cProduto + " nใo encontrado !!!"
			Endif
			
			If lMsErroAuto
				nXErr++
				If Len(_cMsgExt) = 0
					_cMsgExt := GRLog()
				Endif
				DisarmTransaction()
				Alert("Erro ao tratar o produto " + ALLTRIM(cProduto) + CHR(13) + CHR(10) + _cMsgExt)
			Endif
		Endif
	EndIf
	IncProc()

	FT_FSKIP()

EndDo

FT_FUSE()

MsgInfo("Foram processados "+AllTrim(Str(nX,6))+" Linhas."+chr(13)+chr(10)+ iif(nXErr>0,AllTrim(Str(nXErr,6)) + " registros apresentaram erros. (Veja LOG)"+chr(13)+chr(10)+_cPathErr+_cArqErr,"Sem Erros.") ,"Importacao com Sucesso.")

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑณ Grava o Arquivo de Log gerado pela rotina de Integracao               ณฑฑ
//ฑฑณ Renato Santos - 06/10/08                                              ณฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Static Function GrLOG()
Local _cRetLOG	:= Space(30)
Local _cNmArq 	:= NomeAutoLog()
if _cNmArq != Nil
   _cRetLOG :=MemoRead(_cNmArq)
   FERASE((CURDIR() + _cNmArq))
Else
   _cRetLOG :="Erro nใo determinado"
Endif

Return(_cRetLOG)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑณ Fun็ใo para excluir as Previs๕es de Vendas por Documento ou Periodo   ณฑฑ
//ฑฑณ Gess้ Antonio Roldใo - Projeto Golden Code - 20/11/2013               ณฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function ExcSC4()
Local aRet := {}, aPar := {}, lContDig:=.F.
Local aX := {}
//
aAdd(aX,110)
aAdd(aX,750)
//
aAdd(aPar,{1,"Documento de" ,   Space(9),,,,"",50,.F.})
aAdd(aPar,{1,"Documento ate" ,  Replicate("Z",9),,,,"",50,.T.})
aAdd(aPar,{1,"Data Prev. de" ,  Ctod("  /  /  "),,,,"",50,.F.})
aAdd(aPar,{1,"Data Prev. ate" , Ctod("  /  /  "),,,,"",50,.T.})
//
lContDig :=  ParamBox(aPar,"Exclui Previs๕es de Vendas",@aRet,,,.T.,aX[1],aX[2],,"",.F.,.F.)
//
If ! lContDig
   Return   
Endif
//
If ApMsgYesno("Confirma exclusใo das Previs๕es de Vendas ?", "Exclui SC4")
   Processa({|| PROC_EXC()}, "Exclusใo da Previsใo de Vendas")
Endif
//
Return

/*****************************************************
* Processa a exclusใo da Previsใo de Vendas conforme *
* parametriza็ใo da rotina                           *
*****************************************************/
Static Function PROC_EXC()
Local cQuery  := ""
Local nTotReg := 0

cQuery := "SELECT R_E_C_N_O_ AS NUMREG "
cQuery += "FROM "+RETSQLNAME("SC4")+" SC4 "
cQuery += "WHERE SC4.D_E_L_E_T_ = ' ' "
cQuery += "AND C4_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += "AND C4_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "
cQuery += "AND C4_FILIAL = '"+xFilial("SC4")+"' "

TcQuery cQuery New Alias "TRB"

DbSelectArea("TRB")
ProcRegua(Reccount())
TRB->(DbGoTop())

While ! Eof()
    DbSelectArea("SC4")
    DbGoto(TRB->NUMREG)
    RecLock("SC4",.F.)
    DbDelete()
    MsUnlock()

    nTotReg ++

    DbSelectarea("TRB")
    DbSkip()
Enddo

Alert("Foram excluidos "+Alltrim(Str(nTotReg,4))+" registros...")

DbSelectArea("TRB")
DbCloseArea()

Return
