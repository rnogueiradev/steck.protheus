#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "STCTBA020.CH"

Static lCTB020AUT := .F.
Static lDefTopCtb := IfDefTopCTB()
Static __lCtrCtb  := .F.

User Function STCTBA020(aRotAuto,nOpcAuto,aRotItem)

	Local nOrdemSX3
	Local nRecnoSX3

	Local aCores := {	{ "CT1_BLOQ == '1'" , "BR_VERMELHO"	},; // Conta Bloqueada
	{ "CT1_BLOQ == '2' .AND. ( ( Empty( CT1_DTEXIS ) .Or. CT1_DTEXIS <= dDatabase ) .AND. ( Empty( CT1_DTEXSF ) .Or. CT1_DTEXSF >= dDatabase ) ) .AND. ( ( Empty( CT1_DTBLIN ) .OR. CT1_DTBLIN >= dDatabase ) .Or. ( Empty( CT1_DTBLFI ) .Or. CT1_DTBLFI <= dDatabase ) )" , "BR_VERDE"   	},; // Sem Restrio
	{ "CT1_BLOQ == '2' .AND. ( ! Empty( CT1_DTEXIS ) .AND. CT1_DTEXIS >= dDatabase )" , "BR_AMARELO"	},; // Exercicio N Iniciado
	{ "CT1_BLOQ == '2' .AND. ( ! Empty( CT1_DTEXSF ) .AND. CT1_DTEXSF <= dDatabase )" , "BR_CINZA"		},; // Exercicio Finalizado
	{ "CT1_BLOQ == '2' .AND. ( ( ! Empty( CT1_DTBLIN ) .AND. CT1_DTBLIN <= dDatabase ) .OR. ( ! Empty( CT1_DTBLFI ) .Or. CT1_DTBLFI >= dDatabase ) )" , "BR_LARANJA"}} // Bloqueado no periodo


	PRIVATE aFolder	:= {}
	Private oFold020

	PRIVATE aRotina   := {}
	PRIVATE cCadastro := OemToAnsi(STR0006)  //"Plano de Contas"
	PRIVATE cCvdCodPla:= ""
	PRIVATE lExstCdPla:= .F.
	Private oGetVis   :=nil
	Private nPVis:=0

	DEFAULT aRotAuto := {}
	DEFAULT aRotItem := {}
	DEFAULT nOpcAuto := 3

	If !(cPaisLoc $ "DOM|MEX")
		aFolder:={STR0068,STR0069} //Visi  Gerencial //Plan de Cuentas Referencial
   
	Else
		aFolder:={STR0068} //Visi  Gerencial
	endif

	__lCtrCtb       := SuperGetMV("MV_CTRCTB",.F.,"2") == "1"

	aRotina   := MenuDef()

	SetFunName('CTBA020')
// Verificar existencia do campo "CVD_CODPLA"
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek("CVD_CODPLA"))
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			lExstCdPla := .T.
		ENDIF
	Else
		cCvdCodPla:= "*" //Para n  proibir altera o do campo
	EndIf
	SX3->(DbSetOrder(1))

	If Len(aRotAuto) > 0
		lCTB020AUT := .T.
	Else
		SetKey(VK_F12,{|a,b|AcessaPerg("CTB020",.T.)})
	EndIf
             
	Pergunte("CTB020",.F.)
 

// Altera o no campo X3_RESERV referente ao campo CT1_BOOK  e CT1_TRNSEF da tabela SX3, para permitir que 
// atraves do configurador, o usuario consiga alterar o tamanho do campo CT1_BOOK da tabela CT1

	dbSelectArea("SX3")
	nOrdemSX3 := IndexOrd()
	nRecnoSX3 := Recno()


	dbSetOrder(nOrdemSX3)
	DbGoto(nRecnoSX3)

	dbSelectArea("CT1")
	If cPaisLoc == "ANG" .AND. ExistBlock("CT998X5LL")
		CT998x5LL()
	Endif

	If lCTB020Aut
		PRIVATE aAutoCab   := Aclone(aRotAuto)
		PRIVATE aAutoItens := aRotItem
		MBrowseAuto(nOpcAuto,aAutoCab,"CT1")
	Else
		If mv_par09 == 2
			CtbaTree("CT1")
			SET KEY VK_F12 to
			Return
		ElseIf mv_par09 == 3
			If MsgYesNo(STR0010)
				CtbaTree("CT1")
				SET KEY VK_F12 to
				Return
			Endif
		Endif
 
		mBrowse( 6, 1,22,75,"CT1",,,,,,aCores)
		dbSetOrder(1)
		SET KEY VK_F12 to
	EndIf

Return






Static Function	PlnCtaGrv(nOpcA,aRegNo)

	Local aArea    := GetArea("CT1")
	Local nX       := 0
	Local nY       := 0
	Local nMaxFor  := Len(aCols)
	Local nDeleted := Len(aHeader)+1
	Local nPEnt    := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_ENTREF"})
	Local bCampo   := {|nCPO| Field(nCPO) }
	Local lTravou  := .F.
	Local nOpc      := 0
	Local aCposHistor := {}
	Local aEaiRet		:= {}

	DEFAULT aRegNo := {}

