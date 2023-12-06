#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#Include "TopConn.ch"
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STMENPREV      | Autor | GIOVANI.ZAGO               | Data | 28/02/2014  |
|=====================================================================================|
|Descrição | tela de troca de previsao  										      |
|          |  													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STConsFalta                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STMENPREV( )
	*---------------------------------------------------*
	Private cPerg       := 'MENPREV'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private cAliasPed   := 'X'+cPerg+cHora+ cMinutos+cSegundos
	Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
	Private aSize    	:= MsAdvSize(.F.)
	Private lMark   	:=  .T.
	Private aVetor 		:= {}
	Private aVetor2 	:= {}
	Private aSbfLoc		:= {}
	Private lSaida  	:= .F.
	Private aCpoEnch	:= {}
	Private nOpcA		:= 0
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private oChk
	Private lRetorno    := .F.
	Private lChk	 	:= .F.
	Private oLbx
	Private oLbx2
	Private oLbxz
	Private lInverte 	:= .F.
	Private nContLin 	:= 0
	Private lLote    	:= .F.
	Private oDlg
	Private oDlgx
	Private oList
	Private _nQtd   	:= 0
	Private _nQtd2 		:= 0
	Private  _nMeta 	:= 0
	Private oVlrSelec
	Private nVlrSelec 	:= 0
	Private oMarcAll
	Private lMarcAll    	:= .T.
	Private oMarked	 := LoadBitmap(GetResources(),'LBOK')
	Private oNoMarked:= LoadBitmap(GetResources(),'LBNO')
	Private oMeta
	Private oPesc
	Private oPesc2
	Private _oQtd2
	Private _oQtd
	Private _nPed  := 0
	Private _oPed
	Private _nPed2  := 0
	Private _oPed2
	Private aTam     := {}
	Private cPesc    := ''
	Private cPesc2    := ''
	Private _cSerIbl := IIF(CFILANT='01','001','001')
	Private _cFil    := IIF(CFILANT='01','02','01')
	Private bFiltraBrw
	Private AFILBRW    := {}
	Private _cEndeStxx  := 'Endereços(SBF): '
	Private _cPrev  := _oDados:aCols[_oDados:nAt,Ascan(aHeader,{|x| AllTrim(x[2])==(cVend)})]
	Private _cProdAcols  := _oDados:aCols[_oDados:nAt,Ascan(aHeader,{|x| AllTrim(x[2])==(cNomVend)})]
	aTam   := TamSX3("BF_LOCALIZ")
	cPesc  := space(aTam[1])
	
	
	Processa({|| 	STQUERY()},'Selecionando Pedidos')
	Processa({|| 	STQUERY2()},'Selecionando Pedidos')
	Processa({|| 	CompMemory()},'Compondo Faltas')
	
	If len(aVetor2) = 0
		aVetor2:= {{.f.,'','',0,0}}
	EndIf
	If len(aVetor) > 0
		MonTaSlec() // monta a tela
	Else
		MsgInfo("Não Existe Produto Disponivel !!!!!")
	EndIf
	
	
Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
	*-----------------------------*
	Local cQuery     := ''
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	cQuery := ' SELECT C6_NUM ,C6_PRODUTO,C6_XQTPRV,C6_FILIAL,C6_QTDENT,C6_QTDVEN,R_E_C_N_O_  AS "REC" FROM SC6010 SC6
	cQuery += " WHERE SC6.C6_XPREV = '"+_cPrev+"'
	cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_PRODUTO  = '"+_cProdAcols+"'"
	cQuery += " AND SC6.D_E_L_E_T_ = ' '
	
	cQuery += " ORDER BY SC6.C6_QTDVEN
	
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)
	
	
Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY2()
	*-----------------------------*
	Local cQuery     := ''
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	cQuery := ' SELECT C6_NUM ,C6_PRODUTO,C6_XQTPRV,C6_FILIAL,C6_QTDENT,C6_QTDVEN ,R_E_C_N_O_  AS "REC" FROM SC6010 SC6
	cQuery += " WHERE SC6.C6_XPREV = ' '
	cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	cQuery += " AND SC6.C6_PRODUTO  = '"+_cProdAcols+"'"
	cQuery += " AND SC6.D_E_L_E_T_ = ' '
	cQuery += " AND EXISTS (SELECT * FROM PA1010 PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_CODPRO = C6_PRODUTO AND PA1.PA1_DOC = C6_NUM||C6_ITEM)
	
	cQuery += " ORDER BY SC6.C6_QTDVEN
	
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasPed) > 0
		(cAliasPed)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasPed,.T.,.T.)
	
	
Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |    crio o avetor                                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
	*-----------------------------*
	Local _lBloq := .F.
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	ProcRegua(RecCount()) // Numero de registros a processar
	_nQtd:=0
	
	aVetor  :={}
	aVetor2 :={}
	
	While !(cAliasLif)->(Eof())
		
		aadd(aVetor ,{ _lBloq,;
			(cAliasLif)->C6_NUM ,; //01 PRODUTO
		(cAliasLif)->C6_PRODUTO		 ,;	//02   DESCRI
		(cAliasLif)->C6_XQTPRV	,;
			(cAliasLif)->REC})
		
		
		(cAliasLif)->(dbSkip())
	End
	
	dbSelectArea(cAliasPed)
	(cAliasPed)->(dbGoTop())
	ProcRegua(RecCount()) // Numero de registros a processar
	_nQtd:=0
	While !(cAliasPed)->(Eof())
		
		
		
		aadd(aVetor2 ,{ _lBloq,;
			(cAliasPed)->C6_NUM ,; //01 PEDIDO
		(cAliasPed)->C6_PRODUTO		 ,;	//02   PRODUTO
		(cAliasPed)->C6_QTDVEN-(cAliasPed)->C6_QTDENT	,;
			(cAliasPed)->REC	})
		
		
		(cAliasPed)->(dbSkip())
	End
	
	
	
	
