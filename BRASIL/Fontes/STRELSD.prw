#Include "Protheus.CH"
#include "fwmvcdef.ch"
#include "topconn.ch"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

Static oFont07	:= TFont():New("Arial",,05,,.F.,,,,.T.,.F.)
Static oFont07N	:= TFont():New("Arial",,05,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont09	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont09N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont10	:= TFont():New("Arial",,10,,.F.,,,,.T.,.F.)
Static oFont10N	:= TFont():New("Arial",,10,,.T.,,,,.T.,.F.)
Static oFont11	:= TFont():New("Arial",,11,,.F.,,,,.T.,.F.)
Static oFont11N	:= TFont():New("Arial",,11,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",,12,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",,16,,.T.,,,,.T.,.F.)

Static nClrVerd := RGB(035,142,035)
Static nClrVerm := RGB(217,017,027)
Static nClrBran := RGB(255,255,255)


/*/{Protheus.doc} User Function STRELSD
    (long_description)
    Solicitação de Desenvolvimento
	@Type function
    @author user
    Valdemir Rabelo - SigaMat
    @since 23/03/2020
    u_STRELSD()
/*/
User Function STRELSD(paCols,oGetDad1, nTotItem, nItem, oObjPrn, _aSds)
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
	Local aAreaPP8          := GetArea()
	Local cLocal            := "\spool"
	Local cAtend            := PP7->PP7_CODIGO
	Private oBshCClaro      := TBrush():New(,CLR_HGRAY) // Cinza Claro
	Private nPag            := 1
	Private oPrinter
	Private oFont12N        := TFont():New("Arial",,12,,.T.,,,,.T.,.F.)
	Private nLin            := 15
	Private nCol            := 0
	Default paCols          := {}
	Default oGetDad1        := Nil
	Default nTotItem        := 0
	Default nItem           := 0
	Default oObjPrn         := Nil
	Default _aSds           := {}

	if oGetDad1 == nil
		if Len(paCols) > 0
			cAtend := PP7->PP7_CODIGO
			cItem  := paCols[n, 1]
		else
			cAtend := PP8->PP8_CODIGO
			cItem  := PP8->PP8_ITEM
		endif
		if PP7->( !dbSeek(xFilial('PP7')+PP8->PP8_CODIGO) )
			Alert("Não encontrou item da Unicom")
			return
		Endif
	else
		cAtend := PP7->PP7_CODIGO
		cItem  := oGetDad1:aCols[oGetDad1:nAt][2]
	endif

	dbSelectArea("PP8")
	dbSetOrder(1)
	if !dbSeek(xFilial("PP8")+cAtend+cItem)
		Alert("Não encontrou item da Unicom")
		return
	Endif

	DBSelectArea("Z67")
	dbSetOrder(1)
	if !dbSeek(XFilial('Z67')+cAtend+cItem)
		Alert("As questões para ficha SD não foram preenchidas pelo comercial (Z67)")
		return
	Endif

	MakeDir("C:\Temp")    // Cria pasta temp

	if ((Len(paCols) > 0) .or. oGetDad1 != nil) .or. ((nTotItem > 0) .and. nItem==1)
		oPrinter := FWMSPrinter():New("STRELSD_"+cAtend+".PDF",IMP_PDF, lAdjustToLegacy,cLocal,lDisableSetup, , , , , , .F., .T. )

		if File("C:\Temp\STRELSD_"+cAtend+".PDF")   // Verifico se foi criado
			FErase("C:\Temp\STRELSD_"+cAtend+".PDF")
		endif

		oPrinter:SetPortrait()
		oPrinter:SetResolution(72)
		oPrinter:SetPaperSize(DMPAPER_A4)	// A4 210mm x 297mm  620 x 876
		oPrinter:cPathPDF :="C:\Temp\"
	else
		oPrinter := oObjPrn
	Endif

	Processa( {||  InitProc(nItem) }, "Imprimindo Solicitação de Desenvolvimento, Aguarde...")

	if ((Len(paCols) > 0) .or. oGetDad1 != nil) .or. ((nTotItem > 0) .and. nItem==nTotItem)
		oPrinter:Preview()
		FreeObj(oPrinter)
		oPrinter := Nil
		// Envia WF
		if (nItem==nTotItem)
			EnvWFLib(_aSds, "STRELSD_"+cAtend+".PDF", "C:\Temp\")
		Endif
	Endif

	RestArea( aAreaPP8 )

Return oPrinter




Static Function InitProc(nItem)
	Local cOPCAOI  := ""
	Local cOPCAOE  := ""
	Local cEngenha := IF(Z67->Z67_ENGENH=="D", "DESENVOLVIMENTO","PRODUTO")
	Local cTipoVen := ""
	Local cLinha   := ""
	Local nAtual   := 0
	Local aPosicao := {}
	Local cEspecif := Z67->Z67_ESPECI
	Local aEspecif := u_vMemoToA(cEspecif, 200, , .T.)
	Local nLEsp    := Len(aEspecif) * 14
	Local aRecebe  := Separa(Alltrim(Z67->Z67_POSICAO),"/")
	Local aLinha   := {}
	Default nItem  := 0

	aAdd(aPosicao, {.f., "001", "Prensa Cabo"})
	aAdd(aPosicao, {.f., "002", "Adaptador"})
	aAdd(aPosicao, {.f., "003", "Somente Furação"})
	aAdd(aPosicao, {.f., "004", "Tampão"})
	aAdd(aPosicao, {.f., "005", "Será feito pelo cliente"})
	aAdd(aPosicao, {.f., "006", "Entrada Flange - Superior"})
	aAdd(aPosicao, {.f., "007", "Entrada Flange - Inferior"})

	SA1->( dbSeek(xFilial('SA1')+PP7->PP7_CLIENT+PP7->PP7_LOJA) )
	SA3->( dbSeek(xFilial('SA3')+PP7->PP7_VEND) )
	if Left(PP7->PP7_VEND,1)=="I"
		cTipoVen := "( INTERNO )"
	else
		cTipoVen := "( EXTERNO )"
	endif

	Cabec01(nItem)      // @nLin,nCol,

	oPrinter:Box(nLin-10, 12, nLin+48, 520)
	oPrinter:Say (nLin, nCol + 015, "ENGENHARIA:  ",oFont12 )
	oPrinter:Say (nLin, nCol + 080, cEngenha,       oFont12N )
	oPrinter:Say (nLin, nCol + 190, "VENDEDOR: ",  oFont12 )
	oPrinter:Say (nLin, nCol + 250, Left(Alltrim(SA3->A3_NOME),25)+" "+cTipoVen,  oFont12N )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "DATA:  ",oFont12 )
	oPrinter:Say (nLin, nCol + 045,  Dtoc(PP7->PP7_EMISSA), oFont12N )
	oPrinter:Say (nLin, nCol + 100,  "CLIENTE: ",oFont12 )
	oPrinter:Say (nLin, nCol + 150,  LEFT(SA1->A1_NOME,30), oFont12N )
	oPrinter:Say (nLin, nCol + 430,  "ITEM:    ",oFont12 )
	oPrinter:Say (nLin, nCol + 460,  PP8->PP8_ITEM, oFont12N )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "CONTATO: ",oFont12 )
	oPrinter:Say (nLin, nCol + 045,  SA1->A1_CONTATO, oFont12N )
	oPrinter:Say (nLin, nCol + 160,  "DEPTO:   ",oFont12 )
	oPrinter:Say (nLin, nCol + 250,  "FONE:    ",oFont12 )
	oPrinter:Say (nLin, nCol + 285,  SA1->A1_TEL, oFont12N )
	oPrinter:Say (nLin, nCol + 430,  "PEDIDO:  ",oFont12 )
	oPrinter:Say (nLin, nCol + 460,  PP7->PP7_PEDIDO, oFont12N )
	nLin += 16
	oPrinter:Box(nLin-10, 12, nLin+nLEsp+10, 520)
	oPrinter:Say(nLin, nCol + 015,  "ESPECIFICAÇÕES TÉCNICA: ", oFont12 )
	nLin += 14
	//Percorrendo as linhas geradas
	if Len(aEspecif) > 0
		For nAtual := 1 To Len(aEspecif)
			oPrinter:Say(nLin, 015, aEspecif[nAtual], oFont12N)
			nLin += 14
		Next
	else
		nLin += 14
		oPrinter:Line(nLin,15,nLin, 497)
		nLin += 14
		oPrinter:Line(nLin,15,nLin, 497)
		nLin += 24
	endif

	if Len(aRecebe) > 0
		nPosLin  := 0
		cLinha   := "POSIÇÃO SÃO: "
		For nAtual := 1 to Len(aRecebe)
			nPosLin := aScan(aPosicao, { |X| X[2]==aRecebe[nAtual]})
			if nAtual > 1
				cLinha += ", "
			endif
			cLinha += aPosicao[nPosLin][3]
		Next
		aLinha := u_vMemoToA(cLinha, 200, , .T.)
	endif
	nAj := 0
	if Len(aLinha) > 1
		nAj := ( Len(aLinha) * 14 )
	else
		nAj := 80
	endif
	oPrinter:Box(nLin-10, 12, nLin+nAj, 520)
	oPrinter:Say (nLin, nCol + 015,  "POSIÇÃO DE ENTRADA / SAÍDA DE ALIMENTAÇÃO: ",oFont12 )
	nLin += 14
	if Len(aLinha) > 0
		For nAtual := 1 to Len(aLinha)
			oPrinter:Say (nLin, nCol + 015,  aLinha[nAtual],    oFont12N )
			nLin += 14
		Next
	else
		oPrinter:Say (nLin, nCol + 015,  "[   ] PRENSA CABO",    oFont12 )
		oPrinter:Say (nLin, nCol + 250,  "ENTRADA ( FLANGE )",   oFont12 )
		nLin += 14
		oPrinter:Say (nLin, nCol + 015,  "[   ] ADAPTADOR",      oFont12 )
		oPrinter:Say (nLin, nCol + 250,  "[   ] SUPERIOR",       oFont12 )
		nLin += 14
		oPrinter:Say (nLin, nCol + 015,  "[   ] SOMENTE FURAÇÃO",oFont12 )
		oPrinter:Say (nLin, nCol + 250,  "[   ] INFERIOR",       oFont12 )
		nLin += 14
		oPrinter:Say (nLin, nCol + 015,  "[   ] TAMPÃO",         oFont12 )
		nLin += 14
		oPrinter:Say (nLin, nCol + 015,  "[   ] SERÁ FEITO PELO CLIENTE", oFont12 )
		nLin += 24
	endif

	oPrinter:Box(nLin-10, 12, nLin+66, 520)
	oPrinter:Say (nLin, nCol + 015,  "CLIENTE FORNECEU ESQUEMA ELÉTRICO DE LIGAÇÃO / UNIFILAR: ", oFont12 )
	oPrinter:Say (nLin, nCol + 325,  IF(Z67->Z67_FORELE=="S","SIM","NÃO"), oFont12N )
	nLin += 14
	oPrinter:Say (nLin+5, nCol + 015,  "PREENCHER ESTE CAMPO SE NÃO FOR  FORNECIDO O DIAGRAMA UNIFILAR:", oFont12N )
	nLin += 20
	oPrinter:Say (nLin, nCol + 015,  "TENSÃO DE ALIMENTAÇÃO DE ENTRADA: ", oFont12 )
	oPrinter:Say (nLin, nCol + 210,  Z67->Z67_TALENT, oFont12N )
	oPrinter:Say (nLin, nCol + 280,  "( V ) CORRENTE NOMIAL: ", oFont12 )
	oPrinter:Say (nLin, nCol + 410,  Z67->Z67_CORNOM, oFont12N )
	oPrinter:Say (nLin, nCol + 460,  "( A )",         oFont12 )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "BITOLA DOS CONDUTORES DE ENTRADA: ", oFont12 )
	oPrinter:Say (nLin, nCol + 210,   Z67->Z67_BITENT, oFont12N )
	oPrinter:Say (nLin, nCol + 280,  "( mm² ) COM INTERLIGAÇÃO: ",          oFont12 )
	oPrinter:Say (nLin, nCol + 410,  IF(Z67->Z67_INTERL=="S","SIM","NÃO"), oFont12N )
	nLin += 24

	oPrinter:Box(nLin-10, 12, nLin+74, 520)
	oPrinter:Say (nLin, nCol + 015,  "LOCAL DE TRABALHO:", oFont12 )
	nLin += 20
	oPrinter:Say (nLin, nCol + 015, "AMBIENTE: ", oFont12 )
	oPrinter:Say (nLin, nCol + 070, if(Z67->Z67_AMBINT=="E","EXTERNO","INTERNO"), oFont12N )
	oPrinter:Say (nLin, nCol + 120, "GRAU DE PROTEÇÃO: IP ", oFont12 )
	oPrinter:Say (nLin, nCol + 240, Z67->Z67_GPRTIP, oFont12N )
	oPrinter:Say (nLin, nCol + 290, "TEMPERAT.TRABALHO:", oFont12 )
	oPrinter:Say (nLin, nCol + 420, Z67->Z67_TEMPER, oFont12N )
	oPrinter:Say (nLin, nCol + 460, " C", oFont12 )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "NECESSITA DE PROTEÇÃO UV: ",  oFont12 )
	oPrinter:Say (nLin, nCol + 160,  if(Z67->Z67_NPRTUV=="S","SIM","NÃO"),  oFont12N )
	oPrinter:Say (nLin, nCol + 290,  "QUANTO TEMPO: ",              oFont12 )
	oPrinter:Say (nLin, nCol + 370,  Z67->Z67_QTEMPO,  oFont12N )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "SUJEITO A EXPOSIÇÃO A MEIOS ÁCIDOS, SOLVENTES, OU OUTROS AGENTES QUÍMICOS:",          oFont12 )
	oPrinter:Say (nLin, nCol + 430,  IF(Z67->Z67_SUJEXP=="S","SIM","NÃO"),  oFont12N )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "SE SIM A QUAL TIPO :",  oFont12 )
	oPrinter:Say (nLin, nCol + 130,  Z67->Z67_QTIPO,          oFont12N )
	nLin += 22

	oPrinter:Box(nLin-10, 12, nLin+14, 520)
	oPrinter:Say (nLin, nCol + 015,  "AMOSTRAS:",        oFont12 )
	oPrinter:Say (nLin, nCol + 075,  IF(Z67->Z67_AMOSTR=="S","SIM","NÃO"),        oFont12N )
	nLin += 18

	oPrinter:Box(nLin-10, 12, nLin+40, 520)
	oPrinter:Say (nLin, nCol + 190,  "FORNECER DESENHO PARA:",          oFont12 )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "DEPARTAMENTO COMERCIAL: ",          oFont12 )
	oPrinter:Say (nLin, nCol + 160,  IF(Z67->Z67_DEPCML=="S","SIM","NÃO"),oFont12N )
	oPrinter:Say (nLin, nCol + 280,  "APROVAÇÃO DO CLIENTE:   ",          oFont12 )
	oPrinter:Say (nLin, nCol + 410,  IF(Z67->Z67_APVCLI=="S","SIM","NÃO"),oFont12N )
	nLin += 17
	oPrinter:Say (nLin, nCol + 015,  "PRAZO DE ENTREGA: ", oFont12 )
	oPrinter:Say (nLin, nCol + 120,  dtoc(Z67->Z67_PRZENT),      oFont12N )
	nLin += 20

	oPrinter:Box(nLin-10, 12, nLin+45, 520)
	oPrinter:Say (nLin, nCol + 015,  "ENVIADO PARA ENGENHARIA:", oFont12 )
	oPrinter:Say (nLin, nCol + 160,  Dtoc(Z67->Z67_ENVENG), oFont12N )
	oPrinter:Say (nLin, nCol + 325,  "ASSINATURA: ",  oFont12 )
	oPrinter:Say (nLin, nCol + 395,  Z67->Z67_ASSENV, oFont12N )
	nLin += 20
	oPrinter:Say (nLin, nCol + 015,  "RECEBIDA DA ENGENHARIA: ", oFont12 )
	oPrinter:Say (nLin, nCol + 160,  Dtoc(Z67->Z67_RECENG), oFont12N )
	oPrinter:Say (nLin, nCol + 325,  "ASSINATURA: ",  oFont12 )
	oPrinter:Say (nLin, nCol + 395,  Z67->Z67_ASSREC, oFont12N )
	nLin += 20

	oPrinter:Box(nLin-10, 12, nLin+5, 520)
	oPrinter:Say (nLin, nCol + 160,  "PARA PREENCHIMENTO DA ENGENHARIA DE PRODUTOS",          oFont12N )
	nLin += 14

	oPrinter:Box(nLin-10, 12, nLin+20, 520)
	oPrinter:Say (nLin+5, nCol + 015,  "RECEBIDA POR: ",        oFont12 )
	oPrinter:Say (nLin+5, nCol + 110,  Z67->Z67_RECPOR,         oFont12N )
	oPrinter:Say (nLin+5, nCol + 250,  "DATA: ",                oFont12 )
	oPrinter:Say (nLin+5, nCol + 280,  dtoc(Z67->Z67_DTPOR ),   oFont12N )
	oPrinter:Say (nLin+5, nCol + 430,  "HORA: ",                oFont12 )
	oPrinter:Say (nLin+5, nCol + 460,  Z67->Z67_HRPOR ,         oFont12N )
	nLin += 20
	cDESENV := ""
	IF Z67->Z67_DESENV == "1"
		cDESENV := "VIAVEL"
	ELSEIF Z67->Z67_DESENV == "2"
		cDESENV := "INVIAVEL"
	ELSE
		cDESENV := "VIAVEL COM RESTRIÇÃO"
	ENDIF
	oPrinter:Box(nLin-10, 12, nLin+100, 520)
	oPrinter:Say (nLin, nCol + 015,  "DESENVOLVIMENTO: ",          oFont12 )
	oPrinter:Say (nLin, nCol + 120,  cDESENV, oFont12N )
	nLin += 14
	oPrinter:Say (nLin, nCol + 015,  "RESTRIÇÕES: ",  oFont12 )
	oPrinter:Say (nLin, nCol + 120,  Z67->Z67_RESTIC, oFont12N )
	nLin += 18
	oPrinter:Say (nLin, nCol + 015,  "CÓDIGO CPD DO PRODUTO:", oFont11 )
	oPrinter:Say (nLin, nCol + 150,  Z67->Z67_CPDPRD, oFont11N )
	oPrinter:Say (nLin, nCol + 230,  "CÓDIGO DE VENDAS:", oFont11 )
	oPrinter:Say (nLin, nCol + 320,  Z67->Z67_CODVND, oFont11N )
	oPrinter:Say (nLin, nCol + 430,  "PS:", oFont11 )
	oPrinter:Say (nLin, nCol + 460,  Z67->Z67_PS, oFont11N )
	nLin += 20
	oPrinter:Say (nLin, nCol + 015,  "PRAZO DE DESENVOLVIMENTO: ", oFont11 )
	oPrinter:Say (nLin, nCol + 150,  DTOC(Z67->Z67_PRZDES), oFont11N )
	oPrinter:Say (nLin, nCol + 230,  "CONCLUSÃO:", oFont11 )
	oPrinter:Say (nLin, nCol + 310,  DTOC(Z67->Z67_CONCLU), oFont11N )
	oPrinter:Say (nLin, nCol + 430,  "HORA:", oFont11 )
	oPrinter:Say (nLin, nCol + 460,  Z67->Z67_HSCONC, oFont11N )