//                                ?
//?Verifica a operacao                                           ?
//                                ?
	If nOpcA <> 3
	//                                ?
	//?Grava o cabecalho                                             ?
	//                                ?
		dbSelectArea("CT1")
		dbSetOrder(1)
		If MsSeek(xFilial("CT1")+M->CT1_CONTA)
			RecLock("CT1")
		Else
			RecLock("CT1",.T.)
		EndIf
		For nY := 1 To FCount()
			AADD(aCposHistor,{CT1->(FieldName(nY)),CT1->&(EVAL(bCampo,nY)),""})
		Next nY
	
		For nY := 1 TO FCount()
			FieldPut(nY,M->&(EVAL(bCampo,nY)))
		Next nY
		CT1->CT1_FILIAL := xFilial("CT1")
		CT1->( FKCommit() )



	//                           ?
	//?Grava Hist ico de Altera es na tabela CW4.         ?
	//                            
		nOpc := If(nOpcA == 1,3,If(nOpcA==2,4,5))
		If nOpc == 3
			CTBGrvHist(xFilial("CT1"),"CT1"		,CT1->CT1_CONTA,      ,ValType(CT1->CT1_CONTA),"CT1_CONTA",""       ,CT1->CT1_CONTA,nOpc)
		//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo,cValorAnt,cValorNovo    ,nOpc)
		Else
			For nY := 1 To Len(aCposHistor)
				aCposHistor[nY][3] := CT1->&(EVAL(bCampo,nY))
				If aCposHistor[nY][2] <> aCposHistor[nY][3]
					CTBGrvHist(xFilial("CT1"),"CT1"     ,CT1->CT1_CONTA,      ,ValType(aCposHistor[nY][1]),aCposHistor[nY][1],aCposHistor[nY][2],aCposHistor[nY][3],nOpc)
				//           cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo                 ,cCampo            ,cValorAnt         ,cValorNovo        ,nOpc)
				EndIf
			Next nY
		EndIf

	//                                ?
	//?Grava os itens                                                ?
	//                                ?
		For nX := 1 To nMaxFor // Exclui primeiro os registros deletados para nao viola o de chave primaria
			If ( aCols[nX][nDeleted] )
				If ( Len(aRegNo) >= nX )
					dbSelectArea("CVD")
					MsGoto(aRegNo[nX])
					RecLock("CVD")
					dbDelete()
					MsUnLock()
				EndIf
			EndIf
		Next nX
		For nX := 1 To nMaxFor
			If ( aCols[nX][nDeleted] )
				loop // Nao considerado os itens deletado pois ja foram excluidos da base no laco de cima
			Endif
			If ( Len(aRegNo) >= nX )
				dbSelectArea("CVD")
				MsGoto(aRegNo[nX])
				RecLock("CVD")
				lTravou := .T.
			Else
				If ( !aCols[nX][nDeleted] .And. !Empty(aCols[nX][nPEnt]) )
					RecLock("CVD",.T.)
					lTravou := .T.
				Else
					lTravou := .F.
				EndIf
			EndIf
			If lTravou
			//                                     
			// tualiza os itens                                                       ?
			//                                     
				For nY := 1 to Len(aHeader)
					If aHeader[nY][10] <> "V"
						CVD->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				CVD->CVD_FILIAL := xFilial("CVD")
				CVD->CVD_CONTA  := M->CT1_CONTA
			EndIf
		Next nX
	Else
	//                                ?
	// xclucao dos itens                                             ?
	//                                ?
		For nX := 1 To nMaxFor
			If ( Len(aRegNo) >= nX )
				dbSelectArea("CVD")
				MsGoto(aRegNo[nX])
				RecLock("CVD")
				dbDelete()
				MsUnlock()
			EndIf
		Next nX
		
		CVD->( FKCommit() )

		dbSelectArea("CT1")
		dbSetOrder(1)
		If MsSeek(xFilial("CT1")+M->CT1_CONTA)
	
  		//                                    ?
		//?Exclui o Registro do De-Para                                          ?
		//                                    ?
			Begin Transaction
			
				lEaiRet := .T.
				If !lCTB020AUT .And. FWHasEAI("CTBA020",.T.,,.T.)
				//Informado o quinto par etro "cFunName" para que o ResponseMessage retorne para o adapter correto,
				//no caso da integra o ser chamada por outra rotina
					aEaiRet:= FwIntegDef( 'CTBA020', , , , 'CTBA020' )
			
					If !aEaiRet[1]
						Help(" ",1,"HELP","Erro EAI",STR0080,3,1)//"Problemas na integra o EAI, Transa o n  executada."
						DisarmTransaction()
						lEaiRet := .F.
					EndIf
				EndIf
			
				If lEaiRet
					RecLock("CT1")
					dbDelete()
					MsUnLock()
				EndIf
		
			End Transaction
		EndIf
	
	//                           ?
	//?Grava Hist ico de Altera es na tabela CW4.         ?
	//                            
		nOpc := If(nOpcA == 1,3,If(nOpcA==2,4,5))
		CTBGrvHist(xFilial("CT1"),"CT1"     ,CT1->CT1_CONTA,      ,ValType(CT1->CT1_CONTA),"CT1_CONTA",M->CT1_CONTA,""        ,nOpc)
	//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo          ,cValorAnt   ,cValorNovo,nOpc)
	
	EndIf
//                                ?
// estaura a integridade da rotina                               ?
//                                ?
	RestArea(aArea)
Return(.T.)
 
Static Function MenuDef()

	Local aRotina := {	{ OemToAnsi(STR0001),"AxPesqui"	  ,0 , 1,,.F.},;  //"Pesquisar"
	{ OemToAnsi(STR0002),"Ctba020Vis",0 , 2},;  //"Visualizar"
	{ OemToAnsi(STR0003),"Ctba020Inc",0 , 3},;  //"Incluir"
	{ OemToAnsi("Alterar"),"u_st20Alt",0 , 4},;  //"Alterar"
	{ OemToAnsi(STR0011),"Ctba020leg",0 , 6,,.F.},; //"Legenda"
	{ OemToAnsi(STR0045),"MSDOCUMENT", 0 , 4} }		// "Conhecimento"

	If cPaisLoc <> "BRA" .And. __lCtrCtb
		Aadd (	aRotina, {OemToAnsi(STR0067),"CTBA001", 0 , 4 })		//"Controles Cont eis"
	EndIf

Return(aRotina)

 
//-------------------------------------
/*	Modelo do Browser
@author  	Leandro Ferreira Paulino
@version 	P10 R1.4
@build		7.00.101202A
@since 		17/08/2011
@return 	oModel Objeto do Modelo	 */
//-------------------------------------
Static Function ModelDef()
	Local oModel 	:= Nil
	Local oStruCT1	:= Nil

	oStruCT1 := FwFormStruct(1,"CT1")

// Tira valida o da estrutura
	oStruCT1:SetProperty( '*'         , MODEL_FIELD_VALID, { || .T. } )
	oStruCT1:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

	oModel:= MpFormModel():New("CTBA020",/*Pre-Validacao*/, /*Pos-Validacao*/, /*Commit*/,/*Cancel*/)
	oModel:AddFields("CTBA020_CT1",Nil,oStruCT1,/*Pre-Validacao*/,/*Pos-Validacao*/,/*Carga*/)
	oModel:SetDescription(STR0006) // Metodo XML
	oModel:GetModel("CTBA020_CT1"):SetDescription(STR0006)
	oModel:SetPrimaryKey({"CT1_CONTA"})

Return ( oModel )
 
