#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "APVT100.CH"
#Include "Totvs.ch"
#include 'parmtype.ch'
#include 'tbiconn.ch'


User Function STFSFA30(lTelaPri,oLbx,_cOs)  // acesso usuario comum sem acesso ao estorno

	Local aArea			:= GetArea()
	Local aAreaCB7		:= CB7->( GetArea() )
	Local lOk			:= .T.
	Local nX			:= 0
	Local nCont			:= 0
	Local _cCodPrx		:= ""
	Private _lCB8       := .F.     // Valdemir Rabelo 07/01/2022 - Adicionado para Controlar apresentaÁ„o Qtde CB8

	//Tiago - chamado: 20230607007153 - data: 22/06/2023
	//Private tiago 		:= .T.
	Private nQtdTotPed	:= 0
	Private nQtdDigit 	:= 0
	Private cQueryB9	:= ""
	Private lContinua   :=.T.

	Default lTelaPri 	:= .F.

Private lSoUmOper := .T.

	// Leonardo Flex 26/02/2013 -> Verifica saldo para embalar
	If IsInCallStack("U_STFSFA13")
		For nX := 1 to Len(oLbx:aArray)
			nCont += Val(oLbx:aArray[nX][9])
		Next
		If nCont <= 0
			lOk := .F.
			MsgAlert("Ordem de separaÁ„o n„o possui saldo de embalagem!!!","AtenÁ„o")
		EndIf
	EndIf

	If lOk
		While lContinua 
		   lContinua:=Embalagem(lTelaPri,_cOs)
		   If !lContinua
   	          Exit
           EndIf  
	       oPedido
	       cPedido		:= Space(6)
	       oOrdSep
	       cOrdSep  	:= Space(6)
	       lTelaPri	:= .F.
	      _cOs := ""
      	  lOk			:= .T.
	      nX			:= 0
	      nCont			:= 0
	      _cCodPrx		:= ""
	      _lCB8       := .F.   
	      nQtdTotPed	:= 0
	      nQtdDigit 	:= 0
	      cQueryB9	:= ""
          lSoUmOper := .T.
        Enddo  
	EndIf

	RestArea(aAreaCB7)
	RestArea(aArea)

Return

User Function STFSFA31()    //acesso usuario administrador com opcao de estorno

	U_STFSFA30(.T.)

Return

User Function STFSFA32(oDlg) //Validar rota TNT

	Local _lRet		:= .T.
	Local _cQuery8  := ""
	Local _cAlias8  := GetNextAlias()
	Local aTEmpFil      := Separa(getMV("ST_TEMPFIL",.F.,"11,01"),",")    // Valdemir Rabelo 07/01/2022 - Aruja CD


	If cEmpAnt == aTEmpFil[1] .And. cFilAnt == aTEmpFil[2] //Ticket 20190902000005
		//20190507000024
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		If SA1->( dbSeek(xFilial("SA1") + CB7->(CB7_CLIENT + CB7_LOJA)) )
			If !U_STFAT340("2","T",oDlg)
				Break
			EndIf
			If Empty(cOrdSep)	// Ticket 20210623010632 - Bloqueio Tela De Embalagem para pedidos com mensagens -- Eduardo Pereira Sigamat -- 20.09.2021 -- Inclus„o das linhas 56 e 60
				If !U_STFAT340("4","T",oDlg)
					Break
				EndIf
			EndIf
		EndIf
		//Verificar se tem rota na TNT
		dbSelectArea("SC5")
		SC5->( dbSetOrder(1) )
		If SC5->( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO) )
			If AllTrim(SC5->C5_XORIG) == "2"
				If !MsgYesNo("AtenÁ„o, pedido de internet, deseja continuar?")
					Break
				EndIf
			EndIf
			If !(AllTrim(SC5->C5_TIPOCLI) == "X") .And. AllTrim(SC5->C5_TRANSP) == "000163"
				dbSelectArea("SA1")
				SA1->( dbSetOrder(1) )
				_aEndEnt := U_STTNT011()
				_cQuery8 := " SELECT *
				_cQuery8 += " FROM " + RetSqlName("SZV") + " ZV
				_cQuery8 += " WHERE ZV.D_E_L_E_T_ = ' ' AND '" + _aEndEnt[1][1] + "' BETWEEN ZV_CEPDE AND ZV_CEPATE
				If !Empty(Select(_cAlias8))
					dbSelectArea(_cAlias8)
					(_cAlias8)->( dbCloseArea() )
				EndIf
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery8),_cAlias8,.T.,.T.)
				dbSelectArea(_cAlias8)
				(_cAlias8)->( dbGoTop() )
				If (_cAlias8)->( Eof() )
					MsgAlert("Rota n„o encontrada, verifique!")
					_lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf

Return _lRet

Static Function Embalagem(lTelaPri,_cOs)

	Local aArea    := GetArea()
	Local oDlg
	Local aButtons	:= {}
	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4
	Local oSplit
	Local oStatus
	Local cStatus	:= Space(20)
	Local oCliente
	Local cCliente 	:= Space(10)
	Local oDesCli
	Local cDesCli	:= Space(40)
	Local cCodOpe	:= CbRetOpe()
	Local aCabVol 	:= {" ","Seq.","Tipo Emb","Larg","Altur","Profun","Regiao","Peso Volume","Qtde Itens","Operador","Abertura","Ult.Ocorrencia", ""} //Adic. Larg Alt Prof Regiao
	Local oLbxVol
	Local aVolumes	:= {}
	Local aCabItem	:= {"Produto","DescriÁ„o","Quantidade","Lote",""}
	Local oLbxItem
	Local aVolItem	:= {}
	Local oTotVol
	Local nTotVol	:=	0
	Local oNomeSep
	Local _cNomeSep := ""
	Local oCubag
	Local _nCubTot	:= 0
	Local oTotPeso
	Local nTotPeso	:=	0
	Local oEmb		:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local cDescImp	:= "Impressora n„o configurada"
	Local oDescImp
	Local aSize    	 := MsAdvSize(.F.)//Giovani Zago - TOTVS 121c/12/12
	Local cMV_XEXCEMB	:= SuperGetMV("MV_XEXCEMB",,"")
	Local cMV_XREPVOL	:= SuperGetMV("MV_XREPVOL",,"")
	Local _cUser  		:= RetCodUsr()
	Local lRet          :=.T.
	Public  cAuxOrd     :=""
	Private oPedido
	Private cPedido		:= Space(6)
	Private oOrdSep
	Private cOrdSep  	:= Space(6)
	Default lTelaPri	:= .F.
	Default _cOs := ""


	If !Empty(_cOs)
		dbSelectArea("CB7")
		CB7->( dbSetOrder(1) )
		If CB7->( !dbSeek(xFilial("CB7") + _cOs) )
			Return
		EndIf
		lTelaPri := .T.
	EndIf

	Private nVolRepl	:= 0

	If lTelaPri .And.  !("01*" $ CB7->CB7_TIPEXP .Or. "02*" $ CB7->CB7_TIPEXP)
		MsgAlert("Ordem de SeparaÁ„o n„o configurada para ter embalagem!!!","AtenÁ„o")
		Return
	EndIf

	If !Empty(CB1->CB1_XLOCIM)
		CB5->( dbSetOrder(1) )
		If CB5->( dbSeek(xFilial("CB5") + CB1->CB1_XLOCIM) )
			cDescImp := CB5->(Alltrim(CB5_MODELO) + ' ' + Alltrim(CB5_DESCRI))
		EndIf
	EndIf

	aAdd(aButtons,{"BMPINCLUIR"  	,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)}		,"Incluir F5","Incluir"		})
	aAdd(aButtons,{"NOTE"			,{|| ManuVol(.F.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)}		,"Alterar F6","Alterar"		})
		
	If !lTelaPri .And. _cUser $ cMV_XEXCEMB 
		//sÛ gera WF dos itens embalados, caso a transf j· tenha sido feita o WF falhou, ou qq motivo que se deseje apenas enviar o WF
		aAdd(aButtons,{"NOTE"			,{|| ManuVol1(.F.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)}		,"Gera WF","Gera WF"		}) 

		aAdd(aButtons,{"DEVOLNF"	,{|| DelVol(oLbxVol,aVolumes,cOrdSep,cPedido)}												,"Exclui F9","Exclui"		})
		aAdd(aButtons,{"DEVOLNF"	,{|| DelVolTot(oLbxVol,aVolumes,cOrdSep,cPedido)}											,"Exclui todos","Exclui todos"		}) //Chamado 000416
	EndIf
	aAdd(aButtons,{"ACDIMG32"		,{|| EtiVol(cOrdSep,aVolumes[oLbxVol:nAt,2],oDescImp)}	 									,"Etiq. Volume F7","Volume"})
	aAdd(aButtons,{"INSTRUME"		,{|| CfgLocImp(oDescImp)}	 							  									,"Configurar Local de Impress„o F8","Loc Imp"})
	aAdd(aButtons,{"ACDIMG32"		,{|| EtiVolLot(cOrdSep,aVolumes[oLbxVol:nAt,2],oDescImp)}									,"Impressao em lote F10","Imp Lote"}) //Chamado 000415 - Renato Nogueira
	If _cUser $ cMV_XREPVOL
		aAdd(aButtons,{"ACDIMG32"	,{|| ReplVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.T.,oLbxItem,aVolItem)}	,"Replicar Volume","Replicar Volume"})
	EndIf
	Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
	//	Setkey(VK_F6,{|| ManuVol(.f.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido)}) - Desabilitado por solicitaÁ„o do Kleber Braga em 27/11/2013
	Setkey(VK_F6,{|| Close(odlg)}) 
	Setkey(VK_F7,{|| EtiVol(cOrdSep,aVolumes[oLbxVol:nAt,2],oDescImp)})
	Setkey(VK_F8,{|| CfgLocImp(oDescImp)})
	Setkey(VK_F9,{|| EtiqDese() })				// Valdemir Rabelo 10/11/2020 - Ticket: 20200922007743

	DEFINE MSDIALOG oDlg TITLE "Embalagem" FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	oDlg:lMaximized := .T.

	@00,00 MSPANEL oPanel1  SIZE 20,20 of oDlg
	oPanel1:Align := CONTROL_ALIGN_TOP

	@ 06,15+030 Say "Ord. SeparaÁ„o" PIXEL of oPanel1
	@ 04,40+050 MsGet oOrdSep Var cOrdSep Picture "!!!!!!" PIXEL of oPanel1 SIZE 40,09 F3 "CB7FS1" Valid VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag,oDlg) WHEN ! lTelaPri

	@ 06,102+050 Say "Pedido" PIXEL of oPanel1
	@ 04,143+050 MsGet oPedido Var cPedido Picture "!!!!!!" PIXEL of oPanel1 SIZE 40,09 F3 "CB7FS2" Valid VldPedido(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag,oDlg) WHEN ! lTelaPri

	@ 06,195+050 Say "Status Sep." PIXEL of oPanel1
	@ 04,222+050 MsGet oStatus Var cStatus Picture "@!" PIXEL of oPanel1 SIZE 60,09 WHEN .F.

	@ 06,322+050 Say "Cliente" PIXEL of oPanel1
	@ 04,365+050 MsGet oCliente Var cCliente Picture "@!" PIXEL of oPanel1 SIZE 40,09 WHEN .F.
	@ 04,424+050 MsGet oDesCli Var cDesCli Picture "@!" PIXEL of oPanel1 SIZE 180,09 WHEN .F.

	@00,00 MSPANEL oPanel2 PROMPT "" SIZE 100,100 of oDlg
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT

	oLbxVol := TWBrowse():New(10,10,1200,1200,,aCabVol,,oPanel2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	@00,00 MSPANEL oPanel4 PROMPT "" SIZE 20,20 of oDlg
	oPanel4:Align := CONTROL_ALIGN_BOTTOM

	@ 06,002+20 Say "Cubag.:" PIXEL of oPanel4 //Renato Nogueira - Chamado 000214 - 18/02/2014
	@ 04,025+20 MsGet oCubag Var _nCubTot Picture "@!" PIXEL of oPanel4 SIZE 35,09 When .f.

	@ 06,002+100 Say "Separador:" PIXEL of oPanel4
	@ 04,030+100 MsGet oNomeSep Var _cNomeSep Picture "@!" PIXEL of oPanel4 SIZE 90,09 When .f.

	@ 06,002+250 Say "Peso Total:" PIXEL of oPanel4
	@ 04,030+250 MsGet oTotPeso Var nTotPeso Picture "9999999.99" PIXEL of oPanel4 SIZE 38,09 When .f.

	@ 06,68+250 Say "Total de Volumes:" PIXEL of oPanel4
	@ 04,110+250 MsGet oTotVol Var nTotVol Picture "9999" PIXEL of oPanel4 SIZE 30,09 When .f.

	@ 06,150+250 Say "Local de Impress„o:" PIXEL of oPanel4
	@ 04,200+250 MsGet oDescImp Var cDescImp Picture "@!" PIXEL of oPanel4 SIZE 100,09 When .f.
  

   

	If lTelaPri
		MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		cOrdSep := CB7->CB7_ORDSEP
		If !VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag,oDlg)
			Return
		EndIf
	Else
		aVolumes:={{oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)}} //Adic. Larg Alt Prof
		oLbxVol:SetArray( aVolumes )
		oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
		oLbxVol:Refresh()
	EndIf

	oLbxVol:bChange := {|| oLbxVol :Refresh(),MontaItem(aVolItem,cOrdSep+aVolumes[oLbxVol:nAt,2],oLbxItem)  }
	oLbxVol:Align := CONTROL_ALIGN_ALLCLIENT

	@00,00 MSPANEL oPanel3 PROMPT "" SIZE 100,100 of oDlg
	oPanel3:Align := CONTROL_ALIGN_BOTTOM
	oLbxItem := TWBrowse():New(10,10,1200,1200,,aCabItem,,oPanel3,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	MontaItem(aVolItem,cOrdSep+aVolumes[1,2],oLbxItem)
	oLbxItem:Align := CONTROL_ALIGN_ALLCLIENT
	oPanel3:lVisibleControl:=.F.

	@ 000,000 BUTTON oSplit PROMPT "*" SIZE 5,5 OF oDlg PIXEL
	oSplit:cToolTip := "Habilita e desabilita os itens."
	oSplit:bLClicked := {|| oPanel3:lVisibleControl 	:= !oPanel3:lVisibleControl}
	oSplit:Align := CONTROL_ALIGN_BOTTOM

	oLbxVol:Refresh()
	ACTIVATE MSDIALOG oDlg on INIT (EnchoiceBar(oDlg, {||oDlg:End()  },{|| oDlg:End()},,aButtons ) ,eval(oSplit:bLClicked))

	If Val(CB7->CB7_STATUS) < 4
		MsgAlert("AtenÁ„o, a embalagem da OS " + AllTrim(CB7->CB7_ORDSEP) + " n„o foi finalizada!")
	EndIf

	Setkey(VK_F4,Nil)
	Setkey(VK_F5,Nil)
	Setkey(VK_F6,Nil)
	Setkey(VK_F7,Nil)
	Setkey(VK_F8,Nil)
	SetKey(VK_F9,Nil)    // Valdemir Rabelo 10/11/2020 - Ticket: 20200922007743

	RestArea(aArea)

	IF Empty(cOrdSep)
	   lRet:=.F.
	ENDIF   

Return(lRet)

Static Function VldPedido(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag,oDlg)

	Local nC		:= 0
	Local lRet		:= .F.
	Local oEmb 		:= LoadBitmap( GetResources(), "BR_PRETO" )
	Local cPedido	:= oPedido:cText

	If Empty(cPedido)
		Return .T.
	EndIf

/*
	If Val(CB7->CB7_STATUS) < 4
		MsgAlert("AtenÁ„o, a embalagem da OS " + AllTrim(CB7->CB7_ORDSEP) + " n„o foi finalizada!")
	EndIf
*/

	Begin Sequence
		If !Empty(oOrdSep:cText) .And. !Empty(oPedido:cText)
			CB7->( dbSetorder(1) )
			If CB7->( dbSeek(xFilial("CB7") + oOrdSep:cText) )
				If !(AllTrim(CB7->CB7_PEDIDO) == AllTrim(oPedido:cText))
					MsgAlert('Ordem de SeparaÁ„o com o Pedido ' + oPedido:cText + ' n„o encontrado','AtenÁ„o')
					oPedido:cText  := Space(6)
					oOrdSep:cText  := Space(6)
					cPedido	 := Space(6)
					cOrdSep	 := Space(6)
					Break
				EndIf
			Else
				MsgAlert('Ordem de SeparaÁ„o n„o encontrada','AtenÁ„o')
				oPedido:cText  := Space(6)
				oOrdSep:cText  := Space(6)
				cPedido	 := Space(6)
				cOrdSep	 := Space(6)
				Break
			EndIf
		EndIf
		If Empty(oOrdSep:cText)
			CB7->( dbSetorder(2) )  //CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG
			If CB7->( !dbSeek(xFilial('CB7') + cPedido) )
				MsgAlert('Ordem de SeparaÁ„o com o Pedido ' + cPedido + ' n„o encontrado','AtenÁ„o')
				Break
			Endif
			While CB7->( !Eof() .And. CB7_FILIAL + CB7_PEDIDO == xFilial('CB7') + cPedido )
				nC++
				CB7->( dbSkip() )
			End
			CB7->( dbSeek(xFilial('CB7') + cPedido) )
			If nC > 1
				ConPad1(,,,"CB7FS2",,,.F.,,, cPedido)
				If CB7->CB7_PEDIDO <> cPedido
					MsgAlert('Ordem de SeparaÁ„o n„o pertence ao Pedido ' + cPedido,'AtenÁ„o')
					Break
				EndIf
			EndIf
		EndIf

		If !Empty(CB7->CB7_XOPE2 + CB7->CB7_XOPE3 + CB7->CB7_XOPE4 + CB7->CB7_XOPE5)
//			FWAlertInfo("Mais de um Separador - Regra Desabilitada")
			lSoUmOper := .F.
//		Else
//			FWAlertInfo("Somente um Separador - Regra Habilitada")
		EndIf

		If !("01*" $ CB7->CB7_TIPEXP .Or. "02*" $ CB7->CB7_TIPEXP)
			MsgAlert("Ordem de SeparaÁ„o n„o configurada para ter embalagem!!!","AtenÁ„o")
			Break
		EndIf
		oStatus:cText	:= RetStatus(CB7->CB7_STATUS)

//ticket 20220708013590 - lSoUmOper
		//>> Chamado 008043
		If lSoUmOper .And. oStatus:cText $ "Nao iniciado#Em separacao" .And. !(Empty(Alltrim(oStatus:cText)))
			MsgAlert("Ordem de SeparaÁ„o N„o Iniciada ou Em SeparaÁ„o!!!","AtenÁ„o")
			Break
		EndIf
		//<<

		If !U_STFSFA32(oDlg)
			Break
		EndIf
		oOrdSep:cText  	:= CB7->CB7_ORDSEP
		oCliente:cText 	:= CB7->(CB7_CLIENT + ' - ' + CB7_LOJA)
		oDesCli:cText  	:= Posicione("SA1",1,xFilial("SA1") + CB7->(CB7_CLIENT + CB7_LOJA),"A1_NOME")
		MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		Eval(oLbxVol:bChange)
		lRet := .T.
		Recover
		oStatus:cText	:= ''
		oPedido:cText  	:= Space(6)
		oOrdSep:cText  	:= Space(6)
		oCliente:cText 	:= ''
		oDesCli:cText  	:= ''
		aVolumes := { {oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)} } //Adic. Larg Alt Prof
		oLbxVol:SetArray( aVolumes )
		oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
		oLbxVol:Refresh()
		Eval(oLbxVol:bChange)
		lRet := .F.
	End Sequence
	CB7->( dbSetorder(1) )

	If lRet
		oLbxVol:SetFocus()
	EndIf

