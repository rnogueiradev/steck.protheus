#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � STPCR004 � Autor � RVG                   � Data � 22/04/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pedidos x Estoque Disponivel Steck                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
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

User Function STPCR006()

Local oReport

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef()
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �13/06/05  ���
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
Static Function ReportDef()

Local aOrdem    := {}
Local cPictQt   := PesqPict("SB2","B2_QATU")
Local nTamQt    := TamSX3('B2_QATU')[1]
Local oCabec
Local oFaltas
Local cAliasTRB := GetNextAlias()

Private cPerg   := "STPCR00504"
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

oReport:= TReport():New("STPCR005","Lista de Pedidos a Faturar Steck",cPerg, {|oReport| ReportPrint(oReport, ,cAliasTRB)},;
"O relatorio ir� listar saldos Pedidos a Faturar STECK ")

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
 
cMes	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2)+;
	    	"+B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2)+;
   	 	    "+B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)
       

oSection1 := TRSection():New(oReport,"Pedidos a Faturar",{},aOrdem) //"Lista de Faltas"##"Produtos"
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,'Filial'    	,cAliasTRB,/*Titulo*/,/*Picture*/,04,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Pedido'    	,cAliasTRB,/*Titulo*/,/*Picture*/,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Prod' 		,cAliasTRB,"Produto",/*Picture*/,15,/*lPixel*/,  )
TRCell():New(oSection1,'Descri' 	,cAliasTRB,"Descricao",/*Picture*/,45,/*lPixel*/,  )
TRCell():New(oSection1,'Cliente' 	,cAliasTRB,/*Titulo*/,/*Picture*/,25,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SLD_ATU'	,cAliasTRB,"Qtd a Faturar"  ,"@E 999999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'VLR_ATU'	,cAliasTRB,"Vlr a Faturar"  ,"@E 999999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DT_VDA'		,cAliasTRB,"Data Vendas"    ,,8,/*lPixel*/,{|| _xdt1  })
TRCell():New(oSection1,'DT_FAB'  	,cAliasTRB,"Data Fabrica"   ,,8,/*lPixel*/,{|| _xdt2  })
TRCell():New(oSection1,'Res_PV'		,cAliasTRB,"Reserva PV"   	,"@E 999999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Res_OUT'	,cAliasTRB,"Reserva Geral"  ,"@E 999999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Flt_PV'		,cAliasTRB,"Falta PV"   	,"@E 999999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'Tipo' 		,cAliasTRB,"Tipo Fat" 	 	,"@!",3,/*lPixel*/,{|| _xTipofat } )
TRCell():New(oSection1,'Credito'   	,cAliasTRB,"Credito"		,"@!",3,/*lPixel*/,{|| _xCredito } )
TRCell():New(oSection1,'Soma'   	,cAliasTRB,"Total do PV"			,"@!",3,/*lPixel*/,{|| _xSoma } )
TRCell():New(oSection1,'Qtd_est'   	,cAliasTRB,"Saldo Estoque"			,"@!",3,/*lPixel*/,  )

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

_cWhere := "% C6_FILIAL = '"+xfilial("SC6")+"' %"

If !EMPTY(MV_PAR06)                
 
   _cWhere := "% C6_OPER = '"+MV_PAR06+"' %" 
  
Endif

oReport:Section(1):BeginQuery()                     

BeginSql Alias cAliasTRB
	
	SELECT C6_NUM||'-'||C6_ITEM AS PEDIDO,
	       C6_PRODUTO AS PROD,  
	       B1_DESC AS DESCRI,
	       A1_COD||'-'||A1_LOJA||'-'||A1_NREDUZ AS CLIENTE,
	       C6_QTDVEN-(C6_QTDENT) AS SLD_ATU,
	       (C6_QTDVEN-(C6_QTDENT ))*C6_PRCVEN AS VLR_ATU,
           C6_ENTRE1 AS DT_VDA,
	       C5_XDTFABR AS DT_FAB,
 	       (SELECT SUM(PA2_QUANT) FROM %table:PA2% PA2PV WHERE  PA2PV.PA2_CODPRO = SC6.C6_PRODUTO AND TRIM(PA2PV.PA2_DOC) = TRIM(C6_NUM||C6_ITEM)   AND PA2PV.%NotDel% AND PA2_TIPO = '1') AS RES_PV,
 	       (SELECT SUM(PA2_QUANT) FROM %table:PA2% PA2PV WHERE  PA2PV.PA2_CODPRO = SC6.C6_PRODUTO AND TRIM(PA2PV.PA2_DOC) <> TRIM(C6_NUM||C6_ITEM)  AND PA2PV.%NotDel%  ) AS RES_OUT,
 	       (SELECT SUM(PA1_QUANT) FROM %table:PA1% PA1PV WHERE  PA1PV.PA1_CODPRO = SC6.C6_PRODUTO AND PA1PV.%NotDel%  ) AS FLT_PV,
	       C5_ZDTREJE  AS DT_REJ,                                   
	       C6_FILIAL AS FILIAL,
	       C5_XTIPF AS XTIPO,
		   (SELECT SUM(B2_QATU) FROM %table:SB2% SB2 WHERE SB2.B2_FILIAL = SC6.C6_FILIAL AND B2_COD = SC6.C6_PRODUTO AND SB2.%NotDel% AND SB2.B2_LOCAL = SB1.B1_LOCPAD AND SB2.B2_LOCAL BETWEEN %Exp:mv_par07% AND %Exp:mv_par08% ) AS QTD_EST,
	       (SELECT SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) FROM %table:SC6% SC6PV WHERE SC6.C6_NUM = SC6PV.C6_NUM  
	               AND SC6PV.%NotDel% AND C6_QTDVEN > C6_QTDENT 
	               AND C6_BLQ <> 'R'  
	               AND SC6PV.C6_NUM||SC6PV.C6_ITEM in (SELECT PA1.PA1_DOC  FROM %table:PA1% PA1 WHERE PA1.%NotDel% AND SUBSTR(PA1_DOC,1,6) = SC6.C6_NUM AND PA1_QUANT > 0 ) ) AS TOT_PED
	       
	FROM  %table:SC6% SC6,%table:SC5% SC5,%table:SA1% SA1,%table:SB1% SB1,%table:PA1% PA1
	
	WHERE %exp:_cWhere%
	AND SC6.%NotDel% 
	AND SC5.%NotDel% 
	AND SB1.%NotDel% 
	AND SA1.%NotDel% 
	AND PA1.%NotDel% 
	AND C6_QTDVEN > (C6_QTDENT) 
	AND C6_BLQ <> 'R' 
	AND SC6.C6_PRODUTO   BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% 
	AND	SC6.C6_NUM       BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%  
    AND SC6.C6_NUM     = SC5.C5_NUM 
	AND SC5.C5_CLIENTE = SA1.A1_COD 
	AND SC5.C5_LOJACLI = SA1.A1_LOJA
	AND SB1.B1_COD     = SC6.C6_PRODUTO
    AND SC6.C6_NUM||SC6.C6_ITEM = PA1.PA1_DOC 
    AND PA1.PA1_QUANT > 0              
    AND C5_FILIAL = %xfilial:SC5%
	
	ORDER BY TOT_PED DESC,PEDIDO
