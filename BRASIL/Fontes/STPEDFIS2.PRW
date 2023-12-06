#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"

/*====================================================================================\
|Programa  | STPEDFIS         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição | STPEDFIS                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDFIS                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPEDFIS(_cStPed)
	*-----------------------------*
	
	Local _nOpcao 	:= 3
	Local _xAlias 	:= GetArea()
	Local aFields 	:= {}
	Local aCpoEnch	:= {}
	Local aTam  	:= {}
	Local aNoEnch	:= {"C5_NUM","C5_CLIENTE"}
	Local oDlg
	Local _cCodAut  := GetMv("ST_CODFIS",,'000000')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipos das Opcoes						  ³
	//³ _nOpcao == 1 -> Incluir					  ³
	//³ _nOpcao == 2 -> Visualizar                ³
	//³ _nOpcao == 3 -> Alterar                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Local bCampoSC5	:= { |nCPO| Field(nCPO) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arrays de controle dos campos que deverao ser alterados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCposAlt := {}
	Local nCntFor := 1
	Local _ni := 1
	
	If __cuserid $ _cCodAut
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria variaveis M->????? da Enchoice                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 TO FCount()
			M->&(EVAL(bCampoSC5,nCntFor)) := FieldGet(nCntFor)
		Next nCntFor
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria aHeader e aCols da GetDados                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nUsado:=0
		
		
		//				  1-Campo    , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		, 6-Validacao  											, 7-ComboBox
		aTam := TamSX3("C6_PRODUTO")
		AAdd( aFields, { 'C6_PRODUTO', 'C'	, aTam[1]	, 0		, 'PRODUTO'		, " "													, ''				  					} )
		aTam := TamSX3('C6_DESCRI')
		AAdd( aFields, { 'C6_DESCRI' , 'C'	, aTam[1]	, 0		, 'DESCRIÇÃO'	, " "													, ''				  					} )
		aTam := TamSX3('C6_ITEM')
		AAdd( aFields, { 'C6_ITEM' 	 , 'C'	, aTam[1]	, 0		, 'ITEM	 '  	, " "													, ''				  					} )
		aTam := TamSX3('C6_TES')
		AAdd( aFields, { 'TES'	     , 'C'	, aTam[1]   , 0		, 'TES	 ' 		, " "				   									, ''				   					} )
		aTam := TamSX3("C6_CF")
		AAdd( aFields, { 'CFOP' 	 , 'C'	, aTam[1]   , 0		, 'Cod. Fiscal'	, " "	  							   					, ''  									} )
		aTam := TamSX3("C6_CLASFIS")
		AAdd( aFields, { 'CLASSI' 	 , 'C'	, aTam[1]   , 0		, 'Sit. Trib.'	, " "	  							   					, ''  									} )
		AAdd( aFields, { 'RECNO' 	 , 'N'	, 20   		, 0		, 'RECNO'   	, " "	  							   					, ''  									} )
		
		
		aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
		// 	01-Titulo			   			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		, 14-Visual	, 15-Valid Usuario
		aAdd( aHeader, {	aFields[01,5]+Space(20)	, aFields[01,1]	, '@!'		, aFields[01,3]	, 0			, aFields[01,6]	, ''		, aFields[01,2]	, ''		, 'R'			, aFields[01,7]	, ''			, ''   			, 'V'		, ''				} )
		aAdd( aHeader, {	aFields[02,5]+Space(20)	, aFields[02,1]	, '@!'		, aFields[02,3]	, 0			, aFields[02,6]	, ''		, aFields[02,2]	, ''		, 'R'			, aFields[02,7]	, ''			, ''  			, 'V'		, ''				} )
		aAdd( aHeader, {	aFields[03,5]+Space(20)	, aFields[03,1]	, '@!'		, aFields[03,3]	, 0			, aFields[03,6]	, ''		, aFields[03,2]	, ''		, 'R'			, aFields[03,7]	, ''			, '' 			, 'V'		, ''				} )
		aAdd( aHeader, {	aFields[04,5]+Space(20)	, aFields[04,1]	, '@!'		, aFields[04,3]	, 0			, aFields[04,6]	, ''		, aFields[04,2]	, 'SF4'		, 'R'			, aFields[04,7]	, ''			, ''			, ''		, ''				} )
		aAdd( aHeader, {	aFields[05,5]+Space(20)	, aFields[05,1]	, '@!'		, aFields[05,3]	, 0			, aFields[05,6]	, ''		, aFields[05,2]	, '13'		, 'R'			, aFields[05,7]	, ''			, ''			, ''		, ''				} )
		aAdd( aHeader, {	aFields[06,5]+Space(20)	, aFields[06,1]	, '@!'		, aFields[06,3]	, 0			, aFields[06,6]	, ''		, aFields[06,2]	, ''		, 'R'			, aFields[06,7]	, ''			, ''			, ''		, ''				} )
		aAdd( aHeader, {	aFields[07,5]+Space(20)	, aFields[07,1]	, ''		, aFields[07,3]	, 0			, aFields[07,6]	, ''		, aFields[07,2]	, ''		, 'R'			, aFields[07,7]	, ''			, '.F.'			, 'V'		, ''				} )
		
		
		nUsado:=len(aHeader)
		aCols:={}
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+_cStPed)
		While !eof().and.C6_NUM==_cStPed
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				If aHeader[_ni,2] = 'TES'
					aCols[Len(aCols),_ni]:=SC6->C6_TES
				ElseIf aHeader[_ni,2] = 'CFOP'
					aCols[Len(aCols),_ni]:=SC6->C6_CF
				ElseIf aHeader[_ni,2] = 'CLASSI'
					aCols[Len(aCols),_ni]:=SC6->C6_CLASFIS
				ElseIf aHeader[_ni,2] = 'RECNO'
					aCols[Len(aCols),_ni]:=SC6->(RECNO())
				Else
					aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
				EndIf
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			dbSkip()
		End
		
		
		IF Len(aCols)>0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa a Modelo 3                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTitulo:=OemToAnsi("Manutencao Fiscal do Pedido")
			cAliasGetD:="SC6"
			cLinOk    :="AllwaysTrue()"
			cTudoOk   :='STxGRV()'
			aCpoEnchoice:={'NOUSER','C5_NUM','C5_CLIENTE','C5_LOJACLI','C5_TIPOCLI'}
			aAltEnchoice := {}
			
			Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
				bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
			Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
			
			DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 to 28,130	of oMainWnd
			
			EnChoice( "SC5" ,SC5->(Recno()), 2, , , , aCpoEnchoice, {10,1,040,512}, aCpoEnchoice, 3 )
			//	oGetDados0 := MSNewGetDados():New (01,01,100,((aSize[6]-(aSize[6]/8))-051) , 0      , 				, 				, 			, 		, 		 , 			, 			, 			, 		,oFolder:aDialogs[1], aHeader0, aCols0)
			oGetDados  := MSNewGetDados()   :New (42,1,130,512,GD_INSERT + GD_UPDATE + GD_DELETE	,cLinOk			,cTudoOk		,""			,		, 		 ,1			,			,Len(aCols),		,   				,	aHeader,aCols		)
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpca:=1,IF(oGetDados:TudoOk(),IF(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()})
			
		EndIF
		
		
	Else
		msginfo('Usuario sem Acesso')
		
	EndIF
	RestArea(_xAlias)
	
Return
/*====================================================================================\
|Programa  | STxGRV           | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STxGRV                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STxGRV()
	*-----------------------------*
	Local i
	Local _aArea  := getarea()
	Local _lRet   := .F.
	
	If MsgYesNo('Confirma Atualização ?')
		For i:=1 To Len(aCols)
			
			DbSelectArea("SC6")
			SC6->(DbGoTop())
			SC6->(DbGoTo(aCols[i,7]))
			If 		SC6->(recno()) = aCols[i,7]
				SC6->(RecLock("SC6",.F.))
				SC6->C6_TES      :=aCols[i,4]
				SC6->C6_CF       :=aCols[i,5]
				SC6->C6_CLASFIS  :=aCols[i,6]
				SC6->(Msunlock("SC6"))
				SC6->( DbCommit() )
			EndIF
			
		Next i
		_lRet   := .T.
	EndIF
	restarea(_aArea)
Return  (_lRet)



