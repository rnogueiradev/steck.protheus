#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'TbiConn.ch'

/*/{Protheus.doc} STBEN001
Função para planejamento de beneficiamento utilizando as tabelas ZZ8 e ZZ9, Modelo 3 em MVC
@author Robson Mazzarotto
@since 12/12/2016
@version 1.0
/*/
User Function STBEN001()

	Local oBrowse
	Private aRotina := Menudef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZ8")
	oBrowse:SetDescription("Planejamento de Beneficiamento")
	oBrowse:AddLegend( "ZZ8->ZZ8_STATUS == 'P'", "GREEN", "Planejamento em Pedido de venda" )
	oBrowse:AddLegend( "ZZ8->ZZ8_STATUS == 'E'", "RED",   "Planejamento Estornado" )
	oBrowse:AddLegend( "ZZ8->ZZ8_STATUS == 'B'", "GRAY",  "Planejamento Finalizado" )

	oBrowse:Activate()

Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Robson Mazzarotto                                            |
| Data:  12/12/2016                                                   |
| Desc:  Criação do menu MVC                                          |
*---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar"	ACTION 'ViewDef.STBEN001' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    	ACTION 'ViewDef.STBEN001' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Estornar"		ACTION 'u_STBENEST' 		OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    	ACTION 'u_STBENEXC' 		OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda"		ACTION 'u_STBENLEG'     	OPERATION 6 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Robson Mazzarotto

@since 12/12/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStr1   := FWFormStruct(1,'ZZ8')
	Local oStr2   := FWFormStruct(1,'ZZ9')
	Local bCommit	:= { |oModel| U_ST001ProcComm( oModel ) }

	oModel := MPFormModel():New( "STBEN01", /*bPreVld*/, /*bPosVld*/, bCommit, /*bCancel*/ )

	oModel:SetDescription('Planejamento de Beneficiamento')

	oModel:addFields('FIELD1',,oStr1)
	oModel:addGrid('GRID1','FIELD1',oStr2)

	oModel:SetRelation('GRID1', { { 'ZZ9_FILIAL', 'ZZ8_FILIAL' }, { 'ZZ9_REGIST', 'ZZ8_REGIST' } }, ZZ9->(IndexKey(1)) )

	oModel:SetPrimaryKey({ 'ZZ8_FILIAL', 'ZZ8_REGIST' })

	oModel:getModel('FIELD1'):SetDescription('Cabecalho')
	oModel:getModel('GRID1'):SetDescription('Itens')

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Robson Mazzarotto

@since 12/12/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'ZZ8')
	Local oStr2:= FWFormStruct(2, 'ZZ9')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:AddGrid('FORM3' , oStr2,'GRID1')
	oView:CreateHorizontalBox( 'BOXFORM1', 50)
	oView:CreateHorizontalBox( 'BOXFORM3', 50)
	oView:SetOwnerView('FORM3','BOXFORM3')
	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:AddIncrementField('FORM3', 'ZZ9_ITEM' )

Return oView

User Function STBENLEG()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",      "Planejamento em Pedido de venda"  })
	AADD(aLegenda,{"BR_VERMELHO",   "Planejamento Estornado"})
	AADD(aLegenda,{"BR_CINZA",   	"Gerado nota fiscal de beneficiamento"})

	BrwLegenda("Grupo de Produtos", "Procedencia", aLegenda)
Return

