#INCLUDE "PROTHEUS.CH" 
#INCLUDE "APVT100.CH" 

#DEFINE CODROM	01
#DEFINE DTEMIS	02
#DEFINE NOTAFI	03
#DEFINE SERIES	04
#DEFINE CLIENT	05
#DEFINE LOJACL	06
#DEFINE PEDIDO	07
#DEFINE NTRANS	08
#DEFINE BAIRRO	09
#DEFINE MUNICI	10
#DEFINE TELCLI	11
#DEFINE CONTAT	12
#DEFINE QTDVOL	13
#DEFINE PBRUTO	14
#DEFINE NPLACA	15
#DEFINE NCLIEN	16
#DEFINE ENDENT	17
#DEFINE MOTORI	18
#DEFINE AJUDA1	19
#DEFINE AJUDA2	20
#DEFINE TIPROM	21
#DEFINE TELEFO	22
#DEFINE HRROM	23

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA61 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Romaneio                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA61( cAlias, nReg, nOpcx )
	Local cRomaneioDe
	Local cRomaneioAte

	Private cString      := "PD2"
	Private aOrd         := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir informacoes referentes ao "
	Private cDesc2       := "Romaneio de Expedicao"
	Private cDesc3       := ""
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "M"
	Private nomeprog     := "STFSF61R" 
	Private nTipo        := 18
	Private aReturn      := {"Zebrado",1,"Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private titulo       := "Relatorio de Romaneio Expedicao"
	Private nLin         := 99
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private cbtxt        := "Registro(s) lido(s)"
	Private cbcont       := 0
	Private CONTFL       := 01
	Private m_pag        := 0
	Private imprime      := .T.
	Private wnrel        := "STFSF61R"

	AjustaSX1()
	If !Pergunte("STFSF61R",.t.)
		Return
	Endif
	cRomaneioDe  := MV_PAR01
	cRomaneioAte := MV_PAR02
	If cRomaneioDe > cRomaneioAte
		MsgAlert("Parâmetros de Romaneio inválido!","Aviso")
		Return
	Endif

	wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,Nil,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| ImpRel(cRomaneioDe,cRomaneioAte) },Titulo)
Return


