#Include "rwmake.ch"
#Include "topconn.ch"


user function xcB9C6()



_cQuery := " SELECT DISTINCT(C6_PRODUTO), C6_LOCAL "
_cQuery += " FROM "+RETSQLNAME("SC6")+" SC6 "
_cQuery += " WHERE  "
_cQuery += "   SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
_cQuery += "   AND (C6_QTDVEN > C6_QTDENT ) "
_cQuery += "   AND C6_BLQ <> 'R' "
_cQuery += "   AND SC6.D_E_L_E_T_ = ' '"
_cQuery += " ORDER BY C6_PRODUTO"

TCQuery _cQuery New Alias "TRB01"

Dbselectarea("TRB01")
 

dbgotop()

do while !eof()
	
	DbSelectArea("SB9")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB9") + TRB01->C6_PRODUTO + TRB01->C6_local + space(8)  )
	
	                     
	IF EOF()
		
		RecLock("SB9",.t.)
		SB9->B9_FILIAL 	:= XFILIAL("SB9")
		SB9->B9_COD		:= TRB01->c6_produto
		SB9->B9_LOCAL	:= TRB01->c6_local
		SB9->B9_DATA	:= stod("        ")
		SB9->B9_QINI 	:= 0
		SB9->B9_VINI1	:= 0
		MsUnlock()
	ENDIF
	
	Dbselectarea("SB2")
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If !SB2->(DbSeek(xFilial("SB2")+ TRB01->c6_produto + TRB01->c6_local ))
		RecLock("SB2",.t.)
		SB2->B2_FILIAL 	:= XFILIAL("SB2")
		SB2->B2_COD		:= TRB01->c6_produto
		SB2->B2_LOCAL	:= TRB01->c6_local
		SB2->B2_QATU 	:= 0
		SB2->B2_VATU1	:= 0
		MsUnlock()
	Endif
	
	
	
	DbSelectArea("SB1")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB1")+ TRB01->C6_PRODUTO  )
	
	DbSelectArea("SB9")
	Dbsetorder(1)
	DbSeek(XFILIAL("SB9") + TRB01->C6_PRODUTO + SB1->B1_LOCPAD + space(8)  )
	IF EOF()
		
		RecLock("SB9",.t.)
		SB9->B9_FILIAL 	:= XFILIAL("SB9")
		SB9->B9_COD		:= TRB01->c6_produto
		SB9->B9_LOCAL	:=  SB1->B1_LOCPAD
		SB9->B9_DATA	:= stod("       ")
		SB9->B9_QINI 	:= 0
		SB9->B9_VINI1	:= 0
		MsUnlock()
	ENDIF
	
	Dbselectarea("SB2")
	SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If !SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
		RecLock("SB2",.t.)
		SB2->B2_FILIAL 	:= XFILIAL("SB2")
		SB2->B2_COD		:= TRB01->c6_produto
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
