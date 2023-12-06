#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EsCompOPG    �Autor  �Microsiga          �Fecha �  05/13/15 ���
�������������������������������������������������������������������������͹��
���Desc.     �Identifica si la compensacion afecta bancos                 ���
���          �Identifica valor de anticipos en compensaciones             ���   
���          �asientos 570 y 571							              ���   
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function EsCompOPG
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nRet 		//.F. 
Local nAnt

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

lBanco := .F.    
lAntic := .F.

While StrSQL->(!Eof())		
	If !Empty(StrSQL->(EK_BANCO))//Compensacion sin salida de banco
		lBanco := .T.				
	Endif	
	If "PA" $ StrSQL->(EK_TIPO).OR."APB" $ StrSQL->(EK_TIPO) // Compensacion de anticipo
		lAntic := .T.  					
	Endif
	
	StrSQL->(DbSkip())
EndDo
          
//If !lBanco  //sin salida de banco
   If !lAntic // Sin comp anticipo
      nRet:= 1
   else 
      nRet:= 2
   Endif
//Endif



//lRet := !lBanco //Si no tiene banco es Compensaci�n
//MsgYesNo("Es compensaci�n: " + If(lRet,".T.",".F."), "Aten��o")

RestArea(aArea)
Return(nRet)         

 //valor de anticipos
User Function CompPA
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nRet 		//.F. 
Local nAnt      := 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

lBanco := .F.    
lAntic := .F.

While StrSQL->(!Eof())		
	If !Empty(StrSQL->(EK_BANCO))//Compensacion sin salida de banco
		lBanco := .T.				
	Endif	
	If "PA" $ StrSQL->(EK_TIPO).OR."APB" $ StrSQL->(EK_TIPO) // Compensacion de anticipo
		lAntic := .T.  
		nAnt += StrSQL->(EK_VALOR)			
	Endif
	
	StrSQL->(DbSkip())
EndDo
        nret:= nAnt    

RestArea(aArea)
Return(nRet)
