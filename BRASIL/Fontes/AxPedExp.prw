#INCLUDE "rwmake.ch"
#Include "protheus.ch"
#INCLUDE "eecap100.ch"
#include "EEC.CH"
#include "dbtree.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AxPedExp º Autor ³ Fernando Pereira   º Data ³  16/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajusta informações do Pedido de Exportação                 º±±
±±º          ³ Internacional para a exportação                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**************************
User Function AxPedExp()
**************************

Public lAltera  :=.T.
Public lAprova  :=.F.
Public lDescit  :=.F.

Private lFat
Private cCadastro := "Manutenção da Capa do Pedido de Exportação"
Private aRotina := {;
{ OemToAnsi('Pesquisar') ,'AxPesqui'  ,0,1,0,Nil},;
{ OemToAnsi('Visualizar'),'AxVisual'  ,0,2,0,Nil},;
{ OemToAnsi('Alterar')   ,'U_mAltEE7' ,0,4,0,Nil}}

//| AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons)

mBrowse( 6,1,22,75,"EE7")

return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw           | AUTOR | Fernando | DATA | 16/05/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - mAltEE7()                                              |//
//|           | Alteração das informações 										|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

****************************************
User Function mAltEE7(cAlias,nReg,nOpc)
****************************************
Local nOpcaA
Local cAlias  := "EE7"
Local oDlg, bOk, bCancel, nOpcA := 0
Local lRet

Local bPesLiq := MemVarBlock(cAlias+"_PESLIQ")
Local bPesBru := MemVarBlock(cAlias+"_PESBRU")
Local aObjPC := { "oSayPLC", "oSayPBC" }
Local cAliasWork := "EE7"
Local bSomaPeso, nRecWork := ("EE7")->(RecNo())
Local bCondicao
Local nEE7RecOld

Private lCBPesCal := .F.
Private nPesLD := 0
Private lPesLD := .T.
                                       
cNota := Posicione("SC9",1,xFilial("SC9")+EE7->EE7_PEDFAT,"C9_NFISCAL")

