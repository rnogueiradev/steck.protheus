#include 'parmtype.ch'
#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)

/*====================================================================================\
|Programa  | STROMA00         | Autor | GIOVANI.ZAGO             | Data | 07/07/2017  |
|=====================================================================================|
|Descrição |   STROMA00       				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STROMA00           	                                                  |
|=====================================================================================|
|Uso       | Especifico  		                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*----------------------------------*
User Function STROMA00()
	*----------------------------------*
	Local oBrowse

	DbSelectArea("PD1")
	PD1->(DbSetOrder(1))
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("PD1")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STROMA00")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Romaneio Digital")   	// Descrição do browse
	oBrowse:AddLegend( "PD1->PD1_STATUS == '0'" , "ENABLE"		, "Não iniciado" )
	oBrowse:AddLegend( "PD1->PD1_STATUS == '1'" , "BR_AMARELO"	, "Em Andamento" )
	oBrowse:AddLegend( "PD1->PD1_STATUS == '2'" , "BR_PRETO"	, "Fechado" )
	oBrowse:AddLegend( "PD1->PD1_STATUS == '3'" , "DISABLE"		, "Encerrado" )

	oBrowse:Activate()

Return(Nil)



Static Function MenuDef()
	Local aRotina := {}
	Private _UserMvc := GetMv('ST_TELPAI',,'000000/000645')
	Public xInclui	:= .F.

	ADD OPTION aRotina TITLE "Incluir"    ACTION "u_STROMA01(PD1->(RECNO()),3)" OPERATION 3 ACCESS 0  
	ADD OPTION aRotina TITLE "Alterar"    ACTION "u_STROMA01(PD1->(RECNO()),4)" OPERATION 4 ACCESS 0  

Return aRotina


User Function STROMA01(_nRec,_nOption)
	Local lSaida := .F.
	Local nOpca  := 0
	Local aButtons := {{"LBTIK",{|| PedStx()} ,"Confirma"}}
	Local aList := {}
	Local oOk	   	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	   	:= LoadBitmap( GetResources(), "LBNO" )
	Local oChk1,oChk2,oChk3,oChk4
	Local lChk1	 	:= .T.
	Local lChk2	 	:= .T.
	Private oDlg ,oLayer01,oBrowse,oBrowse1
	Private oLayer 	:= FWLayer():new()
	Private aCoors 	:= FWGetDialogSize( oMainWnd )
	Private _aCabe 	:= {}
	Private aVetor1 := {}
	Private aVetor2 := {}


	xInclui	:= Iif(_nOption=3,.T.,.F.)

	RegToMemory("PD1", xInclui , xInclui, xInclui)

	If xInclui
		M->PD1_CODROM :=   PD1->(GetSX8Num("PD1","PD1_CODROM"))
		M->PD1_DTEMIS := dDataBase
	EndIf

	Aadd(aVetor1,{.F.,'','','','','','','','','','','',''})
	aVetor2 := GERPD2(M->PD1_CODROM)

	Do While !lSaida
		Define MsDialog oDlg Title "Romaneio Digital" From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
		oLayer:init(oDlg,.T.)//Cria as colunas do Layer
		// Primeira coluna cabeçalho.....********************************
		oLayer:addCollumn('Col01',100,.T.)		 
		oLayer:addWindow('Col01','C1_Win01','Romaneio - '+M->PD1_CODROM,040,.T.,.t.,{||   },	 ,{||   }) 
		oLayer01:= oLayer:GetWinPanel('Col01', 'C1_Win01' )
		EnChoice('PD1',_nRec,_nOption,,,,,{0,0,90,80},,,,,,oLayer01,,.f.,,,,,,,,.T.)
		// Primeira coluna cabeçalho.....********************************

		// Segunda coluna Documentos dentro do romaneio.....********************************
		//oLayer:addCollumn('Col01',100,.T.) 		
		oLayer:addWindow('Col01','C1_Win02','Doc.Romaneio - '+M->PD1_CODROM,060,.f.,.T.,{||   },,{||  })
		oLayer02:= oLayer:GetWinPanel('Col01', 'C1_Win02' )

		@ 1,1 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oLayer02 on CLICK(aEval(aVetor1,{|x| x[1]:=lChk1}) ,oList:Refresh())

		@ 10,1 LISTBOX oList FIELDS HEADER ;
		'','Doc','CF','Cliente','Zona','Emissão','Vol','Cep','Peso','T','Transportadora','Obs' ;
		SIZE oLayer02:nClientWidth/100*30,oLayer02:nClientHeight/100*50 ;
		OF oLayer02 PIXEL ON dblClick(aVetor1[oList:nAt,1] := !aVetor1[oList:nAt,1])
		oList:SetArray( aVetor1 )
		oList:bLine := {|| {Iif(aVetor1[oList:nAt,01],oOk,oNo),;
		aVetor1[oList:nAt,02],;
		aVetor1[oList:nAt,03],;
		aVetor1[oList:nAt,04],;
		aVetor1[oList:nAt,05],;
		aVetor1[oList:nAt,06],;
		aVetor1[oList:nAt,07],;
		aVetor1[oList:nAt,08],;
		aVetor1[oList:nAt,09],;
		aVetor1[oList:nAt,10],;
		aVetor1[oList:nAt,11],;
		aVetor1[oList:nAt,12];
		}}

		@ 1,oLayer02:nClientWidth/100*30 CHECKBOX oChk2 VAR lChk2 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oLayer02 on CLICK(aEval(aVetor2,{|x| x[1]:=lChk2}) ,oList2:Refresh())

		@ 10,oLayer02:nClientWidth/100*30 LISTBOX oList2 FIELDS HEADER ;
		'','Doc','CF','Cliente','Zona','Emissão','Vol','Cep','Peso','T','Transportadora'  ;
		SIZE oLayer02:nClientWidth/100*50,oLayer02:nClientHeight/100*50 ;
		OF oLayer02 PIXEL ON dblClick(aVetor2[oList2:nAt,1] := !aVetor2[oList2:nAt,1])
		oList2:SetArray( aVetor2 )
		oList2:bLine := {|| {Iif(aVetor2[oList2:nAt,01],oOk,oNo),;
		aVetor2[oList2:nAt,02],;
		aVetor2[oList2:nAt,03],;
		aVetor2[oList2:nAt,04],;
		aVetor2[oList2:nAt,05],;
		aVetor2[oList2:nAt,06],;
		aVetor2[oList2:nAt,07],;
		aVetor2[oList2:nAt,08],;
		aVetor2[oList2:nAt,09],;
		aVetor2[oList2:nAt,10],;
		aVetor2[oList2:nAt,11];
		}}


		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()}	,{|| nOpca := 0,lSaida:=.t.,oDlg:End()},,aButtons)

	End
	If nOpca =1
		If MSGYESNO("Confirma a Operação?")
			Processa({|| 	GravaRomaneio()},'Aguarde .......')
		EndIf
	EndIf

Return


Static Function GravaRomaneio()

	Local _xAlias 	:= GetArea()

	DbSelectArea("PD1")
	PD1->(DbSetOrder(1))

	If PD1->(DbSeek(xFilial("PD1")+M->PD1_CODROM)) 
		PD1->(RecLock("PD1",.F.))
	Else
		ConfirmSX8()
		PD1->(RecLock("PD1",.T.))
	EndIf

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("PD1"))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="PD1"
		If !("USERLG" $ X3_CAMPO) .AND. !(X3_CONTEXT == "V")
			If X3Uso(SX3->X3_USADO) .And. ! (AllTrim(SX3->X3_CAMPO) $ "PD1_VLRNTS")
				&("PD1->"+SX3->X3_CAMPO):= M->(&(SX3->X3_CAMPO))
			EndIf
		EndIf
		SX3->(DbSkip())

	EndDo

	PD1->(MsUnLock())
	PD1->(DbCommit())

	U_STFSF60C(PD1->PD1_CODROM,,,) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)
	RestArea(_xAlias)
Return()

Static Function STDCL01(_nLin)

	Aadd(aBrowse,{ aBrowse1[_nLin,1],aBrowse1[_nLin,2],aBrowse1[_nLin,3],aBrowse1[_nLin,4]})

	If Len(aBrowse1) = 1
		aBrowse1:= {}
		Aadd(aBrowse1,{ .T.,' ',' ',Transform(0,'@E 99,999,999,999.99')})
	Else
		Adel(aBrowse1,_nLin)
		aSize(aBrowse1,len(aBrowse1)-1)
	EndIf

	oBrowse1:refresh()
	oBrowse:refresh()
	oLayer02:refresh()
Return()

Static Function STDCL00(_nLin)

	Aadd(aBrowse1,{ aBrowse[_nLin,1],aBrowse[_nLin,2],aBrowse[_nLin,3],aBrowse[_nLin,4]})

	If Len(aBrowse) = 1
		aBrowse:= {}
		Aadd(aBrowse,{ .T.,' ',' ',Transform(0,'@E 99,999,999,999.99')})
	Else
		Adel(aBrowse,_nLin)
		aSize(aBrowse,len(aBrowse)-1)
	EndIf

	oBrowse1:refresh()
	oBrowse:refresh()
	oLayer02:refresh()
Return()

Static Function GERPD2(_cCodRom)

	Local cPerg 	:= "GERPD2"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := cPerg+cHora+cMinutos+cSegundos
	Local cPergTit 	:= cAliasLif
	Local _aRet 	:= {}


	cQuery := "SELECT 
	cQuery += " F2_DOC,F2_TPFRETE,A1_NREDUZ,F2_EMISSAO,F2_PBRUTO,PD2_QTDVOL,CASE WHEN C5_XTIPO='1' THEN 'RETIRA' ELSE 'ENTREGA' END  AS TPENT ,SUBSTR(A4_NOME,1,30) AS TRANSP

	cQuery += " FROM PD2010 PD2

	cQuery += " INNER JOIN (SELECT * FROM SF2010)SF2
	cQuery += " ON SF2.D_E_L_E_T_ = ' ' 
	cQuery += " AND F2_DOC = PD2_NFS
	cQuery += " AND F2_FILIAL = PD2_FILIAL
	cQuery += " AND F2_SERIE = PD2_SERIES

	cQuery += " INNER JOIN (SELECT * FROM SA1010)SA1
	cQuery += " ON SA1.D_E_L_E_T_ = ' ' 
	cQuery += " AND A1_COD = F2_CLIENTE
	cQuery += " AND A1_LOJA = F2_LOJA

	cQuery += " INNER JOIN(SELECT * FROM SA4010) SA4
	cQuery += " ON SA4.D_E_L_E_T_ = ' '
	cQuery += " AND SA4.A4_COD = SF2.F2_TRANSP
	cQuery += " AND A4_FILIAL = ' '

	cQuery += " INNER JOIN(SELECT * FROM SD2010 )SD2 ON SD2.D_E_L_E_T_=' '
	cQuery += " AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_ITEM='01'

	cQuery += " INNER JOIN(SELECT * FROM SC5010) SC5 ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO

	cQuery += " WHERE PD2.D_E_L_E_T_ =  ' '
	cQuery += " AND PD2_FILIAL ='"+cFilAnt+"'
	cQuery += " AND PD2_CODROM = '"+_cCodRom+"'

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			Aadd(_aRet,{ .T.,;
			substr(Alltrim((cAliasLif)->F2_DOC),4,6),; 
			Alltrim((cAliasLif)->F2_TPFRETE),; 
			substr(Alltrim((cAliasLif)->A1_NREDUZ),1,15),; 
			Alltrim(u_StCepReg((cAliasLif)->F2_DOC,'001',' ')),; 
			Alltrim( Dtoc(Stod((cAliasLif)->F2_EMISSAO))),; 
			Alltrim(cValtochar((cAliasLif)->PD2_QTDVOL)),; 
			Alltrim(u_StCepReg((cAliasLif)->F2_DOC,'001','1')),; 
			(cAliasLif)->F2_PBRUTO,; 
			Alltrim((cAliasLif)->TPENT),; 
			substr(Alltrim((cAliasLif)->TRANSP),1,20); 
			})


			(cAliasLif)->(dbskip())

		End
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	If Len(_aRet) = 0
		Aadd(_aRet,{.F.,'','','','','','','','','','',''})
	EndIf

Return(_aRet)


