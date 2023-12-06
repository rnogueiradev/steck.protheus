#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCTBR03   � Autor � Vitor Merguizo	� Data �  12/11/15���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Classe de Valor Agrupado                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STCTBR03()

Local oReport
Local aArea	     := GetArea()
Private cTitulo  := "Relatorio de Classe de Valor Agrupado"
Private cPerg    := "STCTBR03"

Ajusta()

	oReport:= ReportDef()
	oReport:lParamPage:=.F.
	oReport:PrintDialog()
	
	RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ReportDef� Autor � Microsiga	        � Data � 12.05.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Definicao do layout do Relatorio				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportDef(void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()
Local oReport
Local oSection1

oReport:= TReport():New(cPerg,cTitulo,cPerg,	{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de Classe de Valor Agrupado .")
oReport:SetLandScape(.T.)

pergunte(cPerg,.F.)
	
oSection1 := TRSection():New(oReport,"Lan�amentos",{"CT2"},)
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"EMP"		,, "Empresa",,04, .F.)
TRCell():New(oSection1,"MES"		,, "Mes"	,,10, .F.)
TRCell():New(oSection1,"CLASSE"		,, "Classe"	,,TamSx3("CT2_CLVLDB")[1], .F.)
TRCell():New(oSection1,"DESCLA"		,, "Desc.Classe",,TamSx3("CTH_DESC01")[1], .F.)
TRCell():New(oSection1,"CLASSES"	,, "Classe Sup."	,,TamSx3("CT2_CLVLDB")[1], .F.)
TRCell():New(oSection1,"DESCLAS"	,, "Desc.Classe Sup.",,TamSx3("CTH_DESC01")[1], .F.)
TRCell():New(oSection1,"CC"			,, "C.Custo",,TamSx3("CT2_CCD")[1]   , .F.)
TRCell():New(oSection1,"DESCC"		,, "Desc.C.Custo",,TamSx3("CTT_DESC01")[1], .F.)
TRCell():New(oSection1,"CONTA"		,, "Conta"	,,TamSx3("CT2_DEBITO")[1], .F.)
TRCell():New(oSection1,"DESCON"		,, "Desc.Conta",,TamSx3("CT1_DESC01")[1], .F.)
TRCell():New(oSection1,"DEBITO"		,, "Debito"	,,TamSX3("CT2_VALOR")[1] ,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"CREDITO"	,, "Credito",,TamSX3("CT2_VALOR")[1] ,/*[lPixel]*/,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"MOVTO"		,, "Movimento",,TamSX3("CT2_VALOR")[1] ,/*[lPixel]*/,,"RIGHT",,"RIGHT")

oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SC6")
	
Return oReport

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Microsiga		          � Data �16.11.12 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                            ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportPrint(oReport)

Local cAlias		:= "QRY1CT2"
Local cQuery		:= ""
Local _n		:= 0
Local _i		:= 0
Local n			:= 0
Local nTaxa		:= 0

Local aAreaSM0		:= SM0->(GetArea())
Local aEmpQry		:= {}
Local aEmpresa		:= MarkFile()
Local aDados1[13]
Local oSection1  := oReport:Section(1)

oSection1:Cell("EMP"   )	:SetBlock( { || aDados1[01] } )
oSection1:Cell("MES"   )	:SetBlock( { || aDados1[02] } )
oSection1:Cell("CLASSE")	:SetBlock( { || aDados1[03] } )
oSection1:Cell("CC"    )	:SetBlock( { || aDados1[04] } )
oSection1:Cell("CONTA" )	:SetBlock( { || aDados1[05] } )
oSection1:Cell("DEBITO")	:SetBlock( { || aDados1[06] } )
oSection1:Cell("CREDITO")	:SetBlock( { || aDados1[07] } )
oSection1:Cell("DESCLA")	:SetBlock( { || aDados1[08] } )
oSection1:Cell("CLASSES")	:SetBlock( { || aDados1[09] } )
oSection1:Cell("DESCLAS")	:SetBlock( { || aDados1[10] } )
oSection1:Cell("DESCC" )	:SetBlock( { || aDados1[11] } )
oSection1:Cell("DESCON" )	:SetBlock( { || aDados1[12] } )
oSection1:Cell("MOVTO")		:SetBlock( { || aDados1[13] } )

If Empty(aEmpresa)
	MsgAlert("Aten��o, N�o foi selecionada nenhuma Empresa.")
	Return
EndIf

If Len(aEmpresa) > 0	
	
	For _n := 1 to Len(aEmpresa)
		If aEmpresa[_n][1]
			AADD(aEmpQry,aEmpresa[_n][2])
		EndIf
	Next _n
	
	cQuery += " SELECT EMP,MES,CLASSE,CTH.CTH_DESC01,CTH.CTH_CLSUP,CTHS.CTH_DESC01 CTH_DESCS,CC,CTT.CTT_DESC01,CONTA,CT1_DESC01,DEBITO,CREDITO FROM ("
	
	For _i := 1 to Len(aEmpQry)
		If _i > 1
			cQuery += " UNION ALL"
		EndIf
		
		cQuery += " SELECT '"+aEmpQry[_i]+"' EMP, MES,CLASSE,CC,CONTA,SUM(DEBITO)DEBITO,SUM(CREDITO)CREDITO FROM ( "
		cQuery += " SELECT SUBSTR(CT2_DATA,1,6)MES,CT2_DEBITO CONTA,CT2_CCD CC, CT2_CLVLDB CLASSE, CT2_VALOR DEBITO, 0 CREDITO "
		cQuery += " FROM CT2"+aEmpQry[_i]+"0 CT2 "
		cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_DATA BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND CT2_DC IN ('1','3') AND CT2_MOEDLC = '01' AND CT2_TPSALD = '1' AND CT2.D_E_L_E_T_ = ' ' "
		If !Empty(mv_par03)
			cQuery += " AND CT2_DTLP <> '"+Dtos(mv_par03)+"'"
		EndIf
		cQuery += " UNION ALL "
		cQuery += " SELECT SUBSTR(CT2_DATA,1,6),CT2_CREDIT, CT2_CCC, CT2_CLVLCR, 0 DEBITO, CT2_VALOR CREDITO  "
		cQuery += " FROM CT2"+aEmpQry[_i]+"0 CT2  "
		cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_DATA BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND CT2_DC IN ('2','3') AND CT2_MOEDLC = '01' AND CT2_TPSALD = '1' AND CT2.D_E_L_E_T_ = ' ' "
		If !Empty(mv_par03)
			cQuery += " AND CT2_DTLP <> '"+Dtos(mv_par03)+"'"
		EndIf
		cQuery += " )XXX GROUP BY MES,CLASSE,CC,CONTA "
		
		cQuery += " UNION ALL"
		
		cQuery += " SELECT '"+aEmpQry[_i]+"' EMP, 'Saldo' MES,CLASSE,CC,CONTA,SUM(DEBITO)DEBITO,SUM(CREDITO)CREDITO FROM ( "
		cQuery += " SELECT SUBSTR(CT2_DATA,1,6)MES,CT2_DEBITO CONTA,CT2_CCD CC, CT2_CLVLDB CLASSE, CT2_VALOR DEBITO, 0 CREDITO "
		cQuery += " FROM CT2"+aEmpQry[_i]+"0 CT2 "
		cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_DATA < '"+Dtos(mv_par01)+"' AND CT2_DC IN ('1','3') AND CT2_MOEDLC = '01' AND CT2_TPSALD = '1' AND CT2.D_E_L_E_T_ = ' ' "
		cQuery += " UNION ALL "
		cQuery += " SELECT SUBSTR(CT2_DATA,1,6),CT2_CREDIT, CT2_CCC, CT2_CLVLCR, 0 DEBITO, CT2_VALOR CREDITO  "
		cQuery += " FROM CT2"+aEmpQry[_i]+"0 CT2  "
		cQuery += " WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_DATA < '"+Dtos(mv_par01)+"' AND CT2_DC IN ('2','3') AND CT2_MOEDLC = '01' AND CT2_TPSALD = '1' AND CT2.D_E_L_E_T_ = ' ' "
		cQuery += " )XXX GROUP BY CLASSE,CC,CONTA "
		
		
	Next _i
	
	cQuery += " )BX "
	cQuery += " LEFT JOIN "+RetSqlName("CTH")+" CTH ON CTH.CTH_FILIAL = '"+xFilial("CT2")+"' AND CLASSE = CTH.CTH_CLVL AND CTH.D_E_L_E_T_ = ' ' " 
	cQuery += " LEFT JOIN "+RetSqlName("CTH")+" CTHS ON CTHS.CTH_FILIAL = '"+xFilial("CT2")+"' AND CTH.CTH_CLSUP = CTHS.CTH_CLVL AND CTHS.D_E_L_E_T_ = ' ' " 
	cQuery += " LEFT JOIN "+RetSqlName("CTT")+" CTT ON CTT_FILIAL = '"+xFilial("CT2")+"' AND CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' " 
	cQuery += " LEFT JOIN "+RetSqlName("CT1")+" CT1 ON CT1_FILIAL = '"+xFilial("CT2")+"' AND CONTA = CT1_CONTA AND CT1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY  1,2,3,4,5 "
	
	//cQuery := ChangeQuery(cQuery)
	
	//�������������������������������Ŀ
	//� Fecha Alias se estiver em Uso �
	//���������������������������������
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	//���������������������������������������������
	//� Monta Area de Trabalho executando a Query �
	//���������������������������������������������
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)
	
	TCSetField(cAlias,"DEBITO","N",18,2)
	TCSetField(cAlias,"CREDITO","N",18,2)
	
	DbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter(0)
	
	oReport:SetTitle(cTitulo)
	
	While (cAlias)->(!Eof())
		
		
		aFill(aDados1,nil)
		oSection1:Init()
		
		aDados1[01] := (cAlias)->EMP
		aDados1[02] := (cAlias)->MES
		aDados1[03] := (cAlias)->CLASSE
		aDados1[04] := (cAlias)->CC
		aDados1[05] := (cAlias)->CONTA
		aDados1[06] := (cAlias)->DEBITO
		aDados1[07] := (cAlias)->CREDITO
		aDados1[08] := (cAlias)->CTH_DESC01
		aDados1[09] := (cAlias)->CTH_CLSUP
		aDados1[10] := (cAlias)->CTH_DESCS
		aDados1[11] := (cAlias)->CTT_DESC01
		aDados1[12] := (cAlias)->CT1_DESC01
		aDados1[13] := (cAlias)->(CREDITO-DEBITO)
	
		oSection1:PrintLine()
		
		(cAlias)->(dbSkip())
	EndDo
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
EndIf

oSection1:Finish()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MARKFILE �Autor  � Vitor Merguizo     � Data �  08/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o auxiliar para sele��o de Arquivos                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MarkFile()

Local aArea		:= SM0->(GetArea())
Local aChaveArq := {}
Local lSelecao	:= .T.
Local cTitulo 	:= "Sele��o de Empresas para Gera��o de Relatorio: "
Local cEmpresa	:= ""
Local bCondicao := {|| .T.}

// Vari�veis utilizadas na sele��o de categorias
Local oChkQual,lQual,oQual,cVarQ

// Carrega bitmaps
Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")

// Vari�veis utilizadas para lista de filiais
Local nx := 0
Local nAchou := 0

DbSelectArea("SM0")
DbSetOrder(1)
SM0->(DbGoTop())

While SM0->(!Eof())
	If SM0->M0_CODIGO <> cEmpresa .And. SM0->M0_CODIGO <> "06" //N�o Carrega a EMpresa 06
		//+--------------------------------------------------------------------+
		//| aChaveArq - Contem os arquivos que ser�o exibidos para sele��o |
		//+--------------------------------------------------------------------+
		AADD(aChaveArq,{.F.,SM0->M0_CODIGO,SM0->M0_NOMECOM})
	EndIf
	cEmpresa := SM0->M0_CODIGO
	SM0->(dbSkip())
EndDo

If Empty(aChaveArq)
	ApMsgAlert("Nao foi possivel Localizar Empresas.")
	RestArea(aArea)
	Return aChaveArq
EndIf

RestArea(aArea)

//+--------------------------------------------------------------------+
//| Monta tela para sele��o dos arquivos contidos no diret�rio |
//+--------------------------------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
oDlg:lEscClose := .F.
@ 05,15 TO 125,300 OF oDlg PIXEL
@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Sele��o" SIZE 50, 10 OF oDlg PIXEL;
ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))
@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Codigo","Nome" SIZE;
273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL
oQual:SetArray(aChaveArq)
oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

RETURN aChaveArq

//Fun��o auxiliar: TROCA()
Static Function Troca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

//Fun��o auxiliar: MARCAOK()
Static Function MarcaOk(aArray)
Local lRet:=.F.
Local nx:=0
// Checa marca��es efetuadas
For nx:=1 To Len(aArray)
	If aArray[nx,1]
		lRet:=.T.
	EndIf
Next
// Checa se existe algum item marcado na confirma��o
If !lRet
	MsgAlert("N�o existem Empresas marcadas")
EndIf
Return lRet

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������Ŀ��
���Fun��o	 �Ajusta    � Autor � Vitor Merguizo 		  � Data � 16/08/2012		���
�����������������������������������������������������������������������������������Ĵ��
���Descri��o � Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	���
���          � no SX3                                                           	���
�����������������������������������������������������������������������������������Ĵ��
���Sintaxe e � 																		���
������������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Data de?                     ","Data de?                     ","Data de?                     ","mv_ch1","D",08,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_ch2","D",08,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Data Apur.?                  ","Data Apur.?                  ","Data Apur.?                  ","mv_ch3","D",08,0,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1(cPerg,aPergs)

Return