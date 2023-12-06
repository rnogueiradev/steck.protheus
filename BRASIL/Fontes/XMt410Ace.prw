#include 'Protheus.ch'
#include 'RwMake.ch'

#DEFINE CL CHR(13)+CHR(10)

/*====================================================================================\
|Programa  | Mt410Ace         | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  P.E alteração do Pedido											      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | Mt410Ace                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function Mt410Ace()
	*---------------------------------------------------*
	Local Aarea      := Getarea()
	Local cVendNew   := space(50)
	Local lContinua  := .T.
	Local nOpc       := PARAMIXB [1]
	Local oDlgEmail
	Local _lVen 	 := GetMv("ST_TMKI80",,.T.)
	Local _aGrupos
	Local _cAltPed01 := SuperGetMV("ST_GRPPCP ",.F.,"000000","000141")
	Local _cAltPed02 := SuperGetMV("ST_GRPPLAN",.F.,"000000","000141")
	Local _cMKT 	 := GetMv("ST_ACEMKT",,'000199')

// GIOVANI ZAGO 19/02/2020 AJUSTE PARA O MKT ALTERAR PEDIDO DE FEIRA.
	If __cUserId $ _cMKT
		Return(.T.)
	EndIf

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If _aGrupos[1][10][1] $ GetMv("ST_GRPBENE") .And. !(SC5->C5_TIPO=="B")
			MsgAlert("Atenção, esse grupo de usuário só pode alterar pedidos de beneficiamento!")
			Return(.F.)
		EndIf

		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))

		//If cFilAnt = '01' .And. nOpc <> 2 .And. SA3->(dbSeek(xFilial('SA3')+RetCodUsr())) .And. !Empty(Alltrim(SA3->A3_SUPER))

		If nOpc <> 2

			SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))

			//Chamado 002457
			If (SA3->(dbSeek(xFilial('SA3')+RetCodUsr()))) .And. (SC5->C5_TIPO=="N")
				lContinua := .T.
			ElseIf !(SA3->(dbSeek(xFilial('SA3')+RetCodUsr()))) .And. !(SC5->C5_TIPO=="N")
				lContinua := .T.
				//Chamado 002300
			ElseIf _aGrupos[1][10][1] $ _cAltPed01 .And. (SC5->C5_CLIENTE = '033467' .And. SC5->C5_LOJACLI = '01') .And. cEmpAnt == '03'//STECK MANAUS
				lContinua := .T.
				//Chamado 002536
			ElseIf _aGrupos[1][10][1] $ _cAltPed02 .And. (SC5->C5_CLIENTE = '033467' .And. SC5->C5_LOJACLI = '02') .And. (cEmpAnt == '03' .or. cEmpAnt == '01')
				lContinua := .T.
			ElseIf _aGrupos[1][10][1] $ GetMv('ST_ACEEXP',,'000141/000000/000036')
				lContinua := .T.
			ElseIf	cEmpAnt == '03' .And. RetCodUsr() = '000366'
				lContinua := .T.
			ElseIf SC6->C6_OPER $ GetMv("STOPERMKT",,"20#21")
				lContinua := .T.
			ElseIf SC5->C5_FILIAL=="04" .Or. SC5->C5_FILIAL=="05"
				lContinua := .T.
			Else
				lContinua := .F.
				MsgInfo("Usuário sem Acesso a Realizar Alteração de Pedido de Venda...!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
				"Favor Verificar...!!! (mt410ace)")
			Endif
		Endif

		If lContinua
			//Else
			//IF nOpc == 4 // Alterar
			If IsInCallStack('U_STFAT15') .Or. nOpc == 4
				/*
				DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Motivo Da Alteração") From 1,0 To 16,25 OF oMainWnd

				@ 05,04 SAY "Motivo:" PIXEL OF oDlgEmail
				@ 15,04 MSGet cVendNew 	  Size 55,012  PIXEL OF oDlgEmail Valid  Empty(cVendNew)
				//@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail


				@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
				@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


				nOpca:=0

				ACTIVATE MSDIALOG oDlgEmail CENTERED

				If nOpca == 1

				lContinua:= .t.
				Else
				lContinua:= .f.

				Endif
				*/
