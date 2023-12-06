#include "rwmake.ch"
#include "tbiconn.ch"
#include "TOTVS.ch"
#include "PROTHEUS.ch"


/*====================================================================================\
|Programa  | STUPDPPG         | Autor | GIOVANI.ZAGO             | Data | 22/01/2014  |
|=====================================================================================|
|Descrição | STUPDPPG                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STUPDPPG                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*

User Function STUPDPPG()
	Local i := 0
	Local _Acamp:= {}
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	AADD(_Acamp,{'008407','01'})
	AADD(_Acamp,{'009054','01'})
	AADD(_Acamp,{'012147','01'})
	AADD(_Acamp,{'014932','01'})
	AADD(_Acamp,{'016856','01'})
	AADD(_Acamp,{'029977','01'})
	AADD(_Acamp,{'036099','01'})
	AADD(_Acamp,{'046528','01'})
	AADD(_Acamp,{'050619','01'})
	AADD(_Acamp,{'058598','01'})
	AADD(_Acamp,{'061719','01'})
	AADD(_Acamp,{'065009','01'})
	AADD(_Acamp,{'066783','01'})
	AADD(_Acamp,{'067311','01'})
	AADD(_Acamp,{'067490','01'})
	AADD(_Acamp,{'069381','01'})
	AADD(_Acamp,{'070155','01'})
	AADD(_Acamp,{'070500','01'})
	AADD(_Acamp,{'070580','01'})
	AADD(_Acamp,{'070581','01'})
	AADD(_Acamp,{'070583','01'})
	AADD(_Acamp,{'070585','01'})
	AADD(_Acamp,{'070586','01'})
	AADD(_Acamp,{'070588','01'})
	AADD(_Acamp,{'070589','01'})
	AADD(_Acamp,{'070591','01'})
	AADD(_Acamp,{'070593','01'})
	AADD(_Acamp,{'070594','01'})
	AADD(_Acamp,{'070596','01'})
	AADD(_Acamp,{'070609','01'})
	AADD(_Acamp,{'070683','01'})
	AADD(_Acamp,{'070684','01'})
	AADD(_Acamp,{'070685','01'})
	AADD(_Acamp,{'070686','01'})
	AADD(_Acamp,{'070687','01'})
	AADD(_Acamp,{'070688','01'})
	AADD(_Acamp,{'070689','01'})
	AADD(_Acamp,{'070690','01'})
	AADD(_Acamp,{'070692','01'})
	AADD(_Acamp,{'070693','01'})
	AADD(_Acamp,{'070694','01'})
	AADD(_Acamp,{'070695','01'})
	AADD(_Acamp,{'070697','01'})
	AADD(_Acamp,{'070698','01'})
	AADD(_Acamp,{'070699','01'})
	AADD(_Acamp,{'070700','01'})
	AADD(_Acamp,{'070701','01'})
	AADD(_Acamp,{'070703','01'})
	AADD(_Acamp,{'070704','01'})
	AADD(_Acamp,{'070705','01'})
	AADD(_Acamp,{'070706','01'})
	AADD(_Acamp,{'070707','01'})
	AADD(_Acamp,{'070709','01'})
	AADD(_Acamp,{'070710','01'})
	AADD(_Acamp,{'070711','01'})
	AADD(_Acamp,{'070712','01'})
	AADD(_Acamp,{'070713','01'})
	AADD(_Acamp,{'070714','01'})
	AADD(_Acamp,{'070715','01'})
	AADD(_Acamp,{'070716','01'})
	AADD(_Acamp,{'070718','01'})
	AADD(_Acamp,{'070719','01'})
	AADD(_Acamp,{'070720','01'})
	AADD(_Acamp,{'070722','01'})
	AADD(_Acamp,{'070723','01'})
	AADD(_Acamp,{'070724','01'})
	AADD(_Acamp,{'070725','01'})
	AADD(_Acamp,{'070726','01'})
	AADD(_Acamp,{'070727','01'})
	AADD(_Acamp,{'070728','01'})
	AADD(_Acamp,{'070729','01'})
	AADD(_Acamp,{'070730','01'})
	AADD(_Acamp,{'070731','01'})
	AADD(_Acamp,{'070734','01'})
	AADD(_Acamp,{'070735','01'})
	AADD(_Acamp,{'070736','01'})
	AADD(_Acamp,{'070737','01'})
	AADD(_Acamp,{'070738','01'})
	AADD(_Acamp,{'070739','01'})
	AADD(_Acamp,{'070740','01'})
	AADD(_Acamp,{'070741','01'})
	AADD(_Acamp,{'070743','01'})
	AADD(_Acamp,{'070744','01'})
	AADD(_Acamp,{'070745','01'})
	AADD(_Acamp,{'070746','01'})
	AADD(_Acamp,{'070747','01'})
	AADD(_Acamp,{'070748','01'})
	AADD(_Acamp,{'070750','01'})
	AADD(_Acamp,{'072183','01'})
	AADD(_Acamp,{'077198','01'})
	AADD(_Acamp,{'091081','01'})
	AADD(_Acamp,{'091570','01'})
	AADD(_Acamp,{'092900','01'})
	AADD(_Acamp,{'093117','01'})
	AADD(_Acamp,{'093263','01'})
	AADD(_Acamp,{'094460','01'})
	AADD(_Acamp,{'095270','01'})
	AADD(_Acamp,{'095483','01'})
	AADD(_Acamp,{'095484','01'})
	AADD(_Acamp,{'095485','01'})
	AADD(_Acamp,{'095486','01'})
	AADD(_Acamp,{'095487','01'})
	AADD(_Acamp,{'095488','01'})
	AADD(_Acamp,{'095489','01'})
	AADD(_Acamp,{'095490','01'})
	AADD(_Acamp,{'095491','01'})
	AADD(_Acamp,{'095492','01'})
	AADD(_Acamp,{'095493','01'})
	AADD(_Acamp,{'095494','01'})


	For i:=1 To Len(_Acamp)
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+_Acamp[i,1]+_Acamp[i,2]))


			dbSelectArea("PPE")
			PPE->(RecLock("PPE",.T.))
			PPE->PPE_NUM   	:=  '000009'
			PPE->PPE_CLIENT :=   SA1->A1_COD
			PPE->PPE_LOJA   :=   SA1->A1_LOJA
			PPE->PPE_NOME   :=   SA1->A1_NOME
			PPE->PPE_AREA   :=   SA1->A1_VEND
			PPE->(MsUnLock())

		EndIf

	Next i


	/*
	For i:=1 To Len(_Acamp)
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+_Acamp[i,1]))

	dbSelectArea("SBM")
	SBM->(dbSetOrder(1))
	If 	SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
	dbSelectArea("PPG")
	PPG->(RecLock("PPG",.T.))

	PPG->PPG_NUM   	:=  '000001'
	PPG->PPG_PROD  	:=   SB1->B1_COD
	PPG->PPG_NPROD  :=   SB1->B1_DESC
	PPG->PPG_GRUPO  :=   SB1->B1_GRUPO
	PPG->PPG_NGRUPO :=   SBM->BM_DESC
	PPG->PPG_VALOR  :=   Round(_Acamp[i,2],2)
	dbSelectArea("ACY")
	ACY->(dbSetOrder(1))
	If 	ACY->(dbSeek(xFilial("ACY")+aLLTRIM(_Acamp[i,3])))
	PPG->PPG_GRPVEN :=  ACY->ACY_GRPVEN
	PPG->PPG_NGRPVE :=  ACY->ACY_DESCRI
	EndIf
	PPG->(MsUnLock())

	EndIf
	EndIf

	Next i
	*/
Return()

