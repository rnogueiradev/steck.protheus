#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SRCTBR94 �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa��o do template cont�bil                            ���
���          �                                                            ���
���          |                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �Especifico Steck Ind�stria                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function SRCTBR94()

	Local aSays			:= {}
	Local aButtons 		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= " Importa��o do template cont�bil "

	AADD(aSays," Importa��o do template cont�bil")
	AADD(aSays," ")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"VERSAO 1.0 ")
	AADD(aSays,"Especifico Steck Ind�stria  ")
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro , aSays , aButtons )

	If nOpca==1
		Processa( { || SCTBR94A() } , "Processando template..." )
		MsgInfo("Processamento finalizado com sucesso..","Aten��o")
	Endif
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AMRNETD �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
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
Static Function SCTBR94A()


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

	Processa({|lEnd| LeTXT(aTxt)},"Aguarde, lendo arquivo de movimentos cont�beis...")

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
	//Private lMsErroAuto := .F.
	Private aCabec   := {}
	Private lMsErroAuto := .F.
	Private  lMSHelpAuto := .T.
	Private _aCab   := {}
	Private _aItem  := {}

	For nX := 1 to Len(aTxt)


       lMsErroAuto := .F.
       lMSHelpAuto := .T.
       _aCab   := {}
       _aItem  := {}


		aAdd(_aCab,  {'DDATALANC'     ,Ddatabase       ,NIL} )
		aAdd(_aCab,  {'CLOTE'         ,'000002'         ,NIL} )
		aAdd(_aCab,  {'CSUBLOTE'         ,'001'         ,NIL} )
		aAdd(_aCab,  {'CPADRAO'         ,''             ,NIL} )
		aAdd(_aCab,  {'NTOTINF'         ,0               ,NIL} )
		aAdd(_aCab,  {'NTOTINFLOT'     ,0                ,NIL} )



		aAdd(_aItem,{  {'CT2_FILIAL'      ,Rtrim(cEmpAnt)+Rtrim(cFilAnt)+Space(3)       , NIL},;
			{'CT2_LINHA'      , '001'          , NIL},;
			{'CT2_MOEDLC'      ,'01'           , NIL},;
			{'CT2_DC'           ,'3'           , NIL},;
			{'CT2_DEBITO'      ,aTxt[nX,3]     , NIL},;
			{'CT2_CREDIT'      ,aTxt[nX,4]     , NIL},;
			{'CT2_VALOR'      , Val(StrTran(aTxt[nX,5],",","."))  , NIL},;
			{'CT2_ORIGEM'     ,'CTBA102'    , NIL},;
			{'CT2_HP'           ,''               , NIL},;
			{'CT2_ITEMD'           ,aTxt[nX,7]               , NIL},;
			{'CT2_ITEMC'           ,aTxt[nX,8]               , NIL},;
            {'CT2_CCD'           , aTxt[nX,9]               , NIL},;
            {'CT2_CCC'           , aTxt[nX,10]               , NIL},;
			{'CT2_HIST'       , aTxt[nX,6]  , NIL} } )

		MSExecAuto({|x, y,z| CTBA102(x,y,z)}, _aCab ,_aItem, 3)

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()

		EndIf


	Next nx

	MsgInfo("Processamento finalizado!!!","Aten��o")


Return
