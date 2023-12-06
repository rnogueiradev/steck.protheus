#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | STINFEMB        | Autor | RENATO.NOGUEIRA           | Data | 06/10/2015  |
|=====================================================================================|
|Descrição | Informações de embarque do pedido					                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STINFEMB                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STINFEMB()
	Local _nX:=1
	Local nY := 1
	Private _aCamposEdit	:= {}
	Private lSaida   		:= .T.
	Private oDlg
	Private oGet
	Private _aCols			:= {}
	Private _aStruTrb		:= {}
	Private lConfirma		:= .F.
	Private bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oDlg:End()) }
	Private bCancel 	  	:= {||(	lSaida:=.f.,oDlg:End()) }
	Private aButtons	  	:= {}
	Private _cReserva		:= Space(13)
	Private _cNavio			:= Space(40)
	Private _cViagem		:= Space(15)
	Private _cPorOrig		:= Space(30)
	Private _cPorDest		:= Space(30)
	Private _dEtd			:= Space(8)
	Private _cPaisD			:= Space(20)
	Private _cDeadL			:= Space(50)
	Private _cVia			:= Space(20)
	Private _cPeso			:= Space(30)
	Private _cCubag			:= Space(30)
	Private _cQuant			:= Space(30)
	Private oFontN  		:= TFont():New('Arial',,-16,.T.)
	Private _lVazio			:= .T.
	Private lRet			:= IIf(__cUserId $ GetMv("ST_ROTEMB"),.T.,.F.)
	
	If !Empty(EE7_XRESER)
		_cReserva	:= EE7_XRESER
	EndIf
	If !Empty(EE7_XNAVIO)
		_cNavio	:= EE7_XNAVIO
	EndIf
	If !Empty(EE7_XVIAGE)
		_cViagem	:= EE7_XVIAGE
	EndIf
	If !Empty(EE7_XPORTO)
		_cPorOrig	:= EE7_XPORTO
	EndIf
	If !Empty(EE7_XPORTD)
		_cPorDest	:= EE7_XPORTD
	EndIf
	If !Empty(EE7_XETD)
		_dEtd	:= DTOC(EE7_XETD)
	EndIf
	If !Empty(EE7_XPAISD)
		_cPaisD	:= EE7_XPAISD
	EndIf
	If !Empty(EE7_XDEADL)
		_cDeadL	:= EE7_XDEADL
	EndIf
	If !Empty(EE7_XVIA)
		_cVia	:= EE7_XVIA
	EndIf
	If !Empty(EE7_XPESO)
		_cPeso	:= EE7_XPESO
	EndIf
	If !Empty(EE7_XCUBAG)
		_cCubag:= EE7_XCUBAG
	EndIf
	If !Empty(EE7_XQUANT)
		_cQuant:= EE7_XQUANT
	EndIf
	
	_aCamposEdit := {"DATA","HORA","OBS"}
	
	AADD(_aStruTrb,{"Item"		,"ITEM","@!"		,4		,0,,,"C","","R",})
	AADD(_aStruTrb,{"Data"		,"DATA","@!"		,8		,0,,,"D","","R",})
	AADD(_aStruTrb,{"Hora"		,"HORA","99:99"	,5		,0,,,"C","","R",})
	AADD(_aStruTrb,{"Observação","OBS" ,"@!"		,240	,0,,,"C","","R",BOXOBS()})
	
	cQuery := " SELECT * "
	cQuery += " FROM "+RetSqlName("SZF")+" ZF "
	cQuery += " WHERE ZF.D_E_L_E_T_=' ' AND ZF_FILIAL='"+xFilial("EE7")+"' AND ZF_PEDIDO='"+EE7->EE7_PEDIDO+"' "
	
	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)
	
	While (cAlias)->(!Eof())
		
		_lVazio	:= .F.
		
		AADD(_aCols,Array(Len(_aStruTrb)+1))
		
		For nY := 1 To Len(_aStruTrb)
			
			DO CASE
			CASE AllTrim(_aStruTrb[nY][2]) =  "ITEM"
				_aCols[Len(_aCols)][nY] := (cAlias)->ZF_ITEM
			CASE AllTrim(_aStruTrb[nY][2]) =  "DATA"
				_aCols[Len(_aCols)][nY] := STOD((cAlias)->ZF_DATA)
			CASE AllTrim(_aStruTrb[nY][2]) =  "HORA"
				_aCols[Len(_aCols)][nY] := (cAlias)->ZF_HORA
			CASE AllTrim(_aStruTrb[nY][2]) =  "OBS"
				_aCols[Len(_aCols)][nY] := AllTrim((cAlias)->ZF_OBS)
			ENDCASE
			
		Next ny
		
		_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.
		
		(cAlias)->(DbSkip())
		
	Enddo
	
	If _lVazio
		AADD(_aCols,Array(Len(_aStruTrb)+1))
		For nY := 1 To Len(_aStruTrb)
			DO CASE
			CASE AllTrim(_aStruTrb[nY][2]) =  "ITEM"
				_aCols[Len(_aCols)][nY] := "0001"
			CASE AllTrim(_aStruTrb[nY][2]) =  "DATA"
				_aCols[Len(_aCols)][nY] := DATE()
			CASE AllTrim(_aStruTrb[nY][2]) =  "HORA"
				_aCols[Len(_aCols)][nY] := "00:00"
			CASE AllTrim(_aStruTrb[nY][2]) =  "OBS"
				_aCols[Len(_aCols)][nY] := "PREENCHER AQUI"
			ENDCASE
		Next
		_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.
	EndIf
	
	While lSaida
		
		DEFINE MSDIALOG oDlg FROM 0,0 TO 500,1100 TITLE Alltrim(OemToAnsi('Dados do embarque')) Pixel //430,531
		
		@ 005,001 SAY "Reserva Nr  " SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 004,060 MSGET _cReserva 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 025,001 SAY "Navio " 		 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 024,060 MSGET _cNavio	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 045,001 SAY "Viagem " 	 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 044,060 MSGET _cViagem	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 065,001 SAY "Porto Orig" 	 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 064,060 MSGET _cPorOrig 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		
		@ 005,201 SAY "Porto Dest  " SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 004,260 MSGET _cPorDest 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 025,201 SAY "Etd " 		 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 024,260 MSGET _dEtd	 	 SIZE 55,11 	OF oDlg PIXEL PICTURE "99/99/9999" WHEN lRet
		@ 045,201 SAY "País Dest"	 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 044,260 MSGET _cPaisD	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 065,201 SAY "Deadline" 	 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 064,260 MSGET _cDeadL	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		
		@ 005,401 SAY "Via" 		 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 004,460 MSGET _cVia 		 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 025,401 SAY "Peso" 		 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 024,460 MSGET _cPeso	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 045,401 SAY "Cubagem"		 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 044,460 MSGET _cCubag	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		@ 065,401 SAY "Quantidade" 	 SIZE 55,10 	OF oDlg PIXEL FONT oFontN
		@ 064,460 MSGET _cQuant	 	 SIZE 55,11 	OF oDlg PIXEL WHEN lRet
		
		
		oGet	:= MsNewGetDados():New( 130,  1,  235,550, IIf(lRet,GD_INSERT+GD_DELETE+GD_UPDATE,) ,"AllWaysTrue","AllWaysTrue",,_aCamposEdit,,999,,, ,oDlg, _aStruTrb, _aCols )
		MsNewGetDados():SetEditLine (.T.)
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
		
	EndDo
	
	aCols:= aClone(oGet:aCols)
	
	If lConfirma
		
		EE7->(RecLock("EE7",.F.))
		EE7->EE7_XRESER	:= _cReserva
		EE7->EE7_XNAVIO	:= _cNavio
		EE7->EE7_XVIAGE	:= _cViagem
		EE7->EE7_XPORTO	:= _cPorOrig
		EE7->EE7_XPORTD	:= _cPorDest
		EE7->EE7_XETD		:= CTOD(_dEtd)
		EE7->EE7_XPAISD	:= _cPaisD
		EE7->EE7_XDEADL	:= _cDeadL
		EE7->EE7_XVIA		:= _cVia
		EE7->EE7_XPESO	:= _cPeso
		EE7->EE7_XCUBAG	:= _cCubag
		EE7->EE7_XQUANT	:= _cQuant
		EE7->(MsUnLock())
		
		DbSelectArea("SZF")
		SZF->(DbSetOrder(1))
		SZF->(DbGoTop())
		
		For _nX:=1 To Len(oGet:aCols)
			
			If SZF->(DbSeek(xFilial("EE7")+EE7->EE7_PEDIDO+PADL(_nX,4,"0")))
				SZF->(RecLock("SZF",.F.))
				SZF->ZF_DATA	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "DATA"    })]
				SZF->ZF_HORA	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "HORA"    })]
				SZF->ZF_OBS	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "OBS"    })]
				SZF->(MsUnLock())
			Else
				SZF->(RecLock("SZF",.T.))
				SZF->ZF_FILIAL:= EE7->EE7_FILIAL
				SZF->ZF_PEDIDO:= EE7->EE7_PEDIDO
				SZF->ZF_ITEM	:= PADL(_nX,4,"0")
				SZF->ZF_DATA	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "DATA"    })]
				SZF->ZF_HORA	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "HORA"    })]
				SZF->ZF_OBS	:= oGet:aCols[_nX][aScan(_aStruTrb, { |x| Alltrim(x[2]) == "OBS"    })]
				SZF->(MsUnLock())
			EndIf
			
		Next
		
		MsgAlert("Embarque atualizado com sucesso")
		
	EndIf
	
