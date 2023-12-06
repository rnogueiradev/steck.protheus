#INCLUDE "MATC010.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TCBrowse.ch"

/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATC010	� Autor � Eveli Morasco         � Data � 22/06/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta Formacao de Precos c/ base na estrutura do produto���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo Sart�13/08/98�16456A�Acerto na insercao de linhas              ���
���Fernando J. �18/01/99�19743A�Passar a Filial correta na Func.Posicione.���
���CesarValadao�24/05/99�PROTHE�Manutencao do metodo :End e :DrawLine.    ���
���CesarValadao�15/06/99�PROTHE�Inclusao do :bLine em oCusto e oPlan.     ���
���CesarValadao�13/10/99�22282A�Novo Lay-Out com Celula Percentual com 4  ���
���            �        �      �Digitos e Formula com 100 Caracteres.     ���
���CesarValadao�03/01/00�1837  �Acerto na Exclusao de Linha Total/Formula ���
���Iuspa       �28/08/00�5742  �mv_par03 Inclui produto quant neg estrut? ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MATC010A()
LOCAL cArea       := Alias()
PRIVATE aRotina   := MenuDef()
PRIVATE cArqMemo  := "STANDARD"
PRIVATE cCodPlan  := ""
PRIVATE cCodRev	  := ""
PRIVATE lDirecao  := .T.
PRIVATE lExibeHelp:= .T.
PRIVATE lPesqRev  := .F.
PRIVATE nQualCusto:= 1

PRIVATE aArray    :={}
PRIVATE aHeader   :={}
PRIVATE aTotais   :={}
PRIVATE cCadastro := OemToAnsi(STR0003)	//"Forma��o de Pre�os"                                    
PRIVATE lMC010GRV := (ExistBlock("MC010GRV")) //Ponto de Entrada p/ gravar campos na base de dados
PRIVATE cProg     := "C010"  
PRIVATE nQtdFormula
PRIVATE nQtdTotais
PRIVATE cCusto

Private _ACUSORI := {}

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//�������������������������������������������������������������������
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final("Atualizar SIGACUSA.PRX !!!")
EndIf

//���������������������������������������������������������������Ŀ
//� Inclui perguntas no SX1                                       �
//�����������������������������������������������������������������
//MTC010SX1()
//���������������������������������������������������������������Ŀ
//� Acerto das perguntas no SX1                                   �
//�����������������������������������������������������������������
C010AjuSX1()

//���������������������������������������������������������������Ŀ
//� Carrega variaveis Codigo/Revisao                              �
//�����������������������������������������������������������������
If AliasInDic('SCO') .And.;
   SCO->(FieldPos("CO_CODIGO")) > 0 .And.;
   SCO->(FieldPos("CO_REVISAO")) > 0
   cCodPlan  := StrZero(1,TamSx3("CO_CODIGO")[1])
   cCodRev	 := StrZero(1,TamSx3("CO_REVISAO")[1])
EndIf


//���������������������������������������������������������Ŀ
//� Caso o M�dulo que chama a fun��o seja o SIGALOJA        �
//� abre o arquivo SG1. esta implementa��o visa a libera��o �
//� de FILES do MS-DOS para o Sigaloja                      �
//�����������������������������������������������������������
If nModulo == 12 .Or. nModulo == 72 // SIGALOJA //SIGAPHOTO
	ChkFile("SG1")
	ChkFile("SGG")
EndIf

//����������������������������������������������������������������Ŀ
//� Ativa tecla F12 para acionar perguntas                         �
//������������������������������������������������������������������
Set Key VK_F12 To MTC010PERG()

Pergunte("MTC010", .F.)

//����������������������������������������������������������������Ŀ
//� Forca utilizacao da estrutura caso nao tenha SGG               �
//������������������������������������������������������������������
If MC010SX2("SGG") == .F.
	mv_par09:=1
EndIf

// Verifica o Nivel de Estrutura
If Empty(mv_par11) 
	mv_par11 := 999
EndIf

mBrowse(6,1,22,75,"SB1",,,,,2)

//���������������������������������������������������������Ŀ
//� Caso o M�dulo que chama a fun��o seja o SIGALOJA        �
//� Fech o arquivo SG1. esta implementa��o visa a libera��o �
//� de FILES do MS-DOS para o Sigaloja                      �
//�����������������������������������������������������������
If nModulo == 12 .Or. nModulo == 72 // SIGALOJA //SIGAPHOTO
	dbSelectArea("SG1")
	dbCloseArea()
	dbSelectArea("SGG")
	dbCloseArea()
	dbSelectArea(cArea)
EndIf

//����������������������������������������������������������������Ŀ
//� Desativa tecla que aciona perguntas                            �
//������������������������������������������������������������������
Set Key VK_F12 To

RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �BrowPlanW � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta a tela dos Browses                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BrowPlanW(nMatPrima,aFormulas,nTipo)
LOCAL cFormula, i, nX, nIni, nFim, cArq, cArqAnt, cBuffer, cArqBak, nUltNivel
LOCAL lAutoCalc, aProd:={}, lMatPrima:=.T., nPos:=1
LOCAL k, cVal, cNivEstr, cProduto, nDelet, nCont:=0
LOCAL oBtnA, oBtnD, oBtnE, oBtnF, oBtnG
LOCAL nACol, nMult:=0, cDescricao, nHdl
LOCAL oDlg, oFont, oBMP
LOCAL aObjects   :={}
LOCAL aPosObj    :={}
LOCAL aSize		 :=MsAdvSize()
LOCAL aInfo      :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
LOCAL lLoop      := .F.
LOCAL lRetPEButP := .F.  // Habilita botao 'PLANILHA'
LOCAL lMc10Bgrv  := .F. 

STATIC oTot,oLbx
PRIVATE cTitulo:=STR0004+cArqMemo+STR0005+cCusto+If(!Empty(mv_par04),STR0035+mv_par04,"") 	//" Planilha "###" - Custo "###" - Revisao "
PRIVATE cBMPName:=If(lDirecao,"VCPGDOWN","VCPGUP")
PRIVATE aMC010Arred
PRIVATE aTot:={}                           

DEFAULT nTipo := 1

InitArray(.T., @aProd, aFormulas, nMatPrima)
InitArray(.F., @aTot,  aFormulas, nMatPrima)

nTamcol := GetTextWidh(0,"99.999.999,99")

C010AjuSX1()
PERGUNTE("MTC010",.F.)
//����������������������������������������������������������������Ŀ
//� Forca utilizacao da estrutura caso nao tenha SGG               �
//������������������������������������������������������������������
If MC010SX2("SGG") == .F.
	mv_par09:=1
EndIf           
//�������������������������������������������������������������������������������������������Ŀ
//� Ponto de entrada utilizado mostrar o botao de gravacao mesmo quando o ntipo for igual a 2 �
//���������������������������������������������������������������������������������������������
If ExistBlock('MC10BGRV')
	lMc10Bgrv := If(ValType(lMc10Bgrv:=ExecBlock('MC10BGRV', .F., .F., {nTipo}))=='L',lMc10Bgrv,.F.)
Endif	

lAutoCalc := If(mv_par01==1,.T.,.F.)

