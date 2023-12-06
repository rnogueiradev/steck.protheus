#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCSTO02 �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Itens para entrar no calculo da ferramenta                 ���
���          �                                                            ���
���          |                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function STCSTO02()

	Local aSays			:= {}
	Local aButtons 		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= " Ferramenta infla��o de custo MP "

	AADD(aSays," Ferramenta infla��o de custo MP  ")
	AADD(aSays," ")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"VERSAO 1.0 ")
	AADD(aSays,"Especifico Steck Industria Ltda")
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro , aSays , aButtons )


	Processa( { || STCTO02A() } , "Processando da carga de custo MP..." )
	MsgInfo("Processamento finalizado com sucesso..","Aten��o")

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCTO02A �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicio do processamento                                     ���
���          �                                                            ���
���          |                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �Especifico AmericaNet V                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function STCTO02A()


//��������������������������������������������������������������������������Ŀ
//� Declara variaveis.														 �
//����������������������������������������������������������������������������
	Local aTxt    := {}						//Array com os campos enviados no TXT.
	Local nHandle := 0						//Handle do arquivo texto.
	Local cArqImp := ""						//Arquivo Txt a ser lido.

//��������������������������������������������������������������������������Ŀ
//� Posiciona areas.														 �
//����������������������������������������������������������������������������
	SG1->(dbSetOrder(1))  //CNPJ do Fornecedor

//��������������������������������������������������������������������������Ŀ
//� Busca o arquivo para leitura.											 �
//����������������������������������������������������������������������������
	cArqImp := cGetFile("Arquivo .CSV |*.CSV","Selecione o Arquivo CSV",0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	If (nHandle := FT_FUse(cArqImp))== -1
		MsgInfo("Erro ao tentar abrir arquivo.","Aten��o")
		Return
	EndIf

	Processa({|lEnd| LeTXT(aTxt)},"Aguarde, lendo arquivo de acumulados...")

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPFORN   �Autor �Cristiano Pereira           � Data �  28/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Le o Txt e carrega os dados.				                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LeTXT(aTxt)

//��������������������������������������������������������������������������Ŀ
//� Declara variaveis.														 �
//����������������������������������������������������������������������������
	Local cLinha  := ""						//Linha do arquivo texto a ser tratada.
	Local nReg    := 0

	FT_FGOTOP()
	aTxt := {}
	While !FT_FEOF()
		nReg++
		IncProc("Registro:"+ Str(nReg))
		cLinha := FT_FREADLN()

		cLinha := Upper(NoAcento(AnsiToOem(cLinha)))
		AADD(aTxt,{})
		While At(";",cLinha) > 0
			aAdd(aTxt[Len(aTxt)],AllTrim(Substr(cLinha,1,At(";",cLinha)-1)))
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		EndDo
		cLinha := StrTran(Substr(cLinha,1,Len(cLinha)),',','.')
		aAdd(aTxt[Len(aTxt)],AllTrim(StrTran(Substr(cLinha,1,Len(cLinha)),'"','')))
		FT_FSKIP()
	EndDo
	GravaDados(aTxt)
	FT_FUSE()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GravaDados  �Autor �Cristiano Pereira    Data �  28/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Grava os dados lidos			                  			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaDados(aTxt)

	Local nX    	  := 0
	Local cQry    
	//Private lMsErroAuto := .F.
	Private aCabec   := {}


	//Limpeza dos filtros 


	cQry := " UPDATE "+RetSqlName("SB1")+" SB1 SET B1_XINFMP = ''  WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_XINFMP  = 'S' AND  SB1.D_E_L_E_T_ <> '*'   "
	_cEvSql   :=  TcSqlExec(cQry)

	If _cEvSql  <> 0
			DisarmTransaction()
			MsgAlert('Erro no UPDATE: ' + AllTrim(Str(_cEvSql)),'ATEN��O')
	EndIf
	

	For nX := 1 to Len(aTxt)

		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+aTxt[nX,1])
			If Reclock("SB1",.F.)
				SB1->B1_XINFMP :="S"
				MsUnlock()
			Endif
		Endif

	Next nx

	MsgInfo("Processamento finalizado!!!","Aten��o")


Return