If SC5->C5_ZFATBLQ = '1' .And. lContinua
	lContinua:=.F.
	msgiNFO("Pedido de Venda Faturado Totalmente....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
		"O mesmo não poderá ser Alterado....!!!!!!")
Endif

If ('XXXX' $ SC5->C5_NOTA).And.(SC5->C5_ZFATBLQ $ '1/2') .And. lContinua
	lContinua:=.F.
	msgiNFO("Pedido de Venda Eliminado por Resíduo (Saldo)....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
		"O mesmo não poderá ser Alterado....!!!!!!")
Endif

If ('XXXX' $ SC5->C5_NOTA) .And. (SC5->C5_ZFATBLQ = '3' .Or. Empty(Alltrim(SC5->C5_ZFATBLQ))) .And. lContinua
	lContinua:=.F.
	msgiNFO("Pedido de Venda Cancelado....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
		"O mesmo não poderá ser Alterado....!!!!!!")
Endif


If lContinua
	DbSelectArea('SC6')
	SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM

			SC6->(RecLock("SC6",.F.))
			SC6->C6_ZB2QATU :=  u_versaldo(SC6->C6_PRODUTO)
			//SC6->C6_ENTRE1  :=  u_atudtentre(SC6->C6_ZB2QATU,SC6->C6_PRODUTO,SC6->C6_QTDVEN)
			SC6->C6_ZRESERV :=  Posicione("PA2",4,xFilial("PA2")+SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,"PA2_QUANT")
			SC6->(MsUnlock())
			SC6->( DbCommit() )


			dbSelectArea("SC9")
			SC9->(	dbSetOrder(1) )
			If	SC9->(dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))

				If !Empty (SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
					lContinua:=.F.
				EndIf
			EndIf
			SC6->(DbSkip())

		End
	Endif
	If !	lContinua
		Msginfo("Pedido de Venda em Separação pela Expedição....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			"Não será possível alterar o mesmo até a emissão da Nota Fiscal....!!!!!!")
	EndIf

Endif

If Empty(SC5->C5_ZFATBLQ) .And. lContinua

	SC5->(RecLock("SC5",.F.)) // GIOVANI ZAGO ERRO VIRADA 16/10/2017 COLOQUEI O RECLOCK
	SC5->C5_ZFATBLQ := '3'
	SC5->C5_ZDTREJE := CTOD('  /  /    ')
	SC5->C5_ZMOTREJ := ' '
	SC5->(MsUnlock())
	SC5->( DbCommit() )

Endif

//Giovani Zago 06/05/14  bloquear vendedor externo de alterar cotação digitada pelo interno
If lContinua  .And. _lVen
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cUserId))
		If Alltrim(SA3->A3_COD) $ 'R00268/R00269/R00152/R00192/R00196/R00261/R00262/R01910/R01911'

			If Alltrim(SA3->A3_COD) $ 'R00268/R00269'
				If !(Alltrim(SC5->C5_VEND2)  $ 'R00268/R00269' .Or. Empty(Alltrim(SC5->C5_VEND2)))
					_lRet := .F.
					MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2 ,"A3_NOME") )
				EndIf
			ElseIf Alltrim(SA3->A3_COD) $ 'R00152/R00192/R00196'
				If !(Alltrim(SC5->C5_VEND2)  $ 'R00152/R00192/R00196' .Or. Empty(Alltrim(SC5->C5_VEND2)))
					_lRet := .F.
					MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2 ,"A3_NOME") )
				EndIf
			ElseIf Alltrim(SA3->A3_COD) $ 'R00261/R00262'
				If !(Alltrim(SC5->C5_VEND2)  $ 'R00261/R00262' .Or. Empty(Alltrim(SC5->C5_VEND2)))
					_lRet := .F.
					MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2 ,"A3_NOME") )
				EndIf
			ElseIf Alltrim(SA3->A3_COD) $ 'R01910/R01911'
				If !(Alltrim(SC5->C5_VEND2)  $ 'R01910/R01911' .Or. Empty(Alltrim(SC5->C5_VEND2)))
					_lRet := .F.
					MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2 ,"A3_NOME") )
				EndIf


			EndIf


		Else
			If SA3->A3_TPVEND <> 'I'
				If !(SC5->C5_VEND2 = SA3->A3_COD .Or. Empty(Alltrim(SC5->C5_VEND2)))
					_lRet := .F.
					MsgInfo("Favor entrar em contato com o vendedor: "+Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2 ,"A3_NOME") )
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
Endif
Endif
Endif