Return lRet

Static Function VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag,oDlg)

	Local cOrdSep 	:= oOrdSep:cText
	Local oEmb 		:= LoadBitmap( GetResources(), "BR_PRETO"	)
	Local lRet		:= .T.

    If Empty(cOrdSep)
		Return .t.
	EndIf

    //20230803009773 Incluido Devido a encavalemento de pedido onde o usu·rio n„o efetuava a confirmaÁ„o e n„o utilizava a funÁ„o F6   
    If !EMPTY(cOrdSep) .AND. !EMPTY(cAuxOrd)
	    If cAuxOrd <> cOrdSep
           MsgAlert("Ao inserir uma nova Ordem de separaÁ„o, È necess·rio confirmar ou pressionar F6, para evitar possÌveis junÁıes indevidas!", "AtenÁ„o")
		   Close(odlg)
           cAuxOrd :=""
		   lRet := .F.
		   Return lRet 
        ENDIF
	ENDIF

	cAuxOrd := cOrdSep

	Begin Sequence
		If !Empty(oOrdSep:cText) .And. !Empty(oPedido:cText)
			CB7->( dbSetorder(1) )
			If CB7->( dbSeek(xFilial("CB7") + oOrdSep:cText) )
				If !(AllTrim(CB7->CB7_PEDIDO) == AllTrim(oPedido:cText))
					MsgAlert('Ordem de SeparaÁ„o com o Pedido ' + oPedido:cText + ' n„o encontrado','AtenÁ„o')
					oPedido:cText  := Space(6)
					oOrdSep:cText  := Space(6)
					Break
				EndIf
			Else
				MsgAlert('Ordem de SeparaÁ„o n„o encontrada','AtenÁ„o')
				oPedido:cText  := Space(6)
				oOrdSep:cText  := Space(6)
				Break
			EndIf
		EndIf
		CB7->( dbSetorder(1) )
		If CB7->( !dbSeek(xFilial('CB7') + cOrdSep) )
			MsgAlert('Ordem de SeparaÁ„o n„o encontrada','AtenÁ„o')
			Break
		EndIf

		If !Empty(CB7->CB7_XOPE2 + CB7->CB7_XOPE3 + CB7->CB7_XOPE4 + CB7->CB7_XOPE5)
//			FWAlertInfo("Mais de um Separador - Regra Desabilitada")
			lSoUmOper := .F.
//		Else
//			FWAlertInfo("Somente um Separador - Regra Habilitada")
		EndIf

		//Tiago Dias - 05/07/2023 - chamado: 20230705008330 (desabilitar condiÁ„o)
		/*If !Empty(CB7->CB7_XOPE2 + CB7->CB7_XOPE3 + CB7->CB7_XOPE4 + CB7->CB7_XOPE5)
			FWAlertInfo("Mais de um Separador - Regra Desabilitada")
			lSoUmOper := .F.
		Else
			FWAlertInfo("Somente um Separador - Regra Habilitada")
		EndIf*/

		If !("01*" $ CB7->CB7_TIPEXP .Or. "02*" $ CB7->CB7_TIPEXP)
			MsgAlert("Ordem de SeparaÁ„o n„o configurada para ter embalagem!!!","AtenÁ„o")
			Break
		EndIf
		If !U_STFSFA32(oDlg)
			Break
		EndIf
		oStatus:cText 	:= RetStatus(CB7->CB7_STATUS)
		oPedido:cText  	:= CB7->CB7_PEDIDO
		oCliente:cText 	:= CB7->(CB7_CLIENT + ' - ' + CB7_LOJA)
		oDesCli:cText  	:= Posicione("SA1",1,xFilial("SA1") + CB7->(CB7_CLIENT + CB7_LOJA),"A1_NOME")
		MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		Eval(oLbxVol:bChange)
		lRet := .T.
		Recover
		oStatus:cText 	:= ''
		oPedido:cText  	:= Space(6)
		oOrdSep:cText  	:= Space(6)
		oCliente:cText 	:= ''
		oDesCli:cText  	:= ''
		aVolumes := { {oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)} } //Adic. Larg Alt Prof
		oLbxVol:SetArray( aVolumes )
		oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
		oLbxVol:Refresh()
		Eval(oLbxVol:bChange)
		lRet := .F.
	End Sequence

Return lRet

/*
Status
"0" - "Nao iniciado"
"1" - "Em separacao"
"2" - "Separacao finalizada"
"3" - "Em processo de embalagem"
"4" - "Embalagem Finalizada"
"5" -	"Nota gerada"
"6" -	"Nota impressa"
"7" -	"Volume impresso"
"8" -	"Em processo de embarque"
"9" -	"Finalizado"
*/

Static Function RetStatus(cStatus)

	Local aStatus := {	"Nao iniciado","Em separacao","Separacao finalizada",	"Em processo de embalagem",;
		"Embalagem Finalizada","Nota gerada","Nota impressa",	"Volume impresso",;
		"Em processo de embarque",	"Finalizado"}
	Local _cRet	:= ' '

	_cRet		:= aStatus[Val(cStatus)+1]

	If _cRet $ "Nao iniciado#Em separacao"	.And. CB7->CB7_XOPE2 <> ' ' .And. cFilAnt == '02' //Giovani zago 24/05/19 ajuste para comeÁar a embalagem quando tiver 2 separadores. ticket 20190517000020
		_cRet := ' '
	EndIf

Return _cRet

Static Function MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)

	Local cOrdSep 	:= CB7->CB7_ORDSEP
	Local aArea		:= GetArea()
	Local aAreaCB9 	:= CB9->( GetArea() )
	Local aAreaCB6 	:= CB9->( GetArea() )
	Local _aArea
	Local _aAreaCB1
	Local _cNomeSep	:= ""
	Local nTotPeso 	:= 0
	Local aVolAux	:= {}
	Local nQtdEmb	:= 0
	Local oEmb		:= LoadBitmap( GetResources(), "BR_PRETO"	)
	Local oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO"	)
	Local oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO"	)
	Local _nCubTot	:= 0
	Local cRegiao	:= ' '

	aVolumes := {}

	_aAreaCB1 := CB1->( GetArea() )

	CB9->( dbSetorder(4) )
	CB6->( dbOrderNickName("STFSCB601") )    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
	If CB6->( dbSeek(xFilial('CB6') + cOrdSep) )
		While CB6->( !Eof() .And. CB6_FILIAL + CB6_XORDSE == xFilial('CB6') + cOrdSep)
			nQtdEmb	:= 0
			nQtdEmb := STEMB30(CB6->CB6_VOLUME)
			If ! Empty(CB6->CB6_XPESO)
				oEmb := oVermelho
			Else
				oEmb := oAmarelo
			EndIf
			If Empty(Alltrim(cRegiao))
				cRegiao := u_regceped(CB6->CB6_PEDIDO)
			EndIf
			aVolAux := {oEmb,;
				Right(CB6->CB6_VOLUME,4),;
				CB6->CB6_TIPVOL + ' ' + Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_DESCRI"),;
				Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_ALTURA"),; //Adic. Larg Alt Prof
			Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_LARGUR"),; //Adic. Larg Alt Prof
			Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_PROFUN"),; //Adic. Larg Alt Prof
			cRegiao,; //Adic. Regiao
			Transform(CB6->CB6_XPESO,"999999.99"),;
				nQtdEmb,;
				CB6->CB6_XOPERA + ' ' + Posicione("CB1",1,xFilial("CB1") + CB6->CB6_XOPERA,"CB1_NOME"),;
				CB6->(DtoC(CB6_XDTINI) + ' ' + CB6_XHINI),;
				CB6->(DtoC(CB6_XDTFIN) + ' ' + CB6_XHFIN),;
				" "}
			nTotPeso +=	CB6->CB6_XPESO
			aadd(aVolumes,aClone(aVolAux))
			_nCubTot += Posicione("CB3",1,xFilial("CB3") + CB6->CB6_TIPVOL,"CB3_VOLUME") //Renato Nogueira - Chamado 000214
			CB6->( dbSkip() )
		EndDo
	EndIf
	RestArea(_aAreaCB1)
	_aArea		:= GetArea()
	_aAreaCB1   := CB1->( GetArea() )

	dbSelectArea("CB1")
	CB1->( dbGotop() )
	CB1->( dbSetOrder(1) )
	CB1->( dbSeek(xFilial("CB1") + CB7->CB7_XOPEXP) )

	_cNomeSep := CB1->CB1_NOME

	RestArea(_aAreaCB1)
	RestArea(_aArea)

	If Empty(aVolumes)
		aVolumes := { {oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)} } //Adic. Larg Alt Prof
	Else
		ASort(aVolumes,,,{|x,y| (x[2]) > (y[2])})
		oTotPeso:cText := nTotPeso
		oTotPeso:Refresh()
		oTotVol:cText 	:= Len(aVolumes)
		oTotVol:Refresh()
		oNomeSep:cText := _cNomeSep
		oNomeSep:Refresh()
		oCubag:cText := _nCubTot
		oCubag:Refresh()
	EndIf

	oLbxVol:SetArray( aVolumes )
	oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
	oLbxVol:Refresh()

	RestArea(aAreaCB9)
	RestArea(aAreaCB6)
	RestArea(aArea)

Return

Static Function MontaItem(aVolItem,cVolume,oLbxItem)

	Local cPicture := "999999" //PesqPict("CB9","CB9_QTEEMB")
	Local cDesProd := ''

	aVolItem := {}

	CB9->( dbSetOrder(4) )
	If !Empty(cVolume) .And. CB9->( dbSeek(xFilial("CB9") + cVolume) )
		While CB9->( !Eof() .And. CB9_FILIAL + CB9_VOLUME == xFilial("CB9") + cVolume)
			cDesProd := Posicione("SB1",1,xFilial("SB1") + CB9->CB9_PROD,"B1_DESC")
			aAdd(aVolItem,{CB9->CB9_PROD,cDesProd,Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,''})
			CB9->( dbSkip() )
		EndDo
	End
	If Empty(aVolItem)
		aVolItem := { {Space(15),Space(40),Space(20),Space(20),Space(40)} }
	EndIf
	If oLbxItem # Nil
		oLbxItem:SetArray( aVolItem )
		oLbxItem:bLine := {|| aEval(aVolItem[oLbxItem:nAt],{|z,w| aVolItem[oLbxItem:nAt,w] } ) }
		oLbxItem:Refresh()
	EndIf

Return

Static Function DelVol(oLbxVol,aVolumes,cOrdSep,cPedido)

	Local cPicture	:= "999999"
	Local cDesProd	:= ''
	Local aItVlSel	:= {}
	Local aRecCB9	:= {}
	Local cVolume	:= ''
	Local aCabItVol := {"Produto","DescriÁ„o","Quantidade","Lote"}
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery1  += " WHERE SC9.D_E_L_E_T_ = ' ' AND C9_FILIAL = '" + xFilial("SC9") + "' "
	cQuery1  += " 	AND C9_PEDIDO = '" + cPedido + "' "
	cQuery1  += " 	AND C9_ORDSEP = '" + cOrdSep + "' "
	cQuery1  += " 	AND C9_NFISCAL <> ' ' "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )

	If (cAlias1)->CONTADOR >= 1
		MsgAlert("Essa ordem de separaÁ„o possui NF amarrada e o volume n„o poder· ser excluÌdo","AtenÁ„o") //Renato Nogueira - Chamado 000094
		Return
	EndIf

	If Empty(aVolumes[1,2])
		Return
	EndIf

	cVolume := cOrdSep+aVolumes[oLbxVol:nAt,2]

	CB9->( dbSetOrder(4) )
	If !Empty(cVolume) .And. CB9->( dbSeek(xFilial("CB9") + cVolume) )
		While CB9->( !Eof() .And. CB9_FILIAL + CB9_VOLUME == xFilial("CB9") + cVolume)
			cDesProd := Posicione("SB1",1,XFILIAL("SB1")+CB9->CB9_PROD,"B1_DESC")
			_numPed		:= CB9->CB9_PEDIDO
			_numOS		:= CB9->CB9_ORDSEP
			_numItem	:= CB9->CB9_ITESEP
			If !_TemNota(_numPed,_numItem,_numOS)				//[RENATO NOGUEIRA - 200513] ADICIONADO VALIDA«√O PARA VERIFICAR SE TEM NOTA GERADA
				aAdd(aItVlSel,{.F.,CB9->CB9_PROD,cDesProd,Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,CB9->CB9_ITESEP})//Giovani Zago 06/06/2013
			EndIf
			aAdd(aRecCB9,CB9->( Recno()) )
			CB9->( dbSkip() )
		EndDo
	End
	If Empty(aItVlSel)
		CB6->( dbSetOrder(1) )
		If CB6->( dbSeek(xFilial("CB6") + cVolume) )
			CB6->( RecLock("CB6",.F.) )
			CB6->( dbDelete() )
			CB6->( MsUnlock() )
		EndIf
		MsgInfo("N„o foram encontrados itens no volume. Volume excluÌdo.","AtenÁ„o")
		Return
	EndIf

	SelVol(aCabItVol,aItVlSel,"Deleta Itens do Volume - " + cVolume)

	MsgRun( "Excluindo Itens do volume, aguarde...",, {|| DelVolGrv(aItVlSel,aRecCB9,cVolume,cPedido,cOrdSep)} )

Return