Static Function IntegDef( cXml, nType, cTypeMsg )
	Local aRet := {}
	aRet:= CTBI020( cXml, nType, cTypeMsg )
Return aRet
 
//------------------------------------------------------
Static Function IntProtGfe(nOperation)
	Local lRet := .T.
	Local lIntGFE := SuperGetMv("MV_INTGFE",.F.,.F.)
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2",.F.,"2")

	If lIntGFE == .T. .And. cIntGFE2 $ "1"
		If !InterGUE(nOperation)
			lRet := .F.
		EndIf
	EndIf
	
Return lRet
//-----------------------------------------------------
/*/	Integra a tabela CT1(Protheus) com GUE(SIGAGFE) a cada registro novo
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function InterGUE(nOperation)
	Local aAreaGUE := GUE->( GetArea() )
	Local lRet :=  .T.
	Local oModelGUE := FWLoadModel("GFEA090")
	Local nTpOpSetad
	Local cMsg
	
	dbSelectArea("GUE")
	GUE->( dbSetOrder(1) )
	GUE->( dbSeek( xFilial("GUE")+M->CT1_CONTA ) )
	If !GUE->( Eof() ) .And. GUE->GUE_FILIAL == xFilial("GUE");
			.And. AllTrim(GUE->GUE_CTACTB) == AllTrim(M->CT1_CONTA)

		oModelGUE:SetOperation( MODEL_OPERATION_UPDATE )
		nTpOpSetad := MODEL_OPERATION_UPDATE
		
	Else
		oModelGUE:SetOperation( MODEL_OPERATION_INSERT )
		nTpOpSetad := MODEL_OPERATION_INSERT
		
	EndIf
	
	oModelGUE:Activate()
	
	If nOperation <> MODEL_OPERATION_DELETE
		oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_TITULO'  , M->CT1_DESC01 )
		
		If nTpOpSetad == MODEL_OPERATION_UPDATE
			If nOperation == MODEL_OPERATION_INSERT
				oModelGUE:LoadValue( 'GFEA090_GUE', 'GUE_SIT', "1" )
			Endif
		Else
			oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_FILIAL', xFilial("CT1") )
			oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_CTACTB', M->CT1_CONTA )
		EndIf
		
	Else
		If nTpOpSetad <> MODEL_OPERATION_INSERT
			oModelGUE:LoadValue( "GFEA090_GUE", "GUE_SIT", "2" )
		EndIf
	Endif
	
	If nOperation != MODEL_OPERATION_DELETE .Or. nTpOpSetad != MODEL_OPERATION_INSERT
		If oModelGUE:VldData()
			oModelGUE:CommitData()
		Else
			lRet := .F.
			cMsg := STR0066+CRLF+CRLF+oModelGUE:GetErrorMessage()[6]
		EndIf
	EndIf
	
	oModelGUE:Deactivate()
	
	If !lRet
		Help( ,, STR0057,,cMsg, 1, 0 ) //"Aten o"
	EndIf
	
	RestArea( aAreaGUE )
	
Return lRet
 
Static Function LlenaCTS(aHeadCTS,aColsCTS,aColsOr)
	Local nUsado:=0
	Local nx:=0
	Local cAli:="CTS"
	Local aHeadFijo:={"CTS_CODPLA","CTS_NOME","CTS_CONTAG","CTS_ORDEM","CTS_LINHA","CTS_FORMUL","CTS_IDENTI","CTS_TPSALD","CTS_CTTINI", "CTS_CTTFIM", "CTS_CTDINI", "CTS_CTDFIM",  "CTS_CTHINI", "CTS_CTHFIM" } //Solo los campos que presentara el getdados
	Local cQuery := ""
	Local cTempF := ""
	dbselectarea("CTS")
	aColsCTS:={}

	DbSelectArea("SX3")
	DbSetOrder(2)
	FOR NX:=1 TO LEN(aHeadFijo)
		IF SX3->(dbSeek(aHeadFijo[NX]))
			nUsado++
			AADD(aHeadCTS,{ TRIM( X3Titulo()), x3_campo, x3_picture,x3_tamanho,;
				x3_decimal,SX3->X3_VALID ,x3_usado, x3_tipo, x3_f3, x3_context,X3Cbox(),SX3->X3_RELACAO } )
		ENDIF
	NEXT

	If !Inclui
		cTempF := CriaTrab(Nil, .F.)
		cQuery := "SELECT CTS_CODPLA, CTS_NOME,CTS_DESCCG, CTS_CONTAG, CTS_ORDEM, CTS_LINHA, CTS_FORMUL, CTS_IDENT, CTS_TPSALD, CTS_CTTINI, CTS_CTTFIM, CTS_CTDINI, CTS_CTDFIM,  CTS_CTHINI, CTS_CTHFIM "
		cQuery += "FROM "+RetsqlName("CTS") + " CTS "
		cQuery += "WHERE '"+CT1->CT1_CONTA+"' BETWEEN CTS_CT1INI AND CTS_CT1FIM "
		cQuery += "AND D_E_L_E_T_ = '' "
		cQuery += "ORDER BY CTS_CODPLA"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTempF,.T.,.T.)
		(cTempF)->(dbGoTop())
		While (!(cTempF)->(EOF()))
			aAdd(aColsCTS, {(cTempF)->CTS_CODPLA, (cTempF)->CTS_NOME, (cTempF)->CTS_CONTAG, (cTempF)->CTS_ORDEM, (cTempF)->CTS_LINHA, (cTempF)->CTS_FORMUL, (cTempF)->CTS_IDENT, (cTempF)->CTS_TPSALD,(cTempF)->CTS_CTTINI,(cTempF)->CTS_CTTFIM,(cTempF)->CTS_CTDINI,(cTempF)->CTS_CTDFIM,(cTempF)->CTS_CTHINI,(cTempF)->CTS_CTHFIM, .F.})
			aAdd(aColsOr, {(cTempF)->CTS_CODPLA, (cTempF)->CTS_NOME, (cTempF)->CTS_CONTAG, (cTempF)->CTS_ORDEM, (cTempF)->CTS_LINHA, (cTempF)->CTS_FORMUL, (cTempF)->CTS_IDENT, (cTempF)->CTS_TPSALD,(cTempF)->CTS_CTTINI,(cTempF)->CTS_CTTFIM,(cTempF)->CTS_CTDINI,(cTempF)->CTS_CTDFIM,(cTempF)->CTS_CTHINI,(cTempF)->CTS_CTHFIM, .F.})
			(cTempF)->(dbSkip())
		EndDo
		(cTempF)->(dbCloseArea())
	EndIf
Return
 
Static Function NuevoCTS(nLin, aColsCTS)
	Local cFilCVF  := xFilial("CVF")
	Local nX := 0
	Local nPosVis  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CODPLA" })
	Local nPosOrd  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_ORDEM" })
	Local nPosli   := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_LINHA" })
	Local nPosCtg  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CONTAG" })
	Local nPossld  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_TPSALD" })
	Local nPosFrm  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_FORMUL" })
	Local nPosID   := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_IDENTI" })//7
	Local nPosCtti := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTINI" })
	Local nPosCttf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTFIM" })
	Local nPosCtdi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDINI" })
	Local nPosCtdf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDFIM" })
	Local nPosCthi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHINI" })
	Local nPosCthf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHFIM" })
	Local cDesc    :=''

	dbSelectArea("CTS")
	CTS->(DBSETORDER(1))
	dbSelectArea("CVE")
	CVE->(dbSetOrder(1))
	dbSelectArea("CVF")
	CVF->(dbSetOrder(4))
	For nX := nLin to len(aColsCTS)
		If !aColsCTS[nX][len(aColsCTS[nX])] .and. !Empty(aColsCTS[nX,nPosVis]) .and. !Empty(aColsCTS[nX,nPosCtg]) .and. !Empty(aColsCTS[nX,nPosOrd]) .and. !Empty(aColsCTS[nX,nPosli])
			If CVF->(dbSeek(cFilCVF+aColsCTS[nX,nPosVis]+aColsCTS[nX,nPosOrd]))
				If CVE->(dbSeek(xFilial("CVE")+aColsCTS[nX,nPosVis]))
					cDesc   := CVE->CVE_DESCRI
				EndIf
				IF CTS->(DBSEEK(xFILIAL("CTS")+aColsCTS[nX,nPosVis]+aColsCTS[nX,nPosOrd]+aColsCTS[nX,nPosli]))
					RecLock("CTS", .F.)
				ELSE
					RecLock("CTS", .T.)
					CTS->CTS_FILIAL := CVF->CVF_FILIAL
					CTS->CTS_CODPLA := CVF->CVF_CODIGO
					CTS->CTS_ORDEM  := CVF->CVF_ORDEM
					CTS->CTS_LINHA  := aColsCTS[nX,nPosli]
				
					CTS->CTS_CONTAG := CVF->CVF_CONTAG
					CTS->CTS_CTASUP := CVF->CVF_CTASUP
					CTS->CTS_NORMAL := CVF->CVF_NORMAL
					CTS->CTS_COLUNA := VAL(CVF->CVF_COLUNA)
					CTS->CTS_CLASSE := CVF->CVF_CLASSE
					CTS->CTS_NOME   := cDesc
				ENDIF
				CTS->CTS_NOME   := cDesc
				CTS->CTS_CT1INI := M->CT1_CONTA
				CTS->CTS_CT1FIM := M->CT1_CONTA
				CTS->CTS_TPSALD := aColsCTS[nX,nPossld]
				CTS->CTS_IDENT  := aColsCTS[nX][nPosID]
				CTS->CTS_FORMUL := aColsCTS[nX,nPosFrm]
				CTS->CTS_CTTINI := aColsCTS[nX,nPosCtti]
				CTS->CTS_CTTFIM := aColsCTS[nX,nPosCttf]
				CTS->CTS_CTDINI := aColsCTS[nX,nPosCtdi]
				CTS->CTS_CTDFIM := aColsCTS[nX,nPosCtdf]
				CTS->CTS_CTHINI := aColsCTS[nX,nPosCthi]
				CTS->CTS_CTHFIM := aColsCTS[nX,nPosCthf]
			
				CTS->(MsUnlock())
			EndIf
		EndIf
	Next nX
Return
 
Static Function CTSAlt(aColsCTS, aColsOr)
	Local nX   := 0
	Local nLen := len(aColsOr)
	Local nPos := 0
	Local nPosVis  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CODPLA" })
	Local nPosOrd  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_ORDEM" })//4
	Local nPosli   := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_LINHA" })//5
	Local nPosCtg  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CONTAG" })//3
	Local nPossld  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_TPSALD" })//8
	Local nPosFrm  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_FORMUL" })//6
	Local nPosDes  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_NOME" })
	Local nPosID   := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_IDENTI" })//7
	Local nPosCtti := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTINI" })
	Local nPosCttf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTFIM" })
	Local nPosCtdi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDINI" })
	Local nPosCtdf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDFIM" })
	Local nPosCthi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHINI" })
	Local nPosCthf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHFIM" })

	For nX := 1 to len(aColsCTS)
		If nX <= nLen
			If aColsCTS[nX,len(aColsCTS[nX])] //si esta borrado
				CtsArreItem(aColsCTS[nX,nPosVis], aColsCTS[nX,nPosOrd], aColsCTS[nX,nPosli])
			Else
				nPos := aScan(aColsCTS, {|x| x[nPosVis]+x[nPosDes]+x[nPosCtg]+x[nPosOrd]+x[nPosli]+x[nPosFrm]+x[nPosID]+x[nPossld] == aColsOr[nX][nPosVis]+aColsOr[nX][nPosDes]+aColsOr[nX][nPosCtg]+aColsOr[nX][nPosOrd]+aColsOr[nX][nPosli]+aColsOr[nX][nPosFrm]+aColsOr[nX][nPosID]+aColsOr[nX][nPossld]+;
					x[nPosCtti]+x[nPosCttf]+x[nPosCtdi]+x[nPosCtdf]+x[nPosCthi]+x[nPosFrm]})
				If nPos == 0
					nPosLlav :=0
				//si hubo cambios en la llave 
					nPosLlav := aScan(aColsCTS, {|x| x[nPosVis]+x[nPosDes]+x[nPosCtg]+x[nPosOrd] == aColsOr[nX][nPosVis]+aColsOr[nX][nPosDes]+aColsOr[nX][nPosCtg]+aColsOr[nX][nPosOrd]})
					CTSMod(aColsOr[nX][nPosVis],aColsOr[nX][nPosOrd],aColsOr[nX][nPosli],nX,nPosLlav,aColsCTS)
				EndIf
			EndIf
		Else
			NuevoCTS(nX, aColsCTS)
		EndIf
	Next nX
Return
 
Static Function CTSMod(cCodpla, cOrdem, cLinha, nX,nIncl,aColsCTS)
	Local nPossld  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_TPSALD" })//8
	Local nPosFrm  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_FORMUL" })//6
	Local nPosID   := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_IDENTI" })//7
	Local nPosCtti := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTINI" })
	Local nPosCttf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTFIM" })
	Local nPosCtdi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDINI" })
	Local nPosCtdf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDFIM" })
	Local nPosCthi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHINI" })
	Local nPosCthf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHFIM" })

	dbSelectArea("CTS")
	CTS->(dbSetOrder(1))
	if nIncl <> 0
		If CTS->(dbSeek(xFilial("CTS")+cCodpla+cOrdem+cLinha))
			RecLock("CTS", .F.)
			CTS->CTS_TPSALD := oGetVis:aCols[nX][nPossld]
			CTS->CTS_FORMUL := oGetVis:aCols[nX][nPosFrm]
			CTS->CTS_IDENT  := oGetVis:aCols[nX][nPosID]
			CTS->CTS_CTTINI := oGetVis:aCols[nX][nPosCtti]
			CTS->CTS_CTTFIM := oGetVis:aCols[nX][nPosCttf]
			CTS->CTS_CTDINI := oGetVis:aCols[nX][nPosCtdi]
			CTS->CTS_CTDFIM := oGetVis:aCols[nX][nPosCtdf]
			CTS->CTS_CTHINI := oGetVis:aCols[nX][nPosCthi]
			CTS->CTS_CTHFIM := oGetVis:aCols[nX][nPosCthf]
			
			CTS->(MsUnlock())
		EndIf
	else
		CtsArreItem(cCodpla, cOrdem, cLinha) //borra al que se modifico la llave
		NuevoCTS(nX, aColsCTS) //se incluye el nuevo
	endif
Return

 
Static Function CTSDel(aColsCTS)
	Local lNuevo := .F.
	Local cContaFin := ''
	Local cContaSig := ''
	Local cFilCTS := xFilial("CTS")
	Local cFilCT1 := xFilial("CT1")
	Local nX := 0
	Local nPosVis := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CODPLA" })
	Local nPosOrd := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_ORDEM" })//4
	Local nPosli  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_LINHA" })//5

	For nX := 1 to len(aColsCTS)
	
		CtsArreItem(aColsCTS[nX,nPosVis], aColsCTS[nX,nPosOrd], aColsCTS[nX,nPosli])
	Next nX
Return
 
Static Function SigLinea(cCodPla, cOrdem)
	Local aAREA := GetArea()
	Local cTempF := CriaTrab(Nil, .F.)
	Local cQuery := ""
	Local cLinha := ""
	Local nCount := 0

	If n > 1
		Return Soma1(aCols[n-1][5])
	Else
		cQuery := "SELECT CTS_LINHA FROM "+RetSqlName("CTS")
		cQuery += " WHERE CTS_FILIAL = '"+xFilial("CTS")+"'"
		cQuery += " AND CTS_CODPLA = '"+cCodPla+"'"
		cQuery += " AND CTS_ORDEM = '"+cOrdem+"'"
		cQuery += " AND D_E_L_E_T_ = '' "
		cQuery += " ORDER BY CTS_LINHA DESC"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTempF,.T.,.T.)
		count to nCount
		If nCount > 0
			(cTempF)->(dbGoTop())
			cLinha := (cTempF)->(CTS_LINHA)
			cLinha := soma1(cLinha)
		Else
			cLinha := soma1("000")
		EndIf
		(cTempF)->(dbCloseArea())
		RestArea(aAREA)
	EndIf

Return cLinha
//reordena los items de la CTS

Static Function CtsArreItem(cCodpla, cOrdem,cLinha)
	Local cFilCTS := xFilial("CTS")
	Local lBan := .F.
	Local cConta := ""
	Local cContaSup := ""
	Local cDescCgc := ""
	Local cNormal := ""
	Local cColuna := ""
	Local cClasse := ""
	Local cIdent := ""
	Local cNome := ""
	Local cTpsald := ""
	Local cFormul := ""
	Local cCtaIni	:= ""
	Local cCtaFim	:= ""

	dbSelectArea("CTS")
	CTS->(dbSetOrder(1))

	dbSelectArea("CT1")
	CT1->(dbSetOrder(1))

	If CTS->(dbSeek(cFilCTS+cCodpla+cOrdem+cLinha))

    //Resguarda datos del registro que se esta analizando
		cCtaIni	:=CTS->CTS_CT1INI
		cCtaFim	:=CTS->CTS_CT1FIM
		cConta    := CTS->CTS_CONTAG
		cContaSup := CTS->CTS_CTASUP
		cNormal   := CTS->CTS_NORMAL
		cColuna   := CTS->CTS_COLUNA
		cClasse   := CTS->CTS_CLASSE
		cIdent    := CTS->CTS_IDENT
		cNome     := CTS->CTS_NOME
		cTpsald   := CTS->CTS_TPSALD
		cFormul   := CTS->CTS_FORMUL
		cDescCgc:=	CTS->CTS_NOME
     
      
		If M->CT1_CONTA == CTS->CTS_CT1INI .AND. M->CT1_CONTA != CTS->CTS_CT1FIM //Si cuenta de inicio y no de fin
			CT1->(dbSkip())
			RecLock("CTS", .F.)
			CTS->CTS_CT1INI := CT1->CT1_CONTA
			CTS->(MsUnlock())
		ElseIf M->CT1_CONTA == CTS->CTS_CT1FIM .AND. M->CT1_CONTA != CTS->CTS_CT1INI //Si cuenta de fin y no de inicio
			CT1->(dbSkip(-1))
			RecLock("CTS", .F.)
			CTS->CTS_CT1FIM := CT1->CT1_CONTA
			CTS->(MsUnlock())
		ElseIf M->CT1_CONTA > CTS->CTS_CT1INI .and. M->CT1_CONTA < CTS->CTS_CT1FIM //Si es intermedia

		
			if CT1->(DBSEEK(XFILIAL("CT1")+cCtaIni ))
				DO WHILE !CT1->(EOF()) .AND. CT1->CT1_CONTA<=cCtaFim
		 
					if  CT1->CT1_CONTA >= M->CT1_CONTA //Si es la cuenta a borrar
			       
						CT1->(dbSkip(-1)) //Regreso un registro antes
			    	
						Reclock("CTS",.F.)
						CTS->CTS_CT1FIM := CT1->CT1_CONTA
						CTS->(MSUNLOCK())
					
						CT1->(DBSKIP()) //Apunto en el que estaba
						CT1->(DBSKIP()) //avanzo uno mas
						if !CT1->(EOF())
					
							RecLock("CTS", .T.)
							CTS->CTS_FILIAL := cFilCTS
							CTS->CTS_CODPLA := cCodpla
							CTS->CTS_ORDEM  := cOrdem
							CTS->CTS_CONTAG := cConta
							CTS->CTS_CTASUP := cContaSup
							CTS->CTS_NOME := cDescCgc
							CTS->CTS_NORMAL := cNormal
							CTS->CTS_COLUNA := cColuna
							CTS->CTS_CLASSE := cClasse
							CTS->CTS_IDENT  := cIdent
							CTS->CTS_NOME   := cNome
							CTS->CTS_LINHA  := SigLinea(cCodpla, cOrdem)
							CTS->CTS_CT1INI := CT1->CT1_CONTA
							CTS->CTS_CT1FIM := cCtaFim
						
							CTS->CTS_TPSALD := cTpsald
							CTS->CTS_FORMUL := cFormul
							CTS->(MsUnlock())
						endif
						exit
					endif
					CT1->(DBSKIP())
				ENDDO
			endif
		
		
		ElseIf M->CT1_CONTA == CTS->CTS_CT1INI .AND. M->CT1_CONTA == CTS->CTS_CT1FIM //Si es cuenta de inicio y fin
			RecLock("CTS", .F.)
			CTS->(dbDelete())
			CTS->(MsUnlock())
		EndIf
	
	EndIf

	If CVE->(dbSeek(xFilial("CVE")+cCodpla))
		cDescCgc   := CVE->CVE_DESCRI
	EndIf

Return
 

user FUNCTION st20Alt(cAlias,nReg,nOpc)
	Local nOpcA := 0
	Local lCtb020Vld := ExistBlock("CTB020VLD")
	Local aSize     := {}
	Local aObjects  := {}
	Local aInfo     := {}
	Local aPosObj   := {}
	Local aRegNo    := {}
	Local oDlg
	Local nUsado    := 0
	Local nX        := 0
	Local cGetD     := ".T."
	Local l020VlGrv	:= ExistBlock("CTB020VG")
	Local lCT020BUT := ExistBlock("CT020BUT")
	Local lCT20ALTA := ExistBlock("CT20ALTA") // P.E. executado antes da alteracao da conta
	Local lCT20ALTD := ExistBlock("CT20ALTD") // P.E. executado depois da alteracao da conta
	local aButtons  := {}
	Local aEaiRet	:= {}

	Local aHeadCTS:={}
	Local aColsCTS:={}
	Local aColsOr := {}
	Private aHeader := {}
	Private aCols   := {}
	Private aTELA[0][0]
	Private aGETS[0]

//*****************************
// P.E. valida o da grava o *
//*****************************
	If l020VlGrv

		cGetD	:= "ExecBlock('CTB020VG',.F.,.F.,{4})"

	EndIf

	If lCT20ALTA
		ExecBlock("CT20ALTA",.F.,.F.)
	Endif

	dbSelectArea(cAlias)
	dbSetOrder(1)
	If !SoftLock(cAlias)
		Return
	EndIf
	If lCtb020Vld
		If !ExecBlock("CTB020VLD", .F., .F.,nOpc)
			Return
		EndIf
	EndIf
 
	RegToMemory( "CT1", .F., .T. )
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CVD")
	While !Eof() .And. SX3->X3_ARQUIVO=="CVD"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE ,;
				SX3->X3_TAMANHO ,;
				SX3->X3_DECIMAL ,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO ,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	dbSelectArea("CVD")
	dbSetOrder(1)
	MsSeek(xFilial("CVD")+M->CT1_CONTA)
	While !Eof() .And. xFilial("CVD") == CVD->CVD_FILIAL .And. M->CT1_CONTA == CVD->CVD_CONTA
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			If aHeader[nX][10]=="V"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			Else
				aCols[Len(aCols)][nX] := CVD->(FieldGet(FieldPos(aHeader[nX][2])))
			EndIf
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
		aadd(aRegNo,CVD->(RecNo()))
		dbSelectArea("CVD")
		dbSkip()
	EndDo
	If Empty(aCols)
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
	EndIf

	LlenaCTS(@aHeadCTS,@aColsCTS,@aColsOr) //Monta aCols y aheader de CTS (Vision Gerencial)
	If lCT020BUT
		aButtons := ExecBlock("CT020BUT",.F.,.F.,aButtons)
	Endif

	If !lCTB020AUT		// SE FOR ROTINA AUTOMATICA
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .f. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

		EnChoice( "CT1", nReg, nOpc, , , , , aPosObj[1],NaoAltera(cAlias,{"CT1_DC"}),3)

		If !(cPaisLoc $ "DOM|MEX")
			oFold020 := TFolder():New( aPosObj[2,1],aPosObj[2,2], AClone(aFolder), {'',''}, oDlg,,,, .T., , aPosObj[2,4]-5, aPosObj[2,3] ) //gsa
		Else
			oFold020 := TFolder():New( aPosObj[2,1],aPosObj[2,2], AClone(aFolder), {''}, oDlg,,,, .T., , aPosObj[2,4]-5, aPosObj[2,3] ) //gsa
		EndIf

		oGetVis:=MsNewGetDados():New(0,0,90,aPosObj[2,4]-7,7,"Ctba20LOk()" ,"VisionesOk()" ,nil, NIL, 0, 999,"AllwaysTrue" ,"","CTBA20Del()" ,  oFold020:aDialogs[1], aHeadCTS, aColsCTS) //Visiones Gerenciales
		oGetVis:SetEditLine(.F.)

		If !(cPaisLoc $ "DOM|MEX")
			oGetD:=MsGetDados():New(0,0,90,aPosObj[2,4]-7,nOpc,"Ctba020LOk","Ctba020TOk","",.T.,,1,,999,"Ctba020FOk",,,,oFold020:aDialogs[2])
			cGetD:= cGetD + " .and. oGetD:TudoOk()"
		EndIf

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(x020Val() .and. VisionesOk(),If(!Obrigatorio(aGets,aTela) .Or. !(&(cGetD)),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},,aButtons)
	Else
 
		If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"Ctba020LOk",{|| .T.},aAutoCab)
			nOpcA := 1
		EndIf
	EndIf

	If nOpcA == 1
	
		BEGIN TRANSACTION
			PlnCtaGrv(2,aRegNo)
			If !lCTB020AUT
				CTSAlt(oGetVis:aCols, aColsOr)
			EndIf
		
			If Empty(CT1->CT1_CTASUP).and. !lCTB020AUT
			// Aviso de que a conta superior nao foi preenchida
				Help(" ",1,"NOCTASUP")
			EndiF
		 
			If SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
				PcoSincCO("CT1",2)
			EndIf
		
		
			Reclock("CT1")
		
			If ExistBlock("CTBA20CT")
				ExecBlock("CTBA20CT",.F.,.F.,nOpc)
			Endif
		
			MsUnlock()
		
			If lCT20ALTD
				ExecBlock("CT20ALTD",.F.,.F.)
			Endif
			If !lCTB020AUT .And. FWHasEAI("CTBA020",.T.,,.T.)
			//Informado o quinto par etro "cFunName" para que o ResponseMessage retorne para o adapter correto,
			//no caso da integra o ser chamada por outra rotina
				aEaiRet:= FwIntegDef( 'CTBA020', , , , 'CTBA020' )
			
				If !aEaiRet[1]
					Help(" ",1,"HELP","Erro EAI",STR0080,3,1)//"Problemas na integra o EAI, Transa o xecutada.Por favor verificar no Monitor EAI"
					DisarmTransaction()
				EndIf
			EndIf
		
		END TRANSACTION
		MaEnvEAI(/*EMPRESA*/,/*FILIAL*/,nOpc,"CTBA020",{ { "CT1", "CTBA020_CT1", NIL, NIL, NIL, NIL } } )
	EndIF


	MsUnlockAll()

