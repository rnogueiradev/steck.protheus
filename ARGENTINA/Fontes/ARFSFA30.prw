#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "Rwmake.ch"
#include "APVT100.CH"

/*====================================================================================\
|Programa  | ARFSFA30        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descri็ใo | ROTINA PARA REALIZAR EMBALAGEM			                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function ARFSFA30(_cOrdSep1,_cPedido1)

	Local lTelaPri := .F.

	Embalagem(lTelaPri,_cOrdSep1,_cPedido1)

Return

/*====================================================================================\
|Programa  | Embalagem       | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descri็ใo |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

Static Function Embalagem(lTelaPri,_cOrdSep1,_cPedido1)

	Local aArea    := GetArea()
	Local oDlg
	Local aButtons	:= {}

	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4
	Local oSplit

	Local oPedido
	Local cPedido	:= Space(6)
	Local oOrdSep
	Local cOrdSep  := Space(6)
	Local oStatus
	Local cStatus	:= Space(20)
	Local oCliente
	Local cCliente := Space(10)
	Local oDesCli
	Local cDesCli	:= Space(40)
	Local cCodOpe	:= CbRetOpe()

	Local aCabVol :={" ","Seq.","Tipo Emb","Larg","Altur","Profun","Regiao","Peso Volume","Qtde Itens","Operador","Abertura","Ult.Ocorrencia", ""} //Adic. Larg Alt Prof Regiao
	Local oLbxVol
	Local aVolumes:={}

	Local aCabItem :={"Produto","Descri็ใo","Quantidade","Lote",""}
	Local oLbxItem
	Local aVolItem:={}

	Local oTotVol
	Local nTotVol	:=	0
	Local oNomeSep
	Local _cNomeSep := ""
	Local oCubag
	Local _nCubTot	:= 0
	Local oTotPeso
	Local nTotPeso	:=	0
	Local oEmb		:= LoadBitmap( GetResources(), "BR_PRETO" 	)
	Local cDescImp := "Impressora nใo configurada"
	Local oDescImp
	Local aSize    	 := MsAdvSize(.F.)//Giovani Zago - TOTVS 121c/12/12
	Local cMV_XEXCEMB	:= SuperGetMV("MV_XEXCEMB",,"")
	Local cMV_XREPVOL	:= SuperGetMV("MV_XREPVOL",,"")
	Local _cUser  		:= RetCodUsr()

	DEFAULT lTelaPri:= .F.

	Private nVolRepl	:= 0

	If lTelaPri .and.  ! ("01*" $ CB7->CB7_TIPEXP .or. "02*" $ CB7->CB7_TIPEXP)
		MsgAlert("Ordem de Separa็ใo nใo configurada para ter embalagem!!!","Aten็ใo")
		Return
	EndIf
	/*
	If ! Empty(CB1->CB1_XLOCIM)
	CB5->(DbSetOrder(1))
		If CB5->(DbSeek(xFilial("CB5")+CB1->CB1_XLOCIM))
	cDescImp := CB5->(Alltrim(CB5_MODELO)+' '+Alltrim(CB5_DESCRI) )
		EndIf
	EndIf
	*/
	aAdd(aButtons,{"BMPINCLUIR"  	,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)}		,"Incluir F5","Incluir"		})
	aAdd(aButtons,{"NOTE"			,{|| ManuVol(.f.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)}		,"Alterar F6","Alterar"		})
	aAdd(aButtons,{"DEVOLNF"		,{|| DelVol(oLbxVol,aVolumes,cOrdSep,cPedido),MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag),Eval(oLbxVol:bChange)}												,"Exclui F9","Exclui"		})
	aAdd(aButtons,{"ACDIMG32"		,{|| EtiVol(cOrdSep,aVolumes[oLbxVol:nAt,2],oDescImp)}	 									,"Etiq. Volume F7","Imprimir"})
	aAdd(aButtons,{"ACDIMG32"		,{|| VisPed(cPedido)}		,"Visualizar pedido","Visualizar pedido"})

	Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
	//	Setkey(VK_F6,{|| ManuVol(.f.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido)}) - Desabilitado por solicita็ใo do Kleber Braga em 27/11/2013
	Setkey(VK_F7,{|| EtiVol(cOrdSep,aVolumes[oLbxVol:nAt,2],oDescImp)})
	Setkey(VK_F8,{|| CfgLocImp(oDescImp)})

	DEFINE MSDIALOG oDlg TITLE "Embalagem" FROM 0,0 TO aSize[6],aSize[5] PIXEL OF oMainWnd

	oDlg:lMaximized := .T.

	@00,00 MSPANEL oPanel1  SIZE 20,20 of oDlg
	oPanel1:Align := CONTROL_ALIGN_TOP
	@ 06,15+050 Say "Pedido" PIXEL of oPanel1
	@ 04,30+050 MsGet oPedido Var cPedido Picture "!!!!!!" PIXEL of oPanel1 SIZE 40,09 F3 "CB7FS2" Valid VldPedido(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag) WHEN .F.//! lTelaPri

	@ 06,102+050 Say "Ord. Separa็ใo" PIXEL of oPanel1
	@ 04,143+050 MsGet oOrdSep Var cOrdSep Picture "!!!!!!" PIXEL of oPanel1 SIZE 40,09 F3 "CB7FS1" Valid VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag) WHEN .F.//! lTelaPri

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

	@ 06,150+250 Say "Local de Impressใo:" PIXEL of oPanel4
	@ 04,200+250 MsGet oDescImp Var cDescImp Picture "@!" PIXEL of oPanel4 SIZE 100,09 When .f.

	oOrdSep:cText := _cOrdSep1
	oPedido:cText := _cPedido1

	DbSelectArea("CB7")
	CB7->(DbSetOrder(1))
	CB7->(DbGoTop())
	If !CB7->(DbSeek(xFilial("CB7")+_cOrdSep1))
		MsgAlert("Ordem de separa็ใo nใo encontrada, verifique!")
		Return
	EndIf

	If ! VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		Return
	EndIf
	MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	/*
	If lTelaPri
	MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	cOrdSep := CB7->CB7_ORDSEP
		If ! VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	Return
		EndIf
	Else
	aVolumes:={{oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)}} //Adic. Larg Alt Prof
	oLbxVol:SetArray( aVolumes )
	oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
	oLbxVol:Refresh()
	EndIf
	*/
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

	Setkey(VK_F4,NIL)
	Setkey(VK_F5,NIL)
	Setkey(VK_F6,NIL)
	Setkey(VK_F7,NIL)
	Setkey(VK_F8,NIL)

	RestArea(aArea)
Return

Static Function VldPedido(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	Local nC			:= 0
	Local lRet		:= .f.
	Local oEmb 		:= LoadBitmap( GetResources(), "BR_PRETO"	)
	Local cPedido	:= oPedido:cText

	If Empty(cPedido)
		Return .t.
	EndIf

	Begin Sequence
		If !Empty(oOrdSep:cText) .And. !Empty(oPedido:cText)
			CB7->(DbSetorder(1))
			If CB7->(DbSeek(xFilial("CB7")+oOrdSep:cText))
				If !(AllTrim(CB7->CB7_PEDIDO)==AllTrim(oPedido:cText))
					MsgAlert('Ordem de Separa็ใo com o Pedido '+oPedido:cText+' nใo encontrado','Aten็ใo')
					oPedido	:cText  := Space(6)
					oOrdSep	:cText  := Space(6)
					Break
				EndIf
			Else
				MsgAlert('Ordem de Separa็ใo nใo encontrada','Aten็ใo')
				oPedido	:cText  := Space(6)
				oOrdSep	:cText  := Space(6)
				Break
			EndIf
		EndIf
		If Empty(oOrdSep:cText)
			CB7->(DbSetorder(2))  //CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG
			If ! CB7->(DbSeek(xFilial('CB7')+cPedido))
				MsgAlert('Ordem de Separa็ใo com o Pedido '+cPedido+' nใo encontrado','Aten็ใo')
				Break
			Endif
			While CB7->(! Eof() .and. CB7_FILIAL+CB7_PEDIDO == xFilial('CB7')+cPedido )
				nC++
				CB7->(DbSkip())
			End
			CB7->(DbSeek(xFilial('CB7')+cPedido))
			If nC > 1
				ConPad1(,,,"CB7FS2",,,.f.,,, cPedido)
				If CB7->CB7_PEDIDO <> cPedido
					MsgAlert('Ordem de Separa็ใo nใo pertence ao Pedido '+cPedido,'Aten็ใo')
					Break
				EndIf
			EndIf
		EndIf
		If ! ("01*" $ CB7->CB7_TIPEXP .or. "02*" $ CB7->CB7_TIPEXP)
			MsgAlert("Ordem de Separa็ใo nใo configurada para ter embalagem!!!","Aten็ใo")
			Break
		EndIf
		oStatus	:cText 		:= RetStatus(CB7->CB7_STATUS)
		oOrdSep	:cText  	:= CB7->CB7_ORDSEP
		oCliente:cText 		:= CB7->(CB7_CLIENT+' - '+CB7_LOJA)
		oDesCli	:cText  	:= Posicione("SA1",1,XFILIAL("SA1")+CB7->(CB7_CLIENT+CB7_LOJA),"A1_NOME")
		MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		Eval(oLbxVol:bChange)
		lRet:= .t.
		Recover
		oStatus	:cText 	:= ''
		oPedido	:cText  := Space(6)
		oOrdSep	:cText  := Space(6)
		oCliente:cText 	:= ''
		oDesCli	:cText  := ''

		aVolumes:={{oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)}} //Adic. Larg Alt Prof
		oLbxVol:SetArray( aVolumes )
		oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
		oLbxVol:Refresh()
		Eval(oLbxVol:bChange)

		lRet := .f.
	End Sequence
	CB7->(DbSetorder(1))
Return lRet