Static Function DelVolTot(oLbxVol,aVolumes,cOrdSep,cPedido)

	Local aArea			:= GetArea()
	Local cPicture		:= "999999"
	Local cDesProd		:= ''
	Local aItVlSel		:= {}
	Local aRecCB9		:= {}
	Local cVolume  		:= ''
	Local aCabItVol 	:= {"Produto","DescriÁ„o","Quantidade","Lote"}
	Local cQuery1 		:= ""
	Local cAlias1 		:= "QRYTEMP"
	Local nX	   		:= 0
	Local _lRetorno 	:= .F. //Validacao da dialog criada oDlg
	Local _nOpca 		:= 0 //Opcao da confirmacao
	Local bOk 			:= {|| _nOpca := 1, _lRetorno := .T., __oDlg:End() } //botao de ok
	Local bCancel 		:= {|| _nOpca := 0, __oDlg:End() } //botao de cancelamento
	Local _cArqEmp 		:= "" //Arquivo temporario com as empresas a serem escolhidas
	Local _aStruTrb 	:= {} //estrutura do temporario
	Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
	Local _aEmpMigr 	:= {} //array de retorno com as empresas escolhidas
	Private cMarcou		:= GetMark()
	Private __lInverte 	:= .F. //Variaveis para o MsSelect
	Private __oBrwTrb //objeto do msselect
	Private __oDlg

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery1  += " WHERE SC9.D_E_L_E_T_ = ' ' "
	cQuery1  += " 	AND C9_FILIAL = '" + xFilial("SC9") + "' "
	cQuery1  += " 	AND C9_PEDIDO = '" + cPedido + "' "
	cQuery1  += " 	AND C9_ORDSEP = '" + cOrdSep + "' "
	cQuery1  += " 	AND C9_NFISCAL <> ' ' "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR >= 1
		MsgAlert("Essa ordem de separaÁ„o possui NF amarrada e o volume n„o poder· ser excluÌdo","AtenÁ„o") //Renato Nogueira - Chamado 000094
		Return
	EndIf

	If Empty(aVolumes[1,2])
		Return
	EndIf

	//Define campos do TRB
	aAdd(_aStruTrb,{"PEDIDO" 	,"C",06,0})
	aAdd(_aStruTrb,{"OS" 		,"C",06,0})
	aAdd(_aStruTrb,{"VOLUME" 	,"C",10 ,0})
	aAdd(_aStruTrb,{"OK" 		,"C",02,0})

	//Define campos do msselect
	aAdd(_aBrowse,{"OK"		,,"" })
	aAdd(_aBrowse,{"PEDIDO" ,,"Pedido" })
	aAdd(_aBrowse,{"OS" 	,,"Ordem de separaÁ„o" })
	aAdd(_aBrowse,{"VOLUME" ,,"Volume" })
	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	Endif
	_cArqEmp := CriaTrab(_aStruTrb)
	dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

	cQuery := " SELECT CB6_PEDIDO, CB6_XORDSE, CB6_VOLUME "
	cQuery += " FROM " + RetSqlName("CB6") + " CB6 "
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CB6_XORDSE = '" + cOrdSep + "' "
	cQuery += " 	AND CB6_FILIAL = '" + xFilial("CB6") + "' "
	cQuery += " ORDER BY CB6_VOLUME "
	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

	While (cAlias)->( !Eof() )
		RecLock("TRB",.T.)
		TRB->OK 		:= Space(2)
		TRB->PEDIDO 	:= (cAlias)->CB6_PEDIDO
		TRB->OS		 	:= (cAlias)->CB6_XORDSE
		TRB->VOLUME		:= (cAlias)->CB6_VOLUME
		MsUnlock()
		(cAlias)->( dbSkip() )
	Enddo

	@ 001,001 TO 400,700 Dialog __oDlg TITLE OemToAnsi("Volumes")
	@ 030,005 SAY OemToAnsi("Defina os volumes que deseja marcar: ")
	__oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@__lInverte,@cMarcou,{040,001,195,350})
	__oBrwTrb:oBrowse:lCanAllmark := .F.
	__oBrwTrb:oBrowse:bAllMark := {||MarkAll(cMarcou,@__oBrwTrb,cAlias,__oDlg)}
	Eval(__oBrwTrb:oBrowse:bGoTop)
	__oBrwTrb:oBrowse:Refresh()
	Activate MsDialog __oDlg On Init (EnchoiceBar(__oDlg,bOk,bCancel,,)) Centered VALID _lRetorno

	(cAlias)->( dbCloseArea() )
	TRB->( dbGotop() )
	If _nOpca == 1
		Do While TRB->( !Eof() )
			If !Empty(TRB->OK)//se usuario marcou o registro
				aItVlSel	:= {}
				aRecCB9		:= {}
				CB9->( dbSetOrder(4) )
				If !Empty(TRB->VOLUME) .And. CB9->( dbSeek(xFilial("CB9") + TRB->VOLUME) )
					While CB9->( !Eof() .And. CB9_FILIAL + CB9_VOLUME == xFilial("CB9") + TRB->VOLUME)
						cDesProd := Posicione("SB1",1,XFILIAL("SB1")+CB9->CB9_PROD,"B1_DESC")
						_numPed	:= CB9->CB9_PEDIDO
						_numOS	:= CB9->CB9_ORDSEP
						_numItem:= CB9->CB9_ITESEP
						If !_TemNota(_numPed,_numItem,_numOS)				//[RENATO NOGUEIRA - 200513] ADICIONADO VALIDA«√O PARA VERIFICAR SE TEM NOTA GERADA
							aAdd(aItVlSel,{.T.,CB9->CB9_PROD,cDesProd,Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,CB9->CB9_ITESEP})//Giovani Zago 06/06/2013
						EndIf
						aAdd(aRecCB9,CB9->( Recno()) )
						CB9->( dbSkip() )
					EndDo
				End
				If Empty(aItVlSel)
					CB6->( dbSetOrder(1) )
					If CB6->( dbSeek(xFilial("CB6") + cVolume) )
						CB6->( RecLock("CB6",.F.) )
						CB6->( dbDelete() )
						CB6->( MsUnlock() )
					EndIf
					MsgInfo("N„o foram encontrados itens no volume. Volume excluÌdo.","AtenÁ„o")
					Return
				EndIf
				MsgRun( "Excluindo Itens do volume, aguarde...",, {|| DelVolGrv(aItVlSel,aRecCB9,TRB->VOLUME,cPedido,cOrdSep)} )
			EndIf
			TRB->( dbSkip() )
		EndDo
	EndIf

	//fecha area de trabalho e arquivo tempor·rio criados
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
		Ferase(_cArqEmp + OrdBagExt())
	EndIf

	RestArea(aArea)

Return

Static Function MarkAll(cMarcou,__oBrwTrb,cAlias,__oDlg)

	dbSelectArea("TRB")
	("TRB")->( dbGoTop() )
	While ("TRB")->( !Eof() )
		("TRB")->( RecLock("TRB",.F.) )
		If ("TRB")->OK == cMarcou
			("TRB")->OK := ""
		Else
			("TRB")->OK := cMarcou
		EndIf
		("TRB")->( dbSkip() )
	EndDo

	__oBrwTrb:oBrowse:Refresh(.T.)

Return Nil

Static Function DelVolGrv(aDocs,aRecCB9,cVolume,cPedido,cOrdSep)

	Local nX 		:= 0
	Local nSaldoEmb	:= 0
	Local lDelCB9	:= .F.
	Local lAchouCB9	:= .F.

	If STDUPLIORD(cOrdSep) //verifica se ordem de separaÁ„o possui produtos duplicado Giovani Zago 06/06/2013 item 104 mit006
		STORDDUPLGrv(aDocs,aRecCB9,cVolume,cPedido,cOrdSep)
	Else
		For nX:= 1 to Len(aDocs)
			If !aDocs[nX,1]
				Loop
			EndIf
			lDelCB9		:= .T.
			lAchouCB9	:= .F.
			CB9->( dbSetorder(8) )
			CB9->( dbGoTo(aRecCB9[nX]) )
			CB8->( dbSetOrder(4) )
			CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
			nSaldoEmb := CB9->CB9_QTEEMB
			If CB9->( dbSeek(CB9->CB9_FILIAL + CB9->CB9_ORDSEP + CB9->CB9_PROD + Space(10) + Space(6) + Space(20) + Space(10)) )
				CB9->( RecLock("CB9",.F.) )
				CB9->CB9_QTESEP += nSaldoEmb
				CB9->( MsUnlock() )
				lAchouCB9 := .T.
			EndIf
			CB9->( dbGoTo(aRecCB9[nX]) )
			CB9->( RecLock("CB9",.F.) )
			If lAchouCB9
				CB9->( dbDelete() )
			Else
				CB9->CB9_VOLUME := ""
				CB9->CB9_QTEEMB := 0
				CB9->CB9_CODEMB := ""
				CB9->CB9_LOTECT := ""
				CB9->CB9_STATUS := "1"  // Em Aberto
			EndIf
			CB9->( MsUnlock() )
			CB8->( RecLock("CB8",.F.) )
			CB8->CB8_SALDOE += nSaldoEmb
			CB8->( MsUnlock() )
		Next
		If lDelCB9
			CB6->( dbSetorder(1) )
			CB9->( dbSetorder(4) )
			If CB9->( !dbSeek(xFilial("CB9") + cVolume) )
				If CB6->( dbSeek(xFilial("CB6") + cVolume) )
					CB6->( RecLock("CB6",.F.) )
					CB6->( dbDelete() )
					CB6->( MsUnlock() )
				EndIf
			EndIf
			CB7->( dbSetorder(1) )
			If CB7->( dbSeek(xFilial("CB7") + cOrdSep) )
				CB6->( dbOrderNickName("STFSCB601") )    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
				CB7->( Reclock('CB7',.F.) )
				If CB6->( !dbSeek(xFilial('CB6') + cOrdSep) )
					CB7->CB7_STATUS := "2"  // Sep.Final
				Else
					CB7->CB7_STATUS := "3"  // Embalando
				EndIf
				CB7->( MsUnLock() )
			EndIf
			If !IsInCallStack("DelVolTot")
				MsgInfo("Itens excluÌdos com sucesso.","OK")
			EndIf
		EndIf
	EndIf

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥SelVol	∫Autor  ≥Microsiga           ∫ Data ≥  13/04/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Tela de selecao de itens do volume                          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥SIGAFAT                                                     ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function SelVol(aCabDoc,aDocs,cTitulo)

	Local oPanel
	Local oPanel1
	Local oChk
	Local lChk 		:= .F.
	Local oDlg
	Local oLbx
	Local aCab		:= {}
	Local nX,i
	Local aButtons	:= {}
	Local lOk		:= .F.
	Local oChkQtd
	Local lChkQtd	:= .F.
	Local lStOper   := .T.//Giovani TOTVS     11/12/12
	Private aSize       := MsAdvSize()

	aAdd(aCab," ")

	For nX := 1 to len(aCabDoc)
		aAdd(aCab,Alltrim(aCabDoc[nX]))
	Next

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd
	oPanel :=TPanel():New( 010, 010, ,oDlg, , , , , , 14, 14, .F.,.T. )
	oPanel :align := CONTROL_ALIGN_TOP
	oPanel1 :=TPanel():New( 010, 010, ,oDlg, , , , , , 70, 70, .F.,.T. )
	oPanel1 :align := CONTROL_ALIGN_ALLCLIENT
	oLbx:= TwBrowse():New(01,01,490,490,,aCab,, oPanel1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oLbx:bLDblClick 	:= { || aDocs[oLbx:nAt,1]:= ! aDocs[oLbx:nAt,1]}
	oLbx:align 			:= CONTROL_ALIGN_ALLCLIENT
	oLbx:SetArray( aDocs )
	oLbx:bLine 			:= {|| Retbline(oLbx,aDocs) }
	oLbx:Refresh()
	@ 1,1 BUTTON "Marcar Todos"	SIZE 45 ,10   FONT oDlg:oFont ACTION (MarcaTodos(oLbx, .F., .T.))  OF oDlg PIXEL   //'Marcar Todos'
	ACTIVATE MSDIALOG oDlg on init EnchoiceBar( oDlg, {||  lOk:= .t., oDlg:End()} , {|| oDlg:End() },,aButtons ) CENTERED

	If !lOk
		aDocs := {}
	EndIf

Return

Static Function MarcaTodos(oLbx, lInverte, lMarca)

	Local nX
	Default lMarca := .T.

	For nX := 1 TO Len(oLbx:aArray)
		InverteSel(oLbx,nX, lInverte, lMarca)
	Next

Return

Static Function InverteSel(oLbx, nLin, lInverte, lMarca)

	Default nLin := oLbx:nAt

	If lInverte
		oLbx:aArray[nLin,1] := !oLbx:aArray[nLin,1]
	Else
		If lMarca
			oLbx:aArray[nLin,1] := .T.
		Else
			oLbx:aArray[nLin,1] := .F.
		EndIf
	EndIf

Return

Static Function RetbLine(oLbx,aDocs)

	Local nx
	Local oOk	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	:= LoadBitmap( GetResources(), "LBNO" )
	Local aRet	:= {}

	For nX := 1 to len(aDocs[oLbx:nAt])
		If nX == 1
			If aDocs[oLbx:nAt,1]
				aAdd(aRet,oOk)
			Else
				aAdd(aRet,oNo)
			EndIf
		Else
			aAdd(aRet,aDocs[oLbx:nAt,nX])
		EndIf
	Next

Return aclone(aRet)

Static Function ManuVol(lInclui,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,lReplVol,oLbxItem,aVolItem)

	Local oPanel
	Local oPanel3
	Local oEtiqueta
	Local cEtiqueta		:= Space(48)
	Local cCodEmbOld	:= Space(3)
	Local cCodEmb		:= Space(3)
	Local oCodEmb
	Local cDescEmb		:= Space(20)
	Local oDescEmb
	Local oChk
	Local lChk 			:= .F.
	Local oDlg
	Local oLbx
	Local aLbx			:= {}
	Local lOk			:= .F.
	Local nPeso			:= 0
	Local lSaldoEmb		:= .F.
	Local nItem			:= 0
	Local cMV_XEXCEMB	:= SuperGetMV("MV_XEXCEMB",,"")
	Local cMV_XREPVOL	:= SuperGetMV("MV_XREPVOL",,"")
	Local _cUser  		:= RetCodUsr()
	Local cQuery1 		:= ""
	Local cAlias1 		:= "QRYTEMP"
	Local cUserReab     := GetNewPar("ST_CB7REAB","001566/000415/000439/000421")   //Valdemir Rabelo 26/05/2022
	Local cArML         := ""  //ARMAZ…M PARA TRANSFER NCIA MERCADO LIVRE
	Local cEndML        := ""  //ENDERE«O PARA TRANSFER NCIA MERCADO LIVRE
	Local lTransfML     := .T.
	Default lReplVol	:= .F.

	Setkey(VK_F5,Nil)

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " + RetSqlName("SC9") + " SC9 "
	cQuery1  += " WHERE SC9.D_E_L_E_T_= ' ' "
	cQuery1  += " 	AND C9_FILIAL = '" + xFilial("SC9") + "' "
	cQuery1  += " 	AND C9_PEDIDO = '" + cPedido + "' "
	cQuery1  += " 	AND C9_ORDSEP = '" + cOrdSep + "' "
	cQuery1  += " 	AND C9_NFISCAL <> ' ' "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )
	If (cAlias1)->CONTADOR >= 1
		dbSelectArea("CB7")
		CB7->( dbSetOrder(1) )
		CB7->( dbGotop() )
		If CB7->( dbSeek(xFilial('CB7') + cOrdSep) )
			if (CB7_STATUS == '4')         // Valdemnir Rabelo 26/05/2022 - Ticket: 20220516010273
			   if !(__cUserID $ cUserReab)
					FwMsgRun(,{|| Sleep(3000)},'Informativo','Embalagem j· Finalizada, n„o pode ser alterada.')			   
					Return
			   else 
			      if !FWAlertYesNo("Deseja reabrir a embalagem?","ConfirmaÁ„o!")
				     Return
				  endif 
			   endif 

			Endif 
			If CB7->CB7_XVIRTU = '1'
				CB9->( dbSetorder(4) )
				CB6->( dbOrderNickName("STFSCB601") )    //CB6_FILIAL + CB6_XORDSE + CB6_VOLUME
				If	CB6->( dbSeek(xFilial('CB6') + cOrdSep) )
					If CB6->CB6_VOLUME = cOrdSep + 'AUTO'
						If MsgYesNo("OS automatica deseja Reembalar?")
							// Deleta o registro da CB6
							RecLock("CB6",.F.)
							CB6->( dbDelete() )
							CB6->( MsUnlock() )
							CB6->( dbCommit() )
							// Deleta o registro da CB7
							CB7->( RecLock("CB7",.F.) )
							CB7->CB7_STATUS := '2'
							CB7->( MsUnLock() )
							CB7->( dbCommit() )
							// Deleta o registro da CB8
							dbSelectArea("CB8")
							CB8->( dbSetOrder(1) )
							CB8->( dbGotop() )
							If CB8->( dbSeek(xFilial('CB8') + cOrdSep) )
								While CB8->( !Eof() ) .And. CB8->(CB8_FILIAL + CB8_ORDSEP) == xFilial('CB8') + cOrdSep
									CB8->( RecLock("CB8",.F.) )
									CB8->CB8_SALDOE := CB8->CB8_QTDORI
									CB8->( MsUnLock() )
									CB8->( dbCommit() )
									dbSelectArea("CB9")
									CB9->( dbSetOrder(6) ) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+CB9_LOTSUG+CB9_SLOTSU+CB9_SUBVOL+CB9_CODETI
									CB9->( dbGoTop() )
									If CB9->( dbSeek(xFilial("CB9") + CB8->(CB8_ORDSEP + CB8_ITEM)) )
										RecLock("CB9",.F.)
										CB9->CB9_QTEEMB := 0
										CB9->CB9_STATUS := '1'
										CB9->CB9_CODEMB := ' '
										CB9->CB9_LOTECT := ' '
										CB9->CB9_VOLUME := ' '
										CB9->( MsUnlock() )
										CB9->( dbCommit() )
									EndIf
									CB8->( dbSkip() )
								End
							EndIf
						EndIf
					EndIf
				Else
					Return
				EndIf
			Else
				MsgAlert("Essa ordem de separaÁ„o possui NF amarrada e o volume n„o poder· ser alterado","AtenÁ„o") //Renato Nogueira - Chamado 000094
				Return
			EndIf
		EndIf
	EndIf

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " + RetSqlName("CB6") + " B6 "
	cQuery1  += " WHERE B6.D_E_L_E_T_ = ' ' "
	cQuery1  += " 	AND CB6_FILIAL = '" + xFilial("CB6") + "' "
	cQuery1  += " 	AND CB6_PEDIDO = '" + cPedido + "' "
	cQuery1  += " 	AND CB6_XORDSE = '" + cOrdSep + "' "
	cQuery1  += " 	AND CB6_XPESO <= 0 "
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR >= 1 .And. lInclui
		MsgAlert("Existem volumes em aberto, verifique","AtenÁ„o") //Renato Nogueira - Chamado 000094
		Return
	EndIf

	If Empty(cOrdSep)
		MsgAlert("Ordem de separaÁ„o n„o informada!!!","AtenÁ„o")
		Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
		Return .F.
	EndIf

	If CB7->CB7_STATUS > "4"
		MsgAlert("Ordem de SeparaÁ„o com status de " + RetStatus(CB7->CB7_STATUS) + " e n„o pode haver manutenÁ„o","AtenÁ„o")
		Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
		Return .T.
	EndIf

	If Empty(aVolumes[1,2])
		lInclui := .T.
	EndIf

	aCB8Sdo	:= {}

	If lInclui
		lSaldoEmb := .T.	// … verdadeiro porque j· foi verificado o saldo na FunÁ„o ReplVol -- Tratamento para ajuste do Ticket 20210323004713 - CorreÁ„o Replicar volume -- Eduardo Pereira - Sigamat
		If !lSaldoEmb
			MsgAlert("Ordem de SeparaÁ„o n„o possuÌ saldo de embalagem para ser embalado.","AtenÁ„o")
			Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
			Return .T.
		EndIf
		// Ticket 20210407005509 - Inclus„o de volume pedido com embalagem finalizada -- Eduardo Sigamat -- Inicio do tratamento - 08.04.2021
		If CB7->CB7_STATUS == "4"	// Embalagem Finalizada
			MsgAlert("Inclus„o de Volume n„o permitida, Embalagem finalizada!!!","AtenÁ„o")
			Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
			Return .T.
		EndIf
		// Ticket 20210407005509 - Inclus„o de volume pedido com embalagem finalizada -- Eduardo Sigamat -- Fim do tratamento - 08.04.2021
		If Empty(CB7->CB7_XDIEM)
			CB7->( RecLock("CB7") )
			CB7->CB7_XDIEM := Date()
			CB7->CB7_XHIEM := Time()
			CB7->( MsUnLock() )
		EndIf
		While !LockByName("STFSFA30.FSW", .F., .F., LS_GetTotal(1) < 0)
			Sleep(500)
		EndDo
		cVolume := Soma1(STUltimo(cOrdSep))
		CB6->( RecLock("CB6",.T.) )
		CB6->CB6_FILIAL := xFilial("CB6")
		CB6->CB6_VOLUME := cVolume
		CB6->CB6_XORDSE := cOrdSep
		CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
		CB6->CB6_TIPVOL := CB3->CB3_CODEMB
		CB6->CB6_XDTINI := dDataBase
		//CB6->CB6_XHINI  := Left(Time(),5)
		CB6->CB6_XHINI  := Time()
		CB6->( MsUnLock() )
		UnlockByName("STFSFA30.FSW", .F., .F., LS_GetTotal(1) < 0)
	Else
		cVolume	:= cOrdSep + aVolumes[oLbxVol:nAt,2]
		CB6->( dbSetOrder(1) )
		CB6->( dbSeek(xFilial('CB6') + cVolume) )
		  
		If !Empty(CB6->CB6_XPESO)
			If ! lTelaPri .And. !_cUser $ cMV_XEXCEMB
				MsgAlert("Volume fechado! Usuario sem autorizacao para excluir embalagem")
				Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
				Return .f. 
			EndIf
			If ! MsgYesNo("Deseja reabrir o volume?","AtenÁ„o")
				Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
				Return .f.
			EndIf
		EndIf
		  
		cCodEmb 	:= CB6->CB6_TIPVOL
		cCodEmbOld	:= cCodEmb
		cDescEmb	:= Posicione("CB3", 1, xFilial("CB3") + CB6->CB6_TIPVOL, "CB3_DESCRI")
	EndIf

	nLinVol := 0
	If lReplVol
		nLinVol		:= oLbxVol:nAt
		cCodEmb 	:= Substr(aVolumes[nLinVol,3],1,3)
		cDescEmb	:= Substr(aVolumes[nLinVol,3],5)
		lOk := .T.
		For nItem := 1 to Len(aVolItem)
			aAdd(aLbx,{.T.,aVolItem[nItem,1],aVolItem[nItem,2],aVolItem[nItem,3],aVolItem[nItem,4],""})
			VldEti(oEtiqueta,lChk,cVolume,oLbx,aLbx,@cCodEmb,oCodEmb,@cCodEmbOld,lReplVol,oLbxItem,aVolItem,nItem)
		Next nItem
	Else
		DEFINE MSDIALOG oDlg TITLE "ManutenÁ„o de Volumes" FROM 0,0 TO 470,600 PIXEL OF oMainWnd
		EnchoiceBar( oDlg, {|| lOk:= .t.,oDlg:End()} , {|| oDlg:End() },, )
		oPanel 			:= TPanel():New( 010, 010, ,oDlg, , , , , , 30, 30, .F.,.T. )
		oPanel:align 	:= CONTROL_ALIGN_TOP
		oPanel3 		:= TCBrowse():New(010,010,70,70,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oPanel3:align 	:= CONTROL_ALIGN_ALLCLIENT
		@ 002 , 001 SAY   "Volume" OF	oPanel PIXEL
		@ 001 , 040 MSGET cVolume	SIZE 040, 09 OF oPanel PIXEL  When .F.
		@ 002 , 101 SAY   "Tipo de Embalagem" 	 OF oPanel PIXEL
		@ 001 , 155 MSGET oCodEmb 	Var cCodEmb		SIZE 040, 09 OF oPanel PIXEL PICTURE "!!!" F3 "CB3" VALID VldEmb(cCodEmb,@cDescEmb) //When Empty(cCodEmb)
		@ 001 , 200 MSGET oDescEmb 	Var cDescEmb	SIZE 080, 09 OF oPanel PIXEL WHEN .F.
		@ 017 , 001 SAY   "Etiqueta" 					PIXEL  COLOR CLR_BLUE  OF oPanel
		@ 016 , 040 MSGET oEtiqueta VAR cEtiqueta	PIXEL  COLOR CLR_BLUE SIZE 120,10 OF oPanel PICTURE "@!" VALID VldEti(oEtiqueta,lChk,cVolume,oLbx,aLbx,@cCodEmb,oCodEmb,@cCodEmbOld,lReplVol,oLbxItem,aVolItem,0)
		@ 017 , 168 BUTTON oF3 PROMPT "?" SIZE 9,10 OF oPanel PIXEL ACTION   MontaBarra(oEtiqueta)
		//		@ 017 , 200 CHECKBOX oChk VAR lChk PROMPT "Estorna" 	SIZE 40,7 	PIXEL OF oPanel When lTelaPri
		@ 001 , 001 LISTBOX oLbx FIELDS HEADER " ","Produto","DescriÁ„o","Quantidade","Lote"," " SIZES {2,15,20,20,20,10} SIZE 490,095 OF oPanel3 PIXEL
		oLbx:align := CONTROL_ALIGN_ALLCLIENT
		oLbx:bGotFocus:={||SetFocus(oEtiqueta:hWnd)}
		MontaaLbx(cVolume,oLbx,aLbx)
		Setkey(VK_F4,{|| lOk:= .t.,oDlg:End()}) //SolicitaÁ„o Kleber Braga - 27/11/2013
		/*
		oLbx:lUseDefaultColors := .F.
		oLbx:SetBlkColor({|| 4227327 })
		*/
	ACTIVATE MSDIALOG oDlg CENTERED Valid VldInfEmb(cCodEmb,oCodEmb)
EndIf

If lOk .And. !Empty(aLbx[1,2])
    nCnt  := 0
	nPeso := 0
	While nCnt <= 10    // Faz 10 tentativas para pegar o peso - Valdemir Rabelo Ticket: 20220516010273
	    if nPeso == 0
	If GetMV("ST_BALAN",,.F.)
		If	lReplVol
			nPeso := Val(aVolumes[nLinVol,8])
		Else
			nPeso := u_STBALANCA()
			If nPeso = 0
				nPeso := PegaPeso(cVolume)
			EndIf
		EndIf
	Else
		nPeso := If(lReplVol,Val(aVolumes[nLinVol,8]),PegaPeso(cVolume))
	EndIf
		Endif 
		if nPeso > 0
		   exit
		endif 
		nCnt++
	Enddo
EndIf

If lOk
	STCHKCB8(cOrdSep)
EndIf

If Empty(aLbx[1,2])	.And. cVolume == Ultimo(cOrdSep)
	//MsgAlert("Excluindo o ultimo volume vazio!!!","AtenÁ„o")
	CB6->( dbSetOrder(1) )
	CB6->( dbSeek(xFilial('CB6') + cVolume) )
	CB6->( RecLock("CB6",.F.) )
	CB6->( dbDelete() )
	CB6->( MsUnlock() )
Else
	CB6->( dbSetOrder(1) )
	CB6->( dbSeek(xFilial('CB6') + cVolume) )
	CB6->( RecLock("CB6",.F.) )
	CB6->CB6_TIPVOL := cCodEmb
	CB6->CB6_XPESO	:= nPeso
	CB6->( MsUnlock() )
EndIf

MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
Eval(oLbxVol:bChange)

FimProcEmb(aVolumes)     // Ajuste para Ticket: 20210615010129

If CB7->CB7_STATUS >= "4"
	SC5->(DbSetOrder(1))
	If !Empty(CB7->CB7_PEDIDO) .And. SC5->( dbSeek(xFilial('SC5') + CB7->CB7_PEDIDO) )
		SC5->( RecLock('SC5',.F.) )
		SC5->C5_PBRUTO	:= oTotPeso:cText
		SC5->C5_VOLUME1	:= oTotVol:cText
		SC5->C5_ESPECI1	:= "CX"
		SC5->( MsUnLock() )
	EndIf
EndIf

If nPeso > 0 .And. !lReplVol
	EtiVol(cOrdSep,Right(cVolume,4),oDescImp)
EndIf
oStatus	:cText 	:= RetStatus(CB7->CB7_STATUS)

//FR - Fl·via Rocha - SIGAMAT CONSULTORIA
//AQUI CHAMA A ROTINA DE TRANSFER NCIA CASO O CLIENTE SEJA MERCADO LIVRE
If CB7->CB7_STATUS == "4" //embalagem finalizada	
	DbSelectArea("SA1")
	If FieldPos("A1_XAMZTRF") > 0 .and. FieldPos("A1_XENDTRF") > 0						
		//CAMPO ARMAZ…M P/ TRANSFER NCIA
		cArML := Posicione("SA1",1,xFilial("SA1") + CB7->(CB7_CLIENT + CB7_LOJA),"A1_XAMZTRF")
		//CAMPO ENDERE«O P/ TRANSFER NCIA
		cEndML:= Posicione("SA1",1,xFilial("SA1") + CB7->(CB7_CLIENT + CB7_LOJA),"A1_XENDTRF")		
		If !Empty(cArML)
			lTransfML := U_STTranML(CB7->CB7_ORDSEP,CB7->CB7_PEDIDO,cArML,cEndML,CB7->CB7_CODOPE,.T.)
			//             STTranML(cOS            ,cPedido        ,cArML,cEndML,cxOPER         ,lTela)
			If !lTransfML
				MSGALERT("A TRANSFER NCIA PARA MERCADO LIVRE N√O FOI REALIZADA, FAVOR ESTORNAR A EMBALAGEM")
			Endif 
		Endif 
	Endif
Endif  
//FR - 10/05/2023 - MERCADO LIVRE 

Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})