restarea(Aarea)
Return(lContinua)




User Function  versaldo(_nPosProd)

	Local nSaldo           := 0
	Local aRetArray        := {}
	Local i
	Local _cArmVen      := GetMv("ST_ARMVEN",,"01/03")

	aRetArray:=aclone(U_STFSVE50(_nPosProd,,,.T.))

	If aRetArray <> NIL

		FOR i:=1 TO LEN(aRetArray)
			If Alltrim(aRetArray[i,2] )  $ _cArmVen
				nSaldo+=aRetArray[i,3]
			EndIf
		NEXT i

	EndIf
Return (nSaldo)


USER FUNCTION atudtentre(nSaldo,cProd,_nQuant,cNum,cItem)
	LOCAL _nDow      := 0
	LOCAL nDiasGrp 	 := 0
	LOCAL nDias		   := 0
	LOCAL dtEntre  	 := dDatabase
	LOCAL _lContinua := .T.
	LOCAL _nPosDEnt  := 0
	LOCAL _nPosProd  := 0
	LOCAL _aArea     := GetArea()
	LOCAL aDtEntre   :={}
	LOCAL nPrecisa   :=0
	LOCAL NX         :=0
	LOCAL cMsg       :=""
	LOCAL nPos       :=0
	LOCAL _dData     :=CTOD('  /  /  ')
	LOCAL _dData1    :=CTOD('  /  /  ')
	LOCAL dDataCalc  :=CTOD('  /  /  ')
	PRIVATE  _dRet	 := dDatabase

    Default cNum :=""
	Default cItem:=""

	/***********************************************************************************************************************
	<<<ALTERAÇÃO>>>
	ação.........: Tratamento para a atualização de data de Entrega do produto
	.............: Se o Orçamento ou o Pedido de Venda estiverem com a data de Enterega Programada preenchida não deixa alterar 
	.............: a data de enterga.
	Campos.......: UA_XDTENPR - Orçamento
	.............: C5_XDTENPR - Pedido de Venda
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 11/05/2022
	Chamado......: 20220429009114 - Oferta Logística
	***********************************************************************************************************************/
	
	nPrecisa:=_nQuant

	
	IF IsInCallStack("U_STFSVE47") = .T. .AND. ! IsInCallStack("U_STREST11")
		IF !EMPTY(SUA->UA_XDTENPR)
			_nPosDEnt := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_DTENTRE"})
			dtEntre := aCols[n,_nPosDEnt]
			_lContinua := .F.
		ENDIF
			_nPosProd := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "UB_PRODUTO"})
	ENDIF

	IF IsInCallStack("MATA410") = .T.
		IF !EMPTY(SC5->C5_XDTENPR)
			_nPosDEnt := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "C6_ENTREG"})
			dtEntre := aCols[n,_nPosDEnt]
			_lContinua := .F.
		ENDIF
			_nPosProd := aScan(aHeader, {|x|Upper(AllTrim(x[2])) == "C6_PRODUTO"})
	ENDIF


	/********************************************
	Veriável de controle para verificar se pode ou não alterar as datas de enterga 
	tanto no Pedido de Venda como no Orçamento
	********************************************/
	IF _lContinua = .T.

		nDias    := GETMV("ST_DIASALD",,2) 	// Parametro para acrescimo de dias com Saldo //GIOVANI ZAGO 01/03/13

		If cEmpAnt=="04"//giovani zago

			nDiasGrp:= u_STLDGRUP(cProd)
			//nDias += nDiasGrp
			_nDow:= DOW(DDATABASE)
			If _nDow = 6
				nDias+=2
			ElseIf _nDow = 7
				nDias+=1
			Endif
			dtEntre:=DataValida(dDataBase + nDias, .T.)

		ElseIf cEmpAnt=="01" .And. cFilAnt=="05"

			nDiasGrp := u_STLDGRUP(cProd)

			If IsInCallStack("U_STFAT470")
				dtEntre	 := DataValida(SC5->C5_EMISSAO + nDiasGrp , .T.)
			Else
				dtEntre	 := DataValida(dDataBase + nDiasGrp , .T.)
			EndIf

		Else
			/*****************
			Produto com Estoque
			*****************/
			IF _nQuant <= nSaldo    	// Com Saldo - Soma a Database + Conteúdo do Parâmetro
				////dtEntre:=DataValida(dDataBase + nDias, .T.)
				dtEntre:=DataValida((DATE()), .T.)
			    aadd(aDtEntre,{dtEntre,_nQuant,'1SD'} )
				//ELSEIF Getmv("ST_410ACE",,.F.) .And.  PREVDISTRI(cProd,_nQuant)
			    //	dtEntre:= _dRet
				////dtEntre:=DataValida(dtEntre + nDias, .T.)
			    //	dtEntre:=DataValida(_dRet, .T.)			
			    /*****************
			    Produto SEM Estoque 
			    *****************/
			    //ElseIf Getmv("ST_410ACE",,.F.) .And.  PREVDISTRI(cProd,_nQuant)
			ELSEIF _nQuant > nSaldo
                 
				IF nSaldo>0
				   aadd(aDtEntre,{dtEntre,nSaldo,'1SD'} )
				   //aadd(aDtEntre,{DataValida((DATE()), .T.),nSaldo} )
				   nPrecisa-=nSaldo
				ENDIF    
				
				//Embarques comex
				cQuery := " SELECT ZA6.R_E_C_N_O_ ZA6REC, ZA6_QUANT-ZA6_CONSUM ZA6SALDO, C7_NUM, ZA6_DATA
				cQuery += " FROM "+RetSqlName("ZA6")+" ZA6
				cQuery += " LEFT JOIN "+RetSqlName("SC7")+" C7
				cQuery += " ON C7_FILIAL=ZA6_FILIAL AND C7_PO_EIC=ZA6_PO AND C7_ITEM=ZA6_ITEM
				cQuery += " WHERE ZA6.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' ' AND ZA6_QUANT-ZA6_CONSUM>0 
				cQuery += " AND ZA6_PROD='"+cProd+"' "
				cQuery += " AND C7_QUANT-C7_QUJE>0
				cQuery += " AND C7_RESIDUO=' ' 
				cQuery += " ORDER BY ZA6_DATA

		  		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)

				dtEntre := STOD("")
				IF !EMPTY(TSC7->ZA6_DATA) .AND. TSC7->ZA6SALDO >= _nQuant
					dtEntre := STOD(TSC7->ZA6_DATA)
					dtEntre := DataValida(STOD(TSC7->ZA6_DATA), .T.)
					//nPrecisa:=0
				ENDIF

				IF nPrecisa > 0 .and. !EMPTY(cNUm)// Não achou a data vai buscar datas dos importados. 
				   TSC7->(DBgotop())   
				   While ! TSC7->(Eof())
				      //_dData1:=IIF(STOD(TSC7->ZA6_DATA)<Date(),DTOS(DATE()),TSC7->ZA6_DATA)
					  _dData1:=TSC7->ZA6_DATA
					  IF nPrecisa > TSC7->ZA6SALDO
                         nPos:=aScan(aDtEntre, {|x|x[3]+DTOS(x[1]) = '2PO'+_dData1 })						 
						 IF nPos<>0
						    aDtEntre[nPos,2]+=TSC7->ZA6SALDO
						 ELSE 
						    aadd(aDtEntre,{STOD(TSC7->ZA6_DATA),TSC7->ZA6SALDO,'2PO'} )
						 ENDIF	
						 nPrecisa-=TSC7->ZA6SALDO
				      ELSE 
                         nPos:=aScan(aDtEntre, {|x|x[3]+DTOS(x[1]) = '2PO'+_dData1 })						 
						 IF nPos<>0
						    aDtEntre[nPos,2]+=TSC7->ZA6SALDO
						 ELSE 
						    aadd(aDtEntre,{STOD(TSC7->ZA6_DATA),TSC7->ZA6SALDO,'2PO'} )
						 ENDIF	
						 nPrecisa:=0
						 exit
					  ENDIF		 
				      TSC7->(dbskip())
				   ENDDO 
                ENDIF				   	  

				TSC7->(DBCLOSEAREA())

				If !Empty(dtEntre)
					RestArea(_aArea)
					Return(dtEntre)
				EndIf

				cQuery := " SELECT C7.C7_NUM,C7.R_E_C_N_O_ SC7REC, C7_PRODUTO, C7_QUANT-C7_QUJE C7SLD,
				cQuery += " CASE WHEN C7_XDTENT2<>' ' THEN C7_XDTENT2 ELSE C7_DATPRF END DATASC7,
				cQuery += " NVL(Z96_QTDATE,0) QTDZ96, 
				cQuery += " C7_QUANT-C7_QUJE-NVL(Z96_QTDATE,0) SALDO, C7_XDTENT2, C7_DATPRF
				cQuery += " FROM "+RetSqlName("SC7")+" C7
				cQuery += " LEFT JOIN (
				cQuery += " SELECT Z96_FILIAL, Z96_PROD, Z96_PEDCOM, Z96_ITECOM, SUM(NVL(Z96_QTDATE,0)) Z96_QTDATE
				cQuery += " FROM "+RetSqlName("Z96")+" Z96
				cQuery += " WHERE Z96.D_E_L_E_T_=' ' 
				cQuery += " GROUP BY Z96_FILIAL, Z96_PROD, Z96_PEDCOM, Z96_ITECOM
				cQuery += " ) Z96
				cQuery += " ON Z96_FILIAL=C7_FILIAL AND Z96_PROD=C7_PRODUTO AND Z96_PEDCOM=C7_NUM AND Z96_ITECOM=C7_ITEM
				cQuery += " WHERE C7.D_E_L_E_T_=' ' 
				cQuery += " AND C7_QUANT-C7_QUJE>0
				cQuery += " AND C7_FORNECE IN ('005866','005764')
				cQuery += " AND C7_RESIDUO=' ' 
				cQuery += " AND C7_PO_EIC=' ' 
				cQuery += " AND C7_QUANT-C7_QUJE-NVL(Z96_QTDATE,0)>0
				cQuery += " AND C7_PRODUTO = '"+cProd+"'
				cQuery += " ORDER BY C7_PRODUTO, CASE WHEN C7_XDTENT2<>' ' THEN C7_XDTENT2 ELSE C7_DATPRF END				

		  		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
				
				dtEntre := STOD("")

				IF !EMPTY(TSC7->C7_XDTENT2) .AND. TSC7->SALDO >= _nQuant
					dtEntre := STOD(TSC7->C7_XDTENT2)
					dtEntre := DataValida(STOD(TSC7->C7_XDTENT2), .T.)
					//nPrecisa:=0
				ELSEIF !EMPTY(TSC7->C7_DATPRF) .AND. TSC7->SALDO >= _nQuant
					dtEntre := STOD(TSC7->C7_DATPRF) 
					dtEntre := DataValida(STOD(TSC7->C7_DATPRF), .T.)
					//nPrecisa:=0
				ENDIF
				

				IF nPrecisa > 0 .and. !EMPTY(cNUm)// Não achou a data vai buscar datas dos importados. 
				   TSC7->(DBgotop())   
				   While ! TSC7->(Eof())
				      IF !EMPTY(TSC7->C7_XDTENT2)
					     _dData := STOD(TSC7->C7_XDTENT2)
					  ELSE 
  				         _dData:= STOD(TSC7->C7_DATPRF)
				      ENDIF		 
				      //_dData:=IIF(_dData<Date(),DataValida(date()),DataValida(_dData))
					  _dData:=DataValida(_dData)
					  IF nPrecisa > TSC7->SALDO
					     nPos:=aScan(aDtEntre, {|x|x[3]+DTOS(x[1]) = '2PO'+DTOS(_dData) })
						 IF nPos<>0
						    aDtEntre[nPos,2]+=TSC7->SALDO
						 ELSE 
						    aadd(aDtEntre,{_dData,TSC7->SALDO,'2PO'} )
						 ENDIF	
				         nPrecisa-=TSC7->SALDO
				      ELSE 
					     nPos:=aScan(aDtEntre, {|x|x[3]+DTOS(x[1]) = '2PO'+DTOS(_dData) })
						 IF nPos<>0
						    aDtEntre[nPos,2]+=nPrecisa
						 ELSE 
						    aadd(aDtEntre,{_dData,nPrecisa,'2PO'} )
						 ENDIF	
						 nPrecisa:=0
						 exit
					  ENDIF		 
				      TSC7->(dbskip())
				   ENDDO 
                ENDIF		
				
				TSC7->(DBCLOSEAREA())

				//If !Empty(dtEntre) .And. dtEntre>=Date()
				//	RestArea(_aArea)
				//	Return(dtEntre)
				//EndIf

				//IF EMPTY(dtEntre) .Or. dtEntre<Date()
					nDiasGrp:= u_STLDGRUP(cProd)
					dtEntre := DataValida(dDataBase + nDiasGrp, .T.)
				    IF nPrecisa>0
                       aadd(aDtEntre,{dtEntre,nPrecisa,'3LD'} )
					ENDIF
				//ENDIF
			ENDIF
			
			If (Alltrim(cProd) $ ('CA2010AB/CA2010B'))

				dtEntre:=DataValida(u_StDtCanl(cProd,_nQuant) , .T.)

			EndIf
		EndIf
	ENDIF
	RestArea(_aArea)
    IF cItem<>'XX'
	   IF !Empty(cNum)
	      SUB->(DBSETORDER(1))
	      IF SUB->(DBSEEK(XFILIAL('SUB')+cNum+cItem+cProd))
	         IF EMPTY(SUB->UB_MDTENTR)
	            aSort(aDtEntre,,,{|x,y| x[1] < y[1] })
	            FOR NX:=1 TO LEN(aDtEntre)
		           cMsg+=ALLTRIM(STR(aDtEntre[NX,2],10))+';'+DTOC(aDtEntre[NX,1])+';'
	            NEXT
	            SUB->(RECLOCK('SUB'))
	            SUB->UB_MDTENTR:=cMsg
	            SUB->(MSUNLOCK())
		     ENDIF
		  ENDIF	 
	   ENDIF	  
	ELSE
	   dDataCalc:=dtEntre
	   dtEntre  :=aDtEntre
	ENDIF
 
    IF IsInCallStack("U_RSTFAT11") // Se vier do orçamento atualiza a data. 
       IF LEN(aDtEntre)==1
          SUB->(RECLOCK('SUB'))
          SUB->UB_DTENTRE:=aDtEntre[1,1]
          SUB->(MSUNLOCK())
	   ELSEIF LEN(aDtEntre)>1
	      cMsg:=""  
		  FOR NX:=1 TO LEN(aDtEntre)
              cMsg+=ALLTRIM(STR(aDtEntre[NX,2],10))+';'+DTOC(aDtEntre[NX,1])+';'
	      NEXT
	      SUB->(RECLOCK('SUB'))
	      SUB->UB_MDTENTR:=cMsg
		  SUB->UB_DTENTRE:=aDtEntre[LEN(aDtEntre),1]
	      SUB->(MSUNLOCK())
	   ELSEIF LEN(aDtEntre)==0
          SUB->(RECLOCK('SUB'))
          SUB->UB_DTENTRE:=IIF(!Empty(dDataCalc),dDataCalc,SUB->UB_DTENTRE)
          SUB->(MSUNLOCK())
	   ENDIF 	  
	ENDIF  

