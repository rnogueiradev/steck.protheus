#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STFAT100        | Autor | RENATO.OLIVEIRA           | Data | 26/12/2018  |
|=====================================================================================|
|Descrição | Zerar emails com erro para tentar novamente                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT100()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "01"
	Local _cQuery1 	:= ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	ConOut("[STFAT100]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cQuery1 := " UPDATE Z1A010 Z1A
	_cQuery1 += " SET Z1A.Z1A_Q1=1
	_cQuery1 += " WHERE Z1A.D_E_L_E_T_=' ' AND Z1A_DATA='"+DTOS(Date())+"' AND Z1A_Q1=0 AND Z1A_Q2=0

	TcSqlExec(_cQuery1)

	ConOut("[STFAT100]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()