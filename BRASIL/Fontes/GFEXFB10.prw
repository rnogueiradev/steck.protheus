#INCLUDE "PROTHEUS.CH"
/*====================================================================================\
|Programa  | GFEXFB10         | Autor | GIOVANI.ZAGO             | Data | 13/08/2019  |
|=====================================================================================|
|Descrição | GFEXFB10     P.E. GFE Para unificar o grupo de calculo de frete cd e     |
|          | fabrica saindo de manaus carga fechada.                                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GFEXFB10                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-------------------------*
User Function GFEXFB10
*-------------------------*
	Local cNumGrup := ""

	If cEmpAnt = '03' 
		cNumGrup := "000001"
	EndIf
	/*
	Local cEmisDc  := PARAMIXB[1] //GFEXFB_5CMP(lTabTemp, cTRBDOC, @aDocCarg, 1,"EMISDC"),;
	Local cSerDc   := PARAMIXB[2] //GFEXFB_5CMP(lTabTemp, cTRBDOC, @aDocCarg, 1,"SERDC"), ;
	Local cNrDc    := PARAMIXB[3] //GFEXFB_5CMP(lTabTemp, cTRBDOC, @aDocCarg, 1,"NRDC"),  ;
	Local cCdTpDc  := PARAMIXB[4] //GFEXFB_5CMP(lTabTemp, cTRBDOC, @aDocCarg, 1,"CDTPDC")
	Local cNrRom   := PARAMIXB[5] //GFEXFB_5CMP(lTabTemp, cTRBDOC, @aDocCarg, 1,"NRAGRU") || gwn_nrrom
	Local cQuery   := ""
	Local cAliasQry:= ""
	Local nNumGrup := 0
	local nX       := 0
	Local aNumGrup := {}

	//Busca todas os documentos do romaneio cNrRom
	cQuery := " SELECT GW1_CDTPDC,GW1_EMISDC,GW1_SERDC,GW1_NRDC,GW1_CDREM,GW1_CDDEST,GW1_ENTNRC,GW1_ENTBAI,GW1_ENTEND"
	cQuery += "   FROM "+RetSqlName('GW1')"
	cQuery += "  WHERE GW1_FILIAL = '"+xFilial('GW1')+"'"
	cQuery += "    AND GW1_NRROM  = '"+cNrRom+"'"
	cQuery += "    AND D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	cAliasQry := GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasQry,.F.,.T.)

	While (cAliasQry)->(!Eof())
	//Insere os documentos em um array, junto com a nova numeração para o número do grupo
	If  (nX := aScan(aNumGrup,{|x| x[2] == (cAliasQry)->(GW1_EMISDC+GW1_CDREM+GW1_CDDEST+GW1_ENTNRC+GW1_ENTBAI+GW1_ENTEND)})) == 0
	nNumGrup++
	aAdd(aNumGrup,{StrZero(nNumGrup,06),(cAliasQry)->(GW1_EMISDC+GW1_CDREM+GW1_CDDEST+GW1_ENTNRC+GW1_ENTBAI+GW1_ENTEND),{}})
	nX := Len(aNumGrup)
	EndIf
	aAdd(aNumGrup[nX][3], (cAliasQry)->(GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC))
	(cAliasQry)->(dbSkip())
	EndDo
	(cAliasQry)->(dbCloseArea())

	//Busca no array o documento passado por parâmetro e atribui o número do grupo que será retornado para gravar o cálculo
	For nX := 1 To Len(aNumGrup)
	If (aScan(aNumGrup[nX][3], {|x| x == cCdTpDc+cEmisDc+cSerDc+cNrDc})) > 0
	cNumGrup := aNumGrup[nX][1]
	EndIf
	Next nX
	*/
Return cNumGrup