Return

Static Function VldInfEmb(cCodEmb,oCodEmb)

	Local lRet 		:= .T.
	Local aArea 	:= GetArea()
	Local aAreaCB3	:= CB3->( GetArea() )

	If Empty(cCodEmb)
		MsgAlert("Codigo de Embalagem n„o informado!!!","AtenÁ„o")
		oCodEmb:SetFocus()
		lRet := .F.
	EndIf

	CB3->( dbSetOrder(1) )
	If lRet .And. CB3->( !dbSeek(xFilial('CB3') + cCodEmb) )
		MsgAlert("Codigo de Embalagem n„o encontrado!!!","AtenÁ„o")
		oCodEmb:SetFocus()
		lRet := .F.
	EndIf

	RestArea(aAreaCB3)
	RestArea(aArea)

Return lRet

/*
Static Function Ultimo(cOrdSep)
Local aArea		:= GetArea()
Local aAreaCB6	:= CB6->(GetArea())
Local cVolume	:= cOrdSep+"0000"

CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
CB6->(DbSeek(xFilial('CB6')+cOrdSep))
	While CB6->(! Eof() .and. CB6_FILIAL+CB6_XORDSE == xFilial('CB6')+cOrdSep)
cVolume	:=CB6->CB6_VOLUME
CB6->(DbSkip())
	End
RestArea(aAreaCB6)
RestArea(aArea)
Return cVolume
*/

Static Function Ultimo(cOrdSep)

	Local aArea		:= GetArea()
	Local aAreaCB6	:= CB6->( GetArea() )
	Local cVolume	:= cOrdSep + "0000"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STVOL' + cHora + cMinutos + cSegundos
	Local cQuery    := ' '

	cQuery := " SELECT
	cQuery += " CB6.CB6_VOLUME
	cQuery += " FROM " + RetSqlName("CB6") + " CB6 "
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB6.CB6_XORDSE = '" + cOrdSep + "' "
	cQuery += " 	AND CB6.CB6_FILIAL =  '" + xFilial("CB6") + "' "
	cQuery += " ORDER BY CB6.CB6_VOLUME DESC
	//cQuery := ChangeQuery(cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		cVolume	:=(cAliasLif)->CB6_VOLUME
	EndIf

	If Empty(Alltrim(cVolume))
		cVolume	:= cOrdSep+"0000"
	EndIf

	RestArea(aAreaCB6)
	RestArea(aArea)

Return cVolume

Static Function StUltimo(cOrdSep)

	Local aArea		:= GetArea()
	Local aAreaCB6	:= CB6->( GetArea() )
	Local cVolume	:= cOrdSep + "0000"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STVOL' + cHora + cMinutos + cSegundos
	Local cQuery    := ' '

	cQuery := " SELECT
	cQuery += " CB6.CB6_VOLUME
	cQuery += " FROM " + RetSqlName("CB6") + " CB6 "
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB6.CB6_XORDSE = '" + cOrdSep + "' "
	cQuery += " 	AND CB6.CB6_FILIAL =  '" + xFilial("CB6") + "' "
	cQuery += " ORDER BY CB6.CB6_VOLUME
	//cQuery := ChangeQuery(cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	dbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If  Select(cAliasLif) > 0
		While 	(cAliasLif)->( !Eof() )
			cVolume:= Soma1(cVolume)
			If  cVolume  <> (cAliasLif)->CB6_VOLUME
				cVolume:= Tira1(cVolume)
				RestArea(aAreaCB6)
				RestArea(aArea)
				Return cVolume
			EndIf
			(cAliasLif)->( dbSkip() )
		Enddo
		(cAliasLif)->( dbCloseArea() )
	EndIf

	If Empty(Alltrim(cVolume))
		cVolume	:= cOrdSep + "0000"
	EndIf

	RestArea(aAreaCB6)
	RestArea(aArea)

Return cVolume

Static Function PegaPeso(cVolume)

	Local aParambox	:= {}
	Local aRet		:= {}
	Local nPeso		:= 0

	aAdd(aParamBox,{1, "Peso", nPeso, "9999999.99", "", "", "", 0, .F.})
	If !ParamBox(aParamBox,"Peso do Volume",@aRet,,,,,,,,.f.)
		Return 0
	EndIf

Return MV_PAR01

Static Function MontaBarra(oEtiqueta)

	Local aParambox	:= {}
	Local aRet		:= {}
	Local cProduto	:= Space(15)
	Local nQuant	:= 0
	Local cLote		:= Space(10)

	aAdd(aParamBox,{1,"Produto"		,cProduto	,"@!"	   , "","SB1", "", 0, .T.})
	aAdd(aParamBox,{1,"Quantidade"	,nQuant		,"@E 99999", "",   "", "", 0, .T.})
	aAdd(aParamBox,{1,"Lote"		,cLote		,"@!"	   , "",   "", "", 0, .T.})
	If !ParamBox(aParamBox,"Conteudo da Etiqueta",@aRet,,,,,,,,.f.)
		Return
	EndIf

	oEtiqueta:cText:= PadR(Alltrim(aRet[1]) + "=" + Alltrim(aRet[3]) + "=" + AllTrim(Str(aRet[2])),48)
	oEtiqueta:SetFocus()
	Eval(oEtiqueta:bValid)

Return .T.

Static Function MontaaLbx(cVolume,oLbx,aLbx)

	Local cPicture	:= PesqPict("CB9","CB9_QTEEMB")
	Local cDesProd	:= ''
	Local oOK 		:= LoadBitmap(GetResources(),'br_verde')
	Local oNO		:= LoadBitmap(GetResources(),'br_vermelho')
	Local cQuery9 	:= ""
	Local cAlias9 	:= "QRYTEMP9"

	aLbx := {}

	CB9->( dbSetOrder(4) )
	If !Empty(cVolume) .And. CB9->( dbSeek(xFilial("CB9") + cVolume) )
		cQuery9 := " SELECT MAX(R_E_C_N_O_) REGISTRO "
		cQuery9 += " FROM " + RetSqlName("CB9") +  " B9 "
		cQuery9 += " WHERE B9.D_E_L_E_T_ = ' ' "
		cQuery9 += " 	AND CB9_FILIAL = '" + CB9->CB9_FILIAL + "' "
		cQuery9 += " 	AND CB9_ORDSEP = '" + CB9->CB9_ORDSEP + "' "
		cQuery9 += " 	AND CB9_STATUS = '2' "
		cQuery9 += " 	AND CB9_XULTVO = 'S' "
		If !Empty(Select(cAlias9))
			dbSelectArea(cAlias9)
			(cAlias9)->( dbCloseArea() )
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery9),cAlias9,.T.,.T.)

		dbSelectArea(cAlias9)
		(cAlias9)->( dbGoTop() )
		If (cAlias9)->( !Eof() )
			_nLastReg :=(cAlias9)->REGISTRO
		EndIf
		While CB9->( !Eof() .And. CB9_FILIAL + CB9_VOLUME == xFilial("CB9") + cVolume)
			cDesProd := Posicione("SB1",1,XFILIAL("SB1") + CB9->CB9_PROD,"B1_DESC")
			aadd(aLbx,{Iif(_nLastReg==CB9->(Recno()),.T.,.F.),CB9->CB9_PROD,cDesProd,Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,''})
			CB9->( dbSkip() )
		EndDo
		aSort(aLbx,,,{|x,y|x[1]>y[1]})
	EndIf

	If Empty(aLbx)
		aLbx := { {.F., Space(15), Space(40), Space(20), Space(20), Space(40)} }
	EndIf

	oLbx:SetArray( aLbx )
	oLbx:bLine := {||{If(aLbx[oLbx:nAt,1],oOK,oNO),;
		aLbx[oLbx:nAt,2],;
		aLbx[oLbx:nAt,3],;
		aLbx[oLbx:nAt,4],;
		aLbx[oLbx:nAt,5],;
		aLbx[oLbx:nAt,6]}}

	oLbx:Refresh()

Return

Static Function VldEmb(cCodEmb,cDescEmb)

	Local aArea		:= GetArea()
	Local aAreaCB3	:= CB3->( GetArea() )

	cDescEmb := Space(30)

	CB3->( dbSetOrder(1) )
	If !Empty(cCodEmb) .And. !CB3->( dbSeek(xFilial('CB3') + cCodEmb) )
		MsgAlert("Codigo de Embalagem n„o encontrado!!!","AtenÁ„o")
		RestArea(aAreaCB3)
		RestArea(aArea)
		Return .F.
	EndIf

	If !Empty(cCodEmb)
		cDescEmb:= CB3->CB3_DESCRI
	EndIf

	RestArea(aAreaCB3)
	RestArea(aArea)

