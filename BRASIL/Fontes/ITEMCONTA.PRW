#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Carlos Miranda      � Data �  30/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Enviar mensagem ao usuario para cadastrar o Item Contabil ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 - Uso exclusivo para a Steck                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				        
				        MSGALERT(" ATEN��O!! VERIFIQUE A INCLUSAO DO ITEM CONTABIL")
				        
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
