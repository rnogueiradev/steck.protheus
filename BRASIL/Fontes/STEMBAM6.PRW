#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STEMBAM6   ºAutor  ³Joao Rinaldi       º Data ³  28/09/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para consulta de produto na tela de embarque         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STEMBAM2.prw                                               º±±
±±ºNome      ³ Geração de Embarque                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STEMBAM6

	Local _nI
	Local nOpcao         := 0
	Local lSaida         := .F.	
	Private cPerg        := "STEMBAM6"
	Private cPerg1       := PADR(cPerg , Len(SX1->X1_GRUPO)," " )
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos     := SUBSTR(cTime, 4, 2)
	Private cSegundos    := SUBSTR(cTime, 7, 2)
	Private cAliasLif    := cPerg+cHora+cMinutos+cSegundos
	Private cPergTit     := cAliasLif
	Private cAlias1      := GetNextAlias()
	Private _aDados      := {}


//-------cGrupo    ,cOrdem,cPergunt                 ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
//PutSx1(cPerg     ,"01"  ,"Filial ?"               ,"Filial ?"                 ,"Filial ?"                   ,"mv_ch1"    ,"C"   ,02      , 0      , 0     ,"G" ,""    ,"SM0" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,""                   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,""      ,_aHelp  ,_aHelp  ,_aHelp  ,"")
	PutSx1(cPerg   ,"01"   ,"Código Produto: ?"     ,"Código Produto: ?"        ,"Código Produto: ?"           ,"mv_ch1"    ,"C"   ,15      , 0      , 0     ,"G" ,""    ,"SB1" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,"  "                 ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

	Pergunte(cPerg,.T.)

	Dbselectarea("SB1")
	SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
	SB1->(DbGoTop())
	If !DbSeek(xFilial("SB1")+MV_PAR01) .or. Empty(MV_PAR01)
		Alert("Código do Produto não encontrado...!!!"+ Chr(10) + Chr(13) +;
			Chr(10) + Chr(13) +;
			"Favor verificar...!!!")
		Return
	Endif

	Processa({|| StQuery(  ) },"Analisando Informações...!!!")

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
	
		While 	(cAlias1)->(!Eof())

			Aadd(_aDados,{(cAlias1)->A1_COD,;
				(cAlias1)->A2_DESC,;
				(cAlias1)->A3_PEDIDO,;
				(cAlias1)->A4_EMBARQUE,;
				(cAlias1)->A5_SALDO_ENDERECO})
		
			(cAlias1)->(dbskip())
		End
	
		(cAlias1)->(dbCloseArea())
	EndIf

	Do While !lSaida
		nOpcao := 0
		For _nI := 1 to len(_aDados)
			Define msDialog oDxlg Title "Consulta - Dados do Produto - Armazém '"+SuperGetMV("ST_LOCESC",,"15")+"'" From 10,10 TO 270,400 Pixel
	
			@ 010,010 say "Código: " COLOR CLR_BLUE  Of oDxlg Pixel
			@ 010,060 get _aDados[_nI][1]   when .f. size 120,08  Of oDxlg Pixel
	
			@ 030,010 say "Descrição: " COLOR CLR_BLUE  Of oDxlg Pixel
			@ 030,060 get _aDados[_nI][2]   when .f. size 120,08  Of oDxlg Pixel	

			@ 050,010 say "Pedido de Venda: " COLOR CLR_BLUE  Of oDxlg Pixel
			@ 050,060 get cvaltochar(_aDados[_nI][3])   when .f. size 120,08  Of oDxlg Pixel	

			@ 070,010 say "Embarque: " COLOR CLR_BLUE  Of oDxlg Pixel
			@ 070,060 get cvaltochar(_aDados[_nI][4])   when .f. size 120,08  Of oDxlg Pixel	

			@ 090,010 say "Armazém '"+SuperGetMV("ST_LOCESC",,"15")+"' : " COLOR CLR_BLUE  Of oDxlg Pixel
			@ 090,060 get cvaltochar(_aDados[_nI][5])   when .f. size 120,08  Of oDxlg Pixel	
	
			@ 110,085 Button "OK"    Size 28,12 Action Eval({||(lSaida:=.T.,nOpcao:=1,oDxlg:End())}) OF oDxlg Pixel
	
			Activate Dialog oDxlg Centered
	
		Next _nI

	EndDo



Static Function StQuery()

	Local _cQuery1   := ' '

	_cQuery1 := " SELECT
	_cQuery1 += " SB1.B1_COD  AS A1_COD,
	_cQuery1 += " SB1.B1_DESC AS A2_DESC,
	
	_cQuery1 += " (SELECT NVL(SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT),0)
	_cQuery1 += " FROM "+RetSqlName("SC6")+" SC6 "
	_cQuery1 += " INNER JOIN "+RetSqlName("SC5")+" SC5 "
	_cQuery1 += " ON  SC5.D_E_L_E_T_ = ' '
	_cQuery1 += " AND SC5.C5_FILIAL  = SC6.C6_FILIAL
	_cQuery1 += " AND SC5.C5_NUM     = SC6.C6_NUM
	_cQuery1 += " AND SC5.C5_CLIENTE = SC6.C6_CLI
	_cQuery1 += " AND SC5.C5_LOJACLI = SC6.C6_LOJA
	_cQuery1 += " WHERE SC6.D_E_L_E_T_ = ' '
	_cQuery1 += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	_cQuery1 += " AND SC5.C5_EMISSAO >= '20141215'
	_cQuery1 += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	_cQuery1 += " AND SC6.C6_BLQ     = ' '
	_cQuery1 += " AND SC6.C6_OPER    = '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
	_cQuery1 += " AND SC6.C6_PRODUTO = SB1.B1_COD
	_cQuery1 += " AND SC6.C6_BLQ     <> 'R'
	_cQuery1 += " )AS A3_PEDIDO,

	_cQuery1 += " (SELECT NVL(SUM(ZZU.ZZU_QTDE),0)
	_cQuery1 += " FROM "+RetSqlName("ZZU")+" ZZU "
	_cQuery1 += " LEFT JOIN "+RetSqlName("ZZT")+" ZZT "
	_cQuery1 += " ON  ZZT.D_E_L_E_T_ = ' '
	_cQuery1 += " AND ZZT.ZZT_FILIAL = ZZU.ZZU_FILIAL
	_cQuery1 += " AND ZZT.ZZT_NUMEMB = ZZU.ZZU_NUMEMB
	_cQuery1 += " AND ZZT.ZZT_FILIAL = '"+xFilial("ZZT")+"'"
	_cQuery1 += " WHERE ZZU.D_E_L_E_T_ = ' '
	_cQuery1 += " AND ZZT.ZZT_STATUS IN ('1','2')
	_cQuery1 += " AND ZZU.ZZU_PRODUT = SB1.B1_COD
	_cQuery1 += " AND ZZU.ZZU_FILIAL = '"+xFilial("ZZU")+"'"
	_cQuery1 += " AND ZZU_VIRTUA <> 'N' " //Chamado 007618
	_cQuery1 += " )AS A4_EMBARQUE,

	_cQuery1 += " (SELECT NVL(SUM(BF_QUANT),0)
	_cQuery1 += " FROM "+RetSqlName("SBF")+" SBF "
	_cQuery1 += " WHERE SBF.D_E_L_E_T_ = ' '
	_cQuery1 += " AND SBF.BF_PRODUTO   = SB1.B1_COD
	_cQuery1 += " AND SBF.BF_LOCAL     = '"+SuperGetMV("ST_LOCESC",,"15")+"'"
	_cQuery1 += " AND SBF.BF_FILIAL    = '"+xFilial("SBF")+"'"
	_cQuery1 += " )AS A5_SALDO_ENDERECO

	_cQuery1 += " FROM "+RetSqlName("SB1")+" SB1 "

	_cQuery1 += " WHERE SB1.D_E_L_E_T_= ' '
	_cQuery1 += " AND SB1.B1_COD = '"+MV_PAR01+"'"

	_cQuery1 := ChangeQuery(_cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery1),cAlias1)

Return ()





/*
01 - Preto - CLR_BLACK
02 - Azul - CLR_BLUE
03 - Verde - CLR_GREEN
04 - Ciano - CLR_CYAN
05 - Vermellho - CLR_RED
06 - Magenta - CLR_MAGENTA
07 - Marrom - CLR_BROWN
08 - Cinza - CLR_GRAY
09 - Azul Claro - CLR_HBLUE
10 - Verde Claro - CLR_HGREEN
11 - Ciano - CLR_HCYAN
12 - Vermelho Claro - CLR_HRED
13 - Magenta Claro - CLR_HMAGENTA
14 - Amarelo - CLR_YELLOW
15 - Cinza Claro - CLR_HGRAY
16 - Branco - CLR_WHITE
*/