#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTANIIF   �Autor  �EDUAR ANDIA         � Data �  21/06/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funci�n que retorna la Clase Valor			   registrada ���
���          � en el Plan de cuenta (CT1_XNIIFS)                          ���
�������������������������������������������������������������������������͹��
���Uso       � GAMA\Colombia                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function uClVl(cConta)
Local aArea 	:= GetArea()
Local cQry   	:= ""
Local cClVl	:= ""         
Default cConta	:= ""

If !Empty(cConta)

	cQry :="SELECT * FROM " + RetSqlName("CT1") +" WHERE CT1_FILIAL = '"  + xFilial("CT1") + "'"+ " AND CT1_CONTA = '" + cConta + "'"+" AND D_E_L_E_T_ = ''"  
	
	If Select("StrSQL") > 0  //En uso
	   StrSQL->(DbCloseArea())
	Endif
					
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry),"StrSQL", .F., .T.)
	
	DbSelectArea("StrSQL")
	DbGoTop()
	If !Empty(StrSQL->(CT1_XCLVL)) 
		cClVl := StrSQL->(CT1_XCLVL)
	Endif				
	StrSQL->(dbCloseArea()) 
	
	RestArea(aArea)
Endif
Return(cClVl)