//------------------------------------------------------------------------
Static Function ImpRel(cRomaneioDe,cRomaneioAte)
	Local aImpDet := {}
	Local cRomaneioAtu
	Local cQuery
	Local nX

	cQuery := " Select PD2_CODROM,PD2_NFS,PD2_SERIES,PD2_CLIENT,PD2_LOJCLI,PD2_QTDVOL,PD2_PBRUTO "
	cQuery += "   From "+RetSqlName("PD2")+" PD2"
	cQuery += "  Where PD2_FILIAL = '" + xFilial("PD2") + "' AND"
	cQuery += "        PD2_CODROM >= '"+cRomaneioDe+"' AND PD2_CODROM <= '"+cRomaneioAte+"' AND"
	cQuery += "        PD2.D_E_L_E_T_ = ' '"
	//cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)

	SA1->(DbSetOrder(1))
	SA2->(DbSetOrder(1))
	SA4->(DbSetOrder(1))
	SF2->(DbSetOrder(1))
	SD2->(DbSetOrder(3))
	PD1->(DbSetOrder(1))
	TMP->(DbGoTop())
	While TMP->(!Eof())
		PD1->(DbSeek(xFilial("PD1")+TMP->PD2_CODROM))
		SF2->(DbSeek(xFilial("SF2")+TMP->(PD2_NFS+PD2_SERIES+PD2_CLIENT+PD2_LOJCLI)))
		SA4->(DbSeek(xFilial("SA4")+SF2->F2_TRANSP))
		If SF2->F2_TIPO $ "DB"
			SA2->(DbSeek(xFilial("SA2")+TMP->(PD2_CLIENT+PD2_LOJCLI)))
		Else
			SA1->(DbSeek(xFilial("SA1")+TMP->(PD2_CLIENT+PD2_LOJCLI)))
		EndIf
		SD2->(DbSeek(xFilial("SD2")+TMP->(PD2_NFS+PD2_SERIES+PD2_CLIENT+PD2_LOJCLI)))

		If SF2->F2_TIPO $ "DB"
			aadd(aImpDet,{	TMP->PD2_CODROM,PD1->PD1_DTEMIS,TMP->PD2_NFS,TMP->PD2_SERIES,TMP->PD2_CLIENT,PD2_LOJCLI,SD2->D2_PEDIDO,SA4->A4_NOME,;
			SA2->A2_BAIRRO,SA2->A2_MUN,SA2->A2_TEL,SA2->A2_CONTATO,TMP->PD2_QTDVOL,TMP->PD2_PBRUTO,PD1->PD1_PLACA,SA2->A2_NOME,;
			SA2->A2_END,PD1->PD1_MOTORI,PD1->PD1_AJUDA1,PD1->PD1_AJUDA2,PD1->PD1_TPROM,SA4->A4_TEL,PD1->PD1_HRROM})
		Else
			aadd(aImpDet,{	TMP->PD2_CODROM,PD1->PD1_DTEMIS,TMP->PD2_NFS,TMP->PD2_SERIES,TMP->PD2_CLIENT,PD2_LOJCLI,SD2->D2_PEDIDO,SA4->A4_NOME,;
			SA1->A1_BAIRRO,SA1->A1_MUN,SA1->A1_TEL,SA1->A1_CONTATO,TMP->PD2_QTDVOL,TMP->PD2_PBRUTO,PD1->PD1_PLACA,SA1->A1_NOME,;
			SA1->A1_END,PD1->PD1_MOTORI,PD1->PD1_AJUDA1,PD1->PD1_AJUDA2,PD1->PD1_TPROM,SA4->A4_TEL,PD1->PD1_HRROM})
		EndIf

		TMP->(DbSkip())
	Enddo
	TMP->(dbCloseArea())

	cRomaneioAtu := ""
	For nX:=1 to Len(aImpDet)
		If cRomaneioAtu <> aImpDet[nX,01] .Or. nLin > 60
			nLin := 99
			Cabec2(nX,aImpDet)
			cRomaneioAtu := aImpDet[nX,01]
		Endif
		ImpDet(nX,aImpDet)
	Next

	SET DEVICE TO SCREEN
	If aReturn[5]==1
		DbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()

Return