/*/{Protheus.doc} STGridOP
Função para carregar a grip com OP informada
@type function
@author Robson Mazzarotto
@since 22/01/2017
@version 1.0
/*/
User Function STGridOP()

	Local oModel	:= FWModelActive()
	Local oView		:= FWViewActive()
	Local dDataINI	:= oModel:GetValue("FIELD1","ZZ8_DATAIN")
	Local dDataFIM	:= oModel:GetValue("FIELD1","ZZ8_DATAFI")
	Local cCodOP	:= oModel:GetValue("FIELD1","ZZ8_OP")
	Local cRegister	:= oModel:GetValue("FIELD1","ZZ8_REGIST")
	Local cTipo		:= oModel:GetValue("FIELD1","ZZ8_TIPO")
	Local lImporta	:= .F.
	Local _cForne  	:= ""
	Local _cLoja   	:= ""
	Local _cCnd     := ""
	Local _cAlias	:= " "
	Local cPesqOp	:= ""
	Local cItem		:= Repl("0",Len(ZZ9->ZZ9_ITEM))
	Local nCont		:= 0
	Local nQtdEnd	:= 0
	Local nQtdOp	:= 0
	Local aRetForn	:= {}
	Local _dData    := Date()

	_cAlias := GetNextAlias()

	If cTipo == '1' // Apontamento
		BeginSql alias _cAlias
			column ZZ8_DATA as Date

			SELECT D3_COD,D3_OP,D3_QUANT,D3_EMISSAO, D3_XQTDPLA, B1_DESC, SD3.R_E_C_N_O_ RECSD3
			FROM %table:SD3% SD3, %table:SB1% SB1
			WHERE SD3.D3_FILIAL = %xFilial:SD3%
			AND SB1.B1_FILIAL = %xFilial:SB1%
			AND SD3.D3_EMISSAO BETWEEN %Exp:DToS(dDataINI)% AND %Exp:DToS(dDataFIM)%
			// AND SD3.D3_OP = %exp:cCodOP%
			AND SB1.B1_COD = SD3.D3_COD
			AND SB1.B1_XBENEF = 'S'
			// DESCONSIDERA PRODUTO FANTASMA  -VALDEMIR RABELO 19/07/2019
			AND SB1.B1_FANTASM <> 'S'
			//-----------------------------------------
			AND SD3.D3_CF = 'PR0'
			AND SD3.D3_ESTORNO = ''
			//AND SD3.D3_QUANT > (SD3.D3_XQTDPLA*-1)
			AND SD3.D3_QUANT > SD3.D3_XQTDPLA
			AND SD3.%notdel%

		EndSql

		dbSelectArea(_cAlias)

		If Eof()
			MsgAlert("Não foram encontrados registros para o periodo informado.","Atenção")
			Return .F.
		Else

			SBF->(dbSetOrder(2))	//BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
			SG1->(dbSetOrder(2))	//G1_FILIAL+G1_COD+G1_COMP+G1_TRT

			lImporta := MsgYesNo( "Confirma a importação dos apontamentos? Os itens digitados manualmente serão perdidos." )

			If lImporta

				While !(_cAlias)->(Eof())
					cItem	:= Soma1(cItem,Len(ZZ9->ZZ9_ITEM))
					nQtdEnd	:= 0

					If nCont > 0
						oModel:GetModel("GRID1"):AddLine()
					EndIf

					aRetForn := GetSA2( ( _cAlias )->D3_COD )

					If !SG1->(dbSeek(xFilial("SG1")+(_cAlias)->D3_COD))
						MsgAlert("Produto "+Alltrim((_cAlias)->D3_COD)+"-"+AllTrim((_cAlias)->B1_DESC)+" não possuí codigo PAI na tabela 'SG1' cadastro de estrutura de produtos.","Atenção")
						(_cAlias)->(dbSkip())
						Loop
					EndIf
					IF (( (_cAlias)->D3_QUANT - (_cAlias)->D3_XQTDPLA) )==0		// Valdemir Rabelo 19/07/2019
						MsgAlert("Produto "+Alltrim((_cAlias)->D3_COD)+"-"+AllTrim((_cAlias)->B1_DESC)+" Produto com quantidade zerada.","Atenção")
						(_cAlias)->(dbSkip())
						Loop				   
					Endif

					SBF->(dbSeek(xFilial("SBF")+(_cAlias)->D3_COD+"01"))
					While !SBF->(Eof()) .AND. SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL == xFilial("SBF")+(_cAlias)->D3_COD+"01"
						nQtdEnd += SBF->BF_QUANT
						SBF->(dbSkip())
					EndDo

					oModel:SetValue("GRID1","ZZ9_FILIAL"	, xFilial("ZZ9")		)
					oModel:SetValue("GRID1","ZZ9_ITEM"		, cItem					)
					oModel:SetValue("GRID1","ZZ9_REGIST"	, cRegister				)
					oModel:SetValue("GRID1","ZZ9_OP"		, Alltrim((_cAlias)->D3_OP)		)
					oModel:SetValue("GRID1","ZZ9_FORNEC"	, aRetForn[1]	 		)
					oModel:SetValue("GRID1","ZZ9_LOJA"		, aRetForn[2]			)
					oModel:SetValue("GRID1","ZZ9_RAZAO"		, Posicione("SA2",1,XFILIAL("SA2")+aRetForn[1]+aRetForn[2], "A2_NOME" ) )
					oModel:LoadValue("GRID1","ZZ9_QUANT"	, (_cAlias)->D3_QUANT - (_cAlias)->D3_XQTDPLA	)
					oModel:LoadValue("GRID1","ZZ9_QTDEND"	, nQtdEnd	)
					oModel:SetValue("GRID1","ZZ9_PRODUT"	, Alltrim( (_cAlias)->D3_COD	 )	)
					oModel:SetValue("GRID1","ZZ9_DESCRI"	, (_cAlias)->B1_DESC		)
					oModel:SetValue("GRID1","ZZ9_DATAIN"	, dDataINI				)
					oModel:SetValue("GRID1","ZZ9_DATAFI"	, dDataFIM				)
					oModel:SetValue("GRID1","ZZ9_RECSD3"	, (_cAlias)->RECSD3		)

					nCont ++

					(_cAlias)->(dbSkip())

					//--------------------------------------------------------
					// Posiciona na primeira linha após a atualização da grid
					//--------------------------------------------------------
					oView:SetViewAction( 'REFRESH', { |oView| U_STGridOP( oView ) } )
					oModel:GetModel( "GRID1" ):GoLine( 1 )

				EndDo
			EndIf
		EndIf

	ElseIf cTipo == '2' //Ordem de Produção

		cPesqOp := Posicione( "SC2", 1, xFilial( "SC2" )+ cCodOP, "C2_PRODUTO"	)
		nQtdOp  := Posicione( "SC2", 1, xFilial( "SC2" )+ cCodOP, "C2_QUANT" 	)

		If !(Empty( cPesqOp ))

			BeginSQL alias _cAlias
				SELECT G1_COMP, G1_QUANT
				FROM  %Table:SG1% SG1
				WHERE G1_COD = %Exp:cPesqOp%
				AND G1_FIM >= %Exp:_dData%
				AND SG1.D_E_L_E_T_ = ' '
			EndSQL

			dbSelectArea(_cAlias)
			(_cAlias)->(DbGoTop())

			If  !(Select(_cAlias) > 0)
				Help( ,, 'Help',, 'Não foram encontrados registros oara o código de operação informada', 1, 0 )
				Return .F.
			EndIf

			lImporta := MsgYesNo( "Confirma a importação da Estrutura da Ordem de Produção? Os itens digitados manualmente serão perdidos." )

			If lImporta

				SBF->(dbSetOrder(2))	//BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
				SG1->(dbSetOrder(1))	//G1_FILIAL+G1_COD+G1_COMP+G1_TRT

				While !( _cAlias )->( Eof() )
					cItem	:= Soma1( cItem, Len( ZZ9->ZZ9_ITEM ) )
					nQtdEnd	:= 0

					If nCont > 0
						oModel:GetModel("GRID1"):AddLine()
					EndIf

					aRetForn := GetSA2( Alltrim( ( _cAlias )->G1_COMP ) )

					SBF->(dbSeek(xFilial("SBF")+(_cAlias)->G1_COMP+"01"))
					While !SBF->(Eof()) .AND. SBF->BF_FILIAL+SBF->BF_PRODUTO+SBF->BF_LOCAL == xFilial("SBF")+(_cAlias)->G1_COMP+"01"
						nQtdEnd += SBF->BF_QUANT
						SBF->(dbSkip())
					EndDo

					oModel:SetValue( "GRID1","ZZ9_FILIAL"	, xFilial( "ZZ9" )		   )
					oModel:SetValue( "GRID1","ZZ9_ITEM"		, cItem					   )
					oModel:SetValue( "GRID1","ZZ9_REGIST"	, cRegister				   )
					oModel:SetValue( "GRID1","ZZ9_OP"		, cCodOP				   )
					oModel:SetValue( "GRID1","ZZ9_FORNEC"	,   aRetForn[1]  )
					oModel:SetValue( "GRID1","ZZ9_LOJA"		,   aRetForn[2]  )
					oModel:SetValue( "GRID1","ZZ9_RAZAO"	, Posicione( "SA2", 1, xFilial( "SA2" )+ FWFldGet( 'ZZ9_FORNEC' ) + FWFldGet( 'ZZ9_LOJA' ), "A2_NOME" ) )
					oModel:LoadValue( "GRID1","ZZ9_QUANT"	, ( _cAlias )->G1_QUANT * nQtdOp )
					oModel:LoadValue("GRID1","ZZ9_QTDEND"	, nQtdEnd	)
					oModel:SetValue( "GRID1","ZZ9_PRODUT"	, Alltrim( ( _cAlias )->G1_COMP ) )
					oModel:SetValue( "GRID1","ZZ9_DESCRI"	, Posicione( "SB1", 1, xFilial( "SB1" ) +	( _cAlias )->G1_COMP, "B1_DESC" ) )
					oModel:SetValue("GRID1","ZZ9_DATAIN"	, ddatabase				)
					oModel:SetValue("GRID1","ZZ9_DATAFI"	, ddatabase				)
					oModel:SetValue("GRID1","ZZ9_RECSD3"	, 0	)

					nCont ++

					( _cAlias )->( DbSkip() )

					//--------------------------------------------------------
					// Posiciona na primeira linha após a atualização da grid
					//--------------------------------------------------------
					oView:SetViewAction( 'REFRESH', { |oView| U_STGridOP( oView ) } )
					oModel:GetModel( "GRID1" ):GoLine( 1 )
				EndDo

			EndIf

		EndIf

	Else
		Help( ,, 'Help',, 'Não foi encontrado estrutura para importação com a Ordem de Produção informada, será necessário efetuar a inclusão de forma manual.', 1, 0 )
	EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} STGetZZ8

