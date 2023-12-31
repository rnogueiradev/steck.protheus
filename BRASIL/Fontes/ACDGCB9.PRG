#INCLUDE "Protheus.ch"
#INCLUDE "APVT100.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACDGCB9  �Autor  �Sandro              � Data �  18/06/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para gravacao do lote especifico           ���
�������������������������������������������������������������������������͹��
���Uso       �STECK	                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function ACDGCB9()
Local cOrdSep	:= If(!Empty(CB7->CB7_XOSPAI),CB7->CB7_XOSPAI,CB7->CB7_ORDSEP)
Local cLoteX	:= U_RetLoteX()   
Local nQtde		:= PARAMIXB[1]

PA0->(DbSetOrder(1))
If !PA0->(DbSeek(xFilial("PA0")+cOrdSep+CB8->CB8_ITEM+CB8->CB8_PROD+cLoteX))
	PA0->(RecLock("PA0",.T.))
	PA0->PA0_FILIAL 	:= xFilial("PA0")
	PA0->PA0_ORDSEP 	:= cOrdSep
	If ! Empty(CB7->CB7_OP	)
		PA0->PA0_DOC		:= CB7->CB7_OP
		PA0->PA0_TIPDOC	:= 'SD4'		
	Else		
		PA0->PA0_DOC		:= CB7->CB7_PEDIDO
		PA0->PA0_TIPDOC	:= 'SC5'
	EndIf	       
	PA0->PA0_ITSEP		:= CB8->CB8_ITEM
	PA0->PA0_PROD   	:= CB8->CB8_PROD
	PA0->PA0_LOTEX  	:= cLoteX
	PA0->PA0_QTDE		:= nQtde
	PA0->PA0_USU	 	:= __cUserID
	PA0->PA0_DTSEP  	:= dDataBase
	PA0->PA0_HRSEP  	:= Time()
Else
	PA0->(RecLock("PA0",.F.))
	PA0->PA0_QTDE		+= nQtde
	PA0->PA0_DTSEP		:= dDataBase
	PA0->PA0_HRSEP		:= Time()
Endif
PA0->(MsUnLock())                

If CB1->CB1_XIMPET =="1" 
	If Empty(CB1->CB1_XLOCIM)
		MSCBPRINTER('S600',NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,cUserName)
		MSCBCHKSTATUS( )
	Else 
		If !CB5SetImp(CB1->CB1_XLOCIM) 
			CBAlert("Local de impress�o "+CB1->CB1_XLOCIM+" n�o existe!!!","Aten��o") 
			Return 
		EndIf			
	EndIf		
	If ExistBlock("IMG01") 
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1')+CB8->CB8_PROD)) 
		ExecBlock("IMG01",,,{nQtde,,,1,,,,,,,,cLoteX,Space(6),,,,,Space(20)})
	EndIf	
	MSCBCLOSEPRINTER() 
Else
	If Separou(cOrdSep)
		VtAlert("Fim Separacao!")
		If VTYesNo("Imprimir Etiqueta?","Atencao",.T.) //"Deseja estornar a separacao ?"
			Etiqueta()
		Endif
	Endif
EndIf	
Return 

/*
PA0_TIPDOC	PA0_DOC                                                         
"SC5" 		000001   				-> UTILIZADO NO PEDIDO
"SD4"			00003501003				-> UTILIZADO NA OP
"SC2" 		00000101001    		-> GERADA PELA OP
"SD1"			000001   UNI12345602	-> GERADA PELA NOTA FISCAL ENTRADA
"CB6"			0000000001				-> CODIGO DO VOLUME
*/
            
/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Fun�ao    � Separou  � Autor � ACD                   � Data � 06/02/05      ���
������������������������������������������������������������������������������Ĵ��
���Descri�ao � Verifica se todos os itens da Ordem de Separacao foram separados���
������������������������������������������������������������������������������Ĵ��
��� Uso      �SIGAACD                                                          ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
Static Function Separou(cOrdSep)
Local lRet:= .t.
Local aArea	:= GetArea()         //Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada
Local aCB8	 					 //Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada

DbSelectarea("CB8")              //Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada
aCB8	:= GetArea() 			 //Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada

CB8->(DBSetOrder(1))
CB8->(DbSeek(xFilial("CB8")+cOrdSep))
While CB8->(! Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial("CB8")+cOrdSep)
	If !Empty(CB8->CB8_OCOSEP)
		CB8->(DbSkip())
		Loop
	EndIf
	If CB8->CB8_SALDOS > 0
		lRet:= .f.
		Exit
	EndIf
	CB8->(DbSkip())
EndDo

DbSelectarea("CB8")  	  		//Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada
RestArea(aCB8)		 			//Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada
 
RestArea(aArea)					 //Renato 13032013 - Ajuste feito pois o GetArea estava pegando da tabela errada

Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACDGCB9   �Autor  �Microsiga           � Data �  08/29/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Etiqueta()
Local aTela 	:= VTSave() 
Local cEtiProd := Space(48)
Local cLoteX	:= ""

While .t.                 
	cEtiProd := Space(48)   
	cLocImp	:= CB1->CB1_XLOCIM                           
	aEtiqueta:= {}
	VtClear()
	@ 0,0 VtSay "Impressao Etiqueta"
	@ 2,0 VTSay "Leia a etiqueta"
	@ 3,0 VTGet cEtiProd pict "@!" Valid VldProduto(cEtiProd,aEtiqueta)
	@ 5,0 VtSay "Local de Impresao"
	@ 6,0 VtGet cLocImp pict "999999" F3 'CB5' Valid ! Empty(cLocImp) 
   VTRead
   If VtLastkey() == 27
   	Exit
   EndIf   
   If ! VTYesNo("Confirma a Impress�o de Etiqueta","Atencao")
   	Loop
   EndIf
	VTMSG("Imprimindo..")
	If !CB5SetImp(cLocImp) 
		CBAlert("Local de impress�o "+cLocImp+" n�o existe!!!","Aten��o") 
		Return 
	EndIf
	cLoteX := U_RetLoteX()	
		
	If ExistBlock("IMG01") 
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial('SB1')+aEtiqueta[1])) 
		ExecBlock("IMG01",,,{aEtiqueta[2],,,1,,,,,,,,cLoteX,Space(6),,,,,Space(20)})
	EndIf	
	MSCBCLOSEPRINTER() 
End

VtRestore(,,,,aTela)
Return 

Static Function VldProduto(cEtiqueta,aEtiqueta) 
Local aEti 			:= CBRetEtiEan(cEtiqueta)
Local cProduto		:= Space(15)
Local cLote       := Space(10)
Local cSLote      := Space(6)

If len(aEti) == 0  
	VtAlert("Etiqueta invalida","Atencao [ENTER]")
	VtKeyBoard(chr(20))
	Return .f.
EndIf           
If Empty(aEti[1])
	VtAlert("Produto n�o encontrado","Atencao [ENTER]")  
	VtKeyBoard(chr(20))
	Return .f.
EndIf           
                   	
cProduto := aEti[1]
cLote 	:= aEti[3]

If ! CBRastro(cProduto,@cLote,@cSLote)
	Return .f.
EndIf   
aEti[3] 	:= cLote
aEtiqueta := aClone(aEti)

Return .t.