//------------------------------------------------------------------------
Static Function ImpDet(nX,aImpDet)

	Local _cOS 		:= GetOs(aImpDet[nX,NOTAFI])
	Local _cLocEx 	:= ""
	
	@   nLin,000 PSay "NOTA FISCAL: " + aImpDet[nX,NOTAFI]
	@   nLin,081 PSay "|       CONFIRMACAO"
	@ ++nLin,000 PSay "PEDIDO    : " + aImpDet[nX,PEDIDO] + " OS: " + GetOs(aImpDet[nX,NOTAFI])
	@   nLin,081 PSay "|"
	@ ++nLin,000 PSay "CLIENTE    : " + Left(aImpDet[nX,NCLIEN],40)
	@   nLin,081 PSay "|"
	@ ++nLin,000 PSay "TRANSP     : " + AllTrim(aImpDet[nX,NTRANS]) + " | TEL: " + AllTrim(aImpDet[nX,TELEFO])
	@   nLin,081 PSay "| NOME: "
	@ ++nLin,000 PSay "END ENTREG : " + aImpDet[nX,ENDENT]
	@   nLin,081 PSay "|"
	@ ++nLin,000 PSay "BAIRRO     : " + aImpDet[nX,BAIRRO]
	@   nLin,055 PSay "MUN: " + aImpDet[nX,MUNICI]
	@   nLin,081 PSay "| RG:"
	@ ++nLin,000 PSay "CONTATO    : " + aImpDet[nX,CONTAT]
	@   nLin,055 PSay "TEL: " + aImpDet[nX,TELCLI]
	@   nLin,081 PSay "|"
	@ ++nLin,000 PSay "---------------------------------------------------------------------------------|"	// PLACA: " + aImpDet[nX,NPLACA]
	@   nLin,081 PSay "| DATA: ___/___/______"
	@ ++nLin,000 PSay "OBSERVACAO : ___________________________________________________________________ |"
	//@ ++nLin,000 PSay "             ___________________________________________________________________ |"
	//@ ++nLin,000 PSay "             ___________________________________________________________________ |"
	@ ++nLin,000 PSay "COLETA     : _________________       N.VOLUMES   : "
	@   nLin,051 PSay aImpDet[nX,QTDVOL] Picture "999"
	@   nLin,067 PSay "PESO: "
	@   nLin,073 PSay aImpDet[nX,PBRUTO] Picture "@E 99999,99"
	@   nLin,081 PSay "| Hr Entrega: ______:______"
	//@   nLin,081 PSay "|"
	
	dbSelectArea("SZ5")
	dbSetOrder(1)
	dbGotop()
	If(dbSeek(xFilial("SZ5")+Alltrim(StrTran(_cOS,"/",""))))

		While !EOF() .AND. SZ5->Z5_FILIAL = xFilial("SZ5") .AND. SZ5->Z5_ORDSEP == Alltrim(StrTran(_cOS,"/",""))

			If Empty(_cLocEx)

				_cLocEx :=  Alltrim(SZ5->Z5_ENDEREC)

			Else

				_cLocEx :=  _cLocEx+"/"+Alltrim(SZ5->Z5_ENDEREC)

			EndIF

			SZ5->(dbSkip())

		End
	EndIf
	
	@ ++nLin,000 PSay "LOC.EXPED.:"+Alltrim(_cLocEx) 
	@   nLin,081 PSay "| Hr Saida:   ______:______"
//	@   nLin,081 PSay "|"
	@ ++nLin,000 PSay Replicate("=",115)
	++nLin

Return


//------------------------------------------------------------------------
Static Function Cabec2(nX,aImpDet)

	Local oPr

	If nLin > 60
		++m_pag
		nLin := 06
		@ nLin,000 PSay Replicate("=",115)
		@ ++nLin,000 PSay "STECK"
		If aImpDet[nX,TIPROM] == "1"
			@   nLin,000 PSay "EMITE ROMANEIO DE ENTREGA                         IMPRESSO EM : " + DTOC(dDataBase) + " - " + SubStr(Time(),1,5)
		Else
			@   nLin,000 PSay "EMITE ROMANEIO DE RETIRA                          IMPRESSO EM : " + DTOC(dDataBase) + " - " + SubStr(Time(),1,5)
		EndIf
		@   nLin,101 PSay "PAG.: " + StrZero(m_pag,2)
		@ ++nLin,000 PSay Replicate("=",115)
		If aImpDet[nX,TIPROM] == "1"
			@ ++nLin,000 PSay "ROMANEIO DE ENTREGA: "+AllTrim(aImpDet[nX,CODROM])+" - DIA: " + DTOC(aImpDet[nX,DTEMIS]) + " - " + aImpDet[nX,HRROM]
		Else
			@ ++nLin,000 PSay "ROMANEIO DE RETIRA: "+AllTrim(aImpDet[nX,CODROM])+" - DIA: " + DTOC(aImpDet[nX,DTEMIS]) + " - " + aImpDet[nX,HRROM]
		EndIf

		oPr := ReturnPrtObj()   
		cCode := AllTrim(aImpDet[nX,CODROM])
		MSBAR3("CODE128",1.5,010,Alltrim(cCode),oPr,Nil,Nil,Nil,Nil,1.2,Nil,Nil,Nil)

		@ ++nLin,000 PSay "KM  SAIDA  : _________________       HORA SAIDA  : __________                  "
		@ ++nLin,000 PSay "KM  CHEGADA: _________________       HORA CHEGADA: __________                  "
		If Empty(aImpDet[nX,MOTORI])
			@ ++nLin,000 PSay "Motorista  : __________________________________________________________________"
		Else
			@ ++nLin,000 PSay "Motorista  : " + AllTrim(aImpDet[nX,MOTORI])
		EndIf
		If Empty(aImpDet[nX,NPLACA])
			@ ++nLin,000 PSay "Placa      : __________________________________________________________________"
		Else
			@ ++nLin,000 PSay "Placa      : " + AllTrim(aImpDet[nX,NPLACA])
		EndIf
		If Empty(aImpDet[nX,AJUDA1])
			@ ++nLin,000 PSay "Ajudante 1 : __________________________________________________________________"
		Else
			@ ++nLin,000 PSay "Ajudante 1 : " + AllTrim(aImpDet[nX,AJUDA1])
		EndIf
		If Empty(aImpDet[nX,AJUDA2])
			@ ++nLin,000 PSay "Ajudante 2 : __________________________________________________________________"
		Else
			@ ++nLin,000 PSay "Ajudante 2 : " + AllTrim(aImpDet[nX,AJUDA2])
		EndIf

		@ ++nLin,000 PSay Replicate("=",115)
		++nLin
	EndIf