Return .T.

Static Function VldEti(oEtiqueta,lEstorna,cVolume,oLbx,aLbx,cCodEmb,oCodEmb,cCodEmbOld,lReplVol,oLbxItem,aVolItem,nItem)

	Local aRet
	Local cProduto
	Local cLote    		:= Space(10)
	Local cSLote   		:= Space(6)
	Local cNumSer  		:= Space(20)
	Local nQE      		:= 0
	Local nLin          := 0
	Local nSaldoEmb
	Local nRecno,nRecnoCB9
	Local nQtdeSep
	Local cOrdSep		:= CB7->CB7_ORDSEP
	Local cEtiqueta 	:= ""
	Local cLoteX 		:= ""
	Local cCodOpe		:= CbRetOpe()
	Local _cCodPrx		:= ""
	Local i
	Local _aProdsDif 	:= {}
	Local _nY 			:= 0
	Local _nX 			:= 0
	Local aTEmpFil      := Separa(getMV("ST_TEMPFIL",.F.,"11,01"),",")    // Valdemir Rabelo 07/01/2022 - Aruja CD
	Local nx            :=0
	Local aRecno        :={} 
	Local aAreaCB9      :={}
	Local aArea         :={}
	private cEmpBal     := "E"

	Default lEstorna 	:= .F.
	Default lReplVol 	:= .F.

	If lReplVol
		cEtiqueta := PadR(Alltrim(aVolItem[nItem,1]) + "=" + Alltrim(aVolItem[nItem,4]) + "=" + Alltrim(aVolItem[nItem,3]),48)
	Else
		cEtiqueta := oEtiqueta:cText
	EndIf

	If Empty(cEtiqueta)
		Return .T.
	EndIf
/*
	cEtiqueta := U_STAVALET(cEtiqueta, cEmpBal) //Rotina para avaliar etiqueta e ajustar para padr„o de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014

	If Empty(cEtiqueta)
		Return .F.
	EndIf
*/
	aRet := CBRetEtiEan(cEtiqueta)//53606480722399                                  
	If	Empty(aRet)
		MsgAlert("Etiqueta invalida","Aviso")
		Return .F.
	EndIf

	cProduto:= aRet[1]
	nQE  	:= aRet[2]
	cLote  	:= aRet[3]
	cNumSer := aRet[5]
	cLoteX 	:= U_RetLoteX()

	//Tiago - chamado: 20230607007153 - data: 22/06/2023
	nQtdDigit	:= nQE 	
	nQtdTotPed	:= 0

	cQueryB9 := "SELECT * FROM " +RetSqlName("CB9")
	cQueryB9 += " WHERE D_E_L_E_T_= ''" 					
	cQueryB9 += " AND CB9_ORDSEP = '" +cOrdSep+"'" 	
	cQueryB9 += " AND CB9_VOLUME = ''" 	

	PLSQuery(cQueryB9, 'QUERYB9')
	DbSelectArea('QUERYB9')
	QUERYB9->(DbGoTop())

	While ! QUERYB9->(EoF())

		nQtdTotPed += QUERYB9->CB9_QTESEP

		QUERYB9->(DbSkip())

	ENDDO

	// Valida se para Ean13 est· sendo lanÁado mais que o permitido - Valdemir Rabelo 09/01/2022
/*
	CB9->( dbSetorder(2) )
	if CB9->( dbSeek(xFilial("CB9") + cOrdSep + cVolume ) )
		CB8->( dbSetOrder(4) ) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
		IF CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
			if ((CB9->CB9_QTEEMB+nQE) > CB8->CB8_QTDORI)
				ApMsgAlert("Quantidade superior a embalar","Aviso")	   
				Return .F. 
			endif
		ENDIF 
	else 
	    
		if (nQE > CB8->CB8_QTDORI)
			ApMsgAlert("Quantidade superior a embalar","Aviso")	   
			Return .F. 
		endif
	endif  
*/
	If Empty(nQE)
		ApMsgAlert("Quantidade invalida","Aviso")
		If ! lReplVol
			oEtiqueta:cText := Space(48)
		EndIf
		Return .F.
	EndIf

	If GetMv("ST_30GIO",,.T.)//GIOVANI.ZAGO SE DER PROBLEMA NA EMBALAGEM BASTA CRIAR O PARAMETRO COM .F.  06/08/2019
		If cEmpAnt =aTEmpFil[1] .And. cFilAnt = aTEmpFil[2]
			dbSelectArea("SC5")
			SC5->( dbSetOrder(1) )
			If 	SC5->( dbSeek(xFilial("SC5") + CB7->CB7_PEDIDO) )
				dbSelectArea("Z44")
				Z44->( dbSetOrder(1) )
				If Z44->( dbSeek(xFilial("Z44") + SC5->C5_CLIENTE + SC5->C5_LOJACLI) )
					If Z44->Z44_MAXITE > 0
						_cCodPrx := Alltrim(cProduto)
						_nCodPrx := 0
						For i := 1 To Len(aLbx)
							If !(Empty(Alltrim(aLbx[i,2])))
								_lAchou := .F.
								For _nY := 1 To Len(_aProdsDif)
									If AllTrim(_aProdsDif[_nY]) == AllTrim(aLbx[i,2])
										_lAchou := .T.
									EndIf
								Next
								If !_lAchou
									aAdd(_aProdsDif,aLbx[i,2])
								EndIf
							EndIf
						Next i
						_lProdIgual := .F.
						For _nY := 1 To Len(_aProdsDif)
							If AllTrim(_aProdsDif[_nY]) == AllTrim(_cCodPrx)
								_lProdIgual := .T.
							EndIf
						Next
						_nCodPrx := Len(_aProdsDif)
						If _nCodPrx >= Z44->Z44_MAXITE .And. !_lProdIgual
							MsgAlert("Quantidade de itens por volume: " + cValtoChar(Z44->Z44_MAXITE) + " item")
							Return .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If !Rastro(cProduto)
		/*
		PA0->( dbSetOrder(4) )
		If !PA0->( !dbSeek(xFilial("PA0") + cOrdSep + cProduto + cLoteX) )    //Comentado por Leonardo Flex 26/02/2013 - Item 2 do plano de melhorias
			ApMsgAlert("Lote Especifico n„o encontrado","Aviso")
			oEtiqueta:cText := Space(48)
			Return .F.
		EndIf
		*/
	EndIf

	If !lEstorna
		CB9->( dbSetorder(8) )
		If CB9->( !dbSeek(xFilial("CB9") + cOrdSep + cProduto + cLote + cSLote + cNumSer + Space(10)) )
			MsgAlert("Etiqueta Invalida","Aviso")
			If !lReplVol
				oEtiqueta:cText := Space(48)
			EndIf
			Return .F.
		EndIf
		nSaldoEmb := 0
		//While CB9->(! EOF() .AND. CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOTECT+CB9_NUMLOT+CB9_VOLUME ==xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+space(10)) //Comentado por Leonardo Flex -> corrigido condicao da busca
		While CB9->( !Eof() ) .And. CB9->CB9_FILIAL == xFilial("CB9") .And. AllTrim(CB9->CB9_ORDSEP) == AllTrim(cOrdSep) .And. ;
				AllTrim(CB9->CB9_PROD) == AllTrim(cProduto) .And. AllTrim(CB9->CB9_LOTECT) == AllTrim(cLote) .And. ;
				AllTrim(CB9->CB9_NUMLOT) == AllTrim(cSLote) .And. CB9->CB9_VOLUME == Space(10)
			nSaldoEmb += CB9->CB9_QTESEP
			CB9->( dbSkip() )
		EndDo

		If	nQE > nSaldoEmb
			MsgAlert("Quantidade informada maior que disponivel para embalar","Aviso")
			If !lReplVol
				oEtiqueta:cText := Space(48)
			Else
				lOk := .F.
				aLbx[1,1] := .F.
				aLbx[1,2] := ""
			EndIf
			Return .F.
		EndIf
		CB6->( dbSetOrder(1) )
		CB6->( RecLock("CB6",.F.) )
		CB6->CB6_STATUS := "1"   // ABERTO
		CB6->CB6_XOPERA := cCodOpe
		CB6->CB6_XDTFIN := dDataBase
		//CB6->CB6_XHFIN  := Left(Time(),5)
		CB6->CB6_XHFIN  := Time()
		CB6->( MsUnlock() )
		//-- Atualiza Quantidade Embalagem
		nSaldoEmb := nQE
		CB9->(DbSetorder(8))
		While nSaldoEmb > 0 .And. CB9->( dbSeek(xFilial("CB9") + cOrdSep + cProduto + cLote + cSLote + cNumSer + Space(10)) )
			If	nSaldoEmb > CB9->CB9_QTESEP
				Begin Transaction
					CB9->( RecLock("CB9") )
					CB9->CB9_VOLUME := cVolume
					CB9->CB9_QTEEMB := CB9->CB9_QTESEP
					CB9->CB9_CODEMB := cCodOpe
					CB9->CB9_STATUS := "2"  // Embalado
					CB9->( MsUnlock() )
					//-- Atualiza Itens Ordem da Separacao
					CB8->( dbSetOrder(4) ) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
					CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
					CB8->( RecLock("CB8") )
					CB8->CB8_SALDOE -= CB9->CB9_QTESEP
					If CB8->CB8_SALDOE<0
						CB8->CB8_SALDOE	:= 0
					EndIf
					CB8->( MsUnlock() )
				End Transaction
				nSaldoEmb -= CB9->CB9_QTESEP
			Else
				nRecnoCB9:= CB9->( Recno() )
				CB9->( dbSetOrder(8) )
				If	CB9->( dbSeek(CB9_FILIAL + CB9_ORDSEP + CB9_PROD + cLoteX + CB9_NUMLOT + CB9_NUMSER + cVolume + CB9_ITESEP + CB9_LOCAL + CB9_LCALIZ) )
					Begin Transaction
						CB9->( RecLock("CB9") )
						CB9->CB9_QTEEMB += nSaldoEmb
						CB9->CB9_QTESEP += nSaldoEmb
						CB9->( MsUnlock() )
						//-- Atualiza Itens Ordem da Separacao
						CB8->( dbSetOrder(4) ) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
						CB8->( RecLock("CB8") )
						CB8->CB8_SALDOE -= nSaldoEmb
						If CB8->CB8_SALDOE < 0
							CB8->CB8_SALDOE	:= 0
						EndIf
						CB8->( MsUnlock() )
						//--
						CB9->( dbGoto(nRecnoCB9) )
						CB9->( RecLock("CB9") )
						CB9->CB9_QTESEP -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->( dbDelete() )
						EndIf
						CB9->( MsUnlock() )
					End Transaction
					nSaldoEmb := 0
				Else
					CB9->( dbGoto(nRecnoCB9) )
					nRecno:= CB9->( CBCopyRec() )
					Begin Transaction
						CB9->( RecLock("CB9") )
						CB9->CB9_VOLUME := cVolume
						CB9->CB9_QTEEMB := nSaldoEmb
						CB9->CB9_QTESEP := nSaldoEmb
						CB9->CB9_CODEMB := cCodOpe
						CB9->CB9_STATUS := "2"  // Embalado
						CB9->CB9_LOTECT	:= cLoteX
						CB9->( MsUnlock() )
						//-- Atualiza Itens Ordem da Separacao
						CB8->( dbSetOrder(4) ) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
						CB8->( RecLock("CB8") )
						CB8->CB8_SALDOE -= nSaldoEmb
						If CB8->CB8_SALDOE < 0
							CB8->CB8_SALDOE	:= 0
						EndIf
						CB8->( MsUnlock() )
						//--
						CB9->( dbGoto(nRecno) )
						CB9->( RecLock("CB9") )
						CB9->CB9_QTESEP -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->( dbDelete() )
						EndIf
						CB9->( MsUnlock() )
					End Transaction
					nSaldoEmb := 0
				EndIf
			EndIf
		EndDo
        
		aArea   :=GetArea()  
        aAreaCB9:=CB9->(GETAREA()) 
        
		// Limpa Flag. 
        aRecno:=UltimoVol(CB9->CB9_FILIAL,CB9->CB9_ORDSEP,,,,'S')
        IF LEN(aRecno)>0
           FOR NX:=1 TO LEN(aRecno)
              DBSELECTAREA('CB9')
              DBGOTO(aRecno[NX])
              IF !EOF()
                 RECLOCK('CB9',.F.)
                 CB9->CB9_XULTVO :=' '
                 MSUNLOCK('CB9')
              ENDIF 
           NEXT 
        ENDIF 

        // Atribui Flag 
        aRecno:=UltimoVol(CB9->CB9_FILIAL,CB9->CB9_ORDSEP,cVolume,cLoteX,cProduto,' ')
        IF LEN(aRecno)>0
           FOR NX:=1 TO LEN(aRecno)
              DBSELECTAREA('CB9')
              DBGOTO(aRecno[NX])
              IF !EOF()
                 RECLOCK('CB9',.F.)
                 CB9->CB9_XULTVO :='S'
                 MSUNLOCK('CB9')
              ENDIF 
           NEXT 
        ENDIF 
         
		RestArea(aAreaCB9) 
		RestArea(aArea)

        /*/ 
		_cUpd := " UPDATE " + RetSqlName("CB9") + " B9 "
		_cUpd += " SET CB9_XULTVO = ' ' "
		_cUpd += " WHERE B9.D_E_L_E_T_=' ' "
		_cUpd += " 	AND CB9_FILIAL = '" + CB9->CB9_FILIAL + "' "
		_cUpd += " 	AND CB9_ORDSEP = '" + CB9->CB9_ORDSEP + "' "
		TCSqlExec(_cUpd)
		_cUpd := " UPDATE " + RetSqlName("CB9") + " B9 "
		_cUpd += " SET CB9_XULTVO = 'S' "
		_cUpd += " WHERE B9.D_E_L_E_T_ = ' ' "
		_cUpd += " 	AND CB9_FILIAL = '" + CB9->CB9_FILIAL + "' "
		_cUpd += " 	AND CB9_ORDSEP = '" + CB9->CB9_ORDSEP + "' "
		_cUpd += " 	AND CB9_VOLUME = '" + cVolume + "' "
		_cUpd += " 	AND CB9_LOTECT = '" + cLoteX + "' "
		_cUpd += " 	AND CB9_PROD = '" + cProduto + "' "
		TCSqlExec(_cUpd)
        /*/


	Else	//If !lEstorna
		CB9->( dbSetorder(8) )
		If CB9->( !dbSeek(xFilial("CB9") + cOrdSep + cProduto + cLote + cSLote + cNumSer + cVolume) )
			MsgAlert("Produto nao embalado","Aviso")
			If !lReplVol
				oEtiqueta:cText := Space(48)
			Endif
			Return .F.
		EndIf
		nSaldoEmb := 0
		While CB9->( !Eof() .And. CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_VOLUME == xFilial("CB9") + cOrdSep + cProduto + cLote + cSLote + cVolume)
			nSaldoEmb += CB9->CB9_QTEEMB
			CB9->( dbSkip() )
		EndDo
		If nQE > nSaldoEmb
			MsgAlert("Quantidade informada maior que embalado","Aviso")
			If !lReplVol
				oEtiqueta:cText := Space(48)
			EndIf
			Return .F.
		EndIf
		//-- Estorna Quantidade Embalagem
		nSaldoEmb := nQE
		CB9->( dbSetorder(8) )
		While nSaldoEmb > 0 .And. CB9->( dbSeek(xFilial("CB9") + cOrdSep + cProduto + cLote + cSLote + cNumSer + cVolume) )
			If	nSaldoEmb >= CB9->CB9_QTEEMB
				nRecnoCB9:= CB9->( Recno() )
				nQtdeSep := CB9->CB9_QTESEP
				Begin Transaction
					CB9->( dbSetOrder(8) )
					If	CB9->( dbSeek(CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_NUMSER + Space(10) + CB9_ITESEP + CB9_LOCAL + CB9_LCALIZ) )
						CB9->( RecLock("CB9") )
						CB9->CB9_QTESEP += nQtdeSep
						CB9->( MsUnlock() )
						CB9->( dbGoto(nRecnoCB9) )
						//--
						CB8->( dbSetOrder(4) )
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
						CB9->( RecLock("CB9") )
						CB9->( dbDelete() )
						CB9->( MsUnlock() )
					Else
						CB9->( dbGoto(nRecnoCB9) )
						CB9->( RecLock("CB9") )
						CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB := 0
						CB9->CB9_CODEMB := ""
						CB9->CB9_STATUS := "1"  // Em Aberto
						CB9->( MsUnlock() )
						CB8->( dbSetOrder(4) )
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
					EndIf
					CB8->( RecLock("CB8") )
					CB8->CB8_SALDOE += nQtdeSep
					CB8->( MsUnlock() )
				End Transaction
				nSaldoEmb -= nQtdeSep
			Else
				nRecnoCB9:= CB9->( Recno() )
				nQtdeSep := CB9->CB9_QTESEP
				Begin Transaction
					CB9->( dbSetOrder(8) )
					If	CB9->( dbSeek( CB9_FILIAL + CB9_ORDSEP + CB9_PROD + CB9_LOTECT + CB9_NUMLOT + CB9_NUMSER + Space(10) + CB9_ITESEP + CB9_LOCAL + CB9_LCALIZ) )
						CB9->( RecLock("CB9") )
						CB9->CB9_QTESEP += nSaldoEmb
						CB9->( MsUnlock() )
						//--
						CB9->( dbGoto(nRecnoCB9) )
						CB9->( RecLock("CB9") )
						//CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB -= nSaldoEmb
						CB9->CB9_QTESEP -= nSaldoEmb
						//CB9->CB9_CODEMB := ''
						//CB9->CB9_STATUS := "1"
						If	Empty(CB9->CB9_QTESEP)
							CB9->( dbDelete() )
						EndIf
						CB9->( MsUnlock() )
						//--
						CB8->( dbSetOrder(4) )
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
						CB8->( RecLock("CB8") )
						CB8->CB8_SALDOE += nSaldoEmb
						CB8->( MsUnlock() )
					Else
						CB9->( dbGoto(nRecnoCB9) )
						nRecno := CB9->( CBCopyRec() )
						CB9->( RecLock("CB9") )
						CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB := 0
						CB9->CB9_QTESEP := nSaldoEmb
						CB9->CB9_CODEMB := ''
						CB9->CB9_STATUS := "1"
						CB9->( MsUnlock() )
						//--
						CB8->( dbSetOrder(4) )
						CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
						CB8->( RecLock("CB8") )
						CB8->CB8_SALDOE += nSaldoEmb
						CB8->( MsUnlock() )
						CB9->( dbGoto(nRecno) )
						CB9->( RecLock("CB9") )
						CB9->CB9_QTESEP -= nSaldoEmb
						CB9->CB9_QTEEMB -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->( dbDelete() )
						EndIf
						CB9->( MsUnlock() )
					EndIf
				End Transaction
				nSaldoEmb := 0
			EndIf
		EndDo
	EndIf

	//manutencao no pa0
	PA0->( dbSetOrder(2) )
	If PA0->( !dbSeek(xFilial('PA0') + 'CB9' + PadR(cVolume,20) + cProduto + cLoteX) )
		PA0->( RecLock("PA0",.T.) )
		PA0->PA0_FILIAL 	:= xFilial("PA0")
		PA0->PA0_DOC		:= cVolume
		PA0->PA0_ORDSEP		:= PadR(cVolume,6)
		PA0->PA0_TIPDOC		:= 'CB9'
		PA0->PA0_PROD   	:= cProduto
		PA0->PA0_LOTEX  	:= cLoteX
	Else
		PA0->( RecLock("PA0",.F.) )
	EndIf
	If !lEstorna
		PA0->PA0_QTDE += nQE
	Else
		PA0->PA0_QTDE -= nQE
	EndIf
	PA0->PA0_USU		:= __cUserID
	PA0->PA0_DTSEP  	:= dDataBase
	PA0->PA0_HRSEP  	:= Time()
	If PA0->PA0_QTDE <= 0
		PA0->( dbDelete() )
	EndIf
	PA0->( MsUnLock() )

	//cCodEmbOld := cCodEmb
	//cCodEmb := Space(3)
	//oCodEmb:Refresh()

	If ! lReplVol
		MontaaLbx(cVolume,oLbx,aLbx)
		oEtiqueta:cText := Space(48)
	EndIf
	FimProcEmb()

