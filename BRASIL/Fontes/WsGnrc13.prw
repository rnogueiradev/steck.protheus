#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ WsGnrc13 บAutor ณJonathan Schmidt Alves บ Data ณ28/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de chamadas das integracoes Totvs x Thomson:          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Modulos:                                                   บฑฑ
ฑฑบ          ณ Importacao/Cambio Importacao                               บฑฑ
ฑฑบ          ณ Exportacao/Cambio Exportacao                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Tipos de Processamento:                           WsGnrc13 บฑฑ
ฑฑบ          ณ Consultas: Consulta webservice Thomson e grava no Totvs    บฑฑ
ฑฑบ          ณ Inclusoes: Envia dados do Totvs para o Thomson             บฑฑ
ฑฑบ          ณ Processamentos: Realiza processamentos no Totvs            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function WsGnrc13()
Private oDlg01
Private oPnlTop
Private oPnlGD1
Private oPnlBot
Private oRadPrc
Private aHdr01 := {}
Private aCls01 := {}
Private oGetD1
Private cTitle := "WsGnrc13: TWOSOURCE Totvs x Thomson"
// Atualizacao da Integracao
Private oSayPrcInt
Private oCmbPrcInt
Private cCmbPrcInt := ""
Private aPrcInt := {}
Private aCmbPrcInt := {}
Private nRadPrc := 1
Private aRadPrc := { "Importacao", "Exportacao" }
Private nLineG01 := 0
// Pesquisa da Integracao
Private oSayPrcPsq
Private cSayPrcPsq := ""
Private oGetPrcPsq
Private cGetPrcPsq := Space(20)
// Cores GetDados 01
Private nC01C01 := RGB(199,199,199)	// Cinza
Private nC01S01 := RGB(141,141,141)	// Cinza Mais Escuro
Private nC01C02 := RGB(143,217,223) // Azul Acinzentado
// Cores Panels Folder 01
Private nClrTop := RGB(199,199,199)	// Cinza Padrao Mais Claro      *** Top
Private nClrGd1 := RGB(141,141,141)	// Cinza Padrao Escuro          *** GetDados
Private nClrBot := RGB(141,141,141)	// Cinza Padrao Escuro          *** Bottom
// Variaveis filiais
Private _cFilZT1 := xFilial("ZT1")
Private _cFilZT2 := xFilial("ZT2")
Private _cFilZTL := xFilial("ZTL")
Private _cFilZTN := xFilial("ZTN")
// Abertura das tabelas
DbSelectArea("ZT1")
ZT1->(DbSetOrder(1)) // ZT1_FILIAL + ZT1_CODIGO + ZT1_TIPINT
DbSelectArea("ZT2")
ZT2->(DbSetOrder(2)) // ZT2_FILIAL + ZT2_CODIGO + ZT2_CODITE
DbSelectArea("ZTN")
ZTN->(DbSetOrder(1)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_IDTRAN + ZTN_STATHO + ZTN_STATOT + ZTN_DTHRLG
DbSelectArea("ZTX")
ZTX->(DbSetOrder(1)) // ZTX_FILIAL + ZTX_IDECTB + ZTX_IDELAN + ZTX_STATOT + ZTX_DTHRLG
DbSelectArea("ZTY")
ZTY->(DbSetOrder(1)) // ZTY_FILIAL + ZTY_IDECTB + ZTY_IDELAN + ZTY_STATOT + ZTY_DTHRLG
DbSelectArea("ZTF")
ZTF->(DbSetOrder(1)) // ZTF_FILIAL + ZTF_CDSPID + ZTF_PROCES + ZTF_IDEPRO
DbSelectArea("ZTP")
ZTP->(DbSetOrder(1)) // ZTP_FILIAL + ZTP_CDIDSP
DEFINE MSDIALOG oDlg01 FROM 050,165 TO 442,743 TITLE cTitle Pixel
// Panel
oPnlTop	:= TPanel():New(000,000,,oDlg01,,,,,nClrTop,190,060,.F.,.F.) // Filtro
oPnlGd1	:= TPanel():New(060,000,,oDlg01,,,,,nClrGd1,370,180,.F.,.F.) // GetDados 01
// Logo
@004,195 BitMap Size 100,040 File "TwoSourceLogo.jpg" Of oDlg01 Pixel Stretch NoBorder
// Linha 01 Processo Importacao/Exportacao
oRadPrc := TRadMenu():New(002,015,aRadPrc, {|u| Iif(PCount() == 0, nRadPrc, nRadPrc := u) }, oPnlTop,, {|| LdsInteg( nRadPrc ) },,,,.T.,,200,12,,,,.T.)
oRadPrc:lHoriz := .T.
// Linha 02 Processo de Integracao
@017,003 SAY oSayPrcInt PROMPT "Integracao:" SIZE 040,010 Of oPnlTop Pixel
@015,042 MSCOMBOBOX oCmbPrcInt Var cCmbPrcInt ITEMS aCmbPrcInt SIZE 120,011 Of oPnlTop Pixel
oCmbPrcInt:bChange := {|| u_AskYesNo(3500,"PrcShw04","Recarregando...","","","","","REFRESH",.T.,.F.,{|| PrcLds04(.T.) }) }
// Linha 03
@030,003 SAY oSayPrcPsq Var cSayPrcPsq SIZE 090,011 Of oPnlTop Pixel
@028,042 MSGET oGetPrcPsq Var cGetPrcPsq SIZE 060,008 Of oPnlTop Pixel HASBUTTON
// Linha 04
@043,060 BUTTON oBtnPsq PROMPT "Pesquisar" Size 037,010 Pixel Of oPnlTop Action(PsqInteg()) // Carregamento
oBtnPsq:lVisible := .F.
@043,100 BUTTON oBtnPrc PROMPT "Processar" Size 037,010 Pixel Of oPnlTop Action(PrcInteg()) // Carregamento
// Carregamento do processo de integracao
LdsInteg( nRadPrc ) // 1=Importacao 2=Exportacao
aHdr01 := LoadsHdr( aPrcInt[ 01,01] ) // Carrego aHdr
aCls01 := LoadCols( aHdr01 ) // Criacao do aCls01
// GetDados
oGetD1 := MsNewGetDados():New(003,003,130,288,Nil,"AllwaysTrue()", "AllwaysTrue()" ,, /*aFldsAlt01*/ ,,,,,"AllwaysTrue()",oPnlGD1,@aHdr01,@aCls01)
oGetD1:oBrowse:SetBlkBackColor({|| GetDXClr("01", oGetD1:aCols, oGetD1:nAt, aHdr01) })
oGetD1:bChange := {|| nLineG01 := oGetD1:nAt, oGetD1:Refresh() }
oGetD1:oBrowse:lHScroll := .F.
// Carregamento do processo de integracao
LdsInteg( nRadPrc ) // 1=Importacao 2=Exportacao
ACTIVATE MSDIALOG oDlg01 CENTERED
Return

Static Function GetDXClr(cGet, aCols, nLine, aHdrs) // Cores GetDados 01/03
Local nClr := nC01C01 // Cinza Padrao Mais Claro
If nLine > 0 .And. nLine <= Len(aCols)
    If nLine == &("nLineG" + cGet) // Linha selecionada
        nClr := nC01S01
    Else
        nClr := nC01C01
    EndIf
EndIf
Return nClr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ LdsInteg บAutor ณJonathan Schmidt Alves บ Data ณ04/10/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recarregando Conmbo processos de integracao.               บฑฑ
ฑฑบ          ณ Chamada para o Recarregamento do GetDados.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LdsInteg(nRad)
Local _w1
aPrcInt := {}
// Carregamento das integracoes
//                { Cod Intg,    Desc Integ,                                                                                                  Funcao Processamento,       Pesquisa,  Tamanho, Field Integracao }
//                {       01,            02,                                                                                                                    03,             04,       05,               06 }
aAdd(aPrcInt,     { "190301", "Atualiza Moedas",            {|| u_WsGnrc00("PKG_SFW_MOEDA.PRC_MOEDA_TAXA",      							"03", "P", "DSV", 2) },             "",       00,      ""          })
aAdd(aPrcInt,     { "210101", "Consulta Notificacoes",      {|| u_WsGnrc00("PKG_SFW_OIFEXPORT",	            /*ZTN*/							"01", "P", "DSV", 2) },             "",       00,      ""          })
aAdd(aPrcInt,     { "210401", "Atualiza Status Notif",      {|| u_WsGnrc00("PKG_SFW_OIFEXPORT",             /*ZTN*/							"04", "P", "DSV", 2) },             "",       00,      ""          })
If nRad == 1 // 1=Importacao
    // Carregamento das integracoes
    //            { Cod Intg,    Desc Integ,                                                                                                  Funcao Processamento,       Pesquisa,  Tamanho, Field Integracao }
    //            {       01,            02,                                                                                                                    03,             04,       05,               06 }
    aAdd(aPrcInt, { "330301", "Inclusao Pedido Importacao", {|| u_WsGnrc00("PKG_IS_API_ORDEM_IMPORTACAO.PRC_IS_PROCESSA_ORDEM_IMP",		    "03", "P", "DSV", 2) },      "Pedido:",       15,      "_FIELD2"   })

    aAdd(aPrcInt, { "350101", "Consulta Notif Trans/Compro",{|| u_WsGnrc00("PKG_PRC_FATURA_IMP",			/*6059 e 6060*/					"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "3503__", "Transito/Baixa Tran/Pagar",  {|| u_WsGnrc00("WsRc3503",                      /*6059 e 6060 NF*/                "",  "",    "", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "3504__", "Atualizacao do Compromisso", {|| u_WsGnrc00("WsRc3504",                      /*6060 atualiza data*/            "",  "",    "", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "370101", "Consulta Notif Nota Import",	{|| u_WsGnrc00("PKG_SFW_NOTAFISCAL_NFENFC",	    /*6002*/						"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "3703__", "Inclusao Nota Fiscal Import",{|| u_WsGnrc00("WsRc3703",                      /*6002*/                          "",  "",    "", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "370701", "Retorno NF Import",          {|| u_WsGnrc00("PKG_BS_API_RETORNO_NF",		    /*6002 Retorno da NF Import*/	"03", "P", "DSV", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "380101", "Consulta Notif Cambio Imp",	{|| u_WsGnrc00("PRC_IT_CI_OUT_TXT",			    /*6012 ZTY Consulta*/			"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "3803__", "Incl/Baixa Tit Pag Camb Imp",{|| u_WsGnrc00("WsRc3803", 	                    /*6012 ZTY Gera PA do Cambio*/	  "",  "",    "", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "390101", "Consulta Notif Adto/Desp",   {|| u_WsGnrc00("PKG_PRC_ADIANT_DESPESA",		/*6062 Le o ZTN e gera ZTF*/	"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "3905__", "Inclusao TitPagar Adto/Desp",{|| u_WsGnrc00("WsRc3905",                      /*6062 Le o ZTF e gera SE2*/      "",  "",    "", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "390801", "Recebimento dos Materiais",  {|| u_WsGnrc00("PKG_IS_API_RECEBIMENTO.PRC_IS_PROCESSA_RECEBIMENTO",            "03", "P", "DSV", 2) },             "",       00,      ""          })

ElseIf nRad == 2 // 2=Exportacao
    aAdd(aPrcInt, { "430301", "Ordem Venda",                {|| u_WsGnrc00("PKG_ES_GEN_ORDEM_VALIDA.PRC_ORDEM_HEADER",						"03", "P", "DSV", 2) },       "Ordem:",       20,      "_FIELD2"   })
    aAdd(aPrcInt, { "440301", "Processo Exportacao",        {|| u_WsGnrc00("PKG_ES_GEN_PROCESSO",											"03", "P", "DSV", 2) },    "Processo:",       20,      "_FIELD2"   })
    aAdd(aPrcInt, { "450301", "Processo Embalagem",         {|| u_WsGnrc00("PKG_EMBALAGEM",				    							    "03", "P", "DSV", 2) },   "Embalagem:",       20,      "_FIELD2"   })
    
    aAdd(aPrcInt, { "460101", "Consulta Notif Senf Export", {|| u_WsGnrc00("PKG_ES_GEN_SENF_ATUALIZA",		/*6004*/						"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "4703__", "Atualizacao Proc Exp Capa",  {|| u_WsGnrc00("WsRc4703",                                                        "",  "",    "", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "480101", "Consulta Notif Cambio Exp",  {|| u_WsGnrc00("PRC_IT_CE_OUT_TXT",			    /*6011 ZTX Consulta*/			"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "480301", "Envio da NFiscal Export",    {|| u_WsGnrc00("PKG_ES_GEN_NF_ATUALIZA",		/*6004*/						"03", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "4903__", "Incl/Baixa Tit Rec Camb Exp",{|| u_WsGnrc00("WsRc4903",                      /*6011 ZTX Gera RA do Cambio*/    "",  "",    "", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "490501", "Consulta Notif Pagamento",   {|| u_WsGnrc00("PKG_GEN_PAGAMENTO",			    /*5054 ZTP Pagamentos*/			"01", "P", "DSV", 2) },             "",       00,      ""          })
    aAdd(aPrcInt, { "4906__", "Inclusao Titulos Financeiro",{|| u_WsGnrc00("WsRc4906",                      /*5054 ZTP Gera Titulos*/         "",  "",    "", 2) },             "",       00,      ""          })

    aAdd(aPrcInt, { "4907__", "Inclusao Tit Receber Fatur", {|| u_WsGnrc00("WsRc4907",                      /*9001*/                          "",  "",    "", 2) },             "",       00,      ""          })
EndIf
aCmbPrcInt := {}
For _w1 := 1 To Len( aPrcInt )
    aAdd(aCmbPrcInt, aPrcInt[_w1,01] + "=" + aPrcInt[_w1,02])
Next
If ValType(oCmbPrcInt) == "O"
    oCmbPrcInt:aItems := aClone( aCmbPrcInt )
    oCmbPrcInt:bChange := {|| u_AskYesNo(3500,"PrcShw04","Recarregando...","","","","","REFRESH",.T.,.F.,{|| PrcLds04(.T.) }) }    
    oCmbPrcInt:Refresh()
EndIf
PrcLds04(.T.) // Recarregamento GetDados
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ PrcLds04 บAutor ณJonathan Schmidt Alves บ Data ณ28/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recarregando processo de integracao.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function PrcLds04(lLoad)
Local nOpc := oCmbPrcInt:nAt
Local lShwGet := .F.
Local lShwPsq := .F.
Local cPrcInt := aPrcInt[nOpc,01]
// Objeto Say de pesquisa
If !Empty(aPrcInt[nOpc,04])
    cSayPrcPsq := aPrcInt[nOpc,04]              // Titulo da pesquisa
EndIf
oSayPrcPsq:lVisible := !Empty(aPrcInt[nOpc,04])
oSayPrcPsq:Refresh()
// Objeto Get de pesquisa
cGetPrcPsq := Space(aPrcInt[nOpc,05])           // Espaco Get
oGetPrcPsq:lVisible := aPrcInt[nOpc,05] > 0
oGetPrcPsq:Refresh()
aCls01 := {}
If lLoad // Carregamento dos registros conforme pesquisa
    aHdr01 := LoadsHdr(cPrcInt) // Carregamento do Header
    If cPrcInt $ "190301/" // Moedas
        DbSelectArea("SM2")
        SM2->(DbSetOrder(1)) // DtoS(M2_DATA)
        SM2->(DbSeek( DtoS(dDatabase - 5) ))
        While SM2->(!EOF()) .And. SM2->M2_DATA <= Max(dDatabase, Date())
            aAdd(aCls01, { DtoC(SM2->M2_DATA), SM2->M2_MOEDA2, SM2->M2_MOEDA4, SM2->(Recno()), .F. })
            SM2->(DbSkip())
        End
        lShwGet := .T.
        lShwPsq := .F.
    // 210101/210401 Consulta/Atualiza Notificacoes
    ElseIf cPrcInt $ "210101/210401/" // Notificacoes
        If nRadPrc == 1 // 1=Importacao
            //           { Proces, Descricao da Notificacao                                                             , Reservado, Reservado, Recno, .F. }
            //           {     01,                                                                                    02,        03,        04,    05,  06 }
            aAdd(aCls01, { "6002", "Importacao - Nota Fiscal"                                                           , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "6059", "Importacao - Transito"                                                              , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "6060", "Importacao - Baixa do Transito/Compromisso/Abertura do Pagar/Baixa do Adiant"       , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "6062", "Importacao - Emissao de Pagamento/Adiantamento/Prestacao de Contas"                 , Space(20), Space(20),     0, .F. })
            //           {     01,                                                                                    02,        03,        04,    05,  06 }
            aAdd(aCls01, { "6012", "Cambio Imp - Cambio Importacao"                                                     , Space(20), Space(20),     0, .F. })
        ElseIf nRadPrc == 2 // 2=Exportacao
            //           {     Processo, Descricao da Notificacao                                                       , Reservado, Reservado, Recno, .F. }
            //           {     01,                                                                                    02,        03,        04,    05,  06 }
            aAdd(aCls01, { "6004", "Exportacao - Nota Fiscal (Senf)"                                                    , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "5055", "Exportacao - Adiantamento de Despesas"                                              , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "5054", "Exportacao - Pagamento"                                                             , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "5016", "Exportacao - Prestacao de Contas"                                                   , Space(20), Space(20),     0, .F. })
            aAdd(aCls01, { "9001", "Exportacao - Atualizacao de Vencimentos"                                            , Space(20), Space(20),     0, .F. })
            //           {     01,                                                                                    02,        03,        04,    05,  06 }
            aAdd(aCls01, { "6011", "Cambio Exp - Cambio Exportacao"                                                     , Space(20), Space(20),     0, .F. })
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 350101 Consulta Notif Trans/Compro
    ElseIf cPrcInt $ "350101/" // Consulta Notif Trans/Compro
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6059" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6059" + "3" // "6059"=Transito
                If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                    If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        If ZTN->(DbSeek( _cFilZTN + "6060" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6060" + "3" // "6060"=Compromisso
                If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                    If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 3503__ Inclusao Lanc Contabeis
    ElseIf cPrcInt $ "3503__/" // Inclusao Lanc Contabeis
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6059" + "3", .T. ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN $ "6059/6060/" // "6059"=Transito "6060"=Baixa Transito/Compromisso
                If ZTN->ZTN_STATHO == "3" // "3"=Em Processamento
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        If ZTN->ZTN_STATOT == "05" // "05"=Xml Baixado
                            If ZTN->ZTN_IDEVEN == "6059" .Or. (ZTN->ZTN_IDEVEN == "6060" .And. "NF" $ ZTN->ZTN_PVC202)          // Compromisso ou NF
                                aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                            EndIf
                        EndIf
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 370101 Consulta Notif Nota Import
    ElseIf cPrcInt $ "370101/" // Consulta Notif Nota Import
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6002" + "3" // "6002"=NFiscal Import
                If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 380101 Consulta Notif Cambio Imp
    ElseIf cPrcInt $ "380101/" // Consulta Notif Cambio Imp
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6012" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6012" + "3" // "6012"=Contrato Cambio Import
                If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                    aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 3703__ Inclusao Nota Fiscal Import"
    ElseIf cPrcInt $ "3703__/" // Inclusao Nota Fiscal Import
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
                If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                    If ZTN->ZTN_STATOT == "05" // "05"=XML Baixado
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    ElseIf cPrcInt $ "3504__/" // Atualizacao do Compromisso
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6060" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6060" + "3"
                If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                    If "COMPROMISSO" $ Upper(ZTN->ZTN_PVC202)
                        If ZTN->ZTN_STATOT == "05" // "05"=XML Baixado
                            aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                        EndIf
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 390101 Consulta Notif Adto/Desp
    ElseIf cPrcInt $ "390101/" // Consulta Notif Adto/Desp
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6062" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6062" + "3" // "6062"=Emissao de Pagamento/Adiantamento/Prestacao de Contas
                If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 3905__ Inclusao TitPagar Adto/Desp
    ElseIf cPrcInt $ "3905__/" // Inclusao TitPagar Adto/Desp
        DbSelectArea("ZTF")
        ZTF->(DbGotop())
        While ZTF->(!EOF())
            If ZTF->ZTF_STATOT == "01" // "01"=Pendente
                If !Empty(ZTF->ZTF_DATEMI) // Data de Emissao preenchida
                    If Left(ZTF->ZTF_SPORGA,02) == cEmpAnt .And. SubStr(ZTF->ZTF_SPORGA,04,02) == cFilAnt // Empresa conforme
                        If SubStr(ZTF->ZTF_CREDO1,2,2) == cEmpAnt // Cod Empresa do Fornecedor conforme
                            aAdd(aCls01, { ZTF->ZTF_CDSPID, ZTF->ZTF_PROCES, ZTF->ZTF_DESPES, ZTF->ZTF_NUMDOC, ZTF->(Recno()), .F. })
                        EndIf
                    EndIf
                EndIf
            EndIf
            ZTF->(DbSkip())
        End
        lShwGet := .T.
        lShwPsq := .F.
    // 3803__ Inclusao Tit Pagar Camb Imp
    ElseIf cPrcInt $ "3803__/" // Inclusao Tit Pagar Camb Imp
        DbSelectArea("ZTY")
        ZTY->(DbGotop())
        While ZTY->(!EOF())
            If ZTY->ZTY_STATOT == "01" // "01"=Pendente
                If Left(ZTY->ZTY_EMPRES,04) == cEmpAnt + cFilAnt // Empresa e Filial conforme
                    aAdd(aCls01, { ZTY->ZTY_IDELAN, ZTY->ZTY_TEXCOM, ZTY->ZTY_TEXTIT, ZTY->ZTY_TIPDOC, ZTY->(Recno()), .F. })
                EndIf
            EndIf
            ZTY->(DbSkip())
        End
        lShwGet := .T.
        lShwPsq := .F.
    // 370701 Retorno NF Import
    ElseIf cPrcInt $ "370701/" // Retorno NF Import
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
                If ZTN->ZTN_STATOT == "08" // "08"=Nota de Importacao transmitida com sucesso!
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->ZTN_DETPR1, ZTN->ZTN_DETPR2, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 390801 Recebimento dos Materiais
    ElseIf cPrcInt $ "390801/" // Recebimento dos Materiais
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6002" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6002" + "3"
                If ZTN->ZTN_STATOT == "10" // "10"=Nota de Entrada Totvs retornada Thomson XML
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->ZTN_DETPR1, ZTN->ZTN_DETPR2, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // ################ EXPORTACAO ####################
    // 460101 Consulta Notif Senf Export
    ElseIf cPrcInt $ "460101/" // Consulta Notif Senf Export
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6004" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6004" + "3" // "6002"=NFiscal Export
                If ZTN->ZTN_STATOT == "03" // "03"=Em Processamento Totvs
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa e Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 4703__ Atualizacao Proc Exp Capa
    ElseIf cPrcInt $ "4703__/" // Atualizacao Proc Exp Capa
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6004" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN == "6004" .And. ZTN->ZTN_STATHO == "3"
                If ZTN->ZTN_STATOT == "05" // "05"=Em Processamento Totvs (com Xml baixado)
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empresa e Filial conforme
                        If Left(ZTN->ZTN_PVC201,04) == cEmpAnt + cFilAnt // Empresa e Filial conforme
                            aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                        EndIf
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 480101 Consulta Notif Cambio Exp
    ElseIf cPrcInt $ "480101/" // Consulta Notif Cambio Exp
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6011" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "6011" + "3" // "6011"=Contrato Cambio Export
                If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                    aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 480301 Envio da NFiscal Export
    ElseIf cPrcInt $ "480301/" // Envio da NFiscal Export
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "6004" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "6004" + "3"
                If ZTN->ZTN_STATOT == "07" // "07"=Capa atualizada com sucesso! (notificado Thomson)
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt // Empra/Filial conforme
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 4903__ Inclusao TitRec Cambio Exp
    ElseIf cPrcInt $ "4903__/" // Inclusao TitRec Cambio Exp
        DbSelectArea("ZTX")
        ZTX->(DbGotop())
        While ZTX->(!EOF())
            If ZTX->ZTX_STATOT == "01" // "01"=Pendente
                If Left(ZTX->ZTX_EMPRES,04) == cEmpAnt + cFilAnt // Empresa e Filial conforme
                    aAdd(aCls01, { ZTX->ZTX_IDELAN, ZTX->ZTX_REFER1, ZTX->ZTX_VALRME, ZTX->ZTX_VALRMN, ZTX->(Recno()), .F. })
                EndIf
            EndIf
            ZTX->(DbSkip())
        End
        lShwGet := .T.
        lShwPsq := .F.
    // 490501 Consulta Notif Pagamento
    ElseIf cPrcInt $ "490501/" // Consulta Notif Pagamento
        If ZTN->(DbSeek( _cFilZTN + "5054" + "3" )) // "3"=Em Processamento Totvs
            While ZTN->(!EOF()) .And. ZTN->ZTN_FILIAL + ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == _cFilZTN + "5054" + "3"
                If ZTN->ZTN_STATOT == "03" // "03"=Processamento Totvs
                    If ZTN->ZTN_ERPORI == cEmpAnt + cFilAnt
                        aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // 4906__ Inclusao Titulos Financeiro
    ElseIf cPrcInt $ "4906__/" // Inclusao Titulos Financeiro
        DbSelectArea("ZTP")
        ZTP->(DbGotop())
        While ZTP->(!EOF())
            If ZTP->ZTP_STATOT == "01" // "01"=Pendente
                If !Empty(ZTP->ZTP_DATASP) // Data de Emissao preenchida
                    If Left(ZTP->ZTP_NUMDOC,02) == cEmpAnt .And. SubStr(ZTP->ZTP_NUMDOC,03,02) == cFilAnt // Empresa/Filial conforme
                        aAdd(aCls01, { ZTP->ZTP_CDIDSP, ZTP->ZTP_NUMDOC, ZTP->ZTP_CODDES, ZTP->ZTP_DSPGTO, ZTN->(Recno()), .F. })
                    EndIf
                EndIf
            EndIF
            ZTP->(DbSkip())
        End
        lShwGet := .T.
        lShwPsq := .F.
    // 4907__ // Inclusao Tit Receber Fatur
    ElseIf cPrcInt $ "4907__/" // Inclusao Tit Receber Fatur
        DbSelectArea("ZTN")
        ZTN->(DbSetOrder(2)) // ZTN_FILIAL + ZTN_IDEVEN + ZTN_STATHO + ZTN_DATRAN
        If ZTN->(DbSeek( _cFilZTN + "9001" + "3" ))
            While ZTN->(!EOF()) .And. ZTN->ZTN_IDEVEN + ZTN->ZTN_STATHO == "9001" + "3" // "9001"=Envio de Datas e Valores de Parcela (Receber)
                If ZTN->ZTN_STATOT == "03" // "3"=Em Processamento Totvs "03"=Em Processamento Totvs
                    If Left(ZTN->ZTN_PVC201,4) == cEmpAnt + cFilAnt // Empresa/Filial conforme
                        If !Empty( ZTN->ZTN_PVC201 )
                            aAdd(aCls01, { ZTN->ZTN_IDTRAN, ZTN->ZTN_IDEVEN, ZTN->ZTN_PVC201, ZTN->ZTN_NUMB01, ZTN->(Recno()), .F. })
                        EndIf
                    EndIf
                EndIf
                ZTN->(DbSkip())
            End
        EndIf
        lShwGet := .T.
        lShwPsq := .F.
    // Exige pesquisa
    ElseIf !Empty(aPrcInt[nOpc,04]) .And. aPrcInt[nOpc,05] > 0 // Exige pesquisa
        lShwGet := .T.
        lShwPsq := .T.
    Else
        lShwGet := .F.
        lShwPsq := .F.
    EndIf
    If lShwGet // .T.=Mostrar e atualizar o GetDados
        If ValType(oGetD1) == "O"
            oGetD1:oBrowse:lVisible := .F.
        EndIf
        nLineG01 := 1
        oGetD1 := MsNewGetDados():New(003,003,130,288,Nil,"AllwaysTrue()", "AllwaysTrue()" ,, /*aFldsAlt01*/ ,,,,,"AllwaysTrue()",oPnlGD1,@aHdr01,@aCls01)
        oGetD1:oBrowse:SetBlkBackColor({|| GetDXClr("01", oGetD1:aCols, oGetD1:nAt, aHdr01) })
        oGetD1:bChange := {|| nLineG01 := oGetD1:nAt, oGetD1:Refresh() }
        oGetD1:oBrowse:lHScroll := .F.
        oGetD1:aCols := aClone(aCls01)
        oGetD1:oBrowse:lVisible := .T.
    EndIf
    // Mostrar/Nao Mostrar o Botao de Pesquisa
    oBtnPsq:lVisible := lShwPsq
    oBtnPsq:Refresh()
    // Refresh geral
    If lShwGet
        oDlg01:CommitControls()
        oGetD1:Refresh()
        oGetD1:oBrowse:SetFocus() // Foco no objeto
    ElseIf ValType(oGetD1) == "O"
        oGetD1:oBrowse:lVisible := .F.
    EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ LoadsHdr บAutor ณ Jonathan Schmidt Alves บDataณ 01/10/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para recarregamento dos headers.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LoadsHdr(cHdr)
Local aHdr := {}
// ########### GENERICOS #############
If cHdr $ "190301/" // Moedas
    aAdd(aHdr, { "Data",       		        "I01_FIELD1",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Taxa Dolar",              "I01_FIELD2",	"@E 999,999.99999", 08, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Taxa Euro",               "I01_FIELD3",	"@E 999,999.99999", 08, 02, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "210101/210401/" // Consulta Notificacoes/Atualiza Notificacoes
    aAdd(aHdr, { "Evento",       		    "I01_FIELD1",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Desc Evento",             "I01_FIELD2",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Reservado 01",            "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Reservado 02",            "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
// ############ IMPORTACAO ############
ElseIf cHdr $ "330301/" // Inclusao Pedido de Importacao
    aAdd(aHdr, { "Filial",       		    "I01_FIELD1",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Pedido",                  "I01_FIELD2",	"",				    15, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Reservado 01",            "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Reservado 02",            "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "430301/" // Ordem de Venda (EE7)
    aAdd(aHdr, { "Filial",       		    "I01_FIELD1",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Pedido",       		    "I01_FIELD2",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "PedFat",             		"I01_FIELD3",	"",					06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Data",                 	"I01_FIELD4",	"",					08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "440301/" // Processo
    aAdd(aHdr, { "Filial",       		    "I01_FIELD1",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Pedido",       		    "I01_FIELD2",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Embarque",           		"I01_FIELD3",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Data",                 	"I01_FIELD4",	"",					08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "450301/" // Embalagem (EEC)
    aAdd(aHdr, { "Filial",       		    "I01_FIELD1",	"",                 02, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Embarque",           		"I01_FIELD2",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Pedido",       		    "I01_FIELD3",	"",                 20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Data",                 	"I01_FIELD4",	"",					08, 00, ".F.",				"€€€€€€€€€€€€€€ ", "D", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "350101/3503__/370101/3703__/380101/390101/" + "3504__/" // ZTN
    aAdd(aHdr, { "IdTran",       		    "I01_FIELD1",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Evento",           		"I01_FIELD2",	"",					04, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "PkVc201",                	"I01_FIELD3",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "PkNum01",                	"I01_FIELD4",	"",					10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "370701/390801/" // Nota de entrada gerada Totvs, Recebimento de Materiais
    aAdd(aHdr, { "IdTran",       		    "I01_FIELD1",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Evento",           		"I01_FIELD2",	"",					04, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "PkVc201",                	"I01_FIELD3",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "PkNum01",                	"I01_FIELD4",	"",					10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Detalhes 01",            	"I01_FIELD5",	"",					50, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 05
    aAdd(aHdr, { "Detalhes 02",            	"I01_FIELD6",	"",					50, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 06
    aAdd(aHdr, { "Recno",                   "I01_RECNO7",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 07
ElseIf cHdr $ "3905__/" // ZTF
    aAdd(aHdr, { "Id",             		    "I01_FIELD1",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Processo",                "I01_FIELD2",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Despesa",                 "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Num Documento",           "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "3803__/" // ZTY
    aAdd(aHdr, { "Id Lancto",      		    "I01_FIELD1",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Texto",                   "I01_FIELD2",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Titulo",                  "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Tip Documento",           "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
// ############ EXPORTACAO ############
ElseIf cHdr $ "460101/4703__/480101/480301/" + "4907__/" // ZTN
    aAdd(aHdr, { "Evento",       		    "I01_FIELD1",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Desc Evento",             "I01_FIELD2",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Reservado 01",            "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Reservado 02",            "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "4903__/" // ZTX
    aAdd(aHdr, { "Id Lancto",      		    "I01_FIELD1",	"",                 06, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Referencia",              "I01_FIELD2",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "Vlr MoedaEst",            "I01_FIELD3",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "Vlr MoedaNac",            "I01_FIELD4",	"",				    20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "490501/" // Consulta Pagamentos
    aAdd(aHdr, { "IdTran",       		    "I01_FIELD1",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "Evento",           		"I01_FIELD2",	"",					04, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "PkVc201",                	"I01_FIELD3",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "PkNum01",                	"I01_FIELD4",	"",					10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
ElseIf cHdr $ "4906__/" // ZTP Inclusao Titulos Pagar Financeiro
    aAdd(aHdr, { "Id",            		    "I01_FIELD1",	"",                 10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 01
    aAdd(aHdr, { "NumDoc",           		"I01_FIELD2",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 02
    aAdd(aHdr, { "CodDes",                	"I01_FIELD3",	"",					20, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 03
    aAdd(aHdr, { "DsPgto",                	"I01_FIELD4",	"",					30, 00, ".F.",				"€€€€€€€€€€€€€€ ", "C", "",		"R", "", "" }) // 04
    aAdd(aHdr, { "Recno",                   "I01_RECNO5",	"",				    10, 00, ".F.",				"€€€€€€€€€€€€€€ ", "N", "",		"R", "", "" }) // 05
EndIf
Return aHdr

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ LoadCols บAutor ณ Jonathan Schmidt Alves บDataณ 01/06/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carregamento do aCols conforme padrao do aHdr01 passado.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LoadCols(aHdr01) // Criador de aCols
Local z
Local aCls := {}
Local _aCls := {}
For z := 1 To Len(aHdr01)
	If aHdr01[z,08] == "C" // Char
		aAdd(_aCls, Space(aHdr01[z,04]))
	ElseIf aHdr01[z,08] == "N" // Num
		aAdd(_aCls, 0)
	ElseIf aHdr01[z,08] == "D" // Data
		aAdd(_aCls, CtoD(""))
	EndIf
Next
aAdd(_aCls, .F.) // Nao apagado
aAdd(aCls, _aCls)
Return aCls

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ PsqInteg บAutor ณJonathan Schmidt Alves บ Data ณ28/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pesquisa antes da integracao.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function PsqInteg()
Local nOpc := oCmbPrcInt:nAt
Local cInteg := aPrcInt[ nOpc,01]
aCls01 := {}
If cInteg $ "190301/" // Moedas
    DbSelectArea("SM2")
    SM2->(DbSetOrder(1)) // DtoS(M2_DATA)
    SM2->(DbSeek( DtoS(dDatabase - 5) ))
    While SM2->(!EOF()) .And. SM2->M2_DATA <= Max(dDatabase, Date())
        aAdd(aCls01, { DtoC(SM2->M2_DATA), SM2->M2_MOEDA2, SM2->M2_MOEDA4, SM2->(Recno()), .F. })
        SM2->(DbSkip())
    End
ElseIf cInteg $ "330301/" // Pedido de Importacao
    _cFilSW2 := xFIlial("SW2")
    DbSelectArea("SW2")
    SW2->(DbSetOrder(1)) // W2_FILIAL + W2_PO_NUM
    If SW2->(DbSeek( _cFilSW2 + cGetPrcPsq ))
        aAdd(aCls01, { SW2->W2_FILIAL, SW2->W2_PO_NUM, SW2->W2_PO_DT, Space(20), SW2->(Recno()), .F. })
        SW2->(DbSkip())
    EndIf
    If Len( aCls01 ) == 0
        aCls01 := LoadCols( oGetD1:aHeader ) // Criacao do aCls01
    EndIf
ElseIf cInteg $ "430301/" // Ordem de Venda (EE7)
    _cFilEE7 := xFilial("EE7")
    DbSelectArea("EE7")
    EE7->(DbSetOrder(1)) // EE7_FILIAL + EE7_PEDIDO
    If EE7->(DbSeek( _cFilEE7 + cGetPrcPsq ))
        aAdd(aCls01, { EE7->EE7_FILIAL, EE7->EE7_PEDIDO, EE7->EE7_PEDFAT, EE7->EE7_DTPROC, EE7->(Recno()), .F. })
    Else
        aCls01 := LoadCols( oGetD1:aHeader ) // Criacao do aCls01
    EndIf
ElseIf cInteg $ "440301/" // Processo
    _cFilEEC := xFilial("EEC")
    DbSelectArea("EEC")
    EEC->(DbSetOrder(14)) // EEC_FILIAL + EEC_PEDREF
    If EEC->(DbSeek( _cFilEEC + cGetPrcPsq ))
        While EEC->(!EOF()) .And. EEC->EEC_FILIAL + EEC->EEC_PEDREF == _cFilEEC + cGetPrcPsq
            aAdd(aCls01, { EEC->EEC_FILIAL, EEC->EEC_PEDREF, EEC->EEC_PREEMB, EEC->EEC_DTPROC, EEC->(Recno()), .F. })
            EEC->(DbSkip())
        End
    EndIf
    If Len( aCls01 ) == 0
        aCls01 := LoadCols( oGetD1:aHeader ) // Criacao do aCls01
    EndIf
ElseIf cInteg $ "450301/" // Embalagem (EEC)
    _cFilEEC := xFilial("EEC")
    DbSelectArea("EEC")
    EEC->(DbSetOrder(14)) // EEC_FILIAL + EEC_PEDREF
    If EEC->(DbSeek( _cFilEEC + cGetPrcPsq ))
        While EEC->(!EOF()) .And. EEC->EEC_FILIAL + EEC->EEC_PEDREF == _cFilEEC + cGetPrcPsq
            aAdd(aCls01, { EEC->EEC_FILIAL, EEC->EEC_PREEMB, EEC->EEC_PEDREF, EEC->EEC_DTPROC, EEC->(Recno()), .F. })
            EEC->(DbSkip())
        End
    EndIf
    If Len( aCls01 ) == 0
        aCls01 := LoadCols( oGetD1:aHeader ) // Criacao do aCls01
    EndIf
EndIf
oGetD1:aCols := aClone(aCls01)
oGetD1:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ PrcInteg บAutor ณJonathan Schmidt Alves บ Data ณ28/09/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da integracao.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SCHNEIDER                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function PrcInteg()
Local lRet := .T.
Local aReturn := {}
Local nOpc := oCmbPrcInt:nAt
Local bProc := aPrcInt[ nOpc, 03 ] // Rotina de integracao
Local cFldI := aPrcInt[ nOpc, 06 ] // Field de integracao
Private cIntPrcPsq := ""
Private nRecTabPos := 0
If aPrcInt[ nOpc, 01 ] $ "210101/210401/" // Consulta Notificacao/Atualiza Notificacao
    If Type("oGetD1") <> "O" .Or. Len(oGetD1:aCols) == 0 // Pesquisa nao realizada
        MsgStop("Nao foram carregados eventos para disparar a integracao!","PrcInteg")
        lRet := .F.
    Else // Evento posicionado
        cIntPrcPsq := oGetD1:aCols[ oGetD1:nAt, 01 ] // Codigo do Evento
    EndIf
ElseIf !Empty(aPrcInt[ nOpc, 04 ]) .And. aPrcInt[ nOpc, Len( oGetD1:aHeader ) ] > 0 // Exige pesquisa
    If Type("oGetD1") <> "O" .Or. Len(oGetD1:aCols) == 0 // Pesquisa nao realizada
        MsgStop("Realize a pesquisa para disparar a integracao!","PrcInteg")
        lRet := .F.
    Else // Pesquisa ok
        If (nFnd := ASCan( oGetD1:aHeader, {|x|, SubStr(x[02],4,7) == cFldI })) > 0
            cIntPrcPsq := oGetD1:aCols[ oGetD1:nAt, nFnd ]
        Else // Field Integracao nao identificado
            MsgStop("Field de Integracao nao identificado!","PrcInteg")
            lRet := .F.
        EndIf
    EndIf
Else // Nao Exige Pesquisa... eh o Recno posicionado
    If oGetD1:oBrowse:lVisible .And. Len(oGetD1:aCols) > 0 // Recno posicionado
        nRecTabPos := oGetD1:aCols[ oGetD1:nAt, Len( oGetD1:aHeader ) ]
    ElseIf !(aPrcInt[ nOpc, 01 ] $ "190301") // Nenhum registro
        MsgStop("Nenhum registro carregado para processamento!","PrcInteg")
        lRet := .F.
    EndIf
EndIf
If lRet // .T.=Valido para integracao
    aReturn := Eval( bProc ) // Rotina de integracao
    If ValType(aReturn) == "A"
        If Len(aReturn) > 0
            If ValType(aReturn[01]) == "L"
                // Recarregar tela
                If oBtnPsq:lVisible // Botao de pesquisa visivel
                    PsqInteg() // Refazer a pesquisa
                ElseIf aPrcInt[ nOpc, 01 ] == "190301" // Moedas, mostro as taxas do SM2
                    PsqInteg() // Chama consulta automatica (taxas atualizadas)
                ElseIf !(aPrcInt[ nOpc, 01 ] $ "210101/210401/") // Se nao eh pesquisa, e nao eh Notificacao... recarrego
                    Eval(oCmbPrcInt:bChange) // Eval do Combo (limpa itens que acabaram de ser processados)
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
Return aReturn
