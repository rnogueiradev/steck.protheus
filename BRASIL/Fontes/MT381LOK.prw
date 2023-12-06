#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT381LOK ºAutor  ³ RVG                º Data ³  10/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT381LOK
Local _lRet := .t.                          
   
Local nPosOsep   := aScan(aHeader,{|aX| AllTrim(aX[2]) == "D4_XORDSEP"})
Local nPosOrig   := aScan(aHeader,{|aX| AllTrim(aX[2]) == "D4_QTDEORI"})
Local nPosSald   := aScan(aHeader,{|aX| AllTrim(aX[2]) == "D4_QUANT"})
Local nPosLocal  := aScan(aHeader,{|aX| AllTrim(aX[2]) == "D4_LOCAL"})
Local nPosCod    := aScan(aHeader,{|aX| AllTrim(aX[2]) == "D4_COD"})

Dbselectarea("SD4")
SD4->(dbGoTo(aCols[n][Len(aHeader)])) //recno contido no aCols
		
If !GdDeleted()      
   
   If !empty(acols[n,nPosOsep])
       
       IF acols[n,nPosOrig] <> SD4->D4_QTDEORI
      	 	_lRet := .f.
       ENDIF

       IF acols[n,nPosSald] <> SD4->D4_QUANT
      	 	_lRet := .f.
       ENDIF              

       IF acols[n,nPosLocal] <> SD4->D4_LOCAL
      	 	_lRet := .f.
       ENDIF
       
   Endif                          
  
Endif  

If GdDeleted() .And. !empty(acols[n,nPosOsep])

	_lRet := .f. 
                
Endif 

IF !_lRet

	 MsgStop("Empenhos com ordem de separacao Geradas não podem ser alterados ou a linha com OS foi apagada!!!")

Endif      
                                  
If !GdDeleted() .and. acols[n,nPosCod] == SC2->C2_PRODUTO
   	_lRet := .f. 
   	 MsgStop("Empenhos com o memso codigo do Produto da OP nao sao permitidos!!!")
Endif   
      
Return _lRet
