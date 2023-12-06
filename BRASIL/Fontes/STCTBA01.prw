#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STRCIMP1  �Autor  �Microsiga           � Data �  28/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para atualiza��o da Tabela CFD conforme defini��o da���
���          � area fiscal da Steck                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCTBA01()

Local aSays		:= {}
Local aButtons	:= {}

Private cCadastro 	:= OemToAnsi("Atualiza��o de Lan�amentos: Classe de Valor")
Private cPerg 		:= "STCTBA01"
Private aHeader 	:= {}
Private aCols		:= {}
Private cTabela		:= ""
Private oGetDados1
Private nOpcao 		:= 0

// Funcao para criacao de perguntas da rotina.
Ajusta()

Pergunte(cPerg,.t.)

AAdd(aSays,"Este programa tem como objetivo atualizar o campo Classe de Valor dos Lan�amentos Contabeis.")

AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) } } )
AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

FormBatch(cCadastro,aSays,aButtons)

If nOpcao == 1
	// Funcao para buscar os produtos de acordo com o parametro selecionado
	MsgRun("Atualizando Classes","Aguarde",{ || STCTBA1A() })
EndIf

Return

Static Function fConfMark()

If MsgYesNo("Confirma a Atualiza��o do Lan�amentos de "+dtoc(mv_par01)+" at� "+dtoc(mv_par02)+"?")
	nOpcao := 1
EndIf

Return(.T.)

Static Function STCTBA1A()

Local cQuery	:= ""

//Monta a Regua
ProcRegua(0)

IncProc("Atualizando Lan�amentos...")


If SubStr(cNumEmp,1,2)=="11"

cQuery += " MERGE INTO "+RetSqlName("CT2")+" T1 USING ( "
cQuery += " SELECT RECCT2, " 
cQuery += " NVL((SELECT ZB_CLVL FROM (SELECT * FROM  "+RetSqlName("SZB")+" ORDER BY ZB_GRUPO DESC ,ZB_CC DESC)SZB " 
cQuery += " WHERE ZB_FILIAL = CT2_FILIAL " 
cQuery += " AND ZB_GRUPO = GRUPOD " 
cQuery += " AND (ZB_CC = CT2_CCD OR ZB_CC = ' ') " 
cQuery += " AND SZB.D_E_L_E_T_ = ' ' " 
cQuery += " AND ROWNUM = 1 ),CASE WHEN CT2_DEBITO = ' ' THEN '         ' ELSE 'P88999   ' END) AS ZB_CLVLD, " 
cQuery += " NVL((SELECT ZB_CLVL FROM (SELECT * FROM  "+RetSqlName("SZB")+" ORDER BY ZB_GRUPO DESC ,ZB_CC DESC)SZB " 
cQuery += " WHERE ZB_FILIAL = CT2_FILIAL " 
cQuery += " AND ZB_GRUPO = GRUPOC "
cQuery += " AND (ZB_CC = CT2_CCC OR ZB_CC = ' ') " 
cQuery += " AND SZB.D_E_L_E_T_ = ' ' " 
cQuery += " AND ROWNUM = 1 ),CASE WHEN CT2_CREDIT = ' ' THEN '         ' ELSE 'P88999   ' END) AS ZB_CLVLC " 
cQuery += " FROM ( " 
cQuery += " SELECT CT2.R_E_C_N_O_ RECCT2,CT2_FILIAL,CT2_DATA,CT2_DEBITO,CT2_CCD,CT1D.CT1_GRUPO GRUPOD,CT2_CREDIT,CT2_CCC,CT1C.CT1_GRUPO GRUPOC " 
cQuery += " FROM "+RetSqlName("CT2")+" CT2 "  
cQuery += " LEFT JOIN "+RetSqlName("CT1")+" CT1D ON CT1D.CT1_FILIAL = CT2_FILIAL AND CT2_DEBITO = CT1D.CT1_CONTA AND CT1D.D_E_L_E_T_ = ' ' " 
cQuery += " LEFT JOIN "+RetSqlName("CT1")+" CT1C ON CT1C.CT1_FILIAL = CT2_FILIAL AND CT2_CREDIT = CT1C.CT1_CONTA AND CT1C.D_E_L_E_T_ = ' ' " 
cQuery += " )XXXX " 
cQuery += " WHERE CT2_FILIAL = ' ' AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
cQuery += " )T2 ON (T1.R_E_C_N_O_ = T2.RECCT2) " 
cQuery += " WHEN MATCHED THEN " 
cQuery += " UPDATE SET T1.CT2_CLVLDB = T2.ZB_CLVLD , T1.CT2_CLVLCR = T2.ZB_CLVLC "

