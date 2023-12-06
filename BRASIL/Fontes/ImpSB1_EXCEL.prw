#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpSB1XLS �Autor  �Renato Nogueira     � Data �  28/08/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa utilizado para importar dados para a SB1 atraves de���
���          �um arquivo excel                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static __lOpened := .F.

User Function ImpSB1XLS()

	Local cArq    := "produtos.csv"
	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local cDir	  := "C:\arquivos_protheus\"
	Local n		  := 0
	Local i		  := 0
	Local oDlg

	Private aErro := {}

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	_cLog:= "RELAT�RIO DE PRODUTOS N�O ENCONTRADOS "+CHR(13) +CHR(10)

	If !File(cDir+cArq)
		MsgStop("O arquivo " +cDir+cArq + " n�o foi encontrado. A importa��o ser� abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cDir+cArq)                   // abrir arquivo
	ProcRegua(FT_FLASTREC())             // quantos registros ler
	FT_FGOTOP()                          // ir para o topo do arquivo
	
	_cDescCont := ""

	While !FT_FEOF()                     // fa�a enquanto n�o for fim do arquivo

		cLinha := FT_FREADLN()           // lendo a linha
		If At(";",cLinha) > 0
			AADD(aDados,Separa(cLinha,";",.T.))
		Else
			aDados[Len(aDados)][2] += Chr(13)+Chr(10)+cLinha
		EndIf

		FT_FSKIP()

	EndDo

	//Begin Transaction             //inicia transa��o
	ProcRegua(Len(aDados))   //incrementa regua

	For i:=1 to Len(aDados)  //ler linhas da array

		IncProc("Importando SB1...")

		dbSelectArea("SB1")
		dbSetOrder(1)
		DbSeek(xFilial("SB1")+aDados[i,1])

		If !SB1->(Eof())

			Reclock("SB1",.F.)

			SB1->B1_XDESEXD	:= aDados[i,2]

			SB1->(MsUnlock())

		Else

			_ClOG+= aDados[i,1]+CHR(13) +CHR(10)

		Endif

	Next i
	//End Transaction              // finaliza transa��o

	FT_FUSE()

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _clOG Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	ApMsgInfo("Importa��o conclu�da com sucesso!","SUCESSO")

Return