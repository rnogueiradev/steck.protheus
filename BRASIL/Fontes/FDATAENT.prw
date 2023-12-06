#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FDATAFAT  �Autor  �Microsiga           � Data �  21/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega os datas de Inspe��o de CQ e Recebimento da Fatec   ���
�� 			  na tabela PC1-FATEC							              ���
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FDATAENT(cFATEC)
Local cQuery := ""
Local cRetorno:="" 

/*
cQuery	:=	" SELECT F1_DTDIGIT "
cQuery  +=	" FROM " + RetSqlName("PC1") + " A "
cQuery	+=	" INNER JOIN " + RetSqlName("SD1") + " B ON A.PC1_NUMERO = B.D1_XFATEC " 
cQuery	+=	" INNER JOIN " + RetSqlName("SF1") + " C ON B.D1_DOC = C.F1_DOC "
cQuery	+=	" WHERE A.PC1_NUMERO = '"+cFATEC+"' "
cQuery	+=	" AND A.D_E_L_E_T_ <> '*' "   
cQuery	+=	" AND B.D_E_L_E_T_ <> '*' " 
cQuery	+=	" AND C.D_E_L_E_T_ <> '*' "  
cQuery	+=	" GROUP BY F1_DTDIGIT "
*/

cQuery := " SELECT F1_DTDIGIT "
cQuery += " FROM "+RetSqlName("SF1")+" F1 "
cQuery += " WHERE F1.D_E_L_E_T_=' ' AND F1_FILIAL||F1_DOC||F1_SERIE||F1_FORNECE||F1_LOJA=( "
cQuery += " SELECT DISTINCT D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA "
cQuery += " FROM "+RetSqlName("SD1")+" D1 "
cQuery += " WHERE D1.D_E_L_E_T_=' ' AND D1_FILIAL='"+cFilAnt+"' AND D1_XFATEC='"+cFATEC+"' ) "

cQuery	:= ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY', .F., .T.)

QRY->(DbGotop())
IF QRY->(!Eof())
	IF(!EMPTY(QRY->F1_DTDIGIT))	
		cRetorno:= STOD(QRY->F1_DTDIGIT)
	ENDIF
ENDIF
 
			
QRY->(DbClosearea()) 			
      
Return cRetorno

#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FDATAFAT  �Autor  �Microsiga           � Data �  21/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega os datas de Inspe��o de CQ e Recebimento da Fatec   ���
�� 			  na tabela PC1-FATEC							              ���
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STNFENT(cFATEC)

Local cQuery := ""
Local cRetorno:="" 

cQuery := " SELECT F1_DOC "
cQuery += " FROM "+RetSqlName("SF1")+" F1 "
cQuery += " WHERE F1.D_E_L_E_T_=' ' AND F1_FILIAL||F1_DOC||F1_SERIE||F1_FORNECE||F1_LOJA=( "
cQuery += " SELECT DISTINCT D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA "
cQuery += " FROM "+RetSqlName("SD1")+" D1 "
cQuery += " WHERE D1.D_E_L_E_T_=' ' AND D1_FILIAL='"+cFilAnt+"' AND D1_XFATEC='"+cFATEC+"' ) "

cQuery	:= ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY', .F., .T.)

QRY->(DbGotop())
IF QRY->(!Eof())
	IF(!EMPTY(QRY->F1_DOC))	
		cRetorno:= QRY->F1_DOC
	ENDIF
ENDIF
 
			
QRY->(DbClosearea()) 			
      
Return cRetorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FDATAFAT  �Autor  �Microsiga           � Data �  21/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega os datas de Inspe��o de CQ e Recebimento da Fatec   ���
�� 			  na tabela PC1-FATEC							              ���
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STNFEN2(cFATEC)

Local cQuery := ""
Local cRetorno:="" 

cQuery := " SELECT F1_XNFCLI "
cQuery += " FROM "+RetSqlName("SF1")+" F1 "
cQuery += " WHERE F1.D_E_L_E_T_=' ' AND F1_FILIAL||F1_DOC||F1_SERIE||F1_FORNECE||F1_LOJA=( "
cQuery += " SELECT DISTINCT D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA "
cQuery += " FROM "+RetSqlName("SD1")+" D1 "
cQuery += " WHERE D1.D_E_L_E_T_=' ' AND D1_FILIAL='"+cFilAnt+"' AND D1_XFATEC='"+cFATEC+"' ) "

cQuery	:= ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRY', .F., .T.)

QRY->(DbGotop())
IF QRY->(!Eof())
	IF(!EMPTY(QRY->F1_XNFCLI))	
		cRetorno:= QRY->F1_XNFCLI
	ENDIF
ENDIF
 
			
QRY->(DbClosearea()) 			
      
Return cRetorno