IF cNum='PORTAL' // Se vier do portal retorna a data maior. 
   IF ValType(aDtEntre) == "A"
      aSort(aDtEntre,,,{|x,y| x[1] < y[1] })
	  dtEntre:=aDtEntre[len(aDtEntre),1]
   ENDIF	  
ENDIF


Return (dtEntre)


	/*====================================================================================\
	|Programa  | PREVDISTRI          | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
	|=====================================================================================|
	|Descrição |  GRAVA COMPROMISSO NA SC6                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | PREVDISTRI                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------*
Static Function PREVDISTRI(_cProd,_nQuant)
	*---------------------------*
	Local _aArea	  := GetArea()
	Local cAliasLif   := 'PREVDISTRI'
	Local cQuery      := ' '
	Local _nQtdDisp   := 0
	Local _cProdx     := ' '
	Private cAliasSc6 := ' '


	cQuery := " SELECT ZZJ_COD, ZZJ_NUM,
	cQuery += " ZZJ_QUANT,
	cQuery += " ZZJ_DATA
	cQuery += "  FROM "+RetSqlName("ZZJ")+" ZZJ "
	cQuery += " WHERE ZZJ.D_E_L_E_T_ = ' '
	cQuery += " AND ZZJ.ZZJ_CANCEL = ' '
	cQuery += " AND ZZJ.ZZJ_COD = '"+_cProd+" '
	cQuery += " AND ZZJ.ZZJ_DATA > '"+dtos(dDataBase)+" '
	cQuery += " ORDER BY ZZJ_DATA


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While !(cAliasLif)->(Eof())
			_nQtdDisp   := 	((cAliasLif)->ZZJ_QUANT  - PREVSUM((cAliasLif)->ZZJ_NUM) )


			If _nQtdDisp >= _nQuant
				_dRet:= Stod((cAliasLif)->ZZJ_DATA)
				Return(.T.)
			EndIf


			(cAliasLif)->(dbSkip())
		End




	EndIf

	Return(.F.)


	/*====================================================================================\
	|Programa  | PREVSUM             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
	|=====================================================================================|
	|Descrição |  SUM COMPROMISSO NA SC6                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | PREVSUM                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------*
Static Function PREVSUM(_cPrevs)
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cAliasSum  := 'PREVSUM'
	Local cQuery     := ' '
	Local _nRet      := 0

	cQuery := " SELECT
	cQuery += ' SUM(SC6.C6_XQTPRV) "QTD"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_FILIAL   = '"+xFilial("SC6")+"'"
	cQuery += " AND SC6.C6_XPREV = '"+_cPrevs+"'"
	cQuery += " AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += " AND SC6.C6_BLQ <> 'R'

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasSum) > 0
		(cAliasSum)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSum)
	dbSelectArea(cAliasSum)
	If  Select(cAliasSum) > 0
		(cAliasSum)->(dbgotop())

		_nRet:= (cAliasSum)->QTD

	EndIf

	Return(_nRet)


	/*====================================================================================\
	|Programa  | PREVSUM             | Autor | GIOVANI.ZAGO          | Data | 15/10/2014  |
	|=====================================================================================|
	|Descrição |  SUM COMPROMISSO NA SC6                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | PREVSUM                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------*
User Function STLDGRUP(_cProd)
	*---------------------------*
	Local _aArea	 := GetArea()
	Local cAliasSum  := 'STLDGRUP'
	Local cQuery     := ' '
	Local _nRet      := 0

	Dbselectarea('SB1')
	SB1->(dbsetorder(1))
	If 	SB1->(Dbseek(xfilial("SB1") + _cProd ))

		If SB1->B1_PE <> 0
			_nRet      := SB1->B1_PE
		Else
			cQuery := " SELECT
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'F' THEN SBM.BM_XDAYIF ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'M' THEN SBM.BM_XDAYIM ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'R' THEN SBM.BM_XDAYIR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'RR' THEN SBM.BM_XDAYIRR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'O' THEN SBM.BM_XDAYIO ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'X' THEN SBM.BM_XDAYIX ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'I' AND SB1.B1_XFMR = 'N' THEN SBM.BM_XDAYIN ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'F' THEN SBM.BM_XDAYFF ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'M' THEN SBM.BM_XDAYFM ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'R' THEN SBM.BM_XDAYFR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'RR' THEN SBM.BM_XDAYFRR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'O' THEN SBM.BM_XDAYFO ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'X' THEN SBM.BM_XDAYFX ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'N' THEN SBM.BM_XDAYFN ELSE
			/*
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'F' THEN SBM.BM_XDAYFF ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'M' THEN SBM.BM_XDAYFM ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'R' THEN SBM.BM_XDAYFR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'RR' THEN SBM.BM_XDAYFRR ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'O' THEN SBM.BM_XDAYFO ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'X' THEN SBM.BM_XDAYFX ELSE
			cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' AND SB1.B1_XFMR = 'N' THEN SBM.BM_XDAYFN ELSE
			*/
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'F' THEN SBM.BM_XDAYCF ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'M' THEN SBM.BM_XDAYCM ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'R' THEN SBM.BM_XDAYCR ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'RR' THEN SBM.BM_XDAYCRR ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'O' THEN SBM.BM_XDAYCO ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'X' THEN SBM.BM_XDAYCX ELSE
	cQuery += " CASE WHEN SB1.B1_CLAPROD = 'C' AND SB1.B1_XFMR = 'N' THEN SBM.BM_XDAYCN ELSE

	cQuery += " 0 END END END END END END END END END END END END END END END END END END END END END
	// cQuery += " END END END END END END END
	cQuery += ' "TIME"

	cQuery += " FROM "+RetSqlName("SBM")+" SBM "

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+") SB1"
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SB1.B1_COD = '"+_cProd+"'
	cQuery += " AND SB1.B1_GRUPO = SBM.BM_GRUPO
	If cEmpAnt = '01'
		cQuery += " LEFT JOIN(SELECT * FROM SB1030) TB1
		cQuery += " ON TB1.D_E_L_E_T_ = ' '
		cQuery += " AND TB1.B1_COD = SB1.B1_COD
	EndIf

	cQuery += " WHERE SBM.D_E_L_E_T_ = ' '

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasSum) > 0
		(cAliasSum)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSum)
	dbSelectArea(cAliasSum)
	If  Select(cAliasSum) > 0
		(cAliasSum)->(dbgotop())

		_nRet:= (cAliasSum)->TIME

	EndIf
