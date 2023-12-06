#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STIMPSE1        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA ATUALIZAR TITULOS DE CLIENTE                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STIMPSE1()

	Local cArquivo := ""
	Local aDados   := {}
	Local aCampos  := {}
	Local lPrim	   := .T.
	Local _cLog	   := ""
	Local i

	MsgInfo("Atenção para a estrutura do arquivo:"+CHR(13)+CHR(10)+"FILIAL;NUMERO;CLIENTE;LOJA;PREFIXO;"+CHR(13)+CHR(10)+"PARCELA;TIPO;VENCIMENTO;HISTÓRICO")

	cArquivo := cGetFile("Arquivos CSV  (*.CSV)  | *.CSV  ","",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)

	If Empty(cArquivo)
		Return
	EndIf

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

	DbSelectArea("SE1")
	SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

	ProcRegua(Len(aDados))   //incrementa regua
	For i:=1 to Len(aDados)  //ler linhas da array	

		_cFilial 	:= PADL(aDados[i][1],2,"0")
		_cNum		:= PADL(aDados[i][2],TamSx3("E1_NUM")[1],"0")
		_cCliente	:= PADL(aDados[i][3],TamSx3("E1_CLIENTE")[1],"0")
		_cLoja		:= PADL(aDados[i][4],TamSx3("E1_LOJA")[1],"0")
		_cPrefixo	:= PADL(aDados[i][5],TamSx3("E1_PREFIXO")[1],"0")
		_cParc		:= PADL(aDados[i][6],TamSx3("E1_PARCELA")[1])
		_cTipo		:= PADR(aDados[i][7],TamSx3("E1_TIPO")[1])

		SE1->(DbGoTop())
		If SE1->(DbSeek(_cFilial+_cCliente+_cLoja+_cPrefixo+_cNum+_cParc+_cTipo))

			SE1->(RecLock("SE1",.F.))
			SE1->E1_VENCREA := CTOD(aDados[i][8])
			SE1->E1_HIST	:= aDados[i][9]
			SE1->(MsUnLock())

			_cLog += "Título: "+_cNum+" alterado com sucesso"+CHR(13)+CHR(10)

		Else

			_cLog += "Título: "+_cNum+" não encontrado"+CHR(13)+CHR(10)

		EndIf

	Next

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Resumo do processamento'
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return()