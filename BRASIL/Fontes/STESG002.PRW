#INCLUDE "RWMAKE.CH"

 
 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STESG002  �Autor  � RVG Solucoes       � Data �  06/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao usada como validacao no campo D!_OP para validar se ���
���          � o produto que volta da NF � igual ao que ser� produzido    ���
���          � pela OP    												  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STESG002

Local _cCampo		:= Readvar()
Local _cConteudo	:= &(Readvar())
Local _nPosCod    	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local _nPosOp     	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local _lRet 		:= .t.  

If empty(acols[n,_nPosCod])

   MsgStop("Necess�rio preencher o codigo do produto antes da OP !!! ")
   _lRet := .f.  

Else

    If Upper(alltrim(_cCampo)) == 'M->D1_OP'
	
	 	DbselectArea('SC2')
		dbSetOrder(1)
	
		If SC2->(MsSeek(xFilial("SC2")+_cConteudo))
	
	       If alltrim(sc2->c2_produto) == alltrim(acols[n,_nPosCod])
	     
	         MsgStop("Produto de retorno nao pode ser igual ao da Ordem de Producao !!! ")
	   		  _lRet := .f.  
	       
	       Endif
	       
	    Else
	    
			  MsgStop("Ordem de Producao, nao encontrada !!! ")
	   		  _lRet := .f.  
	     
	    Endif

	 Else
	
		If Upper(alltrim(_cCampo)) == 'M->D1_COD'
			
			If !empty(acols[n,_nPosOp])
		
				If SC2->(MsSeek(xFilial("SC2")+acols[n,_nPosOP]))
			
			       If alltrim(sc2->c2_produto) ==  alltrim(_cConteudo)
			     
			         MsgStop("Produto de retorno nao pode ser igual ao da Ordem de Producao !!! ")
			   		  _lRet := .f.  
			       
			       Endif
			       
				Endif
	
			Endif
		
		Endif

	Endif

Endif
 
Return  _lRet