Static Function VldOrdSep(oOrdSep,oPedido,oStatus,oCliente,oDesCli,oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	Local cOrdSep 	:= oOrdSep:cText
	Local oEmb 		:= LoadBitmap( GetResources(), "BR_PRETO"	)
	Local lRet		:= .t.
	If Empty(cOrdSep)
		Return .t.
	EndIf
	Begin Sequence
		If !Empty(oOrdSep:cText) .And. !Empty(oPedido:cText)
			CB7->(DbSetorder(1))
			If CB7->(DbSeek(xFilial("CB7")+oOrdSep:cText))
				If !(AllTrim(CB7->CB7_PEDIDO)==AllTrim(oPedido:cText))
					MsgAlert('Ordem de Separa็ใo com o Pedido '+oPedido:cText+' nใo encontrado','Aten็ใo')
					oPedido	:cText  := Space(6)
					oOrdSep	:cText  := Space(6)
					Break
				EndIf
			Else
				MsgAlert('Ordem de Separa็ใo nใo encontrada','Aten็ใo')
				oPedido	:cText  := Space(6)
				oOrdSep	:cText  := Space(6)
				Break
			EndIf
		EndIf
		CB7->(DbSetorder(1))
		If ! CB7->(DbSeek(xFilial('CB7')+cOrdSep))
			MsgAlert('Ordem de Separa็ใo nใo encontrada','Aten็ใo')
			Break
		Endif
		If ! ("01*" $ CB7->CB7_TIPEXP .or. "02*" $ CB7->CB7_TIPEXP)
			MsgAlert("Ordem de Separa็ใo nใo configurada para ter embalagem!!!","Aten็ใo")
			Break
		EndIf
		oStatus	:cText 	:= RetStatus(CB7->CB7_STATUS)
		oPedido	:cText  	:= CB7->CB7_PEDIDO
		oCliente	:cText 	:= CB7->(CB7_CLIENT+' - '+CB7_LOJA)
		oDesCli	:cText  	:= Posicione("SA1",1,XFILIAL("SA1")+CB7->(CB7_CLIENT+CB7_LOJA),"A1_NOME")
		MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
		Eval(oLbxVol:bChange)
		lRet := .t.
		Recover
		oStatus	:cText 	:= ''
		oPedido	:cText  	:= Space(6)
		oOrdSep	:cText  	:= Space(6)
		oCliente	:cText 	:= ''
		oDesCli	:cText  	:= ''

		aVolumes:={{oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)}} //Adic. Larg Alt Prof
		oLbxVol:SetArray( aVolumes )
		oLbxVol:bLine := {|| aEval(aVolumes[oLbxVol:nAt],{|z,w| aVolumes[oLbxVol:nAt,w] } ) }
		oLbxVol:Refresh()
		Eval(oLbxVol:bChange)

		lRet:= .f.
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

Return aStatus[Val(cStatus)+1]


Static Function MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	Local cOrdSep 	:= CB7->CB7_ORDSEP
	Local aArea		:= GetArea()
	Local aAreaCB9 	:= CB9->(GetArea())
	Local aAreaCB6 	:= CB9->(GetArea())
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

	aVolumes:={}

	DbSelectArea("CB9")
	CB9->(DbSetorder(4))
	CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
	CB6->(DbSeek(xFilial('CB6')+cOrdSep))
	While CB6->(! Eof() .and. CB6_FILIAL+CB6_XORDSE == xFilial('CB6')+cOrdSep)
		nQtdEmb	:=0
		/*
		If	CB9->(DbSeek(xFilial('CB9')+CB6->CB6_VOLUME))
			While CB9->(! Eof() .and. CB9_FILIAL+CB9_VOLUME == xFilial('CB9')+CB6->CB6_VOLUME)
		nQtdEmb	+= CB9->CB9_QTEEMB //gargalo
		CB9->(DbSkip())
			End
		EndIf
		*/
		nQtdEmb:= STEMB30(CB6->CB6_VOLUME)
		If ! Empty(CB6->CB6_XPESO)
			oEmb := oVermelho
		Else
			oEmb := oAmarelo
		EndIf

		//cRegiao := u_regceped(CB6->CB6_PEDIDO)
		cRegiao := ""

		aVolAux :=	{oEmb,;
			Right(CB6->CB6_VOLUME,4),;
			CB6->CB6_TIPVOL+' '+Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_DESCRI"),;
			Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_ALTURA"),; //Adic. Larg Alt Prof
		Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_LARGUR"),; //Adic. Larg Alt Prof
		Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_PROFUN"),; //Adic. Larg Alt Prof
		cRegiao,; //Adic. Regiao
		Transform(CB6->CB6_XPESO,"999999.99"),;
			nQtdEmb,;
			CB6->CB6_XOPERA+' '+Posicione("CB1",1,XFILIAL("CB1")+CB6->CB6_XOPERA,"CB1_NOME"),;
			CB6->(Dtoc(CB6_XDTINI)+' '+CB6_XHINI),;
			CB6->(Dtoc(CB6_XDTFIN)+' '+CB6_XHFIN),;
			" "}

		nTotPeso +=	CB6->CB6_XPESO
		aadd(aVolumes,aClone(aVolAux))

		_nCubTot	+= Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_VOLUME") //Renato Nogueira - Chamado 000214

		CB6->(DbSkip())
	EndDo

	_aArea		:= GetArea()
	_aAreaCB1   := CB1->(GetArea())

	DbSelectArea("CB1")
	CB1->(DbGotop())
	CB1->(DbSetOrder(1))
	CB1->(DbSeek(xFilial("CB1")+CB7->CB7_XOPEXP))

	_cNomeSep	:= CB1->CB1_NOME

	RestArea(_aAreaCB1)
	RestArea(_aArea)

	If Empty(aVolumes)
		aVolumes:={{oEmb,Space(4),Space(35),Space(5),Space(5),Space(5),Space(3),Space(12),Space(12),Space(40),Space(12),Space(12),Space(80)}} //Adic. Larg Alt Prof
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
	aVolItem:={}

	CB9->(DbSetOrder(4))
	If ! Empty(cVolume) .and. CB9->(DbSeek(xFilial("CB9")+cVolume))
		While CB9->(! Eof() .and. CB9_FILIAL+CB9_VOLUME == xFilial("CB9")+cVolume)
			cDesProd := Posicione("SB1",1,XFILIAL("SB1")+CB9->CB9_PROD,"B1_DESC")
			aadd(aVolItem,{CB9->CB9_PROD,Alltrim(cDesProd),Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,''})
			CB9->(DbSkip())
		EndDo
	End
	If Empty(aVolItem)
		aVolItem:={{Space(15),Space(40),Space(20),Space(20),Space(40)}}
	EndIf
	If oLbxItem # NIL
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
	Local aCabItVol := {"Produto","Descri็ใo","Quantidade","Lote"}
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local oTotPeso
	Local oTotVol
	Local _lApagou := .F.

	cVolume := cOrdSep+aVolumes[oLbxVol:nAt,2]

	CB9->(DbSetOrder(4))
	If ! Empty(cVolume) .and. CB9->(DbSeek(xFilial("CB9")+cVolume))
		While CB9->(! Eof() .and. CB9_FILIAL+CB9_VOLUME == xFilial("CB9")+cVolume)

			_lApagou := .T.

			_nSaldoEmb := CB9->CB9_QTEEMB

			CB9->(RecLock("CB9",.F.))
			CB9->CB9_VOLUME := ""
			CB9->CB9_CODEMB := ""
			CB9->CB9_STATUS := "1"
			CB9->CB9_QTEEMB := 0
			CB9->CB9_LOTECT := ""
			CB9->(MsUnLock())

			DbSelectArea("CB8")
			CB8->(DbSetOrder(1))
			CB8->(DbGoTop())
			If CB8->(DbSeek(CB9->(CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP)))
				CB8->(RecLock("CB8",.F.))
				CB8->CB8_SALDOE += _nSaldoEmb
				CB8->(MsUnLock())
			EndIf

			CB9->(DbSkip())
		EndDo
	End
	If _lApagou

		CB6->(DbSetOrder(1))
		If CB6->(DbSeek(xFilial("CB6")+cVolume))
			CB6->(RecLock("CB6",.F.))
			CB6->(DbDelete())
			CB6->(MsUnlock())
		EndIf

		CB7->(DbSetorder(1))
		If CB7->(DbSeek(xFilial("CB7")+cOrdSep))
			CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
			CB7->(Reclock('CB7',.F.))
			If !CB6->(DbSeek(xFilial('CB6')+cOrdSep))
				CB7->CB7_STATUS := "2"  // Sep.Final
			Else
				CB7->CB7_STATUS := "3"  // Embalando
			EndIf
			CB7->(MsUnLock())
		EndIf

		SF2->(RecLock("SF2",.F.))
		SF2->F2_XSTATUS := "2"
		SF2->(MsUnLock())

	Else
		MsgAlert("Nenhum volume encontrado, verifique!")
	EndIf

Return

Static Function MarkAll(cMarcou,__oBrwTrb,cAlias,__oDlg)

	DbSelectArea("TRB")
	("TRB")->(DbGoTop())

	While ("TRB")->(!Eof())

		("TRB")->(RecLock("TRB",.F.))
		IF ("TRB")->OK == cMarcou
			("TRB")->OK := ""
		Else
			("TRB")->OK := cMarcou
		EndIf

		("TRB")->(DbSkip())

	EndDo

	__oBrwTrb:oBrowse:Refresh(.t.)

Return Nil