Return


static Function x020Val()
	Local lRet		:= .T.
	Local cFilCT1	:= ""
	Local aCT1	:= {}
	Local aArea		:= {}

	If CTBLCUso()
		If M->CT1_LCCMPL == "1"
			If Empty(M->CT1_CTPART) .Or. Empty(M->CT1_CTCPAR)
				Help(" ",1,"CT1CRIA",,STR0046 + "." + STR0047 + ".",1,0)
				lRet := .F.
			Else
				aArea := GetArea()
				DbSelectArea("CT1")
				aCT1 := GetArea()
				CT1->(DbSetOrder(1))
				cFilCT1 := xFilial("CT1")
				/* verificando a conta de partida para o lancamento complementar */
				If DbSeek(cFilCT1 + M->CT1_CTPART)
					If CT1->CT1_CLASSE == "1"	/* conta sintetica */
						Help(" ",1,"CT1CRIA2",,STR0048 + "." + STR0049 + ".",1,0)
						lRet := .F.
					Else
						If CT1->CT1_LCCMPL == "1"
							Help(" ",1,"CT1CRIA3",,STR0050 + "." + STR0049 + ".",1,0)
							lRet := .F.
						Endif
					Endif
				Else
					Help(" ",1,"CT1CRIA4",,STR0051 + "." + STR0049 + ".",1,0)
					lRet := .F.
				Endif
				/* verificando a conta de partida para o lancamento complementar */
				If lRet
					If DbSeek(cFilCT1 + M->CT1_CTCPAR)
						If CT1->CT1_CLASSE == "1"	/* conta sintetica */
							Help(" ",1,"CT1CRIA5",,STR0048 + "." + STR0049 + ".",1,0)
							lRet := .F.
						Else
							If CT1->CT1_LCCMPL == "1"
								Help(" ",1,"CT1CRIA6",,STR0050 + "." + STR0049 + ".",1,0)
								lRet := .F.
							Endif
						Endif
					Else
						Help(" ",1,"CT1CRIA7",,STR0052 + "." + STR0049 + ".",1,0)
						lRet := .F.
					Endif
				Endif
				RestArea(aCT1)
				RestArea(aArea)
			Endif
		Else
			M->CT1_CTPART := ""
			M->CT1_CTCPAR := ""
		Endif
	Endif
