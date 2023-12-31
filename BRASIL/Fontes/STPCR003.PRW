#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������?�������������������������Ŀ��
���Fun��o    � STPCR003 � Autor � RVG                   � Data � 23/03/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista de Faltas                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR350                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STPCR003()
Local cAliasTRB := GetNextAlias()
Local oReport

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef(cAliasTRB)
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �                                         ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR350			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(CALIASTRB)
                                        
Local aOrdem    := {"Por Produto" ,"Por Pedido"}
Local cPictQt   := PesqPict("SB2","B2_QATU")
Local nTamQt    := TamSX3('B2_QATU')[1]
Local oCabec
Local oFaltas
Private cPerg   := "STPCR00301"
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
AjustaSX1()

oReport:= TReport():New("MATR350","Lista de Faltas-Steck",cPerg, {|oReport| ReportPrint(oReport,aOrdem,cAliasTRB)},;
"O relatorio fara' a alocacao do material em estoque `as OP's "+;
" em ordem sequencial ,deixando que as faltas sejam localizadas nas ultimas OP's.")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� mv_par01     // Produto inicial                               �
//� mv_par02     // Produto final                                 �
//� mv_par03     // Considera saldo entradas em aberto            �
//� mv_par04     // Lista somente registros com saldo neg         �
//� mv_par05     // Almoxarifado de (para formacao do saldo Ini)  �
//� mv_par06     // Almoxarifado Ate(para formacao do saldo Ini)  �
//� mv_par07     // Considera OPs 1- Firmes 2- Previstas 3- Ambas �
//� mv_par08     // Apenas SCs com data limite de compra em atraso�
//� mv_par09     // Da Ordem de Producao                          �
//� mv_par10     // Ate a Ordem de Producao                       �
//� mv_par11     // Listar as OPs 1.Atendidas/N Atendidas/Ambas   �
//� mv_par12     // Qtd. Nossa Poder 3o.  1-Ignora / 2-Soma       �
//� mv_par13     // Qtd. 3o. Nosso Poder  1-Ignora / 2-Subtrai    �
//� mv_par14     // Utiliza Data                                  �
//� mv_par15     // Data de referencia                            �
//�����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

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
//��������������������������������������������������������������������������
oSection1 := TRSection():New(oReport,"Faltas de Pedido de Venda ",{},aOrdem) //"Lista de Faltas"##"Produtos"
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,'PA1_DOC'   	,cAliasTRB,"Ped.Venda",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_COD'    	,cAliasTRB,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC' 	,cAliasTRB,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'   	,cAliasTRB,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO' 	,cAliasTRB,/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PA1_QUANT' 	,cAliasTRB,"Qte Falta","@E 99999,999.99",/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B2_QATU' 	,cAliasTRB,"Sld Em Estoque","@E 99999,999.99",/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor � RVG                 � Data �05/04/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �       			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)
Local oSection1    := oReport:Section(1)
Local nOrdem       := oSection1:GetOrder()

IF nOrdem == 2
	_cExpress := "PA1.PA1_FILIAL,PA1.PA1_DOC"
ELSE
	_cExpress := "PA1.PA1_FILIAL,PA1_CODPRO,PA1.PA1_DOC"
ENDIF

lQuery 		:= .T.   

//cAliasPA1	:= GetNextAlias()

IF nOrdem == 2

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasTRB
		
		SELECT PA1.*,
		SB1.B1_COD,SB1.B1_DESC,SB1.B1_UM,SB1.B1_POSIPI,SB1.B1_GRUPO,SB1.B1_TIPO,SB2.B2_QATU
		
		FROM %table:PA1% PA1, %table:SB1% SB1, %table:SB2% SB2
		
		WHERE PA1.PA1_FILIAL = %xFilial:PA1% AND
		PA1.PA1_CODPRO >= %Exp:mv_par01% AND
		PA1.PA1_CODPRO <= %Exp:mv_par02% AND
		PA1.PA1_DOC    >= %Exp:mv_par07% AND
		PA1.PA1_DOC    <= %Exp:mv_par08% AND
		PA1.PA1_TIPO    = '1' AND
		PA1.%NotDel% AND
		SB1.B1_FILIAL = %xFilial:SB1% AND
		PA1.PA1_CODPRO = SB1.B1_COD AND
		SB1.B1_GRUPO >= %Exp:mv_par05% AND
		SB1.B1_GRUPO <= %Exp:mv_par06% AND
		SB1.B1_TIPO  >= %Exp:mv_par03% AND
		SB1.B1_TIPO  <= %Exp:mv_par04% AND
		SB1.%NotDel% AND
		SB2.B2_FILIAL = %xFilial:SB2% AND
		PA1.PA1_CODPRO = SB2.B2_COD AND
		SB1.B1_LOCPAD = SB2.B2_LOCAL AND
		SB2.%NotDel%
		
		ORDER BY PA1.PA1_FILIAL,PA1.PA1_DOC
		
	EndSql
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)	
Else

	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasTRB
		
		SELECT PA1.*,
		SB1.B1_COD,SB1.B1_DESC,SB1.B1_UM,SB1.B1_POSIPI,SB1.B1_GRUPO,SB1.B1_TIPO,SB2.B2_QATU
				
		FROM %table:PA1% PA1, %table:SB1% SB1, %table:SB2% SB2
		
		WHERE PA1.PA1_FILIAL = %xFilial:PA1% AND
		PA1.PA1_CODPRO >= %Exp:mv_par01% AND
		PA1.PA1_CODPRO <= %Exp:mv_par02% AND
		PA1.PA1_DOC    >= %Exp:mv_par07% AND
		PA1.PA1_DOC    <= %Exp:mv_par08% AND
		PA1.PA1_TIPO    = '1' AND
		PA1.%NotDel% AND
		SB1.B1_FILIAL = %xFilial:SB1% AND
		PA1.PA1_CODPRO = SB1.B1_COD AND
		SB1.B1_GRUPO >= %Exp:mv_par05% AND
		SB1.B1_GRUPO <= %Exp:mv_par06% AND
		SB1.B1_TIPO  >= %Exp:mv_par03% AND
		SB1.B1_TIPO  <= %Exp:mv_par04% AND
		SB1.%NotDel%  AND
		SB2.B2_FILIAL = %xFilial:SB2% AND
		PA1.PA1_CODPRO = SB2.B2_COD AND
		SB1.B1_LOCPAD = SB2.B2_LOCAL AND
		SB2.%NotDel%  
		
		ORDER BY PA1.PA1_FILIAL,PA1_CODPRO,PA1.PA1_DOC
		
	EndSql
	
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)	

Endif          
dbSelectArea(cAliastrb)

//��������������������������������������������������������������Ŀ
//� Titulo do relatorio                                          �
//����������������������������������������������������������������
oReport:SetTitle(oReport:Title()+IIf(nOrdem == 1," - ("+AllTrim("Por Produto          ")+")"," - ("+AllTrim("Por Pedido de Venda")+")"))

//oReport:SetMeter(&("cAliastrb")->(LastRec()))

oReport:Section(1):Print()

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor �                                         ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Ajusta grupo de pergunta no SX1                             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �MATR350			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()
/* Removido - 18/05/2023 - N�o executa mais Recklock na X1 - Criar/alterar perguntas no configurador
Local aArea	:= GetArea()

DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Do Produto"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Produto"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Tipo de"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Tipo ate"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_DEF01   := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Grupo de "
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SBM"
	MsUnLock()
EndIf


If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Grupo ate "
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SBM"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Do P.Venda"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC5"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"08",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Ate o P.venda "
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC5"
	MsUnLock()
EndIf*/

Return