Retorna o novo Numero da ZZ8

@author Leonardo Kichitaro
/*/
//-------------------------------------------------------------------
User Function STGetZZ8()

	Local cQuery	:= GetNextAlias()
	Local nRet		:= 0

	BeginSql Alias cQuery
		SELECT COUNT(*) ZZ8NUM
		FROM %Table:ZZ8% ZZ8
		WHERE ZZ8.ZZ8_FILIAL = %xFilial:ZZ8%
		AND (ZZ8.D_E_L_E_T_= ' ' OR ZZ8.D_E_L_E_T_= '*')
	EndSql

	nRet := StrZero((cQuery)->ZZ8NUM + 1,6)

	(cQuery)->( DbCloseArea() )

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GetSA2

Busca o fornecedor na ZZ9 caso não encontre utiliza o cadastro de
Produto x Fornecedor.

@author Leonardo Kichitaro

/*/
//-------------------------------------------------------------------
Static Function GetSA2(cCodPro)

	Local aRet		:= {}

	Local cQuery	:= GetNextAlias()

	BeginSql Alias cQuery
		SELECT ZZ9_FORNEC, ZZ9_LOJA FROM
		%Table:ZZ9% ZZ9
		WHERE ZZ9.ZZ9_FILIAL = %xFilial:ZZ9%
		AND ZZ9.ZZ9_PRODUT = %Exp:cCodPro%
		AND ZZ9.D_E_L_E_T_ = ' '
		ORDER BY ZZ9.R_E_C_N_O_ DESC
		//	LIMIT 1
	EndSql

	If !(cQuery)->(Eof())
		aRet := {(cQuery)->ZZ9_FORNEC, (cQuery)->ZZ9_LOJA}
	Else
		SA5->(dbSetOrder(2))
		SA5->(dbSeek(xFilial("SA5")+cCodPro))
		If SA5->A5_FILIAL+SA5->A5_PRODUTO == xFilial("SA5")+cCodPro
			aRet := {SA5->A5_FORNECE, SA5->A5_LOJA}
		Else
			aRet := {'002968', '01'}
		EndIf
	EndIf

	(cQuery)->( DbCloseArea() )

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} STQuant

Não permite inserir uma quantidade maior que a quantidade disponível
para planejar.

Exceção: Permite apenas quando a inserção for manual (OP vazia)

@author Leonardo Kichitaro
@since

