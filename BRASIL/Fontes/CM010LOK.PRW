#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"   
#INCLUDE "Topconn.ch"   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CM010LOK ³ Autor ³ RICARDO POSMAN      ³ Data ³  01.06.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para Atualizacao PRECO DE COMPRA           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CM010LOK()
Local _nItens := 0
Local lRet := .t.
_nPosProd := aScan(aHeader,{|e|Trim(e[2])=='AIB_CODPRO'})
_nPosPrv  := aScan(aHeader,{|e|Trim(e[2])=='AIB_PRCCOM'})


		For _nItens := 1 To Len(aCols)
		    If aCols[_nItens,Len(aHeader)+1]
		       Loop
		    Endif   
				dbSelectArea("SB1")
				DbSetOrder(1)
				If SB1->(DbSeek(xFilial('SB1')+aCols[_nItens,_nPosProd]))
                		IF EMPTY(SB1->B1_UPRC)
                				RecLock("SB1", .F.)
								SB1->B1_UPRC := aCols[_nItens,_nPosPrv]
								
								SB1->(msUnlock())    
						endif		
				endif		                		 
		Next

Return (lRet)              