Return



/*
    Autor       : Valdemir Rabelo
    Descrição   : Impreme Cabeçalho
    Data        : 07/08/2019
*/
Static Function Cabec01(nItem)
	Local CorStatus
	Local nConta  := 0
	LOCAL cLogoD  := GetSrvProfString("Startpath","") + "lgrl"+cEmpAnt+".bmp"
	Default nItem := 0

	if nItem > 0
		nPag := nItem
	Endif

	nLin += 10
	// Titulo e Logo
	oPrinter:EndPage()
	oPrinter:StartPage()
	oPrinter:SayBitmap (nLin - 0010,nCol + 0012 ,cLogoD ,0068,0025)	                    // < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight]
	oPrinter:Say (nLin, nCol + 0130,"SOLICITAÇÃO DE DESENVOLVIMENTO - SD",oFont16N )
	oPrinter:Say (nLin, nCol + 0460,"Nº ", oFont16N )
	oPrinter:Say (nLin, nCol + 0477, PP7->PP7_CODIGO, oFont16 )
	oPrinter:Box(nLin+18, 12, nLin+35, 520)
	nLin += 19
	oPrinter:Say (nLin+10, nCol + 0130,"PARA PREENCHIMENTO DO DEPARTAMENTO COMERCIAL",oFont12N )
	oPrinter:Say (nLin-10, nCol + 0460,"PAGINA: ",oFont10N )
	oPrinter:Say (nLin-10, nCol + 0497, StrZero(nPag,3),oFont10 )
	nLin += 28
	nPag++

