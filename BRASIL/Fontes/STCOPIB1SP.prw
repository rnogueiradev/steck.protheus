#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"

User Function STCOPIB1SP()

Local cEmpFilAtu	:= Alltrim(cEmpAnt + cFilAnt)
Private aRotAuto := {}
Private nOpc := 0
Private _cNewEmp		:= "01" //Manaus
Private _cNewFil 		:= "01" //Filial principal
Private aArea 		    := GetArea()
Private aAreaSB1 		:= SB1->(GetArea())


Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .f. // necessario a criacao, pois sera //atualizado quando houver

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO 'FAT'

If cEmpFilAtu $ "0301"

//	If INCLUI

		nOpc := 3

		aRotAuto:= {{'B1_COD' ,SB1->B1_COD,Nil},;
		{'B1_DESC' ,SB1->B1_DESC,Nil},;
		{'B1_TIPO' ,SB1->B1_TIPO,Nil},;
		{'B1_UM' ,SB1->B1_UM,Nil},;
		{'B1_LOCPAD' ,"01",Nil},;
		{'B1_PICM' ,0,Nil},;
		{'B1_IPI' ,0,Nil},;
		{'B1_PRV1' ,SB1->B1_PRV1,Nil},;
		{'B1_LOCALIZ' ,SB1->B1_LOCALIZ,Nil},;
		{'B1_ORIGEM' ,SB1->B1_ORIGEM,Nil},;
		{'B1_CLAPROD' ,SB1->B1_CLAPROD,Nil},;
		{'B1_GRUPO' ,SB1->B1_GRUPO,Nil},;
		{'B1_CODBAR' ,SB1->B1_CODBAR,Nil},;
		{'B1_POSIPI',SB1->B1_POSIPI,Nil},;
		{'B1_XGATCL',SB1->B1_XGATCL,Nil},;
		{'B1_XDESEXT',SB1->B1_XDESEXT,Nil},;
		{'B1_FANSTAM',SB1->B1_FANTASM,Nil},;
		{'B1_APROPRI',SB1->B1_APROPRI,Nil},;
		{'B1_XDESENH',SB1->B1_XDESENH,Nil},;
		{'B1_XDESEXT',SB1->B1_XDESEXT,Nil},;
		{'B1_XCOMP',SB1->B1_XCOMP,Nil},;
		{'B1_XTENSAO',SB1->B1_XTENSAO,Nil},;
		{'B1_XCORREN',SB1->B1_XCORREN,Nil},;
		{'B1_PESBRU',SB1->B1_PESBRU,Nil},;
		{'B1_PESO',SB1->B1_PESO,Nil},;
		{'B1_XCRIACB',SB1->B1_XCRIACB,Nil},;
		{'B1_XDESEXT',SB1->B1_XDESEXT,Nil},;
		{'B1_CODBAR',SB1->B1_CODBAR,Nil},;
		{'B1_GRTRIB',IIf(!Empty(SB1->B1_GRTRIB),"001",""),Nil},;
		{'B1_XDTINCL',SB1->B1_XDTINCL,Nil},;
		{'B1_XDESEXD',SB1->B1_XDESEXD,Nil}}

		StartJob("U_STCB1AM",GetEnvServer(), .T.,_cNewEmp, _cNewFil,aRotAuto,nOpc)

		If lMsErroAuto
			DisarmTransaction()
			break
		EndIf

		If lMsErroAuto
			Mostraerro()
		EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)


EndIf

Return .T.

