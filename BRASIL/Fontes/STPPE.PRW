#include "rwmake.ch"
#include "tbiconn.ch"

/*====================================================================================\
|Programa  | STUPPE           | Autor | GIOVANI.ZAGO             | Data | 22/01/2014  |
|=====================================================================================|
|Descrição | STUPPE                                                                   |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STUPPE                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*

User Function STUPPE()
	Local i := 0
	Local _Acamp:= {}
	AADD(_Acamp,{'02884101'})
	AADD(_Acamp,{'00207701'})
	AADD(_Acamp,{'03818901'})
	AADD(_Acamp,{'07153401'})
	AADD(_Acamp,{'00088701'})
	AADD(_Acamp,{'03250801'})
	AADD(_Acamp,{'03041301'})
	AADD(_Acamp,{'00209101'})
	AADD(_Acamp,{'00076801'})
	AADD(_Acamp,{'00011601'})
	AADD(_Acamp,{'01662601'})
	AADD(_Acamp,{'05952501'})
	AADD(_Acamp,{'03362901'})
	AADD(_Acamp,{'07173101'})
	AADD(_Acamp,{'02086301'})
	AADD(_Acamp,{'03453701'})
	AADD(_Acamp,{'00699501'})
	AADD(_Acamp,{'06399701'})
	AADD(_Acamp,{'05646601'})
	AADD(_Acamp,{'05831401'})
	AADD(_Acamp,{'05066601'})
	AADD(_Acamp,{'00445401'})
	AADD(_Acamp,{'00445402'})
	AADD(_Acamp,{'00445403'})
	AADD(_Acamp,{'00445404'})
	AADD(_Acamp,{'00481801'})
	AADD(_Acamp,{'03847901'})
	AADD(_Acamp,{'06389401'})
	AADD(_Acamp,{'06389402'})
	AADD(_Acamp,{'07039401'})
	AADD(_Acamp,{'05137101'})
	AADD(_Acamp,{'06262801'})
	AADD(_Acamp,{'06458101'})
	AADD(_Acamp,{'03159901'})
	AADD(_Acamp,{'04767401'})
	AADD(_Acamp,{'06229701'})
	AADD(_Acamp,{'05597801'})
	AADD(_Acamp,{'05597801'})
	AADD(_Acamp,{'07276201'})
	AADD(_Acamp,{'06039101'})
	AADD(_Acamp,{'05126301'})
	AADD(_Acamp,{'06564301'})
	AADD(_Acamp,{'00872404'})
	AADD(_Acamp,{'00502201'})
	AADD(_Acamp,{'03112201'})
	AADD(_Acamp,{'04097301'})
	AADD(_Acamp,{'06813501'})
	AADD(_Acamp,{'03089601'})
	AADD(_Acamp,{'07761901'})
	AADD(_Acamp,{'04931001'})
	AADD(_Acamp,{'07389201'})
	AADD(_Acamp,{'03224401'})
	AADD(_Acamp,{'07211101'})
	AADD(_Acamp,{'03749901'})
	AADD(_Acamp,{'03608501'})
	AADD(_Acamp,{'01128101'})
	AADD(_Acamp,{'00084501'})
	AADD(_Acamp,{'00081601'})
	AADD(_Acamp,{'00822801'})
	AADD(_Acamp,{'05021701'})
	AADD(_Acamp,{'04677301'})
	AADD(_Acamp,{'07761501'})
	AADD(_Acamp,{'05193301'})
	AADD(_Acamp,{'00683601'})
	AADD(_Acamp,{'00897601'})
	AADD(_Acamp,{'03519201'})
	AADD(_Acamp,{'05412001'})
	AADD(_Acamp,{'00017701'})
	AADD(_Acamp,{'00257101'})
	AADD(_Acamp,{'00017401'})
	AADD(_Acamp,{'03050401'})
	AADD(_Acamp,{'00408101'})
	AADD(_Acamp,{'05603601'})
	AADD(_Acamp,{'03187901'})
	AADD(_Acamp,{'06956101'})
	AADD(_Acamp,{'06973401'})
	AADD(_Acamp,{'01089201'})
	AADD(_Acamp,{'00088801'})
	AADD(_Acamp,{'00088802'})
	AADD(_Acamp,{'00613401'})
	AADD(_Acamp,{'06544701'})
	AADD(_Acamp,{'00059001'})
	AADD(_Acamp,{'01291501'})
	AADD(_Acamp,{'07084601'})
	AADD(_Acamp,{'01316701'})
	AADD(_Acamp,{'03509301'})
	AADD(_Acamp,{'00162601'})
	AADD(_Acamp,{'03869201'})
	AADD(_Acamp,{'04279201'})
	AADD(_Acamp,{'00332201'})
	AADD(_Acamp,{'01158201'})
	AADD(_Acamp,{'01540101'})
	AADD(_Acamp,{'01540301'})
	AADD(_Acamp,{'00031801'})
	AADD(_Acamp,{'00077401'})
	AADD(_Acamp,{'00373201'})
	AADD(_Acamp,{'00660801'})
	AADD(_Acamp,{'00688801'})
	AADD(_Acamp,{'00909101'})
	AADD(_Acamp,{'00910901'})
	AADD(_Acamp,{'01466101'})
	AADD(_Acamp,{'01840501'})
	AADD(_Acamp,{'02167001'})
	AADD(_Acamp,{'02253801'})
	AADD(_Acamp,{'05421301'})
	AADD(_Acamp,{'06452801'})
	AADD(_Acamp,{'06514201'})
	AADD(_Acamp,{'00872401'})
	AADD(_Acamp,{'00872404'})
	AADD(_Acamp,{'00872405'})
	AADD(_Acamp,{'03576301'})
	AADD(_Acamp,{'05585201'})
	AADD(_Acamp,{'01089301'})
	AADD(_Acamp,{'02751801'})
	AADD(_Acamp,{'03557001'})
	AADD(_Acamp,{'03800101'})
	AADD(_Acamp,{'02058401'})
	AADD(_Acamp,{'01294001'})
	AADD(_Acamp,{'03759801'})
	AADD(_Acamp,{'04710601'})
	AADD(_Acamp,{'05900601'})
	AADD(_Acamp,{'05570901'})
	AADD(_Acamp,{'00426401'})
	AADD(_Acamp,{'03081201'})
	AADD(_Acamp,{'01584203'})
	AADD(_Acamp,{'02604801'})
	AADD(_Acamp,{'06974301'})
	AADD(_Acamp,{'05553501'})
	AADD(_Acamp,{'07047301'})
	AADD(_Acamp,{'05831501'})
	AADD(_Acamp,{'05739401'})
	
	
	For i:=1 To Len(_Acamp)
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+_Acamp[i,1]))
			
			
			dbSelectArea("PPE")
			PPE->(RecLock("PPE",.T.))
			//PPE_NUM     PPE_CLIENT     PPE_LOJA     PPE_NOME                        PPE_AREA     PPE_DESCRI            PPE_SUPER     PPE_DESUPE
			PPE->PPE_NUM   		:=  '000001'
			PPE->PPE_CLIENT  	:=   SA1->A1_COD
			PPE->PPE_LOJA  		:=   SA1->A1_LOJA
			PPE->PPE_NOME  		:=   SA1->A1_NOME
			PPE->PPE_AREA 		:=   SA1->A1_VEND
			PPE->PPE_DESCRI  	:=   Posicione("SA3",1,xFilial("SA3") + SA1->A1_VEND ,"A3_NOME")
			PPE->PPE_SUPER 		:=  Posicione("SA3",1,xFilial("SA3") + SA1->A1_VEND  ,"A3_SUPER")
			PPE->PPE_DESUPE 	:=  Posicione("SA3",1,xFilial("SA3") + PPE->PPE_SUPER,"A3_NOME")
			
			PPE->(MsUnLock())
			
		EndIf
		
		
	Next i
	
Return()

