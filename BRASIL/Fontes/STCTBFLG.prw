#include "protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCTBFLG   �Autor �Cristiano Pereira         �  28/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Limpeza de flag do processo de concilica��o              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � STCTBFLG                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STCTBFLG()

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

	Processa({|lEnd| LeTXT(aTxt)},"Aguarde, lendo arquivo de Estruturas...")

Return

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
		If !IsDigit(SubStr(cLinha,1,1))
			FT_FSKIP()
			Loop
		EndIf
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
���Programa  � IMPFORN   �Autor �Cristiano Pereira            � Data �  28/01/12   ���
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
    Local _cSql       := ""

	For nX := 1 to Len(aTxt)
        _cQry := " UPDATE "+RetSqlName("SE5")+"  SE5 SET E5_LA = ' ' WHERE E5_FILIAL ='"+aTxt[nX,2]+"' AND R_E_C_N_O_ ='"+aTxt[nX,1]+"'   AND D_E_L_E_T_ <> '*'   "
        TcSQLExec(_cQry)
	Next nX 



Return