Return()

Static Function BOXOBS()
	
	Local _cCombo := "1=Aguardando reserva do pedido;"+;
		"2=Aguardando packing list (peso e volume);"+;
		"3=Aguardando dados do agente de cargas;"+;
		"4=Aguardando cotação de frete;"+;
		"5=Aguardando emissão de NF;"+;
		"6=Finalizando documentação de embarque;"+;
		"7=Coleta agendada;"+;
		"8=Exceção de coleta da mercadoria;"+;
		"9=Exceção de atraso do embarque: Motivo – Tempo/clima;"+;
		"10=Exceção de atraso do embarque: Motivo – Embarque não autorizado pelo cliente;"+;
		"11=Embarque finalizado: Mercadoria no destino"
	
Return(_cCombo)

Static Function GETOBS(_cObs)
	
	Do Case
	Case AllTrim(_cObs)=="1"
		_cCombo := "1=Aguardando reserva do pedido"
	Case AllTrim(_cObs)=="2"
		_cCombo := "2=Aguardando packing list (peso e volume)"
	Case AllTrim(_cObs)=="3"
		_cCombo := "3=Aguardando dados do agente de cargas"
	Case AllTrim(_cObs)=="4"
		_cCombo := "4=Aguardando cotação de frete"
	Case AllTrim(_cObs)=="5"
		_cCombo := "5=Aguardando emissão de NF"
	Case AllTrim(_cObs)=="6"
		_cCombo := "6=Finalizando documentação de embarque"
	Case AllTrim(_cObs)=="7"
		_cCombo := "7=Coleta agendada"
	Case AllTrim(_cObs)=="8"
		_cCombo := "8=Exceção de coleta da mercadoria"
	Case AllTrim(_cObs)=="9"
		_cCombo := "9=Exceção de atraso do embarque: Motivo – Tempo/clima"
	Case AllTrim(_cObs)=="10"
		_cCombo := "10=Exceção de atraso do embarque: Motivo – Embarque não autorizado pelo cliente"
	Case AllTrim(_cObs)=="11"
		_cCombo := "11=Embarque finalizado: Mercadoria no destino"
	EndCase
	
Return(_cCombo)