AADD(aObjects,{450,50,.T.,.T.,.T.})
AADD(aObjects,{450,50,.T.,.T.,.T.})
aPosObj:=MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlg TITLE cTitulo OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
	oFont:= oDlg:oFont
	If cProg == "A318" 
		oLbx := TCBROWSE():New(1,1,1,1, , , , , , , , , , ,oFont, , , , , .F., , .T., , .F.,,)
		cCodPlan := SCO->CO_CODIGO
		cCodRev  := SCO->CO_REVISAO
		cArqMemo := SCO->CO_NOME
		lPesqRev:= .T.	     	
	Else
		oLbx := TCBROWSE():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-50,aPosObj[1,4], , , , , , , , , , ,oFont, , , , , .F., , .T., , .F.,,)
	EndIf
	oLbx:bLDblClick	:= { | nRow, nCol | (Eval(oBtnA:bAction),nPos := Ascan(aArray,{|x| Str(x[1],5) == aProd[oLbx:nAt,1] .And. x[3]==aProd[oLbx:nAt,3]})) }
	oLbx:bChange  	:= {||(nPos := Ascan(aArray,{|x| Str(x[1],5) == aProd[oLbx:nAt,1] .And. x[3]==aProd[oLbx:nAt,3]}),Setfocus(oLbx:hWnd))}
	oLbx:bGotFocus	:= {||(nPos := Ascan(aArray,{|x| Str(x[1],5) == aProd[oLbx:nAt,1] .And. x[3]==aProd[oLbx:nAt,3]}),lMatPrima:=.T. ) }
	oLbx:nAt:=nPos
	ADD COLUMN TO oLbx HEADER aHeader[1,1] OEM DATA {|| aProd[oLbx:nAt,1] } ALIGN LEFT SIZE CalcFieldSize("C",03,0,aHeader[1,2],aHeader[1,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[2,1] OEM DATA {|| aProd[oLbx:nAt,2] } ALIGN LEFT SIZE CalcFieldSize("C",08,0,aHeader[2,2],aHeader[2,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[3,1] OEM DATA {|| aProd[oLbx:nAt,3] } ALIGN LEFT SIZE CalcFieldSize("C",30,0,aHeader[3,2],aHeader[3,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[4,1] OEM DATA {|| aProd[oLbx:nAt,4] } ALIGN LEFT SIZE CalcFieldSize("C",15,0,aHeader[4,2],aHeader[4,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[5,1] OEM DATA {|| aProd[oLbx:nAt,5] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aProd[oLbx:nAt,5]),0,,aHeader[5,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[6,1] OEM DATA {|| aProd[oLbx:nAt,6] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aProd[oLbx:nAt,6]),0,,aHeader[6,1]) PIXELS
	ADD COLUMN TO oLbx HEADER aHeader[7,1] OEM DATA {|| aProd[oLbx:nAt,7] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aProd[oLbx:nAt,7]),0,,aHeader[7,1]) PIXELS
	oLbx:SetArray(aProd)

	If cProg == "A318" 
		oLbx:Hide()
		oTot := TCBROWSE():New(aPosObj[1,1],aPosObj[1,2],aPosObj[2,3]-50,aPosObj[1,4] + aPosObj[2,4], , , , , , , , , , ,oFont, , , , , .F., , .T., , .F.,,)
	Else
		oTot := TCBROWSE():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-50,aPosObj[2,4], , , , , , , , , , ,oFont, , , , , .F., , .T., , .F.,,)
	EndIf
	oTot:bLDblClick := { | nRow, nCol | (Eval(oBtnA:bAction),nPos := Ascan(aArray,{|x| Str(x[1],5) == aTot[oTot:nAt,1] .And. x[3]==aTot[oTot:nAt,2]})) }
	oTot:bChange    := {|| (nPos := Ascan(aArray,{|x| Str(x[1],5) == aTot[oTot:nAt,1] .And. x[3]==aTot[oTot:nAt,2]}),SetFocus(oTot:hWnd))}
	oTot:bGotFocus  := {|| lMatPrima:=.F. }
	oTot:nAt:=nPos
	ADD COLUMN TO oTot HEADER aheader[1,1] OEM DATA {|| aTot[oTot:nAt,1] } ALIGN LEFT SIZE CalcFieldSize("C",03,0,aHeader[1,2],aHeader[1,1]) PIXELS
	ADD COLUMN TO oTot HEADER aHeader[3,1] OEM DATA {|| aTot[oTot:nAt,2] } ALIGN LEFT SIZE CalcFieldSize("C",30,0,aHeader[3,2],aHeader[3,1]) PIXELS
	ADD COLUMN TO oTot HEADER aHeader[6,1] OEM DATA {|| aTot[oTot:nAt,4] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aTot[oTot:nAt,4]),0,,aHeader[6,1]) PIXELS
	ADD COLUMN TO oTot HEADER aHeader[7,1] OEM DATA {|| aTot[oTot:nAt,5] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aTot[oTot:nAt,5]),0,,aHeader[7,1]) PIXELS
	ADD COLUMN TO oTot HEADER OemToAnsi(STR0006) OEM DATA {|| aTot[oTot:nAt,3] } ALIGN LEFT SIZE CalcFieldSize("C",Len(aTot[oTot:nAt,3]),0,,STR0006) PIXELS	//"F�rmula"
 	oTot:SetArray(aTot) 

	DEFINE SBUTTON 		 FROM aPosObj[1,4]-65,aPosObj[1,3]-33 TYPE 4  ENABLE OF oDlg Action Insere(IIF(lMatPrima,@aProd,@aTot),lMatPrima,nPos,@aFormulas,@nMatPrima,lAutoCalc,@oLbx,@oTot)
	DEFINE SBUTTON oBtnA FROM aPosObj[1,4]-50,aPosObj[1,3]-33 TYPE 11 ENABLE OF oDlg Action Altera(IIF(lMatPrima,@aProd,@aTot),lMatPrima,nPos,@aFormulas,nMatPrima,lAutoCalc,@oLbx,@oTot)
	DEFINE SBUTTON 		 FROM aPosObj[1,4]-35,aPosObj[1,3]-33 TYPE 3  ENABLE OF oDlg Action Deleta(IIF(lMatPrima,@aProd,@aTot),lMatPrima,nPos,aFormulas,@nMatPrima,lAutoCalc,@oLbx,@oTot)
	If nTipo == 1 .Or. lMc10Bgrv
		If SuperGetMV("MV_REVPLAN",.F.,.F.)
			DEFINE SBUTTON 		 FROM aPosObj[1,4]-20,aPosObj[1,3]-33 TYPE 13 ENABLE OF oDlg Action (MC010GRVEX(.T.),GeraRev(nMatPrima,aFormulas,oDlg))		
		Else
			DEFINE SBUTTON 		 FROM aPosObj[1,4]-20,aPosObj[1,3]-33 TYPE 13 ENABLE OF oDlg Action (MC010GRVEX(.T.),Grava(nMatPrima,aFormulas,oDlg))
		EndIf
			DEFINE SBUTTON 		 FROM aPosObj[1,4]-05,aPosObj[1,3]-33 TYPE 2  ENABLE OF oDlg Action (MC010GRVEX(.F.),oDlg:End())		
	Else		
		DEFINE SBUTTON 		 FROM aPosObj[1,4]-20,aPosObj[1,3]-33 TYPE 2  ENABLE OF oDlg Action (oDlg:End())			
	Endif	
	
	@ aPosObj[2,1]+05,aPosObj[2,3]-41 BITMAP oBMP NAME If(lDirecao,"VCPGDOWN","VCPGUP") SIZE 5,6 OF oDlg PIXEL NO BORDER                                                             

	@ aPosObj[2,1]+00,aPosObj[2,3]-41 BUTTON oBtnE Prompt OemToAnsi(STR0001) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),Pesquisa(oLbx,aProd,oDlg),DisBut(oBtnD,oBtnE,oBtnF,.F.,lRetPEButP),Def(.F., @oTot, aTot));oBtnE:oFont:=oDlg:oFont	//"&Pesquisar"

	If cProg != "A318" 
		If nTipo == 1	
			If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("PlanRev") 
				@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(PlanRev(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
				oBtnD:oFont:= oDlg:oFont	//"&Planilha"
			Else
				@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(Planilha(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
				oBtnD:oFont:= oDlg:oFont	//"&Planilha"		
			EndIf
		Else 
			If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("PlanRev")
				@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(PlanRev(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
				oBtnD:oFont:= oDlg:oFont	//"&Planilha"	
			Else
				@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(Planilha(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
				oBtnD:oFont:= oDlg:oFont	//"&Planilha"				
			EndIf
		EndIf
	Else
		If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("PlanRev") 
			@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(PlanRev(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
			oBtnD:oFont:= oDlg:oFont	//"&Planilha"
		Else
			@ aPosObj[2,1]+15,aPosObj[2,3]-41 BUTTON oBtnD Prompt OemToAnsi(STR0007) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),IIF(Planilha(oBtnD,oBtnE,oBtnF),(oDlg:End(),lLoop:=.T.),))
			oBtnD:oFont:= oDlg:oFont	//"&Planilha"		
		EndIf			
	EndIf
			
	//����������������������������������������������������������������������Ŀ
	//� MC010BUT - Ponto de Entrada para criar botoes de usuario.		 	 �
	//�            Outro uso: Retornando .T. inibe o botao 'Planilha'. 		 �
	//������������������������������������������������������������������������		
	lRetPEButP:= .F.
	If (ExistBlock("MC010BUT"))
		lRetPEButP := ExecBlock("MC010BUT",.F.,.F.,{@oDlg,aPosObj,aProd,aFormulas,aTot})
		lRetPEButP := If(ValType(lRetPEButP)=="L",lRetPEButP,.F.)
	EndIf
	If lRetPEButP
		oBtnD:Disable()
	EndIf	
			
	@ aPosObj[2,1]+30,aPosObj[2,3]-41 BUTTON oBtnE Prompt OemToAnsi(STR0008) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),ReCalculo(nMatPrima,@aProd,@aTot,aFormulas),DisBut(oBtnD,oBtnE,oBtnF,.F.,lRetPEButP),Def(.F., @oTot, aTot));oBtnE:oFont:=oDlg:oFont	//"&Rec�lculo"
	@ aPosObj[2,1]+45,aPosObj[2,3]-41 BUTTON oBtnF Prompt OemToAnsi(STR0009) SIZE 44, 11 OF oDlg PIXEL Action (DisBut(oBtnD,oBtnE,oBtnF,.T.,lRetPEButP),Custo(@aTot,@aProd,nMatPrima,@aFormulas,oDlg),Def(.F.,@oTot,aTot),Def(.T.,@oLbx,aProd),DisBut(oBtnD,oBtnE,oBtnF,.F.,lRetPEButP));oBtnF:oFont:= oDlg:oFont	//"&Custo"
	@ aPosObj[2,1]+60,aPosObj[2,3]-41 BUTTON oBtnG Prompt OemToAnsi(STR0034) SIZE 44, 11 OF oDlg PIXEL Action (lDirecao:=!lDirecao, oBMP:SetBMP(If(lDirecao,"VCPGDOWN","VCPGUP")))	//"&Dire��o"
ACTIVATE MSDIALOG oDlg
If lLoop
	lLoop:=.F.
	If nTipo == 1	
		If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("MC010FORM2")
			MC010Form2(Alias(),Recno(),2)
		Else
			MC010Forma(Alias(),Recno(),2)	
		EndIf
	Else
		If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("MC010FORM2")
			MC010Form2("SB1",SB1->(Recno()),98,1,2)
	    Else
			MC010Forma("SB1",SB1->(Recno()),98,1,2)		
		EndIf
	EndIf
EndIf	
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Altera   � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Altera o conteudo da Linha da planilha                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Altera(aArr,lMatPrima,n,aFormulas,nMatPrima,lAutoCalc,oLbx,oTot)
LOCAL nUltNivel
LOCAL nX,nQuantAnt,nValTotAnt, nTempSet := 0
LOCAL nDec:=0,nTam:=0
LOCAL cProd:="",cDesc:="",nQtd:=0,nValtot:=0,nPerc:=0
LOCAL cDescricao := ""
LOCAL cAlias:=Alias(),nOrder:=IndexOrd(),nRecno:=Recno()
LOCAL cCelPer:=Space(5)
//����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas p/ verificar se produto e'fixo/variavel         �
//������������������������������������������������������������������������
LOCAL nNiv:=1000,lFixo:=.F.

Local lInt 		:= Iif(!AliasInDic("SCO"),.F.,SCO->(FieldPos("CO_INTPV") > 0 .And. FieldPos("CO_INTPUB") > 0 ) .And. Len(aArray[n]) >= 15 .And. ValType(aArray[n][15]) == "A" .And. Len(aArray[n][15]) >= 2)
Local cIntPv	:= Iif( lInt, aArray[n][15][1], Nil)
Local cIntPub	:= Iif( lInt, aArray[n][15][2], Nil)

//����������������������������������������������������������������������Ŀ
//� Inicializa variaveis do GET                                          �
//������������������������������������������������������������������������
cDesc 		:=aArray[n,3]
cProd 		:=aArray[n,4]
nQtd		:=aArray[n,5]
nQuantAnt	:=aArray[n,5]
nValTot		:=aArray[n,6]
nValTotAnt	:=aArray[n,6]
nPerc 		:=aArray[n,7]
If lMatPrima
	If GetProd(@aArr,lMatPrima,@cProd,@cDesc,@nQtd,@nValTot,@nPerc,n,nMatPrima,lAutoCalc,aFormulas,.F.)
		If n > nMatPrima+nQtdTotais
			nTam := Len(Subs(Trim(aHeader[6,2]),AT("9",Trim(aHeader[6,2])),Len(Trim(aHeader[6,2]))))
			nDec := Len(Subs(Trim(aHeader[6,2]),AT(".",Trim(aHeader[6,2]))+1,Len(Trim(aHeader[6,2]))-AT(".",Trim(aHeader[6,2]))))
			nDec := IIF(nDec==0,2,nDec)
			aFormulas[n-nMatPrima-nQtdTotais,1] := PadR(Str(nValTot,nTam,nDec),100)
		EndIf
		aArray[n][3] := cDesc
		aArray[n][4] := cProd
		aArray[n][5] := nQtd
		aArray[n][6] := nValTot
		If nQtd != nQuantAnt .Or. nValTot != nValTotAnt
			dbSelectArea(If(mv_par09=1,"SG1","SGG"))
			dbSetOrder(1)
			//��������������������������������������������������������������������Ŀ
			//� Verifica se existe produto fixo na estrutura                       �
			//����������������������������������������������������������������������
			For nX := n+1 To nMatPrima-2
				If Val(aArray[nx][2]) > Val(aArray[n][2])
					If aArray[nX][13] $ "V "
						If Val(aArray[nx,2]) <= nNiv
							lFixo:=.F.
							nNiv:=Val(aArray[nx,2])
						EndIf
					Else
						If Val(aArray[nx,2]) <= nNiv
							lFixo:=.T.
							nNiv:=Val(aArray[nx,2])
						EndIf
					EndIf
					If !lFixo .And. aArray[nX][13] $ "V "
					    If !(IsProdMod(Upper(aArray[nX][4])))
						   aArray[nX][5] := (aArray[nX][5]/nQuantAnt) * nqtd
						   aArray[nX][6] := (aArray[nX][6]/nQuantAnt) * nqtd
						Else 
						   nTempSet:=MC010SETUP(aArray[1][4],aArray[nx,5],nQtd,nQuantAnt,aArray[nx,14])
						   aArray[nX][5] := nTempSet   
					       nTempSet:=MC010SETUP(aArray[1][4],aArray[nx,6],nQtd,nQuantAnt,aArray[nx,14])
						   aArray[nX][6] := nTempSet 
						Endif   
					EndIf
				Else
					Exit
				EndIf
			Next nX  
		EndIf
		dbSelectArea(cAlias)
		dbSetOrder(nOrder)
		dbGoto(nRecno)
		nUltNivel := CalcUltNiv()
		CalcTot(nMatPrima,nUltNivel,aFormulas,nQualCusto)
		InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
		Def(lMatPrima,@oLbx,aArr)
	EndIf
Else
	If n >= nMatPrima .And. n < nMatPrima+nQtdTotais
		cDescricao := aArray[n][3]
		cFormula   := aTotais[(n-nMatPrima)+1]
		If GetFormula(@aArr,@cDescricao,@cFormula,@nValTot,n,nMatPrima,,@cIntPv,@cIntPub)
			aArray[n][3]             := cDescricao
			If lInt
				aArray[n][15][1] := cIntPv
				aArray[n][15][2] := cIntPub
			EndIf
			aTotais[(n-nMatPrima)+1] := cFormula
			If lAutoCalc
				RecalcTot(nMatPrima)
				CalcForm(aFormulas,nMatPrima)
			EndIf
			InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
			Def(lMatPrima,@oTot,aArr)
		EndIf
	ElseIf n > nMatPrima+nQtdTotais .And. n < Len(aArray)
		cDescricao := aArray[n][3]
		cFormula   := aFormulas[n-nMatPrima-nQtdTotais,1]
		cCelPer	   := Substr(aFormulas[n-nMatPrima-nQtdTotais,2],2,5)
		If GetFormula(@aArr,@cDescricao,@cFormula,@nValTot,n,nMatPrima,@cCelPer,@cIntPv,@cIntPub)
			aArray[n][3] := cDescricao
			If At("#",cFormula) > 0
				aArray[n][10] := .F.
			EndIf
			If lInt
				aArray[n][15][1] := cIntPv
				aArray[n][15][2] := cIntPub
			EndIf
			aFormulas[n-nMatPrima-nQtdTotais,1] := cFormula
			aFormulas[n-nMatPrima-nQtdTotais,2] := If(Empty(cCelPer), Space(6), "#"+cCelPer)
			If lAutoCalc
				RecalcTot(nMatPrima)
				CalcForm(aFormulas,nMatPrima)
			EndIf
			InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
			Def(lMatPrima,@oTot,aArr)
		EndIf
	EndIf
EndIf
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Deleta   � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Deleta a Linha da planilha                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Deleta(aArr,lMatprima,n,aFormulas,nMatPrima,lAutoCalc,oLbx,oTot)

Local nX := 0 
Local nUltNivel

If lMatPrima
	cNivEstr := aArray[n][2]
	If Val(cNivEstr) == 1
		Help(" ",1,"C010Nivel")
		RETURN .F.
	EndIf
	If Val(cNivEstr) == 0
		RETURN
	EndIf
	nDelet := 0
	aArray := ADel(aArray,n)
	aArray := ASize(aArray,Len(aArray)-1)
	nMatPrima--
	nDelet --
	While Val(aArray[n][2]) > Val(cNivEstr)
		aArray := ADel(aArray,n)
		aArray := ASize(aArray,Len(aArray)-1)
		nMatPrima--
		nDelet --
	End
	For nX := 1 To Len(aFormulas)
		If AT("#",aFormulas[nX,1]) > 0
			aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],nDelet,n)
		EndIf
		If !Empty(aFormulas[nX,2])
			aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))+nDelet,5)
		EndIf
	Next nX
	For nX := Len(aArray) To 1 Step -1
		If aArray[nX][1] == nX
			Exit
		EndIf
		aArray[nX][1] := nX
	Next nX
	If lAutoCalc
		RecalcTot(nMatPrima)
		CalcForm(aFormulas,nMatPrima)
	EndIf
	Recalculo(nMatPrima,@aArr,@aTot,aFormulas)				
	nUltNivel := CalcUltNiv()
	CalcTot(nMatPrima,nUltNivel,aFormulas,nQualCusto)
	InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
	Def(lMatPrima,@oLbx,aArr)	
Else
	If n >= nMatPrima .And. n < nMatPrima+nQtdTotais
		For nX := 1 To Len(aFormulas)
			If AT("#",aFormulas[nX,1]) > 0
				aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],-1,n)
			EndIf
			If !Empty(aFormulas[nX,2])
				aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))-1,5)
			EndIf
		Next nX
		aTotais := ADel(aTotais,(n-nMatPrima)+1)
		aTotais := ASize(aTotais,Len(aTotais)-1)
		nQtdTotais--
		aArray := ADel(aArray,n)
		aArray := ASize(aArray,Len(aArray)-1)
		For nX := Len(aArray) To 1 Step -1
			If aArray[nX][1] == nX
				Exit
			EndIf
			aArray[nX][1] := nX
		Next nX
		If lAutoCalc
			RecalcTot(nMatPrima)
			CalcForm(aFormulas,nMatPrima)
		EndIf                                                   
		Recalculo(nMatPrima,@aArr,@aTot,aFormulas)						
	ElseIf n > nMatPrima+nQtdTotais .And. n < Len(aArray)
		For nX := 1 To Len(aFormulas)
			If AT("#",aFormulas[nX,1]) > 0
				aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],-1,n)
			EndIf
			If !Empty(aFormulas[nX,2])
				aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))-1,5)
			EndIf
		Next nX
		aFormulas := ADel(aFormulas,n-nMatPrima-nQtdTotais)
		aFormulas := ASize(aFormulas,Len(aFormulas)-1)
		nQtdFormula--
		aArray := ADel(aArray,n)
		aArray := ASize(aArray,Len(aArray)-1)
		For nX := Len(aArray) To 1 Step -1
			If aArray[nX][1] == nX
				Exit
			EndIf
			aArray[nX][1] := nX
		Next nX
		If lAutoCalc
			RecalcTot(nMatPrima)
			CalcForm(aFormulas,nMatPrima)
		EndIf
		Recalculo(nMatPrima,@aArr,@aTot,aFormulas)						
		InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
		Def(lMatPrima,@oTot,aArr)		
	EndIf
