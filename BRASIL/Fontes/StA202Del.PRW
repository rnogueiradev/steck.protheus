#include "RWMAKE.CH"
#include "Protheus.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  A200Exclui| Autor � FlexPro             � Data �29.01.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exclusao de componentes na Estrutura                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA200                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function A202spdl()

Local aArea    :=GetArea()
Local cCodOrig :=Criavar("GG_COMP" ,.F.),cCodDest :=Criavar("GG_COMP" ,.F.)
Local cGrpOrig :=Criavar("GG_GROPC",.F.),cGrpDest :=Criavar("GG_GROPC",.F.)
Local cDescOrig:=Criavar("B1_DESC" ,.F.),cDescDest:=Criavar("B1_DESC" ,.F.)
Local cOpcOrig :=Criavar("GG_OPC"  ,.F.),cOpcDest :=Criavar("GG_OPC"  ,.F.)
Local oSay,oSay2
Local lOk:=.F.
Local aAreaSX3:=SX3->(GetArea())
//��������������������������������������������������������������Ŀ
//� Variavel lPyme utilizada para Tratamento do Siga PyME        �
//����������������������������������������������������������������
Local lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("GG_OK")
	dbSelectArea("SX3")
	dbSetOrder(1) 
	dbSelectArea("SGG")
	DEFINE MSDIALOG oDlg FROM  140,000 TO 350,615 TITLE OemToAnsi("Exclusao Componentes") PIXEL //"Substituicao de Componentes"
	DEFINE SBUTTON oBtn FROM 800,800 TYPE 5 ENABLE OF oDlg
	@ 026,006 TO 056,305 LABEL OemToAnsi("Componente Original") OF oDlg PIXEL //"Componente Original"
	@ 038,035 MSGET cCodOrig   F3 "SB1" Picture PesqPict("SGG","GG_COMP") Valid NaoVazio(cCodOrig) .And. ExistCpo("SB1",cCodOrig)  SIZE 105,09 OF oDlg PIXEL
	@ 048,030 SAY oSay Prompt cDescOrig SIZE 130,6 OF oDlg PIXEL
	@ 040,013 SAY OemtoAnsi("Produto")   SIZE 24,7  OF oDlg PIXEL 

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())}) 
	// Processa substituicao dos componentes
	If lOk
		Processa({|| A200PrSubs(cCodOrig,cGrpOrig,cOpcOrig) })
	EndIf
Else
	Aviso(OemToAnsi("Atencao"),OemToAnsi("Para utilizacao dessa opcao deve ser criado o campo GG_OK semelhante ao campo C9_OK."),{"Ok"}) //"Atencao"###"Para utilizacao dessa opcao deve ser criado o campo GG_OK semelhante ao campo C9_OK."
EndIf
SX3->(RestArea(aAreaSX3))
RestArea(aArea)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A200PrSubs  � Autor � FlexPro             � Data �29.01.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta markbowse para selecao e substituicao dos componentes���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A200PrSubs(ExpC1,ExpC2,ExpC3,ExpC4,ExpC5,ExpC6)            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto origem                           ���
���          � ExpC2 = Grupo de opcionais origem                          ���
���          � ExpC3 = Opcionais do produto origem                        ���
���          � ExpC4 = Codigo do produto destino                          ���
���          � ExpC5 = Grupo de opcionais destino                         ���
���          � ExpC6 = Opcionais do produto destino                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA200                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function A200PrSubs(cCodOrig,cGrpOrig,cOpcOrig)
Local cFilSGG     := ""
Local cQrySGG     := ""
Local aIndexSGG   := {}
Local aBackRotina := ACLONE(aRotina)
//��������������������������������������������������������������Ŀ
//� Variavel lPyme utilizada para Tratamento do Siga PyME        �
//����������������������������������������������������������������
Local lPyme:= Iif(Type("__lPyme") <> "U",__lPyme,.F.)

PRIVATE cMarca200 := ThisMark()
PRIVATE bFiltraBrw
PRIVATE cCadastro := OemToAnsi("Estrutura de Produtos")
PRIVATE aRotina   := {  {"Excluir","U_StB22Del", 0 , 1}} 

cFilSGG := "GG_FILIAL='"+xFilial("SGG")+"'"
cFilSGG += ".And.GG_COMP=='"+cCodOrig+"'"

cQrySGG := "SGG.GG_FILIAL='"+xFilial("SGG")+"'"
cQrySGG += " AND SGG.GG_COMP='"+cCodOrig+"'"

//������������������������������������������������������������������������Ŀ
//�Realiza a Filtragem                                                     �
//��������������������������������������������������������������������������
dbSelectArea("SGG")
dbSetOrder(1)
bFiltraBrw := {|x| If(x==Nil,FilBrowse("SGG",@aIndexSGG,@cFilSGG),{cFilSGG,cQrySGG,"","",aIndexSGG}) }
Eval(bFiltraBrw)

dbSelectArea("SGG")
If !MsSeek(xFilial("SGG"))
	HELP(" ",1,"RECNO")
Else
	//������������������������������������������������������������������������Ŀ
	//�Monta o browse para a selecao                                           �
	//��������������������������������������������������������������������������
	MarkBrow("SGG","GG_OK")
EndIf

//������������������������������������������������������������������������Ŀ
//�Restaura condicao original                                              �
//��������������������������������������������������������������������������
dbSelectArea("SGG")
RetIndex("SGG")
dbClearFilter()
aEval(aIndexSGG,{|x| Ferase(x[1]+OrdBagExt())})
aRotina:=ACLONE(aBackRotina)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �StA22Del    � Autor � FlexPro             � Data �29.01.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava a Exclusao dos componentes                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � StA22Del(ExpC1,ExpN1,ExpN2)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo	              (OPC)               ���
���          � ExpN1 = Numero do registro             (OPC)               ���
���          � ExpN2 = Numero da opcao selecionada    (OPC)               ���
���          � ExpC2 = Marca para substituicao                            ���
���          � ExpL1 = Inverte marcacao                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA200                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function StB22Del(cAlias,nRecno,nOpc,cMarca200,lInverte)
Local aRecnosSGG:= {}
Local aRecnosSGF:= {}
Local aAreaSGF	:= SGF->(GetArea()) 
Local lRet		:= .T.
Local nRecnoSGF
Local nz:=0

dbSelectArea("SGG")
dbSeek(xFilial("SGG"))
DbGotop()

While !Eof() .And. GG_FILIAL == xFilial("SGG")
	
	// Verifica os registros marcados para Exclsuao
	If IsMark("GG_OK",cMarca200,lInverte)
		Reclock("SGG",.F.)
		Delete
		MsUnlock()
	EndIf
	dbSkip()

EndDo

Return 