/*/
//-------------------------------------------------------------------

User Function STQuant()

	Local oModel		:= FWModelActive()
	Local oMdlGrd		:= 	oModel:GetModel( 'GRID1' )
	Local lRet      	:= .T.

	If FWFldGet( 'ZZ8_TIPO' ) == '1' .And. !Empty( FWFldGet( 'ZZ9_OP', oMdlGrd:GetLine() ) )

		dbSelectArea("SD3")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SD3")+oMdlGrd:GetValue('ZZ9_OP')+oMdlGrd:GetValue('ZZ9_PRODUT'))
			IF oMdlGrd:GetValue('ZZ9_QUANT') > SD3->D3_QUANT - SD3->D3_XQTDPLA
				lRet := .F.
				Help( ,, 'Help',, 'Quantidade digitada maior que a disponível para Planejar!', 1, 0 ) //Para cadastrar a solução é necessário cadastrar o help no arquivo de help
			Endif
		Endif

	EndIf

	Return( lRet )

	//-------------------------------------------------------------------
	/*/{Protheus.doc} ST001ProcComm( oModel )

	Cria régua de processamento da gravação

	@author Leonardo Kichitaro
	@since

	/*/
//-------------------------------------------------------------------

User Function ST001ProcComm( oModel )
	Processa( {|| ST001Commit( oModel ) },,"Realizando a geração da ordem de produção e pedido de venda" )
	Return( .T. )

	//-------------------------------------------------------------------000
	/*/{Protheus.doc} ST001Commit( oModel )

	Persistência do modelo de dados

	@author Leonardo Kichitaro
	@since

	/*/
//-------------------------------------------------------------------
Static Function ST001Commit( oModel )

	Local aArea				:= GetArea()
	Local aOProd			:= {}
	Local aAuxPv			:= {}
	Local aCabPV			:= {}
	Local aItensPV			:= {}
	Local aLinha			:= Nil
	Local cProd				:= ""
	Local nItC2				:= ""
	Local cDoc				:= ""
	Local cAux				:= ""
	Local cRegist			:= ""
	Local cOPpla         	:= ""
	Local cProvider			:= ""
	Local cNumOp			:= ""
	Local cConcatOp			:= ""
	Local nOperation		:= oModel:GetOperation()			// Pega a Operação
	Local nX				:= 0
	Local nY				:= 0
	Local nJ				:= 0
	Local nCont				:= 0
	Local nPos				:= 0
	Local nQtd				:= 0
	Local nRecSD3			:= 0
	Local nVlUnit        	:= 0
	Local nVlTot         	:= 0
	Local nItem				:= TamSx3( "C2_ITEM" )[1]
	Local nSequen			:= TamSx3( "C2_SEQUEN" )[1]
	Local oMdlGrd			:= oModel:GetModel( 'GRID1' )	// Carrego Objeto GRID
	Local lErroOP			:= .F.
	Local cOPAp          	:= ""
	Local cPbruto        	:= ""
	Local cEspeci        	:= ""
	Local cVolume        	:= ""
	Local cXtipo         	:= ""
	Local cLocal         	:= ""
	Local cTES			 	:= ""

	Private lMsErroAuto	:= .F.

	dbSelectArea("SF4")
	dbSetOrder(1)

	//Begin Transaction
	If nOperation == MODEL_OPERATION_INSERT

		ProcRegua( 0 )

		cRegist := FWFldGet( 'ZZ8_REGIST' )
		cPbruto := FWFldGet( 'ZZ8_PBRUTO' )
		cEspeci := FWFldGet( 'ZZ8_ESPECI' )
		cVolume := FWFldGet( 'ZZ8_VOLUME' )
		cXtipo  := FWFldGet( 'ZZ8_XTIPO' )

		//---------------------------------------------
		// Cria uma ordem de produção para cada item
		//---------------------------------------------

		For nX := 1 To oMdlGrd:Length()			// Quantidade de Linhas no GRID

			oMdlGrd:GoLine( nX )				// Posiciona na Linha
			If !oMdlGrd:IsDeleted()				// Se não for Deletada

				If oModel:GetModel( 'FIELD1' ):GetValue( 'ZZ8_TIPO' ) == '1' //Apontamento

					cNumOp	:= "Z9"+StrZero(ST001GetSC2(),4)
					cProd	:= Alltrim(Posicione("SG1",2,XFILIAL("SG1")+Alltrim( oMdlGrd:GetValue( 'ZZ9_PRODUT' ) ), "G1_COD"))
					nQtd	:= oMdlGrd:GetValue( 'ZZ9_QUANT' )
					cOPpla  := oMdlGrd:GetValue( 'ZZ9_OP' )
					nRecSD3	:= oMdlGrd:GetValue( 'ZZ9_RECSD3' )

					aOProd := { 	{ "C2_FILIAL"		, xFilial( "SC2" )	, Nil },;
					{ "C2_NUM"		, cNumOp			, Nil },;
					{ "C2_ITEM"		, '01'				, Nil },;
					{ "C2_SEQUEN" 	, '001'				, Nil },;
					{ "C2_PRODUTO"	, cProd				, Nil },;
					{ "C2_LOCAL"	, Posicione( "SB1", 1, xFilial( "SB1" ) + cProd, "B1_LOCPAD" )  , Nil },;
					{ "C2_UM"      	, Posicione( "SB1", 1, xFilial( "SB1" ) + cProd, "B1_UM" )		, Nil },;
					{ "C2_QUANT"	, nQtd				, Nil },;
					{ "C2_DATPRI" 	, Date()  			, Nil },;
					{ "C2_DATPRF" 	, Date()   			, Nil },;
					{ "C2_EMISSAO" 	, Date()   			, Nil },;
					{ "C2_TPOP"   	, "F"      			, Nil },;
					{ "C2_XBENEF"   , "S"      			, Nil },;
					{ "C2_XPLAN"   	, cRegist			, Nil },;
					{ "C2_XOPPLAN"   	, cOPpla			, Nil },;
					{ "AUTEXPLODE" , "S"               ,Nil} }

					MSExecAuto( { |x,y| MATA650( x, y ) }, aOProd, 3 )

					If lMsErroAuto
						DisarmTransaction()
						MostraErro()
						lErroOP := .T.
						Exit
					Else
						cConcatOp += IIf( Empty( cConcatOp ), cNumOp, "\" + cNumOp )

						//---------------------------------------------------------
						// Levantamento de dados para criação do pedido de vendas
						//---------------------------------------------------------
						cAux := FWFldGet( 'ZZ9_FORNEC', nX )

						SD3->(dbGoTo(nRecSD3))
						RecLock('SD3',.F.)
						SD3->D3_XQTDPLA := (SD3->D3_XQTDPLA + FWFldGet('ZZ9_QUANT',nX))
						SD3->(MsUnLock())

					Endif

				elseif oModel:GetModel( 'FIELD1' ):GetValue( 'ZZ8_TIPO' ) == '2' //OP
					dbSelectArea("SC2")
					dbSetOrder(1)
					dbGotOP()

					IF dbSeek(xFilial("SC2")+FWFldGet( 'ZZ9_OP', nX ))
						RecLock('SC2',.F.)
						SC2->C2_XPLAN := oModel:GetModel( 'FIELD1' ):GetValue( 'ZZ8_REGIST' )
						SC2->(MsUnLock())
					ENDIF

				Endif

				If Empty( aAuxPv )
					Aadd( aAuxPV, { FWFldGet( 'ZZ9_FORNEC'  , nX ),;
					FWFldGet( 'ZZ9_LOJA'	, nX ),;
					{ { FWFldGet( 'ZZ9_PRODUT'	, nX ),;
					FWFldGet( 'ZZ9_QUANT'	, nX ),;
					FWFldGet( 'ZZ9_OP'		, nX ),;
					cNumOp						  } } } )

				Else
					//---------------------------------------------------------------
					// Verifica se o Fornecedor ja existe pra concatenar os produtos
					//---------------------------------------------------------------
					If ( nPos := AScan( aAuxPV,{ |x| x[1] == FWFldGet( 'ZZ9_FORNEC', nX ) } ) ) > 0
						Aadd( aAuxPV[nPos,3],{ FWFldGet( 'ZZ9_PRODUT', nX ),;
						FWFldGet( 'ZZ9_QUANT' , nX ),;
						FWFldGet( 'ZZ9_OP'	 , nX ),;
						cNumOp 						} )

					Else
						Aadd( aAuxPV, { FWFldGet( 'ZZ9_FORNEC'	, nX ),;
						FWFldGet( 'ZZ9_LOJA'	, nX ),;
						{ {	 FWFldGet( 'ZZ9_PRODUT'	, nX ),;
						FWFldGet( 'ZZ9_QUANT'	, nX ),;
						FWFldGet( 'ZZ9_OP'		, nX ),;
						cNumOp						  } } } )
					EndIf

				EndIf

			Endif

			nCont++
		Next( nX )

		If !lErroOP .OR. oModel:GetModel( 'FIELD1' ):GetValue( 'ZZ8_TIPO' ) == '3' //Retrabalho
			//---------------------------------------------------------------
			// Após a divisão dos produtos, gera Pedido de venda
			//---------------------------------------------------------------
			For nY := 1 To Len( aAuxPV )
				cDoc := GetSxeNum( "SC5", "C5_NUM" )
				RollBAckSx8()
				aCabPV		:= {}
				aItensPV	:= {}
				Aadd( aCabPV, { "C5_FILIAL"		, xFilial( "SC5" )		, Nil } )
				Aadd( aCabPV, { "C5_NUM"		, cDoc					, Nil } )
				Aadd( aCabPV, { "C5_TIPO" 	  	, "B"					, Nil } )
				Aadd( aCabPV, { "C5_TIPOCLI"	, "F"					, Nil } )
				Aadd( aCabPV, { "C5_CLIENTE"	, aAuxPV[nY, 1]			, Nil } )
				Aadd( aCabPV, { "C5_LOJACLI"	, aAuxPV[nY, 2]			, Nil } )
				Aadd( aCabPV, { "C5_CLIENT"		, aAuxPV[nY, 1]			, Nil } )
				Aadd( aCabPV, { "C5_LOJAENT"	, aAuxPV[nY, 2]			, Nil } )
				Aadd( aCabPV, { "C5_CONDPAG"	, "502"					, Nil } )
				Aadd( aCabPV, { "C5_ZCONDPG"	, "502"					, Nil } )
				Aadd( aCabPV, { "C5_ZFATBLQ"	, "3"						, Nil } )
				Aadd( aCabPV, { "C5_TPFRETE"	, "F"						, Nil } )
				Aadd( aCabPV, { "C5_TRANSP"		, "10000"					, Nil } )
				Aadd( aCabPV, { "C5_XTIPF"		, "1"						, Nil } )
				Aadd( aCabPV, { "C5_XPLAN"		, cRegist					, Nil } )
				Aadd( aCabPV, { "C5_XPLAAPR"	, "N"						, Nil } )
				Aadd( aCabPV, { "C5_XUSER"	    , __cUserId				, Nil } )
				Aadd( aCabPV, { "C5_PBRUTO"	    , cPbruto		 			, Nil } )
				Aadd( aCabPV, { "C5_ESPECI1"    , cEspeci					, Nil } )
				Aadd( aCabPV, { "C5_VOLUME1"	, cVolume					, Nil } )
				Aadd( aCabPV, { "C5_XTIPO"		, cXtipo					, Nil } )

				For nJ := 1 To Len( aAuxPV[nY, 3] )
					aLinha := {}

					nVlUnit := U_STCUSTO(Alltrim( aAuxPV[nY, 3, nJ, 1] ))
					cTES    := SuperGetMV( 'ST_XPLATES',, '518' )
					cLOCAL  := Posicione("SB1",1,xFilial("SB1")+Alltrim( aAuxPV[nY, 3, nJ, 1] ), "B1_LOCPAD")		// Valdemir Rabelo 22/07/2019
					cUM     := Posicione("SB1",1,xFilial("SB1")+Alltrim( aAuxPV[nY, 3, nJ, 1] ), "B1_UM")			// Valdemir Rabelo 22/07/2019
					if !SF4->( dbSeek(xFilial('SF4')+cTES))
						lErroOP := .T.
				    endif

					Aadd( aLinha, { "C6_ITEM"		, StrZero( nJ, 2 )						, Nil } )
					Aadd( aLinha, { "C6_PRODUTO"	, Alltrim( aAuxPV[nY, 3, nJ, 1] )		, Nil } )
					Aadd( aLinha, { "C6_OPER"		, "74"									, Nil } )
					Aadd( aLinha, { "C6_QTDVEN"		, aAuxPV[nY, 3, nJ, 2]			 		, Nil } )
					Aadd( aLinha, { "C6_PRCVEN"		, nVlUnit								, Nil } )
					Aadd( aLinha, { "C6_PRUNIT"		, nVlUnit								, Nil } )
					Aadd( aLinha, { "C6_VALOR"		, ( nVlUnit * aAuxPV[nY, 3, nJ, 2] )	, Nil } )
					Aadd( aLinha, { "C6_LOCAL"		, cLOCAL								, Nil } )			// Valdemir Rabelo 22/07/2019
					Aadd( aLinha, { "C6_TES"		, cTES									, Nil } )
					Aadd( aLinha, { "C6_CF"			, SF4->F4_CF							, Nil } )			// Valdemir Rabelo 22/07/2019
					Aadd( aLinha, { "C6_UM"			, cUM									, Nil } )			// Valdemir Rabelo 22/07/2019
					//Aadd( aLinha, { "C6_CLASFIS"	, cClasFis								, Nil } )			// Valdemir Rabelo 22/07/2019
					If oModel:GetModel( 'FIELD1' ):GetValue( 'ZZ8_TIPO' ) == '1' //Apontamento
						Aadd( aLinha, { "C6_LOCALIZ"	, "1BENEFICIAMENTO"						, Nil } )
						Aadd( aLinha, { "C6_XLOTBEN"	, Alltrim( aAuxPV[nY, 3, nJ, 3] )	    , Nil } ) //Grava o número da ordem de produção gerada (ZZ9_OP).
						Aadd( aLinha, { "C6_XOPBENF"	, Alltrim( aAuxPV[nY, 3, nJ, 4] )		, Nil } ) //Grava o número da ordem de produção gerada (SC2).
					else
						Aadd( aLinha, { "C6_XOPBENF"	, Alltrim( aAuxPV[nY, 3, nJ, 3] )		, Nil } ) //Grava o número da ordem de produção gerada (ZZ9_OP).
						Aadd( aLinha, { "C6_LOCALIZ"	, "1BENEFICIAMENTO"						, Nil } )
					endif
					Aadd( aLinha, { "C6_CHASSI"		, "*"									, Nil } )		// Valdemir Rabelo 22/07/2019
					Aadd( aLinha, { "C6_TURNO"		, "*"									, Nil } )		// Valdemir Rabelo 22/07/2019

					Aadd( aItensPV, aLinha )

					nVlTot += (  nVlUnit * aAuxPV[nY, 3, nJ, 2] )
				Next( nJ )

				_lCriouSa1 := .F.

				//Solução temporária enquanto a totvs não resolve o problema do eof quando usa fornecedor no pv
				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				If !SA1->(DbSeek(xFilial("SA1")+aAuxPV[nY, 1]+aAuxPV[nY, 2]))
					SA1->(RecLock("SA1",.T.))
					SA1->A1_COD 	:= aAuxPV[nY, 1]
					SA1->A1_LOJA 	:= aAuxPV[nY, 2]
					SA1->(MsUnLock())
					_lCriouSa1 := .T.
				EndIf

				MSExecAuto( { |x,y,z| MATA410( x, y, z ) }, aCabPV, aItensPV, 3 )

				If _lCriouSa1
					SA1->(DbSetOrder(1))
					If !SA1->(DbSeek(xFilial("SA1")+aAuxPV[nY, 1]+aAuxPV[nY, 2]))
						SA1->(RecLock("SA1",.F.))
						SA1->(DbDelete())
						SA1->(MsUnLock())
					EndIf
				EndIf

				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
				Else
					//-------------------------------------
					// Envia e-mail para os responsáveis
					//-------------------------------------
					cProvider := Posicione( 'SA2', 1, xFilial( 'SA2' ) + aAuxPV[nY, 1] + aAuxPV[nY, 2], 'A2_NOME' )
					U_ST001WFPed( cDoc, cProvider, 1, /*cSolCom*/, /*cPedCom*/, nVlTot, cRegist, cConcatOp )
				EndIf

			Next( nY )
		EndIf

		If lMsErroAuto
			DisarmTransaction()
		Else
			FWFormCommit( oModel )
		EndIf

	EndIf

	//End Transaction

	RestArea( aArea )