EndIf
IF(lMatPrima,Def(lMatPrima,@oLbx,aArr),Def(lMatPrima,@oTot,aArr))
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Insere   � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Insere uma linha na planilha                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Insere(aArr,lMatPrima,n,aFormulas,nMatprima,lAutoCalc,oLbx,oTot)
LOCAL cProd:="",nQtd:=0,nValtot:=0,nPerc:=0
LOCAL cDescricao := "",cCelPer:=Space(5)
LOCAL nX := 0
LOCAL cTrt:=If(mv_par09==1,Criavar("G1_TRT",.F.),Criavar("GG_TRT",.F.))
LOCAL cFixVar:=If(mv_par09==1,Criavar("G1_FIXVAR",.F.),Criavar("GG_FIXVAR",.F.))

Local lInt 		:= Iif(!AliasInDic("SCO"),.F.,SCO->(FieldPos("CO_INTPV") > 0 .And. FieldPos("CO_INTPUB") > 0 ) .And. Len(aArray[n]) >= 15 .And. ValType(aArray[n][15]) == "A" .And. Len(aArray[n][15]) >= 2)
Local cIntPv	:= Iif( lInt, aArray[n][15][1], Nil)
Local cIntPub	:= Iif( lInt, aArray[n][15][2], Nil)


If lMatPrima
	cNivEstr := aArray[n][2]
	If Val(cNivEstr) == 1
		Help(" ",1,"C010Nivel")
		RETURN .F.
	EndIf
	If Val(cNivEstr) == 0
		nNivel := Val(aArray[n-1][2])
		If nNivel > 1
			nNivel--
		EndIf
		cNivEstr:=Space(IIF(nNivel+1<=5,nNivel,4))+LTRIM(STR(nNivel+1,2))
	EndIf
	For nX := 1 To Len(aFormulas)
		If AT("#",aFormulas[nX,1]) > 0
			aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],1,n)
		EndIf
		If !Empty(aFormulas[nX,2])
			aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))+1,5)
		EndIf
	Next nX
	AAdd(aArray,{})
	aArray := AIns(aArray,If(n==1,2,n))
	nMatPrima++
	aArray[n] := {n,cNivEstr,Space(30),Space(15),1,0,0,.T.,"  ",.T.,cTrt,If(substr(cAcesso,39,1)=="S",.T.,.F.),cFixVar}		
	For nX := Len(aArray) To 1 Step -1
		If aArray[nX][1] == nX
			Exit
		EndIf
		aArray[nX][1] := nX
	Next nX
	cProd := aArray[n][4]
	nQtd := 1
	If !GetProd(@aArr,lMatPrima,@cProd,@cDescricao,@nQtd,@nValTot,@nPerc,n,nMatPrima,lAutoCalc,aFormulas,.T.)
		For nX := 1 To Len(aFormulas)
			If AT("#",aFormulas[nX,1]) > 0
				aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],-1,n)
			EndIf
			If !Empty(aFormulas[nX,2])
				aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))-1,5)
			EndIf
		Next nX
		aArray := ADel(aArray,n)
		aArray := ASize(aArray,Len(aArray)-1)
		nMatPrima--
		For nX := Len(aArray) To 1 Step -1
			If aArray[nX][1] == nX
				Exit
			EndIf
			aArray[nX][1] := nX
		Next nX
	Else
		aArray[n][3] := cDescricao
		aArray[n][4] := cProd
		aArray[n][5] := nQtd
		aArray[n][6] := nValTot
		aArray[n][9] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPO")
	EndIf
	If lAutoCalc
		RecalcTot(nMatPrima)
		CalcForm(aFormulas,nMatPrima)
	EndIf
	Recalculo(nMatPrima,@aArr,@aTot,aFormulas)			
	Def(lMatPrima,@oLbx,aArr)
