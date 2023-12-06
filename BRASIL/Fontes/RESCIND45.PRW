#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Carlos Miranda      º Data ³  16/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Enviar mensagem ao usuario para rescisao:funcionarios com º±±
±±º          ³  mais de 45 anos.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Uso exclusivo para a Steck                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              	

user function RESCIND45()

Local _aaArea := getArea()   

_admissao := SRA->RA_ADMISSA
//nIdade_   := ((dDataBase - SRA->RA_NASC) / 365)
nIdade_   := ((ddataDem - SRA->RA_NASC) / 365)       
lCalRes_  := .T.


dbSelectArea("SRA")
			

			If CTIPRES $ "01*02*04*05" .AND. _admissao < CTOD("01/11/98").AND. nIdade_ >= 45        
				        
				        //MSGSTOP(SRA->RA_SALARIO) 
				        
				        MSGALERT(" ATENÇÃO!! FUNCIONARIO COM MAIS DE 45 ANOS DE IDADE")
				        MSGALERT(nidade_)  
				       
				        
//				//MSGALERT(SRA->RA_FILIAL + "/" + SRA->RA_MAT + " - " + SRA->RA_NOME + " Data Base: "+Dtoc(SRF->RF_DATABAS))
				
			Endif


RestArea(_aaArea)

Return(lCalRes_)
