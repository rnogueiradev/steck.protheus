#INCLUDE 'RwMake.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STZZI          | Autor | GIOVANI.ZAGO               | Data | 27/11/2013  |
|=====================================================================================|
|Descrição | Cria mBrowse 											                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STZZI                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STZZI()
	*---------------------------------------------------*
	Local aCores2     := {}
	Local _cQuery1 	  := ""
	Local _cAlias1    := GetNextAlias()
	Local nh          :=0
	Local aGrpven     :={}

	Private cCadastro := 'Alçadas Desconto'
	Private cString   := 'ZZI'
	Private aRotina	  := MenuDef()
	Private _cFilSQL  := ''
	Private cFiltro   :=" ZZI_BLQ  =  '2' "
	Private aIndexZZI := {}
	Private bFiltraBrw:= {}
	Private cUserSub  :="" 
    //Private bFiltraBrw:= { || FilBrowse(cString,@aIndexZZI,@cFiltra) }


	dbSelectArea("ZZH")
	ZZH->(dbSetOrder(1))
	If ZZH->(DbSeek(xFilial("ZZH")+__cUserId)) .or. __cUserId = '000000'
       
	   // Filtrar registros pelo Grupo de Vendas. 
	   IF !EMPTY(ZZH->ZZH_GRPVEN)
           aGrpVen:=StrToArray(ALLTRIM(ZZH->ZZH_GRPVEN),",")
           cFiltro+=" AND ( "
           FOR nh:=1 TO LEN(aGrpVen)
	           cGrp:=Replace(aGrpVen[nh],"'","")
               IF NH<LEN(aGrpVen)
		               cFiltro+=" ZZI_GRPVEN = '"+cGrp+SPACE(TamSX3("ZZI_GRPVEN")[1]-LEN(cGrp))+"'  OR  "
	           ELSE 
                       cFiltro+=" ZZI_GRPVEN = '"+cGrp+SPACE(TamSX3("ZZI_GRPVEN")[1]-LEN(cGrp))+"' ) "
	            ENDIF   
	        NEXT 	

		ENDIF 	

		IF ! Empty(ZZH->ZZH_APRSUB) .AND. ZZH->ZZH_DTVLAP>=dDatabase
		   _cUser1:=ALLTRIM(ZZH->ZZH_APRSUB)
		ELSE 
		   _cUser1:=__cUserId
		ENDIF   

        /*/
		aCores2    := {;
		{"  ZZI_APROV1='"+_cUser1+"'  .AND. ZZI_STAPR1=' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da pendente 
        {"  ZZI_APROV1='"+_cUser1+"'  .AND. ( ZZI_STAPR1='A' .OR. ZZI_STAPR1='Z' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alçada aprovado 
		{"  ZZI_APROV2='"+_cUser1+"'  .AND. ZZI_STAPR2=' ' .AND. ZZI_STAPR1<>' '  .AND. ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada pendente 
		{"  ZZI_APROV2='"+_cUser1+"'  .AND. ( ZZI_STAPR2='A' .OR. ZZI_STAPR2='Z' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alcaçada aprovado
		{"  ZZI_APROV3='"+_cUser1+"'  .AND. ZZI_STAPR3=' ' .AND. ZZI_STAPR1<>' ' .AND. ZZI_STAPR2<>' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada Pendente 
		{"  ZZI_APROV3='"+_cUser1+"'  .AND. ( ZZI_STAPR3='A' .OR. ZZI_STAPR3='Z' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alcaçada aprovado
		{"  ZZI_APROV4='"+_cUser1+"'  .AND. ZZI_STAPR4=' '  .AND. ZZI_STAPR1<>' ' .AND. ZZI_STAPR2<>' ' .AND. ZZI_STAPR3<>' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada PENDENTE 
		{"  ZZI_APROV4='"+_cUser1+"'  .AND. ( ZZI_STAPR4='A' .OR. ZZI_STAPR4='Z' ) .AND. ZZI->ZZI_STAPR3='A' .AND.  ZZI->ZZI_REJEI <> '1'" 	, "BR_AZUL"	},; // dentro da alçada aprovado
		{" .T. "												, "BR_PRETO"   	}}	// Sem classificaçao
        /*/

		aCores2    := {;
		{"  ZZI_APROV1='"+_cUser1+"'  .AND. ZZI_STAPR1=' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da pendente 
        {"  ZZI_APROV1='"+_cUser1+"'  .AND. ( ZZI_STAPR1='A' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alçada aprovado 
		{"  ZZI_APROV2='"+_cUser1+"'  .AND. ZZI_STAPR2=' ' .AND. ZZI_STAPR1<>' '  .AND. ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada pendente 
		{"  ZZI_APROV2='"+_cUser1+"'  .AND. ( ZZI_STAPR2='A' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alcaçada aprovado
		{"  ZZI_APROV3='"+_cUser1+"'  .AND. ZZI_STAPR3=' ' .AND. ZZI_STAPR1<>' ' .AND. ZZI_STAPR2<>' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada Pendente 
		{"  ZZI_APROV3='"+_cUser1+"'  .AND. ( ZZI_STAPR3='A' ) .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_AZUL"	},; // dentro da alcaçada aprovado
		{"  ZZI_APROV4='"+_cUser1+"'  .AND. ZZI_STAPR4=' '  .AND. ZZI_STAPR1<>' ' .AND. ZZI_STAPR2<>' ' .AND. ZZI_STAPR3<>' ' .AND.  ZZI->ZZI_REJEI <> '1'"	, "BR_VERDE"	},; // dentro da alcaçada PENDENTE 
		{"  ZZI_APROV4='"+_cUser1+"'  .AND. ( ZZI_STAPR4='A' ) .AND. ZZI->ZZI_STAPR3='A' .AND.  ZZI->ZZI_REJEI <> '1'" 	, "BR_AZUL"	},; // dentro da alçada aprovado
		{" .T. "												, "BR_PRETO"   	}}	// Sem classificaçao



		(cString)->(DbSetOrder(3))

		DbSelectArea("ZZI")

		_cQuery1 := " SELECT ZZI.R_E_C_N_O_ RECZZI, UA.R_E_C_N_O_ RECSUA
		_cQuery1 += " FROM "+RetSqlName("ZZI")+" ZZI
		_cQuery1 += " LEFT JOIN "+RetSqlName("SUA")+" UA
		_cQuery1 += " ON UA_FILIAL=ZZI_FILANT AND UA_NUM=ZZI_NUM
		_cQuery1 += " WHERE ZZI.D_E_L_E_T_=' ' AND UA.D_E_L_E_T_=' '  
		_cQuery1 += " AND ZZI_BLQ='2' AND ZZI_TIPO='ORÇAMENTO'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())

			ZZI->(DbGoTo((_cAlias1)->RECZZI))
			SUA->(DbGoTo((_cAlias1)->RECSUA))

			If ZZI->(!Eof()) .And. SUA->(!Eof())
				If ZZI->(RLock())
					ZZI->(RecLock("ZZI",.F.))
					ZZI->ZZI_MARKUP := U_STFSVE39(.F.)
					ZZI->(MsUnLock())
				EndIf
			EndIf

			(_cAlias1)->(DbSkip())
		EndDo
		
		_cQuery1 := " SELECT C5_NUM, C5_XMOTRES, ZZI_NUM, RECZZI
		_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
		_cQuery1 += " LEFT JOIN (
		_cQuery1 += " SELECT DISTINCT ZZI_NUM, ZZI.R_E_C_N_O_ RECZZI
		_cQuery1 += " FROM "+RetSqlName("ZZI")+" ZZI
		_cQuery1 += " WHERE ZZI.D_E_L_E_T_=' ' AND ZZI_TIPO='PEDIDO'
		_cQuery1 += " ) ZZI
		_cQuery1 += " ON ZZI_NUM=C5_NUM
		_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='02' AND C5_XMOTRES<>' ' AND ZZI_NUM IS NOT NULL
		
		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)

		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())
			ZZI->(DbGoTo((_cAlias1)->RECZZI))
			If ZZI->(!Eof())
				ZZI->(RecLock("ZZI",.F.))
				ZZI->(DbDelete())
				ZZI->(MsUnLock())
			EndIf
			
			(_cAlias1)->(DbSkip())
		EndDo				

        dbSelectArea(cString)
        dbGoTop()
		mBrowse( 6,1,22,75,cString,,,,,,aCores2,,,,,,,,cFiltro)
        
	Else
		MsgAlert("Usuario sem Acesso!!!!!!!")
	EndIf
	Return NIL

	/*====================================================================================\
	|Programa  | MenuDef        | Autor | GIOVANI.ZAGO               | Data | 10/01/2013  |
	|=====================================================================================|
	|Descrição | Opçoes do Menu											                  |
	|          | 													                      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | MenuDef                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------------*
Static Function MenuDef()
	*---------------------------------------------------*

	/*/
	PRIVATE aRotina	 :={{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
	{ "Visualizar" , "AxVisual" , 0 , 2 },;
	{ "Aprovar"    , "u_xVisuaST()" , 0 , 4 },;
	{ "Legenda"    , "u_xLegendAlca()" , 0 , 2 },;
    { "Status Aprovaçao", "U_STZZIST()" , 0 , 2 }}
    /*/

	//	PRIVATE aRotina	 :={{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
	//{ "Visualizar" , "AxVisual" , 0 , 2 },;
	//{ "Legenda"    , "u_xLegendAlca()" , 0 , 2 },;
    //{ "Status Aprovaçao", "U_STZZIST()" , 0 , 2 },;
	//{ "Aprovar"    , "u_xVisuaST()" , 0 , 4 }}
	
	Private aRotina   := {}                               	
	aAdd( aRotina, {"Pesquisar" ,"PesqBrw",0,1} )
	aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
	aAdd( aRotina, {"------"   ,"u_semacao",0,3} )
	aAdd( aRotina, {"Aprovar"   ,"u_xVisuaST()",0,4} )
	aAdd( aRotina, {"Status Aprovação","U_STZZIST()",0,5} )
	aAdd( aRotina, {"Legenda"   ,"u_xLegendAlca()",0,6} )



	Return(aRotina)

	/*====================================================================================\
	|Programa  | xLegendAlca    | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
	|=====================================================================================|
	|Descrição | Opçoes do Menu											                  |
	|          | 													                      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | xLegendAlca                                                              |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------------*
User Function xLegendAlca()
	*---------------------------------------------------*
	Local	aLegenda:= {;
	{"BR_VERDE" 	,'Disponivel Para Aprovação'},;
	{"BR_AZUL"  	,'Aprovado nesta alçada'},;
	{"BR_PRETO"  	,'Bloqueado'},;
	{"BR_VERMELHO"  ,'Rejeitado'}}

	BrwLegenda("Alçada de Desconto","Legenda",aLegenda)

	Return

	/*====================================================================================\
	|Programa  | xVisuaST       | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
	|=====================================================================================|
	|Descrição | Opçoes do Menu											                  |
	|          | 													                      |
	|          | _aAprovador                                                              |
	|          | 1 - recno zzi                                                            |
	|          | 2 - observacao                                                           |
	|          | 3 - 1 aprovado ; 2 reprovado                                             |
	|=====================================================================================|
	|Sintaxe   | xVisuaST                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-------------------------*
User Function xVisuaST(_aAprovador,_cErro)
	*-------------------------*
	Local  aButtons :={}
	Local  _cName   := FunName()
	Local _nRet     := 0
	Local _cUserTe  := getmv("ST_ZZIUSET",," ")+"/000000"
	Local nTotNivel :=SuperGetMv("ES_NTOTNIV",.f.,4)
	Local cCampo    :=""
    Local lAprovar  :=.F.
	Local cMensAprov:=""
	Local cProxAprov:=""
	Local nNivel    :=0
	Local _cUser2   :=__cUserId
	Local cMensLib  :=""
	
	Local cJusti:=""
    Local Odlg1
    Local oFont:=TFont():New('Courier New', ,-11,.T.,.T.,,,,.F.,.F.)
	
	Private _cRejei := ""
	Private _cMRejei:= ""
	Private _lApp := .F.

	Default _aAprovador := {}

	If Len(_aAprovador)>0
		DbSelectArea("ZZI")
		ZZI->(DbGoTo(_aAprovador[1]))
		If ZZI->(Eof())
			_cErro := "Registro não encontrado"
			Return
		EndIf
		_lApp := .T.
	EndIf

	IF ! Empty(ZZH->ZZH_APRSUB) .AND. ZZH->ZZH_DTVLAP>=dDatabase
	   _cUser2:=ALLTRIM(ZZH->ZZH_APRSUB)
	ENDIF   

    FOR nx:=1 to nTotNivel
       IF nx<nTotnivel 
          cProxAprov:="ZZI_APROV"+ALLTRIM(STR(nx+1))
	   ELSE 
	      cProxAprov:=""
	   ENDIF
	   cCampo:="ZZI_STAPR"+ALLTRIM(STR(nx))
	   IF ZZI->&cCampo==' '
	      cCampo:="ZZI_APROV"+ALLTRIM(STR(nx))
		  IF ZZI->&cCampo<>_cUser2
		     cMensAprov:="Usuario Sem Permissão..." + CHR(13) + CHR(10)+ " Solicitar aprovação do Nível: "+alltrim(str(nx))+" - "+ZZI->&cCampo+" "+UsrRetName(ZZI->&cCampo) 
			 Exit
		  ELSE 
			 nNivel:=nx
			 IF nx==nTotNivel  .or. Empty(&cProxAprov)
			    lAprovar:=.T.
				nTotNivel:=nx 
			 ENDIF   
		     EXIT
		  ENDIF
	   ENDIF	   
	NEXT 

	If !_lApp
		If 'PEDIDO' $ ZZI->ZZI_TIPO
			DbSelectArea('SC5')
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(xFilial("SC5")+ZZI->ZZI_NUM))
				IF lAprovar 
				Processa({|lEnd| _nRet:=U_STTELALC('1',SC5->C5_NUM,1,2) })  // Chamada com regua
				ELSE
				Processa({|lEnd| _nRet:=U_STTELALC('1',SC5->C5_NUM,2,1) })  // Chamada com regua
				ENDIF   
				aAdd(aButtons,{"P.V.",{|| 	a410Visual('SC5',SC5->(Recno()),2)},"P.V."})
			EndIf
		Else
			dbSelectArea("SUA")
			SUA->(dbSetOrder(1))
			If SUA->(DbSeek(xFilial("SUA")+ZZI->ZZI_NUM))
				IF lAprovar 
				Processa({|lEnd| _nRet:=U_STTELALC('2',SUA->UA_NUM,1,2)})  // Chamada com regua
				ELSE 
				Processa({|lEnd| _nRet:=U_STTELALC('2',SUA->UA_NUM,2,1)})  // Chamada com regua
				ENDIF
				aAdd(aButtons,{"Orçamento",{|| TK271CallCenter("SUA",SUA->(RECNO()),2)},"Orçamento"})
			EndIf
		EndIf
	Else
	
		_nRet := 1

		If _aAprovador[3]==2
			_cRejei := "1"
			_cMRejei := _aAprovador[2]
		EndIf

	EndIf

	If _nRet = 1 .And. (lAprovar .Or. AllTrim(_cRejei)=="1")
		U_XZZIAPR()
	ElseIf _nRet = 1 .And. !lAprovar  .and. nNivel=0
		MsgAlert(cMensAprov)
	EndIf
    
	IF nNivel>0 .and. _nRet = 1 
		If !_lApp
			IF nNivel<nTotNivel
				DEFINE MSDIALOG oDlg1 TITLE 'Orçamento Aprovado Nível: '+alltrim(str(nNivel)) FROM  175,020 TO 380,650 PIXEL OF oMainWnd
				@ 010,010 Say "Observações" SIZE 50,9 PIXEL
				@ 020,010 GET oMemo  VAR cJusti MEMO SIZE 290,050 OF oDlg1 PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON FROM 080,250 TYPE 1 Action (nOpc:=1,oDlg1:End()) ENABLE OF oDlg1
				ACTIVATE MSDIALOG oDlg1 Centered 
				//MsgInfo('Orçamento aprovado nivel: '+alltrim(str(nNivel)))
			ENDIF
			cMensLib:= CR+"Liberado Nivel: "+alltrim(str(nNivel)) +'  Usuario: ' +cUserName + " em " + DtoC(dDatabase) + " às " + Time() //+  CR
			cCampo:="ZZI->ZZI_STAPR"+alltrim(str(nNivel))
			ZZI->(RECLOCK('ZZI',.F.))
			ZZI->ZZI_OBSAP1	:= aLLTRIM(cMensLib)+ CR+ ALLTRIM(cJusti) + CR+   aLLTRIM(ZZI->ZZI_OBSAP1)
			&cCampo:='A'
			ZZI->(MSUNLOCK())
		Else
			cMensLib:= CR+"Liberado Nivel: "+alltrim(str(nNivel)) +'  Usuario: ' +cUserName + " em " + DtoC(dDatabase) + " às " + Time() //+  CR
			cCampo:="ZZI->ZZI_STAPR"+alltrim(str(nNivel))
			ZZI->(RECLOCK('ZZI',.F.))
			ZZI->ZZI_OBSAP1	:= aLLTRIM(cMensLib)+ CR+ ALLTRIM(_aAprovador[2]) + CR+   aLLTRIM(ZZI->ZZI_OBSAP1)
			&cCampo:='A'
			ZZI->(MSUNLOCK())		
		EndIf
	EndIf
    	
	Return()

	/*====================================================================================\
	|Programa  | XZZIAPR        | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
	|=====================================================================================|
	|Descrição | Opçoes do Menu											                  |
	|          | 													                      |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | XZZIAPR                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-------------------------*
User Function XZZIAPR()
	*-------------------------*
	Local cLogAnali := ' '
	Local cObs		:= ' '
	Local _lPsc     := .f.
	Local _cMsgDesc		:= ' '

	ZZI->(RecLock("ZZI",.F.))
	ZZI->ZZI_REJEI    :=  _cRejei
	ZZI->ZZI_MREJEI   := _cMRejei
	ZZI->ZZI_BLQ    :=  IiF(ZZI->ZZI_REJEI = '1','3','1')
	ZZI->ZZI_USERAP := __cUserId+" - "+cUserName
	ZZI->ZZI_DTAPR  := dDataBase
	ZZI->(MsUnlock())
	ZZI->( DbCommit() )

	If 'PEDIDO' $ ZZI->ZZI_TIPO
		DbSelectArea('SC5')
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+ZZI->ZZI_NUM))
			If ZZI->ZZI_REJEI = '1'
				u_STzzimail('PEDIDO','',cusername,dtoc(date()),time(),'')
			EndIf

			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZBLOQ   := '2'
			SC5->C5_ZMOTBLO := ' '
			SC5->(MsUnlock())
			SC5->( DbCommit() )

			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
	
			IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ) )
				While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
					u_LOGJORPED("ZZI","2",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao comercial")
				SC6->(DbSkip())
				End
			EndIf

		EndIf
	Else
		dbSelectArea("SUA")
		SUA->(dbSetOrder(1))
		If SUA->(DbSeek(xFilial("SUA")+ZZI->ZZI_NUM))
			If ZZI->ZZI_REJEI = '1'
				//u_STzzimail('',ZZI->ZZI_MREJEI,cusername,dtoc(date()),time(),Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2  ,"A3_EMAIL")))

			EndIf

			If	 ZZI->ZZI_REJEI = '1'
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XDESBLQ := 'REJEITADO'
				SUA->(MsUnlock())
				SUA->( DbCommit() )
				cLogAnali := "Analisado por(4) " + cUserName + CR+ " em " + DtoC(dDatabase) +CR+" às " + Time()+ CR
				cObs		:= MSMM(SUA->UA_XCODANA)

				MSMM(SUA->UA_XCODANA,,,cLogAnali + ' '+ ZZI->ZZI_MREJEI ,1,,,"SUA", "UA_XCODANA",,.T.)

			Else
				DbSelectArea('SUB')
				SUB->(DbSetOrder(1))
				If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
					While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM
						If 	SUB->UB_VLRITEM <> 0.01
							SUB->(RecLock("SUB",.F.))
							SUB->UB_XBLQITE  := '3'
							SUB->(MsUnlock())
							SUB->( DbCommit() )
						Else
							_lPsc:= .t.
						Endif
						SUB->(DbSkip())
					End
				Endif

				SUA->(RecLock("SUA",.F.))
				If _lPsc
					SUA->UA_XDESBLQ := 'PSC/'
				Else
					SUA->UA_XBLOQ 	:= '2'
					SUA->UA_XDESBLQ := ' '
				EndIf

				SUA->(MsUnlock())
				SUA->( DbCommit() )

				If SUA->UA_XBLOQ=="2"
					U_STFAT610("1")
				EndIf

				cLogAnali := "Analisado por(5) " + cUserName + CR + " em " + DtoC(dDatabase) +CR+" às " + Time()+ CR
				cObs		:= MSMM(SUA->UA_XCODANA)

				MSMM(SUA->UA_XCODANA,,,cLogAnali  ,1,,,"SUA", "UA_XCODANA",,.T.)

			EndIf

		EndIf

	EndIf

	Return

	/*====================================================================================\
	|Programa  | STzzimail        | Autor | GIOVANI.ZAGO             | Data | 14/08/2014  |
	|=====================================================================================|
	|Descrição | STzzimail                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STzzimail                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function  STzzimail(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Rejeição - Alçada Comercial
	Local cFuncSent:= "STzzimail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ""
	Local cAttach  := ''

	default _cEmail  := ""

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If _cObs = 'PEDIDO'
			Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
			Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
			Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
			Aadd( _aMsg , { "Dt. Emissão : "    , DTOC(SC5->C5_EMISSAO)})
			Aadd( _aMsg , { "Dt. Rejeição: "    , _cDat  } )
			Aadd( _aMsg , { "Rejeitado: "    	, _cName } )
			Aadd( _aMsg , { "Hora: "    		, _cHora } )
			Aadd( _aMsg , { "Motivo: "    		, _cMot  } )
		Else
			Aadd( _aMsg , { "Orçamento: "          , SUA->UA_NUM } )
			Aadd( _aMsg , { "Cliente - Loja: "  , SUA->UA_CLIENTE+' - '+SUA->UA_LOJA } )
			Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME"),1,35)  } )
			Aadd( _aMsg , { "Dt. Emissão : "    , DTOC(SUA->UA_EMISSAO)})
			Aadd( _aMsg , { "Dt. Rejeição: "    , _cDat  } )
			Aadd( _aMsg , { "Rejeitado: "    	, _cName } )
			Aadd( _aMsg , { "Hora: "    		, _cHora } )
			Aadd( _aMsg , { "Motivo: "    		, _cMot  } )
		EndIf
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
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
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

		//giovani zago desabilitado criado nova rotina de email. 11/12/18
		// U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
	Return()

	/*====================================================================================\
	|Programa  | zExpTabs       | Autor | GIOVANI.ZAGO               | Data | 27/11/2013  |
	|=====================================================================================|
	|Descrição | Cria mBrowse 											                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | zExpTabs                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------------*

User Function zExpTabs()
	Local aArea    := GetArea()
	Local aAreaX2  := SX2->(GetArea())
	Local aAreaX3  := SX3->(GetArea())
	Local aAreaX9  := SX9->(GetArea())
	Local aAreaIX  := SIX->(GetArea())
	Local cDirect  := GetTempPath()
	Local cArquivo := "tabelas.html"
	Local nHdl     := fCreate(cDirect+cArquivo)

	//Se houve falhas, encerra a rotina
	If nHdl == -1
		MsgAlert("O arquivo '"+cDirect+cArquivo+"' não pode ser criado!", "Atenção")
		Return
	Endif

	//Monta cabeçalho do html
	fWrite(nHdl, '<html>' + CRLF)
	fWrite(nHdl, '<head><title>Tabelas Protheus</title></head>' + CRLF)
	fWrite(nHdl, '<body>' + CRLF)

	//Monta as referências
	fWrite(nHdl, '<b>Refer&ecirc;ncias:</b><br>' + CRLF)
	DbSelectArea('SX2')
	SX2->(DbGoTop())
	While !SX2->(EoF())
		//Se não for tabela específica
		If SubStr(SX2->X2_CHAVE, 1, 2) != 'SZ' .And. SubStr(SX2->X2_CHAVE, 1, 2) != 'Z'
			fWrite(nHdl, '- <a href="#'+SX2->X2_CHAVE+'">'+SX2->X2_CHAVE+' ('+Alltrim(SX2->X2_NOME)+')</a><br>' + CRLF)
		EndIf

		SX2->(DbSkip())
	EndDo
	fWrite(nHdl, '<br>' + CRLF)
	fWrite(nHdl, '<hr>' + CRLF)
	fWrite(nHdl, '<br>' + CRLF)

	fWrite(nHdl, '<center>' + CRLF)
	//Agora é montado as tabelas
	DbSelectArea('SX2')
	SX2->(DbGoTop())
	While !SX2->(EoF())
		//Se não for tabela específica
		If SubStr(SX2->X2_CHAVE, 1, 2) != 'SZ' .And. SubStr(SX2->X2_CHAVE, 1, 2) != 'Z'
			fWrite(nHdl, '<font color="red"><h2 id="'+SX2->X2_CHAVE+'">'+SX2->X2_CHAVE+' - '+Alltrim(SX2->X2_NOME)+'</h2></font>' + CRLF)
			fWrite(nHdl, '<table>' + CRLF)

			//Campos
			DbSelectArea('SX3')
			SX3->(DbSetOrder(1))
			If SX3->(DbSeek(SX2->X2_CHAVE))
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td colspan="5" align="center"><b><i>Campos</i></b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td><b>Campo</b></td>' + CRLF)
				fWrite(nHdl, '<td><b>Titulo</b></td>' + CRLF)
				fWrite(nHdl, '<td colspan="2"><b>Descri&ccedil;&atilde;o</b></td>' + CRLF)
				fWrite(nHdl, '<td><b>Tipo</b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)

				//Percorre os campos
				While ! SX3->(Eof()) .And. SX3->X3_ARQUIVO == SX2->X2_CHAVE
					//Se não for campo customizado
					If ! ('_X_' $ SX3->X3_CAMPO .Or. '__' $ SX3->X3_CAMPO)
						fWrite(nHdl, '<tr>' + CRLF)
						fWrite(nHdl, '<td>'+SX3->X3_CAMPO+'</td>' + CRLF)
						fWrite(nHdl, '<td>'+Alltrim(SX3->X3_TITULO)+'</td>' + CRLF)
						fWrite(nHdl, '<td colspan="2">'+Alltrim(SX3->X3_DESCRIC)+'</td>' + CRLF)
						fWrite(nHdl, '<td>'+SX3->X3_TIPO+'</td>' + CRLF)
						fWrite(nHdl, '</tr>' + CRLF)
					EndIf

					SX3->(DbSkip())
				EndDo
			EndIf

			//Relacionamentos
			DbSelectArea('SX9')
			SX9->(DbSetOrder(1))
			If SX9->(DbSeek(SX2->X2_CHAVE))
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td colspan="5" align="center"><b><i>Relacionamentos</i></b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td><b>Tabela Destino</b></td>' + CRLF)
				fWrite(nHdl, '<td colspan="2"><b>Express&atilde;o Origem</b></td>' + CRLF)
				fWrite(nHdl, '<td colspan="2"><b>Express&atilde;o Destino</b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)

				//Percorre os campos
				While ! SX9->(Eof()) .And. SX9->X9_DOM == SX2->X2_CHAVE
					fWrite(nHdl, '<tr>' + CRLF)
					fWrite(nHdl, '<td>'+SX9->X9_CDOM+'</td>' + CRLF)
					fWrite(nHdl, '<td colspan="2">'+Alltrim(SX9->X9_EXPDOM)+'</td>' + CRLF)
					fWrite(nHdl, '<td colspan="2">'+Alltrim(SX9->X9_EXPCDOM)+'</td>' + CRLF)
					fWrite(nHdl, '</tr>' + CRLF)

					SX9->(DbSkip())
				EndDo
			EndIf

			//índices
			DbSelectArea('SIX')
			SIX->(DbSetOrder(1))
			If SIX->(DbSeek(SX2->X2_CHAVE))
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td colspan="5" align="center"><b><i>&Iacute;ndices</i></b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)
				fWrite(nHdl, '<tr>' + CRLF)
				fWrite(nHdl, '<td><b>Ordem</b></td>' + CRLF)
				fWrite(nHdl, '<td colspan="2"><b>Chave</b></td>' + CRLF)
				fWrite(nHdl, '<td><b>Descri&ccedil;&atilde;o</b></td>' + CRLF)
				fWrite(nHdl, '<td><b>NickName</b></td>' + CRLF)
				fWrite(nHdl, '</tr>' + CRLF)

				//Percorre os campos
				While ! SIX->(Eof()) .And. SIX->INDICE == SX2->X2_CHAVE
					fWrite(nHdl, '<tr>' + CRLF)
					fWrite(nHdl, '<td>'+SIX->ORDEM+'</td>' + CRLF)
					fWrite(nHdl, '<td colspan="2">'+Alltrim(SIX->CHAVE)+'</td>' + CRLF)
					fWrite(nHdl, '<td>'+Alltrim(SIX->DESCRICAO)+'</td>' + CRLF)
					fWrite(nHdl, '<td>'+Alltrim(SIX->NICKNAME)+'</td>' + CRLF)
					fWrite(nHdl, '</tr>' + CRLF)

					SIX->(DbSkip())
				EndDo
			EndIf

			fWrite(nHdl, '</table>' + CRLF)
		EndIf

		SX2->(DbSkip())
	EndDo
	fWrite(nHdl, '</center><br>' + CRLF)

	//Fecha ponteiro do arquivo
	fWrite(nHdl, '</html>' + CRLF)
	fClose(nHdl)

	//Se deseja visualizar o arquivo após a geração
	If MsgYesNo("Arquivo gerado ("+cDirect+cArquivo+"), deseja visualizar?", "Atenção")
		ShellExecute("open", cArquivo, "", cDirect, 1)
	EndIf

	RestArea(aAreaIX)
	RestArea(aAreaX9)
	RestArea(aAreaX3)
	RestArea(aAreaX2)
	RestArea(aArea)
Return

/*====================================================================================\
|Programa  | STZZI01        | Autor | GIOVANI.ZAGO               | Data | 18/08/2020  |
|=====================================================================================|
|Descrição | Remover ZZI                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STZZI01()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	
	DbSelectArea("ZZI")

	_cQuery1 := " SELECT ZZI.R_E_C_N_O_ RECZZI
	_cQuery1 += " FROM "+RetSqlName("ZZI")+" ZZI
	_cQuery1 += " WHERE ZZI.D_E_L_E_T_=' ' AND ZZI_FILANT='"+SC5->C5_FILIAL+"'
	_cQuery1 += " AND ZZI_BLQ='2' AND ZZI_TIPO='PEDIDO' AND ZZI_NUM='"+SC5->C5_NUM+"'
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
	
		ZZI->(DbGoTo((_cAlias1)->RECZZI))
		If ZZI->(!Eof())
			ZZI->(RecLock("ZZI",.F.))
			ZZI->(DbDelete())
			ZZI->(MsUnLock())
		EndIf
	
		(_cAlias1)->(DbSkip())
	EndDo

Return()



User Function STZZIST()
    
	Local xTitNv1  := 'Bloqueio Regional'
	Local xTitNv2  := 'Bloqueio Nacional'
	Local xTitNv3  := 'Bloqueio Canal' 
    Local xTitNv4  := 'Bloqueio Marketing' 

    Local cStatNv1 := " "
	Local cStatNv2 := " "
	Local cStatNv3 := " "
	Local cStatNv4 := " "

	Local cNv1     := ''
	Local cNv2     := ''
	Local cNv3     := ''
	Local cNv4     := ''
	Local cUser    :=''
	Local cVar     :=''
	Local aArea    :=GetArea()

    Local nTotNivel :=SuperGetMv("ES_NTOTNIV",.f.,4)
	
	DBSELECTAREA('ZZI')	

	If IsInCallStack("U_STFSVE47")
	   ZZI->(DBSETORDER(3))
	   IF ZZI->(DBSEEK(XFILIAL('ZZI')+SUA->UA_NUM))
          IF ZZI->ZZI_BLQ == '3'	      
		     //MsgAlert('Atenção','Orçamento Rejeitado!! ','Info')
			 MsgAlert('Orçamento Rejeitado!! ','Atenção','Info')
			 Return()
	      ENDIF		 
	   ELSE 
          MsgAlert('Atenção','Status de aprovação não localizado','Info')
	   ENDIF
	ENDIF   	  

    FOR NX:=1 TO nTotNivel
	   cVar:='ZZI_APROV'+alltrim(str(nx))
       cUser:=&cVar
       cVar:='ZZI_STAPR'+alltrim(str(nx))
       
	   IF !EMPTY(cUser)
	      IF &cVar=='A' 
	         cVar:='cStatNv'+alltrim(str(nx))
		     &cVar:="/system/Aprovado.png"

		     cVar:='cNv'+alltrim(str(nx))
	         &cVar:='APROVADO:  '+cUser+'-'+UsrRetName(cUser)
	      ELSEIF &cVar=='Z' 
	         cVar:='cStatNv'+alltrim(str(nx))
		     &cVar:="/system/Aprovado.png"

		     cVar:='cNv'+alltrim(str(nx))
	         &cVar:='APROVACAO AUTOMATICA'
		  ELSE 
		     cVar:='cStatNv'+alltrim(str(nx))
		     &cVar:="/system/Pendente.png"

		     cVar:='cNv'+alltrim(str(nx))
	         &cVar:='PENDENTE:  '+cUser+'-'+UsrRetName(cUser)
	      ENDIF
	   ELSE 
		  cVar:='cStatNv'+alltrim(str(nx))
		  &cVar:=" "

		  cVar:='cNv'+alltrim(str(nx))
	      &cVar:='---*---'

	   ENDIF	  
	NEXT   


	SetPrvt("oFont1","oFont2","oDlg1","oSay4","oGrp1","oSay1","oGrp2","oSay2","oGrp3","oSay3","oPanel1")

	oFont1     := TFont():New( "Century Schoolbook",0,-15,,.T.,0,,500,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Arial Black",0,-27,,.T.,0,,700,.F.,.T.,,,,,, )
	oFont3     := TFont():New( "MS Sans Serif",0,-13,,.F.,0,,700,.F.,.F.,,,,,, )
	
	oDlg1      := MSDialog():New( 146,337,665,1078,"Status de Aprovação",,,.F.,,,,,,.T.,,,.T. )
	
	//oBmp1      := TBitmap():New( 002,010,084,028,,"/system/lgrl"+Alltrim(cEmpAnt)+".bmp",.F.,oDlg1,,,.F.,.T.,,"",.T.,,.T.,,.F. )

	oSay4      := TSay():New( 004,136,{||"STATUS DE APROVAÇÃO"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,020)

	oGrp1      := TGroup():New( 032,012,072,352,"NÍVEL 1 - "+xTitNv1,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 048,068,{||cNv1},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,016)
	oBmp2      := TBitmap():New( 044,024,024,016,,cStatNv1,.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )

	oGrp2      := TGroup():New( 088,012,128,352,"NÍVEL 2 - "+xTitNv2,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 104,068,{||cNv2},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,016)
	oBmp3      := TBitmap():New( 100,025,024,016,,cStatNv2,.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )

	oGrp3      := TGroup():New( 144,012,184,352,"NÍVEL 3 - "+xTitNv3,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay3      := TSay():New( 160,068,{||cNv3},oGrp3,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,016)
	oBmp4      := TBitmap():New( 156,026,024,016,,cStatNv3,.F.,oGrp3,,,.F.,.T.,,"",.T.,,.T.,,.F. )

	oGrp4      := TGroup():New( 200,012,240,352,"NÍVEL 4 - "+xTitNv4,oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay4      := TSay():New( 216,068,{||cNv4},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,220,016)
	oBmp5      := TBitmap():New( 212,026,024,016,,cStatNv4,.F.,oGrp4,,,.F.,.T.,,"",.T.,,.T.,,.F. )


	oBtn1      := TButton():New( 240,316,"Fechar",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)

	RestArea(aArea)


Return()	
	


	/*====================================================================================\
	|Programa  | SemAcao        | Autor | GIOVANI.ZAGO              | Data | 06/012/2013  |
	|=====================================================================================|
	|Descrição | Opçoes do Menu											                  |
	|=====================================================================================|
	|Sintaxe   | SemAcao                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-------------------------*
User Function SemAcao()

Return()

