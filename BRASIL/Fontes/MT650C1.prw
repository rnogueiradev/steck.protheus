#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��|Ponto de  �MA650GRPV |Autor  �Ricardo Posman         |Data  �18.09.2007|��
���Entrada   �          �       |                       |      |          |��
�������������������������������������������������������������������������Ĵ��
��|Descricao �Ponto de entrada na grava�ao da OP - GRAVA DADOS DA SC EM   |��
��|          �TABELA ESPECIFICA - CONTROLE DE ENTRADA MP EM PRODUCAO      |��
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