Static Function DelVolGrv(aDocs,aRecCB9,cVolume,cPedido,cOrdSep)

	Local nX 		:= 0
	Local nSaldoEmb	:= 0
	Local lDelCB9	:= .F.
	Local lAchouCB9	:= .F.

	If STDUPLIORD(cOrdSep) //verifica se ordem de separa็ใo possui produtos duplicado Giovani Zago 06/06/2013 item 104 mit006

		STORDDUPLGrv(aDocs,aRecCB9,cVolume,cPedido,cOrdSep)

	Else
		For nX:= 1 to len(aDocs)
			/*
			If ! aDocs[nX,1]
			Loop
			EndIf
			*/
			lDelCB9		:= .T.
			lAchouCB9	:= .F.

			CB9->(DbSetorder(8))
			CB9->(DbGoTo(aRecCB9[nX]))

			CB8->(DbSetOrder(4))
			CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))

			nSaldoEmb := CB9->CB9_QTEEMB

			If CB9->(DbSeek(CB9->CB9_FILIAL+CB9->CB9_ORDSEP+CB9->CB9_PROD+Space(10)+Space(6)+Space(20)+Space(10)))
				CB9->(RecLock("CB9",.F.))
				CB9->CB9_QTESEP += nSaldoEmb
				CB9->(MsUnlock())

				lAchouCB9 := .T.
			EndIf

			CB9->(DbGoTo(aRecCB9[nX]))
			CB9->(RecLock("CB9",.F.))
			If lAchouCB9
				CB9->(DbDelete())
			Else
				CB9->CB9_VOLUME := ""
				CB9->CB9_QTEEMB := 0
				CB9->CB9_CODEMB := ""
				CB9->CB9_LOTECT := ""
				CB9->CB9_STATUS := "1"  // Em Aberto
			EndIf
			CB9->(MsUnlock())

			CB8->(RecLock("CB8",.F.))
			CB8->CB8_SALDOE += nSaldoEmb
			CB8->(MsUnlock())
		Next

		If lDelCB9
			CB6->(DbSetorder(1))
			CB9->(DbSetorder(4))
			If !CB9->(DbSeek(xFilial("CB9")+cVolume))
				If CB6->(DbSeek(xFilial("CB6")+cVolume))
					CB6->(RecLock("CB6",.F.))
					CB6->(DbDelete())
					CB6->(MsUnlock())
				EndIf
			EndIf

			CB7->(DbSetorder(1))
			If CB7->(DbSeek(xFilial("CB7")+cOrdSep))
				CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
				CB7->(Reclock('CB7',.F.))
				If !CB6->(DbSeek(xFilial('CB6')+cOrdSep))
					CB7->CB7_STATUS := "2"  // Sep.Final
				Else
					CB7->CB7_STATUS := "3"  // Embalando
				EndIf
				CB7->(MsUnLock())
			EndIf

			If !IsInCallStack("DelVolTot")
				MsgInfo("Itens excluํdos com sucesso.","OK")
			EndIf
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelVol	บAutor  ณMicrosiga           บ Data ณ  13/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de selecao de itens do volume                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAFAT                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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

	If ! lOk
		aDocs:={}
	EndIf

Return

Static Function MarcaTodos(oLbx, lInverte, lMarca)

	Local nX
	DEFAULT lMarca := .T.

	For nX := 1 TO Len(oLbx:aArray)
		InverteSel(oLbx,nX, lInverte, lMarca)
	Next

Return

Static Function InverteSel(oLbx,nLin, lInverte, lMarca)

	DEFAULT nLin := oLbx:nAt

	If lInverte
		oLbx:aArray[nLin,1] := ! oLbx:aArray[nLin,1]

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
		If nX==1
			If aDocs[oLbx:nAt,1]
				aadd(aRet,oOk)
			Else
				aadd(aRet,oNo)
			EndIf
		Else
			aadd(aRet,aDocs[oLbx:nAt,nX])
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
	Local lChk 		:= .f.
	Local oDlg

	Local oLbx
	Local aLbx		:={}
	Local lOk		:=.f.
	Local nPeso		:= 0
	Local lSaldoEmb	:= .F.
	Local nItem		:= 0

	Local cMV_XEXCEMB	:= SuperGetMV("MV_XEXCEMB",,"")
	Local cMV_XREPVOL	:= SuperGetMV("MV_XREPVOL",,"")
	Local _cUser  		:= RetCodUsr()

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	Default lReplVol	:= .F.

	Setkey(VK_F5,NIL)

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " +RetSqlName("SC9")+ " SC9 "
	cQuery1  += " WHERE SC9.D_E_L_E_T_=' ' AND C9_FILIAL='"+xFilial("SC9")+"' AND C9_PEDIDO='"+cPedido+"' AND C9_ORDSEP='"+cOrdSep+"' AND C9_NFISCAL <> ' ' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR >= 1

		DbSelectArea("CB7")
		CB7->(DbSetOrder(1))
		CB7->(DbGotop())
		If	CB7->(DbSeek(xFilial('CB7')+cOrdSep))
			If CB7->CB7_XVIRTU = '1'

				CB9->(DbSetorder(4))
				CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
				If	CB6->(DbSeek(xFilial('CB6')+cOrdSep))
					If CB6->CB6_VOLUME = cOrdSep+'AUTO'

						If MsgYesNo("OS automatica deseja Reembalar?")

							RecLock("CB6",.F.)
							CB6->(DbDelete())
							CB6->(MsUnlock())
							CB6->(DbCommit())



							CB7->(RecLock("CB7",.F.))
							CB7->CB7_STATUS := '2'
							CB7->(MsUnLock())
							CB7->(DbCommit())

							DbSelectArea("CB8")
							CB8->(DbSetOrder(1))
							CB8->(DbGotop())
							If	CB8->(DbSeek(xFilial('CB8')+cOrdSep))
								While CB8->(! Eof()) .and. CB8->(CB8_FILIAL+CB8_ORDSEP) == xFilial('CB8')+cOrdSep


									CB8->(RecLock("CB8",.F.))
									CB8->CB8_SALDOE := CB8->CB8_QTDORI
									CB8->(MsUnLock())
									CB8->(DbCommit())

									DbSelectArea("CB9")
									CB9->(DbSetOrder(6)) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+CB9_LOTSUG+CB9_SLOTSU+CB9_SUBVOL+CB9_CODETI
									CB9->(DbGoTop())
									If CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM)))
										RecLock("CB9",.F.)
										CB9->CB9_QTEEMB := 0
										CB9->CB9_STATUS := '1'
										CB9->CB9_CODEMB := ' '
										CB9->CB9_LOTECT := ' '
										CB9->CB9_VOLUME := ' '
										CB9->(MsUnlock())
										CB9->(DbCommit())
									Endif
									CB8->(DbSkip())
								End

							Endif

						Endif
					Endif


				Else
					Return()
				EndIf
			Else
				MsgAlert("Essa ordem de separa็ใo possui NF amarrada e o volume nใo poderแ ser alterado","Aten็ใo") //Renato Nogueira - Chamado 000094
				Return
			EndIf
		EndIf
	EndIf

	cQuery1	 := " SELECT COUNT(*) CONTADOR "
	cQuery1  += " FROM " +RetSqlName("CB6")+ " B6 "
	cQuery1  += " WHERE B6.D_E_L_E_T_=' ' AND CB6_FILIAL='"+xFilial("CB6")+"' AND CB6_PEDIDO='"+cPedido+"' AND CB6_XORDSE='"+cOrdSep+"' AND CB6_XPESO<=0

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->CONTADOR >= 1 .And. lInclui
		MsgAlert("Existem volumes em aberto, verifique","Aten็ใo") //Renato Nogueira - Chamado 000094
		Return
	EndIf

	If Empty(cOrdSep)
		MsgAlert("Ordem de separa็ใo nใo informada!!!","Aten็ใo")
		Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
		Return .f.
	EndIf

	If CB7->CB7_STATUS > "4"
		MsgAlert("Ordem de Separa็ใo com status de "+RetStatus(CB7->CB7_STATUS)+" e nใo pode haver manuten็ใo","Aten็ใo")
		Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
		Return .t.
	EndIf
	If Empty(aVolumes[1,2])
		lInclui := .t.
	EndIf
	aCB8Sdo	:= {}
	If lInclui
		CB8->(DbSetOrder(1))
		CB8->(DBSeek(xFilial("CB8")+cOrdSep))
		While CB8->(!Eof() .AND. CB8_FILIAL+CB8_ORDSEP==xFilial("CB8")+cOrdSep)
			If ! Empty(CB8->CB8_SALDOE)
				nPosCB8 := aScan(aCB8Sdo,{|x|x[1] = CB8->CB8_PROD})
				If Empty(nPosCB8)
					aAdd(aCB8Sdo,{CB8->CB8_PROD,0})
					nPosCB8 := Len(aCB8Sdo)
				EndIf
				aCB8Sdo[nPosCB8,2] += CB8->CB8_SALDOE
				lSaldoEmb:= .T.
				//Exit
			EndIf
			CB8->(DbSkip())
		EndDo

		If lReplVol
			For nItem := 1 to Len(aVolItem)
				nQtdRepl := Val(aVolItem[nItem,3]) * nVolRepl
				nPosCB8 := aScan(aCB8Sdo,{|x|x[1] = aVolItem[nItem,1]})
				If Empty(nPosCB8) .Or. aCB8Sdo[nPosCB8,2] < nQtdRepl
					lAborRepl := .T.
					nLimVol := Int(aCB8Sdo[nPosCB8,2] / Val(aVolItem[nItem,3]))
					MsgAlert("Produto " + aVolItem[nItem,1] + " nใo possui saldo suficiente para embalar" + CRLF + "O limite para replicar sใo " + AllTrim(Str(nLimVol)) + " volumes.","Aten็ใo")
					Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
					Return .t.
				EndIf
			Next nItem
		EndIf

		If !lSaldoEmb
			MsgAlert("Ordem de Separa็ใo nใo possuํ saldo de embalagem para ser embalado.","Aten็ใo")
			Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
			Return .t.
		EndIf

		If Empty(CB7->CB7_XDIEM)
			CB7->(RecLock("CB7"))
			CB7->CB7_XDIEM := Date()
			CB7->CB7_XHIEM := Time()
			CB7->(MsUnLock())
		EndIf
		While ! LockByName("ARFSFA30.FSW", .F., .F., LS_GetTotal(1) < 0)
			Sleep(500)
		EndDo
		cVolume:= Soma1(STUltimo(cOrdSep))
		CB6->(RecLock("CB6",.T.))
		CB6->CB6_FILIAL := xFilial("CB6")
		CB6->CB6_VOLUME := cVolume
		CB6->CB6_XORDSE := cOrdSep
		CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
		CB6->CB6_TIPVOL := CB3->CB3_CODEMB
		CB6->CB6_XDTINI := dDataBase
		CB6->CB6_XHINI  := Left(Time(),5)
		CB6->(MsUnLock())
		UnlockByName("ARFSFA30.FSW", .F., .F., LS_GetTotal(1) < 0)
	Else
		cVolume 	:= cOrdSep+aVolumes[oLbxVol:nAt,2]
		CB6->(DbSetOrder(1))
		CB6->(DbSeek(xFilial('CB6')+cVolume))
		If ! Empty(CB6->CB6_XPESO)
			If ! lTelaPri .And. !_cUser $ cMV_XEXCEMB
				MsgAlert("Volume fechado! Usuario sem autorizacao para excluir embalagem")
				Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
				Return .f.
			EndIf
			If ! MsgYesNo("Deseja reabrir o volume?","Aten็ใo")
				Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})
				Return .f.
			EndIf
		EndIf
		cCodEmb 	:= CB6->CB6_TIPVOL
		cCodEmbOld	:= cCodEmb
		cDescEmb	:= Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_DESCRI")
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
		DEFINE MSDIALOG oDlg TITLE "Manuten็ใo de Volumes" FROM 0,0 TO 470,600 PIXEL OF oMainWnd

		EnchoiceBar( oDlg, {|| lOk:= .t.,oDlg:End()} , {|| oDlg:End() },, )
		oPanel 			:= TPanel():New( 010, 010, ,oDlg, , , , , , 30, 30, .F.,.T. )
		oPanel:align 	:= CONTROL_ALIGN_TOP
		oPanel3 			:= TCBrowse():New(010,010,70,70,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
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
		@ 001 , 001 LISTBOX oLbx FIELDS HEADER " ","Produto","Descri็ใo","Quantidade","Lote"," " SIZES {2,15,20,20,20,10} SIZE 490,095 OF oPanel3 PIXEL
		oLbx:align := CONTROL_ALIGN_ALLCLIENT
		oLbx:bGotFocus:={||SetFocus(oEtiqueta:hWnd)}
		MontaaLbx(cVolume,oLbx,aLbx)
		Setkey(VK_F4,{|| lOk:= .t.,oDlg:End()}) //Solicita็ใo Kleber Braga - 27/11/2013
		/*
		oLbx:lUseDefaultColors := .F.
		oLbx:SetBlkColor({|| 4227327 })
		*/
		ACTIVATE MSDIALOG oDlg CENTERED Valid VldInfEmb(cCodEmb,oCodEmb)
	EndIf

	If lOk .and. ! Empty(aLbx[1,2])
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
	EndIf

	If lOk
		STCHKCB8(cOrdSep)
	EndIf

	If Empty(aLbx[1,2])	.and. cVolume == Ultimo(cOrdSep)
		//MsgAlert("Excluindo o ultimo volume vazio!!!","Aten็ใo")
		CB6->(DbSetOrder(1))
		CB6->(DbSeek(xFilial('CB6')+cVolume))
		CB6->(RecLock("CB6",.F.))
		CB6->(DbDelete())
		CB6->(MsUnlock())
	Else
		CB6->(DbSetOrder(1))
		CB6->(DbSeek(xFilial('CB6')+cVolume))
		CB6->(RecLock("CB6",.F.))
		CB6->CB6_TIPVOL := cCodEmb
		CB6->CB6_XPESO	:= nPeso
		CB6->(MsUnlock())
	EndIf

	MontaVol(oLbxVol,aVolumes,oTotPeso,oTotVol,oNomeSep,oCubag)
	Eval(oLbxVol:bChange)

	FimProcEmb()

	If CB7->CB7_STATUS >="4"
		SC5->(DbSetOrder(1))
		If ! Empty(CB7->CB7_PEDIDO) .and. SC5->(DbSeek(xFilial('SC5')+CB7->CB7_PEDIDO))
			SC5->(RecLock('SC5',.F.))
			SC5->C5_PBRUTO := oTotPeso:cText
			SC5->C5_VOLUME1:= oTotVol:cText
			SC5->C5_ESPECI1:= "CX"
			SC5->(MsUnLock())
		EndIf
	EndIf

	If nPeso > 0 .And. ! lReplVol

		EtiVol(cOrdSep,Right(cVolume,4),oDescImp)

		If CB7->CB7_STATUS == "4" //Embalagem finalizada

			ARFSFAQ1(SF2->F2_DOC) //Imprimi etiqueta de Clientes

		EndIf

	EndIf

	oStatus	:cText 	:= RetStatus(CB7->CB7_STATUS)

	Setkey(VK_F5,{|| ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.F.,oLbxItem,aVolItem)})