Return( .T. )

//-------------------------------------------------------------------
/*/{Protheus.doc} ST001GetSC2

Retorna o novo Numero da SC2

@author Leonardo Kichitaro
/*/
//-------------------------------------------------------------------
Static Function ST001GetSC2()

	Local cQuery	:= GetNextAlias()
	Local cNum		:= "Z9%"
	Local nRet		:= 0

	BeginSql Alias cQuery
		SELECT COUNT(*) SC2NUM
		FROM %Table:SC2% SC2
		WHERE SC2.C2_FILIAL = %xFilial:SC2%
		AND SC2.C2_NUM LIKE %Exp:cNum%
		//AND SC2.D_E_L_E_T_= ' '
	EndSql

	nRet := (cQuery)->SC2NUM + 1

	(cQuery)->( DbCloseArea() )

Return nRet

//-------------------------------------------------------------------
/*/{Protheus.doc} STBENEST

Estorno do Processo de geração da OP e do PV

@author Leonardo Kichitaro
/*/
//-------------------------------------------------------------------
User Function STBENEST(pRejeita)

	Local lRet		:= .T.

	Local cQuery	:= ""
	Local cPlanej	:= ZZ8->ZZ8_REGIST

	Local aArea		:= {}
	Local aCabec	:= {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local lMsg      := .T.

	Local nRecSC6	:= 0

	PRIVATE lMsErroAuto := .F.
	Default pRejeita := .F.						// Adicionado por Valdemir Rabelo 26/07/2019

	If ZZ8->ZZ8_STATUS == 'E'
		MsgAlert("Planejamento já estornado!","Atenção")
		Return
	ElseIf ZZ8->ZZ8_STATUS == 'B'
		MsgAlert("Planejamento já possui nota de entrada vinculada, não é possível realizar o estornado!","Atenção")
		Return
	EndIf

	if !pRejeita					// Adicionado por Valdemir Rabelo 26/07/2019
		lMsg  := MsgNoYes("Deseja realmente estornar a ordem de produção e o pedido de venda gerado pelo beneficiamento ?","Estorno do Processo de Beneficiamento")
	else
		lMsg  := .T.
	endif

	If lMsg

		Begin Transaction

			SC6->(dbSetOrder(1))	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO

			//Exclui Pedido de Venda
			cQuery := GetNextAlias()

			BeginSql Alias cQuery
				SELECT SC5.R_E_C_N_O_ RECSC5, SC5.C5_NUM FROM
				%Table:SC5% SC5
				WHERE SC5.C5_FILIAL 	= %xFilial:SC5%
				AND SC5.C5_XPLAN		= %Exp:cPlanej%
				AND SC5.D_E_L_E_T_	= ' '
			EndSql

			(cQuery)->(DbGoTop())
			While !(cQuery)->(Eof())

				SC5->(dbGoTo((cQuery)->RECSC5))

				aadd(aCabec,{"C5_FILIAL"	,SC5->C5_FILIAL		,Nil})
				aadd(aCabec,{"C5_NUM"		,SC5->C5_NUM		,Nil})
				aadd(aCabec,{"C5_TIPO"		,SC5->C5_TIPO		,Nil})
				aadd(aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE	,Nil})
				aadd(aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI	,Nil})
				aadd(aCabec,{"C5_LOJAENT"	,SC5->C5_LOJAENT	,Nil})
				aadd(aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG	,Nil})
				aadd(aCabec,{"C5_ZFATBLQ"	,"1"				,Nil})

				SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
				While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
					aLinha := {}
					aadd(aLinha,{"LINPOS"		,"C6_ITEM"	   		,SC6->C6_ITEM	})
					aadd(aLinha,{"AUTDELETA"	,"S"				,Nil			})
					aadd(aLinha,{"C6_PRODUTO"	,SC6->C6_PRODUTO	,Nil			})
					aadd(aLinha,{"C6_QTDVEN"	,SC6->C6_QTDVEN		,Nil			})
					aadd(aLinha,{"C6_PRCVEN"	,SC6->C6_PRCVEN		,Nil			})
					aadd(aLinha,{"C6_PRUNIT"	,SC6->C6_PRUNIT		,Nil			})
					aadd(aLinha,{"C6_VALOR"		,SC6->C6_VALOR		,Nil			})
					aadd(aLinha,{"C6_TES"		,SC6->C6_TES		,Nil			})
					aadd(aItens,aLinha)

					nRecSC6 := SC6->(Recno())

					//Estorna os itens liberados do pedido de venda
					SC9->(dbSetOrder(1))
					SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
					If SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM
						aArea := GetArea()
						a460Estorna(.T.)
						RestArea(aArea)
					EndIf

					SC5->(dbGoTo((cQuery)->RECSC5))
					SC6->(dbGoTo(nRecSC6))

					//Elimina Residuo
					aArea := GetArea()
					MaResDoFat(nil, .T., .F.,)
					MaLiberOk({ SC5->C5_NUM }, .T.)
					RestArea(aArea)

					SC5->(dbGoTo((cQuery)->RECSC5))
					SC6->(dbGoTo(nRecSC6))

					SC6->(dbSkip())
				EndDo

				(cQuery)->(dbSkip())

			EndDo

			(cQuery)->( DbCloseArea() )

			//Estorna a op gerada pelo planejamento
			If lRet

				lMsErroAuto := .F.

				cQuery := GetNextAlias()

				BeginSql Alias cQuery
					SELECT SC2.R_E_C_N_O_ RECSC2, SC2.C2_NUM FROM
					%Table:SC2% SC2
					WHERE SC2.C2_FILIAL 	= %xFilial:SC2%
					AND SC2.C2_XPLAN		= %Exp:cPlanej%
					AND SC2.D_E_L_E_T_	= ' '
				EndSql

				(cQuery)->(DbGoTop())
				While !(cQuery)->(Eof())

					SC2->(dbGoTo((cQuery)->RECSC2))

					aadd(aCabec,{"C2_FILIAL"	,SC2->C2_FILIAL		,Nil})
					aadd(aCabec,{"C2_PRODUTO"	,SC2->C2_PRODUTO	,Nil})
					aadd(aCabec,{"C2_NUM"		,SC2->C2_NUM		,Nil})
					aadd(aCabec,{"C2_ITEM"		,SC2->C2_ITEM		,Nil})
					aadd(aCabec,{"C2_SEQUEN"	,SC2->C2_SEQUEN		,Nil})

					MSExecAuto( { |X,Y| Mata650( X, Y ) }, aCabec, 5 )

					If lMsErroAuto
						DisarmTransaction()
						MostraErro()
						lRet := .F.
						Exit
					EndIf

					(cQuery)->(dbSkip())

				EndDo

			EndIf

			If lRet
				if ZZ8->ZZ8_TIPO = "1"

					ZZ9->(dbSetOrder(1))	//ZZ9_FILIAL+ZZ9_REGIST
					ZZ9->(dbSeek(xFilial("ZZ9")+cPlanej))
					While !ZZ9->(Eof()) .And. ZZ9->ZZ9_FILIAL+ZZ9->ZZ9_REGIST == xFilial("ZZ9")+cPlanej
						SD3->(dbGoTo(ZZ9->ZZ9_RECSD3))
						RecLock('SD3',.F.)
						SD3->D3_XQTDPLA := (SD3->D3_XQTDPLA - ZZ9->ZZ9_QUANT)
						SD3->(MsUnLock())
						ZZ9->(dbSkip())
					EndDo

				endif

				RecLock('ZZ8',.F.)
				ZZ8->ZZ8_STATUS := "E"
				ZZ8->(MsUnLock())

			EndIf

		End Transaction

		if !pRejeita			// Adicionado por Valdemir Rabelo 26/07/2019
			If lRet
				MsgInfo("Estorno realizado com sucesso!","Estorno OK")
			Else
				MsgAlert("Estorno não realizado!","Estorno OK")
			EndIf
		Endif
	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} STBENEXC