Return .F.

/*
Status
"0" - "Nao iniciado"
"1" - "Em separacao"
"2" - "Separacao finalizada"
"3" - "Em processo de embalagem"
"4" - "Embalagem Finalizada"
"5" -	"Nota gerada"
"6" -	"Nota impressa"
"7" -	"Volume impresso"
"8" -	"Em processo de embarque"
"9" -	"Finalizado"
*/

Static Function FimProcEmb(paVolumes)

	Local cOrdSep	:= CB7->CB7_ORDSEP
	Local lFimEmb	:= .T.
	Local nX        := 0
	Local nVldEmb   := 0
	Local lTemSep	:= .F.
	Local lTransfML := .T.
	Default paVolumes := {}        // Valdemir Rabelo 27/10/2021 - Ticket: 20210615010129


	CB8->( dbSeek(xFilial("CB8") + cOrdSep) )
	While CB8->( !Eof() .And. CB8_FILIAL + CB8_ORDSEP == xFilial("CB8") + cOrdSep)
		If !Empty(CB8->CB8_SALDOS)
			lTemSep:= .T.
			lFimEmb:= .F.
			Exit
		EndIf
		If !Empty(CB8->CB8_SALDOE)
			lFimEmb:= .F.
			Exit
		EndIf
		CB8->( dbSkip() )
	EndDo
	// -------- Valida a pesagem se realmente foram todos preenchidos - Valdemir Rabelo 27/10/2021 Ticket: 20210615010129 -------
	nVldEmb := 0
	if (Len(paVolumes) > 0)
		nX      := 0
		For nX := 1 to Len(paVolumes)
			if ValType(paVolumes[nX][8]) == "N"
				if paVolumes[nX][8]==0
					nVldEmb++
				endif
			else
				if Val(paVolumes[nX][8])==0
					nVldEmb++
				endif
			endif
		Next
	endif
	// ----------------------------------------------------------------------------------------------------------------------------//
	//STATUS DA SEPARA«√O: 
	//0=Inicio;1=Separando;2=Sep.Final;3=Embalando;4=Emb.Final;5=Gera Nota;6=Imp.nota;7=Imp.Vol;8=Embarcado;9=Embarque Finalizado 
	//-----------------------------------------------------------------------------------------------------------------------------//    
	//CB7->( Reclock('CB7',.F.) )
	If lFimEmb
		If CB7->CB7_STATUS < "4"
			If	("02" $ CBUltExp(CB7->CB7_TIPEXP))
				CB7->( Reclock('CB7',.F.) )
				CB7->CB7_STATUS := "9"  // embalagem finalizada
				CB7->( MsUnLock() )
			Else
				
				if nVldEmb==0    // Ticket: 20210615010129
					
					CB7->( Reclock('CB7',.F.) )
					CB7->CB7_STATUS := "4"  // embalagem finalizada
					CB7->( MsUnLock() ) 
					
					u_LOGJORPED("CB7","6"," "," ",CB7->CB7_PEDIDO,"","Embalagem",CB7->CB7_ZVALLI)
				endif
			EndIf
				CB7->( Reclock('CB7',.F.) )
				CB7->CB7_XDFEM := Date()
				CB7->CB7_XHFEM := Time()
				CB7->( MsUnLock() ) 
		EndIf
	Else
		If lTemSep
			CB7->( Reclock('CB7',.F.) )
			CB7->CB7_STATUS := "1" //	"1" - "Em separacao"
			CB7->( MsUnLock() ) 
		Else
			CB7->( Reclock('CB7',.F.) )
			CB7->CB7_STATUS := "2" //  "2" - "Separacao finalizada"
			CB7->( MsUnLock() )  
		EndIf
	EndIf
	//CB7->( MsUnLock() )

/*	//INICIO GRAVACAO LOG Z05
	IF CB7->CB7_STATUS == '4' .and. lFimEmb
		u_LOGJORPED("CB7","6"," "," ",CB7->CB7_PEDIDO,"","Embalagem")
	ENDIF
	//FIM GRAVACAO LOG Z05*/


Return lFimEmb

Static Function CfgLocImp(oDescImp)

	Local aParambox	:= {}
	Local aRet		:= {}
	Local cLocImp	:= CB1->CB1_XLOCIM

	aAdd(aParamBox,{1, "Local Impress„o", cLocImp, "!!!!!!", "", "CB5", "", 0, .F.})
	While .T.
		If !ParamBox(aParamBox,"ConfiguraÁ„o",@aRet,,,,,,,,.F.)
			Return .F.
		EndIf
		cLocImp := aRet[1]
		If CB5->( !dbSeek(xFilial("CB5") + cLocImp) )
			MsgAlert("Local de Impress„o Invalido","AtenÁ„o")
			Loop
		EndIf
		Exit
	End
	CB1->( RecLock('CB1',.F.) )
	CB1->CB1_XLOCIM := cLocImp
	CB1->( MsUnlock() )
	oDescImp:cText := CB5->(Alltrim(CB5_MODELO) + ' ' + Alltrim(CB5_DESCRI))

Return .T.

Static Function EtiVol(cOrdSep,cSeq,oDescImp)

	Local cVolume			:= cOrdSep + cSeq
	Local cLocImp			:= CB1->CB1_XLOCIM
	Local cLocOri   		:= ""
	Local aTEmpFil          := Separa(getMV("ST_TEMPFIL",.F.,"11,01"),",")    // Valdemir Rabelo 07/01/2022 - Aruja CD
	Private lTNT          	:= .F.
	Private lBraspress    	:= .F.
	Private _cCodBraspres 	:= Alltrim(GetNewPar("ST_BRACODT","004064")) 	//FR - 22/06/2021 - #20210621010461
	Private _cCodTNT      	:= Alltrim(GetNewPar("ST_TNTCODT","000163"))	//FR - 22/06/2021 - #20210621010461
	Private _cCodTNT      	:= Alltrim(GetNewPar("ST_TNTCODT","000163"))	//FR - 22/06/2021 - #20210621010461
	Private _cCodDHL      := Alltrim(GetNewPar("ST_DHLCODT","004415"))
	Private lDhl    := .F.

	While Empty(cLocImp)
		If !CfgLocImp(oDescImp)
			Return
		EndIf
		cLocImp := CB1->CB1_XLOCIM
	End

	cLocOri := cLocImp

	CB6->( dbSetorder(1) )
	CB6->( dbSeek(xFilial('CB6') + cVolume) )
	If Empty(CB6->CB6_XPESO)
		MsgAlert("Volume em aberto, n„o poder· ser impresso!!!","AtenÁ„o")
		Return
	EndIf

	If Empty(CB6->CB6_XOPERA)
		MsgAlert("Operador n„o cadastrado, n„o poder· ser impresso!!!","AtenÁ„o")
		Return
	EndIf

	If __cUserId $ GetMv("ST_CDUSRS",,'000415/000421/000439/000441')
		Return
	EndIf

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	SC5->( dbSeek(CB6->(CB6_FILIAL + CB6_PEDIDO)) )

	If AllTrim(SC5->C5_TRANSP) == _cCodTNT .And. GetMv("ST_NEWTNT",,.T.) .And. cEmpAnt == aTEmpFil[1] .And. cFilAnt == aTEmpFil[2] 	//FR - 22/06/2021 #20210621010461
		lTNT  := .T.
	Elseif AllTrim(SC5->C5_TRANSP) == _cCodBraspres .And. GetMv("ST_NEWBRA",,.T.) .And. cEmpAnt == aTEmpFil[1] .And. cFilAnt == aTEmpFil[2] 	//FR - 22/06/2021#20210621010461
		lBraspress := .T.
	Elseif AllTrim(SC5->C5_TRANSP)== _cCodDHL .And. GetMv("ST_NEWDHL",,.T.) .And. cEmpAnt==aTEmpFil[1] .And. cFilAnt==aTEmpFil[2] 	//FR - 22/06/2021#20210621010461
		lDhl    := .T.
		Conout("Variavel lDhl habilitada")
	EndIf

	If lTNT .Or. lBraspress .Or. lDhl
		cLocImp := "000013" //Enviar para impressora TNT
	EndIf


	If !CB5SetImp(cLocImp)
		MsgAlert("Local de impress„o " + cLocImp + " n„o cadastrado!!!","AtenÁ„o")
		Return
	EndIf

	If ExistBlock("IMG05")
		conout("chamada do ponto de entrada IMG05")												//Tiago - chamado: 20230607007153 - data: 22/06/2023
		ExecBlock("IMG05",,,{cVolume,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE,cLocOri,cLocImp,nQtdDigit,nQtdTotPed})
	EndIf

	MSCBCLOSEPRINTER()

Return

Static Function EtiVolLot(cOrdSep,cSeq,oDescImp)

	Local aArea			:= GetArea()
	Local cVolume		:= cOrdSep+cSeq
	Local cLocImp		:= CB1->CB1_XLOCIM
	Local _lRetorno 	:= .F. //Validacao da dialog criada oDlg
	Local _nOpca 		:= 0 //Opcao da confirmacao
	Local bOk 			:= {|| _nOpca := 1,_lRetorno := .T.,oDlg:End() } //botao de ok
	Local bCancel 		:= {|| _nOpca := 0,oDlg:End() } //botao de cancelamento
	Local _cArqEmp 		:= "" //Arquivo temporario com as empresas a serem escolhidas
	Local _aStruTrb 	:= {} //estrutura do temporario
	Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
	Local _aEmpMigr 	:= {} //array de retorno com as empresas escolhidas
	Local _aButtons		:= {}
	Local cLocOri   	:= ""
	Local aTEmpFil      := Separa(getMV("ST_TEMPFIL",.F.,"11,01"),",")    // Valdemir Rabelo 07/01/2022 - Aruja CD
	Private cMarca 		:= GetMark() //Variaveis para o MsSelect
	Private lInverte 	:= .F. //Variaveis para o MsSelect
	Private oBrwTrb //objeto do msselect
	Private oDlg
	Private lTNT          := .F.
	Private lBraspress    := .F.
	Private _cCodBraspres := Alltrim(GetNewPar("ST_BRACODT","004064")) 	//FR - 22/06/2021 - #20210621010461
	Private _cCodTNT      := Alltrim(GetNewPar("ST_TNTCODT","000163"))	//FR - 22/06/2021 - #20210621010461
	Private _cCodDHL      := Alltrim(GetNewPar("ST_DHLCODT","004415"))
	Private lDhl    := .F.

	aAdd(_aButtons, {"DBG06",{||GETVOLUM(@cMarca) },"Selecionar faixa de volume" } )

	While Empty(cLocImp)
		If !CfgLocImp(oDescImp)
			Return
		EndIf
		cLocImp := CB1->CB1_XLOCIM
	EndDo

	cLocOri := cLocImp

	dbSelectArea("CB7")
	CB7->( dbSetOrder(1) )
	CB7->( dbSeek(xFilial("CB7") + cOrdSep) )

	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	SC5->( dbSeek(CB7->(CB7_FILIAL + CB7_PEDIDO)) )

	//Define campos do TRB
	aAdd(_aStruTrb,{"PEDIDO" 	,"C",06,0})
	aAdd(_aStruTrb,{"OS" 		,"C",06,0})
	aAdd(_aStruTrb,{"VOLUME" 	,"C",4 ,0})
	aAdd(_aStruTrb,{"OK" 		,"C",02,0})

	//Define campos do msselect
	aAdd(_aBrowse,{"OK" 	  ,,"" })
	aAdd(_aBrowse,{"PEDIDO"  ,,"Pedido" })
	aAdd(_aBrowse,{"OS" 	 ,,"Ordem de separaÁ„o" })
	aAdd(_aBrowse,{"VOLUME" ,,"Volume" })

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf

	_cArqEmp := CriaTrab(_aStruTrb)
	dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

	cQuery := " SELECT CB6_PEDIDO, CB6_XORDSE, CB6_VOLUME "
	cQuery += " FROM " + RetSqlName("CB6") + " CB6 "
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CB6_XORDSE = '" + cOrdSep + "' "
	cQuery += " 	AND CB6_FILIAL = '" + xFilial("CB6") + "' "
	cQuery += " ORDER BY CB6_VOLUME "
	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

	While (cAlias)->( !Eof() )
		RecLock("TRB",.T.)
		TRB->OK 		:= Space(2)
		TRB->PEDIDO 	:= (cAlias)->CB6_PEDIDO
		TRB->OS		 	:= (cAlias)->CB6_XORDSE
		TRB->VOLUME		:= Right((cAlias)->CB6_VOLUME,4)
		MsUnlock()
		(cAlias)->( dbSkip() )
	Enddo

	(cAlias)->( dbCloseArea() )

	@ 001,001 TO 400,700 Dialog oDlg TITLE OemToAnsi("Volumes")
	@ 030,005 SAY OemToAnsi("Defina os volumes que deseja marcar: ")
	oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{040,001,195,350})
	oBrwTrb:oBrowse:lCanAllmark := .T.
	oBrwTrb:oBrowse:bAllMark := {||MarkAll(cMarca,@oBrwTrb,cAlias,oDlg)}
	Eval(oBrwTrb:oBrowse:bGoTop)
	oBrwTrb:oBrowse:Refresh()
	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,@_aButtons)) Centered VALID _lRetorno

	TRB->( dbGotop() )

	If AllTrim(SC5->C5_TRANSP) == _cCodTNT .And. GetMv("ST_NEWTNT",,.T.) .And. cEmpAnt == aTEmpFil[1] .And. cFilAnt == aTEmpFil[2] 	//FR - 22/06/2021 #20210621010461
		lTNT  := .T.
	ElseIf AllTrim(SC5->C5_TRANSP) == _cCodBraspres .And. GetMv("ST_NEWBRA",,.T.) .And. cEmpAnt == aTEmpFil[1] .And. cFilAnt == aTEmpFil[2] 	//FR - 22/06/2021#20210621010461
		lBraspress := .T.
	Elseif AllTrim(SC5->C5_TRANSP)== _cCodDHL .And. GetMv("ST_NEWDHL",,.T.) .And. cEmpAnt==aTEmpFil[1] .And. cFilAnt==aTEmpFil[2] 	//FR - 22/06/2021#20210621010461
		lDhl    := .T.
		Conout("Variavel lDhl habilitada")
	EndIf

	//FR - 22/06/2021 - #20210621010461
	If lTNT .Or. lBraspress .Or. lDhl
		cLocImp := "000013" //Enviar para impressora TNT
	EndIf

	If !CB5SetImp(cLocImp)
		MsgAlert("Local de impress„o " + cLocImp + " n„o cadastrado!!!","AtenÁ„o")
		Return
	EndIf

	If _nOpca == 1
		Do While TRB->( !Eof() )
			If !Empty(TRB->OK)//se usuario marcou o registro
				CB6->( dbSetorder(1) )
				CB6->( dbSeek(xFilial('CB6') + TRB->OS + TRB->VOLUME) )
				If Empty(CB6->CB6_XPESO)
					MsgAlert("Volume: " + TRB->VOLUME + "em aberto, n„o poder· ser impresso!!!","AtenÁ„o")
				Else
					If ExistBlock("IMG05")																						//Tiago - chamado: 20230607007153 - data: 22/06/2023
						ExecBlock("IMG05",,,{TRB->OS + TRB->VOLUME,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE,cLocOri,cLocImp,nQtdDigit,nQtdTotPed})
						MSCBCLOSEPRINTER()
					EndIf
				EndIf
			EndIf
			TRB->( dbSkip() )
		EndDo
	Endif

	//fecha area de trabalho e arquivo tempor·rio criados
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
		fErase(_cArqEmp + OrdBagExt())
	EndIf

	RestArea(aArea)

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥_TemNota	 ∫Autor  ≥Renato	 		 ∫ Data ≥  20/05/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Checar se existe nota gerada para o item da embalagem       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥		                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function _TemNota(_numPed,_numItem,_numOS)

	Local lRet	:= .F.

	dbSelectArea("SC9")
	SC9->( dbSetOrder(1) )	// C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	SC9->( dbSeek(xFilial("SC9") + _numPed + _numItem) )
	While SC9->( !Eof() .And. C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_ORDSEP == xFilial("SC9") + _numPed + _numItem + _numOS)
		If !Empty(SC9->C9_NFISCAL)
			lRet := .T.
		EndIf
		SC9->( dbSkip() )
	EndDo

Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥_TemNota	 ∫Autor  ≥Renato	 		 ∫ Data ≥  20/05/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Checar se existe nota gerada para o item da embalagem       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥		                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function STDUPLIORD(_xOrdSep)

	Local _aAreacb8 := CB8->( GetArea() )
	Local lRet	    := .F.
	Local cQuery    := ' '
	Local cTime     := Time()
	Local cHora     := Substr(cTime, 1, 2)
	Local cMinutos  := Substr(cTime, 4, 2)
	Local cSegundos := Substr(cTime, 7, 2)
	Local cAliasLif := 'TMPCB8' + cHora + cMinutos + cSegundos

	cQuery := " SELECT *
	cQuery += " FROM " + RetSqlName("CB8") + " CB8 "
	cQuery += " INNER JOIN( SELECT * FROM " + RetSqlName("CB8") + " ) TB8 "
	cQuery += " 	ON TB8.CB8_ORDSEP = CB8.CB8_ORDSEP
	cQuery += " 	AND TB8.D_E_L_E_T_ = ' '
	cQuery += " 	AND TB8.CB8_PROD = CB8.CB8_PROD
	cQuery += " 	AND TB8.CB8_ITEM <> CB8.CB8_ITEM
	cQuery += " 	AND TB8.CB8_FILIAL= '" + xFilial("CB8") + "' "
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB8.CB8_ORDSEP = '" + _xOrdSep + "' "
	cQuery += " 	AND CB8.CB8_FILIAL= '" + xFilial("CB8") + "' "
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	dbSelectArea(cAliasLif)
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbgotop() )
		While (cAliasLif)->( !Eof() )
			lRet := .T.
			(cAliasLif)->( dbSkip() )
		EndDo
	EndIf

	RestArea(_aAreacb8)

Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  STORDDUPLGrv	 ∫Autor  ≥Renato	 	 ∫ Data ≥  20/05/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Checar se existe nota gerada para o item da embalagem       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥		                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function STORDDUPLGrv(aDocs,aRecCB9,cVolume,cPedido,cOrdSep)

	Local nX 		:= 0
	Local nSaldoEmb	:= 0
	Local lDelCB9	:= .F.
	Local lAchouCB9	:= .F.

	For nX:= 1 to len(aDocs)
		If ! aDocs[nX,1]
			Loop
		EndIf
		lDelCB9		:= .T.
		lAchouCB9	:= .F.
		CB9->( dbSetorder(8) )
		CB9->( dbGoTo(aRecCB9[nX]) )
		CB8->( dbSetOrder(4) )
		CB8->( dbSeek(xFilial("CB8") + CB9->(CB9_ORDSEP + CB9_ITESEP + CB9_PROD + CB9_LOCAL + CB9_LCALIZ + CB9_LOTSUG + CB9_SLOTSU + CB9_NUMSER)) )
		nSaldoEmb := CB9->CB9_QTEEMB
		If CB9->( dbSeek(CB9->CB9_FILIAL + CB9->CB9_ORDSEP + CB9->CB9_PROD + Space(10) + Space(6) + Space(20) + Space(10) + CB9->CB9_ITESEP) )
			CB9->( RecLock("CB9",.F.) )
			CB9->CB9_QTESEP += nSaldoEmb
			CB9->( MsUnlock() )
			lAchouCB9 := .T.
		EndIf
		CB9->( dbGoTo(aRecCB9[nX]) )
		CB9->( RecLock("CB9",.F.) )
		If lAchouCB9
			CB9->( dbDelete() )
		Else
			CB9->CB9_VOLUME := ""
			CB9->CB9_QTEEMB := 0
			CB9->CB9_CODEMB := ""
			CB9->CB9_LOTECT := ""
			CB9->CB9_STATUS := "1"  // Em Aberto
		EndIf
		CB9->( MsUnlock() )
		CB8->( RecLock("CB8",.F.) )
		CB8->CB8_SALDOE += nSaldoEmb
		CB8->( MsUnlock() )
	Next

	If lDelCB9
		CB6->( dbSetorder(1) )
		CB9->( dbSetorder(4) )
		If CB9->( !dbSeek(xFilial("CB9") + cVolume) )
			If CB6->( DbSeek(xFilial("CB6") + cVolume) )
				CB6->( RecLock("CB6",.F.) )
				CB6->( dbDelete() )
				CB6->( MsUnlock() )
			EndIf
		EndIf
		CB7->( dbSetorder(1) )
		If CB7->( dbSeek(xFilial("CB7") + cOrdSep) )
			CB6->( dbOrderNickName("STFSCB601") )    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
			CB7->( Reclock('CB7',.F.) )
			If CB6->( !dbSeek(xFilial('CB6') + cOrdSep) )
				CB7->CB7_STATUS := "2"  // Sep.Final
			Else
				CB7->CB7_STATUS := "3"  // Embalando
			EndIf
			CB7->( MsUnLock() )
		EndIf
		MsgInfo("Itens excluÌdos com sucesso.","OK")
	EndIf