Return

Static Function VldInfEmb(cCodEmb,oCodEmb)

	Local lRet 		:= .T.
	Local aArea 	:= GetArea()
	Local aAreaCB3	:= CB3->(GetArea())

	If Empty(cCodEmb)
		MsgAlert("Codigo de Embalagem nใo informado!!!","Aten็ใo")
		oCodEmb:SetFocus()
		lRet := .F.
	EndIf

	CB3->(DbSetOrder(1))
	If lRet .And. ! CB3->(DbSeek(xFilial('CB3')+cCodEmb))
		MsgAlert("Codigo de Embalagem nใo encontrado!!!","Aten็ใo")
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
	Local aAreaCB6	:= CB6->(GetArea())
	Local cVolume	:= cOrdSep+"0000"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STVOL'+cHora+ cMinutos+cSegundos
	Local cQuery    := ' '

	cQuery := " SELECT
	cQuery += " CB6.CB6_VOLUME
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '
	cQuery += " AND CB6.CB6_XORDSE = '"+cOrdSep+"'"
	cQuery += " AND CB6.CB6_FILIAL =  '"+xFilial("CB6")+"'"
	cQuery += " ORDER BY CB6.CB6_VOLUME DESC
	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
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
	Local aAreaCB6	:= CB6->(GetArea())
	Local cVolume	:= cOrdSep+"0000"
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'STVOL'+cHora+ cMinutos+cSegundos
	Local cQuery    := ' '

	cQuery := " SELECT
	cQuery += " CB6.CB6_VOLUME
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '
	cQuery += " AND CB6.CB6_XORDSE = '"+cOrdSep+"'"
	cQuery += " AND CB6.CB6_FILIAL =  '"+xFilial("CB6")+"'"
	cQuery += " ORDER BY CB6.CB6_VOLUME
	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			cVolume:= Soma1(cVolume)
			If  cVolume  <> (cAliasLif)->CB6_VOLUME
				cVolume:= Tira1(cVolume)
				RestArea(aAreaCB6)
				RestArea(aArea)
				Return cVolume
			EndIf
			(cAliasLif)->(DbSkip())
		Enddo

		(cAliasLif)->(dbCloseArea())
	EndIf

	If Empty(Alltrim(cVolume))
		cVolume	:= cOrdSep+"0000"
	EndIf

	RestArea(aAreaCB6)
	RestArea(aArea)
Return cVolume

Static Function PegaPeso(cVolume)
	Local aParambox	:= {}
	Local aRet			:= {}
	Local nPeso			:= 0
	aAdd(aParamBox,{1,"Peso"	,nPeso		,"9999999.99", "", "", "" , 0  , .F. })

	If !ParamBox(aParamBox,"Peso do Volume",@aRet,,,,,,,,.f.)
		Return 0
	Endif

Return MV_PAR01

Static Function MontaBarra(oEtiqueta)
	Local aParambox	:= {}
	Local aRet			:= {}
	Local cProduto		:= Space(15)
	Local nQuant		:= 0
	Local cLote			:= Space(10)

	aAdd(aParamBox,{1,"Produto"		,cProduto	,"@!","","SB1","",0,.T.})
	aAdd(aParamBox,{1,"Quantidade"	,nQuant		,"@E 99,999,999.99", "", "", "" , 0  , .T. })
	aAdd(aParamBox,{1,"Lote"			,cLote		,"@!", "", "", "" , 0  , .F. })

	If !ParamBox(aParamBox,"Conteudo da Etiqueta",@aRet,,,,,,,,.f.)
		Return
	Endif
	oEtiqueta:cText:= Padr(Alltrim(aRet[1])+"="+Alltrim(aRet[3])+"="+AllTrim(Str(aRet[2])),48)
	oEtiqueta:SetFocus()
	Eval(oEtiqueta:bValid)
Return .t.

Static Function MontaaLbx(cVolume,oLbx,aLbx)

	Local cPicture := PesqPict("CB9","CB9_QTEEMB")
	Local cDesProd := ''
	Local oOK := LoadBitmap(GetResources(),'br_verde')
	Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	Local cQuery9 	:= ""
	Local cAlias9 	:= "QRYTEMP9"
	Local _nLastReg := 0

	aLbx:={}

	CB9->(DbSetOrder(4))
	If ! Empty(cVolume) .and. CB9->(DbSeek(xFilial("CB9")+cVolume))
		/*
		cQuery9  := " SELECT MAX(R_E_C_N_O_) REGISTRO "
		cQuery9  += " FROM " +RetSqlName("CB9")+ " B9 "
		cQuery9  += " WHERE B9.D_E_L_E_T_=' ' AND CB9_FILIAL='"+CB9->CB9_FILIAL+"' AND CB9_ORDSEP='"+CB9->CB9_ORDSEP+"' "
		cQuery9  += " AND CB9_STATUS='2' AND CB9_XULTVO='S' "

		If !Empty(Select(cAlias9))
		DbSelectArea(cAlias9)
		(cAlias9)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery9),cAlias9,.T.,.T.)

		dbSelectArea(cAlias9)
		(cAlias9)->(dbGoTop())

		If (cAlias9)->(!Eof())
		_nLastReg	:=(cAlias9)->REGISTRO
		EndIf
		*/
		While CB9->(! Eof() .and. CB9_FILIAL+CB9_VOLUME == xFilial("CB9")+cVolume)
			cDesProd := Posicione("SB1",1,XFILIAL("SB1")+CB9->CB9_PROD,"B1_DESC")
			aadd(aLbx,{IIf(_nLastReg==CB9->(Recno()),.T.,.F.),CB9->CB9_PROD,Alltrim(cDesProd),Transform(CB9->CB9_QTEEMB,cPicture),CB9->CB9_LOTECT,''})
			CB9->(DbSkip())
		EndDo
		ASORT(aLbx,,,{|x,y|x[1]>y[1]})
	End
	If Empty(aLbx)
		aLbx:={{.F.,Space(15),Space(40),Space(20),Space(20),Space(40)}}
	EndIf
	oLbx:SetArray( aLbx )
	//oLbx:bLine := {|| aEval(aLbx[oLbx:nAt],{|z,w| aLbx[oLbx:nAt,w] }, ) }
	oLbx:bLine := {||{If(aLbx[oLbx:nAt,1],oOK,oNO),;
		aLbx[oLbx:nAt,2],;
		aLbx[oLbx:nAt,3],;
		aLbx[oLbx:nAt,4],;
		aLbx[oLbx:nAt,5],;
		aLbx[oLbx:nAt,6]}}

	oLbx:Refresh()
Return