Return()

/*====================================================================================\
|Programa  | MonTaSlec        | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MonTaSlec                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function MonTaSlec()
	*-----------------------------*
	
	Local aButtons := {{"LBTIK",{||  oDlg:=U_StFAlRel(oDlg)} ,"Imprimir Rel."} }
	If cfilant = '02'
		//aButtons := {{"LBTIK",{|| Processa({|| 	GeraPed()},'Gerando Pedido.....!!!!!')  } ,"Gerar Pedido"},{"LBTIK",{||  oDlg:=U_StFAlRel(oDlg)} ,"Imprimir Rel."} }
	EndIf
	_nMeta:=_nQtd
	Do While !lSaida
		nOpcao := 0
		
		Define msDialog odlg title "Previsão:"+_cPrev  From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
		
		cLinOk    :="AllwaysTrue()"
		cTudoOk   :="AllwaysTrue()"//'STxGRV()'
		aCpoEnchoice:={'NOUSER'}
		aAltEnchoice := {}
		
		Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
			bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
		Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
		
		@ 020,010 say "Pedidos( De ) :"   Of odlg Pixel
		@ 020,080 msget _oPed Var _nPed picture "@E 999,999,999" when .f. size 55,013  Of odlg Pixel
		@ 035,010 say "Quantidade( De ) :"   Of odlg Pixel
		@ 035,080 msget _oQtd VAR _nQtd picture "@E 999,999,999" when .f. size 55,013  Of odlg Pixel
		@ 050,010 say "Pesquisar:"   Of odlg Pixel
		@ 050,080 msget  oPesc Var cPesc   when .t. size 45,013   valid (fpesc(cPesc))	 Of odlg Pixel
		
		
		//Cria a listbox
		@ 065,000 listbox oLbx fields header '',"Pedido", "Produto",'Qtd.','.'   size  (aSize[3]-05)/2-20,200 of oDlg pixel on dbLclick(edlista())
		
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
			aVetor[oLbx:nAt,2],;
			aVetor[oLbx:nAt,3],;
			aVetor[oLbx:nAt,4],;
			aVetor[oLbx:nAt,5]	}}
		
		//	TButton():New(100,(aSize[3]-05)/2-10,"PMSSETADIR"	,oDlg,{|| MSGINFO('TESTE')},25,15,,,.F.,.T.,.F.,,.F.,,,.F.)
		@ 200,(((aSize[5])/2)-10) BTNBMP oBtn2 RESOURCE "PMSSETADIR" SIZE 45,35 ACTION (STSC6TR(),U_STPREVATU('M')) ENABLE Of odlg Pixel
		
		
		@ 020,510 say "Pedidos( Para ) :"   Of odlg Pixel
		@ 020,580 msget _oPed2 Var _nPed2 picture "@E 999,999,999" when .f. size 55,013  Of odlg Pixel
		@ 035,510 say "Quantidade( Para ) :"   Of odlg Pixel
		@ 035,580 msget _oQtd2 Var _nQtd2 picture "@E 999,999,999" when .f. size 55,013  Of odlg Pixel
		@ 050,510 say "Pesquisar:"   Of odlg Pixel
		@ 050,580 msget  oPesc Var cPesc   when .t. size 45,013   valid (fpesc(cPesc))	 Of odlg Pixel
		
		@ 065,(aSize[3]-05)/2+20 listbox oLbx2 fields header '',"Pedido", "Produto",'Qtd.','.'   size  (aSize[3]-05)/2-20,200 of oDlg pixel on dbLclick(edlista2())
		
		oLbx2:SetArray( aVetor2 )
		oLbx2:bLine := {|| {Iif(	aVetor2[oLbx2:nAt,1],oOk,oNo),;
			aVetor2[oLbx2:nAt,2],;
			aVetor2[oLbx2:nAt,3],;
			aVetor2[oLbx2:nAt,4],;
			aVetor2[oLbx2:nAt,5]	}}
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg   , {|| lSaida:=.t.,oDlg:End()},{||lSaida:=.t.,oDlg:End()},,aButtons)
	End
	
Return()


/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista()
	*-----------------------------*
	Local b
	
	_nQtd:=0
	_nPed:=0
	aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
	
	
	for b:= 1 to Len(aVetor)
		
		If aVetor[b,1]
			_nPed++
			_nQtd+=	aVetor[b,4]
		EndIf
		
	next b
	
	_oPed:Refresh()
	_oQtd:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
Return ()

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista2()
	*-----------------------------*
	Local b
	
	_nQtd2:=0
	_nPed2:=0
	aVetor2[oLbx2:nAt,1]	:= !aVetor2[oLbx2:nAt,1]
	
	for b:= 1 to Len(aVetor2)
		
		If aVetor2[b,1]
			_nPed2++
			_nQtd2+=	aVetor2[b,4]
		EndIf
		
	next b
	If _nQtd2 > _nQtd
		aVetor2[oLbx2:nAt,1]	:= !aVetor2[oLbx2:nAt,1]
		MsgInfo("Quantidade Selecionada Maior Que o Permitido!!!!!")
		_nQtd2:=0
		_nPed2:=0
		for b:= 1 to Len(aVetor2)
			
			If aVetor2[b,1]
				_nPed2++
				_nQtd2+=	aVetor2[b,4]
			EndIf
			
		next b
		
		
	EndIf
	_oPed2:Refresh()
	_oQtd2:Refresh()
	oLbx2:Refresh()
	oDlg:Refresh()
Return ()


Static Function STSC6TR()
	Local b := 0
	For b:= 1 To Len(aVetor)
		
		If aVetor[b,1]
			DbSelectArea("SC6")
			SC6->(DbGoTo(aVetor[b,5] ))
			If aVetor[b,5]   = SC6->(RECNO())
				SC6->(RecLock("SC6",.F.))
				SC6->C6_XPREV := ' '
				SC6->C6_XQTPRV := 0
				SC6->(MsUnlock())
				SC6->( DbCommit() )
			EndIf
		EndIf
		
	Next b
	
	
	For b:= 1 To Len(aVetor2)
		
		If aVetor2[b,1]
			DbSelectArea("SC6")
			SC6->(DbGoTo(aVetor2[b,5] ))
			If aVetor2[b,5]   = SC6->(RECNO())
				SC6->(RecLock("SC6",.F.))
				SC6->C6_XPREV := _cPrev
				SC6->C6_XQTPRV := aVetor2[b,4]
				SC6->(MsUnlock())
				SC6->( DbCommit() )
			EndIf
		EndIf
		
	Next b
	Processa({|| 	STQUERY()},'Selecionando Pedidos')
	Processa({|| 	STQUERY2()},'Selecionando Pedidos')
	Processa({|| 	CompMemory()},'Compondo Faltas')
	
	_oPed2:Refresh()
	_oQtd2:Refresh()
	oLbx2:Refresh()
	oDlg:Refresh()
Return ()
/*====================================================================================\
|Programa  | fpesc            | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fpesc                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fpesc(_cXPesc)
	*-----------------------------*
	local b
	Local _lRex := .f.
	
	If !(Empty(Alltrim(_cXPesc)))
		for b:= 1 to Len(aVetor)
			
			If UPPER(ALLTRIM(aVetor[b,2]))   =  UPPER(ALLTRIM(_cXPesc) )
				_lRex:= .T.
			EndIf
		next b
		
	Else
		_lRex:= .T.
	EndIf
	If _lRex .And. !(Empty(Alltrim(_cXPesc)))
		oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == UPPER(Alltrim(_cXPesc))})
	EndIf
	oLbx:Refresh()
	oDlg:Refresh()
	opesc:Refresh()
Return( _lRex )
