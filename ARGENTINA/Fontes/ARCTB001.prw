#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARCTB001 ºAutor  ³Cristiano Pereira    º Data ³  21/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contabilizações das operações de EF / CH / TF / DEV         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ARCTB001()

Processa( {||  ARCTB1A() } )
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARCTB1A ºAutor  ³Cristiano Pereira    º Data ³  01/25/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento dos saldos contábeis                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ARCTB1A()

Private _cQryCT2  := ""
Private _cOper,oOper
//Private  _aItens  := {"1=CHEQUES EFETIVOS","2=EF","3=TF","4=DEV"}
Private  _aItens  := {"1=CHEQUES EFETIVOS","4=CHEQUES RECHAZADOS"}
Private _cOpc  :=""
Private _dDataD := Ctod(Space(8)),_oDataD
Private _dDataA := Ctod(Space(8)),_oDataA
Private _nOpcao := 0
Private _nSeq   := 0
Private _dData  := Ctod(Space(8))
Private _cDoc   := Space(6)
Private _cQryD  := ""
Private _cConta :=""
Private _cCntCr := "" 

_aCab   := {}
_aItem  := {}
lMsErroAuto := .F.
lMSHelpAuto := .T.
_aArea      := GetArea()



//########################################
//Interface de parâmetros
//########################################

