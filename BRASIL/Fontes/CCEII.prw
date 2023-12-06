#INCLUDE "TOTVS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE IMP_SPOOL 2

//---------------------------------------------------------------------------------------------------------------//
//Alterações Realizadas: 
//Ticket #20220225004628
//FR - Flávia Rocha - Sigamat Consultoria - 14/03/2022 - ALTERAÇÃO - A impressão do telefone estava fora do box
//---------------------------------------------------------------------------------------------------------------//

USER FUNCTION CCEII
Local aArea := GetArea()

If aArea[1] == "SF2"
	CCEII_S()
ElseIf aArea[1] == "SF1"
	CCEII_E()
Else
	FWAlertInfo("Problemas com a Tabela (área) - Contete o TI...")
EndIf

RestArea(aArea)
Return

Static Function CCEII_S
	Local nX:=0
	Local nY:=0
	Local i

	//+----------------------------------------------+
	//|Objetos do XML                                |
	//+----------------------------------------------+
	Private oXML
	Private cError	:=""
	Private cWarning:=""

	//+----------------------------------------------------------------+
	//|DEFINICAO DE FONTES                                             |
	//+----------------------------------------------------------------+
	PRIVATE oFont07n    :=TFont():new("Arial",,-07,.F.,,,,,,.F.,.F.)
	PRIVATE oFont07b    :=TFont():new("Arial",,-07,.T.,,,,,,.F.,.F.)
	PRIVATE oFont08n    :=TFont():new("Arial",,-08,.F.,,,,,,.F.,.F.)
	PRIVATE oFont08b    :=TFont():new("Arial",,-08,.T.,,,,,,.F.,.F.)
	PRIVATE oFont09n    :=TFont():new("Arial",,-09,.F.,,,,,,.F.,.F.)
	PRIVATE oFont09b    :=TFont():new("Arial",,-09,.T.,,,,,,.F.,.F.)
	PRIVATE oFont10n    :=TFont():new("Arial",,-10,.F.,,,,,,.F.,.F.)
	PRIVATE oFont10b    :=TFont():new("Arial",,-10,.T.,,,,,,.F.,.F.)
	PRIVATE oFont12n    :=TFont():new("Arial",,-12,.F.,,,,,,.F.,.F.)
	PRIVATE oFont12b    :=TFont():new("Times New Roman",,-12,.T.,,,,,,.F.,.F.)
	PRIVATE oFont14n    :=TFont():new("Arial",,-14,.F.,,,,,,.F.,.F.)
	PRIVATE oFont14b    :=TFont():new("Arial",,-14,.T.,,,,,,.F.,.F.)
	PRIVATE oFont16n    :=TFont():new("Arial",,-16,.F.,,,,,,.F.,.F.)
	PRIVATE oFont16b    :=TFont():new("Arial",,-16,.T.,,,,,,.F.,.F.)
	PRIVATE oFont18n    :=TFont():new("Arial",,-18,.F.,,,,,,.F.,.F.)
	PRIVATE oFont18b    :=TFont():new("Arial",,-18,.T.,,,,,,.F.,.F.)
	PRIVATE oFont20n    :=TFont():new("Arial",,-20,.F.,,,,,,.F.,.F.)
	PRIVATE oFont20b    :=TFont():new("Arial",,-20,.T.,,,,,,.F.,.F.)
	PRIVATE SPEDXML := ""

	//+---------------------------------------------------------------------------
	//| Monta query de selecao dos Dados
	//+---------------------------------------------------------------------------
	cQuery:=""
	cQuery+=" SELECT  D2_TES,F2_CLIENT, F2_LOJA,F2_DOC,F2_SERIE,F2_TIPO "
	cQuery+="  ,F4_TEXTO,NFE_CHV,PROTOCOLO "
	cQuery+="  ,F2_HORA "
	cQuery+="  ,F2_EMISSAO "
	cQuery+="  ,DHREGEVEN "
	cQuery+="  , utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,1))    SPEDXML1 " //CAST( CAST(XML_SIG AS VARBINARY(8000)) AS VARCHAR(8000)) AS SPEDXML  "
	cQuery+="  , utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,2001)) SPEDXML2 "
	cQuery+="  , utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,4001)) SPEDXML3 "
	cQuery+="  , utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,6001)) SPEDXML4 "
	cQuery+=" FROM SPED154 S154 "
	cQuery+=" 	INNER JOIN "+RetSqlName("SF2")+"  SF2 ON F2_CHVNFE=NFE_CHV "
	cQuery+=" 	INNER JOIN "+RetSqlName("SD2")+"  SD2 ON D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE "
	cQuery+=" 	INNER JOIN "+RetSqlName("SF4")+"  SF4 ON F4_CODIGO=D2_TES  "
	cQuery+=" WHERE	"
	cQuery+="      F2_DOC='"+SF2->F2_DOC+"' "
	cQuery+=" 		AND S154.CSTATEVEN='135' "
	cQuery+="       AND F2_FILIAL='"+XFILIAL("SF2")+"'"
	cQuery+="       AND D2_FILIAL='"+XFILIAL("SD2")+"'"
	cQuery+="       AND F4_FILIAL='"+XFILIAL("SF4")+"'"
	cQuery+=" 		AND SF2.D_E_L_E_T_=' ' "
	cQuery+=" 		AND SD2.D_E_L_E_T_=' ' "
	cQuery+=" 		AND SF4.D_E_L_E_T_=' ' "
	cQuery+="		AND rownum = 1 "
	cQuery+=" GROUP BY "
	cQuery+=" D2_TES,F2_CLIENT,F2_LOJA,F2_DOC,F2_SERIE,F2_TIPO, "
	cQuery+=" F4_TEXTO,NFE_CHV,PROTOCOLO,DHREGEVEN,F2_HORA,F2_EMISSAO,   "
	cQuery+=" utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,1)),  "
	cQuery+=" utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,2001)), "
	cQuery+=" utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,4001)), "
	cQuery+=" utl_raw.cast_to_varchar2(dbms_lob.substr(XML_SIG,2000,6001))  "
	cQuery+=" ORDER BY  PROTOCOLO desc "

	cQuery := ChangeQuery(cQuery)

	If SELECT("TCCE")>0
		TCCE->(DBCLOSEAREA())
	ENDIF

	tcquery cquery new alias "TCCE"
	DBSELECTAREA("TCCE")
	DBGOTOP()

	If F2_TIPO=="D"

		DbSelectArea("SA2")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SA2")+TCCE->F2_CLIENT+TCCE->F2_LOJA)

		A1NOME:=A2_NOME
		A1CGC:=A2_CGC
		A1INSCR:=A2_INSCR
		A1END:=A2_END
		A1BAIRRO:=A2_BAIRRO
		A1CEP:=A2_CEP
		A1MUN:=A2_MUN
		A1TEL:=A2_TEL
		A1EST:=A2_EST

	Else

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SA1")+TCCE->F2_CLIENT+TCCE->F2_LOJA)

		A1NOME:=A1_NOME
		A1CGC:=A1_CGC
		A1INSCR:=A1_INSCR
		A1END:=A1_END
		A1BAIRRO:=A1_BAIRRO
		A1CEP:=A1_CEP
		A1MUN:=A1_MUN
		A1TEL:=A1_TEL
		A1EST:=A1_EST
	EndIf

	DBSELECTAREA("TCCE")
	If Eof()
		MsgInfo("Carta de Correcao Eletronica nao Encontrada")
		Return
	EndIf

	// ----------------------------------------------
	// Inicializa objeto de impressao
	// ----------------------------------------------

	oPrt:=FWMsPrinter():New("DCCE_"+NFE_CHV,IMP_PDF)

	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	MakeDir("C:\ARQUIVOS_PROTHEUS\CCE\")   //forca a imprimir em uma pasta especifica
	oPrt:cPathPDF:="C:\ARQUIVOS_PROTHEUS\CCE\"
	oPrt:SetViewPDF(.t.)

	//+---------------------------------------------
	//|Configuracao de Impressao
	//+---------------------------------------------
	oPrt:SetResolution(78) //O Mesmo tamanho estipulado para a Danfe
	oPrt:SetPortrait()
	oPrt:SetPaperSize(DMPAPER_A4)
	oPrt:SetMargin(60,60,60,60)


	// ----------------------------------------------
	// Configuracao de resolucao de Pagina
	// ----------------------------------------------
	nY:=oPrt:nVertRes() 	//Resolucao vertical
	nX:=oprt:nHorzRes()-200	//Resulucao Horizontal

	oPrt:StartPage()    //Inicia uma nova Pagina

	//bOX DO TOPO DE ASSINATURA
	oPrt:Box(100,010,200,nX-400)	//Dados do Cliente
	oPrt:Box(200,010,300,nX-400)	//Linha 2 Assinatura
	oPrt:Box(200,010,300,300)	   	//Data de Recebimento
	oPrt:Box(100,nX-400,300,nX)		//Numero da Nota

	oPrt:Say(140, 020, "RECEBEMOS DE "+ALLTRIM(SM0->M0_NOMECOM)+" OS PRODUTOS CONSTANTES DA NOTA FISCAL ELETRONICA", oFont12n)
	oPrt:Say(220, 020, "DATA DE RECEBIMENTO", oFont09N)
	oPrt:Say(220, 320, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont09N)
	oPrt:Say(130,(nX-400)+100,"NF-e",oFont14b)
	oPrt:Say(200,(nx-400)+20,SF2->F2_DOC+"-"+SF2->F2_SERIE,oFont18N)


	//Box Informacoes da CCe
	oPrt:Box(410,010,700,nX)
	oPrt:Box(410,010,700,600)//Caixa do Logo
	oPrt:Box(410,500,700,400)//Caixa Inf da Empresa
	oPrt:Box(410,900,700,200)//Caixa Inf da Nota
	oPrt:Box(410,1100,700,nx)//Cod de Barras chave de acesso e protocolo
	oPrt:Box(550,1050,580,1070)

	oPrt:SayBitmap(520,020,"lgrl01.bmp",150,100)    //Logo


	//Informacoes da empresa

	DbSelectArea("SM0")

	oPrt:Say(440,250,SM0->M0_NOMECOM	,ofont14B)
	oPrt:Say(490,250,SM0->M0_ENDENT	,oFont09n)
	oPrt:Say(520,250,SM0->M0_BAIRENT	,oFont09n)
	oPrt:Say(550,250,SM0->M0_CEPENT		,oFont09n)
	oPrt:Say(580,250,ALLTRIM(SM0->M0_CIDENT)+" "+SM0->M0_ESTENT,oFont09n)

	DBSELECTAREA("TCCE")
	//QUADRO INFORMACAOES DA DANFE
	oPrt:Say(440,910,"DACCe"				,oFont14B)
	oPrt:Say(460,910,"Documeto Auxiliar "	,oFont08n)
	oPrt:Say(490,910,"da Carta de "			,oFont08n)
	oPrt:Say(520,910,"Correção Eletrônica"	,oFont08n)

	oPrt:Say(550,910,"0-Entrada"		,oFont09n)
	oPrt:Say(580,910,"1-Saida"			,oFont09n)
	oPrt:say(570,1050,"1"				,oFont09n)
	oPrt:Say(610,910,"Serie :"+SF2->F2_SERIE		,oFont09n)
	oPrt:say(640,910,"Nº.:"+SF2->F2_DOC	,oFont09n)
	oPrt:Say(670,910,"Folha 1/1"		,oFont09n)

	//Codigo de Barras
	oPrt:Code128C(530,1150,NFE_CHV,28)
	oPrt:Say(570,1150,NFE_CHV,oFont12n)
	oPrt:Say(600,1150,"PROTOCOLO DE AUTENTICACAO DE USO:",oFont09n)
	oPrt:Say(630,1150,ALLTRIM(STR(PROTOCOLO))+" - "+DHREGEVEN,oFont12n)

	//Detalhes da NF
	oPrt:Box(700,010,800,nX)//Natureza de Operacao
	//Cnpj/IE/IE do ST
	oPrt:Box(800,010 ,900,nX)
	oPrt:Box(800,700 ,900,nx)//ie
	oPrt:Box(800,1400,900,nx)//cnpj

	oPrt:Box(1000,010 ,1100,nx)//detinatario e emitente
	oPrt:Box(1000,1400,1100,nX)//CNPJ
	oPrt:Box(1000,1800,1100,nX)//data de emissao

	oPrt:Box(1100,010 ,1200,nx)//endereco
	oPrt:Box(1100,900 ,1200,nx)//bairro
	oPrt:Box(1100,1400,1200,nx)//cep
	oPrt:Box(1100,1800,1200,nx)//data entrada/saida

	oPrt:Box(1200,010 ,1300,nx)//municipio
	oPrt:Box(1200,500 ,1300,nx)//fone/fax
	oPrt:Box(1200,1000,1300,nx)//uf
	oPrt:Box(1200,1400,1300,nx)//IE
	oPrt:Box(1200,1800,1300,nx)//hora de saida


	//Box do Texto da Carta
	oPrt:Box(1350,010,ny-300,nx)


	oPrt:Say(720,020,"NATUREZA DA OPERACAO:"	,oFont08n)
	oPrt:Say(760,020,F4_TEXTO					,oFont14b)

	oPrt:Say(820,020,"INSCRICAO ESTADUAL:"		,oFont08n)
	oPrt:say(860,020,SM0->M0_INSC							,oFont14b)
	oPrt:say(820,710,"INSCRICAO ESTADUAL DO SUBST. TRIBUTARIO:",oFont08n)
	oPrt:Say(820,1410,"CNPJ:"				 	,oFont08n)
	oPrt:Say(860,1410,SM0->M0_CGC				,oFont14b)

	oPrt:Say(950,020,"DESTINATARIO/REMETENTE"	,oFont09n)

	oPrt:Say(1020,020 ,"NOME/RAZAO SOCIAL:"		,oFont08n)
	oPrt:Say(1060,020 ,A1NOME					,oFont14b)
	oPrt:Say(1020,1420,"CNPJ/CPF:"		   		,oFont08n)
	oPrt:Say(1060,1420,A1CGC					,oFont14b)
	oPrt:Say(1020,1820,"DATA DA EMISSAO: " 		,oFont08n)
	oPrt:Say(1060,1820,DTOC(STOD(F2_EMISSAO))	,oFont14b)

	oPrt:Say(1120,020 ,"ENDERECO:"			,oFont08n)
	oPrt:Say(1160,020 ,A1END				,oFont14b)
	oPrt:Say(1120,920 ,"BAIRRO/DISTRITO:"	,oFont08n)
	oPrt:Say(1160,920 ,A1BAIRRO			,oFont14b)
	oPrt:Say(1120,1420,"CEP:"				,oFont08n)
	oPrt:Say(1160,1420,A1CEP				,oFont14b)
	oPrt:Say(1120,1820,"DATA ENTRADA/SAIDA:",oFont08n)
	//oPrt:Say(1160,1820,left(DHREGEVEN,10)					,oFont14b)//DHREGEVEN

	oPrt:Say(1220,020 ,"MUNICIPIO:"			,oFont08n)
	oPrt:Say(1260,020 ,A1MUN				,oFont14b)
	oPrt:Say(1220,520 ,"FONE/FAX:"			,oFont08n)
	//oPrt:Say(1220,520 ,A1TEL				,oFont14b)
	//FR - Flávia Rocha - Sigamat Consultoria - 14/03/2022 - Alteração: A impressão do telefone estava fora do box
	oPrt:Say(1260,520 ,A1TEL				,oFont14b)  
	//FR - Flávia Rocha - Sigamat Consultoria - 14/03/2022 - Alteração:
	oPrt:Say(1220,1020,"UF"					,oFont08n)
	oPrt:Say(1260,1020,A1EST				,oFont14b)
	oPrt:Say(1220,1420,"INSCRICAO ESTADUAL:",oFont08n)
	oPrt:Say(1260,1420,A1INSCR				,oFont14b)
	oPrt:Say(1220,1820,"HORA DE SAIDA"	 	,oFont08n)
	oPrt:Say(1260,1820,SubStr(DHREGEVEN,12,5)					,oFont14b)

	oPrt:Say(1370,020 ,"A Carta de Correção é disciplinada pelo § 1º-A do art. 7º do Convênio S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularização de erro ocorrido na emissão de documento fiscal, desde que o",oFont09n)
	oPrt:Say(1400,020 ,"erro não esteja relacionado com: I - as variáveis que determinam o valor do imposto tais como: base de cálculo, alíquota, diferença de preço, quantidade, valor da operação ou da prestação; II - a correção ",oFont09n)
	oPrt:Say(1430,020 ,"de dados cadastrais que implique mudança do remetente ou do destinatário; III - a data de emissão ou de saída.",oFont09n)

	SPEDXML := Alltrim(SPEDXML1)+Alltrim(SPEDXML2)+Alltrim(SPEDXML3)+Alltrim(SPEDXML4)
	MemoWrite("\arquivos\CCE\CCE.XML",SPEDXML)

	IF !File("\arquivos\CCE\CCE.XML")
		Alert("Nota Fiscal sem carta de correcao gerada!")
		Return
	EndiF

	//+--------------------------------------------------------------------+
	//|Abre o XML e monta a estrutura de arvore                            |
	//+--------------------------------------------------------------------+
	oXML:=XmlParserFile("\arquivos\CCE\CCE.XML","_",@cError,@cWarning)


	//+--------------------------------------------------------------------+
	//|Exibe menssagem de erro                                             |
	//+--------------------------------------------------------------------+

	If !Empty(cError) .OR. !Empty(cWarning)
		MsgInfo(cError)
		MsgInfo(cWarning)
		Alert("Verifique se Carta de Corracao foi Gerada!")
		Return
	EndIf

	//+--------------------------------------------------------------------+
	//|Texto da Carta de Correcao                                          |
	//+--------------------------------------------------------------------+
	cTexto:= oXML:_ENVEVENTO:_EVENTO:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT

	oPrt:Say(1500,020,"CARTA DE CORREÇÃO:",oFont16b)

	For i:=1 to MlCount(cTexto,100)
		oPrt:Say(1600+(50*i),020,MemoLine(cTexto,100,i),oFont14b)
	Next

	TCCE->(DBCLOSEAREA())
	oPrt:EndPage()

	oPrt:Print()

RETURN


/*/{Protheus.doc} CCEII_E
Gera Documento Carta Correção - Notas Fiscais de Entrada. Clone do CCEII_S com adaptações
@type function
@version 12.1.27
@author Ricardo Munhoz
@since 09/06/2022
/*/
Static Function CCEII_E
	Local nX:=0
	Local nY:=0
	Local i

	//+----------------------------------------------+
	//|Objetos do XML                                |
	//+----------------------------------------------+
	Private oXML
	Private cError	:=""
	Private cWarning:=""

	//+----------------------------------------------------------------+
	//|DEFINICAO DE FONTES                                             |
	//+----------------------------------------------------------------+
	PRIVATE oFont07n    :=TFont():new("Arial",,-07,.F.,,,,,,.F.,.F.)
	PRIVATE oFont07b    :=TFont():new("Arial",,-07,.T.,,,,,,.F.,.F.)
	PRIVATE oFont08n    :=TFont():new("Arial",,-08,.F.,,,,,,.F.,.F.)
	PRIVATE oFont08b    :=TFont():new("Arial",,-08,.T.,,,,,,.F.,.F.)
	PRIVATE oFont09n    :=TFont():new("Arial",,-09,.F.,,,,,,.F.,.F.)
	PRIVATE oFont09b    :=TFont():new("Arial",,-09,.T.,,,,,,.F.,.F.)
	PRIVATE oFont10n    :=TFont():new("Arial",,-10,.F.,,,,,,.F.,.F.)
	PRIVATE oFont10b    :=TFont():new("Arial",,-10,.T.,,,,,,.F.,.F.)
	PRIVATE oFont12n    :=TFont():new("Arial",,-12,.F.,,,,,,.F.,.F.)
	PRIVATE oFont12b    :=TFont():new("Times New Roman",,-12,.T.,,,,,,.F.,.F.)
	PRIVATE oFont14n    :=TFont():new("Arial",,-14,.F.,,,,,,.F.,.F.)
	PRIVATE oFont14b    :=TFont():new("Arial",,-14,.T.,,,,,,.F.,.F.)
	PRIVATE oFont16n    :=TFont():new("Arial",,-16,.F.,,,,,,.F.,.F.)
	PRIVATE oFont16b    :=TFont():new("Arial",,-16,.T.,,,,,,.F.,.F.)
	PRIVATE oFont18n    :=TFont():new("Arial",,-18,.F.,,,,,,.F.,.F.)
	PRIVATE oFont18b    :=TFont():new("Arial",,-18,.T.,,,,,,.F.,.F.)
	PRIVATE oFont20n    :=TFont():new("Arial",,-20,.F.,,,,,,.F.,.F.)
	PRIVATE oFont20b    :=TFont():new("Arial",,-20,.T.,,,,,,.F.,.F.)
	PRIVATE SPEDXML := ""

	//+---------------------------------------------------------------------------
	//| Monta query de selecao dos Dados
	//+---------------------------------------------------------------------------
	cQuery:=""
	cQuery+= "SELECT D1_TES,F1_FORNECE,F1_LOJA,F1_DOC,F1_SERIE,F1_TIPO,F4_TEXTO,NFE_CHV,PROTOCOLO,F1_HORA,F1_EMISSAO,DHREGEVEN "
	cQuery+= ",UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,1)) SPEDXML1,UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,2001)) SPEDXML2 "
	cQuery+= ",UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,4001)) SPEDXML3,UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,6001)) SPEDXML4  "
	cQuery+= "FROM SPED154 S154 INNER JOIN " + RetSqlName("SF1")+"  SF1 ON F1_CHVNFE=NFE_CHV INNER JOIN " + RetSqlName("SD1")+" SD1 ON D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE "
	cQuery+= "INNER JOIN " + RetSqlName("SF4")+" SF4 ON F4_CODIGO=D1_TES WHERE  F1_DOC='" + SF1->F1_DOC + "' AND S154.CSTATEVEN='135' AND F1_FILIAL='" + FWxFilial("SF1") + "' AND D1_FILIAL='" + FWxFilial("SD1") + "' "
	cQuery+= "AND F4_FILIAL='" + FWxFilial("SF4") + "' AND SF1.D_E_L_E_T_=' ' AND SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' ' AND ROWNUM = 1 "
	cQuery+= "GROUP BY D1_TES,F1_FORNECE,F1_LOJA,F1_DOC,F1_SERIE,F1_TIPO, F4_TEXTO,NFE_CHV,PROTOCOLO,DHREGEVEN,F1_HORA,F1_EMISSAO "
	cQuery+= ", UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,1)), UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,2001)) "
	cQuery+= ", UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,4001)), UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,6001)) "
	cQuery+= "ORDER BY  PROTOCOLO DESC "

	cQuery := ChangeQuery(cQuery)

	If SELECT("TCCE")>0
		TCCE->(DBCLOSEAREA())
	ENDIF

	tcquery cquery new alias "TCCE"
	DBSELECTAREA("TCCE")
	DBGOTOP()

	If F1_TIPO=="D"

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SA1")+TCCE->F1_FORNECE+TCCE->F1_LOJA)

		A1NOME:=A1_NOME
		A1CGC:=A1_CGC
		A1INSCR:=A1_INSCR
		A1END:=A1_END
		A1BAIRRO:=A1_BAIRRO
		A1CEP:=A1_CEP
		A1MUN:=A1_MUN
		A1TEL:=A1_TEL
		A1EST:=A1_EST

	Else

		DbSelectArea("SA2")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SA2")+TCCE->F1_FORNECE+TCCE->F1_LOJA)

		A2NOME:=A2_NOME
		A2CGC:=A2_CGC
		A2INSCR:=A2_INSCR
		A2END:=A2_END
		A2BAIRRO:=A2_BAIRRO
		A2CEP:=A2_CEP
		A2MUN:=A2_MUN
		A2TEL:=A2_TEL
		A2EST:=A2_EST
	EndIf

	DBSELECTAREA("TCCE")
	If Eof()
		MsgInfo("Carta de Correcao Eletronica nao Encontrada")
		Return
	EndIf

	// ----------------------------------------------
	// Inicializa objeto de impressao
	// ----------------------------------------------

	oPrt:=FWMsPrinter():New("DCCE_"+NFE_CHV,IMP_PDF)

	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	MakeDir("C:\ARQUIVOS_PROTHEUS\CCE\")   //forca a imprimir em uma pasta especifica
	oPrt:cPathPDF:="C:\ARQUIVOS_PROTHEUS\CCE\"
	oPrt:SetViewPDF(.t.)

	//+---------------------------------------------
	//|Configuracao de Impressao
	//+---------------------------------------------
	oPrt:SetResolution(78) //O Mesmo tamanho estipulado para a Danfe
	oPrt:SetPortrait()
	oPrt:SetPaperSize(DMPAPER_A4)
	oPrt:SetMargin(60,60,60,60)


	// ----------------------------------------------
	// Configuracao de resolucao de Pagina
	// ----------------------------------------------
	nY:=oPrt:nVertRes() 	//Resolucao vertical
	nX:=oprt:nHorzRes()-200	//Resulucao Horizontal

	oPrt:StartPage()    //Inicia uma nova Pagina

	//bOX DO TOPO DE ASSINATURA
	oPrt:Box(100,010,200,nX-400)	//Dados do Cliente
	oPrt:Box(200,010,300,nX-400)	//Linha 2 Assinatura
	oPrt:Box(200,010,300,300)	   	//Data de Recebimento
	oPrt:Box(100,nX-400,300,nX)		//Numero da Nota

	oPrt:Say(140, 020, "RECEBEMOS DE "+ALLTRIM(SM0->M0_NOMECOM)+" OS PRODUTOS CONSTANTES DA NOTA FISCAL ELETRONICA", oFont12n)
	oPrt:Say(220, 020, "DATA DE RECEBIMENTO", oFont09N)
	oPrt:Say(220, 320, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont09N)
	oPrt:Say(130,(nX-400)+100,"NF-e",oFont14b)
	oPrt:Say(200,(nx-400)+20,SF2->F2_DOC+"-"+SF2->F2_SERIE,oFont18N)


	//Box Informacoes da CCe
	oPrt:Box(410,010,700,nX)
	oPrt:Box(410,010,700,600)//Caixa do Logo
	oPrt:Box(410,500,700,400)//Caixa Inf da Empresa
	oPrt:Box(410,900,700,200)//Caixa Inf da Nota
	oPrt:Box(410,1100,700,nx)//Cod de Barras chave de acesso e protocolo
	oPrt:Box(550,1050,580,1070)

	oPrt:SayBitmap(520,020,"lgrl01.bmp",150,100)    //Logo


	//Informacoes da empresa

	DbSelectArea("SM0")

	oPrt:Say(440,250,SM0->M0_NOMECOM	,ofont14B)
	oPrt:Say(490,250,SM0->M0_ENDENT	,oFont09n)
	oPrt:Say(520,250,SM0->M0_BAIRENT	,oFont09n)
	oPrt:Say(550,250,SM0->M0_CEPENT		,oFont09n)
	oPrt:Say(580,250,ALLTRIM(SM0->M0_CIDENT)+" "+SM0->M0_ESTENT,oFont09n)

	DBSELECTAREA("TCCE")
	//QUADRO INFORMACAOES DA DANFE
	oPrt:Say(440,910,"DACCe"				,oFont14B)
	oPrt:Say(460,910,"Documeto Auxiliar "	,oFont08n)
	oPrt:Say(490,910,"da Carta de "			,oFont08n)
	oPrt:Say(520,910,"Correção Eletrônica"	,oFont08n)

	oPrt:Say(550,910,"0-Entrada"		,oFont09n)
	oPrt:Say(580,910,"1-Saida"			,oFont09n)
	oPrt:say(570,1050,"0"				,oFont09n)
	oPrt:Say(610,910,"Serie :"+SF1->F1_SERIE		,oFont09n)
	oPrt:say(640,910,"Nº.:"+SF1->F1_DOC	,oFont09n)
	oPrt:Say(670,910,"Folha 1/1"		,oFont09n)

	//Codigo de Barras
	oPrt:Code128C(530,1150,NFE_CHV,28)
	oPrt:Say(570,1150,NFE_CHV,oFont12n)
	oPrt:Say(600,1150,"PROTOCOLO DE AUTENTICACAO DE USO:",oFont09n)
	oPrt:Say(630,1150,ALLTRIM(STR(PROTOCOLO))+" - "+DHREGEVEN,oFont12n)

	//Detalhes da NF
	oPrt:Box(700,010,800,nX)//Natureza de Operacao
	//Cnpj/IE/IE do ST
	oPrt:Box(800,010 ,900,nX)
	oPrt:Box(800,700 ,900,nx)//ie
	oPrt:Box(800,1400,900,nx)//cnpj

	oPrt:Box(1000,010 ,1100,nx)//detinatario e emitente
	oPrt:Box(1000,1400,1100,nX)//CNPJ
	oPrt:Box(1000,1800,1100,nX)//data de emissao

	oPrt:Box(1100,010 ,1200,nx)//endereco
	oPrt:Box(1100,900 ,1200,nx)//bairro
	oPrt:Box(1100,1400,1200,nx)//cep
	oPrt:Box(1100,1800,1200,nx)//data entrada/saida

	oPrt:Box(1200,010 ,1300,nx)//municipio
	oPrt:Box(1200,500 ,1300,nx)//fone/fax
	oPrt:Box(1200,1000,1300,nx)//uf
	oPrt:Box(1200,1400,1300,nx)//IE
	oPrt:Box(1200,1800,1300,nx)//hora de saida


	//Box do Texto da Carta
	oPrt:Box(1350,010,ny-300,nx)


	oPrt:Say(720,020,"NATUREZA DA OPERACAO:"	,oFont08n)
	oPrt:Say(760,020,F4_TEXTO					,oFont14b)

	oPrt:Say(820,020,"INSCRICAO ESTADUAL:"		,oFont08n)
	oPrt:say(860,020,SM0->M0_INSC							,oFont14b)
	oPrt:say(820,710,"INSCRICAO ESTADUAL DO SUBST. TRIBUTARIO:",oFont08n)
	oPrt:Say(820,1410,"CNPJ:"				 	,oFont08n)
	oPrt:Say(860,1410,SM0->M0_CGC				,oFont14b)

	oPrt:Say(950,020,"DESTINATARIO/REMETENTE"	,oFont09n)

	oPrt:Say(1020,020 ,"NOME/RAZAO SOCIAL:"		,oFont08n)
	oPrt:Say(1060,020 ,A2NOME					,oFont14b)
	oPrt:Say(1020,1420,"CNPJ/CPF:"		   		,oFont08n)
	oPrt:Say(1060,1420,A2CGC					,oFont14b)
	oPrt:Say(1020,1820,"DATA DA EMISSAO: " 		,oFont08n)
	oPrt:Say(1060,1820,DTOC(STOD(F1_EMISSAO))	,oFont14b)

	oPrt:Say(1120,020 ,"ENDERECO:"			,oFont08n)
	oPrt:Say(1160,020 ,A2END				,oFont14b)
	oPrt:Say(1120,920 ,"BAIRRO/DISTRITO:"	,oFont08n)
	oPrt:Say(1160,920 ,A2BAIRRO			,oFont14b)
	oPrt:Say(1120,1420,"CEP:"				,oFont08n)
	oPrt:Say(1160,1420,A2CEP				,oFont14b)
	oPrt:Say(1120,1820,"DATA ENTRADA/SAIDA:",oFont08n)
	//oPrt:Say(1160,1820,left(DHREGEVEN,10)					,oFont14b)//DHREGEVEN

	oPrt:Say(1220,020 ,"MUNICIPIO:"			,oFont08n)
	oPrt:Say(1260,020 ,A2MUN				,oFont14b)
	oPrt:Say(1220,520 ,"FONE/FAX:"			,oFont08n)
	//oPrt:Say(1220,520 ,A1TEL				,oFont14b)
	//FR - Flávia Rocha - Sigamat Consultoria - 14/03/2022 - Alteração: A impressão do telefone estava fora do box
	oPrt:Say(1260,520 ,A2TEL				,oFont14b)  
	//FR - Flávia Rocha - Sigamat Consultoria - 14/03/2022 - Alteração:
	oPrt:Say(1220,1020,"UF"					,oFont08n)
	oPrt:Say(1260,1020,A2EST				,oFont14b)
	oPrt:Say(1220,1420,"INSCRICAO ESTADUAL:",oFont08n)
	oPrt:Say(1260,1420,A2INSCR				,oFont14b)
	oPrt:Say(1220,1820,"HORA DE SAIDA"	 	,oFont08n)
	oPrt:Say(1260,1820,SubStr(DHREGEVEN,12,5)					,oFont14b)

	oPrt:Say(1370,020 ,"A Carta de Correção é disciplinada pelo § 1º-A do art. 7º do Convênio S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularização de erro ocorrido na emissão de documento fiscal, desde que o",oFont09n)
	oPrt:Say(1400,020 ,"erro não esteja relacionado com: I - as variáveis que determinam o valor do imposto tais como: base de cálculo, alíquota, diferença de preço, quantidade, valor da operação ou da prestação; II - a correção ",oFont09n)
	oPrt:Say(1430,020 ,"de dados cadastrais que implique mudança do remetente ou do destinatário; III - a data de emissão ou de saída.",oFont09n)

	SPEDXML := Alltrim(SPEDXML1)+Alltrim(SPEDXML2)+Alltrim(SPEDXML3)+Alltrim(SPEDXML4)
	MemoWrite("\arquivos\CCE\CCE.XML",SPEDXML)

	IF !File("\arquivos\CCE\CCE.XML")
		Alert("Nota Fiscal sem carta de correcao gerada!")
		Return
	EndiF

	//+--------------------------------------------------------------------+
	//|Abre o XML e monta a estrutura de arvore                            |
	//+--------------------------------------------------------------------+
	oXML:=XmlParserFile("\arquivos\CCE\CCE.XML","_",@cError,@cWarning)


	//+--------------------------------------------------------------------+
	//|Exibe menssagem de erro                                             |
	//+--------------------------------------------------------------------+

	If !Empty(cError) .OR. !Empty(cWarning)
		MsgInfo(cError)
		MsgInfo(cWarning)
		Alert("Verifique se Carta de Corracao foi Gerada!")
		Return
	EndIf

	//+--------------------------------------------------------------------+
	//|Texto da Carta de Correcao                                          |
	//+--------------------------------------------------------------------+
	cTexto:= oXML:_ENVEVENTO:_EVENTO:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT

	oPrt:Say(1500,020,"CARTA DE CORREÇÃO:",oFont16b)

	For i:=1 to MlCount(cTexto,100)
		oPrt:Say(1600+(50*i),020,MemoLine(cTexto,100,i),oFont14b)
	Next

	TCCE->(DBCLOSEAREA())
	oPrt:EndPage()

	oPrt:Print()

RETURN