EndSql

oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

dbSelectArea(cAliasTRB)   
DbGoTop()

_nRec := 0
DbEval({|| _nRec++  })

DbGoTop()

oSection1:Init()

oReport:SetMeter(_nRec)
_cPed:= "XPTO"
Do While !eof()
	
	oReport:IncMeter()
	                            
	if empty(DT_REJ)
	    _xCredito := ''
    else
		_xCredito := 'Bloqueado'
	endif 
	
	if XTIPO = '2'
	    _xTipofat := 'Parcial'
    else
		_xTipofat := 'Total'
	endif 
	
	if _cPed <> SUBSTR(PEDIDO,1,6) 
	   _cPed := SUBSTR(PEDIDO,1,6)
	   _xSoma := Tot_ped 
	   oReport:SkipLine()
	else
		_xSoma := ""
	endif
	
    _XDT1 := STOD(DT_VDA)
    _XDT2 := STOD(DT_FAB)
	
	oSection1:PrintLine()

	If oReport:Cancel()
		Exit
	EndIf

	DbSkip()          
	
Enddo

oSection1:Finish()

dbSelectArea(cAliasTRB)
dbClosearea(cAliasTRB)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Sergio S. Fuzinaka    � Data � 04.11.09 ���
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
	SX1->X1_PERGUNT := "Pedido de"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
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
	SX1->X1_PERGUNT := "Pedido ate"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
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
	SX1->X1_PERGUNT := "Tipo Prod "
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 1
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "c"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := "Vendas"
	SX1->X1_DEF02   := "InterCompany"
	SX1->X1_DEF03   := "Ambos"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Operacao "
	SX1->X1_VARIAVL := "mv_ch6
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	SX1->X1_DEF02   := ""
	MsUnLock()
EndIf


If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Local de "
	SX1->X1_VARIAVL := "mv_ch7
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := ""
	SX1->X1_DEF02   := ""
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"08",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Local de "
	SX1->X1_VARIAVL := "mv_ch8
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_DEF01   := ""
	SX1->X1_DEF02   := ""
	MsUnLock()
EndIf*/
Return
