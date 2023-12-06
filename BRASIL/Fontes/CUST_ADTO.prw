#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณCUST_ADTO  บAutor  ณPedro Augusto Cardoso Data ณ 21/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada na solicitacao de viagem para inserir  	  บฑฑ
ฑฑบ		     ณacrescimo na solicitacao.              	                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TRIVALE													  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CUST_ADTO()
	Local _aArea  := GetArea()  
    Local _nValor := 0
//----------------------------------------------------------------------------------------------------------
//	Local _nValorOld := _nValAcr
	Local _nValorNew := 0 , oEditaValor
	DEFINE MSDIALOG oEditaValor FROM  000,000 TO 100,365 TITLE "Acrescimo" PIXEL
	
	@ 005,005 GET _oValor VAR _nValor picture '@E 99,999.99' When .t. Size 75,025 OF oEditaValor PIXEL
	                                      
	DEFINE SBUTTON FROM 034,120 TYPE 1 ENABLE OF oEditaValor ACTION (nOpca:=1,_nValorNew:= ValorOk(_nValor   ,oEditaValor))
	DEFINE SBUTTON FROM 034,150 TYPE 2 ENABLE OF oEditaValor ACTION (nOpca:=0,_nValorNew:= ValorOk(_nValorNew ,oEditaValor))
	
	ACTIVATE MSDIALOG oEditaValor CENTERED
	
	RestArea(_aArea)          
	Return   _nValorNew 

//----------------------------------------------------------------------------------------------------------
Static Function ValorOK(_nValor_,oEditaValor)
	oEditavALOR:End()
	Return(_nValor_)