Return

/*====================================================================================\
|Programa  | STEMB30             | Autor | GIOVANI.ZAGO          | Data | 30/07/2014  |
|=====================================================================================|
|DescriÁ„o |  Retorna volume			                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEMB30                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistÛrico....................................|
\====================================================================================*/

Static Function STEMB30(_cVol)

	Local _nRet30    := 0
	Local _aArea     := GetArea()
	Local cAliasLif  := 'TMPB30VOL'
	Local cQuery     := ' '

	cQuery := " SELECT
	cQuery += " SUM(CB9.CB9_QTEEMB)
	cQuery += ' AS "CB9_QTEEMB"
	cQuery += " FROM " + RetSqlName("CB9") + " CB9 "
	cQuery += " WHERE CB9.D_E_L_E_T_ = ' '
	cQuery += " 	AND CB9.CB9_VOLUME = '" + _cVol + "' "
	cQuery += " 	AND CB9.CB9_FILIAL = '" + xFilial("CB9") + "' "
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->( dbgotop() )
		While (cAliasLif)->( !Eof() )
			_nRet30 += (cAliasLif)->CB9_QTEEMB
			(cAliasLif)->( dbSkip() )
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf

	RestArea(_aArea)

Return _nRet30


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥STAVALET	∫Autor  ≥Renato Nogueira     ∫ Data ≥  01/12/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina para ajustar padr„o de etiqueta					  ∫±±
±±∫          ≥	    							 	 				      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametro ≥ cEtiqueta                                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Retorno   ≥ cEtiqueta                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function STAVALET(_cEtiqueta,pcEmbal)

	Local _cEan, _nQtde, _cOrdem
	Local _aAreaSB1	:= SB1->( GetArea() )
	Local _cNewEtiq	:= ""
	Local cLote		:= Space(10)
	Local aSave
	Local clinha	:= ""
	Local npos		:= 0
	Local _nCount	:= 0
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _X        := 0
	Local aResult   := {}    // Valdemir Rabelo MigraÁ„o
	Default pcEmbal := ""

	if (type('_lCB8')=="U")
	   Private _lCB8 := .F.
	endif 

	if (cEmpAnt <> '11')

		If SubStr(AllTrim(_cEtiqueta),1,2) == "02" .And. SubStr(AllTrim(_cEtiqueta),17,2) == "37" .And. SubStr(AllTrim(_cEtiqueta),26,2) == "10" //Etiqueta colÙmbia
			_cEan	:= cValtoChar(Val(SubStr(AllTrim(_cEtiqueta),3,14)))
			_nQtde	:= Val(SubStr(AllTrim(_cEtiqueta),19,7))
			_cOrdem	:= SubStr(AllTrim(_cEtiqueta),28,10)
			dbSelectArea("SB1")
			SB1->( dbSetOrder(5) )	// B1_FILIAL + B1_CODBAR
			SB1->( dbGoTop() )
			If SB1->( dbSeek(xFilial("SB1") + _cEan) )
				_cNewEtiq	+= AllTrim(SB1->B1_COD) + "|"
				_cNewEtiq	+= _cOrdem + "|"
				_cNewEtiq	+= cValtoChar(_nQtde)
			Else
				ApMsgAlert("AtenÁ„o, codigo nao encontrado atraves do EAN13, verifique!")
				Return
			EndIf
		EndIf

		If Len(AllTrim(_cEtiqueta)) == 14	// Etiqueta SE
			_cAlias1  := GetNextAlias()
			_cQuery1 := " SELECT B1_COD
			_cQuery1 += " FROM " + RetSqlName("SB1") + " B1
			_cQuery1 += " WHERE B1.D_E_L_E_T_ = ' ' AND B1_XEAN14 = '" + AllTrim(_cEtiqueta) + "' AND B1_XCODSE = 'S'
			If !Empty(Select(_cAlias1))
				dbSelectArea(_cAlias1)
				(_cAlias1)->( dbCloseArea() )
			EndIf
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
			dbSelectArea(_cAlias1)
			(_cAlias1)->( dbGoTop() )
			If (_cAlias1)->( !Eof() )
				_cNewEtiq	:= AllTrim((_cAlias1)->B1_COD) + "|"
				_cNewEtiq	+= "Z" + "|"
				_cNewEtiq	+= cValtoChar(0)
				Return _cNewEtiq
			EndIf
		EndIf

		If IsTelNet() //Chamado 002854
			clinha := _cEtiqueta
			While (npos := At("|",clinha) ) > 0
				_nCount++
				clinha:= Substr(clinha,npos+1,Len(clinha))
			End
			If _nCount <= 1
				dbSelectArea("SB1")
				SB1->( dbSetOrder(1) )
				SB1->( dbGoTop() )
				If SB1->( dbSeek(xFilial("SB1") + StrTran(AllTrim(_cEtiqueta),"|","")) )
					_cNewEtiq	+= AllTrim(SB1->B1_COD) + "|"
					_cNewEtiq	+= cLote + "|"
					_cNewEtiq	+= CValtoChar(0)
				EndIf
			EndIf
		EndIf

		If Empty(_cNewEtiq)
			_cNewEtiq := _cEtiqueta
		EndIf

	Else 
	  // Valdemir Rabelo 08/01/2022
	  if (Right(alltrim(_cEtiqueta),1)=="|")
	    _cEtiqueta := Substr(_cEtiqueta,1,Len(alltrim(_cEtiqueta))-1)
	  else 
	      _cEtiqueta := alltrim(_cEtiqueta)
	  endif 
	  if Len(alltrim(_cEtiqueta) ) = 14
		cEtiqNew := Alltrim(Substr(_cEtiqueta,2,Len(_cEtiqueta)-2))
		cDigV := EanDigito(cEtiqNew)
		cEtiqNew := cEtiqNew + cDigV
		aResult :=  LocCodBar(cEtiqNew, .F.,_cEtiqueta)
	  elseif Len(_cEtiqueta) < 14
		aResult :=  LocCodBar(alltrim(_cEtiqueta), .F.,alltrim(_cEtiqueta))
	  Endif 

	  if !Empty(aResult) 
	        if (pcEmbal=="E")
			   _nQtde := aResult[3]
			else 
				if !_lCB8
					_nQtde      := 0
				else 
					_nQtde      := CB8->CB8_QTDORI
				endif
			endif  
			_cNewEtiq	:= AllTrim(aResult[1]) + "|"
			_cNewEtiq	+= "Z" + "|"
			_cNewEtiq	+= cValtoChar(_nQtde)
			cFilas := _cNewEtiq
			Return _cNewEtiq
	  endif 

	  If Empty(alltrim(_cNewEtiq))
	    if pcEmbal <> "E"
			if (At("=",_cEtiqueta) > 0) .or. (At("|",_cEtiqueta) > 0) .or. (At(":",_cEtiqueta) > 0)
				if !_lCB8    // Valdemir Rabelo 07/01/2022 - CD Aruja - Necess·rio criar como private no fonte origem
					_nQtde      := 0
				else 
					_nQtde      := CB8->CB8_QTDORI
				endif 
				_X   := 0
				For _X := Len(alltrim(_cEtiqueta)) to 1 step-1
					if Substr(alltrim(_cEtiqueta),_X,1) $ "=/|/:"
						Exit 
					endif 
				next 
					
				cTMP := Alltrim(Left(alltrim(_cEtiqueta), _X))+CValtoChar(_nQtde)
				_cNewEtiq := cTMP
				Return _cNewEtiq
			endif 
		endif 
		_cNewEtiq := _cEtiqueta
	  EndIf

    Endif 

	RestArea(_aAreaSB1)

Return _cNewEtiq






/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥STAVALET	∫Autor  ≥Renato Nogueira     ∫ Data ≥  01/12/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina para ajustar padr„o de etiqueta					  ∫±±
±±∫          ≥	    							 	 				      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametro ≥ cEtiqueta                                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Retorno   ≥ cEtiqueta                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
/*      Removido para realizar nova rotina conforme solicitaÁ„o do Renato por causa de Guararema 08/01/2022
User Function STAVALET(_cEtiqueta)

	Local _cEan, _nQtde, _cOrdem
	Local _aAreaSB1	:= SB1->( GetArea() )
	Local _cNewEtiq	:= ""
	Local cLote		:= Space(10)
	Local aSave
	Local clinha	:= ""
	Local aResult   := {}
	Local npos		:= 0
	Local _X        := 0
	Local _nCount	:= 0
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	if (type('_lCB8')=="U")
	   Private _lCB8 := .F.
	endif 

	// ValidaÁ„o cÛdigo 128
	If SubStr(AllTrim(_cEtiqueta),1,2) == "02" .And. SubStr(AllTrim(_cEtiqueta),17,2) == "37" .And. SubStr(AllTrim(_cEtiqueta),26,2) == "10" //Etiqueta colÙmbia
		_cEan	:= cValtoChar(Val(SubStr(AllTrim(_cEtiqueta),3,14)))
		_nQtde	:= Val(SubStr(AllTrim(_cEtiqueta),19,7))
		_cOrdem	:= SubStr(AllTrim(_cEtiqueta),28,10)
		dbSelectArea("SB1")
		SB1->( dbSetOrder(5) )	// B1_FILIAL + B1_CODBAR
		SB1->( dbGoTop() )
		If SB1->( dbSeek(xFilial("SB1") + _cEan) )
			_cNewEtiq	+= AllTrim(SB1->B1_COD) + "|"
			_cNewEtiq	+= _cOrdem + "|"
			if !_lCB8             // Valdemir Rabelo 07/01/2022 - Pegar Qtde. conforme CB8 na separaÁ„o
			_cNewEtiq	+= cValtoChar(_nQtde)
			else 
				_cNewEtiq      := CB8->CB8_QTDORI
			endif 			
		Else
			ApMsgAlert("AtenÁ„o, codigo nao encontrado atraves do EAN13, verifique!")
			Return
		EndIf
	EndIf
	cTMP := _cEtiqueta
	if (Right(_cEtiqueta,1)=="|")
	   cTMP := Left(AllTrim(_cEtiqueta), iif(Right(_cEtiqueta,1)=="|", Len(_cEtiqueta)-1, AllTrim(_cEtiqueta))   )
	endif 
	
	If Len(AllTrim(cTMP)) <= 14	// Etiqueta SE
	    if Right(_cEtiqueta,1)=="|"
		   clinha := Left(_cEtiqueta, Len(_cEtiqueta)-1)
		else 
		   clinha := _cEtiqueta
		endif 
		While (npos := At("|",clinha) ) > 0
			_nCount++
			clinha := Substr(clinha,npos+1,Len(clinha))
		End
	    _nQtde	:= Val(clinha)
		aResult :=  LocCodBar(StrTran(AllTrim(_cEtiqueta),"|",""), .T.)

		if !Empty(aResult) 
		   if !_lCB8
		      _nQtde      := 0
		   else 
		      _nQtde      := CB8->CB8_QTDORI
		   endif 
			_cNewEtiq	:= AllTrim(aResult[1]) + "|"
			_cNewEtiq	+= "Z" + "|"
			_cNewEtiq	+= cValtoChar(_nQtde)
			cFilas := _cNewEtiq
			Return _cNewEtiq
		endif 
	EndIf

	If IsTelNet() //Chamado 002854
	    if Right(_cEtiqueta,1)=="|"
		   clinha := Left(_cEtiqueta, Len(_cEtiqueta)-1)
		else 
		   clinha := _cEtiqueta
		endif 
		//clinha := _cEtiqueta
		While (npos := At("|",clinha) ) > 0
			_nCount++
			clinha:= Substr(clinha,npos+1,Len(clinha))
		End

		If _nCount <= 1
			dbSelectArea("SB1")
			SB1->( dbSetOrder(1) )
			aResult :=  LocCodBar(StrTran(AllTrim(_cEtiqueta),"|",""), .F.)

			If !Empty(aResult)
			    SB1->( DBGOTO(aResult[4]) )
				_cNewEtiq	+= AllTrim(aResult[1]) + "|"
				_cNewEtiq	+= cLote + "|"
				//_nQtde	    := aResult[3]
				if !_lCB8    // Valdemir Rabelo 07/01/2022 - CD Aruja - Necess·rio criar como private no fonte origem
					_nQtde      := 0
				else 
					_nQtde      := CB8->CB8_QTDORI
				endif 
				_cNewEtiq	+= CValtoChar(_nQtde)
			ELSE 
			  if len(alltrim(_cEtiqueta)) <= 14
			     VTALERT("Cod.Barra nao encontrado")
				 Return ""
			  endif 
			EndIf
		EndIf
	EndIf

	If Empty(alltrim(_cNewEtiq))
	   if (At("=",_cEtiqueta) > 0) .or. (At("|",_cEtiqueta) > 0) .or. (At(":",_cEtiqueta) > 0)
			if !_lCB8    // Valdemir Rabelo 07/01/2022 - CD Aruja - Necess·rio criar como private no fonte origem
				_nQtde      := 0
			else 
				_nQtde      := CB8->CB8_QTDORI
			endif 
			_X   := 0
			For _X := Len(alltrim(_cEtiqueta)) to 1 step-1
			   if Substr(alltrim(_cEtiqueta),_X,1)=="="
			      Exit 
			   endif 
			next 
			
	      cTMP := Alltrim(Left(alltrim(_cEtiqueta), _X))+CValtoChar(_nQtde)
		  _cNewEtiq := cTMP
		  Return _cNewEtiq
	   endif 
		_cNewEtiq := _cEtiqueta
	EndIf

	RestArea(_aAreaSB1)

Return _cNewEtiq
*/


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ≥STCHKCB8	∫Autor  ≥Renato Nogueira     ∫ Data ≥  01/12/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina ajustar saldo quando existem dois produtos 		  ∫±±
±±∫          ≥	    							 	 				      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametro ≥ cEtiqueta                                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Retorno   ≥ cEtiqueta                                                  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function STCHKCB8(_cOrdSep)

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	:= " SELECT FILIAL, ORDSEP, TOTALOS, TOTALCB8EMB "
	cQuery1	+= " ,(SELECT SUM(CB9_QTEEMB) FROM " + RetSqlName("CB9") + " B9 WHERE B9.D_E_L_E_T_ = ' ' "
	cQuery1	+= " AND CB9_FILIAL = FILIAL AND CB9_ORDSEP = ORDSEP) TOTALCB9EMB "
	cQuery1	+= " FROM ( "
	cQuery1	+= " SELECT CB8_FILIAL FILIAL, CB8_ORDSEP ORDSEP, SUM(CB8_QTDORI) TOTALOS, SUM(CB8_SALDOE) TOTALCB8EMB "
	cQuery1	+= " FROM " + RetSqlName("CB8") + " B8 "
	cQuery1	+= " WHERE B8.D_E_L_E_T_ = ' ' AND CB8_FILIAL = '" + cFilAnt + "' AND CB8_ORDSEP = '" + _cOrdSep + "' "
	cQuery1	+= " GROUP BY CB8_FILIAL, CB8_ORDSEP ) "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )
	If (cAlias1)->TOTALOS == (cAlias1)->TOTALCB9EMB
		cQuery1 := " UPDATE " + RetSqlName("CB8") + " CB8 "
		cQuery1 += " SET CB8_SALDOE = 0 "
		cQuery1 += " WHERE CB8.D_E_L_E_T_ = ' ' "
		cQuery1 += " 	AND CB8_FILIAL = '" + cFilAnt + "' "
		cQuery1 += " 	AND CB8_ORDSEP = '" + _cOrdSep + "' "
		nErrQry := TCSqlExec( cQuery1 )
		If nErrQry <> 0
			Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATEN«√O')
		EndIf
	EndIf

