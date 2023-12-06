#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STIMPSZ0        | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | Importar chamados 							                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPSZ0()

	Local cArquivo := cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)
	Local aDados   := {}
	Local aCampos  := {}
	Local lPrim	   := .T.
	Local i		   := 0

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SZ0" MODULO "FAT"

	FT_FUSE(cArquivo)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))   //incrementa regua
	For i:=1 to Len(aDados)  //ler linhas da array

		_cNum := U_STTEC020()

		SZ0->(RecLock("SZ0",.T.))
		SZ0->Z0_NUM 		:= _cNum
		SZ0->Z0_USUARIO		:= aDados[i,4]
		SZ0->Z0_MODULO		:= GETMOD(aDados[i,3])
		SZ0->Z0_DESCRI		:= aDados[i,5]
		SZ0->Z0_ANALIST		:= "000010"
		SZ0->Z0_TIPO		:= "C"
		SZ0->Z0_DTSOLIC		:= CTOD(aDados[i,1])
		SZ0->Z0_HRSOLIC		:= "18:00"
		SZ0->Z0_DTENC		:= CTOD(aDados[i,1])
		SZ0->Z0_HRENC		:= "18:00"
		SZ0->Z0_STATUS		:= "8"
		SZ0->Z0_OBS			:= aDados[i,5]
		SZ0->Z0_CLASERP		:= "1"
		SZ0->Z0_CRITICI		:= "1"
		SZ0->Z0_EMPRESA		:= GETEMP(aDados[i,2])
		SZ0->Z0_SOLUCAO		:= aDados[i,6]
		SZ0->Z0_TERCEIR		:= "CRISTIANO"
		SZ0->(MsUnLock())

	Next

Return

/*====================================================================================\
|Programa  | GETMOD          | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | 				 							                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETMOD(_cModulo)

	Local _cCod := ""

	_cModulo := AllTrim(_cModulo)

	Do Case
		Case _cModulo=="FISCAL"
		_cCod := "13"
		Case _cModulo=="CONTROLADORIA"
		_cCod := "04"
		Case _cModulo=="FINANCEIRO"
		_cCod := "03"
		Case _cModulo=="CUSTO"
		_cCod := "04"
	EndCase

Return(_cCod)

/*====================================================================================\
|Programa  | GETEMP          | Autor | RENATO.OLIVEIRA           | Data | 13/08/2018  |
|=====================================================================================|
|Descrição | 				 							                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETEMP(_cDesc)

	Local _cCod := ""

	_cDesc := AllTrim(_cDesc)

	Do Case
		Case _cDesc=="STECK SÃO PAULO"
		_cCod := "SP"
		Case _cDesc=="STECK ARGENTINA"
		_cCod := "AR"
		Case _cDesc=="STECK MANAUS"
		_cCod := "AM"
		Case _cDesc=="STECK BRASIL"
		_cCod := "SP"
	EndCase

Return(_cCod)