Exclusão do Processo de geração da OP e do PV

@author Leonardo Kichitaro
/*/
//-------------------------------------------------------------------
User Function STBENEXC()

	Local oModel := Nil
	Local oView	 := Nil

	If ZZ8->ZZ8_STATUS <> 'E'
		MsgAlert("Planejamento não estornado!","Atenção")
		Return
	EndIf

	oModel := FWLoadModel( 'STBEN001' )
	oView  := FWLoadView ( 'STBEN001' )

	oModel:SetOperation( MODEL_OPERATION_DELETE )
	oModel:Activate()

	oExecView := FWViewExec():New()
	oExecView:SetTitle( "Exclusão do Planejamento" )
	oExecView:SetView( oView )
	oExecView:SetModal(.F.)
	oExecView:SetOperation( MODEL_OPERATION_DELETE )
	oExecView:SetModel( oModel )
	oExecView:SetCloseOnOK({|| .T.})
	oExecView:OpenView( .F. )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ST001WFPed

Envia e-mail aos responsáveis informando a geração do pedido de vendas
pelo planejamento de beneficiamento

@author Leonardo Kichitaro
@since

/*/
//-------------------------------------------------------------------
User Function ST001WFPed( cOrder, cProvider, nTipoWF, cSolCom, cPedCom, nVlTot, cRegist, cConcatOp )

	Local lResult			:= .F.
	Local cAccount		:= SuperGetMV( "MV_RELAUSR",, ""  ) // Conta dominio 	Ex.: Teste@email.com.br
	Local cPassword		:= SuperGetMV( "MV_RELAPSW",,  ""  ) // Pass da conta 	Ex.: Teste123
	Local cServer			:= SuperGetMV( "MV_RELSERV",, ""  ) // Smtp do dominio	Ex.: smtp.email.com.br
	Local cFrom   		:= SuperGetMV( "ST_XEMABEN",, ""  ) // "gerente01@email.com.br"
	Local lRelauth  		:= SuperGetMv( "MV_RELAUTH",, .T. ) // Utiliza autenticação
	Local cBody			:= ST001MntMsg( cOrder, cProvider )
	local lAut				:= .F.
	Local cSubject		:= ""
	Default nTipoWF := 1
	If nTipoWF == 1
		cSubject := "Pedido de Venda gerado por Beneficiamento"
	ElseIf nTipoWF == 2
		cSubject := "Solicitação/Pedido de Compra gerado por Beneficiamento"
	EndIf

	cBody := ST001MntMsg( cOrder, cProvider, nTipoWF, cSolCom, cPedCom, nVlTot, cRegist, cConcatOp )

	U_STMAILTES(cFrom, "", cSubject, cBody,{},"")

	/*
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

	If lRelauth
	lAut := MailAuth( Alltrim( Subs( cAccount, 1, At( "@", cAccount ) -1 ) ), cPassword )
	Else
	lAut := .T.
	EndIf

	If lResult .And. lAut

	SEND MAIL FROM 	cAccount;
	TO  			cFrom;
	SUBJECT     	cSubject;
	BODY    		cBody;
	RESULT 		lResult

	If !lResult
	Conout( 'E-mail não enviado' )
	EndIf

	DISCONNECT SMTP SERVER

	Else
	GET MAIL ERROR cError
	Help( " ", 1, "Erro WF",, cError, 4, 5 )
	EndIf
	*/