oDlgA := MSDialog():New(10,10,350,400,'SIGACTB - Contalizaciones operaciones EF_TF_CH',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

DEFINE FONT oFont1 NAME "Arial" SIZE 0,-14 BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,-10 BOLD

@ 010,003    SAY OemToAnsi("Operaciones: ")                        SIZE 050,120    OF  oDlgA PIXEL FONT oFont1
oComb := tComboBox():New(010,050,{|u| if(PCount()>0,_cOpc :=u,_cOpc )},_aItens,080,20,oDlgA,,,,,,.T.,,,,,,,,,'_cOpc')

@ C(037),C(003)    SAY OemToAnsi("Fecha De: ")   SIZE C(060),C(010)    OF  oDlgA PIXEL FONT oFont1
@ C(037),C(050) Get _dDataD  Object _oDataD When  .T.    Size 070,12


@ C(055),C(003)    SAY OemToAnsi("Fecha Ate: ")   SIZE C(060),C(010)    OF  oDlgA PIXEL FONT oFont1
@ C(055),C(050) Get _dDataA  Object _oDataA When  .T.    Size 070,12



oTBrowseButton1 := TBrowseButton():New( 100,50,'Proceso',oDlgA,{||_nOpcao:=1,,oDlgA:End()},30,10,,,.F.,.T.,.F.,,.F.,,,)
oTBrowseButton2 := TBrowseButton():New( 100,100,'Salir',oDlgA,{|| _nOpcao:=0,oDlgA:End()},30,10,,,.F.,.T.,.F.,,.F.,,,)


// ativa diálogo centralizado
oDlgA:Activate(,,,.T.,,, )


If _nOpcao == 1
	
	//CHEQUES EFETIVOS
	If  _cOpc=="1"
		
		lMsErroAuto := .F.
		lMSHelpAuto := .T.
		_aCab   := {}
		_aItem  := {}
		
		If Select("TCT2") > 0
			DBSelectArea("TCT2")
			DbCloSeArea()
		Endif
		_cQryCT2  := "	SELECT SE5.*      "
		_cQryCT2  += "  FROM "+RetSqlName("SE5")+" SE5   "
		_cQryCT2  += " 	WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND SE5.E5_DATA>='"+dtos(_dDataD)+"'  AND  "
		_cQryCT2  += "  SE5.E5_LA<>'S'              AND       "
		_cQryCT2  += "  SE5.E5_DATA<='"+dtos(_dDataA)+"'  AND       "
		_cQryCT2  += "  SE5.E5_VALOR > 0            AND       "
		_cQryCT2  += "  SE5.D_E_L_E_T_ <>'*'        AND       "
		_cQryCT2   += "  SE5.E5_TIPO='CH'           AND       "
		_cQryCT2   += " SE5.E5_RECPAG ='R'                    "
		
		
		
		_cQryCT2  += " ORDER BY SE5.E5_DATA,SE5.E5_NUMERO                     "
		
		
		
		
		TCQUERY _cQryCT2 ALIAS "TCT2" NEW
		
		Begin Transaction
						
		DbSelectArea("TCT2")
		DbGoTOp()
		
		
		
		While !TCT2->(EOF())
			
			_dData  := TCT2->E5_DATA
			
			If Select("TD") > 0
				DbSelectArea("TD")
				DbCloSeArea()
			Endif
			
			_cQryD := " SELECT CT2.CT2_DOC AS DOC                         "
			_cQryD += " FROM "+RetSqlName("CT2")+" CT2                    "
			_cQryD += " WHERE CT2.CT2_FILIAL ='"+xFilial("CT2")+"'    AND "
			_cQryD += "       CT2.D_E_L_E_T_ <> '*'                   AND "
			_cQryD += "       CT2.CT2_LOTE = '008850'                 AND "
			_cQryD += "       CT2.CT2_DATA='"+Dtos(sTod(TCT2->E5_DATA))+"'      "
			_cQryD += " ORDER BY CT2.CT2_DOC DESC                      "
			
			TCQUERY _cQryD ALIAS "TD" NEW
			
			_nRec := 0
			DbEval({|| _nRec++  })
			
			DbSelectArea("TD")
			DbGoTOp()
			
			If _nRec > 0
				_nSeq       := Val(TD->DOC)+1
			Else
				_nSeq       := 1
			Endif
			
			
			While _dData == TCT2->E5_DATA
				
				IncProc("Selecionando registros   "+TCT2->E5_NUMERO+" "+DTOC(STOD(TCT2->E5_DATA)))
				
			
				_aCab   := {}
				_aItem  := {}
				
				If TCT2->E5_BANCO=="259"

				    DbSelectArea("SEL")
					DbSetOrder(1)
					If DbSeek(xFilial("SEL")+TCT2->E5_ORDREC)
                         If SEL->EL_BANCO =='801'
                             _cConta :="110110001"
					         _cCntCr := "111001030"
						 ElseIf SEL->EL_BANCO =='CAR'
                             _cConta :="110110001"
				             _cCntCr := "111001020"
				 		 Endif
					Else
					_cConta :="110110001"
					_cCntCr := "111001020"
					Endif
				ElseIf  TCT2->E5_BANCO=="072"
					_cConta :="110110002"
					_cCntCr := "111001035"
				Endif
				
				//Inclusão de Lançamento Contábil para teste de atualização via execauto
				aAdd(_aCab,  {'DDATALANC'     ,STOD(TCT2->E5_DATA)      ,NIL} )
				aAdd(_aCab,  {'CLOTE'         ,'008850'         ,NIL} )
				aAdd(_aCab,  {'CSUBLOTE'         ,'001'         ,NIL} )
				aAdd(_aCab,  {'CDOC'             ,StrZero(_nSeq,6)         ,NIL} )
				aAdd(_aCab,  {'CPADRAO'         ,''             ,NIL} )
				aAdd(_aCab,  {'NTOTINF'         ,0                 ,NIL} )
				aAdd(_aCab,  {'NTOTINFLOT'     ,0                 ,NIL} )
				
				
				
				aAdd(_aItem,{  {'CT2_FILIAL'          ,"07"+xFilial("CT2")       , NIL},;
				{'CT2_LINHA'      , "001"             ,NIL},;
				{'CT2_MOEDLC'      ,'01'              ,NIL},;
				{'CT2_DC'           ,'3'              ,NIL},;
				{'CT2_DEBITO'      ,_cConta      ,NIL},;
				{'CT2_CREDIT'      ,_cCntCr       ,NIL},;
				{'CT2_CLVLDB'      ,"A11120"          ,NIL},;
				{'CT2_CLVLCR'      ,"A14110"          ,NIL},;
				{'CT2_VALOR'      , TCT2->E5_VALOR      ,NIL},;
				{'CT2_TPSALD'      ,'1'              ,NIL},;
				{'CT2_ORIGEM'     ,'MSEXECAUT'        ,NIL},;
				{'CT2_HP'           ,''               ,NIL},;
				{'CT2_HIST'       , "DEPOSITO DE CHEQUE "+RTrim(TCT2->E5_BENEF)+" "+Rtrim(TCT2->E5_NUMERO), NIL} } )
				
				
				MSExecAuto({|x, y,z| CTBA102(x,y,z)}, _aCab ,_aItem, 3)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				Else
					
					dbSelectArea("SE5")
					dbGoto(TCT2->R_E_C_N_O_)
					
					
					If TCT2->E5_SITUACA<>"C"
						If Reclock("SE5",.F.)
							SE5->E5_LA := 'S'
							MsUnlock()
						Endif
					Endif
					
				EndIf
				

				
				_nSeq++
				
				DbSelectArea("TCT2")
				DbSkip()
			Enddo
		Enddo
	End Transaction
		
	ElseIf  _cOpc=="4"	//Devolução cheques
		
		
		lMsErroAuto := .F.
		lMSHelpAuto := .T.
		_aCab   := {}
		_aItem  := {}
		
		If Select("TCT2") > 0
			DBSelectArea("TCT2")
			DbCloSeArea()
		Endif
		_cQryCT2  := "	SELECT SE5.*      "
		_cQryCT2  += "  FROM "+RetSqlName("SE5")+" SE5   "
		_cQryCT2  += " 	WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND SE5.E5_DATA>='"+dtos(_dDataD)+"'  AND  "
		_cQryCT2  += "  SE5.E5_DATA<='"+dtos(_dDataA)+"'  AND       "
		_cQryCT2  += "  SE5.D_E_L_E_T_ <>'*'        AND       "
		_cQryCT2  += "  SE5.E5_LA<>'S'              AND       "
		_cQryCT2  += "  SE5.E5_VALOR > 0            AND       "
		_cQryCT2  += "  SE5.E5_SITUACA='C'          AND       "
		_cQryCT2   += "  SE5.E5_TIPO='CH'           AND       "
		_cQryCT2   += " SE5.E5_RECPAG ='R'                    "
		
		_cQryCT2  += " ORDER BY SE5.E5_DATA,SE5.E5_NUMERO     "
		
		
		TCQUERY _cQryCT2 ALIAS "TCT2" NEW
		
		Begin Transaction
				
				
		DbSelectArea("TCT2")
		DbGoTOp()
		
		While !TCT2->(EOF())
			
			_dData  := TCT2->E5_DATA
			
	
			
			If Select("TD") > 0
				DbSelectArea("TD")
				DbCloSeArea()
			Endif
			
			_cQryD := " SELECT CT2.CT2_DOC AS DOC                         "
			_cQryD += " FROM "+RetSqlName("CT2")+" CT2                    "
			_cQryD += " WHERE CT2.CT2_FILIAL ='"+xFilial("CT2")+"'    AND "
			_cQryD += "       CT2.D_E_L_E_T_ <> '*'                   AND "
			_cQryD += "       CT2.CT2_LOTE = '008850'                 AND "
			_cQryD += "       CT2.CT2_DATA='"+Dtos(sTod(TCT2->E5_DATA))+"'      "
			_cQryD += " ORDER BY CT2.CT2_DOC DESC                      "
			
			TCQUERY _cQryD ALIAS "TD" NEW
			
			_nRec := 0
			DbEval({|| _nRec++  })
			
			DbSelectArea("TD")
			DbGoTOp()
			
			If _nRec > 0
				_nSeq       := Val(TD->DOC)+1
			Else
				_nSeq       := 1
			Endif
			
			
			While _dData == TCT2->E5_DATA
				
				IncProc("Selecionando registros   "+TCT2->E5_NUMERO+" "+DTOC(STOD(TCT2->E5_DATA)))
				
				_aCab   := {}
				_aItem  := {}
				
				If TCT2->E5_BANCO=="259"
					_cConta :="110110001"
				ElseIf  TCT2->E5_BANCO=="072"
					_cConta :="110110002"
				ElseIf TCT2->E5_BANCO=="CAR"
				    _cConta :="111001020"
				Endif
				
				//Inclusão de Lançamento Contábil para teste de atualização via execauto
				aAdd(_aCab,  {'DDATALANC'     ,STOD(TCT2->E5_DATA)      ,NIL} )
				aAdd(_aCab,  {'CLOTE'         ,'008850'         ,NIL} )
				aAdd(_aCab,  {'CSUBLOTE'         ,'001'         ,NIL} )
				aAdd(_aCab,  {'CDOC'             ,StrZero(_nSeq,6)         ,NIL} )
				aAdd(_aCab,  {'CPADRAO'         ,''             ,NIL} )
				aAdd(_aCab,  {'NTOTINF'         ,0                 ,NIL} )
				aAdd(_aCab,  {'NTOTINFLOT'     ,0                 ,NIL} )
				
				
				
				aAdd(_aItem,{  {'CT2_FILIAL'          ,"07"+xFilial("CT2")       , NIL},;
				{'CT2_LINHA'      , "001"             ,NIL},;
				{'CT2_MOEDLC'      ,'01'              ,NIL},;
				{'CT2_DC'           ,'3'              ,NIL},;
				{'CT2_DEBITO'      ,"111001025"       ,NIL},;
				{'CT2_CREDIT'      ,_cConta       ,NIL},;
				{'CT2_CLVLDB'      ,"A14110"         ,NIL},;
				{'CT2_CLVLCR'      ,"A11120"           ,NIL},;
				{'CT2_VALOR'      , TCT2->E5_VALOR      ,NIL},;
				{'CT2_TPSALD'      ,'1'              ,NIL},;
				{'CT2_ORIGEM'     ,'MSEXECAUT'        ,NIL},;
				{'CT2_HP'           ,''               ,NIL},;
				{'CT2_HIST'       , " CHEQUES RECHAZADOS "+RTrim(TCT2->E5_BENEF)+" "+Rtrim(TCT2->E5_NUMERO), NIL} } )
				
				
				MSExecAuto({|x, y,z| CTBA102(x,y,z)}, _aCab ,_aItem, 3)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				Else
					
					dbSelectArea("SE5")
					dbGoto(TCT2->R_E_C_N_O_)
					
			    	If TCT2->E5_SITUACA=="C"
						If Reclock("SE5",.F.)
							SE5->E5_LA := 'S'
							MsUnlock()
						Endif
					Endif
					
				EndIf
				
	
				_nSeq++
				
				DbSelectArea("TCT2")
				DbSkip()
			Enddo
		Enddo
		
		End Transaction 
		
	Endif
	
	
	MsgInfo("Processamento realizado com sucesso.")
	
Else
	
	MsgInfo("Processamento abortado.")
	
Endif

RestArea(_aArea)


return
