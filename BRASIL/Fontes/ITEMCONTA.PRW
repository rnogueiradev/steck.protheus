#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Carlos Miranda      º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Enviar mensagem ao usuario para cadastrar o Item Contabil º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10 - Uso exclusivo para a Steck                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/              	

user function ITEMCONTA()

Local _aaArea := getArea()

dbSelectArea("SRV")
dbSelectArea("CT1")

//While !Eof()
	
//If SRV->RV_DATIVIM <> " " 
	  	
		//dbSelectArea("CT1")        
		
//		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			
			//DOIS DIAS ANTES DE VENCER DUAS
			
//            If alltrim(SRV->RV_DATIVIM) = "122001010" .and. CT1->CT1_ITOBRG == "1"
			If CT1->CT1_ITOBRG == "1"     
//			If ALLTRIM(SRV->RV_DATIVIM) <> " " .AND. CT1->CT1_ITOBRG = "1"
				        
				        //MSGSTOP(SRA->RA_SALARIO) 
				        
				        MSGALERT(" ATENÇÃO!! VERIFIQUE A INCLUSAO DO ITEM CONTABIL")
				        
//				MSGALERT(SRA->RA_FILIAL + "/" + SRA->RA_MAT + " - " + SRA->RA_NOME + " Data Base: "+Dtoc(SRF->RF_DATABAS))
				
			Endif
			
//Endif
		
//	Endif
	
	dbSelectArea("CT1")
	dbSelectArea("SRV")
	
//	dbSkip()
	
//Enddo

RestArea(_aaArea)

Return
