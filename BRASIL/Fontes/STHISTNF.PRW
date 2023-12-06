#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STHISTNF	ºAutor  ³Renato Nogueira     º Data ³  14/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para puxar situação de nota fiscal ou pedidoº±±
±±º          ³retornando romaneio, OS, volumes e etc. 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STHISTNF()

	Local aRet 		:= {}
	Local aParamBox := {}
	Local aCombo 	:= {}
	Local cQuery 	:= ""
	Local cQryC6 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local _aItens	:= {}
	Private oLbx

	aCombo := {"Nota Fiscal","Pedido","OS"}

	aAdd(aParamBox,{2,"Tipo de busca",,aCombo,50,"",.F.})
	aAdd(aParamBox,{1,"Numero",Space(9),"","","","",0,.F.})

	If ParamBox(aParamBox,"Parâmetros...",@aRet)
		// Adicionado PD1_XDENVT, PD1_XHENVT, - Valdemir Rabelo 25/02/2020
		cQuery += " SELECT C5_FILIAL,C5_NUM,CB7_ORDSEP,CB7_DTEMIS,CB7_HREMIS,
		cQuery += " 	COUNT(DISTINCT CB8_ITEM) QTDLINHAS,
		cQuery += " 	(CASE WHEN CB7_STATUS='0' THEN 'INICIO' WHEN CB7_STATUS='1' 
		cQuery += " 	THEN 'SEPARANDO' WHEN CB7_STATUS='2' THEN 'SEP. FINAL' 
		cQuery += "		WHEN CB7_STATUS='3' THEN 'EMBALANDO' WHEN CB7_STATUS='4' THEN 'EMB. FINAL' 
		cQuery += " 	WHEN CB7_STATUS='5' THEN 'GERA NOTA' WHEN CB7_STATUS='6' THEN 'IMP NOTA' 
		cQuery += " 	WHEN CB7_STATUS='7' THEN 'IMP VOL' WHEN CB7_STATUS='8' THEN 'EMBARCADO' 
		cQuery += " 	WHEN CB7_STATUS='9' THEN 'EMBARQUE FINALIZADO' END) STATUSPED,
		cQuery += " 	A1_NOME,A1_COD,A1_LOJA,F2_TRANSP, C5_VEND1||' - '||A3_NOME VENDEDOR, CB7_CODOPE||' - ' ||CB1.CB1_NOME OPERADOR, CB7_HRFIMS, 
		cQuery += " 	CB9_CODEMB||' - '||CB1X.CB1_NOME EMBALADOR
		cQuery += " 	,CB7_XHFEM,
		cQuery += " 	(CASE WHEN C5_XTIPO='2' THEN 'ENTREGA' ELSE 'RETIRA' END) TPENT,
		cQuery += " 	(CASE WHEN C5_XTIPF='2' THEN 'PARCIAL' ELSE 'TOTAL' END) TPFAT, CB7_NOTA, F2_EMISSAO, F2_HORA, F2_PBRUTO, F2_VOLUME1, F2_VALBRUT,
		cQuery += " 	PD2_CODROM, PD1_DTEMIS
		If cEmpAnt = '01'
			cQuery += "		,PD1_XDENVT, PD1_XHENVT"
		EndIf
		cQuery += " 	,(CASE WHEN PD1_STATUS='0' THEN 'NAO INICIADO' WHEN PD1_STATUS='1' THEN 'EM ANDAMENTO' WHEN PD1_STATUS='2' THEN 'FECHADO' ELSE 'ENCERRADO' END) STATUSROM,
		cQuery += " 	utl_raw.cast_to_varchar2(dbms_lob.substr(PD1_OBS,2000,1)) PD1_OBS, PD1_PLACA, F2_CHVNFE
		cQuery += " 	,NVL(MAX(Z5_ENDEREC),' ') ENDEXP, NVL(A4_NOME,' ') NOMESA4, NVL(MAX(PC2_NFATEC),' ') FATEC, NVL(MAX(D1_DOC),' ') NFENT
		cQuery += " FROM "+RetSqlName("SC5")+ " C5
		cQuery += " LEFT JOIN "+RetSqlName("CB7")+ " CB7
		cQuery += " ON CB7_FILIAL=C5_FILIAL AND CB7_PEDIDO=C5_NUM AND CB7.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("SZ5")+ " Z5
		cQuery += " ON Z5_FILIAL=CB7_FILIAL AND Z5_ORDSEP=CB7_ORDSEP AND Z5.D_E_L_E_T_=' '  
		cQuery += " LEFT JOIN "+RetSqlName("CB8")+ " CB8
		cQuery += " ON CB7_FILIAL=CB8_FILIAL AND CB7_ORDSEP=CB8_ORDSEP AND CB8.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("SA1")+ " A1
		cQuery += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
		cQuery += " LEFT JOIN "+RetSqlName("SA3")+ " A3
		cQuery += " ON A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("CB1")+ " CB1
		cQuery += " ON CB1_FILIAL=CB7_FILIAL AND CB1_CODOPE=CB7_CODOPE AND CB1.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("CB9")+ " CB9
		cQuery += " ON CB9_FILIAL=CB8_FILIAL AND CB9_ORDSEP=CB8_ORDSEP AND CB9_ITESEP=CB8_ITEM AND CB9.D_E_L_E_T_=' ' 
		cQuery += " LEFT JOIN "+RetSqlName("CB1")+ " CB1X
		cQuery += " ON CB1X.CB1_FILIAL=CB9_FILIAL AND CB1X.CB1_CODOPE=CB9_CODEMB AND CB1X.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("SF2")+ " F2
		cQuery += " ON F2_FILIAL=CB7_FILIAL AND F2_DOC=CB7_NOTA AND F2_SERIE=CB7_SERIE AND F2.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("SD1")+ " D1
		cQuery += " ON D1_FILIAL=F2_FILIAL AND D1_NFORI=F2_DOC AND D1_SERIORI=F2_SERIE AND D1.D_E_L_E_T_=' ' 
		cQuery += " LEFT JOIN "+RetSqlName("SA4")+ " A4
		cQuery += " ON F2_TRANSP=A4_COD AND A4.D_E_L_E_T_=' ' 
		cQuery += " LEFT JOIN "+RetSqlName("PC2")+ " PC2
		cQuery += " ON PC2_NFORIG=F2_DOC AND PC2_SERIE=F2_SERIE AND PC2.D_E_L_E_T_=' ' 
		cQuery += " LEFT JOIN "+RetSqlName("PD2")+ " PD2
		cQuery += " ON PD2_FILIAL=F2_FILIAL AND PD2_NFS=F2_DOC AND PD2_SERIES=F2_SERIE AND PD2.D_E_L_E_T_=' '
		cQuery += " LEFT JOIN "+RetSqlName("PD1")+ " PD1
		cQuery += " ON PD1_FILIAL=PD2_FILIAL AND PD2_CODROM=PD1_CODROM AND PD1.D_E_L_E_T_=' '
		cQuery += " WHERE C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
		cQuery += "  AND C5_FILIAL='"+xFilial("SC5")+"'

		If aRet[1] == "Nota Fiscal"
			cQuery += " AND CB7_NOTA = '" + aRet[2] + "' "
		ElseIf aRet[1] == "Pedido"
			cQuery += " AND C5_NUM = '" + aRet[2] + "' "
		ElseIf aRet[1] == "OS"
			cQuery += " AND CB7_ORDSEP = '" + aRet[2] + "' "
		EndIf

		cQuery += " GROUP BY C5_FILIAL,C5_NUM,CB7_ORDSEP,CB7_DTEMIS,CB7_HREMIS,A4_NOME,
		cQuery += " (CASE WHEN CB7_STATUS='0' THEN 'INICIO' WHEN CB7_STATUS='1' 
		cQuery += " THEN 'SEPARANDO' WHEN CB7_STATUS='2' THEN 'SEP. FINAL' 
		cQuery += " WHEN CB7_STATUS='3' THEN 'EMBALANDO' WHEN CB7_STATUS='4' THEN 'EMB. FINAL' 
		cQuery += " WHEN CB7_STATUS='5' THEN 'GERA NOTA' WHEN CB7_STATUS='6' THEN 'IMP NOTA' 
		cQuery += " WHEN CB7_STATUS='7' THEN 'IMP VOL' WHEN CB7_STATUS='8' THEN 'EMBARCADO' 
		cQuery += " WHEN CB7_STATUS='9' THEN 'EMBARQUE FINALIZADO' END),
		cQuery += " A1_NOME,A1_COD,A1_LOJA,F2_TRANSP,CB7_XHFEM, C5_VEND1||' - '||A3_NOME, CB7_CODOPE||' - ' ||CB1.CB1_NOME, CB7_HRFIMS, CB9_CODEMB||' - '||CB1X.CB1_NOME,
		cQuery += " (CASE WHEN C5_XTIPO='2' THEN 'ENTREGA' ELSE 'RETIRA' END),
		cQuery += " (CASE WHEN C5_XTIPF='2' THEN 'PARCIAL' ELSE 'TOTAL' END),CB7_NOTA, F2_EMISSAO, F2_HORA, F2_PBRUTO, F2_VOLUME1, F2_VALBRUT,
		cQuery += " (CASE WHEN PD1_STATUS='0' THEN 'NAO INICIADO' WHEN PD1_STATUS='1' THEN 'EM ANDAMENTO' WHEN PD1_STATUS='2' THEN 'FECHADO' ELSE 'ENCERRADO' END),
		cQuery += " utl_raw.cast_to_varchar2(dbms_lob.substr(PD1_OBS,2000,1)),PD2_CODROM, PD1_DTEMIS, PD1_PLACA, F2_CHVNFE
		If cEmpAnt = '01'
			cQuery += " ,PD1_XDENVT, PD1_XHENVT"
		EndIf
		If !Empty(Select(cAlias))
			dbSelectArea(cAlias)
			(cAlias)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		dbSelectArea(cAlias)
		(cAlias)->( dbGoTop() )
		While (cAlias)->( !Eof() )
			// Ticket 20210506007456 - Ajuste no relatório "Objeto: U_STHISTNF" consulta NF/pedido - Eduardo Pereira - Sigamat - 06.05.2021 - Inicio
			// Filtro para trazer o valor do pedido por Pedido x Nota
			cQryC6 := " SELECT SUM(C6_VALOR) AS VLR_PED FROM " + RetSqlName("SC6")
			cQryC6 += " WHERE D_E_L_E_T_ = ' ' "
			cQryC6 += " 	AND C6_NUM = '" + (cAlias)->C5_NUM + "' "
			cQryC6 += " 	AND C6_NOTA = '" + (cAlias)->CB7_NOTA + "' "
			If !Empty(Select("TRBSC6"))
				TRBSC6->( dbCloseArea() )
			EndIf
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryC6),"TRBSC6",.T.,.T.)
			// Ticket 20210506007456 - Ajuste no relatório "Objeto: U_STHISTNF" consulta NF/pedido - Eduardo Pereira - Sigamat - 06.05.2021 - Fim
			aAdd(_aItens,{	;
							(cAlias)->C5_FILIAL	,;
							(cAlias)->C5_NUM,;
							(cAlias)->CB7_ORDSEP,;
							DtoC(StoD((cAlias)->CB7_DTEMIS)),;
							(cAlias)->CB7_HREMIS,;
							(cAlias)->QTDLINHAS,;
							"R$ " + AllTrim(Transform(TRBSC6->VLR_PED,"@E 999,999,999.99")),;	// Ticket 20210506007456 - Ajuste no relatório "Objeto: U_STHISTNF" consulta NF/pedido - Eduardo Pereira - Sigamat - 06.05.2021
							(cAlias)->STATUSPED,;
							(cAlias)->A1_COD,;
							(cAlias)->A1_LOJA,;
							(cAlias)->A1_NOME,;
							(cAlias)->VENDEDOR,;
							(cAlias)->OPERADOR,;
							SubStr((cAlias)->CB7_HRFIMS,1,2) + ":" + SubStr((cAlias)->CB7_HRFIMS,3,2),;
							(cAlias)->EMBALADOR,;
							SubStr((cAlias)->CB7_XHFEM,1,5),;
							(cAlias)->TPENT,;
							(cAlias)->F2_TRANSP,;
							(cAlias)->NOMESA4,;
							(cAlias)->TPFAT,;
							(cAlias)->CB7_NOTA,;
							DtoC(StoD((cAlias)->F2_EMISSAO)),;
							(cAlias)->F2_HORA,;
							(cAlias)->F2_PBRUTO,;
							(cAlias)->F2_VOLUME1,;
							"R$ " + AllTrim(Transform((cAlias)->F2_VALBRUT,"@E 999,999,999.99")),;
							(cAlias)->FATEC,;
							(cAlias)->NFENT,;
							(cAlias)->PD2_CODROM,;
							DtoC(StoD((cAlias)->PD1_DTEMIS)),;
							(cAlias)->ENDEXP,;
							(cAlias)->STATUSROM,;
							AllTrim((cAlias)->PD1_OBS),;
							u_regceped((cAlias)->C5_NUM),;
							(cAlias)->PD1_PLACA,;
							(cAlias)->F2_CHVNFE,;
							Iif(cEmpAnt == '01', DtoC(StoD((cAlias)->PD1_XDENVT)), CtoD("//")),; 		// Valdemir Rabelo 25/02/2020
							Iif(cEmpAnt == '01', (cAlias)->PD1_XHENVT, "");
							})
			(cAlias)->( dbSkip() )
		EndDo

		If Len(_aItens) > 0
			DEFINE MSDIALOG oDlg TITLE "Tela de informações" FROM 200,1 TO 500,1200 PIXEL //240
			@ 1,1 LISTBOX oLbx FIELDS HEADER ;
			"Filial",;
			"Pedido",;
			"OS",;
			"Emissão OS",;
			"Hr emissão OS",;
			"QTD linhas",;
			"Vlr Pedido",;
			"Status pedido",;
			"Numero cliente",;
			"Loja",;
			"Cliente",;
			"Vend 1",;
			"Separador",;
			"Hora final separação",;
			"Embalador",;
			"Hora final embalagem",;
			"Tipo Retira ou Entrega",;
			"Trans.Num",;
			"Transportadora",;
			"Pedido parcial ou total",;
			"NF",;
			"Emissão NF",;
			"Hora emissão NF",;
			"Peso Bruto NF",;
			"QTD volumes",;
			"Valor NF",;
			"Fatec",;
			"Nf Entrada",;
			"Romaneio",;
			"Emissão romaneio",;
			"End EXP",;
			"Status romaneio",;
			"OBS romaneio",;
			"Rota",;
			"Placa Veiculo",;
			"Chave",;
			"Dt.Envio",;
			"Hr.Envio";
			SIZE 600,095 OF oDlg PIXEL //ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])
			//Exibe o Array no browse
			oLbx:SetArray( _aItens )
			oLbx:bLine := {||{_aItens[oLbx:nAt,1],;
			_aItens[oLbx:nAt,2],;
			_aItens[oLbx:nAt,3],;
			_aItens[oLbx:nAt,4],;
			_aItens[oLbx:nAt,5],;
			_aItens[oLbx:nAt,6],;
			_aItens[oLbx:nAt,7],;
			_aItens[oLbx:nAt,8],;
			_aItens[oLbx:nAt,9],;
			_aItens[oLbx:nAt,10],;
			_aItens[oLbx:nAt,11],;
			_aItens[oLbx:nAt,12],;
			_aItens[oLbx:nAt,13],;
			_aItens[oLbx:nAt,14],;
			_aItens[oLbx:nAt,15],;
			_aItens[oLbx:nAt,16],;
			_aItens[oLbx:nAt,17],;
			_aItens[oLbx:nAt,18],;
			_aItens[oLbx:nAt,19],;
			_aItens[oLbx:nAt,20],;
			_aItens[oLbx:nAt,21],;
			_aItens[oLbx:nAt,22],;
			_aItens[oLbx:nAt,23],;
			_aItens[oLbx:nAt,24],;
			_aItens[oLbx:nAt,25],;
			_aItens[oLbx:nAt,26],;
			_aItens[oLbx:nAt,27],;
			_aItens[oLbx:nAt,28],;
			_aItens[oLbx:nAt,29],;
			_aItens[oLbx:nAt,30],;
			_aItens[oLbx:nAt,31],;
			_aItens[oLbx:nAt,32],;
			_aItens[oLbx:nAt,33],;
			_aItens[oLbx:nAt,34],;
			_aItens[oLbx:nAt,35],;
			_aItens[oLbx:nAt,36],;
			_aItens[oLbx:nAt,37],;
			_aItens[oLbx:nAt,38]}}
			@ 200,90 BTNBMP oBtn1 RESOURCE  "FINAL" 	     SIZE 40,40 ACTION oDlg:End() ENABLE OF oDlg
			@ 200,120 BTNBMP oBtn1 RESOURCE "BMPVISUAL" 	 SIZE 40,40 ACTION IMPNF() ENABLE OF oDlg
			@ 200,150 BTNBMP oBtn1 RESOURCE "WMSIMG32" 	 	 SIZE 40,40 ACTION VISEMB() ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg CENTER
		Else
			MsgAlert("Nota fiscal ou pedido não encontrados")
		EndIf
		U_STHISTNF()
	EndIf

Return

Static Function IMPNF()

	Local _cDirRel := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS')

	U_STRONFE(oLbx:aArray[oLbx:nAt,36],.T.)

	If !ExistDir(_cDirRel)
		MakeDir(_cDirRel)
	Endif

	_cNomePdf := oLbx:aArray[oLbx:nAt,36]

	If !Empty(_cNomePdf)
		fErase(_cDirRel + "\" + _cNomePdf + ".pdf")
		CpyS2T("\arquivos\xml_nfe\" + cEmpAnt + "\" + _cNomePdf + '.pdf',_cDirRel + "\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		ShellExecute("open",_cDirRel + "\" + _cNomePdf + '.pdf', "", "", 1)
	Else
		MsgInfo("<b>Campo Chave da NF em BRANCO.</b>" + CRLF + CRLF +;
				"<b>Não será impresso a Nota !!!</b>")
	EndIf

Return

Static Function VISEMB()

	U_STFSFA30(,,oLbx:aArray[oLbx:nAt,3])

Return