Static Function VldEmb(cCodEmb,cDescEmb)
	Local aArea := GetArea()
	Local aAreaCB3:= CB3->(GetArea())
	cDescEmb:=Space(30)
	/*
	If Empty(cCodEmb)
	MsgAlert("Codigo de Embalagem nใo informado!!!","Aten็ใo") //Comentado por Leonardo Flex 11/03/2013 - Validar somente na confirmacao
	Return .f.
	EndIf
	*/
	CB3->(DbSetOrder(1))
	If !Empty(cCodEmb) .And. ! CB3->(DbSeek(xFilial('CB3')+cCodEmb))
		MsgAlert("Codigo de Embalagem nใo encontrado!!!","Aten็ใo")
		RestArea(aAreaCB3)
		RestArea(aArea)
		Return .f.
	EndIf
	If !Empty(cCodEmb)
		cDescEmb:= CB3->CB3_DESCRI
	EndIf
	RestArea(aAreaCB3)
	RestArea(aArea)

Return .t.

Static Function VldEti(oEtiqueta,lEstorna,cVolume,oLbx,aLbx,cCodEmb,oCodEmb,cCodEmbOld,lReplVol,oLbxItem,aVolItem,nItem)
	Local aRet
	Local cProduto
	Local cLote    := Space(10)
	Local cSLote   := Space(6)
	Local cNumSer  := Space(20)
	Local nQE      :=0
	Local nSaldoEmb
	Local nRecno,nRecnoCB9
	Local nQtdeSep
	Local cOrdSep	:= CB7->CB7_ORDSEP
	Local cEtiqueta := ""
	Local cLoteX 	:= ""
	Local cCodOpe	:= CbRetOpe()

	DEFAULT lEstorna := .F.
	DEFAULT lReplVol := .F.

	If lReplVol
		cEtiqueta := PadR(Alltrim(aVolItem[nItem,1]) + "=" + Alltrim(aVolItem[nItem,4]) + "=" + Alltrim(aVolItem[nItem,3]),48)
	Else
		cEtiqueta := oEtiqueta:cText
	EndIF

	If Empty(cEtiqueta)
		Return .T.
	EndIf
	/*
	If !VldInfEmb(cCodEmb,oCodEmb)	//Leonardo Flex -> validar se o codigo da embalagem foi informado ou se ela existe
	Return .T.
	EndIf
	*/

	cEtiqueta	:=	U_STAVALET(cEtiqueta) //Rotina para avaliar etiqueta e ajustar para padrใo de leitura do CBRETIEAN - Renato Nogueira - 01/12/2014

	aRet := CBRetEtiEan(cEtiqueta)
	If	Empty(aRet)
		MsgAlert("Etiqueta invalida","Aviso")
		Return .F.
	EndIf

	cProduto := aRet[1]
	nQE  		:= aRet[2]
	cLote  	:= aRet[3]
	cNumSer 	:= aRet[5]
	cLoteX 	:= U_RetLoteX()

	If	Empty(nQE)
		ApMsgAlert("Quantidade invalida","Aviso")
		If ! lReplVol
			oEtiqueta:cText := Space(48)
		EndIf
		Return .F.
	EndIf

	If ! Rastro(cProduto)
		/*
		PA0->(DbSetOrder(4))
		If ! PA0->(DbSeek(xFilial("PA0")+cOrdSep+cProduto+cLoteX))    //Comentado por Leonardo Flex 26/02/2013 - Item 2 do plano de melhorias
		ApMsgAlert("Lote Especifico nใo encontrado","Aviso")
		oEtiqueta:cText := Space(48)
		Return .F.
		EndIf
		*/
	EndIf

	If	! lEstorna
		CB9->(DbSetorder(8))
		If	! CB9->(DBSeek(xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+cNumSer+space(10)))
			MsgAlert("Etiqueta Invalida","Aviso")
			If ! lReplVol
				oEtiqueta:cText := Space(48)
			EndIf
			Return .f.
		EndIf

		nSaldoEmb:=0
		//While CB9->(! EOF() .AND. CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOTECT+CB9_NUMLOT+CB9_VOLUME ==xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+space(10)) //Comentado por Leonardo Flex -> corrigido condicao da busca
		While !CB9->(EOF()) .AND. CB9->CB9_FILIAL == xFilial("CB9") .AND. AllTrim(CB9->CB9_ORDSEP) == AllTrim(cOrdSep) .AND.;
				AllTrim(CB9->CB9_PROD) == AllTrim(cProduto) .AND. AllTrim(CB9->CB9_LOTECT) == AllTrim(cLote) .AND.;
				AllTrim(CB9->CB9_NUMLOT) == AllTrim(cSLote) .AND. CB9->CB9_VOLUME == space(10)
			nSaldoEmb += CB9->CB9_QTESEP
			CB9->(DbSkip())
		EndDo
		If	nQE > nSaldoEmb
			MsgAlert("Quantidade informada maior que disponivel para embalar","Aviso")
			If ! lReplVol
				oEtiqueta:cText := Space(48)
			Else
				lOk := .F.
				aLbx[1,1] := .F.
				aLbx[1,2] := ""
			Endif
			Return .F.
		EndIf

		CB6->(DBSetOrder(1))
		CB6->(RecLock("CB6",.F.))
		CB6->CB6_STATUS := "1"   // ABERTO
		CB6->CB6_XOPERA := cCodOpe
		CB6->CB6_XDTFIN :=dDataBase
		CB6->CB6_XHFIN  := Left(Time(),5)
		CB6->(MsUnlock())

		//-- Atualiza Quantidade Embalagem
		nSaldoEmb := nQE
		CB9->(DbSetorder(8))
		While nSaldoEmb > 0 .And. CB9->(DBSeek(xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+cNumSer+space(10)))
			If	nSaldoEmb > CB9->CB9_QTESEP
				Begin Transaction
					CB9->(RecLock("CB9"))
					CB9->CB9_VOLUME := cVolume
					CB9->CB9_QTEEMB := CB9->CB9_QTESEP
					CB9->CB9_CODEMB := cCodOpe
					CB9->CB9_STATUS := "2"  // Embalado
					CB9->(MsUnlock())
					//-- Atualiza Itens Ordem da Separacao
					CB8->(DbSetOrder(4)) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
					CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
					CB8->(RecLock("CB8"))
					CB8->CB8_SALDOE -= CB9->CB9_QTESEP
					If CB8->CB8_SALDOE<0
						CB8->CB8_SALDOE	:= 0
					EndIf
					CB8->(MsUnlock())
				End Transaction
				nSaldoEmb-=CB9->CB9_QTESEP
			Else
				nRecnoCB9:= CB9->(Recno())
				CB9->(DbSetOrder(8))
				If	CB9->(DBSeek(CB9_FILIAL+CB9_ORDSEP+CB9_PROD+cLoteX+CB9_NUMLOT+CB9_NUMSER+cVolume+CB9_ITESEP+CB9_LOCAL+CB9_LCALIZ))
					Begin Transaction
						CB9->(RecLock("CB9"))
						CB9->CB9_QTEEMB += nSaldoEmb
						CB9->CB9_QTESEP += nSaldoEmb
						CB9->(MsUnlock())
						//-- Atualiza Itens Ordem da Separacao
						CB8->(DbSetOrder(4)) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
						CB8->(RecLock("CB8"))
						CB8->CB8_SALDOE -= nSaldoEmb
						If CB8->CB8_SALDOE<0
							CB8->CB8_SALDOE	:= 0
						EndIf
						CB8->(MsUnlock())
						//--
						CB9->(DbGoto(nRecnoCB9))
						CB9->(RecLock("CB9"))
						CB9->CB9_QTESEP -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->(DBDelete())
						EndIf
						CB9->(MsUnlock())
					End Transaction
					nSaldoEmb := 0
				Else
					CB9->(DbGoto(nRecnoCB9))
					nRecno:= CB9->(CBCopyRec())
					Begin Transaction
						CB9->(RecLock("CB9"))
						CB9->CB9_VOLUME := cVolume
						CB9->CB9_QTEEMB := nSaldoEmb
						CB9->CB9_QTESEP := nSaldoEmb
						CB9->CB9_CODEMB := cCodOpe
						CB9->CB9_STATUS := "2"  // Embalado
						CB9->CB9_LOTECT	:= cLoteX
						CB9->(MsUnlock())
						//-- Atualiza Itens Ordem da Separacao
						CB8->(DbSetOrder(4)) //-- CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_PROD+CB8_LOCAL+CB8_LCALIZ+CB8_LOTECT+CB8_NUMLOT+CB8_NUMSER
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
						CB8->(RecLock("CB8"))
						CB8->CB8_SALDOE -= nSaldoEmb
						If CB8->CB8_SALDOE<0
							CB8->CB8_SALDOE	:= 0
						EndIf

						CB8->(MsUnlock())
						//--
						CB9->(DBGoto(nRecno))
						CB9->(RecLock("CB9"))
						CB9->CB9_QTESEP -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->(DBDelete())
						EndIf
						CB9->(MsUnlock())
					End Transaction
					nSaldoEmb := 0
				EndIf
			EndIf
		EndDo
		/*
		_cUpd := " UPDATE "+RetSqlName("CB9")+" B9 "
		_cUpd += " SET CB9_XULTVO=' ' "
		_cUpd += " WHERE B9.D_E_L_E_T_=' ' AND CB9_FILIAL='"+CB9->CB9_FILIAL+"' AND CB9_ORDSEP='"+CB9->CB9_ORDSEP+"' "

		TCSqlExec(_cUpd)

		_cUpd := " UPDATE "+RetSqlName("CB9")+" B9 "
		_cUpd += " SET CB9_XULTVO='S' "
		_cUpd += " WHERE B9.D_E_L_E_T_=' ' AND CB9_FILIAL='"+CB9->CB9_FILIAL+"' AND CB9_ORDSEP='"+CB9->CB9_ORDSEP+"' "
		_cUpd += " AND CB9_VOLUME='"+cVolume+"' AND CB9_LOTECT='"+cLoteX+"' AND CB9_PROD='"+cProduto+"' "

		TCSqlExec(_cUpd)
		*/
	Else
		CB9->(DbSetorder(8))
		If ! CB9->(DBSeek(xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+cNumSer+cVolume))
			MsgAlert("Produto nao embalado","Aviso")
			If ! lReplVol
				oEtiqueta:cText := Space(48)
			Endif
			Return .F.
		EndIf

		nSaldoEmb:=0
		While CB9->(! EOF() .AND. CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOTECT+CB9_NUMLOT+CB9_VOLUME == xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+cVolume)
			nSaldoEmb += CB9->CB9_QTEEMB
			CB9->(DbSkip())
		EndDo
		If nQE > nSaldoEmb
			MsgAlert("Quantidade informada maior que embalado","Aviso")
			If ! lReplVol
				oEtiqueta:cText := Space(48)
			Endif
			Return .F.
		EndIf

		//-- Estorna Quantidade Embalagem
		nSaldoEmb := nQE
		CB9->(DbSetorder(8))
		While nSaldoEmb>0 .And. CB9->(DBSeek(xFilial("CB9")+cOrdSep+cProduto+cLote+cSLote+cNumSer+cVolume))
			If	nSaldoEmb >= CB9->CB9_QTEEMB
				nRecnoCB9:= CB9->(Recno())
				nQtdeSep := CB9->CB9_QTESEP
				Begin Transaction
					CB9->(DbSetOrder(8))
					If	CB9->(DBSeek(CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+Space(10)+CB9_ITESEP+CB9_LOCAL+CB9_LCALIZ))
						CB9->(RecLock("CB9"))
						CB9->CB9_QTESEP += nQtdeSep
						CB9->(MsUnlock())
						CB9->(DbGoto(nRecnoCB9))
						//--
						CB8->(DbSetOrder(4))
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
						CB9->(RecLock("CB9"))
						CB9->(DbDelete())
						CB9->(MsUnlock())
					Else
						CB9->(DbGoto(nRecnoCB9))
						CB9->(RecLock("CB9"))
						CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB := 0
						CB9->CB9_CODEMB := ""
						CB9->CB9_STATUS := "1"  // Em Aberto
						CB9->(MsUnlock())
						CB8->(DbSetOrder(4))
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
					EndIf
					CB8->(RecLock("CB8"))
					CB8->CB8_SALDOE += nQtdeSep
					CB8->(MsUnlock())
				End Transaction
				nSaldoEmb-=nQtdeSep
			Else
				nRecnoCB9:= CB9->(Recno())
				nQtdeSep := CB9->CB9_QTESEP
				Begin Transaction
					CB9->(DbSetOrder(8))
					If	CB9->(DBSeek( CB9_FILIAL+CB9_ORDSEP+CB9_PROD+CB9_LOTECT+CB9_NUMLOT+CB9_NUMSER+Space(10)+CB9_ITESEP+CB9_LOCAL+CB9_LCALIZ))
						CB9->(RecLock("CB9"))
						CB9->CB9_QTESEP += nSaldoEmb
						CB9->(MsUnlock())
						//--
						CB9->(DbGoto(nRecnoCB9))
						CB9->(RecLock("CB9"))
						//CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB -= nSaldoEmb
						CB9->CB9_QTESEP -= nSaldoEmb
						//CB9->CB9_CODEMB := ''
						//CB9->CB9_STATUS := "1"
						If	Empty(CB9->CB9_QTESEP)
							CB9->(DbDelete())
						EndIf
						CB9->(MsUnlock())
						//--
						CB8->(DbSetOrder(4))
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
						CB8->(RecLock("CB8"))
						CB8->CB8_SALDOE += nSaldoEmb
						CB8->(MsUnlock())
					Else
						CB9->(DbGoto(nRecnoCB9))
						nRecno:= CB9->(CBCopyRec())
						CB9->(RecLock("CB9"))
						CB9->CB9_VOLUME := ""
						CB9->CB9_QTEEMB := 0
						CB9->CB9_QTESEP := nSaldoEmb
						CB9->CB9_CODEMB := ''
						CB9->CB9_STATUS := "1"
						CB9->(MsUnlock())
						//--
						CB8->(DbSetOrder(4))
						CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))
						CB8->(RecLock("CB8"))
						CB8->CB8_SALDOE += nSaldoEmb
						CB8->(MsUnlock())
						CB9->(DBGoto(nRecno))
						CB9->(RecLock("CB9"))
						CB9->CB9_QTESEP -= nSaldoEmb
						CB9->CB9_QTEEMB -= nSaldoEmb
						If	Empty(CB9->CB9_QTESEP)
							CB9->(DBDelete())
						EndIf
						CB9->(MsUnlock())
					EndIf
				End Transaction
				nSaldoEmb := 0
			EndIf
		EndDo
	EndIf

	//manutencao no pa0
	PA0->(DbSetOrder(2))
	If ! PA0->(DbSeek(xFilial('PA0')+'CB9'+Padr(cVolume,20)+cProduto+cLoteX))
		PA0->(RecLock("PA0",.T.))
		PA0->PA0_FILIAL 	:= xFilial("PA0")
		PA0->PA0_DOC		:= cVolume
		PA0->PA0_ORDSEP		:= Padr(cVolume,6)
		PA0->PA0_TIPDOC	:= 'CB9'
		PA0->PA0_PROD   	:= cProduto
		PA0->PA0_LOTEX  	:= cLoteX
	Else
		PA0->(RecLock("PA0",.F.))
	EndIf
	If ! lEstorna
		PA0->PA0_QTDE		+= nQE
	Else
		PA0->PA0_QTDE		-= nQE
	EndIf
	PA0->PA0_USU		:= __cUserID
	PA0->PA0_DTSEP  	:= dDataBase
	PA0->PA0_HRSEP  	:= Time()
	If PA0->PA0_QTDE <=0
		PA0->(DbDelete())
	EndIf
	PA0->(MsUnLock())

	//cCodEmbOld := cCodEmb
	//cCodEmb := Space(3)
	//oCodEmb:Refresh()

	If ! lReplVol
		MontaaLbx(cVolume,oLbx,aLbx)
		oEtiqueta:cText := Space(48)
	EndIf
	FimProcEmb()

