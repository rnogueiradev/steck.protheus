#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STEXPDIC        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
|=====================================================================================|
|Descrição | Enviar wf pedidos APU						                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEXPDIC()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "01"

	Reset Environment

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cArq := ""

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	While SX3->(!Eof())
		_cArq += AllTrim(SX3->X3_ARQUIVO)+";"+AllTrim(SX3->X3_CAMPO)+";"+AllTrim(SX3->X3_TITULO)+Chr(13)+Chr(10)
		SX3->(DbSkip())
	EndDo

	cArquivo := "C:\ARQUIVOS\DIC.CSV"

	If File(cArquivo)
		MemoWrite(cArquivo,"")
		_nHandle := fopen(cArquivo,FO_READWRITE+FO_SHARED)
		fWrite(_nHandle,_cArq)
		fClose(_nHandle)
	EndIf

Return()