Else
	If n >= nMatPrima .And. n < nMatPrima+nQtdTotais
		If nQtdTotais == 0
			cDescricao := Space(30)
			cFormula   := Space(100)
		Else
			cDescricao := aArray[n][3]
			cFormula   := aTotais[(n-nMatPrima)+1]
		EndIf
		If !GetFormula(@aArr,@cDescricao,@cFormula,@nValTot,n,nMatPrima,,@cIntPv,@cIntPub)
			RETURN .F.
		Else
			For nX := 1 To Len(aFormulas)
				If AT("#",aFormulas[nX,1]) > 0
					aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],1,n)
				EndIf
				If !Empty(aFormulas[nX,2])
					aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))+1,5)
				EndIf
			Next nX
			AAdd(aTotais," ")
			aTotais := AIns(aTotais,(n-nMatPrima)+1)
			aTotais[(n-nMatPrima)+1] := cFormula
			nQtdTotais++
			AAdd(aArray,{})
			aArray := AIns(aArray,n)
			aArray[n]    := aClone(aArray[n+1])
			aArray[n][3] := cDescricao
			If lInt
				aArray[n][15][1] := cIntPv
				aArray[n][15][2] := cIntPub
			EndIf
			For nX := Len(aArray) To 1 Step -1
				If aArray[nX][1] == nX
					Exit
				EndIf
				aArray[nX][1] := nX
			Next nX
			If lAutoCalc
				RecalcTot(nMatPrima)
				CalcForm(aFormulas,nMatPrima)
			EndIf
			InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
			Def(lMatPrima,@oTot,aArr)
		EndIf
	ElseIf n > nMatPrima+nQtdTotais .And. n < Len(aArray)
		cDescricao := aArray[n][3]
		cFormula   := aFormulas[n-nMatPrima-nQtdTotais,1]
		cCelPer	  := Substr(aFormulas[n-nMatPrima-nQtdTotais,2],2,5)
		If !GetFormula(@aArr,@cDescricao,@cFormula,@nValTot,n,nMatPrima,@cCelPer,@cIntPv,@cIntPub)
			RETURN .F.
		Else
			For nX := 1 To Len(aFormulas)
				If AT("#",aFormulas[nX,1]) > 0
					aFormulas[nX,1] := AcertaForm(aFormulas[nX,1],1,n)
				EndIf
				If !Empty(aFormulas[nX,2])
					aFormulas[nX,2] := "#"+StrZero(Val(Substr(aFormulas[nx,2],2,5))+1,5)
				EndIf
			Next nX
			ASize(aFormulas,Len(aFormulas)+1)
			AIns(aFormulas,n-nMatPrima-nQtdTotais)
			AFill(aFormulas,{,},n-nMatPrima-nQtdTotais,1)
			aFormulas[n-nMatPrima-nQtdTotais,1] := cFormula
			aFormulas[n-nMatPrima-nQtdTotais,2] := If(Empty(cCelPer), Space(6), "#"+cCelPer)
			nQtdFormula++
			AAdd(aArray,{})
			aArray := AIns(aArray,n)
			aArray[n]    := aClone(aArray[n+1])
			aArray[n][3] := cDescricao
			If lInt
				aArray[n][15][1] := cIntPv
				aArray[n][15][2] := cIntPub
			EndIf
			For nX := Len(aArray) To 1 Step -1
				If aArray[nX][1] == nX
					Exit
				EndIf
				aArray[nX][1] := nX
			Next nX
			If lAutoCalc
				RecalcTot(nMatPrima)
				CalcForm(aFormulas,nMatPrima)
			EndIf
			InitArray(lMatPrima,@aArr,aFormulas, nMatPrima)
			Def(lMatPrima,@oTot,aArr)
		EndIf
	EndIf
EndIf
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Grava 	� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava o arquivo .PDV da planilha                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Grava(nMatPrima,aFormulas,oDlg2)
LOCAL lRet := .F.,cArq, oDlg   
LOCAL cArqUsu
Local nTamCONome := TamSX3("CO_NOME")[1]

If (ExistBlock("MC010NOM"))
	cArqUsu := ExecBlock("MC010NOM",.F.,.F.,cArqMemo)
	If ValType(cArqUsu) == "C"
		cArqMemo := cArqUsu
	EndIf			
EndIf

