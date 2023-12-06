#Include "MATR140.CH" 
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR140  � Autor � Alexandre Inacio Lemes� Data �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR140(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Matr140A( cAlias, nReg , _cTipo )

	Local oReport

	PRIVATE lAuto     := (nReg!=Nil) 

	Private _lAutoStk := .F.

	Default _cTipo := ""

	If !Empty(_cTipo) .And. !IsInCallStack("MATA110")
		_lAutoStk := .T.
	Else
		lAuto := .T.
		nReg := SC1->(Recno())
	EndIf

	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef(nReg)
	oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg = Registro posicionado do SC1 apartir Browse  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(nReg)

	Local oReport 
	Local oSection1 
	Local oCell         
	Local oBreak
	Local cTitle := STR0002 //"Solicitacao de Compra"
	Local cAliasSC1 := Iif(lAuto,"SC1",GetNextAlias())

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01    Do Numero                                        �
	//� mv_par02    Ate o Numero                                     �
	//� mv_par03    Todas ou em Aberto                               �
	//� mv_par04    A Partir da data de emissao                      �
	//� mv_par05    Ate a data de emissao                            �
	//� mv_par06    Do Item                                          �
	//� mv_par07    Ate o Item                                       �
	//� mv_par08    Campo Descricao do Produto.                      �
	//� mv_par09    Imprime Empenhos ?                               �
	//� mv_par10    Utiliza Amarracao ?  Produto   Grupo             �
	//� mv_par11    Imprime Qtos Pedido Compra?                      �
	//� mv_par12    Imprime Qtos Fornecedores?                       �
	//� mv_par13    Impr. SC's Firmes, Previstas ou Ambas            �
	//����������������������������������������������������������������
	Pergunte("MTR140",.F.)

	//������������������������������������������������������������������������Ŀ
	//�Criacao do componente de impressao                                      �
	//�                                                                        �
	//�TReport():New                                                           �
	//�ExpC1 : Nome do relatorio                                               �
	//�ExpC2 : Titulo                                                          �
	//�ExpC3 : Pergunte                                                        �
	//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
	//�ExpC5 : Descricao                                                       �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport := TReport():New(StrTran("MTR140"+DTOS(Date())+Time(),":"),cTitle,If(lAuto,Nil,"MTR140"), {|oReport| ReportPrint(oReport,cAliasSC1,nReg)},STR0001) //"Emissao das solicitacoes de compras cadastradas"
	oReport:SetLandscape() 
	oReport:SetEnvironment(2)
	//������������������������������������������������������������������������Ŀ
	//�Criacao da secao utilizada pelo relatorio                               �
	//�                                                                        �
	//�TRSection():New                                                         �
	//�ExpO1 : Objeto TReport que a secao pertence                             �
	//�ExpC2 : Descricao da se�ao                                              �
	//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
	//�        sera considerada como principal para a se��o.                   �
	//�ExpA4 : Array com as Ordens do relat�rio                                �
	//�ExpL5 : Carrega campos do SX3 como celulas                              �
	//�        Default : False                                                 �
	//�ExpL6 : Carrega ordens do Sindex                                        �
	//�        Default : False                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������
	//������������������������������������������������������������������������Ŀ
	//�Criacao da celulas da secao do relatorio                                �
	//�                                                                        �
	//�TRCell():New                                                            �
	//�ExpO1 : Objeto TSection que a secao pertence                            �
	//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
	//�ExpC3 : Nome da tabela de referencia da celula                          �
	//�ExpC4 : Titulo da celula                                                �
	//�        Default : X3Titulo()                                            �
	//�ExpC5 : Picture                                                         �
	//�        Default : X3_PICTURE                                            �
	//�ExpC6 : Tamanho                                                         �
	//�        Default : X3_TAMANHO                                            �
	//�ExpL7 : Informe se o tamanho esta em pixel                              �
	//�        Default : False                                                 �
	//�ExpB8 : Bloco de c�digo para impressao.                                 �
	//�        Default : ExpC2                                                 �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oSection1:= TRSection():New(oReport,STR0064,{"SC1","SB1","SB2"},/*aOrdem*/)
	oSection1:SetHeaderPage()
	// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

	TRCell():New(oSection1,"C1_ITEM"   ,"SC1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSC1)->C1_ITEM }/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C1_PRODUTO","SC1",/*Titulo*/,/*Picture*/,TamSX3("C1_PRODUTO")[1]+10,/*lPixel*/,{|| (cAliasSC1)->C1_PRODUTO }/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DESCPROD"  ,"   ",STR0049,/*Picture*/,30,/*lPixel*/, {|| cDescPro })
	TRCell():New(oSection1,"B2_QATU"   ,"SB2",/*Titulo*/    ,PesqPict("SB2","B2_QATU" ,12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1EMIN"    ,"   ",STR0050       ,PesqPict("SB1","B1_EMIN" ,12),/*Tamanho*/,/*lPixel*/,{|| RetFldProd(SB1->B1_COD,"B1_EMIN") })
	TRCell():New(oSection1,"SALDOSC1"  ,"   ",STR0051       ,PesqPict("SC1","C1_QUANT",12),/*Tamanho*/,/*lPixel*/,{|| (cAliasSC1)->C1_QUANT-(cAliasSC1)->C1_QUJE })
	TRCell():New(oSection1,"C1_UM"     ,"SC1",/*Titulo*/    ,PesqPict("SC1","C1_UM"),/*Tamanho*/,/*lPixel*/,{|| (cAliasSC1)->C1_UM }/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"C1_LOCAL"  ,"SC1",/*Titulo*/    ,PesqPict("SC1","C1_LOCAL"),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_QE"     ,"SB1",/*Titulo*/    ,PesqPict("SB1","B1_QE",09),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_UPRC"   ,"SB1",/*Titulo*/    ,PesqPict("SB1","B1_UPRC",12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"LEADTIME"  ,"   ",STR0052,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)})
	TRCell():New(oSection1,"DTNECESS"  ,"   ",STR0053,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF) })
	//TRCell():New(oSection1,"DTFORCOMP" ,"   ",STR0054,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||SomaPrazo(If(Empty((cAliasSC1)->C1_DATPRF),(cAliasSC1)->C1_EMISSAO,(cAliasSC1)->C1_DATPRF), -CalcPrazo((cAliasSC1)->C1_PRODUTO,(cAliasSC1)->C1_QUANT)) })
	oSection1:Cell("DESCPROD"):SetLineBreak(.T.) 

	oSection2:= TRSection():New(oSection1,STR0065,{"SD4","SC2"},/*aOrdem*/)

	TRCell():New(oSection2,"D4_OP"     ,"SD4",STR0055,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"C2_PRODUTO","SC2",STR0056,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"D4_DATA"   ,"SD4",STR0057,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"D4_QUANT"  ,"SD4",STR0058,PesqPict("SD4","D4_QUANT",12),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection3:= TRSection():New(oSection2,STR0066,{"SB3"},/*aOrdem*/)

	TRCell():New(oSection3,"MES01"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q01",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES02"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q02",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES03"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q03",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES04"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q04",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES05"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q05",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES06"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q06",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES07"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q07",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES08"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q08",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES09"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q09",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES10"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q10",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES11"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q11",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"MES12"		,"   ",/*Titulo*/,PesqPict("SB3","B3_Q12",11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B3_MEDIA"	,"SB3", ,PesqPict("SB3","B3_MEDIA",8),/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"B3_CLASSE"	,"SB3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection4:= TRSection():New(oSection3,STR0067,{"SC7","SA2"},/*aOrdem*/)
	TRCell():New(oSection4,"C7_NUM"    ,"SC7",STR0043,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cNumPc})
	TRCell():New(oSection4,"C7_ITEM"   ,"SC7",STR0074,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cItemPc})
	TRCell():New(oSection4,"C7_FORNECE","SC7",STR0075,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cFornec})
	TRCell():New(oSection4,"C7_LOJA"   ,"SC7",STR0076,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cLojaFor})
	TRCell():New(oSection4,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cNomeFor})
	TRCell():New(oSection4,"C7_QUANT"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_QUANT"),/*Tamanho*/,/*lPixel*/,{|| nQuant})
	TRCell():New(oSection4,"C7_UM"     ,"SC7",STR0077,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cUM})
	TRCell():New(oSection4,"C7_PRECO"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_PRECO"),/*Tamanho*/,/*lPixel*/,{|| nPreco})
	TRCell():New(oSection4,"C7_TOTAL"  ,"SC7",/*Titulo*/,PesqPict("SC7","C7_TOTAL"),/*Tamanho*/,/*lPixel*/,{|| nTotal})
	TRCell():New(oSection4,"C7_EMISSAO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dEmissao})
	TRCell():New(oSection4,"C7_DATPRF" ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dDATPRF})
	TRCell():New(oSection4,"PRAZO"     ,"   ",STR0059,"999",/*Tamanho*/,/*lPixel*/,{|| dPrazo })
	TRCell():New(oSection4,"C7_COND"   ,"SC7",STR0078/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cCond})
	TRCell():New(oSection4,"C7_QUJE"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nQuje})
	TRCell():New(oSection4,"SALDORES"  ,"   ",STR0060,PesqPict("SC7","C7_QUJE"),/*Tamanho*/,/*lPixel*/,{||nSaldores })
	TRCell():New(oSection4,"RESIDUO"   ,"   ",STR0061,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||cResiduo})


	If mv_par10 == 1	
		oSection5:= TRSection():New(oSection4,STR0068,{"SA5","SA2","SC1"},/*aOrdem*/)
		TRCell():New(oSection5,"A5_FORNECE","SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A5_LOJA"   ,"SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_TEL"    ,"SA2",/*Titulo*/,/*Picture*/,41,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_FAX"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_MUN"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_EST"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_RISCO"  ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A5_CODPRF" ,"SA5",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
	Else	
		oSection5:= TRSection():New(oSection4,STR0069,{"SAD","SA2","SC1"},/*aOrdem*/)
		TRCell():New(oSection5,"AD_FORNECE","SAD",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"AD_LOJA"   ,"SAD",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_TEL"    ,"SA2",/*Titulo*/,/*Picture*/,41,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_CONTATO","SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_FAX"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_ULTCOM" ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_MUN"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_EST"    ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection5,"A2_RISCO"  ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
	EndIf

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSC1,nReg)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local oSection1 := oReport:Section(1) 
	Local oSection2 := oReport:Section(1):Section(1) 
	Local oSection3 := oReport:Section(1):Section(1):Section(1) 
	Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1) 
	Local oSection5 := oReport:Section(1):Section(1):Section(1):Section(1):Section(1) 
	Local aMeses	:= {STR0005,STR0006,STR0007,STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016}		//"Jan"###"Fev"###"Mar"###"Abr"###"Mai"###"Jun"###"Jul"###"Ago"###"Set"###"Out"###"Nov"###"Dez"
	Local aOrdem    := {}
	Local aSavRec   := {}
	Local cMes      := ""
	Local cCampos   := ""
	Local cEmissao  := ""
	Local cGrupo    := ""
	Local nX        := 0
	Local nY        := 0
	Local nRecnoSD4 := 0
	Local nAno      := Year(dDataBase)
	Local nMes      := Month(dDataBase)
	Local nPrinted  := 0
	Local nVlrMax   := 0
	Local cLmtSol   := ""
	Local cQuery := ""
	Local cWhere := ""
	Local lQuery := .T.

	nVlrMax := val(Replicate('9',TamSX3("C1_QTDREEM")[1]))//Valor maximo para reemissao


	Private cDescPro := ""     
	Private cNumPc   := ""  
	Private cItemPc  := ""
	Private cFornec  := ""
	Private cLojaFor := ""
	Private cNomeFor := ""
	Private cUM      := ""   
	Private cCond    := ""
	Private cResiduo := ""
	Private nQuant   := 0
	Private nPreco   := 0
	Private nTotal   := 0
	Private nQuje    := 0 
	Private nSaldoRes:= 0  
	Private dEmissao := ctod("")
	Private dDATPRF  := ctod("")     
	Private dPrazo   := ctod("")

	dbSelectArea("SC1")
	dbSetOrder(1)

	If lAuto
		dbGoto(nReg)
		mv_par01  := SC1->C1_NUM
		mv_par02  := SC1->C1_NUM
		mv_par03  := 1
		mv_par04  := SC1->C1_EMISSAO
		mv_par05  := SC1->C1_EMISSAO
		mv_par06  := "  "
		mv_par07  := "ZZ"
		mv_par09  := 1
		mv_par13  := 3
	Else

		If _lAutoStk

			_cQuery2 := " SELECT DISTINCT 
			_cQuery2 += " C1_FILIAL,
			_cQuery2 += " C1_NUM,
			_cQuery2 += " C1_ITEM,
			_cQuery2 += " C1_PRODUTO,
			_cQuery2 += " C1_UM,
			_cQuery2 += " C1_QUANT,
			_cQuery2 += " C1_SEGUM,
			_cQuery2 += " C1_MOTIVO,
			_cQuery2 += " C1_COMPSTK,
			_cQuery2 += " C1_QTSEGUM,
			_cQuery2 += " C1_DATPRF,
			_cQuery2 += " C1_LOCAL,
			_cQuery2 += " C1_OBS,
			_cQuery2 += " C1_OP,
			_cQuery2 += " C1_CC,
			_cQuery2 += " C1_EMISSAO,
			_cQuery2 += " C1_CONTA,
			_cQuery2 += " C1_ITEMCTA,
			_cQuery2 += " C1_COTACAO,
			_cQuery2 += " C1_DESCRI,
			_cQuery2 += " C1_FORNECE,
			_cQuery2 += " C1_LOJA,
			_cQuery2 += " C1_SOLICIT,
			_cQuery2 += " C1_PEDIDO,
			_cQuery2 += " C1_QUJE,
			_cQuery2 += " C1_TX,
			_cQuery2 += " C1_OK,
			_cQuery2 += " C1_ITEMPED,
			_cQuery2 += " C1_IMPORT,
			_cQuery2 += " C1_UNIDREQ,
			_cQuery2 += " C1_CODCOMP,
			_cQuery2 += " C1_CLASS,
			_cQuery2 += " C1_FABR,
			_cQuery2 += " C1_IDENT,
			_cQuery2 += " C1_NUM_SI,
			_cQuery2 += " C1_OS,
			_cQuery2 += " C1_FABRLOJ,
			_cQuery2 += " C1_TPOP,
			_cQuery2 += " C1_GRUPCOM,
			_cQuery2 += " C1_USER,
			_cQuery2 += " C1_QUJE2,
			_cQuery2 += " C1_ORIGEM,
			_cQuery2 += " C1_CLVL,
			_cQuery2 += " C1_PROJETO,
			_cQuery2 += " C1_SEQMRP,
			_cQuery2 += " C1_FILENT,
			_cQuery2 += " C1_VUNIT,
			_cQuery2 += " C1_RESIDUO,
			_cQuery2 += " C1_QTDORIG,
			_cQuery2 += " C1_CONDPAG,
			_cQuery2 += " C1_CODORCA,
			_cQuery2 += " C1_TIPOEMP,
			_cQuery2 += " C1_PRECO,
			_cQuery2 += " C1_TOTAL,
			_cQuery2 += " C1_ESPEMP,
			_cQuery2 += " C1_TIPO,
			_cQuery2 += " C1_APROV,
			_cQuery2 += " C1_GERACTR,
			_cQuery2 += " C1_MOEDA,
			_cQuery2 += " C1_QTDREEM,
			_cQuery2 += " C1_SIGLA,
			_cQuery2 += " C1_ITEMGRD,
			_cQuery2 += " C1_NOMAPRO,
			_cQuery2 += " C1_GRADE,
			_cQuery2 += " C1_FABRICA,
			_cQuery2 += " C1_LOJFABR,
			_cQuery2 += " C1_FLAGGCT,
			_cQuery2 += " C1_ESTOQUE,
			_cQuery2 += " C1_PROGRAM,
			_cQuery2 += " C1_TPSC,
			_cQuery2 += " C1_MODAL,
			_cQuery2 += " C1_TPMOD,
			_cQuery2 += " C1_CODED,
			_cQuery2 += " C1_NUMPR,
			_cQuery2 += " C1_ORCAM,
			_cQuery2 += " C1_ACCNUM,
			_cQuery2 += " C1_ACCPROC,
			_cQuery2 += " C1_ACCITEM,
			_cQuery2 += " C1_USRCODE,
			_cQuery2 += " C1_RATEIO,
			_cQuery2 += " C1_XEMAIL,
			_cQuery2 += " C1_XPRC,
			_cQuery2 += " C1_ZAPROV,
			_cQuery2 += " C1_ZSTATUS,
			_cQuery2 += " C1_ZMARKBR,
			_cQuery2 += " C1_ZMOTREJ,
			_cQuery2 += " C1_ZDTAPRO,
			_cQuery2 += " C1_ZHRAPRO,
			_cQuery2 += " C1_ZDTCOMP,
			_cQuery2 += " C1_ZHRCOMP,
			_cQuery2 += " C1_REVISAO,
			_cQuery2 += " C1_IDAPS,
			_cQuery2 += " C1_COMPRAC,
			_cQuery2 += " C1_FISCORI,
			_cQuery2 += " C1_ITSCORI,
			_cQuery2 += " C1_SCORI,
			_cQuery2 += " C1_PRDREF,
			_cQuery2 += " C1_TIPCOM,
			_cQuery2 += " C1_PEDRES,
			_cQuery2 += " C1_NRBPIMS,
			_cQuery2 += " C1.R_E_C_N_O_ SC1RECNO
			_cQuery2 += " FROM "+RetSqlName("SCR")+" CR
			_cQuery2 += " LEFT JOIN "+RetSqlName("SC7")+" C7
			_cQuery2 += " ON C7_FILIAL=CR_FILIAL AND C7_NUM=CR_NUM
			_cQuery2 += " LEFT JOIN "+RetSqlName("SC1")+" C1
			_cQuery2 += " ON C1_FILIAL=C7_FILIAL AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC
			_cQuery2 += " WHERE CR.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' ' AND C1.D_E_L_E_T_=' ' 
			_cQuery2 += " AND CR_FILIAL='"+SCR->CR_FILIAL+"' AND CR_NUM='"+SCR->CR_NUM+"'
			_cQuery2 += " ORDER BY C1_NUM, C1_ITEM

			If !Empty(Select(cAliasSC1))
				DbSelectArea(cAliasSC1)
				(cAliasSC1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),cAliasSC1,.T.,.T.)

			dbSelectArea(cAliasSC1)
			(cAliasSC1)->(dbGoTop())

		Else

			MakeSqlExpr(oReport:uParam)

			oReport:Section(1):BeginQuery()	

			cWhere := "%" 
			If mv_par03 == 2
				cWhere += " C1_QUANT <> C1_QUJE AND "
			EndIf
			cWhere += "%" 

			BeginSql Alias cAliasSC1

				SELECT SC1.*, SC1.R_E_C_N_O_ SC1RECNO
				FROM %table:SC1% SC1
				WHERE C1_FILIAL  = %xFilial:SC1% AND 
				C1_NUM      >= %Exp:mv_par01% AND 
				C1_NUM      <= %Exp:mv_par02% AND
				C1_EMISSAO  >= %Exp:Dtos(mv_par04)% AND 
				C1_EMISSAO  <= %Exp:Dtos(mv_par05)% AND 
				C1_ITEM     >= %Exp:mv_par06% AND 
				C1_ITEM     <= %Exp:mv_par07% AND          
				%Exp:cWhere%	    
				SC1.%NotDel% 
				ORDER BY %Order:SC1% 
			EndSql
			
			oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

		EndIf

	EndIf

	TRPosition():New(oSection1,"SB1",1,{ || xFilial("SB1") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SB2",1,{ || xFilial("SB2") + (cAliasSC1)->C1_PRODUTO + (cAliasSC1)->C1_LOCAL })
	TRPosition():New(oSection1,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection3,"SB3",1,{ || xFilial("SB3") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SD4",1,{ || xFilial("SD4") + (cAliasSC1)->C1_PRODUTO })
	TRPosition():New(oSection1,"SC7",1,{ || xFilial("SC7") + (cAliasSC1)->C1_NUM + (cAliasSC1)->C1_ITEM })
	TRPosition():New(oSection2,"SC2",1,{ || xFilial("SC2") + SD4->D4_OP })
	TRPosition():New(oSection4,"SA2",1,{ || xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA })

	//�����������������������������������������������������������������������������������������Ŀ
	//� Executa o CodeBlock com o PrintLine da Sessao 1 toda vez que rodar o oSection1:Init()   �
	//�������������������������������������������������������������������������������������������
	oReport:onPageBreak( { || oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine(), oReport:ThinLine() })

	oReport:SetMeter(SC1->(LastRec()))
	dbSelectArea(cAliasSC1) 

	If _lAutoStk

		mv_par01  := "000000"
		mv_par02  := "999999"
		mv_par03  := 1
		mv_par04  := CTOD("01/01/2017")
		mv_par05  := CTOD("31/12/2049")
		mv_par06  := "0001"
		mv_par07  := "9999"
		mv_par08  := ""
		mv_par09  := 2
		mv_par10  := 1
		mv_par11  := 5
		mv_par12  := 10
		mv_par13  := 3

	EndIf              

	While !oReport:Cancel() .And. !(cAliasSC1)->(Eof()) .And. (cAliasSC1)->C1_FILIAL == xFilial("SC1") .And. ;
	(cAliasSC1)->C1_NUM >= mv_par01 .And. (cAliasSC1)->C1_NUM <= mv_par02

		oReport:IncMeter()

		If oReport:Cancel()
			Exit
		EndIf

		//������������������������������������������������������������Ŀ
		//� Filtra Tipo de OPs Firmes ou Previstas                     �
		//��������������������������������������������������������������
		If !MtrAValOP(mv_par13,"SC1",cAliasSC1 )
			dbSkip()
			Loop
		EndIf

		//������������������������������������������������������������Ŀ
		//� Obtem a string do titulo conforme a SC impressa.           �
		//� "Solicitacao de Compra  C.Custo :   a.Emissao"	           �
		//��������������������������������������������������������������
		cEmissao := IIf((cAliasSC1)->C1_QTDREEM > 0 , Str(If((cAliasSC1)->C1_QTDREEM < nVlrMax,(cAliasSC1)->C1_QTDREEM + 1,(cAliasSC1)->C1_QTDREEM) ,2) + STR0045 , " " )//"a.Emissao 
		oReport:SetTitle(STR0002+"     "+STR0043+" "+Substr((cAliasSC1)->C1_NUM,1,6)+" "+STR0018+" "+(cAliasSC1)->C1_CC+Space(20)+cEmissao )

		//������������������������������������������������������������Ŀ
		//� Inicializa o descricao do Produto conf. parametro digitado.�
		//��������������������������������������������������������������
		SB1->(dbSetOrder(1))
		SB1->(dbSeek( xFilial("SB1") + (cAliasSC1)->C1_PRODUTO ))
		cDescPro := SB1->B1_XDESEXD
		cGrupo   := SB1->B1_GRUPO  

		If AllTrim(mv_par08) == "C1_DESCRI"    // Impressao da Descricao do produto do arquivo de Solicitacao SC1.
			cDescPro := (cAliasSC1)->C1_DESCRI           
		ElseIf AllTrim(mv_par08) == "B5_CEME"  // Descricao cientifica do Produto.
			SB5->(dbSetOrder(1))
			If SB5->(dbSeek( xFilial("SB5") + (cAliasSC1)->C1_PRODUTO ))
				cDescPro := SB5->B5_CEME
			EndIf
		EndIf        


		//��������������������������������������������������������������Ŀ
		//� Dispara o codeBrock do OnPageBreak com o PrintLine           �
		//����������������������������������������������������������������
		oSection1:Init()

		//��������������������������������������������������������������Ŀ
		//� Impressao das observacoes da solicitacao (caso exista)       �
		//����������������������������������������������������������������
		If !Empty((cAliasSC1)->C1_OBS)
			oReport:PrintText(STR0019,,oSection1:Cell("C1_ITEM"):ColPos()) // "OBSERVACOES:"

			For nX := 1 To 258 Step 129
				oReport:PrintText(Substr((cAliasSC1)->C1_OBS,nX,129),,oSection1:Cell("C1_ITEM"):ColPos()) // "OBSERVACOES:"
				If Empty(Substr((cAliasSC1)->C1_OBS,nX+129,129))
					Exit
				Endif
			Next nX

			oReport:ThinLine()

		Endif

		//��������������������������������������������������������������Ŀ
		//� Impressao da requisicoes empenhadas                          �
		//����������������������������������������������������������������
		If mv_par09 == 1
			oReport:SkipLine() 
			oReport:PrintText(STR0020,,oSection1:Cell("C1_ITEM"):ColPos()) //"REQUISICOES EMPENHADAS:"

			dbSelectArea("SD4")
			If !Eof()

				oSection2:Init()

				While !Eof() .And. SD4->D4_FILIAL + SD4->D4_COD == (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO

					nRecnoSD4 := SD4->(Recno())
					If SD4->D4_QUANT <> 0
						oSection2:PrintLine()		    
					EndIf   
					SD4->(dbGoTo(nRecnoSD4))
					SD4->(dbSkip())

				EndDo

				oSection2:Finish()				

			Else
				oReport:PrintText(STR0021,,oSection1:Cell("C1_ITEM"):ColPos())//"Nao existem requisicoes empenhadas deste item."
			EndIf

			oReport:SkipLine() 
			oReport:ThinLine()

		EndIf

		//��������������������������������������������������������������Ŀ
		//� Impressao dos Consumos nos ultimos 12 meses                  �
		//����������������������������������������������������������������
		oReport:SkipLine() 
		oReport:PrintText(STR0024,,oSection1:Cell("C1_ITEM"):ColPos())	//"CONSUMO DOS ULTIMOS 12 MESES:"

		dbSelectArea("SB3")
		If !Eof()

			oSection3:Init()

			nAno   := Year(dDataBase)
			nMes   := Month(dDataBase)
			aOrdem := {}
			nY     := 1

			For nX := nMes To 1 Step -1    
				oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
				AADD(aOrdem,nX)
				nY++
			Next nX

			nAno--                                 

			For nX := 12 To nMes+1 Step -1
				oSection3:Cell("MES"+StrZero(nY,2)):SetTitle("|  "+aMeses[nX]+"/"+StrZero(nAno,4))
				AADD(aOrdem,nX)
				nY++
			Next nX

			For nX := 1 To Len(aOrdem)
				cMes    := StrZero(aOrdem[nX],2)
				cCampos := "SB3->B3_Q"+cMes
				oSection3:Cell("MES"+StrZero(nX,2)):SetValue(&cCampos)
			Next nX

			oSection3:PrintLine()		    
			oSection3:Finish()				

		Else 
			oReport:PrintText(STR0025,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existe registro de consumo anterior deste item."
		EndIf

		//��������������������������������������������������������������Ŀ
		//�Impressao dos ultimos pedidos                                 �
		//����������������������������������������������������������������
		oReport:SkipLine() 
		oReport:ThinLine()
		oReport:SkipLine() 
		oReport:PrintText(STR0027,,oSection1:Cell("C1_ITEM"):ColPos()) //"ULTIMOS PEDIDOS:"

		dbSelectArea("SC7")
		dbSetOrder(4)
		Set SoftSeek On
		dbSeek(xFilial("SC7")+(cAliasSC1)->C1_PRODUTO+"z")
		Set SoftSeek Off
		dbSkip(-1)
		If (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO
			nPrinted := 0

			oSection4:Init()

			While !Bof() .And. (cAliasSC1)->C1_FILIAL + (cAliasSC1)->C1_PRODUTO == SC7->C7_FILIAL + SC7->C7_PRODUTO			
				cNumPc   := SC7->C7_NUM
				cItemPc  := SC7->C7_ITEM
				cFornec  := SC7->C7_FORNECE
				cLojaFor := SC7->C7_LOJA
				cCond    := SC7->C7_COND
				cUM      := SC7->C7_UM 	  
				cResiduo := IIf(Empty(SC7->C7_RESIDUO),STR0062,STR0063) 	
				nQuant   := SC7->C7_QUANT
				nPreco   := SC7->C7_PRECO
				nTotal   := SC7->C7_TOTAL
				dEmissao := SC7->C7_EMISSAO 
				dDATPRF  := SC7->C7_DATPRF   
				dPrazo   := SC7->C7_DATPRF - SC7->C7_EMISSAO  	
				nQuje    := SC7->C7_QUJE          
				nSaldoRes:= Iif(Empty(SC7->C7_RESIDUO),SC7->C7_QUANT - SC7->C7_QUJE,0)                                                               

				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
				cNomeFor := SA2->A2_NOME     

				nPrinted++
				If nPrinted > mv_par11
					Exit
				EndIf

				oSection4:PrintLine()

				dbSkip(-1)
			EndDo

			oSection4:Finish()

		Else
			oReport:PrintText(STR0028,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem pedidos cadastrados para este item."
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Imprime os fornecedores indicados para este produto          �
		//����������������������������������������������������������������
		oReport:SkipLine() 
		oReport:ThinLine()
		oReport:SkipLine() 
		oReport:PrintText(STR0030,,oSection1:Cell("C1_ITEM"):ColPos()) //"FORNECEDORES:"

		If mv_par10 == 1                                                  

			dbSelectArea("SA5")
			dbSetOrder(2)
			dbSeek(xFilial("SA5")+(cAliasSC1)->C1_PRODUTO)

			If !Eof()
				nPrinted := 0
				oSection5:Init()

				While !Eof() .And. xFilial("SA5") + (cAliasSC1)->C1_PRODUTO == SA5->A5_FILIAL + SA5->A5_PRODUTO
					If SA2->(dbSeek(xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA))
						nPrinted++
						If nPrinted > mv_par12
							Exit
						EndIf
						oSection5:PrintLine()
					EndIf    

					dbSkip()
				EndDo
				oSection5:Finish()
			Else
				oReport:PrintText(STR0031,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem fornecedores cadastrados para este item."
			EndIf
		Else                                                                            
			dbSelectArea("SAD")
			dbSetOrder(2)
			dbSeek(xFilial()+cGrupo)

			If !Eof()
				nPrinted := 0
				oSection5:Init()
				While !Eof() .And. SAD->AD_FILIAL + SAD->AD_GRUPO == xFilial("SAD") + cGrupo
					If SA2->(dbSeek(xFilial("SA2")+SAD->AD_FORNECE+SAD->AD_LOJA))
						nPrinted++
						If nPrinted > mv_par12
							Exit
						EndIf
						oSection5:PrintLine()
					EndIf    
					dbSkip()
				EndDo
			Else 
				oReport:PrintText(STR0031,,oSection1:Cell("C1_ITEM"):ColPos())	//"Nao existem fornecedores cadastrados para este item."
			EndIf
			oSection5:Finish()
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Impressao do codigo alternativo                              �
		//����������������������������������������������������������������
		oReport:SkipLine() 
		oReport:ThinLine()
		oReport:SkipLine() 

		If !Empty(SB1->B1_ALTER)
			SB2->(dbSeek(xFilial("SB2") + SB1->B1_ALTER + (cAliasSC1)->C1_LOCAL ))
			oReport:PrintText(STR0034+" "+SB1->B1_ALTER+" "+STR0035+" "+Transform(SB2->B2_QATU,PesqPict("SB2","B2_QATU",12)+" "+SC1->C1_UM ),,oSection1:Cell("C1_ITEM"):ColPos()) //"Codigo Alternativo : " "Saldo do Alternativo :"
		Else
			oReport:PrintText(STR0034 + " " + STR0036,,oSection1:Cell("C1_ITEM"):ColPos()) //"Codigo Alternativo : " ### "Nao ha'"
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Impressao do quadro de concorrencias                         �
		//����������������������������������������������������������������
		dbSelectArea(cAliasSC1)

		oReport:SkipLine() 
		oReport:ThinLine()
		oReport:SkipLine() 

		oReport:SkipLine() 
		oReport:ThinLine()
		oReport:SkipLine() 

		//oReport:PrintText(STR0037,,oSection1:Cell("C1_ITEM"):ColPos()) //"|  C O N C O R R E N C I A S                  | ENTREGA         | OBSERVACOES                        | COND.PGTO        |  CONTATO         |QUANTIDADE      |  PRECO UNITARIO             | IPI     |     VALOR            |"
		oReport:PrintText("Concorr�ncias",,oSection1:Cell("C1_ITEM"):ColPos())
		//oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
		//For nX :=1 To 4
		//oReport:PrintText("|                                             |                 |                                    |                  |                  |                |                             |         |                      |",,oSection1:Cell("C1_ITEM"):ColPos())
		//oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
		//Next nX

		oReport:PrintText(;
		PADR("Nome",TamSx3("A2_NOME")[1]," ")+" | "+;
		PADR("Prazo",TamSx3("C8_DATPRF")[1]," ")+" | "+;
		PADR("Cond.",TamSx3("C8_COND")[1]," ")+" | "+;
		PADR("Pre�o",TamSx3("C8_PRECO")[1]," ")+" | "+;
		PADR("Ipi",TamSx3("C8_VALIPI")[1]," ")+" | "+;
		PADR("Icms",TamSx3("C8_VALICM")[1]," ")+" | ";
		,,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText(;
		PADR("",TamSx3("A2_NOME")[1],"-")+" | "+;
		PADR("",TamSx3("C8_DATPRF")[1],"-")+" | "+;
		PADR("",TamSx3("C8_COND")[1],"-")+" | "+;
		PADR("",TamSx3("C8_PRECO")[1],"-")+" | "+;
		PADR("",TamSx3("C8_VALIPI")[1],"-")+" | "+;
		PADR("",TamSx3("C8_VALICM")[1],"-")+" | ";
		,,oSection1:Cell("C1_ITEM"):ColPos())
		//For nX :=1 To 4
		//oReport:PrintText("|                                             |                 |                                    |                  |                  |                |                             |         |                      |",,oSection1:Cell("C1_ITEM"):ColPos())
		//oReport:PrintText("|---------------------------------------------|-----------------|------------------------------------|------------------|------------------|----------------|-----------------------------|---------|----------------------|",,oSection1:Cell("C1_ITEM"):ColPos())
		//Next nX

		_cQuery1 := " SELECT A2_NOME, C8_DATPRF, C8_COND, C8_PRECO, C8_VALIPI, C8_VALICM
		_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
		_cQuery1 += " LEFT JOIN "+RetSqlName("SA2")+" A2
		_cQuery1 += " ON A2_COD=C8_FORNECE AND A2_LOJA=C8_LOJA
		_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND C8_FILIAL='"+(cAliasSC1)->C1_FILIAL+"'
		_cQuery1 += " AND C8_NUM='"+(cAliasSC1)->C1_COTACAO+"' AND C8_PRODUTO='"+(cAliasSC1)->C1_PRODUTO+"' AND C8_PRECO>0

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())

			oReport:PrintText(;
			PADR((_cAlias1)->A2_NOME,TamSx3("A2_NOME")[1])+" | "+;
			PADR(DTOC(STOD((_cAlias1)->C8_DATPRF)),TamSx3("C8_DATPRF")[1])+" | "+;
			PADR((_cAlias1)->C8_COND,TamSx3("C8_COND")[1])+" | "+;
			PADR(CVALTOCHAR((_cAlias1)->C8_PRECO),TamSx3("C8_PRECO")[1])+" | "+;
			PADR(CVALTOCHAR((_cAlias1)->C8_VALIPI),TamSx3("C8_VALIPI")[1])+" | "+;
			PADR(CVALTOCHAR((_cAlias1)->C8_VALICM),TamSx3("C8_VALICM")[1])+" | ";
			,,oSection1:Cell("C1_ITEM"):ColPos())

			(_cAlias1)->(DbSkip())
		EndDo

		oReport:SkipLine() 
		oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText(STR0038,,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|   ------------------------------------------------------------------------------------------------------   |   -------------------------------------------------------------------------------------------------------   |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                "+PADC(AllTrim((cAliasSC1)->C1_SOLICIT),15)+"                                                                             |                    "+ Padc(AllTrim((cAliasSC1)->C1_NOMAPRO),15)+ "                                                                          |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("|                                                                                                            |                                                                                                             |",,oSection1:Cell("C1_ITEM"):ColPos())
		oReport:PrintText("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",,oSection1:Cell("C1_ITEM"):ColPos())

		//�����������������������������������������������������������Ŀ
		//�Guarda o Recno para a gravacao do numero de reemissao da SC�
		//�������������������������������������������������������������	
		If Ascan(aSavRec,IIf(lQuery .And. !lAuto ,(cAliasSC1)->SC1RECNO,Recno())) == 0	
			AADD(aSavRec,IIf(lQuery .And. !lAuto ,(cAliasSC1)->SC1RECNO,Recno()))
		Endif

		dbSelectArea(cAliasSC1)
		dbSkip()
		oSection1:Finish()
		oReport:EndPage() 
	EndDo

	//���������������������������������������������������������������Ŀ
	//�Grava o numero de reemissao da SC.                             |
	//�����������������������������������������������������������������
	dbSelectArea("SC1")
	If Len(aSavRec) > 0 
		For nX:=1 to Len(aSavRec)
			dbGoto(aSavRec[nX])
			If C1_QTDREEM < nVlrMax
				RecLock("SC1",.F.)  //Atualizacao do flag de Impressao
				Replace C1_QTDREEM With (C1_QTDREEM+1)
				MsUnLock()
			Else
				cLmtSol += SC1->C1_NUM + ","
			EndIf
		Next nX
	EndIf

	If !Empty(cLmtSol)
		Aviso(STR0073,STR0070 + "'" + Alltrim(str(nVlrMax)) + "'" + STR0071 + SubStr(cLmtSol,1,len(cLmtSol)-1) + STR0072,{"OK"})
	EndIf

Return Nil