Return



/*/{Protheus.doc} EnvWFLib
description  Rotina que irá enviar WF da Liberação com Capa SD em anexo
@type function
@version 1.00  
@author Valdemir Jose
@since 06/05/2021
/*/
Static Function EnvWFLib(_aSds, pArquivo, pCaminho)
	Local _cEmail    := getmv("ST_UNCENGE")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND  ,"A3_EMAIL"))
	Local _cAssunto  := "Liberacao para Desenvolvimento - Engenharia"
	Local aPrior     :=  {"0=Extrema Urgência","1=Urgênte","2=Pouco Urgente","3=Normal","4=Média","5=Baixa"," "}
	Local nPrior     := aScan(aPrior, {|X| Left(X,1)==PP8->PP8_PRIOR})
	Local _nLin

	if len(_aSds) > 0

		_aMsg := {}

		Aadd( _aMsg , { "Atendimento: "     , PP8->PP8_CODIGO } )
		Aadd( _aMsg , { "Ocorrencia: "    	, "Liberacao para Desenvolvimento - Engenharia"  } )
		Aadd( _aMsg , { "Cliente: "         , PP7->PP7_NOME+' / '+PP7->PP7_CLIENT+'-'+PP7->PP7_LOJA } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Dt.Necessidade: "  , IIF(EMPTY(ALLTRIM(PP8->PP8_DTNEC)),dtoc(PP7->PP7_DTNEC),dtoc(PP8->PP8_DTNEC)) } )

		Aadd( _aMsg , { "Base: "          , Iif(PP8->PP8_BASE='1','SIM','NÃO')   } )
		Aadd( _aMsg , { "Prioridade: "    , aPrior[nPrior] } )				// Valdemir Rabelo 25/03/2020

		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

		// Definicao do texto/detalhe do email
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		cMsg += '<tr>'
		cMsg += '</tr>'
		For _nLin := 1 to Len(_aSds)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' +'ITEM:'+ _aSds[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aSds[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next

		// Definicao do rodape do email
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(Unicom)</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, "", _cAssunto, cMsg , {pArquivo}, pCaminho)

	Endif

Return