Return .f.


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

Static Function FimProcEmb()
	Local cOrdSep	:= CB7->CB7_ORDSEP
	Local lFimEmb	:= .T.
	Local lTemSep	:= .F.

	CB8->(DBSeek(xFilial("CB8")+cOrdSep))
	While CB8->(!Eof() .AND. CB8_FILIAL+CB8_ORDSEP==xFilial("CB8")+cOrdSep)
		If ! Empty(CB8->CB8_SALDOS)
			lTemSep:= .T.
			lFimEmb:= .F.
			Exit
		EndIf
		If ! Empty(CB8->CB8_SALDOE)
			lFimEmb:= .F.
			Exit
		EndIf
		CB8->(DbSkip())
	EndDo

	CB7->(Reclock('CB7',.F.))
	If lFimEmb
		If CB7->CB7_STATUS < "4"
			If	("02" $ CBUltExp(CB7->CB7_TIPEXP))
				CB7->CB7_STATUS := "9"  // embalagem finalizada
			Else
				CB7->CB7_STATUS := "4"  // embalagem finalizada
			EndIf
			CB7->CB7_XDFEM := Date()
			CB7->CB7_XHFEM := Time()
		EndIf
	Else
		If lTemSep
			CB7->CB7_STATUS := "1" //	"1" - "Em separacao"
		Else
			CB7->CB7_STATUS := "2" //  "2" - "Separacao finalizada"
		EndIf
	EndIf
	CB7->(MsUnLock())

	If CB7->CB7_STATUS=="4" //Embalagem finalizada

		SF2->(RecLock("SF2",.F.))
		SF2->F2_XSTATUS := "3"
		SF2->(MsUnLock())

		U_ARFAT014(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_XORDSEP,"3")

	EndIf

Return lFimEmb

Static Function CfgLocImp(oDescImp)
	Local aParambox	:= {}
	Local aRet			:= {}
	Local cLocImp		:= CB1->CB1_XLOCIM
	aAdd(aParamBox,{1,"Local Impressใo"	,cLocImp		,"!!!!!!", "", "CB5", "" , 0  , .F. })
	While .t.
		If !ParamBox(aParamBox,"Configura็ใo",@aRet,,,,,,,,.f.)
			Return .f.
		Endif
		cLocImp:= aRet[1]
		If ! CB5->(DbSeek(xFilial("CB5")+cLocImp))
			MsgAlert("Local de Impressใo Invalido","Aten็ใo")
			Loop
		EndIf
		Exit
	End
	CB1->(RecLock('CB1',.F.))
	CB1->CB1_XLOCIM:=cLocImp
	CB1->(MsUnlock())
	oDescImp:cText := CB5->(Alltrim(CB5_MODELO)+' '+Alltrim(CB5_DESCRI) )
Return .t.