Return

//------------------------------------------------------------------------
Static Function AjustaSX1()
	Local cAlias := Alias()
	Local aRegistros:={}
	Local i,j:=0

	aadd(aRegistros,{Padr("STFSF61R",Len(SX1->X1_GRUPO),""),"01","Romaneio de          ?","","","mv_ch1","C",TamSX3("PD1_CODROM")[01]	,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegistros,{Padr("STFSF61R",Len(SX1->X1_GRUPO),""),"02","Romaneio ate         ?","","","mv_ch2","C",TamSX3("PD1_CODROM")[01]	,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	For i:=1 to Len(aRegistros)
		If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegistros[i,j])
			Next j
			MsUnlock()
		EndIf
	Next I
	dbSelectArea(cAlias)
Return



/*

=============================================================================================================
STECK
EMITE ROMANEIO DE ENTREGA                         EMITIDO EM : 31/12/99                              PAG.: 01
=============================================================================================================
ROMANEIO DE ENTREGA DO DIA: 31/12/99
KM  SAIDA  : _________________       HORA SAIDA  : __________                  
KM  CHEGADA: _________________       HORA CHEGADA: __________                  
Motorista  : __________________________________________________________________
Placa      : __________________________________________________________________
Ajudante 1 : __________________________________________________________________
Ajudante 2 : __________________________________________________________________
=============================================================================================================
NOTA FISCAL: 123456789   PEDIDO: 123456                                          |       CONFIRMACAO
CLIENTE    : NOME DO CLIENTE POR EXTENSO                                         |
TRANSP     : NOME DA TRANSPORTADORA                                              | NOME: 
END ENTREG : ENDERECO DE ENTREGA                                                 |
BAIRRO     : 123456789012345678901234567890            MUN: 123456789012345      | RG:
CONTATO    :                                           TEL: 123456789012345      |
---------------------------------------------------------------------------------| 
OBSERVACAO : ___________________________________________________________________ |
___________________________________________________________________ |
___________________________________________________________________ |
COLETA     : _________________       N.VOLUMES   : 123456     PESO: 12123,99     |
=============================================================================================================
*/

Static Function GetOs(_cNf)

	Local _cRet 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT CB7_ORDSEP
	_cQuery1 += " FROM "+RetSqlName("CB7")+" CB7
	_cQuery1 += " WHERE CB7.D_E_L_E_T_=' ' AND CB7_FILIAL='"+xFilial("CB7")+"'
	_cQuery1 += " AND CB7_NOTA='"+_cNf+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
		_cRet += (_cAlias1)->CB7_ORDSEP+" / "
		(_cAlias1)->(DbSkip())
	EndDo

Return(_cRet)