lFat  := If(EE7->EE7_STATUS == "D" .AND. !Empty(cNota),.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³coloca o conteudo em uma variavel e monta um array de campos a ser   ³
//|passado para a funcao AXALTERA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lFat
	
	nOpcaA := AxAltera(cAlias,nReg,nOpc,,,,,"u_SZETudOk()")
	
	IF GetMv("MV_AVG0004") // Conferencia dos Pesos
		
		aObjPD := { "oSayPLD", "oGetPLD", "oSayPBD", "oGetPBD" }    //Array com todos os objetos do Peso Dígitado.
		
		nPesLC    := 0    	// Valor Numérico do Peso Líquido Cálculado.
		nPesBC 	  := 0    	// Valor Numérico do Peso Bruto Cálculado.
		lCBPesDig := .T.    // Valor Lógico do Objeto CheckBox Peso Dígitado.
		nPesBD    := 0   	// Valor Numérico do Peso Bruto Dígitado.
		lPesBD    := .T.   	// Variável lógica que definirá o modo de edição do campo peso líquido digitado
		
		(cAliasWork)->(dbGoTo(nRecWork))
		
		nPesLD := If( !Inclui, &(cAlias + "->" + cAlias + "_PESLIQ"), nPesLC )
		nPesBD := If( !Inclui, &(cAlias + "->" + cAlias + "_PESBRU"), nPesBC )
		
		Begin Sequence
		
		Define MSDialog oDlg TITLE "Conferência de Pesos" FROM 10, 12 TO 20.5, 80 OF oMainWnd //"Conferência de Pesos"
		
		//Peso Calculado
		@ 2.0, 0.65 To 5.5, 16.5
		@ 18, 07   CheckBox oCBPesCal Var lCBPesCal Prompt "Peso Calc" Size 35, 08 Of oDlg On Click;
		( Eval( { || lPesLD    := .F.                 ,;
		lPesBD    := .F.                              ,;
		lCBPesDig := .F.                              ,;
		oCBPesDig :Refresh()                          ,;
		aEval( aObjPD, { |x| &( x + ":Disable()" ) } ),;
		aEval( aObjPC, { |x| &( x + ":Enable()" ) } ) } ) ) //"Calculado"
		
		@ 2.3, 1.8 Say oSayPLC   Var "Peso Líquido Cálc" OF oDlg SIZE 35,9 // Objeto Say Peso Líquido Cálculado.
		@ 2.3, 7.8 MSGet oGetPLC Var nPesLC Picture AVSX3(cAlias+"_PESLIQ",AV_PICTURE) OF oDlg When .F. //Objeto Get Peso Líquido Cálculado.
		
		@ 3.5, 1.8 Say oSayPBC   Var "Peso Bruto Cálc" OF oDlg SIZE 35,9 //Objeto Say Peso Bruto Cálculado.
		@ 3.5, 7.8 MSGet oGetPBC Var nPesBC Picture AVSX3(cAlias+"_PESBRU",AV_PICTURE) OF oDlg When .F. //Objeto Get Peso Bruto Cálculado.
		
		//Peso Dígitado
		@ 2.0, 17.0 To 5.5, 33.2
		@ 18, 135.9 CheckBox oCBPesDig Var lCBPesDig Prompt "Peso Dig" Size 36, 08 Of oDlg On Click;
		( Eval( { || lPesLD    := .T.                              ,;
		lPesBD    := .T.                              ,;
		lCBPesCal := .F.                              ,;
		oCBPesCal:Refresh()                           ,;
		aEval( aObjPC, { |x| &( x + ":Disable()" ) } ),;
		aEval( aObjPD, { |x| &( x + ":Enable()") } ) } ) ) //"Dígitado"
		
		@ 2.3, 18.0 Say oSayPLD   Var "Peso Líquido Díg" OF oDlg SIZE 35,9 //Objeto Say Peso Líquido Dígitado.
		@ 2.3, 24.0 MSGET oGetPLD Var nPesLD Picture AVSX3(cAlias+"_PESLIQ",AV_PICTURE) OF oDlg When lPesLD //Objeto Get Peso Líquido Dígitado.
		
		@ 3.5, 18.0 SAY oSayPBD   Var "Peso Bruto Díg" OF oDlg SIZE 35,9 //Objeto Say Peso Bruto Dígitado.
		@ 3.5, 24.0 MSGET oGetPBD Var nPesBD Picture AVSX3(cAlias+"_PESBRU",AV_PICTURE) OF oDlg When lPesBD //Objeto Peso Bruto Dígitado.
		
		If ! lCBPesCal
			aEval( aObjPC, { |x| &( x + ":Disable()" ) } )
			lPesLD := .T.
			lPesBD := .T.
		End If
		
		If ! lCBPesDig
			aEval( aObjPD, { |x| &( x + ":Disable()" ) } )
			lPesLD := .F.
			lPesBD := .F.
		EndIf
		
		bOk := {|| nOpcA := 1, oDlg:End() }
		bCancel := {|| oDlg:End() }
		
		Activate MSDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
		
		IF nOpcA == 0
			Break
		Endif
		
		Eval( bPesLiq, If( lCBPesCal, nPesLC, nPesLD ) )
		Eval( bPesBru, If( lCBPesCal, nPesBC, nPesBD ) )
		
		End Sequence
		
		EE7->(RecLock("EE7",.F.))
		EE7->EE7_PESLIQ := nPesLD
		EE7->EE7_PESBRU := nPesBD
		EE7->(MsUnlock())
		
		*** Corrige Pedido de Vendas
		**********************************
		cCondPag := Posicione("SY6",1,xFilial("SY6")+EE7->EE7_CONDPA,"Y6_SIGSE4")
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+EE7->EE7_PEDFAT))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_PESOL   := EE7->EE7_PESLIQ
			SC5->C5_PBRUTO  := EE7->EE7_PESBRU
			SC5->C5_CONDPAG := cCondPag
			SC5->C5_ZCONDPG := cCondPag
			SC5->C5_FRETE   := EE7->EE7_FRPREV 
			SC5->C5_SEGURO  := EE7->EE7_SEGPRE
			SC5->C5_DESC1   := EE7->EE7_XDESC1
            SC5->C5_VOLUME1 := EE7->EE7_XQVOL  // Envia Quantidade de volumes P. Faturamento
            SC5->C5_ESPECI1 := EE7->EE7_XDVOL // Envia Descricao do Volume para P.Faturamento  
            SC5->C5_DESCONT := EE7->EE7_XDESCO //Giovani Zago Desconto direto na NF
			SC5->(MsUnlock())
		Endif
		
	Endif
	
Else
	
	If lFat
		MsgAlert("Nota Fiscal Gerada! Processo não pode sofrer alteração!","Atenção")
		nOpcaA := .F.
	Endif
	
Endif

Return nOpcaA

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw              | AUTOR | Luiz  | DATA | 15/05/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - SZETudOk()                                             |//
//|           | Validação da Alteracao do Registro em Questao                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
   

***** Valida Alteração
****************************
User Function SZETudOk()
****************************************
Local lRet  := .T.
Local aArea := { Alias() }

If M->EE7_IMPORT != EE7->EE7_IMPORT
	MsgAlert("Cliente não pode sofrer alteração!","Atenção")
	M->EE7_IMPORT := EE7->EE7_IMPORT
	lRet  := .F.
Endif

dbSelectArea( aArea[1] )

Return lRet