Return(lRet)




static function VisionesOk()

Local nx       := 0
Local ny       := 0 
Local nPosDel  := Len(oGetVis:aHeader)+1
Local nPosVis  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CODPLA" })
Local nPosCtg  := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CONTAG" })
Local nPosCtti := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTINI" })
Local nPosCttf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTTFIM" })
Local nPosCtdi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDINI" })
Local nPosCtdf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTDFIM" })
Local nPosCthi := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHINI" })
Local nPosCthf := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CTHFIM" })
Local nPosTpSl := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_TPSALD" })

Local lRet    := .t.
Local nPosAct :=0

For ny:=1 to Len(oGetVis:aCols)
	nPosAct:=ny
	If lRet
	    For nx:=1 to Len(oGetVis:aCols)
		    If !oGetVis:aCols[nx,nPosdel] .and. nx<>nPosAct .and.  !oGetVis:aCols[nPosact,nPosdel]
		       If  oGetVis:aCols[nx,nPosVis]==oGetVis:aCols[nPosAct,nPosVis] .And.  oGetVis:aCols[nx,nPosCtg]==oGetVis:aCols[nPosAct,nPosCtg];
	      		.And. oGetVis:aCols[nx,nPosCtti]==oGetVis:aCols[nPosAct,nPosCtti] .And. oGetVis:aCols[nx,nPosCttf]==oGetVis:aCols[nPosAct,nPosCttf];
	       	.And. oGetVis:aCols[nx,nPosCtdi]==oGetVis:aCols[nPosAct,nPosCtdi] .And. oGetVis:aCols[nx,nPosCtdf]==oGetVis:aCols[nPosAct,nPosCtdf];
	       	.And. oGetVis:aCols[nx,nPosCthi]==oGetVis:aCols[nPosAct,nPosCthi] .And. oGetVis:aCols[nx,nPosCthf]==oGetVis:aCols[nPosAct,nPosCthf];
	       	.And. oGetVis:aCols[nx,nPosTpSl]==oGetVis:aCols[nPosAct,nPosTpSl]
		       	Help( , ,'Help', ,STR0071,1,0)  
		      		lRet:= .F.
		      		Exit 
		       EndIf 
		    EndIf
	    Next
	EndIf