Static Function EtiVol(cOrdSep,cSeq,oDescImp)
	Local cVolume	:= cOrdSep+cSeq
	Local cLocImp	:= "LPT1"//CB1->CB1_XLOCIM

	While Empty(cLocImp)
		If ! CfgLocImp(oDescImp)
			Return
		EndIf
		cLocImp := CB1->CB1_XLOCIM
	End

	CB6->(DbSetorder(1))
	CB6->(DbSeek(xFilial('CB6')+cVolume))
	If Empty(CB6->CB6_XPESO)
		MsgAlert("Volume em aberto, nใo poderแ ser impresso!!!","Aten็ใo")
		Return
	EndIf
	/*
	If ! CB5SetImp(cLocImp)
	MsgAlert("Local de impressใo "+cLocImp+" nใo cadastrado!!!","Aten็ใo")
	Return
	EndIf
	*/
	MSCBPRINTER("ELTRON",cLocImp,,,.F.)

	If ExistBlock("IMG05")
		ExecBlock("IMG05",,,{cVolume,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
	EndIf

	MSCBCLOSEPRINTER()
Return

Static Function EtiVolLot(cOrdSep,cSeq,oDescImp)

	Local aArea			:= GetArea()
	Local cVolume		:= cOrdSep+cSeq
	Local cLocImp		:= CB1->CB1_XLOCIM
	Local _lRetorno 	:= .F. //Validacao da dialog criada oDlg
	Local _nOpca 		:= 0 //Opcao da confirmacao
	Local bOk 			:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
	Local bCancel 		:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
	Local _cArqEmp 		:= "" //Arquivo temporario com as empresas a serem escolhidas
	Local _aStruTrb 	:= {} //estrutura do temporario
	Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
	Local _aEmpMigr 	:= {} //array de retorno com as empresas escolhidas
	Local _aButtons		:= {}
	Private cMarca 		:= GetMark() //Variaveis para o MsSelect
	Private lInverte 	:= .F. //Variaveis para o MsSelect
	Private oBrwTrb //objeto do msselect
	Private oDlg

	AADD(_aButtons, {"DBG06",{||GETVOLUM(@cMarca) },"Selecionar faixa de volume" } )

	While Empty(cLocImp)
		If ! CfgLocImp(oDescImp)
			Return
		EndIf
		cLocImp := CB1->CB1_XLOCIM
	End

	//Define campos do TRB
	AADD(_aStruTrb,{"PEDIDO" 	,"C",06,0})
	AADD(_aStruTrb,{"OS" 		,"C",06,0})
	AADD(_aStruTrb,{"VOLUME" 	,"C",4 ,0})
	AADD(_aStruTrb,{"OK" 		,"C",02,0})

	//Define campos do msselect
	AADD(_aBrowse,{"OK" 	  ,,"" })
	AADD(_aBrowse,{"PEDIDO"  ,,"Pedido" })
	AADD(_aBrowse,{"OS" 	 ,,"Ordem de separa็ใo" })
	AADD(_aBrowse,{"VOLUME" ,,"Volume" })

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	Endif

	_cArqEmp := CriaTrab(_aStruTrb)
	dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

	cQuery := " SELECT CB6_PEDIDO, CB6_XORDSE, CB6_VOLUME "
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "
	cQuery += " WHERE D_E_L_E_T_=' ' AND CB6_XORDSE='"+cOrdSep+"' AND CB6_FILIAL='"+xFilial("CB6")+"' "
	cQuery += " ORDER BY CB6_VOLUME "

	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

	While (cAlias)->(!Eof())

		RecLock("TRB",.T.)
		TRB->OK 		:= space(2)
		TRB->PEDIDO 	:= (cAlias)->CB6_PEDIDO
		TRB->OS		 	:= (cAlias)->CB6_XORDSE
		TRB->VOLUME		:= Right((cAlias)->CB6_VOLUME,4)
		MsUnlock()

		(cAlias)->(DbSkip())

	Enddo

	(cAlias)->(DbCloseArea())

	@ 001,001 TO 400,700 DIALOG oDlg TITLE OemToAnsi("Volumes")
	@ 030,005 SAY OemToAnsi("Defina os volumes que deseja marcar: ")

	oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{040,001,195,350})
	oBrwTrb:oBrowse:lCanAllmark := .T.
	oBrwTrb:oBrowse:bAllMark := {||MarkAll(cMarca,@oBrwTrb,cAlias,oDlg)}
	Eval(oBrwTrb:oBrowse:bGoTop)
	oBrwTrb:oBrowse:Refresh()

	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,@_aButtons)) Centered VALID _lRetorno

	TRB->(DbGotop())

	If ! CB5SetImp(cLocImp)
		MsgAlert("Local de impressใo "+cLocImp+" nใo cadastrado!!!","Aten็ใo")
		Return
	EndIf

	If _nOpca == 1
		Do While TRB->(!Eof())
			If !Empty(TRB->OK)//se usuario marcou o registro

				CB6->(DbSetorder(1))
				CB6->(DbSeek(xFilial('CB6')+TRB->OS+TRB->VOLUME))

				If Empty(CB6->CB6_XPESO)
					MsgAlert("Volume: "+TRB->VOLUME+"em aberto, nใo poderแ ser impresso!!!","Aten็ใo")
				Else
					If ExistBlock("IMG05")
						ExecBlock("IMG05",,,{TRB->OS+TRB->VOLUME,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
						MSCBCLOSEPRINTER()
					EndIf
				EndIf

				//			aAdd(_aEmpMigr,{TRB->VOLUME})
			EndIf
			TRB->(DbSkip())
		EndDo
	Endif

	//fecha area de trabalho e arquivo temporแrio criados
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
		Ferase(_cArqEmp+OrdBagExt())
	Endif

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TemNota	 บAutor  ณRenato	 		 บ Data ณ  20/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChecar se existe nota gerada para o item da embalagem       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _TemNota(_numPed,_numItem,_numOS)

	Local lRet	:= .F.

	DbSelectArea("SC9")
	SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	SC9->(DbSeek(xFilial("SC9")+_numPed+_numItem))
	While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_ORDSEP == xFilial("SC9")+_numPed+_numItem+_numOS)
		If !Empty(SC9->C9_NFISCAL)
			lRet	:= .T.
		EndIf
		SC9->(DbSkip())
	EndDo

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TemNota	 บAutor  ณRenato	 		 บ Data ณ  20/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChecar se existe nota gerada para o item da embalagem       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STDUPLIORD(_xOrdSep)

	Local _aAreacb8 := CB8->(GetArea())
	Local lRet	    := .F.
	Local cQuery    := ' '
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'TMPCB8'+cHora+ cMinutos+cSegundos

	cQuery := " SELECT *
	cQuery += " FROM "+RetSqlName("CB8")+" CB8 "
	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("CB8")+" )TB8 "
	cQuery += " ON TB8.CB8_ORDSEP = CB8.CB8_ORDSEP
	cQuery += " AND TB8.D_E_L_E_T_ =  ' '
	cQuery += " AND TB8.CB8_PROD = CB8.CB8_PROD
	cQuery += " AND TB8.CB8_ITEM <> CB8.CB8_ITEM
	cQuery += " AND TB8.CB8_FILIAL= '"+xFilial("CB8")+"'"
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' '
	cQuery += " AND CB8.CB8_ORDSEP = '"+_xOrdSep+"'"
	cQuery += " AND   CB8.CB8_FILIAL= '"+xFilial("CB8")+"'"

	//SELECT * FROM CB8010 CB8 INNER JOIN(SELECT * FROM CB8010 ) TB8 ON TB8.CB8_ORDSEP = CB8.CB8_ORDSEP AND TB8.D_E_L_E_T_ = ' ' AND TB8.CB8_PROD = CB8.CB8_PROD AND TB8.CB8_ITEM <> CB8.CB8_ITEM AND TB8.CB8_FILIAL= '01'  WHERE  CB8.D_E_L_E_T_ = ' ' AND CB8.CB8_ORDSEP = '018273' AND CB8.CB8_FILIAL= '01'
	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())
			lRet:= .T.
			(cAliasLif)->(DbSkip())
		End
	EndIf

	RestArea(_aAreacb8)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  STORDDUPLGrv	 บAutor  ณRenato	 		 บ Data ณ  20/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChecar se existe nota gerada para o item da embalagem       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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

		CB9->(DbSetorder(8))
		CB9->(DbGoTo(aRecCB9[nX]))

		CB8->(DbSetOrder(4))
		CB8->(DbSeek(xFilial("CB8")+CB9->(CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTSUG+CB9_SLOTSU+CB9_NUMSER)))

		nSaldoEmb := CB9->CB9_QTEEMB

		If CB9->(DbSeek(CB9->CB9_FILIAL+CB9->CB9_ORDSEP+CB9->CB9_PROD+Space(10)+Space(6)+Space(20)+Space(10)+CB9->CB9_ITESEP))
			CB9->(RecLock("CB9",.F.))
			CB9->CB9_QTESEP += nSaldoEmb
			CB9->(MsUnlock())

			lAchouCB9 := .T.
		EndIf

		CB9->(DbGoTo(aRecCB9[nX]))
		CB9->(RecLock("CB9",.F.))
		If lAchouCB9
			CB9->(DbDelete())
		Else
			CB9->CB9_VOLUME := ""
			CB9->CB9_QTEEMB := 0
			CB9->CB9_CODEMB := ""
			CB9->CB9_LOTECT := ""
			CB9->CB9_STATUS := "1"  // Em Aberto
		EndIf
		CB9->(MsUnlock())

		CB8->(RecLock("CB8",.F.))
		CB8->CB8_SALDOE += nSaldoEmb
		CB8->(MsUnlock())
	Next

	If lDelCB9
		CB6->(DbSetorder(1))
		CB9->(DbSetorder(4))
		If !CB9->(DbSeek(xFilial("CB9")+cVolume))
			If CB6->(DbSeek(xFilial("CB6")+cVolume))
				CB6->(RecLock("CB6",.F.))
				CB6->(DbDelete())
				CB6->(MsUnlock())
			EndIf
		EndIf

		CB7->(DbSetorder(1))
		If CB7->(DbSeek(xFilial("CB7")+cOrdSep))
			CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
			CB7->(Reclock('CB7',.F.))
			If !CB6->(DbSeek(xFilial('CB6')+cOrdSep))
				CB7->CB7_STATUS := "2"  // Sep.Final
			Else
				CB7->CB7_STATUS := "3"  // Embalando
			EndIf
			CB7->(MsUnLock())
		EndIf

		MsgInfo("Itens excluํdos com sucesso.","OK")
	EndIf

Return
	/*====================================================================================\
	|Programa  | STEMB30             | Autor | GIOVANI.ZAGO          | Data | 30/07/2014  |
	|=====================================================================================|
	|Descri็ใo |  Retorna volume			                                              |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STEMB30                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/

	*---------------------------*
Static Function STEMB30(_cVol)
	Local _nRet30    := 0
	Local _aArea     := GetArea()
	Local cAliasLif  := 'TMPB30VOL'
	Local cQuery     := ' '

	cQuery := "  SELECT
	cQuery += " sum(CB9.CB9_QTEEMB)
	cQuery += ' as "CB9_QTEEMB"
	cQuery += " FROM "+RetSqlName("CB9")+" CB9 "
	cQuery += " WHERE CB9.D_E_L_E_T_ = ' '
	cQuery += " AND CB9.CB9_VOLUME = '"+_cVol+"'"
	cQuery += " AND CB9.CB9_FILIAL = '"+xFilial("CB9")+"'"


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())

			_nRet30+= (cAliasLif)->CB9_QTEEMB

			(cAliasLif)->(DbSkip())
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	RestArea(_aArea)
Return(_nRet30)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTAVALET	บAutor  ณRenato Nogueira     บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ajustar padrใo de etiqueta					  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cEtiqueta                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ cEtiqueta                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STAVALET(_cEtiqueta)

	Local _cEan, _nQtde, _cOrdem
	Local _aAreaSB1	:= SB1->(GetArea())
	Local _cNewEtiq	:= ""
	Local cLote		:= Space(10)
	Local aSave
	Local clinha	:= ""
	Local npos		:= 0
	Local _nCount	:= 0

	If SubStr(AllTrim(_cEtiqueta),1,2)=="02" .And. SubStr(AllTrim(_cEtiqueta),17,2)=="37" .And. SubStr(AllTrim(_cEtiqueta),26,2)=="10" //Etiqueta col๔mbia

		_cEan	:= CVALTOCHAR(Val(SubStr(AllTrim(_cEtiqueta),3,14)))
		_nQtde	:= Val(SubStr(AllTrim(_cEtiqueta),19,7))
		_cOrdem	:= SubStr(AllTrim(_cEtiqueta),28,10)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(5)) //B1_FILIAL+B1_CODBAR
		SB1->(DbGoTop())

		If SB1->(DbSeek(xFilial("SB1")+_cEan))
			_cNewEtiq	+= AllTrim(SB1->B1_COD)+"|"
			_cNewEtiq	+= _cOrdem+"|"
			_cNewEtiq	+= CVALTOCHAR(_nQtde)
		Else
			ApMsgAlert("Aten็ใo, codigo nao encontrado atraves do EAN13, verifique!")
			Return
		EndIf

	EndIf

	If IsTelNet() //Chamado 002854
		clinha:=_cEtiqueta
		While (npos := at("|",clinha) ) > 0
			_nCount++
			clinha:= substr(clinha,npos+1,len(clinha))
		End

		If _nCount<=1
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbGoTop())
			If SB1->(DbSeek(xFilial("SB1")+StrTran(AllTrim(_cEtiqueta),"|","")))
				/*
				aSave := VTSAVE()
				VtClear()
				@ 1,0 VtSay "Informe o "
				@ 2,0 VtSay "lote:"
				@ 3,0 VTGet cLote pict "@!"
				VTRead
				VtRestore(,,,,aSave)
				*/
				_cNewEtiq	+= AllTrim(SB1->B1_COD)+"|"
				_cNewEtiq	+= cLote+"|"
				_cNewEtiq	+= CVALTOCHAR(0)

			EndIf
		EndIf
	EndIf

	If Empty(_cNewEtiq)
		_cNewEtiq	:= _cEtiqueta
	EndIf

	RestArea(_aAreaSB1)

