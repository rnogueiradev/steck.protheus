#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±|Ponto de  ³MA650GRPV |Autor  ³Ricardo Posman         |Data  ³18.09.2007|±±
±±³Entrada   ³          ³       |                       |      |          |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao ³Ponto de entrada na gravaçao da OP - GRAVA DADOS DA SC EM   |±±
±±|          ³TABELA ESPECIFICA - CONTROLE DE ENTRADA MP EM PRODUCAO      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT650C1()
                    
Private aArea		:= GetArea() 
Private aAreaSC1	:= SC1->(GetArea()) 
Private dData1	:= SC1->C1_DATPRF
Private _nNumop1 	:= SC2->C2_NUM
Private _nNumop2 	:= SC2->C2_NUM+SC2->C2_ITEM+"001"
Private _nCod   	:= "" //Posicione("SC2",1,xFilial("SC2")+_nNumop2,"C2_MOTIVO")


//	RecLock("SC1",.F.)        

//	SC1->C1_MOTIVO :=_nCod 
//	SC1->(msUnlock()) 
		

//DBSELECTAREA("SZ1")
//DBSETORDER(1)

//	DBSEEK(XFILIAL("SZ1")+SC1->C1_MOTIVO) 
        
//		IF SZ1->Z1_NOMES = "S"  
//		dData1	 := (LastDate( SC1->C1_DATPRF  )+1)
		
//		RecLock("SC1",.F.)        


//      	SC1->C1_DATPRF		:= dData1

//		SC1->(msUnlock()) 
		
//		ENDIF  

Return Nil                                     