Next

Return lRet

 
static Function CTBA20Del()
Local lRet := .T.

Local nPosVis := aScan(oGetVis:aHeader,{|x|Alltrim(x[2])=="CTS_CODPLA" })

Local nPos := aScan(oGetVis:aCols, {|x| x[nPosVis] == oGetVis:aCols[n,nPosVis] .AND. !x[len(oGetVis:aCols[n])]})
IF oGetVis:ACols[n][len(oGetVis:aCols[n])]
	If nPos > 0
		Help( , ,'Help', ,STR0071,1,0)  
		lRet := .F.
	EndIf
EndIf
Return lRet



static Function Ctba020LOk()

Local nX        :=  1
Local nUsado    := Len(aHeader)
Local nPEnt     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_ENTREF"})
Local nPPla     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CODPLA"})
Local nPCta     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CTAREF"})
Local nPCc      := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CUSTO" })
Local nPVersao  := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_VERSAO" })
Local lRetorno  := .T.
Local lCT020LOK := ExistBlock("CT020LOK")
 
If Len(aCols) == 1   					// se tem soh uma linha criada da getdaos verifica se codigo plano referencial esta preenchido 
	If !aCols[1][nUsado+1] .And. Empty(aCols[1][nPEnt]) .And. IIf(lExstCdPla,Empty(aCols[1][nPPla]),.T.) .And. Empty(aCols[1][nPCta])
		aCols[1, nUsado+1 ] := .T.  		//caso nao esteja preenchido exclui a linha para nao validar obrigatoriedade do campo CVD_TPUTIL
	EndIf
