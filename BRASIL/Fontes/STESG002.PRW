#INCLUDE "RWMAKE.CH"

 
 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STESG002  ºAutor  ³ RVG Solucoes       º Data ³  06/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada como validacao no campo D!_OP para validar se º±±
±±º          ³ o produto que volta da NF é igual ao que será produzido    º±±
±±º          ³ pela OP    												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STESG002

Local _cCampo		:= Readvar()
Local _cConteudo	:= &(Readvar())
Local _nPosCod    	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local _nPosOp     	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})
Local _lRet 		:= .t.  

If empty(acols[n,_nPosCod])

   MsgStop("Necessário preencher o codigo do produto antes da OP !!! ")
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