Return(_cNewEtiq)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCHKCB8	บAutor  ณRenato Nogueira     บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina ajustar saldo quando existem dois produtos 		  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cEtiqueta                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ cEtiqueta                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STCHKCB8(_cOrdSep)

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	:= " SELECT FILIAL, ORDSEP, TOTALOS, TOTALCB8EMB "
	cQuery1	+= " ,(SELECT SUM(CB9_QTEEMB) FROM "+RetSqlName("CB9")+" B9 WHERE B9.D_E_L_E_T_=' ' "
	cQuery1	+= " AND CB9_FILIAL=FILIAL AND CB9_ORDSEP=ORDSEP) TOTALCB9EMB "
	cQuery1	+= " FROM ( "
	cQuery1	+= " SELECT CB8_FILIAL FILIAL, CB8_ORDSEP ORDSEP, SUM(CB8_QTDORI) TOTALOS, SUM(CB8_SALDOE) TOTALCB8EMB "
	cQuery1	+= " FROM "+RetSqlName("CB8")+" B8 "
	cQuery1	+= " WHERE B8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+cFilAnt+"' AND CB8_ORDSEP='"+_cOrdSep+"' "
	cQuery1	+= " GROUP BY CB8_FILIAL, CB8_ORDSEP ) "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->TOTALOS==(cAlias1)->TOTALCB9EMB

		cQuery1 := " UPDATE "+RetSqlName("CB8")+" CB8 "
		cQuery1 += " SET CB8_SALDOE=0 "
		cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+cFilAnt+"' AND CB8_ORDSEP='"+_cOrdSep+"' "

		nErrQry := TCSqlExec( cQuery1 )

		If nErrQry <> 0
			Conout('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
		EndIf

	EndIf

Return

Static Function ReplVol(lInclui,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,lReplVol,oLbxItem,aVolItem)
	Local aParambox	:= {}
	Local aRet		:= {}
	Local nRepl		:= 0

	Private lAborRepl	:= .F.

	nVolRepl		:= 0

	aAdd(aParamBox,{1,"Qtde Volumes deseja replicar",nVolRepl,"999999", '!Empty(mv_par01)', "", "" , 0  , .F. })
	Do While .T.
		If ! ParamBox(aParamBox,"Replicar Volumes",@aRet,,,,,,,,.f.)
			Return(0)
		Endif
		nVolRepl := aRet[1]
		If ! MsgYesNo("Confirma a replica็ใo de " + Alltrim(Str(nVolRepl)) + " Volume(s) ?")
			Return(0)
		Endif
		Exit
	EndDo
	If ! Empty(nVolRepl)
		For nRepl := 1 to nVolRepl
			ManuVol(.t.,oLbxVol,aVolumes,cOrdSep,oTotPeso,oTotVol,lTelaPri,oDescImp,oStatus,cPedido,oNomeSep,oCubag,.T.,oLbxItem,aVolItem)
			If lAborRepl
				Exit
			EndIf
		Next nRepl
	EndIf

Return()

/*/{Protheus.doc} GETVOLUM
@name GETVOLUM
@type Static Function
@desc retornar faixa de volumes
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GETVOLUM(_cMarcou)

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _aAreaTRB		:= TRB->(GetArea())

	AADD(_aParamBox,{1,"Volume de:",Space(4),"","","","",0,.F.})
	AADD(_aParamBox,{1,"Volume ate:",Space(4),"","","","",0,.F.})

	If ParamBox(_aParamBox,"Sele็ใo de volumes",@_aRet,,,.T.,,500)

		TRB->(DbGoTop())

		While TRB->(!Eof())

			If AllTrim(TRB->VOLUME)>=AllTrim(MV_PAR01) .And. AllTrim(TRB->VOLUME)<=MV_PAR02
				TRB->(RecLock("TRB",.F.))
				TRB->OK := _cMarcou
				TRB->(MsUnLock())
			EndIf

			TRB->(DbSkip())
		EndDo

	EndIf

	RestArea(_aAreaTRB)

Return()

/*/{Protheus.doc} ARSTETQ01

Etiquetas de Cientes

@type function
@author Everson Santana
@since 15/06/18
@version Protheus 12 - Stock/Costos

@history , ,

/*/

Static Function ARFSFAQ1(cVar)

	Local cPorta 	:= "LPT1"
	LOCAL cDoc 		:= cVar
	LOCAL nQuant  	:= space(16)
	Local _cQuery   := ""
	Local _cQuery1	:= ""
	Local n := 0

	_cQuery1 += " SELECT DISTINCT CB6_XORDSE OS,(SELECT COUNT(*) FROM " + RetSqlName("CB6") +" CB6 WHERE   CB7_ORDSEP = CB6_XORDSE "
	_cQuery1 += " AND CB6.CB6_FILIAL = '" + xFilial("CB6") + "' AND  CB6.D_E_L_E_T_ = ' ' ) "
	_cQuery1 += " SOMA "
	_cQuery1 += " FROM " + RetSqlName("CB7") + " CB7 "
	_cQuery1 += " INNER JOIN(SELECT * FROM " + RetSqlName("CB6") +" )CB6 "
	_cQuery1 += " ON   CB7_ORDSEP = CB6_XORDSE AND  CB6.D_E_L_E_T_ = ' ' AND CB6.CB6_FILIAL = '"+ xFilial("CB6") + "' "
	_cQuery1 += " WHERE CB7.D_E_L_E_T_ = ' '  AND CB7.CB7_FILIAL = '" + xFilial("CB7") + "' "
	_cQuery1 += " AND CB7.CB7_NOTA     = '" + cDoc + "' "
	_cQuery1 += " AND CB7.CB7_SERIE    = 'R' "

	If Select("QRY1") > 0
		Dbselectarea("QRY1")
		QRY1->(DbClosearea())
	EndIf

	TcQuery _cQuery1 New Alias "QRY1"

	nQuant := QRY1->SOMA


	_cQuery += " SELECT F2.F2_EMISSAO,F2.F2_CLIENTE,A1.A1_NOME,F2.F2_LOJA,F2.F2_HORA,F2.F2_TRANSP,A4.A4_NOME,A1.A1_END,A1.A1_EST,A1.A1_MUN,F2.F2_PBRUTO,F2.F2_VALBRUT,F2.F2_DOC,F2.F2_SERIE "
	_cQuery += "  FROM " + RetSqlName("SF2") + " F2 "
	_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " A1 "
	_cQuery += "  ON A1.A1_COD = F2.F2_CLIENTE "
	_cQuery += " AND A1.A1_LOJA = F2.F2_LOJA "
	_cQuery += " AND A1.D_E_L_E_T_ = ' ' "
	_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " A4 "
	_cQuery += " ON A4.A4_COD = F2.F2_TRANSP "
	_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
	_cQuery += " WHERE F2.F2_DOC = '"+cDoc+"' "
	_cQuery += " AND F2.F2_SERIE = 'R' "
	_cQuery += " AND F2.D_E_L_E_T_ = ' ' "
	_cQuery += " Order By F2.F2_EMISSAO, F2.F2_HORA "

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery _cQuery New Alias "QRY"

	dbSelectArea("QRY")
	QRY->(dbGoTop())

	If !Empty(QRY->F2_DOC)

		MSCBPRINTER("ELTRON",cPorta,,,.F.)

		MSCBLOADGRF("STECK1.PCX")

		For n:= 1 To nQuant

			MSCBBEGIN(1,6) //124.5 Tamanho da etiqueta

			MSCBGRAFIC(02,01,"STECK1")

			//_nTam := AT( " ", QRY->A1_NOME )

			MSCBSAY(20,05, Substring(Alltrim(QRY->A1_NOME),1,20),"N","4","2,2")
			MSCBSAY(20,15, Substring(Alltrim(QRY->A1_NOME),21,40),"N","4","2,2")//Ticket 20190821000027
			MSCBSAY(20,25, Substring(Alltrim(QRY->A1_EST+"/"+QRY->A1_MUN),21,40),"N","4","2,2") //Ticket 20190821000027
			MSCBSAY(20,40, "Remito: "+Alltrim(QRY->F2_DOC),"N","4","2,2")
			MSCBSAY(20,50, "Bulto: "+StrZero(n,2)+"/"+StrZero(nQuant,2),"N","4","3,3")

			MSCBEND()

		Next n

		MSCBCLOSEPRINTER()

	EndIf

	//_lConf := .F.

	//EndIF

RETURN

Static Function VisPed(cPedido)

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cPedido))
		A410Visual("SC5",SC5->(Recno()),2)
	EndIf

Return()