EndIf
lRetorno := MaCheckCols(aHeader,aCols,N)
If !aCols[n][nUsado+1] .And. (!Empty(aCols[n][nPEnt]) .Or. IIf(lExstCdPla,!Empty(aCols[n][nPPla]),.F.) .Or. !Empty(aCols[n][nPCta]))
	If Empty(aCols[n][nPEnt]) .Or. IIf(lExstCdPla,Empty(aCols[n][nPPla]),.F.) .Or. Empty(aCols[n][nPCta]) .Or. Empty(aCols[n][nPVersao])
		Help(" ",1,"HELP","OBRIGATORIO",STR0053+Chr(10)+Chr(13)+STR0054+IIf(lExstCdPla,STR0055,"")+STR0056,3,1)  //"Favor preencher todos os campos da grade abaixo:"##"'Entidade'"##", 'Plano Ref.'"##" e a 'Conta Ref' pois um ou mais deles est?vazio."
		lRetorno := .F.
	EndIf
EndIf
 
If lRetorno
	For nX := 1 To Len(aCols)
		If !aCols[nX][nUsado+1]  .And. !aCols[n][nUsado+1] 
			If nX <> N
				// Valida se existe outro plano, conta e centro de custo iguais
				If (aCols[n][nPEnt] == aCols[nX][nPEnt] .and. aCols[n][nPPla] == aCols[nX][nPPla] .AND. aCols[n][nPCta] == aCols[nX][nPCta] .and. aCols[n][nPCc] == aCols[nX][nPCc];
					.And. aCols[n][nPVersao] == aCols[nX][nPVersao])
					Help(" ",1,"JAEXISTINF")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	Next nX
