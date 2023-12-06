#include 'protheus.ch'
#include 'parmtype.ch'
#include "fileio.ch"

/*
Fonte utilizado para gerar arquivo EDI da nota fiscal para integração com C&C
Autor:Eduardo Matias
Data:15/08/2018
*/

User Function STKEDI01()

	Local 	nHdl
	Local 	lCab	:=	.T.
	Local 	cTop01	:=	"SQL01"
	Local   cError	:=	"Os seguintes codigos não foram encontados:"+ CRLF
	Local	cErrorIt:=	""
	Local	cCodCf	:=	""
	Private cToFile	:=	''
	Private cArq	:=	''
	Private cPerg	:= "STKEDI01"

	If Pergunte(cPerg,.T.)

		If !ExistDir("C:\01_EDI_CC")
			MakeDir("C:\01_EDI_CC")
		EndIf

		cToFile:= cGetFile("Arquivos xls  (*.txt)  | *.txt  "," ",1,"C:\01_EDI_CC",.T.,GETF_LOCALHARD+GETF_RETDIRECTORY ,.F.,.T.)

		If Empty(cToFile)
			msgStop('Diretório incorreto!!!','Erro')
			Return()
		EndIf

		cQuery:= " SELECT F2_EMISSAO F2EMISSAO,NVL(E1_VENCREA,' ') E1VENCREA,D2_CF D2CFOP,F2_DOC F2DOC,F2_SERIE F2SERIE,NVL(ZD_CODCLI,'VAZIO') ZDCODCLI, "	+ CRLF
		cQuery+= " CASE WHEN SA1.A1_EST = 'SP' THEN '043' ELSE CASE WHEN SA1.A1_EST = 'RJ' THEN '634' END END AS COD_LOJA,"	+ CRLF //Ticket  20190509000010 - Everson Santana - 20.05.19
		cQuery+= " D2_QUANT D2QUANT,D2_PRCVEN D2PRCVEN,D2_IPI D2PRDIPI,D2_VALIPI D2VALIPI,D2_PICM D2PICM,D2_VALICM D2VALICM,C6_FCICOD C6FCICOD,D2_ICMSRET D2ICMSRET, "	+ CRLF

		/*SUBQUERY PARA BUSCAR O ULTIMO PERCENTUAL FCI QUANDO EXISTIR CONVERTO PARA STRING*/
		cQuery+= " NVL((	SELECT FDIMP  "	+ CRLF
		cQuery+= " 								FROM (	SELECT CFD_COD FDCOD,CFD_CONIMP FDIMP "	+ CRLF
		cQuery+= " 										FROM "+RetSqlName("CFD")+" CFD  "	+ CRLF
		cQuery+= " 										WHERE CFD_FILIAL='"+xFilial('CFD')+"'  AND CFD.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " 										ORDER BY CFD.R_E_C_N_O_ DESC	)	TMP "	+ CRLF
		cQuery+= " 								WHERE TMP.FDCOD=SD2.D2_COD AND ROWNUM=1	 )	,0) FDIMP, "	+ CRLF
		cQuery+= " A4_CGC A4CGC,F2_BASEICM F2BASEICM,F2_VALICM F2VALICM,F2_BRICMS F2BRICMS,F2_ICMSRET F2ICMSRET,F2_VALMERC F2VALMERC, "	+ CRLF
		cQuery+= " F2_FRETE F2FRETE,F2_SEGURO F2SEGURO,F2_VALIPI F2VALIPI,F2_VALBRUT F2VALBRUT,F2_PBRUTO F2PBRUTO,C5_XORDEM PEDCOM,D2_COD CODSTK "	+ CRLF

		cQuery+= " FROM "+RetSqlName("SF2")+" SF2 "	+ CRLF
		cQuery+= " INNER 	JOIN "+RetSqlName("SD2")+" SD2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND SD2.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " INNER 	JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND SC6.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " INNER 	JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND SC5.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " LEFT 	JOIN "+RetSqlName("SZD")+" SZD ON ZD_FILIAL='"+xFilial('SZD')+"' AND ZD_CLIENTE=D2_CLIENTE  AND D2_COD=ZD_CODSTE AND  SZD.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " LEFT 	JOIN "+RetSqlName("SE1")+" SE1 ON E1_FILORIG=F2_FILIAL AND E1_NUM=F2_DOC AND E1_PREFIXO=F2_SERIE AND E1_CLIENTE=F2_CLIENTE AND E1_LOJA=F2_LOJA AND SE1.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " LEFT 	JOIN "+RetSqlName("SA4")+" SA4 ON A4_FILIAL='"+xFilial('SA4')+"' AND A4_COD=F2_TRANSP AND SA4.D_E_L_E_T_!='*' "	+ CRLF	 //Ticket  20190509000010 - Everson Santana - 20.05.19
		cQuery+= " LEFT 	JOIN "+RetSqlName("SA1")+" SA1 ON A1_FILIAL='  ' AND A1_COD=SF2.F2_CLIENTE AND A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " WHERE F2_FILIAL='"+cFilAnt+"' AND F2_DOC='"+MV_PAR01+"' AND F2_SERIE='001' AND  SF2.D_E_L_E_T_!='*' "	+ CRLF
		cQuery+= " ORDER BY D2_DOC,D2_ITEM	"	+ CRLF

		If !Empty(Select(cTop01))
			DbSelectArea(cTop01)
			(cTop01)->(dbCloseArea())
		Endif

		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

		TcSetField(cTop01,"F2EMISSAO"	,"D",08,00)
		TcSetField(cTop01,"E1VENCREA"	,"D",08,00)

		If (cTop01)->(Eof())

			msgAlert( 'Nota fiscal nao localizada!','Atenção' )

			Return()

		EndIf

		cArq	:=	(cTop01)->(F2DOC+F2SERIE)+".txt"
		cToFile	:=	cToFile+cArq
		nHdl 	:= 	FCreate(cToFile)

		/*Verifico se a relação PRODUTO X CLIENTE foi encontrada*/
		While (cTop01)->(!Eof())
			If (cTop01)->ZDCODCLI='VAZIO'
				cErrorIt+=	(cTop01)->CODSTK + CRLF
			EndIf
			(cTop01)->(dbSkip())
		EndDo

		If !Empty(cErrorIt)
			msgStop(cError+cErrorIt,"PRODUTO x CLIENTE")
			Return()
		Else
			(cTop01)->(dbGoTop())
		EndIf

		If (cTop01)->(!Eof())

			lCab	:=	.T.

			cLinha0	:=''
			cLinha1	:=''//Header da Nota Fiscal (Tipo 1)
			cLinha2	:=''//Item da Nota Fiscal (Tipo 2)
			cLinha3	:=''//Transportadora (Tipo 3)
			cLinha4	:=''//Trailler da Nota Fiscal (Tipo 4)
			cLinha9	:=''//Trailler do arquivo (Fim de arquivo, Tipo 9)
			nSumQtd	:= 0//Somatória da quantidade de todos os itens da Nota Fiscal

			While (cTop01)->(!Eof())

				nSumQtd	+=	(cTop01)->D2QUANT

				If (cTop01)->D2ICMSRET>0
					cCodCf	:=	(cTop01)->D2CFOP
				EndIf

				(cTop01)->(dbSkip())
			EndDo

			(cTop01)->(dbGoTop())

			While (cTop01)->(!Eof())

				If lCab

					cEmissao:= GravaData( (cTop01)->F2EMISSAO, .F., 5 )
					cDtVenc	:= GravaData( (cTop01)->E1VENCREA, .F., 5 )

					lCab:=	.F.

					cLinha1	:="1"																	//01 - Header da Nota Fiscal
					//cLinha1	+="4119"																//04 - Código do fornecedor
					cLinha1	+="8468"																//04 - Código do fornecedor
					cLinha1	+="00000"																//05 - Encomenda
					//cLinha1	+="043"																	//03 - Código da Loja//Ticket  20190509000010 - Everson Santana - 20.05.19
					cLinha1	+= (cTop01)->COD_LOJA													//03 - Código da Loja
					cLinha1	+=PadL(	AllTrim(SubStr((cTop01)->PEDCOM,1,19)		),19,'0')			//19 - id_num_pedido
					cLinha1	+='000000'																//06 - Filler
					cLinha1	+=cEmissao																//08 - Data de Emissão da Nota Fiscal
					cLinha1	+=cDtVenc																//08 - Data de vencimento da fatura da Nota Fiscal
					cLinha1	+=	FatParc()//Verifico se e parcial ou total entrega					//01 - Tipo de Entrega (1 = Total, 0 = Parcial)
					//cLinha1	+=PadL(	AllTrim(			(cTop01)->D2CFOP			),04,Space(1))	//04 - CFOP
					cLinha1	+=PadL(	AllTrim(Iif(Empty(cCodCf),(cTop01)->D2CFOP,cCodCf)),04,Space(1))//04 - CFOP -- PRIORIZAR CFOP COM ST
					cLinha1	+=PadL(	AllTrim(			SM0->M0_CGC					),14,Space(1))	//14 - CNPJ do emissor da nota fiscal
					cLinha1	+='O'																	//14 - Local de Entrega - Utilizar a letra “O”, maiúscula p/ Cross Docking
					cLinha1	+=PadL(	AllTrim(			(cTop01)->F2DOC				),09,'0')		//04 - Número da Nota Fiscal
					cLinha1	+=PadL(	AllTrim(			(cTop01)->F2SERIE			),03,'0')		//04 - Número da Série NF Preenchido com zeros à esquerda
					cLinha1	+=Space(113)															//01 - Filler

					cLinha1	+=	CRLF

					cLinha3	:="3"																	//01 - Header da Nota Fiscal
					cLinha3	+=PadR(	AllTrim(			(cTop01)->A4CGC					),14,'0')	//14 - CNPJ/CPF da Transportadora
					cLinha3	+=Space(184)															//01 - Filler 184

					cLinha3	+=	CRLF

					cLinha4	:="4"																			//04 - Trailler da Nota Fiscal (Tipo 4)
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2BASEICM		,12,2),".",","	)	,12,"0")	//12 - Base de Calculo de ICMS
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2VALICM		,12,2),".",","	)	,12,"0")	//12 - Somatória do valor do ICMS de todos os itens de produto da Nota Fiscal
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2BRICMS		,12,2),".",","	)	,12,"0")	//12 - Base de Calculo de ICMS Substituição
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2ICMSRET		,12,2),".",","	)	,12,"0")	//12 - Valor ICMS Substituição
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2VALMERC		,12,2),".",","	)	,12,"0")	//12 - Somatória do valor total de todos os itens de pedido da Nota Fiscal
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2FRETE		,12,2),".",","	)	,12,"0")	//12 - Valor do Frete
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2SEGURO		,12,2),".",","	)	,12,"0")	//12 - Valor do seguro
					cLinha4	+=PadL('0'															,12,"0")	//12 - Outras despesas acessórias
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2VALIPI		,12,2),".",","	)	,12,"0")	//12 - Somatória do valor do IPI de todos os itens de pedido da Nota Fiscal
					cLinha4	+=PadR(StrTran(StrZero((cTop01)->F2VALBRUT		,12,2),".",","	)	,12,"0")	//12 - Valor total da Nota Fiscal
					cLinha4	+=PadR(StrTran(StrZero(nSumQtd					,10,0),".",""	)	,10,"0")	//10 - Somatória da quantidade de todos os itens da Nota Fiscal
					cLinha4	+=PadL(AllTrim(cValToChar((cTop01)->F2PBRUTO					))	,10,'0')	//12 - Peso Bruto
					cLinha4	+=PadL('0'															,12,'0')	//12 - Valor do FCP sobre ICMS
					cLinha4	+=PadL('0'															,12,'0')	//12 - Valor do FCP sobre ST
					cLinha4	+=Space(34)																		//01 - Filler 34

					cLinha4	+=	CRLF

					cLinha9	:="9"																		//04 - Trailler da Nota Fiscal (Tipo 4)
					cLinha9	+=Space(198)																//01 - Filler 199


				EndIf

				cLinha2	+='2'																			//01 - Itens de pedido da Nota Fiscal (Reg. Detalhe)
				cLinha2	+=PadR(AllTrim((cTop01)->ZDCODCLI	),25,Space(1))								//25 - Código do Produto
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2QUANT	,10,0),".",","	),10,"0")			//10 - Quantidade do item de Pedido
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2PRCVEN	,12,2),".",","	),12,"0")			//12 - Valor unitário do item de pedido
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2PRDIPI	,05,2),".",","	),05,"0")			//05 - Alíquota do IPI do item de pedido
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2VALIPI	,12,2),".",","	),12,"0")			//12 - Valor do IPI do item do pedido
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2PICM		,05,2),".",","	),05,"0")			//05 - Alíquota do ICMS do item do pedido
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->D2VALICM	,12,2),".",","	),12,"0")			//12 - Valor do ICMS do item do pedido
				cLinha2	+=Space(1)																		//01 - Filler
				cLinha2	+=PadL(AllTrim((cTop01)->C6FCICOD	),36,Space(1))								//36 - Número de FC
				cLinha2	+=PadR(StrTran(StrZero((cTop01)->FDIMP		,05,2),".",""	),04,"0")			//05 - Percentual de CI
				cLinha2	+=Space(76)																		//01 - Filler

				cLinha2	+=	CRLF

				(cTop01)->(dbSkip())

			EndDo

			cLinha0:=cLinha1+cLinha2+cLinha3+cLinha4+cLinha9

			If Len(cLinha0)
				FWrite(nHdl, cLinha0, Len(cLinha0))
			EndIf

		EndIf

		FClose(nHdl)

		msgInfo('Arquivo gerado em:'+cToFile,'Arquivo OK')

	EndIf

Return()

/*VERIFICO SE O PEDIDO DA NOTA FOI ATENDIDO TOTAL OU PARCIAL*/
Static Function FatParc()

	Local cParc	:=	"1"//ENTREGA TOTAL
	Local cTop02:=	"SQL02"

	cQuery:= " SELECT SUM(C6_QTDVEN)-SUM(C6_QTDENT) SALDO "	+ CRLF
	cQuery+= " FROM "+RetSqlName("SD2")+" SD2 " + CRLF
	cQuery+= " INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND SC6.D_E_L_E_T_!='*' " + CRLF
	cQuery+= " WHERE D2_FILIAL='"+cFilAnt+"' AND D2_DOC='"+MV_PAR01+"' AND D2_SERIE='001' AND SD2.D_E_L_E_T_!='*' "	+ CRLF

	If !Empty(Select(cTop02))
		DbSelectArea(cTop02)
		(cTop02)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop02, .T., .T. )

	If (cTop02)->(!Eof())

		If (cTop02)->SALDO>0
			cParc	:=	"0"//ENTREGA PARCIAL
		EndIf

	EndIf

Return(cParc)