Return

Static Function ReplVol(lInclui,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,lReplVol,oLbxItem,aVolItem)

	Local aParambox		:= {}
	Local aRet			:= {}
	Local nRepl			:= 0
	Local aCB8Sdo		:= {}
	Local nSldCB8		:= 0
	Local nQtdRepl		:= 0
	Local nItem			:= 0
	Private lAborRepl	:= .F.

	nVolRepl	:= 0

	aAdd(aParamBox,{1,"Qtde Volumes deseja replicar",nVolRepl,"999999", '!Empty(mv_par01)', "", "" , 0  , .F. })
	Do While .T.
		If !ParamBox(aParamBox,"Replicar Volumes",@aRet,,,,,,,,.F.)
			Return(0)
		EndIf
		nVolRepl := aRet[1]
		If !MsgYesNo("Confirma a replicaÁ„o de " + Alltrim(Str(nVolRepl)) + " Volume(s) ?")
			Return(0)
		EndIf
		Exit
	EndDo

	If nVolRepl > 0
		// Adicionado o tratamento para ajuste do Ticket 20210323004713 - CorreÁ„o Replicar volume -- Eduardo Pereira - Sigamat
		CB8->( dbSetOrder(1) )
		CB8->( dBSeek(xFilial("CB8") + cOrdSep) )
		While CB8->( !Eof() .And. CB8_FILIAL + CB8_ORDSEP == xFilial("CB8") + cOrdSep)
			If CB8->CB8_SALDOE > 0
				nPosCB8 := aScan(aCB8Sdo,{|x|x[1] = CB8->CB8_PROD})
				If Empty(nPosCB8)
					aAdd(aCB8Sdo,{CB8->CB8_PROD,0})
					nPosCB8 := Len(aCB8Sdo)
				EndIf
				aCB8Sdo[nPosCB8,2] += CB8->CB8_SALDOE
				nSldCB8	+= aCB8Sdo[nPosCB8,2]
			EndIf
			CB8->( dbSkip() )
		EndDo
		For nItem := 1 to Len(aVolItem)
			nQtdRepl := Val(aVolItem[nItem,3]) * nVolRepl
			nPosCB8 := aScan(aCB8Sdo,{|x| x[1] = aVolItem[nItem,1]})
			If nPosCB8 > 0
				If aCB8Sdo[nPosCB8,2] < nQtdRepl
					lAborRepl := .T.
					nLimVol := Int(aCB8Sdo[nPosCB8,2] / Val(aVolItem[nItem,3]))
					MsgAlert("Produto " + aVolItem[nItem,1] + " n„o possui saldo suficiente para embalar" + CRLF + "O limite para replicar s„o " + AllTrim(Str(nLimVol)) + " volumes.","AtenÁ„o")
					Setkey(VK_F5,{|| ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
					Return .T.
				EndIf
			EndIf
		Next nItem
		// Finalizado o tratamento para ajuste do Ticket 20210323004713 - CorreÁ„o Replicar volume -- Eduardo Pereira - Sigamat
		For nRepl := 1 to nVolRepl
			ManuVol(.T.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.T.,oLbxItem,aVolItem)
			If lAborRepl
				Exit
			EndIf
		Next nRepl
	EndIf

Return

/*/Protheus.doc GETVOLUM
@name GETVOLUM
@desc retornar faixa de volumes
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GETVOLUM(_cMarcou)

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _aAreaTRB		:= TRB->( GetArea() )

	aAdd(_aParamBox,{1,"Volume de:",Space(4),"","","","",0,.F.})
	aAdd(_aParamBox,{1,"Volume ate:",Space(4),"","","","",0,.F.})
	If ParamBox(_aParamBox,"SeleÁ„o de volumes",@_aRet,,,.T.,,500)
		TRB->( dbGoTop() )
		While TRB->( !Eof() )
			If AllTrim(TRB->VOLUME) >= AllTrim(MV_PAR01) .And. AllTrim(TRB->VOLUME) <= MV_PAR02
				TRB->( RecLock("TRB",.F.) )
				TRB->OK := _cMarcou
				TRB->( MsUnLock() )
			EndIf
			TRB->( dbSkip() )
		EndDo
	EndIf

	RestArea(_aAreaTRB)

Return

/*/Protheus.doc EtiqDese
description
  Rotina para impress„o de Etiqueta de desenho (Ticket: 20200922007743)
@type function
@version 12.1.25
@author Valdemir Jose
@since 10/11/2020
/*/

Static Function EtiqDese()

	Local _aPara     := {}
	Local _aRET      := {}
	Local nQtde      := 1
	Local nX         := 0
	Local nDese      := "Lampada"
	Private aDesenho := {"Lampada", "Fragil", "Fechadura","Retrabalho"}

	aAdd(_aPara,{2,"Desenho"      ,nDese, aDesenho, 50, '.T.', .T.})  
	aAdd(_aPara,{1,"Qtde.Etiqueta",nQtde,"@E 999","","","", 0, .T.})

	If !ParamBox(_aPara,"Etiqueta Desenho",@_aRet)
	   Return
	Endif 

	MV_PAR01 := _aRET[1]
	MV_PAR02 := _aRET[2]

	For nX := 1 to MV_PAR02
		FwMsgRun(,{|| Ietiqdes()},"Aguarde","Montando Etiqueta para impress„o")
	Next 

Return

/*/Protheus.doc Ietiqdes
description
Rotina de Impress„o da Etiqueta (Ticket: 20200922007743)
@type function
@version 12.1.25
@author Valdemir Jose
@since 10/11/2020
/*/

Static Function Ietiqdes()

	Local oPrinter := u_ConfEtiq( 'IETIQDES' )          // Configura impress„o
	Local cDesenho := "\system\" + MV_PAR01 + ".bmp"
	Local nCol     := 0
	Local nLin     := 0

	If !File(MV_PAR01 + ".bmp")
       FWMsgRun(,{|| Sleep(4000)},"AtenÁ„o!","Desenho n„o encontrado na pasta. Por favor, verique com TI")
	   oPrinter := Nil 
	   Return
	EndIf 

    oPrinter:StartPage()
	oPrinter:SayBitmap(02+nLin ,10+nCol, cDesenho, 290, 170 ) 
	oPrinter:EndPage()
    oPrinter:Preview()

	FreeObj(oPrinter)
	oPrinter := Nil

Return 




/*/{Protheus.doc} FindCBar
description
Ticket: 20220105000248
@type function
@version  
@author Valdemir Jose
@since 05/01/2022
@param pcAlias1, variant, param_description
@param pEtiqueta, variant, param_description
@return variant, return_description
/*/
Static Function FindCBar(pEtiqueta, plSchn, pOriginal)
	Local tFIND := GetNextAlias()
	Local cQry  := ""	
	Local cCPO  := ""
	Local nQtde := 0
	Local nX    := 0
	Local aRET  := {}
	Default plSchn := .F.

	 dbSelectArea("SB1")

   cCPO := "A.B1_COD CODIGO, A.B1_CODBAR CODBAR "

	if Select(tFIND) > 0
	   (tFIND)->( dbCloseArea() )
	endif 

	cQry := "SELECT " + CRLF
   	cQry += cCPO + ", A.R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RetSqlName('SB1') + " A        " + CRLF
	cQry += "WHERE a.d_e_l_e_t_ = ' ' " + CRLF
	
	if plSchn
	  cQry += "  AND B1_XCODSE = 'S' " + CRLF
    endif

    //cQry += " AND (A.B1_CODBAR ='"+pEtiqueta+"' OR A.B1_XEAN14='"+pEtiqueta+"' )" + CRLF
	if Len(pEtiqueta) == 12
	   nX := Len(pEtiqueta)
	   cQry += " AND (Substr(A.B1_CODBAR,1,"+cValtoChar(nX)+") ='"+pEtiqueta+"')" + CRLF
	else 
	   cQry += " AND (A.B1_CODBAR ='"+pEtiqueta+"')" + CRLF
	endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),tFIND,.T.,.T.)

	nQtde := 1
	IF (tFIND)->( !Eof() )	
	   SB1->( dbGoto((tFIND)->REG) )
	   if Len(pOriginal) >= 14
			if Left(pOriginal,1)=='1'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN141")
			elseif Left(pOriginal,1)=='2'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN142")
			elseif Left(pOriginal,1)=='3'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN143")
			elseif Left(pOriginal,1)=='4'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN144")
			elseif Left(pOriginal,1)=='5'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN145")
			elseif Left(pOriginal,1)=='6'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN146")
			elseif Left(pOriginal,1)=='7'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN147")
			elseif Left(pOriginal,1)=='8'
				nQtde := POSICIONE("SB5",1,XFILIAL("SB5")+SB1->B1_COD,"B5_EAN148")
			endif 
		Endif 			  
	   aRET := {(tFIND)->CODIGO, (tFIND)->CODBAR, nQtde, (tFIND)->REG}
	Endif 

	(tFIND)->( dbCloseArea() )

Return aRET 


/*/{Protheus.doc} LocCodBar
description
@type function
@version  
@author Valdemir Jose
@since 06/01/2022
@param pEtiqueta, variant, param_description
@param plSchn, variant, param_description
@return variant, return_description
/*/
Static Function LocCodBar(pEtiqueta, plSchn,pOriginal)
	Local aRET := {}

	aRET := FindCBar(pEtiqueta, plSchn, pOriginal)

Return aRET 



/*/{Protheus.doc} LocCodBar
description
@type function
@version  
@author Antonio Cordeiro 
@since 28/07/2023
@param cfil,cOrdSep,cVolume,cLoteCT,cProd,cFlag
@return aRecno array 
/*/

Static Function UltimoVol(cFil1,cOrdSep,cVolume,cLoteCT,cProd,cFlag)

Local cAlias :=""
Local aArea  :=GetArea()
Local aRecno :={}
cAlias := GetNextAlias()

cQuery := " SELECT R_E_C_N_O_ RECNO  "
cQuery += " FROM "+RetSqlName("CB9")+ " CB9 "
cQuery += " WHERE CB9.CB9_FILIAL = '"+cFil1+"' "
cQuery += "   AND CB9.CB9_ORDSEP = '"+cOrdSep+"' "
cQuery += "   AND CB9.CB9_XULTVO = '"+cFlag+"' "
IF ! EMPTY(cVolume) 
   cQuery += "   AND CB9.CB9_VOLUME = '"+cVolume+"' "
ENDIF
IF ! EMPTY(cLoteCT) 
   cQuery += "   AND CB9.CB9_LOTECT = '"+cLoteCt+"' "
ENDIF
IF ! EMPTY(cProd) 
   cQuery += "   AND CB9.CB9_PROD = '"+cProd+"' "
ENDIF
cQuery += "   AND CB9.D_E_L_E_T_ = ' ' "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())
While (cAlias)->( ! Eof())
   AADD(aRecno,(cAlias)->RECNO)
   (cAlias)->(DBSKIP())
ENDDO   

(cAlias)->( DbcloseArea())

RestArea(aArea)

Return(aRecno)


/////GERA WF - funÁ„o para teste para n„o ter q lanÁar a embalagem de novo - //FR - Fl·via Rocha - Sigamat Consultoria
Static Function ManuVol1(lInclui,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,lReplVol,oLbxItem,aVolItem)

	Local cArML         := "06"  //ARMAZ…M PARA TRANSFER NCIA MERCADO LIVRE
	Local cEndML        := "MELI"  //ENDERE«O PARA TRANSFER NCIA MERCADO LIVRE
		
	CB7->( dbSetOrder(1) )
	CB7->( dbGotop() )
	If CB7->( dbSeek(xFilial('CB7') + cOrdSep) )
		Processa( {|| FRWF(CB7->CB7_ORDSEP,CB7->CB7_PEDIDO,cArML,cEndML,CB7->CB7_CODOPE,.T.)}, "Aguarde...", "GERANDO WF", .T. )
	Endif 

Return 

Static Function FRWF(cOrdSep,cPEDIDO,cArML,cEndML,cCODOPE,lTrue)
Local _cEmail := ""
Local _cCopia := ""
Local _cAssunto:= ""
Local cMsg     := ""
Local _aAttach := {}
Local _cCaminho:= ""
Local aDados   := {}
			
CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
CB9->(DbSeek(xFilial("CB9")+ cOrdSep))
While CB9->(!Eof() .and. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+ cOrdSep)

	If CB9->CB9_STATUS == "2" //STATUS = "2" -> EMBALAGEM FINALIZADA
						
		CB9->(Aadd(aDados,{;
				CB9_PROD ,;		//1-PRODUTO
				CB9_QTESEP,;	//2-QUANTIDADE
				CB9_LOCAL,;	//3-LOCAL ORIGEM
				cArML,;		//4-LOCAL DESTINO
				CB9_LCALIZ,;	//5-ENDERE«O
				CB9_LOTSUG,;	//6-LOTE
				CB9_SLOTSU,;	//7-SUBLOTE
				""     ,;		//8-D4_TRT
				""      ,;		//9-D4_OPORIG
				CB9_PEDIDO,;	//10-PEDIDO
				CB9_VOLUME;	//11-NRO. VOLUME
				}))
	Endif
	CB9->(DbSkip())
End
 
If Len(aDados) > 0
	//_cEmail   := "kleber.braga@steck.com.br;diogo.fausto@steck.com.br"
	//_cEmail   += ";flah.rocha@sigamat.com.br;flah.rocha@gmail.com;flavia.rocha76@outlook.com" //FR TESTE
	_cEmail   := GetNewPar("ST_WFMELI" , "diogo.fausto@steck.com.br;ana.rodrigues@steck.com.br;kleber.braga@steck.com.br;alan.santos@steck.com.br;guilherme.fernandez@steck.com.br")
	_cCopia   := "flah.rocha@sigamat.com.br;flavia.rocha76@outlook.com"  
	//_cCopia   := "" 
	_cAssunto := "TRANSFER NCIA DE MATERIAIS P/ MERCADO LIVRE"
	_cAssunto += " - TESTE BASE D02 " 
			
	cMsg      := "Os Seguintes Itens Foram Transferidos do ArmazÈm: " + aDados[1,3] + " Para: " + cArML + CRLF + CRLF

	//MONTA CORPO DA MENSAGEM: 
	U_STMONTAMAIL(@cMsg,aDados,cOrdSep)

	_aAttach  := {} 
	_cCaminho = ""
			
	lEnviou := U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
EndIf

Return