EndIf

//Limpa variavel para nova linha ficar travada para consulta
//F3 antes de escolher o plano e a conta referencial
If lRetorno .And. lExstCdPla .And. !lCTB020AUT
	cCvdCodPla := ""
EndIf

If !VisionesOk()
	lRetorno := .F.
EndIf

If lCT020LOK
	If !ExecBlock("CT020LOK",.F.,.F.)
		lRetorno := .F.	
    Endif 
Endif    
     

Return(lRetorno)



static Function Ctba020TOk()

Local nColEnt  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_ENTREF" })
Local nColPla  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_CODPLA" })
Local nColCta  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_CTAREF" })
Local nUsado   := Len(aHeader)
Local nLinPos  := 1      
Local lCT020TOK := ExistBlock("CT020TOK")
Local lRetorno := .T.
		

If !(cPaisLoc $ "DOM|MEX")
If Len(aCols) == 1   					// se tem soh uma linha criada da getdaos verifica se codigo plano referencial esta preenchido 
	If !aCols[1][nUsado+1] .And. Empty(aCols[1][nColEnt]) .And. IIf(lExstCdPla,Empty(aCols[1][nColPla]),.T.) .And. Empty(aCols[1][nColCta])
		aCols[1, nUsado+1 ] := .T.  		//caso nao esteja preenchido exclui a linha para nao validar obrigatoriedade do campo CVD_TPUTIL
	EndIf
EndIf		
	If ( !Empty(aCols[n][nColEnt]) .Or. IIf(lExstCdPla,!Empty(aCols[n][nColPla]),.F.) .Or. !Empty(aCols[n][nColCta]) ) .And. !aCols[n][nUsado+1] 
		If Empty(aCols[n][nColEnt]) .Or. IIf(lExstCdPla, Empty(aCols[n][nColPla]),.F.) .Or.  Empty(aCols[n][nColCta])
			lRetorno := .F.
			Help(" ",1,"HELP","OBRIGATORIO","Favor preencher todos os campos da grade abaixo:"+Chr(10)+Chr(13)+"'Entidade'"+IIf(lExstCdPla,", 'Plano Ref.'","")+" e a 'Conta Ref' pois um ou mais deles est?vazio.",3,1)
		Else 
			If lExstCdPla
				CVN->(DbSetOrder(2))
				For nLinPos:=1 To Len(aCols)
					If CVN->(!DbSeek(xFilial("CVN")+aCols[nLinPos,nColPla]+aCols[nLinPos,nColCta]))
						lRetorno := .F.
						nLinPos:=Len(aCols)
						Help(" ",1,"HELP","CORRIGIR","Favor corrigir 'Plano Ref.' e a 'Conta Ref' pois est  inconsistentes.",3,1)
					EndIf
				Next nLinPos
			EndIf
		EndIf
	EndIf    
EndIf
If lCT020TOK
	If !ExecBlock("CT020TOK",.F.,.F.)
		lRetorno := .F.	
    Endif 
Endif
 
If lRetorno
	If !IntProtGfe( IIF(INCLUI,3, IIF(ALTERA,4,5) ) )
		lRetorno := .F.
	EndIf
EndIf

Return(lRetorno)