cArqAnt := cArqMemo+Space(nTamCONome-Len(cArqMemo))
Do While .T.
	lConfirma := .F.
	DEFINE MSDIALOG oDlg FROM 15,1 TO 168,302 PIXEL TITLE OemToAnsi(STR0010) 	//"Grava��o em Disco"
		@ 7, 7 TO 52, 135 LABEL "" OF oDlg  PIXEL
		@ 28, 25 MSGET cArqAnt Picture "@!" SIZE 82, 10 OF oDlg PIXEL  Valid !" "$(Trim(cArqAnt))
		@ 19, 25 SAY STR0011 SIZE 53, 7 OF oDlg PIXEL	//"&Nome do Arquivo:"
		DEFINE SBUTTON FROM 58, 081  TYPE 1 ENABLE OF oDlg Action(lRet := .T.,oDlg:End())
		DEFINE SBUTTON FROM 58, 108 TYPE 2 ENABLE OF oDlg Action(lRet := .F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	If !lRet
		RETURN NIL
	Else
	cArq := Trim(cArqAnt)+".PDV"
	If File(cArq)
		If MsgYesNo(OemToAnsi(STR0012+Trim(cArqAnt)+STR0013))	//"Entrada : "###", j� existe, Regrava?"
			lConfirma := .T.
			Exit
		EndIf
	EndIf
	lConfirma := .T.
	Exit
	EndIf
EndDo
If lConfirma
	cTitulo:=STR0004+cArqAnt+STR0005+cCusto	//" Planilha "###" - Custo "
	oDlg2:CTITLE(cTitulo)
	MC010Grava(cArq, cArqAnt, nMatPrima, aFormulas)
EndIf
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Custo    � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Altera o custo da planilha.                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Custo(aTot,aProd,nMatPrima,aFormulas,oDlg2)
LOCAL  nQualCust2:=0,nUltNivel,oCusto,nCusto,oDlg
LOCAL aCustos[8],nX:=1,lRet := .F., oBtnA
nCusto		:= nQualCusto
nQualCust2	:= nQualCusto
aCustos := {STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021} //"STANDARD"###"MEDIO"###"MOEDA2"###"MOEDA3"###"MOEDA4"###"MOEDA5"###"ULTPRECO"###"PLANILHA"
DEFINE MSDIALOG oDlg FROM 15,5 TO 222,309 TITLE STR0022 PIXEL	//"Selecione Tipo de Custo"
	@ 11,12 LISTBOX oCusto FIELDS HEADER  ""  SIZE 131, 69 OF oDlg PIXEL;
		  ON CHANGE (nCusto := oCusto:nAt)
	oCusto:SetArray(aCustos)
	oCusto:bLine := { || {aCustos[oCusto:nAT]} }
	DEFINE SBUTTON oBtnA FROM 83, 088 TYPE 1 ENABLE OF oDlg Action (lRet := .T.,oDlg:End())
	DEFINE SBUTTON FROM 83, 115 TYPE 2 ENABLE OF oDlg Action (lRet:= .F.,ODlg:End())
ACTIVATE MSDIALOG oDlg CENTER
If !lRet
	RETURN NIL
EndIf

If nCusto	  == 1
	cCusto := STR0014	//"STANDARD"
ElseIf nCusto == 2
	cCusto := STR0015+" "+MV_MOEDA1	//"MEDIO"
ElseIf nCusto == 3
	cCusto := STR0015+" "+MV_MOEDA2	//"MEDIO"
ElseIf nCusto == 4
	cCusto := STR0015+" "+MV_MOEDA3	//"MEDIO"
ElseIf nCusto == 5
	cCusto := STR0015+" "+MV_MOEDA4	//"MEDIO"
ElseIf nCusto == 6
	cCusto := STR0015+" "+MV_MOEDA5	//"MEDIO"
ElseIf nCusto == 7
	cCusto := STR0020	//"ULTPRECO"
ElseIf nCusto == 8
	cCusto := STR0021	//"PLANILHA"
EndIf
cTitulo := STR0004+cArqMemo+STR0005+cCusto	//" Planilha "###" - Custo "
oDlg2:CTITLE(cTitulo)
If nCusto != nQualCust2 .And. nCusto != nQualCusto
	nQualCusto := nCusto
	nUltNivel := CalcUltNiv()
	CalcTot(nMatPrima,nUltNivel,aFormulas)
	InitArray(.T., @aProd, aFormulas, nMatPrima)
	InitArray(.F., @aTot,  aFormulas, nMatPrima)
EndIf
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Recalculo� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Recalcula toda a planilha inclusive suas formulas          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Recalculo(nMatPrima,aArr,aArr1,aFormulas)

RecalcTot(nMatPrima)
CalcForm(aFormulas,nMatPrima)
InitArray(.T., @aArr,  aFormulas, nMatPrima)
InitArray(.F., @aArr1, aFormulas, nMatPrima)
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Planilha � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Le planilha gravada no disco                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Planilha(oBtnD,oBtnE,oBtnF)
LOCAL aDiretorio,nX,oPlan, oDlg, oBtnA
LOCAL lRet:=.F.
aDiretorio := Directory("*.PDV")
For nX := 1 To Len(aDiretorio)
	aDiretorio[nX] := SubStr(aDiretorio[nX][1],1,AT(".",aDiretorio[nX][1])-1)
	If aDiretorio[nX] == "STANDARD"
		aDiretorio[nX] := Space(14)
	Else
		aDiretorio[nX] := "   "+aDiretorio[nX]+Space(11-Len(aDiretorio[nX]))
	EndIf
Next nX
Asort(aDiretorio)
If Empty(aDiretorio[1])
	aDiretorio[1] := "   STANDARD   "
EndIf
nX :=1
DisBut(oBtnD,oBtnE,oBtnF,.F.)
DEFINE MSDIALOG oDlg FROM 15,6 TO 222,309 TITLE STR0023 PIXEL	//"Selecione Planilha"
	@ 11,12 LISTBOX oPlan FIELDS HEADER  ""  SIZE 131, 69 OF oDlg PIXEL;
		  ON CHANGE (nX := oPlan:nAt) ON DBLCLICK (Eval(oBtnA:bAction))
	oPlan:SetArray(aDiretorio)
	oPlan:bLine := { || {aDiretorio[oPlan:nAT]} }
	DEFINE SBUTTON oBtnA FROM 83, 088 TYPE 1 ENABLE OF oDlg Action(lRet := .T.,oDlg:End())
	DEFINE SBUTTON FROM 83, 115 TYPE 2 ENABLE OF oDlg Action (lRet:= .F.,ODlg:End())
ACTIVATE MSDIALOG oDlg CENTER
cArqMemo := AllTrim(aDiretorio[nX])
RETURN lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GetFormula� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta a tela de Get das formulas                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetFormula(aArr,cDescricao,cFormula,nValTot,n,nMatPrima,cCelPer,cIntPv,cIntPub)
LOCAL cCel			:= AArray[n,1], oDlg
LOCAL lGetCelPer	:= IIF(cCelPer == NIL,.F.,.T.)
Local lInt			:= !(cIntPv == Nil) .And. !(cIntPub == Nil)
Local aCBoxPv, oBoxPv
Local aCBoxPub, oBoxPub

cCelPer:=IIF(cCelPer == NIL,Space(5),cCelPer)
lRet := .F.

DEFINE MSDIALOG oDlg FROM 54,63 TO 500,400 TITLE cTitulo PIXEL
	@ 003, 07 TO 040, 165 LABEL "" OF oDlg  PIXEL
	@ 041, 07 TO 194, 165 LABEL "" OF oDlg  PIXEL
	@ 014, 16 SAY OemToAnsi(STR0024) SIZE 21, 7 OF oDlg PIXEL	//"C�lula:"
	@ 023, 16 MSGET cCel SIZE 25, 10 OF oDlg PIXEL WHen .F.
	@ 014, 57 SAY OemToAnsi(STR0025) SIZE 31, 7 OF oDlg PIXEL	//"Descri��o:"
	If lInt
		aCBoxPv	:= MATA315Cmb( .T. /*lRetArray*/)
		oBoxPv	:= Nil

      aCBoxPub := {}
      aEval( RetSx3Box( Posicione("SX3", 2, "CO_INTPUB", "X3CBox()" ),,,1), {| x | aAdd(aCBoxPub,x[1]) })
		oBoxPub	:= Nil

		@ 023, 57 MSGET cDescricao SIZE 85, 10 OF oDlg PIXEL  F3 "SCO1"
		@ 050, 16 SAY OemToAnsi(STR0026) SIZE 25, 7 OF oDlg PIXEL	//"F�rmula:"
		@ 059, 16 MSGET cFormula SIZE 125, 10 OF oDlg PIXEL  VALID !Empty(cFormula) .And. C10VldForm(cFormula,@cIntPv,@cIntPub) F3 "SCO2"
	Else
		@ 023, 57 MSGET cDescricao SIZE 85, 10 OF oDlg PIXEL  F3 "SCO1"
		@ 050, 16 SAY OemToAnsi(STR0026) SIZE 25, 7 OF oDlg PIXEL	//"F�rmula:"
		@ 059, 16 MSGET cFormula SIZE 125, 10 OF oDlg PIXEL  VALID !Empty(cFormula)
	EndIf
	@ 078, 16 SAY OemToAnsi(STR0027) SIZE 34, 7 OF oDlg PIXEL	//"Valor Total:"
	@ 087, 16 MSGET nValTot SIZE 125, 10 OF oDlg PIXEL When (aArray[n,8] .and. aArray[n,10])
	@ 106, 16 SAY OemToAnsi(STR0028+" ( # )") SIZE 55, 7 OF oDlg PIXEL	//"C�lula Percentual:"
	@ 115, 16 MSGET cCelPer Picture "99999" SIZE 25, 10 OF oDlg PIXEL When lGetCelPer  Valid Empty(cCelPer) .Or. (Val(cCelPer)>0 .And. Val(cCelPer)<=(Len(aArray)-1))


	If lInt 

		@ 136, 16 SAY RetTitle("CO_INTPV") SIZE 70, 7 OF oDlg PIXEL	
		@ 145, 16 combobox oBoxPv var cIntPv items aCBoxPv size 70,08 of oDlg pixel 

		@ 166, 16 SAY RetTitle("CO_INTPUB") SIZE 70, 7 OF oDlg PIXEL	
		@ 175, 16 COMBOBOX oBoxPub VAR cIntPub ITEMS aCBoxPub SIZE 70,08 OF oDlg PIXEL 
	EndIf

	DEFINE SBUTTON FROM 210, 096 TYPE 1 ENABLE OF oDlg Action(lRet := .T.,oDlg:End())
	DEFINE SBUTTON FROM 210, 123 TYPE 2 ENABLE OF oDlg Action(lRet := .F.,oDlg:End())
ACTIVATE MSDIALOG oDlg CENTER

RETURN lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GetProd	� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta a tela de Get dos produtos                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetProd(aArr,lMatPrima,cProd,cDesc,nQtd,nValTot,nPerc,n,nMatPrima,lAutoCalc,aFormulas,lInclui)
LOCAL lRet:=.F., nQtdOld:=nQtd, oDesc, oQtd, oValTot, oPerc, oDlg

DEFINE MSDIALOG oDlg FROM 21,5 TO 241,402 TITLE STR0029 PIXEL	//"Alterar"
	@ 34,  5 TO 99, 157  LABEL "" OF oDlg  PIXEL
	@  8,  8 SAY OemToAnsi(STR0030) SIZE 21, 7 OF oDlg PIXEL	//"C�digo:"
	@ 17,  8 MSGET cProd Picture "@!" SIZE 104, 10 OF oDlg PIXEL Valid ExistCpo("SB1",cProd) .and. MostraDesc(@cDesc,oDesc,cProd) .and. IIF(lInclui,CalcTotal(cProd,nQtd,nQtdOld,@nValTot,oValTot,@nPerc,oPerc,lAutoCalc,aFormulas,nMatprima,lInclui,n),.T.) WHEN lInclui F3 "SB1"
	@  8, 114 SAY OemToAnsi(STR0025) SIZE 35, 7 OF oDlg PIXEL	//"Descri��o:"
	@ 17, 114 MSGET oDesc Var cDesc SIZE 84, 10 OF oDlg PIXEL WHEN .F.
	@ 41, 10 SAY OemToAnsi(STR0031) SIZE 38, 7 OF oDlg PIXEL	//"Quantidade:"
	@ 51, 10 MSGET oQtd Var nQtd SIZE 67, 10 OF oDlg PIXEL Picture StrTran(aHeader[5,2],"Z","") Valid CalcTotal(cProd,nQtd,@nQtdOld,@nValTot,oValTot,nPerc,oPerc,lAutoCalc,aFormulas,nMatprima,lInclui,n) WHEN  (lMatPrima)
	@ 41, 86 SAY OemToAnsi(STR0032) SIZE 38, 7 OF oDlg PIXEL	//"Valor Total:"
	@ 51, 86 MSGET oValTot Var nValTot SIZE 67, 10 OF oDlg PIXEL Picture StrTran(aHeader[6,2],"Z","") WHEN(lMatPrima .and. aArray[n][8] .And. nQualCusto = 8)
	@ 69, 10 SAY OemToAnsi(STR0033) SIZE 68, 7 OF oDlg PIXEL	//"Participa��o (%)"
	@ 79, 10 MSGET oPerc VAR nPerc SIZE 48, 10 OF oDlg PIXEL Picture aHeader[7,2]
	DEFINE SBUTTON FROM 73, 168 TYPE 1 ENABLE OF oDlg Action (lRet := .T.,oDlg:End())
	DEFINE SBUTTON FROM 87, 168 TYPE 2 ENABLE OF oDlg Action (lRet := .F.,oDlg:End())
ACTIVATE MSDIALOG oDlg CENTER
RETURN lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CalcTot	� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula os totais da planilha.                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CalcTotal(cProd,nQtd,nQtdOld,nValTot,oValTot,nPerc,oPerc,lAutoCalc,aFormulas,nMatprima,lInclui,n)
If lInclui
	aArray[n][3] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
	aArray[n][4] := cProd
	aArray[n][5] := nQtd
	aArray[n][6] := IIF(nQualCusto = 8,nValTot,QualCusto(cProd))
	aArray[n][9] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_TIPO")
	If lAutoCalc
		RecalcTot(nMatPrima)
		CalcForm(aFormulas,nMatPrima)
	EndIf
	nQtd	  := aArray[n][5]
	nValTot := aArray[n][6] * nQtd
	nPerc   := aArray[n][7]
	oValTot:Refresh(.F.)
	oPerc:Refresh(.F.)
	oPerc:Disable()
Else
	nQtdOld := IIF(nQtdOld==0,1,nQtdOld)
	nValTot := (nValTot/nQtdOld) * nQtd
	nQtdOld := nQtd
	oPerc:Disable()
EndIf
RETURN .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Def      � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Redesenha BROWSE com inclusao/exclusao efetuada            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Def(lMatPrima,o,aArr)
o:SetArray(aArr)
If lMatPrima
	o:bLine := {|| {aArr[o:nAt,1],aArr[o:nAt,2],aArr[o:nAt,3],aArr[o:nAt,4],aArr[o:nAt,5],aArr[o:nAt,6],aArr[o:nAt,7]} }
Else
	o:bLine := {|| {aArr[o:nAt,1],aArr[o:nAt,2],aArr[o:nAt,4],aArr[o:nAt,5],aArr[o:nAt,3]} }
EndIf
o:nlen:=Len(aArr)
o:Default()
o:nAt := 1
o:Refresh()
o:Display()
SetFocus(o:hWnd)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � InitArray� Autor � Cesar Eduardo Valadao � Data �05/10/1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclui items no Array                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InitArray(lMatPrima, aArr, aFormulas, nMatPrima)
Local i, nCont
aArr := {}
If lMatPrima
	For i := 1 To nMatPrima-2
	   If aArray[i][12]  // Monta array de acordo com acesso do usuario
		  AAdd(aArr,{Str(aArray[i,1],5),aArray[i,2],aArray[i,3],aArray[i,4],Transform(aArray[i,5],aHeader[5,2]),Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])})
	   EndIf	    
	Next