else
	
cQuery += " MERGE INTO "+RetSqlName("CT2")+" T1 USING ( "
cQuery += " SELECT RECCT2, " 
cQuery += " NVL((SELECT ZB_CLVL FROM (SELECT * FROM  SZB010 ORDER BY ZB_GRUPO DESC ,ZB_CC DESC)SZB " 
cQuery += " WHERE ZB_FILIAL = CT2_FILIAL " 
cQuery += " AND ZB_GRUPO = GRUPOD " 
cQuery += " AND (ZB_CC = CT2_CCD OR ZB_CC = ' ') " 
cQuery += " AND SZB.D_E_L_E_T_ = ' ' " 
cQuery += " AND ROWNUM = 1 ),CASE WHEN CT2_DEBITO = ' ' THEN '         ' ELSE 'P88999   ' END) AS ZB_CLVLD, " 
cQuery += " NVL((SELECT ZB_CLVL FROM (SELECT * FROM  SZB010 ORDER BY ZB_GRUPO DESC ,ZB_CC DESC)SZB " 
cQuery += " WHERE ZB_FILIAL = CT2_FILIAL " 
cQuery += " AND ZB_GRUPO = GRUPOC "
cQuery += " AND (ZB_CC = CT2_CCC OR ZB_CC = ' ') " 
cQuery += " AND SZB.D_E_L_E_T_ = ' ' " 
cQuery += " AND ROWNUM = 1 ),CASE WHEN CT2_CREDIT = ' ' THEN '         ' ELSE 'P88999   ' END) AS ZB_CLVLC " 
cQuery += " FROM ( " 
cQuery += " SELECT CT2.R_E_C_N_O_ RECCT2,CT2_FILIAL,CT2_DATA,CT2_DEBITO,CT2_CCD,CT1D.CT1_GRUPO GRUPOD,CT2_CREDIT,CT2_CCC,CT1C.CT1_GRUPO GRUPOC " 
cQuery += " FROM "+RetSqlName("CT2")+" CT2 "  
cQuery += " LEFT JOIN "+RetSqlName("CT1")+" CT1D ON CT1D.CT1_FILIAL = CT2_FILIAL AND CT2_DEBITO = CT1D.CT1_CONTA AND CT1D.D_E_L_E_T_ = ' ' " 
cQuery += " LEFT JOIN "+RetSqlName("CT1")+" CT1C ON CT1C.CT1_FILIAL = CT2_FILIAL AND CT2_CREDIT = CT1C.CT1_CONTA AND CT1C.D_E_L_E_T_ = ' ' " 
cQuery += " )XXXX " 
cQuery += " WHERE CT2_FILIAL = ' ' AND CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " 
cQuery += " )T2 ON (T1.R_E_C_N_O_ = T2.RECCT2) " 
cQuery += " WHEN MATCHED THEN " 
cQuery += " UPDATE SET T1.CT2_CLVLDB = T2.ZB_CLVLD , T1.CT2_CLVLCR = T2.ZB_CLVLC "

Endif

If TcSqlExec( cQuery )<0
	MsgStop("TCSQLError() " + TCSQLError())
Else
	MsgInfo("Atualiza��o Finalizada!")
EndIf

Return

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

//AjustaSx1(cPerg,aPergs)

Return
