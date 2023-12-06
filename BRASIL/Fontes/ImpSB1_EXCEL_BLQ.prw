#include "totvs.ch"
#include "protheus.ch"


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


User Function ImpSB1BLQ()

Local cArq    := "codigos_bloqueados.csv"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local cDir	  := "C:\"
Local n		  := 0
Local i		  := 0
Private aErro := {}

If !File(cDir+cArq)
	MsgStop("O arquivo " +cDir+cArq + " n�o foi encontrado. A importa��o ser� abortada!","[AEST901] - ATENCAO")
	Return
EndIf

FT_FUSE(cDir+cArq)                   // abrir arquivo
ProcRegua(FT_FLASTREC())             // quantos registros ler
FT_FGOTOP()                          // ir para o topo do arquivo
While !FT_FEOF()                     // fa�a enquanto n�o for fim do arquivo
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()           // lendo a linha
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
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
		
		SB1->B1_PROC		:= aDados[i,2]
		        
		SB1->(MsUnlock())
		
	Else
	
	MsgAlert("Produto: "+aDados[i,1]+" n�o encontrado")
		
	Endif
	
	
Next i
//End Transaction              // finaliza transa��o

FT_FUSE()

ApMsgInfo("Importa��o conclu�da com sucesso!","[AEST901] - SUCESSO")

Return