EndIf
EndIf
Return(_nRet)



	/*====================================================================================\
	|Programa  | STACEMAIL        | Autor | GIOVANI.ZAGO             | Data | 27/05/2015  |
	|=====================================================================================|
	|Descrição | STACEMAIL                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STACEMAIL                                                                |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  STACEMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail,_cProd)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Produto Sem Prazo de Entrega'
	Local cFuncSent:= "STACEMAIL"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := "  Richely.Lima@steck.com.br;paulo.filho@steck.com.br  "
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  :=  "  Richely.Lima@steck.com.br ;paulo.filho@steck.com.br "

	Dbselectarea('SB1')
	SB1->(dbsetorder(1))

	If ( Type("l410Auto") == "U" .OR. !l410Auto ) .And. SB1->(Dbseek(xfilial("SB1") + _cProd )) .And. SB1->B1_TIPO = 'PA'

		Aadd( _aMsg , { "Produto: "       	, SB1->B1_COD   } )
		Aadd( _aMsg , { "Grupo: "  			, SB1->B1_GRUPO } )
		Aadd( _aMsg , { "Classificação : "  , SB1->B1_CLAPROD } )
		Aadd( _aMsg , { "FMR : "  			, SB1->B1_XFMR } )
		Aadd( _aMsg , { "Data: "    		, _cDat  } )
		Aadd( _aMsg , { "Usuario: "    		, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next




		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)  

	EndIf
	RestArea(aArea)
Return()