Else
	i := nMatPrima-1
	AAdd(aArr,{Str(aArray[i,1],5),aArray[i,3],aArray[i,4],Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])})
	nCont := 1
	For i := nMatPrima To nMatPrima+nQtdTotais-1
		AAdd(aArr,{Str(aArray[i,1],5),aArray[i,3],aTotais[nCont],Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])})
		nCont++
	Next
	AAdd(aArr,{Str(aArray[i,1],5),aArray[i,3],aArray[i,4],Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])})
	nCont := 1
	For i := nMatPrima+nQtdTotais+1 To nMatPrima+nQtdTotais+nQtdFormula
		AAdd(aArr,{Str(aArray[i,1],5),aArray[i,3],aFormulas[nCont,1],Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])}) 
		nCont++
	Next
	AAdd(aArr,{Str(aArray[i,1],5),aArray[i,3],aArray[i,4],Transform(aArray[i,6],aHeader[6,2]),Transform(aArray[i,7],aHeader[7,2])})
EndIf
RETURN(aArr)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MostraDesc� Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra a descricao do produto                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MostraDesc(cDesc,oDesc,cProd)
LOCAL cAlias,nOldRecno,nOldOrder
cAlias:=Alias()
dbSelectArea("SB1")
nOldOrder:=IndexOrd()
nOldRecno:=Recno()
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProd)
cDesc:=SB1->B1_DESC
oDesc:Refresh(.F.)
dbSetOrder(nOldOrder)
dbGoTo(nOldRecno)
dbSelectArea(cAlias)
RETURN .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Posicione� Autor � Ary Medeiros          � Data � 19/08/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para posicionamento e retorno de um campo de 1 arq. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Posicione(Alias,Ordem,Expressao,Campo)                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAPLAN                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Posicione(cAlias,nOrdem,cExpr,cCpo)
LOCAL cSavAlias := Alias(), cRet
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
dbSeek(cExpr)
cRet := &(cCpo)
dbSelectArea(cSavAlias)
RETURN cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DisBut   � Autor � Cristiane Maeda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Habilita / Desabilita Botoes                               ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � DisBut(ExpO1,ExpO2,Expo3,ExpL1,ExpL2)                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Obj ref. ao Botao 'Planilha'                       ���
���          � ExpO2 = Obj ref. ao Botao 'Recalculo'                      ���
���          � ExpO3 = Obj ref. ao Botao 'Custo'                          ���
���          � ExpL1 = Se .T. desabilita os 3 botoes acima;			      ���
���          �         Se .F. habilita botoes acima, mas o botao 'Planilha'��
���          �         so' habilita se 5o.parametro tambem for igual a .F.���
���          � ExpL2 = Somente habilita Botao 'Planilha' se =.F. (default)���
���          �         e o 4o.parametro tambem for igual a .F.			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DisBut(oBt1,oBt2,oBt3,lDisable,lRetPEButP)
DEFAULT lRetPEButP :=.F. // Habilita botao 'PLANILHA'
If lDisable
	oBt1:Disable()
	oBt2:Disable()
	oBt3:Disable()
	CursorWait()
Else
	If !lRetPEButP
		oBt1:Enable()
	EndIf
	oBt2:Enable()
	oBt3:Enable()
	CursorArrow()
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTC010PERG� Autor � Rodrigo de A. Sartorio� Data � 16/06/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada da pergunte                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTC010PERG()
PERGUNTE("MTC010",.T.)
//����������������������������������������������������������������Ŀ
//� Forca utilizacao da estrutura caso nao tenha SGG               �
//������������������������������������������������������������������
If MC010SX2("SGG") == .F.
	mv_par09:=1
EndIf
RETURN NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o    �MC0010GRVEX� Autor � Larson Zordan         � Data � 30/05/01 ��
��������������������������������������������������������������������������Ĵ�
���Descri��o � Chamada do Pto Entrada p/ gravar campos em base de dados    ��
��������������������������������������������������������������������������Ĵ�
��� Uso      � SIGAEST                                                     ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MC010GRVEX(lGrava)
If (ExistTemplate("MC010GRV"))
	ExecTemplate("MC010GRV",.F.,.F.,lGrava)
EndIf
If (ExistBlock("MC010GRV"))
	ExecBlock("MC010GRV",.F.,.F.,lGrava)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Fun��o    �MC010SETUP � Autor �Marcos V. Ferreira     � Data �10/11/04  ��
��������������������������������������������������������������������������Ĵ�
���Descri��o �Retorna o Tempo de Setup de uma Operacao                     ��
��������������������������������������������������������������������������Ĵ�
��� Uso      � SIGAEST                                                     ��
���������������������������������������������������������������������������ٱ
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MC010SETUP(cProd,nQtdArray,nQtd,nQuantAnt,cOperac)
LOCAL lSeek,nTempSet := (nQtdArray/nQuantAnt)*nQtd,cRoteiro
LOCAL aAreaSG2:=SG2->(GetArea())
LOCAL aAreaSB1:=SB1->(GetArea())
LOCAL aAreaSH1:=SH1->(GetArea())

// Utilizado na funcao A690HoraCt() 
PRIVATE cTipoTemp	:=SuperGetMV("MV_TPHR")

DEFAULT cOperac := ""

If mv_par05 == 2  .Or. mv_par05 == 3
   dbSelectArea("SB1")
   dbSetOrder(1)
   If MsSeek(xFilial("SB1")+cProd)
      If !Empty(mv_par06)
          cRoteiro:=mv_par06
      ElseIf !Empty(SB1->B1_OPERPAD)
          cRoteiro:=SB1->B1_OPERPAD
      EndIf
      dbSelectArea("SG2")
      dbSetOrder(1)
      lSeek:=dbSeek(xFilial()+cProd+If(Empty(cRoteiro),"01",cRoteiro)+If(!Empty(cOperac),cOperac,""))
   Endif              
   If lSeek
	// Calcula Tempo de Dura��o baseado no Tipo de Operacao
		If SG2->G2_TPOPER $ " 1"
			nTempSet := Round( (nQtd * ( If(mv_par07 == 3,A690HoraCt(SG2->G2_SETUP) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ), 0) + IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ))+If(mv_par07 == 2, A690HoraCt(SG2->G2_SETUP), 0) ),5)
			If SH1->H1_MAOOBRA # 0
				nTempSet :=Round( nTempSet / SH1->H1_MAOOBRA,5)
			EndIf
		ElseIf SG2->G2_TPOPER == "4"
			nQtdAloc:=nQtd % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
			nQtdAloc:=Int(nQtd)+If(nQtdAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQtdAloc,0)
			nTempSet := Round(nQtdAloc * ( IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) ),5)
			If SH1->H1_MAOOBRA # 0
				nTempSet :=Round( nTempSet / SH1->H1_MAOOBRA,5)
			EndIf
		ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
			nTempSet := IIf( SG2->G2_TEMPAD == 0 , 1 ,A690HoraCt(SG2->G2_TEMPAD) )
		EndIf
		nTempSet:=nTempSet*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA)
 EndIf
EndIf

RestArea(aAreaSG2)
RestArea(aAreaSB1)
RestArea(aAreaSH1)
						   
Return nTempSet

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MC010SX2   � Autor �Marcos V. Ferreira     � Data �10/11/04  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica no SX2 se existe uma determinada tabela             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function MC010SX2(cTabela) 
Local lRet := .F.
Local aAreaAnt := GetArea()
Local aAreaSX2 := SX2->(GetArea())