Return( .T. )

//-------------------------------------------------------------------
/*/{Protheus.doc} ST001MntMsg

Montagem da mensagem de Workflow

@author Leonardo Kichitaro
@since

/*/
//-------------------------------------------------------------------
Static Function ST001MntMsg( cOrder, cProvider, nTipoWF, cSolCom, cPedCom, nVlTot, cRegist, cConcatOp )

	Local cMsg			:= ""
	Local cCaminho		:= ""

	Default nTipoWF		:= 1
	Default nVlTot		:= 0
	Default cRegist		:= ""
	Default cConcatOp	:= ""

	cMsg := ' <html>'
	cMsg += ' <head>'
	cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	If nTipoWF == 1
		cMsg += '<title>Pedido de venda de Beneficiamento</title>'
	ElseIf nTipoWF == 2
		cMsg += '<title>Solicitação/Pedido de Compra de Beneficiamento</title>'
	EndIf
	cMsg += '<style type="text/css">'
	cMsg += '<!--'
	cMsg += 'body{'
	cMsg += 'margin:0;'
	cMsg += '	padding:0;'
	cMsg += 'background-color:#c7e4ec;'
	cMsg += '}'
	cMsg += '-->'
	cMsg += '</style>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<table cellpadding="0" cellspacing="0" border="0" width="100%" style="width:100%;background-color:#c7e4ec;width:100%" bgcolor="#c7e4ec">'
	cMsg += '	<tr>'
	cMsg += '		<td>'
	cMsg += '			<table cellpadding="0" cellspacing="0" border="0" width="600px" align="center" style="width:600px;font-family:Verdana, Helvetica, sans-serif;color:#333333;font-size:13px;line-height:150%">'
	cMsg += '				<tr>'
	cMsg += '					<td style="border-top:5px #5db9cf solid;border-bottom:5px #5db9cf solid" >'
	cMsg += '						<img src="'+cCaminho+'" style="display:block" border="0" />' //cCaminho = Definir o caminho da imagem que será apresentada no e-mail
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#FFFFFF" valign="top" align="center" style="padding:10px;color:#212121;font-size:15px;font-weight:bold" >'
	cMsg += '						Informativo de geração de pedido de compras'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#FFFFFF" style="padding:20px;padding-bottom:0px;color:#212121" align="center">'
	cMsg += '						Prezado(a),'
	cMsg += '						<br></br>'
	If nTipoWF == 1
		cMsg += '						Informamos que houve a geração de Pedido de Vendas através de Planejamento de Beneficiamento'
	ElseIf nTipoWF == 2
		cMsg += '						Informamos que houve a geração de Pedido de Compras através de Planejamento de Beneficiamento'
	EndIf
	cMsg += '						<br></br>'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" bgcolor="#5db9cf" valign="top" align="left" style="font-family:Arial Narrow, Arial, Helvetica, sans-serif;font-size:18px; font-weight:bold;color:#ffffff;">'
	cMsg += '					&nbsp; &nbsp; Dados do Pedido:'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '				<tr>'
	cMsg += '                    <td colspan="2" bgcolor="#FFFFFF" "font-family:Arial Narrow, Arial, Helvetica, sans-serif; font-size:14px; color:#212121;">'
	If nTipoWF == 1
		cMsg += '					<br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Número do Pedido: </span> ' +cOrder
		cMsg += '                   <br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Planejamento: </span> ' +cRegist
		cMsg += '                   <br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Ordem de Produção: </span> ' +cConcatOp
		cMsg += '                   <br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Custo Total: </span> ' +CValToChar( nVlTot )
		cMsg += '                   <br></br>'
	ElseIf nTipoWF == 2
		cMsg += '					<br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Solicitação de Compra: </span> ' +cSolCom
		cMsg += '                   <br></br>'
		cMsg += '					<br></br>'
		cMsg += '						&nbsp; &nbsp; <span style="font-weight: bold">  Pedido de Compra: </span> ' +cPedCom
		cMsg += '                   <br></br>'
	EndIf
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Fornecedor: </span> ' +cProvider
	cMsg += '                        <br></br>'
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Data: </span> ' +DtoC( Date() )
	cMsg += '                        <br></br>'
	cMsg += '                       &nbsp; &nbsp; <span style="font-weight: bold"> Hora: </span> ' +Time()
	cMsg += '                        <br></br>'
	cMsg += '						<br></br>'
	cMsg += '					</td>'
	cMsg += '                </tr>'
	cMsg += '				<tr>'
	cMsg += '					<td colspan="2" style="padding-top:10px;font-size:11px">'
	cMsg += '						<i>'
	cMsg += '						Você esté recebendo esta mensagem porque está cadastrado como responsável. Caso não deseje receber esse tipo de mensagem, por favor, entre em contato com o Administrador do sistema.'
	cMsg += '						</i>'
	cMsg += '					</td>'
	cMsg += '				</tr>'
	cMsg += '			</table>'
	cMsg += '		</td>'
	cMsg += '	</tr>'
	cMsg += '</table>'
	cMsg += '</body>'
	cMsg += '</html>'

Return( cMsg )
