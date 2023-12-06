#Include "rwmake.ch"
#Include "topconn.ch"


user function xB9C9()


_cQuery := " SELECT DISTINCT(C9_PRODUTO), C9_LOCAL "
_cQuery += " FROM "+RETSQLNAME("SC9")+" SC9 "
_cQuery += " WHERE  "
_cQuery += "   SC9.C9_FILIAL = '"+xFilial("SC9")+"'"
_cQuery += "   AND  C9_NFISCAL = '         '  "
_cQuery += "   AND SC9.D_E_L_E_T_ = ' '"
_cQuery += " ORDER BY C9_PRODUTO"

TCQuery _cQuery New Alias "TRB01"

Dbselectarea("TRB01")
 

dbgotop()

do while !eof()
	
	DbSelectArea("SB9")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB9") + TRB01->C9_PRODUTO + TRB01->C9_local + "20130405" )
	
	
	IF EOF()                                                                                                                            
		
		RecLock("SB9",.t.)
		SB9->B9_FILIAL 	:= XFILIAL("SB9") 
		SB9->B9_COD		:= TRB01->c9_produto
		SB9->B9_LOCAL	:= TRB01->c9_local
		SB9->B9_DATA	:= stod("20130405")
		SB9->B9_QINI 	:= 0
		SB9->B9_VINI1	:= 0
		MsUnlock()
	ENDIF
	
	Dbselectarea("SB2")
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If !SB2->(DbSeek(xFilial("SB2")+ TRB01->C9_PRODUTO + TRB01->C9_local ))
		RecLock("SB2",.t.)
		SB2->B2_FILIAL 	:= XFILIAL("SB2") 
		SB2->B2_COD		:= TRB01->c9_produto
		SB2->B2_LOCAL	:= TRB01->c9_local
		SB2->B2_QATU 	:= 0
		SB2->B2_VATU1	:= 0
		MsUnlock()
	Endif
	
	
	
	DbSelectArea("SB1")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB1")+ TRB01->c9_produto  )
	
	DbSelectArea("SB9")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB9") + TRB01->C9_PRODUTO  + SB1->B1_LOCPAD + "20130405" )
	IF EOF()
		
		RecLock("SB9",.t.)
		SB9->B9_FILIAL 	:= XFILIAL("SB9")
		SB9->B9_COD		:= TRB01->C9_PRODUTO
		SB9->B9_LOCAL	:=  SB1->B1_LOCPAD
		SB9->B9_DATA	:= stod("20130405")
		SB9->B9_QINI 	:= 0
		SB9->B9_VINI1	:= 0
		MsUnlock()
	ENDIF
	
	Dbselectarea("SB2")
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If !SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
		RecLock("SB2",.t.)
		SB2->B2_FILIAL 	:= XFILIAL("SB2")
		SB2->B2_COD		:= TRB01->C9_PRODUTO
		SB2->B2_LOCAL	:= SB1->B1_LOCPAD
		SB2->B2_QATU 	:= 0
		SB2->B2_VATU1	:= 0
		MsUnlock()
	Endif
	
	
	
	Dbselectarea("TRB01")
	dbskip()
	
Enddo
MSGSTOP("fim")


Dbselectarea("TRB01")
DbClosearea("TRB01")
Return