dbSelectArea("SX2")
dbSetOrder(1)
If dbSeek(cTabela)
	lRet := .T.
EndIf

RestArea(aAreaSX2)
RestArea(aAreaAnt)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Pesquisa	� Autor � Marcos V. Ferreira    � Data �26.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisa um determinado produto dentro do Browse			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Pesquisa(oLbx2,aProduto,oDlgTela)
Local cProd     := Space(TamSX3("B1_COD")[1])
Local lRet      := .F.
Local lPesquisa := .F.
Local nPos      := 0
Local nX        := 0
Local oDlg, oBtnP

Do While .T.
	lRet:= .F.
	DEFINE MSDIALOG oDlg FROM 15,1 TO 168,285 PIXEL TITLE OemToAnsi(STR0036) 	//"Pesquisa por Componente"
	@ 07, 07 TO 52, 135 LABEL "" OF oDlg  PIXEL
	@ 19, 10 SAY STR0037 SIZE 70, 7 OF oDlg PIXEL	//"&Codigo do Produto:"
	@ 28, 10 MSGET cProd F3 "SB1" Picture "@!" SIZE 120, 10 OF oDlg PIXEL
	@ 60, 25 BUTTON oBtnP Prompt OemToAnsi(STR0038) SIZE 44, 11 OF oDlg PIXEL Action(lRet:= .T.,oDlg:End())
	@ 60, 75 BUTTON oBtnP Prompt OemToAnsi(STR0039) SIZE 44, 11 OF oDlg PIXEL Action(lRet:= .F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	If !lRet
		Exit
	Else
	    nPos := 0
	    For nX := 1 to Len(aProduto)
	    	If aProduto[nX,4] == cProd
	    		nPos := nX
	    		nx := Len(aProduto)
	    	EndIf
		Next nX
		If nPos > 0 
			oLbx:nAt:=nPos
			oLbx:Refresh()
		Else 
			Aviso("MATC010",STR0040,{"Ok"})
		EndIf
	EndIf
EndDo
Return   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Fabio Alves Silva     � Data �05/10/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados     	  ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       
Static Function MenuDef()     
Private aRotina	:= {}

AADD (aRotina, {STR0001,"AxPesqui"  	, 0 , 1,0 ,.F.})	//"Pesquisar"
If SuperGetMV("MV_REVPLAN",.F.,.F.) .And. FindFunction("MC010Form2")
	AADD (aRotina, 	{STR0002,"MC010Form2", 0 , 2, 0,nil})	//"Revisao Planilhas"  	
Else
	AADD (aRotina, 	{STR0002,"U_stforma", 0 , 2, 0,nil})	//"Forma Pre�os"  
EndIf

If ExistBlock ("MTC010MNU")					        
	ExecBlock ("MTC010MNU",.F.,.F.)
EndIf	

Return (aRotina)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor �Alexandre Inacio Lemes � Data �12/11/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ajusta Dicionario SX1.                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATC010                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C010AjuSX1()
Local aArea   := GetArea()
Local nTamSX1 := Len(SX1->X1_GRUPO)

//������������������������������������������������������������������������Ŀ
//�Ajusta o Grupo de Perguntas para nao exibir as perguntas 06 e 07 quando �
//�o programa for executado na versao EXPRESS.                             �
//��������������������������������������������������������������������������
dbSelectArea("SX1")
If MsSeek(PADR("MTC010",nTamSX1)+"06") 
	Reclock("SX1",.F.)
	SX1->X1_PYME := "N"
	MsUnlock()
EndIf

If MsSeek(PADR("MTC010",nTamSX1)+"07") 
	Reclock("SX1",.F.)
	SX1->X1_PYME := "N"
	MsUnlock()
EndIf

dbSelectArea("SX1")
dbSetOrder(1)
//-- Acerta Pergunta 08
If dbSeek(PADR("MTC010",nTamSX1)+"08") 
	Reclock("SX1",.F.)
	Replace X1_PERGUNT	With "Mostra Itens Fantasmas ?"
	Replace X1_PERSPA	With "Muestra Items Fantasmas ?"
	MsUnlock()
EndIf
//-- Acerta Pergunta 09
If dbSeek(PADR("MTC010",nTamSX1)+"09")  
	Reclock("SX1",.F.)
	Replace X1_PERGUNT	With "Mostra ?"
	Replace X1_PERSPA	With "Muestra ?"
	MsUnlock()
EndIf
//-- Acerta Pergunta 10
If dbSeek(PADR("MTC010",nTamSX1)+"10")  
	Reclock("SX1",.F.)
	Replace X1_PERGUNT	With "Considera Tipo Dec. OP ?" 
	Replace X1_PERSPA	With "Considera Tipo Dec. OP ?"
	MsUnlock()
EndIf
//-- Acerta Pergunta 04
If dbSeek(PADR("MTC010",nTamSX1)+"04")
	If X1_TAMANHO != TamSX3("B1_REVATU")[1]
		RecLock("SX1",.F.)
		Replace X1_TAMANHO With TamSX3("B1_REVATU")[1]
		MsUnlock()
	EndIf
EndIf
RestArea(aArea)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraRev 	� Autor � Turibio Miranda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Revisao da planilha de formacao de precos             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATC010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraRev(nMatPrima,aFormulas,oDlg2)
LOCAL aArea	  := GetArea()
LOCAL aAreaSB1:= SB1->(GetArea())
LOCAL lRet 	  := .F.,cArq, oDlg   
LOCAL cArqUsu
LOCAL cQuery:= cAliasTRB:= ""
Local nTamCONome := TamSX3("CO_NOME")[1]

cAliasTRB := "SCO"
#IFDEF TOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT CO_CODIGO, CO_REVISAO, CO_NOME FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*'"
	If cProg == "A318"
		cQuery+= " AND CO_CODIGO ='"+cCodPlan+"'"	
	Else
		cQuery+= " AND CO_NOME ='"+cArqMemo+"'"	
	EndIf
	cQuery+= "Order By CO_CODIGO Desc, CO_REVISAO Desc "	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
#ELSE	
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'")'
	If cProg == "A318"
		cQuery += '.And. (CO_CODIGO == "' + cCodPlan +'")'
	Else
		cQuery += '.And. (CO_NOME == "' + Padr(cArqMemo,TamSX3("CO_NOME")[1]) +'")'
	EndIf
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_PRODUTO+CO_NOME",,cQuery,"")
	cAliasTRB := "SCO" 
	dbSelectArea(cAliasTRB)  
	(cAliasTRB)->(dbGoBottom())
#ENDIF
If (cAliasTRB)->(!Eof()) 
	cCodPlan:= (cAliasTRB)->CO_CODIGO
	cCodRev:= Soma1((cAliasTRB)->CO_REVISAO)
	cArqMemo:= (cAliasTRB)->CO_NOME 
Else
	cCodPlan:= StrZero(1,TamSx3("CO_CODIGO")[1])
	cCodRev := StrZero(1,TamSx3("CO_REVISAO")[1])
EndIf
(cAliasTRB)->(DbCloseArea())
RestArea(aAreaSB1)

If (ExistBlock("MC010NOM"))
	cArqUsu := ExecBlock("MC010NOM",.F.,.F.,cArqMemo)
	If ValType(cArqUsu) == "C"
		cArqMemo := cArqUsu
	EndIf			
EndIf

cArqAnt := cArqMemo+Space(nTamCONome-Len(cArqMemo))
Do While .T.
	lConfirma := .F.
	DEFINE MSDIALOG oDlg FROM 15,1 TO 168,302 PIXEL TITLE OemToAnsi(STR0042) 	//"Gerar Revis�o de Planilha"
		@ 7, 7 TO 52, 135 LABEL "" OF oDlg  PIXEL
		@ 16, 15 MSGET cCodPlan Picture "@!" SIZE 30, 10 OF oDlg PIXEL  WHEN VisualSX3('CO_CODIGO') VALID NumRev(cArqAnt,"R") .And. CheckSX3('CO_CODIGO',cCodPlan)
		@ 16, 75 MSGET cCodRev Picture "@!" SIZE 30, 10 OF oDlg PIXEL  WHEN VisualSX3('CO_REVISAO')	 VALID NumRev(cArqAnt,"C") .And. CheckSX3('CO_REVISAO',cCodRev)	
		@ 8, 15 SAY STR0043 SIZE 30, 7 OF oDlg PIXEL	//"C�d.Plan:"
		@ 8, 75 SAY STR0044 SIZE 30, 7 OF oDlg PIXEL	//"Revis�o:"
		@ 38, 15 MSGET cArqAnt Picture "@!" SIZE 82, 10 OF oDlg PIXEL  WHEN VisualSX3('CO_NOME') 
		@ 30, 15 SAY STR0045 SIZE 53, 7 OF oDlg PIXEL	//"Nome da Planilha:"
		DEFINE SBUTTON FROM 58, 054 TYPE 4  ENABLE OF oDlg Action (NumRev(cArqAnt,"S"))
		DEFINE SBUTTON FROM 58, 081  TYPE 1 ENABLE OF oDlg Action(lRet := .T.,oDlg:End())
		DEFINE SBUTTON FROM 58, 108 TYPE 2 ENABLE OF oDlg Action(lRet := .F.,oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	If !lRet
		RETURN NIL
	Else
		lConfirma:= .T.
		Exit
	EndIf
EndDo
If lConfirma
	cTitulo:=STR0004+Alltrim(cArqAnt)+STR0005+cCusto	//" Planilha "###" - Custo "
	oDlg2:CTITLE(cTitulo)
	MC010Rev(cArq, cArqAnt, nMatPrima, aFormulas, cCodPlan)
	cArqMemo:= cArqAnt
EndIf
RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PlanRev  � Autor � Turibio Miranda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Le planilhas e revisoes gravadas na tabela                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATC010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PlanRev(oBtnD,oBtnE,oBtnF)
LOCAL aPlanilhas,nX,oPlan, oDlg, oBtnA
LOCAL aArea:= GetArea()
LOCAL cQuery:=cAliasTRB:=""
LOCAL lRet:=.F.
Local lTop:=.F.

#IFDEF TOP
	cAliasTRB := GetNextAlias()
	cQuery:="SELECT Distinct CO_CODIGO, CO_REVISAO, CO_NOME, CO_DATA FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
	cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*' "
	cQuery+= "ORDER BY CO_CODIGO DESC, CO_REVISAO DESC, CO_DATA DESC"	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
	ltop:=.T.
#ELSE
	cAliasTRB := CriaTrab(,.F.)
	cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'") .and. CO_PRODUTO <> " "'
	IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_NOME",,cQuery,"")
	cAliasTRB := "SCO"
	dbSelectArea(cAliasTRB)
	lTop:=.F.
#ENDIF

If (cAliasTRB)->(!Eof())
	aPlanilhas := {}
	While (cAliasTRB)->(!Eof())
		AADD(aPlanilhas,{(cAliasTRB)->CO_CODIGO,(cAliasTRB)->CO_REVISAO,(cAliasTRB)->CO_NOME,iif(lTop,STOD((cAliasTRB)->CO_DATA),DTOC((cAliasTRB)->CO_DATA)),})
		(cAliasTRB)->(DbSkip())
	EndDo
	DisBut(oBtnD,oBtnE,oBtnF,.F.)
	DEFINE MSDIALOG oDlg FROM 15,6 TO 240,500 TITLE STR0023 PIXEL	//"Selecione Planilha"
		@ 11,12 LISTBOX oPlan FIELDS HEADER  STR0046,STR0047,STR0048,STR0049  SIZE 231, 75 OF oDlg PIXEL; // C�digo/ Revis�o / Nome , Data
			  ON CHANGE (nX := oPlan:nAt) ON DBLCLICK (Eval(oBtnA:bAction))
		oPlan:SetArray(aPlanilhas)
		oPlan:bLine := { || {aPlanilhas[oPlan:nAT,1],;
							  aPlanilhas[oPlan:nAT,2],;
  							  aPlanilhas[oPlan:nAT,3],;
							  aPlanilhas[oPlan:nAT,4]} }
		DEFINE SBUTTON oBtnA FROM 93, 188 TYPE 1 ENABLE OF oDlg Action(lRet := .T.,oDlg:End())
		DEFINE SBUTTON FROM 93, 215 TYPE 2 ENABLE OF oDlg Action (lRet:= .F.,ODlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	cCodPlan := AllTrim(aPlanilhas[nX,1])
	cCodRev  := AllTrim(aPlanilhas[nX,2])
	cArqMemo := AllTrim(aPlanilhas[nX,3])
	lPesqRev:= .T.	     	
	(cAliasTRB)->(DbCloseArea())
	RestArea(aArea)
Else
	(cAliasTRB)->(DbCloseArea())
	RestArea(aArea)
	Planilha(oBtnD,oBtnE,oBtnF)
	lRet:= .T.
EndIf
RETURN lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NumRev   � Autor � Turibio Miranda       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica numeracao Codigo Planilha e Revisao               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATC010                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NumRev(cArqAnt,cTipo)
LOCAL lRet		:=.T. 
LOCAL lCalcula	:=.T. //Tratamento para futura customizacao - PE
aArea:= GetArea()

DEFAULT cArqAnt := "STANDARD"
DEFAULT cTipo   := "C"

If cTipo == "S"
	cCodPlan:= Soma1(cCodPlan)
	cTipo:= "R"
EndIf
cAliasTRB := "SCO"
If lCalcula
	If cTipo == "C"
	#IFDEF TOP
		cAliasTRB := GetNextAlias()
		cQuery:="SELECT Distinct CO_CODIGO, CO_REVISAO, CO_NOME FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
		cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*' "
		cQuery+= "AND CO_CODIGO='"+cCodPlan+"'"
		cQuery+= "AND CO_CODIGO='"+cCodRev+"'"
		cQuery+= "ORDER BY CO_CODIGO DESC, CO_REVISAO DESC"	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
		If (cAliasTRB)->(!Eof())
			cCodPlan:= Soma1((cAliasTRB)->CO_CODIGO)
		EndIf	
	#ELSE
		cAliasTRB := CriaTrab(,.F.)
		cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'").And.(CO_PRODUTO == "'+SB1->B1_COD+'").And.'
		cQuery += 'CO_NOME == "' + cArqMemo +'")'
		IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_NOME",,cQuery,"")
		cAliasTRB := "SCO"
		dbSelectArea(cAliasTRB)
	#ENDIF
		(cAliasTRB)->(DbCloseArea())  
	EndIf

	If cTipo == "R"
	#IFDEF TOP
		cAliasTRB := GetNextAlias()
		cQuery:="SELECT Distinct CO_CODIGO, CO_REVISAO, CO_NOME FROM "+RetSqlName("SCO")+" "+(cAliasTRB)+" "
		cQuery+="WHERE CO_FILIAL='"+xFilial("SCO")+"'  AND D_E_L_E_T_<>'*' "
		cQuery+= "AND CO_CODIGO='"+cCodPlan+"'"
		cQuery+= "ORDER BY CO_CODIGO DESC, CO_REVISAO DESC"	
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasTRB),.F.,.T.)
		If (cAliasTRB)->(!Eof())
			cCodRev:= Soma1((cAliasTRB)->CO_REVISAO)
		Else
			cCodRev:= StrZero(1,TamSx3("CO_REVISAO")[1])
		EndIf
	#ELSE
		cAliasTRB := CriaTrab(,.F.)
		cQuery := '(CO_FILIAL=="' +xFilial("SCO") +'").And.(CO_PRODUTO == "'+SB1->B1_COD+'").And.'
		cQuery += ' (CO_NOME == "' + cArqMemo +'")'
		IndRegua("SCO",cAliasTRB,"CO_FILIAL+CO_CODIGO+CO_NOME",,cQuery,"")
		cAliasTRB := "SCO"
		dbSelectArea(cAliasTRB)
	#ENDIF              
		(cAliasTRB)->(DbCloseArea())  
	EndIf
EndIf
      
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C010F3Def � Autor � Daniel Leme           � Data �24.01.2011���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta F3 na edi��o da Descri��o de F�rmulas             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � C010F3Def()                SXB( SCO1 )                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function C010F3Def()
Local lRet		:= .F.
Local nTmsItem := 0
Local cTitulo 	:= STR0050 // "Constantes da Planilha de Forma��o de Pre�os"
Local aLenCol	:= {30,50}
Local aRet		:= {	{PadR("#PRECO DE VENDA SUGERIDO......",aLenCol[1]), PadR(STR0051,aLenCol[2])},; // "Utilizado como Pre�o Sugerido no Pedido de Venda"
							{PadR("#PUBLICACAO                   ",aLenCol[1]), PadR(STR0052,aLenCol[2])}}  // "Utilizado como Pre�o Sugerido na Publica��o de Pre�os"

nTmsItem := TmsF3Array( {STR0046,STR0053}, aRet, cTitulo ) // "C�digo" ## "Descri��o"
If	nTmsItem > 0
	//-- VAR_IXB eh utilizada como retorno da consulta F3
	VAR_IXB	:= aRet[ nTmsItem ][1]
	lRet		:= .T.
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C010F3Form� Autor � Daniel Leme           � Data �24.01.2011���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta F3 na edi��o de Formulas                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � C010F3Form()               SXB( SCO2 )                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function C010F3Form()
Local aArea		:= GetArea()
Local aAreaSXB	:= SXB->(GetArea())
Local cArqF3	:= ''
Local lRet		:= .F.
Local nOpc		:= 1
Local oDlgEsp

DEFINE MSDIALOG oDlgEsp TITLE '' FROM 10,12 to 21,45
	@ 05, 005 TO 65, 130 LABEL '' OF oDlgEsp PIXEL
	@ 10, 030 RADIO nOpc ITEMS STR0054, STR0055 3D SIZE 75, 015 OF oDlgEsp PIXEL // "&Itens de Precifica��o" ## "&F�rmulas"
	DEFINE SBUTTON FROM 68, 030 TYPE 1 ACTION (lRet:= .T., oDlgEsp:End(), cArqF3:={'SAV2', 'SM4'}[nOpc]) ENABLE OF oDlgEsp
	DEFINE SBUTTON FROM 68, 070 TYPE 2 ACTION (oDlgEsp:End()) ENABLE OF oDlgEsp
ACTIVATE MSDIALOG oDlgEsp CENTERED

If lRet
	VAR_IXB := {}
	If (lRet := ConPad1(,,, cArqF3,"VAR_IXB",, .F.)  )
		If nOpc == 1
			VAR_IXB := "ITPRC('"  +SAV->AV_CODPRC+"')"
		ElseIf nOpc == 2
			VAR_IXB := "FORMULA('"+SM4->M4_CODIGO+"')"
		EndIf
	EndIf
EndIf
RestArea(aAreaSXB)
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �C10VldForm� Autor � Daniel Leme           � Data �24.01.2011���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida Item de Precifica��o na Formula                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function C10VldForm(cFormula,cIntPv,cIntPub)
Local aArea		:= GetArea()
Local aAreaSAV	:= SAV->(GetArea())
Local lRet 		:= .T.

If "ITPRC" $ cFormula
	If AllTrim(StrTran(cFormula,'"',"'")) == "ITPRC('" + Substr(AllTrim(cFormula),8,Len(SAV->AV_CODPRC)) + "')"

		SAV->(DbSetOrder(1))
		If !SAV->(MsSeek( xFilial("SAV") + Substr(AllTrim(cFormula),8,Len(SAV->AV_CODPRC)) ))		
			Help(" ",1,"REGNOIS")
			lRet := .F.
		Else
			cIntPv	:= SAV->AV_INTPV
			cIntPub	:= SAV->AV_PUBLIC
		EndIf
		
	Else

		Help(" ",1,"ERR_FORM")
		lRet := .F.

	EndIf
EndIf

RestArea( aAreaSAV )
RestArea( aArea )

Return lRet

user Function stforma()

MC010Forma("SB1",SB1->(Recno()),99,1,,.F.," ",.F.)

Return
