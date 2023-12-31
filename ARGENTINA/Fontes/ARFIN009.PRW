#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ARFIN009   � Autor � Cristiano Pereira� Data � 10/11/2008  ���
�������������������������������������������������������������������������͹��
���Descricao � Gera��o da aglutina��o dos t�tulos para compensa��o da PA  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP12                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function  ARFIN009()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oGeraAgl
Private cPerg    := "ARFI09"


dbSelectArea( "SRA" )
dbSetOrder( 1 )

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
DEFINE MSDIALOG oGeraAgl FROM  200,001 TO 410,480 TITLE OemToAnsi( "Aglutinaci�n de t�tulos financieros" ) PIXEL

@ 002, 010 TO 095, 230 OF oGeraAgl  PIXEL

@ 010, 018 SAY " Este programa generar� la aglutinaci�n de facturas " SIZE 200, 007 OF oGeraAgl PIXEL
@ 018, 018 SAY " a partir de la selecci�n financiera                              " SIZE 200, 007 OF oGeraAgl PIXEL
@ 026, 018 SAY "                                                               " SIZE 200, 007 OF oGeraAgl PIXEL

DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraAgl ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraAgl ACTION (OkGeraAgl(),oGeraAgl:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraAgl ACTION (oGeraAgl:End())


ACTIVATE MSDIALOG oGeraAgl Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OkGeraAgl  � Autor � Cristiano Pereira� Data � 10/11/2008  ���
�������������������������������������������������������������������������͹��
���Descricao � Sele��o dos t�tulos                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP12                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkGeraAgl()

//Declaracao das variaveis

Private _oMarcados, _cAlias,_cQuery
Private _nMarcado
Private _lOk, lInverte
Private _aStr,_aArea
Private _Tmp1
Private _aTIT,_aCampos
Private _cPesq
Private oMTRMT43


// Variaveis utilizada na selecao
_nMarcados := 0
_nQtde     := 0
_oMarcados := ""
_oQtde     := ""

//Matriz com o nome dos campos do arquivo temporario a serem mostrados no Browse
_aTIT := {}

Aadd( _aTIT, {"OK"            ,"C",02,0} )
Aadd( _aTIT, {"TITULO"        ,"C",12,0} )
Aadd( _aTIT, {"PARCELA"        ,"C",02,0} )
Aadd( _aTIT, {"FORNEC"        ,"C",06,0} )
Aadd( _aTIT, {"LOJA"          ,"C",02,0} )
Aadd( _aTIT, {"NOME"          ,"C",20,0} )
Aadd( _aTIT, {"VALOR"        ,"N",16,2} )
Aadd( _aTIT, {"PREFIXO"        ,"C",3,0} )
Aadd( _aTIT, {"TIPO"        ,"C",3,0} )




// Fecha arquivo temporario
If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif


//Cria arquivo temporario com os campos acima
_Tmp1 := CriaTrab(_aTIT,.t.)

If !Empty(_Tmp1)
	DbUseArea(.t.,,_Tmp1,"TRB1",.t.,.f.)
EndIf

//Matriz com o nome dos campos do arquivo temporario a serem mostrados no Browse
_aCampo := {}

Aadd( _aCampo, {"OK"        ,," "                     , } )
Aadd( _aCampo, {"TITULO"       ,,"T�tulo"             , } )
Aadd( _aCampo, {"PARCELA"      ,,"Parcela"            , } )
Aadd( _aCampo, {"FORNEC"   ,,"Fornecedor"             , } )
Aadd( _aCampo, {"LOJA"     ,,"Loja"                   , } )
Aadd( _aCampo, {"NOME"     ,,"Nome"                   , } )
Aadd( _aCampo, {"VALOR"     ,,"Valor"                 , } )
Aadd( _aCampo, {"PREFIXO"     ,,"Prefixo"             , } )
Aadd( _aCampo, {"TIPO"     ,,"Tipo"                   , } )

// Fecha arquivo temporario
If Select("TSE2") > 0
	DbSelectArea("TSE2")
	DbCloseArea()
Endif


//###############################################
//          SELE��O DAS PENDENCIAS DE RACS      #
//###############################################
_cQuery := " "
_cQuery += " SELECT SE2.E2_FILIAL AS FIL,SE2.E2_PREFIXO AS PREF,SE2.E2_TIPO AS TIPO,SE2.E2_NUM AS NUM,SE2.E2_FORNECE AS FORNECE,SE2.E2_LOJA AS LOJA,SE2.E2_PARCELA AS PARC,SE2.E2_SALDO AS SALDO,SE2.E2_NOMFOR AS NOMFOR  "
_cQuery += " FROM  "+RetSqlName("SE2")+" SE2             "
_cQuery += " WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"'                                   AND                            "
_cQuery += "       SE2.D_E_L_E_T_ <> '*'                                                  AND                            "
_cQuery += "       SE2.E2_FORNECE >='"+MV_PAR01+"' AND SE2.E2_FORNECE <='"+MV_PAR02+"'    AND                            "
_cQuery += "       SE2.E2_LOJA    >='"+MV_PAR03+"' AND SE2.E2_LOJA <='"+MV_PAR04+"'       AND                            "
_cQuery += "       SE2.E2_SALDO > 0                                                       AND                            "
_cQuery += "       ( SE2.E2_TIPO = 'NF' OR SE2.E2_TIPO = 'FT' )                         AND                            "
_cQuery += "       SE2.E2_EMISSAO    >='"+DTOS(MV_PAR05)+"' AND SE2.E2_EMISSAO <='"+DTOS(MV_PAR06)+"'                    "

_cQuery += " ORDER BY SE2.E2_NUM,SE2.E2_EMISSAO   "

TCQUERY _cQuery NEW ALIAS "TSE2"

TCSETFIELD("TSE2","E2_EMISSAO","D",8,0)

_nRec   := 0
DbEval({|| _nRec++  })

DbSelectArea("TSE2")
DbGotop()
ProcRegua(lastRec())

While !TSE2->(EOF())


	IncProc("Processando t�tulo  "+TSE2->FIL+" "+TSE2->NUM+" "+TSE2->FORNECE)

	DbSelectArea("TRB1")
	Do While !RecLock("TRB1",.T.)
	EndDo
	TRB1->TITULO   :=  TSE2->NUM
	TRB1->PARCELA  :=  TSE2->PARC
	TRB1->FORNEC    := TSE2->FORNECE
	TRB1->LOJA     := TSE2->LOJA
	TRB1->NOME   :=  TSE2->NOMFOR
	TRB1->VALOR    :=  TSE2->SALDO
	TRB1->PREFIXO  := TSE2->PREF
	TRB1->TIPO  := TSE2->TIPO



	MsUnlock()
	DbSelectArea("TSE2")
	DbSkip()
Enddo


DbSelectArea("TRB1")
_cIndTRB := CriaTrab(Nil, .F.)
_cChave  := "NOME"
IndRegua("TRB1",_cIndTRB,_cChave,,,"Criando Indice...")


DbGoTop()

If _nRec == 0
	DbSelectArea("TRB1")
	DbCloseArea()
	Ferase(_Tmp1+".Dbf")
	Aviso("NR","N�o existem dados para selecionar.",{"Ok"})
	return
Endif


lInverte := .f.
cMarca   := GetMark()
_aLEG    := {}

AAdd( _aLEG,{"	TRB1->TITULO<> Space(1)","BR_VERDE"})



//Posiciona no primeiro registro do temporario
DbSelectArea("TRB1")
DbGotop()

//####################################################
//   Montagem de Browse para interface com o usuario #
//####################################################

Define MsDialog oMTRMT43 Title OemToAnsi("STECK ARG - Aglutina��o de t�tulos") From C(3),C(3) To C(30),C(120)
@ C(020),C(080) To C(180),C(500)

@ C(002),C(005) BUTTON "Pesquisar" SIZE C(50),C(15) ACTION (IIF(ARFI09A(@_cPesq) <> SPACE(40),TRB1->(DbSeek(_cPesq)),TRB1->(DbGotop())))
@ C(3.9),C(005) BUTTON "Aglutinar" SIZE C(50),C(15) ACTION ARFI09B()
@ C(006),C(005) BUTTON "Sair" SIZE C(50),C(15) ACTION _Sair1(oMTRMT43)

oMark := MsSelect():New("TRB1","OK","",_aCampo,@lInverte,@cMarca,{C(20),C(70),C(180),C(430)},,,,,_aLEG)

//Ativa janela de dialogo
Activate MsDialog oMTRMT43 CENTERED



return

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function C(nTam)

Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor

Do Case
	Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
EndCase

If "MP8" $ oApp:cVersion
	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DURIN48G �Autor  � Cristiano Pereira  � Data �  25/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pesquisar um fornecedor na tabela temporaria               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6- Especifico Dura Automotive                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ARFI09A(_cPesq)

Local cCcFilial := "01"
Local cFilMat   := "01"
Local lRet      := .T.
Local oDlgU
Local oFilUsr
Local cFilUsr   := cCcFilial
Local oDesUsr
Local cCodFor   := Space(TamSx3("A2_COD" )[1])
Local cDesFor   := Space(TamSx3("A2_NOME")[1])
Local cCodFor
Private cDesUsr
Private oCodFor



DEFINE MSDIALOG oDlgU FROM 000,000 TO 160,340 TITLE OemToAnsi("Pesquisar") PIXEL //"Pesquisar"

@ 020,003 TO 065,165 LABEL OemToAnsi("Fornecedor") OF oDlgU PIXEL

@ 030,006 SAY OemToAnsi("Fil") SIZE 010,008 OF oDlgU PIXEL
@ 040,006 MSGET oFilUsr VAR cCcFilial PICTURE "99" F3 "SM0" SIZE 010,008 OF oDlgU PIXEL VALID QA_CHKFIL(cCcFilial,@cFilMat)

@ 030,025 SAY OemToAnsi("C�digo") SIZE 044,008 OF oDlgU PIXEL  //"C�digo"
@ 040,028 MSGET oCodFor VAR cCodFor  PICTURE '@!' F3 "SA2" SIZE 044,008 OF oDlgU PIXEL;
VALID (cDesUsr:= A2_FOR1(cCcFilial,cCodFor,.T.),	oDesUsr:Refresh(),A2_CHK1(cCcFilial,cCodFor,SA2->A2_LOJA))

@ 030,075 SAY OemToAnsi("Nome") SIZE 85,008 OF oDlgU PIXEL  //"Nome"
@ 040,075 MSGET oDesUsr VAR cDesUsr SIZE 85,008 OF oDlgU PIXEL WHEN .f.

ACTIVATE MSDIALOG oDlgU CENTERED ON INIT EnchoiceBar(oDlgU,{|| lRet:=.T., oDlgU:End()},{|| lRet:=.F., oDlgU:End()} )

cCcFilial := cFilUsr
_cPesq    := cDesUsr

Return(_cPesq)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_Sair     �Autor  �Cristiano Pereira    � Data �  25/01/09  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fecha o Objeto                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function _Sair1(oMTRMT43)

DbSelectArea("TRB1")
Ferase(_Tmp1+".Dbf")
//Close(oMTRMT43)
oMTRMT43:End()
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARFI09  �Autor  �Cristiano Pereira     � Data �  01/18/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa aglutina��o                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ARFI09B()

Local aArray:={}
Local aTit :={}
Local _aArea  := GetArea()
Local _dEmisdE:= MV_PAR05
Local _dEmisAt :=MV_PAR06
Local _cGerPr  := MV_PAR07
Local _cLojPr  := MV_PAR08
Local _nSeq    := 1


Private lMsErroAuto := .F.

DbSelectArea("TRB1")
DbGotop()

While !TRB1->(EOF())

	If !Empty(TRB1->OK)

	   _aArea  := GetArea()

		aArray:={}
		aTit :={}

		MV_PAR01:=2

		aAdd( aTit,	{TRB1->PREFIXO,TRB1->TITULO,"  ", TRB1->TIPO,.T.})
		aArray := { "FAT", "FT",MV_PAR09+StrZero(_nSeq,2), "21003", _dEmisdE, _dEmisAt,TRB1->FORNEC,TRB1->LOJA,_cGerPr,_cLojPr, "501", 01, aTit , , }
		//aAdd( aArray ,{ "FAT", "FT", , "21003", MV_PAR05, MV_PAR06,TRB1->FORNEC,TRB1->LOJA,,,"501", 01, aTit , , })

		//BEGIN TRANSACTION
		lMsErroAuto := .F.
		MsExecAuto( { |x,y| FINA290(x,y)},3,aArray,)
		IF lMsErroAuto
			MostraErro()
			DisarmTransaction()
		ENDIF
		//END TRANSACTION


		If lMsErroAuto
		    Alert("Erro na opera��o...")
			MostraErro()
			Exit

		Endif

		RestArea(_aArea)

		_nSeq++
		//aArray := { "FAT", "NF", "FT0001", "21003", MV_PAR05, MV_PAR06,TRB1->FORNEC,TRB1->LOJA,MV_PAR07,MV_PAR08, "501", 01, aTit , , }
	Endif

	DbSelectArea("TRB1")
	DbSkip()
Enddo

DbSelectArea("TRB1")
DbGotop()

If !lMsErroAuto
	MsgInfo("Faturas geradas com sucesso...")
Endif


return


