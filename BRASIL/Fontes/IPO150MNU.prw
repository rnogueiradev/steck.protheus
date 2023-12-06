#Include "Protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AvPrint.ch"
#INCLUDE "Average.ch"
#INCLUDE "rwmake.ch"
                 
#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2
#DEFINE DLG_CHARPIX_H   15.1
#DEFINE DLG_CHARPIX_W    7.9
#DEFINE LITERAL_PEDIDO             IF( nIdioma == INGLES, "PURCHASE ORDER NR: ", "NR. PEDIDO: " 			) //"NR. PEDIDO: "
#DEFINE LITERAL_ALTERACAO          IF( nIdioma == INGLES, "REVISION Number: "  , "ALTERAÃ+O N·mero: " 	) //"ALTERAÃ+O N·mero: "
#DEFINE LITERAL_DATA               IF( nIdioma == INGLES, "Date: "             , "Data: " 					) //"Data: "
#DEFINE LITERAL_PAGINA             IF( nIdioma == INGLES, "Page: "             , "Pßgina: " 				) //"Pßgina: "
#DEFINE LITERAL_FORNECEDOR         IF( nIdioma == INGLES, "SUPPLIER........: " , "FORNECEDOR......: " 	) //"FORNECEDOR......: "
#DEFINE LITERAL_ENDERECO           IF( nIdioma == INGLES, "ADDRESS.........: " , "ENDEREÃO........: " 	) //"ENDEREÃO........: "
#DEFINE LITERAL_REPRESENTANTE      IF( nIdioma == INGLES, "REPRESENTATIVE..: " , "REPRESENTANTE...: " 	) //"REPRESENTANTE...: "
#DEFINE LITERAL_REPR_TEL           IF( nIdioma == INGLES, "TEL.: "             , "FONE: " 					) //"FONE: "
#DEFINE LITERAL_COMISSAO           IF( nIdioma == INGLES, "COMMISSION......: " , "COMISS+O........: " 	) //"COMISS+O........: "
#DEFINE LITERAL_CONTATO            IF( nIdioma == INGLES, "CONTACT.........: " , "CONTATO.........: " 	) //"CONTATO.........: "
#DEFINE LITERAL_IMPORTADOR         IF( nIdioma == INGLES, "IMPORTER........: " , "IMPORTADOR......: " 	) //"IMPORTADOR......: "
#DEFINE LITERAL_CONDICAO_PAGAMENTO IF( nIdioma == INGLES, "TERMS OF PAYMENT: " , "COND. PAGAMENTO.: " 	) //"COND. PAGAMENTO.: "
#DEFINE LITERAL_VIA_TRANSPORTE     IF( nIdioma == INGLES, "MODE OF DELIVERY: " , "VIA TRANSPORTE..: " 	) //"VIA TRANSPORTE..: "
#DEFINE LITERAL_DESTINO            IF( nIdioma == INGLES, "DESTINATION.....: " , "DESTINO.........: " 	) //"DESTINO.........: "
//#DEFINE LITERAL_AGENTE             IF( nIdioma == INGLES, "FORWARDER.......: " , "AGENTE..........: " 	) //"AGENTE..........: "
#DEFINE LITERAL_QUANTIDADE         IF( nIdioma == INGLES, "Quantity"           , "Quantidade" 				) //"Quantidade"
#DEFINE LITERAL_DESCRICAO          IF( nIdioma == INGLES, "Description"        , "DescriþÒo" 				) //"DescriþÒo"
#DEFINE LITERAL_FABRICANTE         IF( nIdioma == INGLES, "Manufacturer"       , "Fabricante" 				) //"Fabricante"
#DEFINE LITERAL_PRECO_UNITARIO1    IF( nIdioma == INGLES, "Unit"               , "Preþo" 					) //"Preþo"
#DEFINE LITERAL_PRECO_UNITARIO2    IF( nIdioma == INGLES, "Price"              , "Unitßrio"				) //"Unitßrio"
#DEFINE LITERAL_TOTAL_MOEDA        IF( nIdioma == INGLES, "Amount"             , "   Total"	 			) //"   Total"
#DEFINE LITERAL_DATA_PREVISTA1     IF( nIdioma == INGLES, "Req. Ship"          , "Data Prev." 				) //"Data Prev."
#DEFINE LITERAL_DATA_PREVISTA2     IF( nIdioma == INGLES, "Date"               , "Embarque" 				) //"Embarque"
#DEFINE LITERAL_OBSERVACOES        IF( nIdioma == INGLES, "REMARKS"            , "OBSERVAÃiES" 			) //"OBSERVAÃiES"
#DEFINE LITERAL_INLAND_CHARGES     IF( nIdioma == INGLES, "INLAND CHARGES"     , "Despesas Internas" 		) //"Despesas Internas"
#DEFINE LITERAL_PACKING_CHARGES    IF( nIdioma == INGLES, "PACKING CHARGES"    , "Despesas Embalagem" 	) //"Despesas Embalagem"
#DEFINE LITERAL_INTL_FREIGHT       IF( nIdioma == INGLES, "INT'L FREIGHT"      , "Frete Internacional" 	) //"Frete Internacional"
#DEFINE LITERAL_DISCOUNT           IF( nIdioma == INGLES, "DISCOUNT"           , "Desconto" 				) //"Desconto"
#DEFINE LITERAL_OTHER_EXPEN        IF( nIdioma == INGLES, "OTHER EXPEN."       , "Outras Despesas" 		) //"Outras Despesas"
#DEFINE LITERAL_STORE              IF( nIdioma == INGLES, "STORE: "            , "Loja" 					) //FDR - 06/01/12 //"Loja"


/*/{Protheus.doc} IPO150MNU

Ponto de Entrada para emissao do relatorio 

@type function
@author Everson Santana
@since 09/02/18
@version Protheus 12 - Easy Import Control

@history , ,

/*/

User Function IPO150MNU()

	Local aRotina:={}
	aAdd(aRotina, { "Steck","U_ST150Impr()", 0 ,0})

	
Return(aRotina)


*----------------------------------------------
User Function ST150Marca()
*----------------------------------------------

	Local aMarcados := {}

	If Select("TRC") > 0
		TRC->(DbCloseArea())
	Endif
		
	_cQuery2 	:= ""
	_cQuery2 	+= " SELECT W2.R_E_C_N_O_ AS R_E_C_N_O_ FROM "+RetSqlName("SW2")+" W2 "
	_cQuery2 	+= " WHERE W2_OK = '"+cMarca+" ' "
	_cQuery2 	+= " AND D_E_L_E_T_ = ' ' "
		
	TcQuery _cQuery2 New Alias "TRC"
		
	dbSelectArea("TRC")
	dbGotop()
		
	While !EOF()
		aAdd(aMarcados,TRC->R_E_C_N_O_)
		dbSelectArea("TRC")
		dbSkip()
	End

Return(aMarcados)

/*
Chamada do relatorio
*/

User Function ST150Impr()

	oDlgIdioma := nVolta := oRadio1 := Nil
	lEnd := nil

	@ (9*DLG_CHARPIX_H),(10*DLG_CHARPIX_W) TO (17*DLG_CHARPIX_H),(45*DLG_CHARPIX_W) DIALOG oDlgIdioma TITLE AnsiToOem("Seleção") //"Seleção"

	@  8,10 TO 48,80 TITLE "Selecione o Idioma" //"Selecione o Idioma"

	nVolta:=0

	oRadio1 := oSend( TRadMenu(), "New", 17, 13, {"Inglês","Idioma Corrente"},{|u| If(PCount() == 0, nIdioma, nIdioma := u)}, oDlgIdioma,,,,,, .F.,, 55, 13,, .F., .T., .T. ) //"Inglês"###"Idioma Corrente"

	oSend( SButton(), "New", 10, 90,1, {|| nVolta:=1, oSend(oDlgIdioma, "End")}, oDlgIdioma, .T.,,)
	oSend( SButton(), "New", 37, 90,2, {|| oSend(oDlgIdioma,"End")}, oDlgIdioma, .T.,,)

	ACTIVATE DIALOG oDlgIdioma CENTERED

	IF nVolta == 1
		ST150Report()
	Endif

Return(Nil)

/*
Impressão do relatorio
*/
Static Function ST150Report()

	#xtranslate :TIMES_NEW_ROMAN_18_NEGRITO    => \[1\]
	#xtranslate :TIMES_NEW_ROMAN_12            => \[2\]
	#xtranslate :TIMES_NEW_ROMAN_12_NEGRITO    => \[3\]
	#xtranslate :COURIER_08_NEGRITO            => \[4\]
	#xtranslate :TIMES_NEW_ROMAN_08_NEGRITO    => \[5\]
	#xtranslate :COURIER_12_NEGRITO            => \[6\]
	#xtranslate :COURIER_20_NEGRITO            => \[7\]
	#xtranslate :TIMES_NEW_ROMAN_10_NEGRITO    => \[8\]
	#xtranslate :TIMES_NEW_ROMAN_08_UNDERLINE  => \[9\]
	#xtranslate :COURIER_NEW_10_NEGRITO        => \[10\]

	#COMMAND    TRACO_NORMAL                   => oSend(oPrn,"Line", Linha  ,  50, Linha  , 2300 ) ;
		;  oSend(oPrn,"Line", Linha+1,  50, Linha+1, 2300 )

	#COMMAND    TRACO_REDUZIDO                 => oSend(oPrn,"Line", Linha  ,1511, Linha  , 2300 ) ; //DFS - 28/02/11 - Posição alterada
	;  oSend(oPrn,"Line", Linha+1,1511, Linha+1, 2300 )

	#COMMAND    ENCERRA_PAGINA                 => oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO) ;
		;  TRACO_NORMAL


	#COMMAND    COMECA_PAGINA [<lItens>]       => AVNEWPAGE                    ;
		;  Linha := 180                 ;
		;  nPagina := nPagina+ 1        ;
		;  pTipo := 2                   ;
		;  ST150Cabec()                 ;
		;  ST150Cab_Itens(<lItens>)
		
		
/*  // Transformado em funcao Static
#xTranslate  DATA_MES(<x>) =>              SUBSTR(DTOC(<x>)  ,1,2)+ " " + ;
                                           IF( nIdioma == INGLES,;
                                               SUBSTR(CMONTH(<x>),1,3),;
                                               SUBSTR(Nome_Mes(MONTH(<x>)),1,3) ) +; 
                                           " " + LEFT(DTOS(<x>)  ,4)

*/
	cIndex := cCond := nIndex := Nil; nOldArea:=ALIAS()
	oFont1:=oFont2:=oFont3:=oFont4:=oFont5:=oFont6:=oFont7:=oFont8:=oFont9:=Nil
	oPrn:= Linha:= aFontes:= Nil; cCliComp:=""
	aCampos:={}; cNomArq:=Nil; aHeader:={}
	lCriaWork:=.T.

	cPictQtde:='@E 999,999,999.999'; cPict1Total:='@E 999,999,999,999.99999'
	cPict2Total:='@E 99,999,999,999,999.99999'
	
	aMarcados := u_ST150Marca()
	nMarcados:=Len(aMarcados)

	IF nMarcados == 0
		MsgInfo("Não existem registros marcados para a impressão !","Atenção") //"NÒo existem registros marcados para a impressÒo !"###"AtenþÒo"

	ELSE
		dbSelectArea("SW2")

		AVPRINT oPrn NAME "EmissÒo do Pedido" //"EmissÒo do Pedido"
      //                              Font            W  H  Bold          Device
		oFont1 := oSend(TFont(),"New","Times New Roman",0,18,,.T.,,,,,,,,,,,oPrn )
		oFont2 := oSend(TFont(),"New","Times New Roman",0,12,,.F.,,,,,,,,,,,oPrn )
		oFont3 := oSend(TFont(),"New","Times New Roman",0,12,,.T.,,,,,,,,,,,oPrn )
		oFont4 := oSend(TFont(),"New","Courier New"    ,0,08,,.T.,,,,,,,,,,,oPrn )
		oFont5 := oSend(TFont(),"New","Times New Roman",0,08,,.T.,,,,,,,,,,,oPrn )
		oFont6 := oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
		oFont7 := oSend(TFont(),"New","Courier New"    ,0,26,,.T.,,,,,,,,,,,oPrn )
		oFont8 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,,,,,,,oPrn )
      //                                                            Underline
		oFont9 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,.T.,,,,,,oPrn )
		oFont10:= oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )

		aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9, oFont10 }

		AVPAGE

		Processa({|X| lEnd := X, ST150Det() })

		AVENDPAGE

		oSend(oFont1,"End")
		oSend(oFont2,"End")
		oSend(oFont3,"End")
		oSend(oFont4,"End")
		oSend(oFont5,"End")
		oSend(oFont6,"End")
		oSend(oFont7,"End")
		oSend(oFont8,"End")
		oSend(oFont9,"End")

		AVENDPRINT

		dbSelectArea("SW2")
		dbGoTop()
	ENDIF
	aMarcados:={}


Return .T.
/*
Detalhe do relatorio
*/

Static Function ST150Det()

	Local nMarcados
	ProcRegua(Len(aMarcados))  //LRL 11/02/04 - ProcRegua(nMarcados))
	Private lMaisPag := .F.
	For nMarcados:=1 To Len(aMarcados)

		SW2->(dbGoTo(aMarcados[nMarcados]))
		IncProc("Imprimindo...") // Atualiza barra de progresso

		Linha := 180
		nTotal:=nTotalGeral:=0
		nPagina:=1
		nCont := 0

		pTipo := 1
		ST150Cabec()

		dbSelectArea("SW3")
		SW3->(dbSetOrder(1))
		SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))

		While SW3->(!Eof()) .AND.;
				SW3->W3_FILIAL == XFILIAL("SW3") .AND. ;
				SW3->W3_PO_NUM == SW2->W2_PO_NUM

			If SW3->W3_SEQ #0
				SW3->(dbSkip())
				LOOP
			Endif

			If Linha >= 3000
				ENCERRA_PAGINA
				COMECA_PAGINA
			Endif

			ST150Item()

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 5
			ST150BateTraco()
			Linha := Linha + 50

			SW3->(dbSkip())
		Enddo //loop dos itens SW3

		cCliComp:= IF(GetMv("MV_ID_CLI")='S',SA1->A1_NOME,SY1->Y1_NOME)
		ST150Totais()
		ST150Remarks()
		
   //SVG - 15/09/2011 - Ajuste no campo observação não deve ter limite de impressão.
		If !lMaisPag
			oSend(oPrn,"Line", Linha, 50, Linha, 1511 )
			oSend(oPrn,"Line", Linha+1, 50, Linha+1, 1511 )
			Linha := Linha + 45
			oSend(oPrn,"Say", Linha, 60, cCliComp, aFontes:TIMES_NEW_ROMAN_12 )
			
		Else
			Linha := Linha+45
			pTipo := 9
			ST150BateTraco()
			oSend(oPrn,"Line", Linha, 50, Linha, 2300 )
			oSend(oPrn,"Say", Linha, 60, cCliComp, aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+100
			oSend(oPrn,"Line", Linha, 50, Linha, 2300 )
			
		EndIf
		//>>
		Linha := Linha+550
		
		ST150Texto()		
		//<<	
   //+---------------------------------------------------------+
   //¦ Atualiza FLAG de EMITIDO                                ¦
   //+---------------------------------------------------------+
		dbSelectArea("SW2")

		RecLock("SW2",.F.)
		SW2->W2_EMITIDO := "S" //PO Impresso
		SW2->W2_OK      := ""  //PO Desmarcado
		MsUnLock()

		If nMarcados+1 <= Len(aMarcados)
			AVNEWPAGE
		Endif

	Next // LOOP DO PO/SW2

Return(nil)
/*
Cabeçalho do Relatorio
*/
Static Function ST150Cabec()

	local i//FSY - 02/05/2013

	c2EndSM0:=""; c2EndSA2:=""; cCommission:=""; c2EndSYT:=""; cTerms:=""
	cDestinat:=""; cRepr:=""; cCGC:=""; cNr:=""

	IF GetMv("MV_ID_CLI") == 'S'
   //-----------> Cliente.
		SA1->( DBSETORDER( 1 ) )
		SA1->( DBSEEK( xFilial("SA1")+SW2->W2_CLIENTE+EICRetLoja("SW2","W2_CLILOJ") ) )
	ELSE
   // --------->  Comprador.
		SY1->( DBSETORDER(1) )
		SY1->( DBSEEK( xFilial("SY1")+SW2->W2_COMPRA ) )
	ENDIF
//----------->  Fornecedor.
	SA2->( DBSETORDER( 1 ) )
	SA2->( DBSEEK( xFilial()+SW2->W2_FORN+EICRetLoja("SW2","W2_FORLOJ") ) )
//----------->  Paises.
	SYA->( DBSETORDER( 1 ) )
	SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )
	c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_MUN   ), ALLTRIM(SA2->A2_MUN   )+' - ', "" )
	c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
	c2EndSA2 := c2EndSA2 + IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )
	IF nIdioma==INGLES
		c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+' - ', "" )
	ELSE
		c2EndSA2 := c2EndSA2 + IF( !EMPTY(SYA->YA_DESCR ), ALLTRIM(SYA->YA_DESCR )+' - ', "" )
	ENDIF
	c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )

//-----------> Pedidos.
	IF SW2->W2_COMIS $ cSim
		cCommission :=SW2->W2_MOEDA+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
		IF( SW2->W2_TIP_COM == "1", cCommission:=TRANS(SW2->W2_PER_COM,E_TrocaVP(nIdioma,'@E 999.99'))+"%", )
			IF( SW2->W2_TIP_COM == "4", cCommission:=SW2->W2_OUT_COM, )
			ENDIF

//-----------> Importador.
			SYT->( DBSETORDER( 1 ) )
			SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )
			cPaisImpor := Alltrim(Posicione("SYA",1,xFilial("SYA")+SYT->YT_PAIS,"YA_DESCR"))    //Acb - 26/11/2010

			c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
			c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
//c2EndSYT := c2EndSYT + IF( !EMPTY(SYT->YT_PAIS  ), ALLTRIM(SYT->YT_PAIS  )+' - ', "" )
			c2EndSYT := c2EndSYT + IF( !EMPTY(cPaisImpor), cPaisImpor  +' - ', "" )    //Acb - 26/11/2010
			c2EndSYT := LEFT( c2EndSYT, LEN(c2EndSYT)-2 )
			cCgc     := ALLTRIM(SYT->YT_CGC)

			IF GetMv("MV_ID_EMPR") == 'S'
				dbSelectArea("SM0")
				dbGotop()
				While !EOF()
					If 	SM0->M0_CODFIL <> "03"
						dbSelectArea("SM0")
						dbSkip()
						Loop
					EndIf
					c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CIDENT), ALLTRIM(SM0->M0_CIDENT)+' - ', "" )
					c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_ESTENT), ALLTRIM(SM0->M0_ESTENT)+' - ', "" )
					c2EndSM0 := c2EndSM0 +IF( !EMPTY(SM0->M0_CEPENT), TRANS(SM0->M0_CEPENT,"@R 99999-999")+' - ', "" )
					c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
					dbSelectArea("SM0")
					dbSkip()
				End
   //acd   cCgc:=ALLTRIM(SM0->M0_CGC)
			ELSE
				c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )
				c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+' - ', "" )
				c2EndSM0 := c2EndSM0 +IF( !EMPTY(SYT->YT_CEP), TRANS(SYT->YT_CEP,"@R 99999-999")+' - ', "" )
				c2EndSM0 := LEFT( c2EndSM0, LEN(c2EndSM0)-2 )
   //acd   cCgc:=ALLTRIM(SYT->YT_CGC)
			ENDIF

//-----------> Condicoes de Pagamento.
			SY6->( DBSETORDER( 1 ) )
			SY6->( DBSEEK( xFilial()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
           
			IF nIdioma == INGLES
				cTerms := MSMM(SY6->Y6_DESC_I,AVSX3("Y6_VM_DESI",3))//48)	//ASR 04/11/2005
			ELSE
				cTerms := MSMM(SY6->Y6_DESC_P,AVSX3("Y6_VM_DESP",3))//48)	//ASR 04/11/2005
			ENDIF
			cTerms := STRTRAN(cTerms, CHR(13)+CHR(10), " ")	//ASR 04/11/2005

//-----------> Portos.
//acd   SY9->( DBSETORDER( 1 ) )
			SY9->( DBSETORDER( 2 ) )
			SY9->( DBSEEK( xFilial()+SW2->W2_DEST ) )

			cDestinat := ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR)

//-----------> Agentes Embarcadores.
			SY4->( DBSETORDER( 1 ) )
			SY4->( DBSEEK( xFilial()+SW2->W2_AGENTE ) ) //W2_FORWARD ) )     // GFP - 10/06/2013

//-----------> Agentes Embarcadores.
			SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

//-----------> Agentes Compradores.
			SY1->(DBSEEK(xFilial()+SW2->W2_COMPRA))


			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
			TRACO_NORMAL
//Linha := Linha+70
			Linha := Linha+5// acb - 29/01/2010

			IF GetMv("MV_ID_EMPR") == 'S'
			
				oSend(oPrn, "SayBitmap", Linha, 100, "\SYSTEM\LGRO0101.bmp" , 400, 200 )
				//oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SM0->M0_NOME)  , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
//   Linha:=Linha+150
				Linha := Linha+100// acb - 29/01/2010
				dbSelectArea("SM0")
				dbGotop()
				While !EOF()
					If 	SM0->M0_CODFIL <> "03"
						dbSelectArea("SM0")
						dbSkip()
						Loop
					EndIf
					oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SM0->M0_ENDENT), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
					dbSelectArea("SM0")
					dbSkip()
				End
				//oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SM0->M0_ENDCOB), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
			ELSE
				If SYT->(FieldPos("YT_COMPEND")) > 0  // TLM - 09/06/2008 Inclusão do campo complemento, SYT->YT_COMPEND
					cNr:=IF(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND),"") + IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
				Else
					cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
				EndIf
				oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SYT->YT_NOME)    , aFontes:TIMES_NEW_ROMAN_18_NEGRITO,,,, 2 )
//   Linha:=Linha+150
				Linha := Linha+100// acb - 29/01/2010
				oSend( oPrn, "Say", Linha    , 1150, ALLTRIM(SYT->YT_ENDE)+ " " + cNr, aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
			ENDIF

			oSend( oPrn, "Say", Linha:= Linha+50, 1150, ALLTRIM(c2EndSM0), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )

			IF GetMv("MV_ID_CLI") == 'S'  // Cliente.

				IF ! EMPTY( ALLTRIM(SA1->A1_TEL) )
					oSend( oPrn, "Say", Linha := Linha+50, 1150, "Tel: " + ALLTRIM(SA1->A1_TEL), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
				ENDIF
				IF ! EMPTY( ALLTRIM(SA1->A1_FAX) )
					oSend( oPrn, "Say", Linha := Linha+50, 1150, "Fax: " + ALLTRIM(SA1->A1_FAX), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
				ENDIF

			ELSE                         // Comprador.

				IF ! EMPTY( ALLTRIM(SY1->Y1_TEL) )
					oSend( oPrn, "Say", Linha := Linha+50, 1150, "Tel: " + ALLTRIM(SY1->Y1_TEL), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
				ENDIF
				IF ! EMPTY( ALLTRIM(SY1->Y1_FAX) )
					oSend( oPrn, "Say", Linha := Linha+50, 1150, "Fax: " + ALLTRIM(SY1->Y1_FAX), aFontes:TIMES_NEW_ROMAN_12,,,, 2 )
				ENDIF

			ENDIF
//Linha := Linha+100
			Linha := Linha+50// acb - 29/01/2010

			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
			TRACO_NORMAL
//Linha := Linha+30
			Linha := Linha+10// acb - 29/01/2010

			oSend( oPrn, "Say", Linha, 1150, LITERAL_PEDIDO + ALLTRIM(TRANS(SW2->W2_PO_NUM,_PictPo)), aFontes:TIMES_NEW_ROMAN_12,,,,2 )
//Linha := Linha+100
			Linha := Linha+50// acb - 29/01/2010

			IF ! EMPTY(SW2->W2_NR_ALTE)
				oSend( oPrn, "Say", Linha, 400 , LITERAL_ALTERACAO + STRZERO(SW2->W2_NR_ALTE,2) , aFontes:TIMES_NEW_ROMAN_12 )
				oSend( oPrn, "Say", Linha, 1770, LITERAL_DATA + DATA_MES( SW2->W2_DT_ALTE )     , aFontes:TIMES_NEW_ROMAN_12 )
//Linha := Linha+100
				Linha := Linha+50// acb - 29/01/2010
			ENDIF

//oSend( oPrn, "Say", Linha, 400 , LITERAL_DATA + DATA_MES( dDataBase ) , aFontes:TIMES_NEW_ROMAN_12 )
			oSend( oPrn, "Say", Linha, 400 , LITERAL_DATA + DATA_MES( SW2->W2_PO_DT ) , aFontes:TIMES_NEW_ROMAN_12 )
			oSend( oPrn, "Say", Linha, 1770, LITERAL_PAGINA + STRZERO(nPagina,3)  , aFontes:TIMES_NEW_ROMAN_12 )
//Linha := Linha+100
			Linha := Linha+50// acb - 29/01/2010

			If pTipo == 2  // A partir da 2o. página.
				Return
			Endif

			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
			TRACO_NORMAL

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 3
			ST150BateTraco()
			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_FORNECEDOR, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, SA2->A2_NREDUZ + Space(2) + Alltrim(IF(EICLOJA(), LITERAL_STORE /*"Loja:"*/ + Alltrim(SA2->A2_LOJA),"")) , aFontes:TIMES_NEW_ROMAN_12 ) //FDR - 06/01/12
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_ENDERECO, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SA2->A2_END)+" "+ALLTRIM(SA2->A2_NR_END), aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			If !Empty(SA2->A2_COMPLEM)  // GFP - 31/10/2013
				oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SA2->A2_COMPLEM), aFontes:TIMES_NEW_ROMAN_12 )
				Linha := Linha+50
			EndIf

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 630, c2EndSA2              , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 630, SA2->A2_CEP           , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			cRepr:=IF(nIdioma==INGLES,"NONE","NAO HA")

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_REPRESENTANTE, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, IF(EMPTY(SA2->A2_REPRES),cRepr,SA2->A2_REPRES)       , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_ENDERECO, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, SA2->A2_REPR_EN , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_COMISSAO, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, cCommission     , aFontes:TIMES_NEW_ROMAN_12 )

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha,1750, LITERAL_REPR_TEL, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha,1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRTEL,ALLTRIM(SA2->A2_DDI)+" "+ALLTRIM(SA2->A2_DDD)+" "+SA2->A2_TEL)), aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_CONTATO, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, SA2->A2_CONTATO, aFontes:TIMES_NEW_ROMAN_12 )

			oSend( oPrn, "Say",  Linha,1750, "FAX.: "           , aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha,1910, ALLTRIM(IF(!EMPTY(SA2->A2_REPRES),SA2->A2_REPRFAX,ALLTRIM(SA2->A2_DDI)+" "+ALLTRIM(SA2->A2_DDD)+" "+SA2->A2_FAX)), aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 3
			ST150BateTraco()

			Linha := Linha+20
			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
			TRACO_NORMAL
			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_IMPORTADOR, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, SYT->YT_NOME      , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			IF SYT->(FieldPos("YT_COMPEND")) > 0  // TLM - 09/06/2008 Inclusão do campo complemento, SYT->YT_COMPEND
				cNr:=If(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND),"") + IF(!EMPTY(SYT->YT_NR_END),", " +  ALLTRIM(STR(SYT->YT_NR_END,6)),"")
			Else
				cNr:=IF(!EMPTY(SYT->YT_NR_END),", "+ALLTRIM(STR(SYT->YT_NR_END,6)),"")
			EndIF
			oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SYT->YT_ENDE)+ " " + cNr, aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 630, c2EndSYT           , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			IF ! EMPTY(cCGC)
				oFnt := aFontes:COURIER_20_NEGRITO
				pTipo := 1
				ST150BateTraco()

				oSend( oPrn, "Say",  Linha, 630, AVSX3("YT_CGC",5)+": "  + Trans(cCGC,"@R 99.999.999/9999-99") , aFontes:TIMES_NEW_ROMAN_12 ) // "C.N.P.J. "
				Linha := Linha+50
			ENDIF

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 3
			ST150BateTraco()

			Linha := Linha+20
			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO)
			TRACO_NORMAL
			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100 , "PROFORMA INVOICE: ", aFontes:COURIER_12_NEGRITO ) //"PROFORMA INVOICE: "
			oSend( oPrn, "Say",  Linha, 1720, LITERAL_DATA            , aFontes:COURIER_12_NEGRITO )

//TRP-12/08/08
			If lNewProforma .and. GetMv("MV_AVG0186",,.F.) // NCF - 05/01/2010 - Criação do Parâmetro MV_AVG0186 que define se as informações da proforma
                                          //                    virão da capa do PO (.F.) ou se virão da tabela de manutenção de proformas (.T.)
				EYZ->(DbSetOrder(2))
				EYZ->(DbSeek(xFilial("EYZ")+ SW2->W2_PO_NUM ))

				Do While EYZ->(!EOF()) .AND. xFilial("EYZ") == EYZ->EYZ_FILIAL .AND. EYZ->EYZ_PO_NUM == SW2->W2_PO_NUM

					oSend( oPrn, "Say",  Linha, 630 , EYZ->EYZ_NR_PRO         , aFontes:TIMES_NEW_ROMAN_12 )
					oSend( oPrn, "Say",  Linha, 1920, DATA_MES(EYZ->EYZ_DT_PRO), aFontes:TIMES_NEW_ROMAN_12 )
					Linha := Linha+50

					EYZ->(DbSkip())
				Enddo
			Else
				oSend( oPrn, "Say",  Linha, 630 , SW2->W2_NR_PRO          , aFontes:TIMES_NEW_ROMAN_12 )
				oSend( oPrn, "Say",  Linha, 1920, DATA_MES(SW2->W2_DT_PRO), aFontes:TIMES_NEW_ROMAN_12 )
			Endif
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 3
			ST150BateTraco()

			Linha := Linha+20
			oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO)
			TRACO_NORMAL

			nLinCp := Max(MLCOUNT( cTerms, 80 ),1)

			oSend(oPrn,"Line", Linha-50,   50, (Linha+100+50*nLinCp),   50 ) ; oSend(oPrn,"Line", Linha-50,   51, (Linha+100+50*nLinCp),   51 )
			oSend(oPrn,"Line", Linha-50, 2300, (Linha+100+50*nLinCp), 2300 ) ; oSend(oPrn,"Line", Linha-50, 2301, (Linha+100+50*nLinCp), 2301 )

			Linha := Linha+20//FSY - 02/05/2013

			oSend( oPrn, "Say",  Linha, 100, LITERAL_CONDICAO_PAGAMENTO , aFontes:COURIER_12_NEGRITO )
//ASR 04/11/2005 - oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,48,1)      , aFontes:TIMES_NEW_ROMAN_12 )
			IF nIdioma == INGLES
   //oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,48,1)      , aFontes:TIMES_NEW_ROMAN_12 )
				FOR i:=1 TO MLCOUNT( cTerms, 80 )//FSY - Para imprimir toda descrição do pagamento - 02/05/2013
					oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,80,i)      , aFontes:TIMES_NEW_ROMAN_12 )
					Linha := Linha+50
				Next
			ELSE
   //oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,48,1)      , aFontes:TIMES_NEW_ROMAN_12 )
				FOR i:=1 TO MLCOUNT( cTerms, 80 )//FSY - Para imprimir toda descrição do pagamento - 02/05/2013
					oSend( oPrn, "Say",  Linha, 630, MEMOLINE(cTerms,80,i)      , aFontes:TIMES_NEW_ROMAN_12 )
					Linha := Linha+50
				Next
			ENDIF
			If MLCOUNT( cTerms, 80 ) == 0//FSY - 02/05/2013
				Linha := Linha+50
			EndIf

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 3
			ST150BateTraco()

			Linha := Linha+20
			oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )

			oSend( oPrn, "Line",  Linha  ,  50, Linha  , 2300 )
			oSend( oPrn, "Line",  Linha+1,  50, Linha+1, 2300 )
			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, "INCOTERMS.......: " , aFontes:COURIER_12_NEGRITO ) //"INCOTERMS.......: "
			oSend( oPrn, "Say",  Linha, 630, ALLTRIM(SW2->W2_INCOTERMS)+" "+ALLTRIM(SW2->W2_COMPL_I), aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

//LRS - 16/03/2015 - Pegar o tipo via Transporte de acordo com o Idioma do relatorio
			SX5->(DbSetOrder(1))
			SX5->(dbSeek(xFilial("SX5")+"Y3"+Alltrim(SubStr(SYQ->YQ_COD_DI,1,1))))

			oSend( oPrn, 'SAY',  Linha, 100, LITERAL_VIA_TRANSPORTE , aFontes:COURIER_12_NEGRITO )
			If nIdioma == INGLES
				oSend( oPrn, 'SAY',  Linha, 630, SX5->X5_DESCENG        , aFontes:TIMES_NEW_ROMAN_12 )
			ElseIF nIdioma == PORTUGUES
				oSend( oPrn, 'SAY',  Linha, 630, SX5->X5_DESCRI         , aFontes:TIMES_NEW_ROMAN_12 )
			ElseIF nIdioma == ESPANHOL
				oSend( oPrn, 'SAY',  Linha, 630, SX5->X5_DESCSPA        , aFontes:TIMES_NEW_ROMAN_12 )
			EndIF
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha, 100, LITERAL_DESTINO , aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, cDestinat       , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 1
			ST150BateTraco()

			//oSend( oPrn, "Say",  Linha, 100, LITERAL_AGENTE, aFontes:COURIER_12_NEGRITO )
			oSend( oPrn, "Say",  Linha, 630, SY4->Y4_NOME  , aFontes:TIMES_NEW_ROMAN_12 )
			Linha := Linha+50

			ST150Cab_Itens()

			Return

*--------------------------------*
		Static FUNCTION ST150Cab_Itens(lImp)
*--------------------------------*
			Default lImp := .T.
			If !lImp
				Return Nil
			EndIf

			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 4
			ST150BateTraco()

			oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO)  // Define fonte padrao
			TRACO_NORMAL

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 2
			ST150BateTraco()

			Linha := Linha+20

			oFnt := aFontes:COURIER_20_NEGRITO
			pTipo := 4
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha,  065, "IT"                , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"IT"
			oSend( oPrn, "Say",  Linha,  200, LITERAL_QUANTIDADE     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha,  470, LITERAL_DESCRICAO      , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha, 1500, LITERAL_FABRICANTE     , aFontes:TIMES_NEW_ROMAN_10_NEGRITO,,,,1 )
			oSend( oPrn, "Say",  Linha, 1570, LITERAL_PRECO_UNITARIO1, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha, 1840, LITERAL_TOTAL_MOEDA    , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha, 2130, LITERAL_DATA_PREVISTA1 , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			Linha := Linha+50

			pTipo := 5
			oFnt := aFontes:COURIER_20_NEGRITO
			ST150BateTraco()

			oSend( oPrn, "Say",  Linha,   65, "Nb"		                , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Nb"
			oSend( oPrn, "Say",  Linha, 1570, LITERAL_PRECO_UNITARIO2, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha, 1870, SW2->W2_MOEDA          , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
			oSend( oPrn, "Say",  Linha, 2130, LITERAL_DATA_PREVISTA2 , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )

			Linha := Linha+50

			oSend(oPrn,"oFont", aFontes:COURIER_20_NEGRITO) // Define fonte padrao

			TRACO_NORMAL

			Return(Nil)


		Static FUNCTION ST150Item()

			Local i
			Private cNomeFantasia := ""
			cPointS :="EICPOOLI"
			i := n1 := n2 := nil
			nNumero := 1
			bAcumula := bWhile := lPulaLinha := nil
			nTam := 25 //36 //DFS - 31/05/11 - Redução do tamanho da descrição por linha para que, ao gerar pdf, descrição do produto e fabricante não fiquem concatenadas.
			cDescrItem := "" //Esta variavel é Private por causa do Rdmake "EICPOOLI"

//-----------> Unidade Requisitante (C.Custo).
			SY3->( DBSETORDER( 1 ) )
			SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

//-----------> Fornecedores.
			SA2->( DBSETORDER( 1 ) )
			SA2->( DBSEEK( xFilial()+SW3->W3_FABR+EICRetLoja("SW3","W3_FABLOJ") ) )

//-----------> Reg. Ministerio.
			SYG->( DBSETORDER( 1 ) )
			SYG->( DBSEEK( xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+EICRetLoja("SW3","W3_FABLOJ")+SW3->W3_COD_I ) )

//-----------> Produtos (Itens) e Textos.
			SB1->( DBSETORDER( 1 ) )
			SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )


			If ExistBlock(cPointS)
				ExecBlock(cPointS,.f.,.f.)
			Endif

			cDescrItem := MSMM(IF( nIdioma==INGLES, SB1->B1_DESC_I, SB1->B1_DESC_P ),36)
			STRTRAN(cDescrItem,CHR(13)+CHR(10), " ")

			IF(lPoint1P,ExecBlock(cPoint1P,.F.,.F.,"2"),)

//-----------> Produtos X Fornecedor.
				SA5->( DBSETORDER( 3 ) )
//SA5->( DBSEEK( xFilial()+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN ) )
				EICSFabFor(xFilial("SA5")+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN, EICRetLoja("SW3", "W3_FABLOJ"), EICRetLoja("SW3", "W3_FORLOJ"))

				oFnt := aFontes:COURIER_20_NEGRITO
				pTipo := 5
				ST150BateTraco()

				Linha := Linha + 50
				oFnt := aFontes:COURIER_20_NEGRITO
				pTipo := 5
				ST150BateTraco()

				nCont:=nCont+1
				oSend( oPrn, "Say",  Linha,  65, STRZERO(nCont,3),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 370, TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,cPictQtde)),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
/*
   If !Empty(SA5->A5_UNID)
      oSend( oPrn, "Say",  Linha, 400, SA5->A5_UNID, aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   Else
      oSend( oPrn, "Say",  Linha, 400, SB1->B1_UM,   aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   Endif
*/                                               
//SO.:0022/02 OS.:0148/02
				oSend( oPrn, "Say",  Linha, 400, BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM,IF(EICLOJA(),SW3->W3_FABLOJ,""),IF(EICLOJA(),SW3->W3_FORLOJ,"")),   aFontes:TIMES_NEW_ROMAN_08_NEGRITO )

				IF MLCOUNT(cDescrItem,nTam) == 1 .OR. lPoint1P
					oSend( oPrn, "Say",  Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
				ELSE
// oSend( oPrn, "Say",  Linha, 480, AV_Justifica(MEMOLINE( cDescrItem,nTam ,1 )),aFontes:COURIER_NEW_10_NEGRITO )
					oSend( oPrn, "Say",  Linha, 480, MEMOLINE( cDescrItem,nTam ,1 ),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
				ENDIF
//Inicio LRS 23/08/2013 14:06 Adicionado uma variavel para pegar o tamanho do texto vindo do A2_NREDUZ 
//e fazendo um Len/2 para quebrar a descrição em 2 se a variavel for maior que 50
				cNomeFantasia := (SA2->A2_NREDUZ)

				If Len(Alltrim(cNomeFantasia)) > 50

					oSend( oPrn, "Say",  Linha,1450, LEFT(AllTrim(SA2->A2_NREDUZ),len(cNomeFantasia)/2) + Space(2) + IF(EICLOJA(), LITERAL_STORE /*"Loja:"*/ + Alltrim(SA2->A2_LOJA),"") ,aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 ) //FDR - 06/01/12
					Linha := Linha + 30
					oSend( oPrn, "Say",  Linha,1300, RIGHT(AllTrim(SA2->A2_NREDUZ),len(cNomeFantasia)/2) + Space(2) ,aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1)
					Linha := Linha - 30
				else
					oSend( oPrn, "Say",  Linha,1450, AllTrim(SA2->A2_NREDUZ) + Space(2) + IF(EICLOJA(), LITERAL_STORE /*"Loja:"*/ + Alltrim(SA2->A2_LOJA),"") ,aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				endIF
//Fim LRS	
				oSend( oPrn, "Say",  Linha,1740, TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 999,999,999.99999')),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				oSend( oPrn, "Say",  Linha,2100, TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total )),aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				oSend( oPrn, "Say",  Linha,2130, DATA_MES(SW3->W3_DT_EMB),aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
//SVG 18/11/08            
				nTotal := DI500TRANS(nTotal + SW3->W3_QTDE*SW3->W3_PRECO,2)
				Linha  := Linha + 50

// Part. Number + Part. Number Opc. + Reg. Minis. - 1o. Linha Descr. ja batida.
				n1 := ( MlCount( cDescrItem, nTam ) + 1 + 2 + 1 ) - 1
				n2 := 0   //acd   MLCOUNT( SUBSTR(ALLTRIM(SY3->Y3_DESC),1,LEN(SY3->Y3_DESC)-12), 12 )
				n1 := IF( n1 > n2, n1, n2 )

				FOR i:=2 TO n1 + 1   // Soma um para bater o ultimo.

					lPulaLinha := .F.

					IF Linha >= 3000
						ENCERRA_PAGINA
						COMECA_PAGINA

						oFnt := aFontes:COURIER_20_NEGRITO
						pTipo := 5
						ST150BateTraco()

						Linha := Linha+50
					ENDIF

					IF !EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
						IF MLCOUNT(cDescrItem,nTam) == i .OR. lPoint1P
							oSend( oPrn, "Say",  Linha, 480,MEMOLINE( cDescrItem,nTam,i ), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
						ELSE
//        oSend( oPrn, "Say",  Linha, 480,AV_Justifica( MEMOLINE( cDescrItem,nTam,i ) ), aFontes:COURIER_NEW_10_NEGRITO )
							oSend( oPrn, "Say",  Linha, 480,MEMOLINE( cDescrItem,nTam,i  ), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
						ENDIF
						lPulaLinha := .T.
					ENDIF

					IF EMPTY( MEMOLINE( cDescrItem,nTam, i ) )
						IF nNumero == 1
							If SW3->(FieldPos("W3_PART_N")) # 0 .And. !Empty(SW3->W3_PART_N)
								oSend( oPrn, "Say",  Linha, 480 , SW3->W3_PART_N,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
								lPulaLinha := .T.
							Else
								If !Empty( SA5->A5_CODPRF )
									oSend( oPrn, "Say",  Linha, 480 , SA5->A5_CODPRF,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
									lPulaLinha := .T.
								Endif
							EndIf
							nNumero := nNumero+1

						ELSEIF nNumero == 2
							If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,1) )
								oSend( oPrn, "Say",  Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,1),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
								lPulaLinha := .T.
							Endif
							nNumero := nNumero+1

						ELSEIF nNumero == 3
							If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,2) )
								oSend( oPrn, "Say",  Linha, 480 , MEMOLINE(SA5->A5_PARTOPC,24,2),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
								lPulaLinha := .T.
							Endif
							nNumero := nNumero+1

						ELSEIF nNumero == 4
							If !Empty( SYG->YG_REG_MIN )
								oSend( oPrn, "Say",  Linha, 480 , SYG->YG_REG_MIN,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
								lPulaLinha := .T.
							Endif
							nNumero := nNumero+1

						ENDIF
					ENDIF
    
   //DFS - 09/05/11 - Comentado, porque estava duplicando os ultimos caracteres do nome do Fornecedor.
   /* IF !EMPTY( LEFT(SA2->A2_NREDUZ, 15 ) )  .AND.  i == 2
       oSend( oPrn, "Say",  Linha,1500, LEFT(SA2->A2_NREDUZ,15), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
       lPulaLinha := .T.
    ENDIF */

					oFnt := aFontes:COURIER_20_NEGRITO
					pTipo := 5
					ST150BateTraco()

					If lPulaLinha
						Linha := Linha+50
					Endif

				NEXT

				Return

*---------------------------*
			Static FUNCTION ST150Totais()
*---------------------------*
				Local nTLinha := 0

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 5
				ST150BateTraco()
				Linha := Linha+50

				If Linha >= 2060
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_NORMAL
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()

				oSend( oPrn, "Say",  Linha,1570, "TOTAL ", aFontes:COURIER_08_NEGRITO ) //"TOTAL " //DFS - 28/02/11 - Posicionamento correto
				nTLinha := Linha
				oSend( oPrn, "Say",  Linha,2100, TRANS(nTotal,E_TrocaVP(nIdioma,cPict2Total))  , aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

				Linha := Linha+50

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()
             
				oSend( oPrn, "Say",  Linha, 1570 , LITERAL_INLAND_CHARGES , aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(SW2->W2_INLAND,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				Linha := Linha + 50

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50

				else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()

				oSend( oPrn, "Say",  Linha, 1570 , LITERAL_PACKING_CHARGES , aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				Linha := Linha+50

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()

				oSend( oPrn, "Say",  Linha, 1570 , LITERAL_INTL_FREIGHT , aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(SW2->W2_FRETEINT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				Linha := Linha+50

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()
				oSend( oPrn, "Say",  Linha, 1570 , LITERAL_DISCOUNT , aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(SW2->W2_DESCONT,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				Linha := Linha+50

				If Linha >=2730
					ENCERRA_PAGINA
					COMECA_PAGINA
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco(20)
				oSend( oPrn, "Say",  Linha, 1570 , LITERAL_OTHER_EXPEN , aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(SW2->W2_OUT_DES,E_TrocaVP(nIdioma,'@E 999,999,999,999.99')), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
				Linha := Linha+50

				If Linha >=2730
					ENCERRA_PAGINA
					COMECA_PAGINA
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					Linha := Linha+50
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 6
					ST150BateTraco()
					TRACO_REDUZIDO
					Linha := Linha+50
				Endif

//SVG 18/11/08 
//TDF 02/02/12 - TRATAMENTO PARA FRETE INCLUSO SIM        
				If SW2->W2_FREINC == "1"  // GFP - 06/03/2014
					nTotalGeral := DI500TRANS((nTotal+SW2->W2_OUT_DES)-SW2->W2_DESCONT,2)
				Else
					nTotalGeral := DI500TRANS((nTotal+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEINT+SW2->W2_OUT_DES)-SW2->W2_DESCONT,2)
				EndIf

				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 6
				ST150BateTraco()

				oSend( oPrn, "Say",  Linha, 1570 , "TOTAL " + ALLTRIM( SW2->W2_INCOTER )         , aFontes:COURIER_08_NEGRITO ) //"TOTAL "
				oSend( oPrn, "Say",  Linha, 1780 , SW2->W2_MOEDA,aFontes:COURIER_08_NEGRITO )
				oSend( oPrn, "Say",  Linha, 2100 , TRANS(nTotalGeral,E_TrocaVP(nIdioma,cPict2Total)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

				Linha := Linha+50

				oSend( oPrn, "oFont", aFontes:COURIER_20_NEGRITO )
				TRACO_NORMAL
				Linha := Linha+50
						
				
				
				//Linha := Linha+200
				
				Linha := nTLinha
				
				//
				
				RETURN NIL


			Static FUNCTION ST150Remarks()

				Local i
				i := bWhile := bAcumula := nil
				cRemarks:=""
				cRemarks := MSMM(SW2->W2_OBS,60)
				STRTRAN(cRemarks,CHR(13)+CHR(10), " ")

// TDF - 15/07/10
				oSend( oPrn, "Say",  Linha, 065, LITERAL_OBSERVACOES, aFontes:TIMES_NEW_ROMAN_08_UNDERLINE )
				Linha := Linha+50
				nTamLinha := 110
//SVG - 15/09/2011 - Ajuste no campo observação não deve ter limite de impressão.
				nTamanhoLn := 82
				nLinRemark := 1
				While !Empty(cRemarks)
					If (nPos := At(CHR(13)+CHR(10), cRemarks)) > 0
						cLinha := SubStr(cRemarks, 1, nPos - 1)
						if nPos > nTamanhoLn
							cLinha := SubStr(cRemarks, 1, nTamanhoLn)
         //Imprime
							oSend( oPrn, "Say",  Linha, 065 , cLinha,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
							cRemarks := SubStr(cRemarks,nTamanhoLn)
						Else
							oSend( oPrn, "Say",  Linha, 065 , cLinha,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
							cRemarks := SubStr(cRemarks, nPos + 2)
						EndIf
					Else
						If Len(cRemarks) < nTamanhoLn
							nTamanhoLn := Len(cRemarks)
						EndIf
						cLinha := SubStr(cRemarks, 1, nTamanhoLn)
      //Imprime 
						oSend( oPrn, "Say",  Linha, 065 , cLinha,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
						cRemarks := SubStr(cRemarks, nTamanhoLn + 1)
					EndIf
   
					Linha := Linha+50
   
					If nLinRemark == 10
						nTamanhoLN := 165//nTamanhoLN +(nTamanhoLN/ 2)
					EndIf
   
					If nLinRemark == 10 .Or. Linha >= 3000
						TRACO_NORMAL
						ENCERRA_PAGINA
						COMECA_PAGINA(.F.)
						TRACO_NORMAL
						Linha := Linha
						pTipo := 8
						ST150BateTraco()
						oFnt  := aFontes:COURIER_20_NEGRITO
						Linha := Linha+50
						lMaisPag := .T.
					EndIf
   
					If nLinRemark >= 10
						Linha := Linha
						pTipo := 8
						ST150BateTraco()
					EndIf

					++nLinRemark

				EndDo
//***SVG - 15/09/2011 - Ajuste no campo observação não deve ter limite de impressão.

/*
FOR i:=1 TO MIN(MLCOUNT( cRemarks, nTamLinha ),10) 
   
   IF !EMPTY(MEMOLINE( cRemarks,nTamLinha, i ))
      oSend( oPrn, "Say",  Linha, 065 , MEMOLINE( cRemarks,nTamLinha, i ),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
   ENDIF 

   Linha := Linha+50

NEXT

*/
				RETURN NIL


			Static FUNCTION ST150BateTraco()
*----------------------------------------*
				xLinha := nil

				If pTipo == 1      .OR.  pTipo == 2  .OR. pTipo == 7 .OR. pTipo == 9
					xLinha := 100
				ElseIf pTipo == 3  .OR.  pTipo == 4
					xLinha := 20
				ElseIf pTipo == 5  .OR.  pTipo == 6 .Or. pTipo == 8
					xLinha := 50
				Endif

				oSend(oPrn,"oFont",oFnt)

				DO CASE

				CASE pTipo == 1  .OR.  pTipo == 3
					oPrn:Box( Linha,  50, (Linha+xLinha),  51)
					oPrn:Box( Linha,2300, (Linha+xLinha),2301)

				CASE pTipo == 2  .OR.  pTipo == 4  .OR.  pTipo == 5
					oPrn:Box( Linha,  50, (Linha+xLinha),  51)
					oPrn:Box( Linha, 120, (Linha+xLinha), 121)
					oPrn:Box( Linha, 460, (Linha+xLinha), 461)
					oPrn:Box( Linha,1510, (Linha+xLinha),1511)
					oPrn:Box( Linha,1750, (Linha+xLinha),1751)
					oPrn:Box( Linha,2110, (Linha+xLinha),2111)
					oPrn:Box( Linha,2300, (Linha+xLinha),2301)

				CASE pTipo == 6  .OR.  pTipo == 7
					oPrn:Box( Linha,  50, (Linha+xLinha),  51)
					oPrn:Box( Linha,1510, (Linha+xLinha),1511) //DFS - 28/02/11 - Posicionamento das linhas
					oPrn:Box( Linha,2300, (Linha+xLinha),2301)
   
				Case pTipo == 8
					oPrn:Box( Linha,  50, (Linha+xLinha),  51)
					oPrn:Box( Linha,2300, (Linha+xLinha),2301)
				CASE pTipo == 9
					oPrn:Box( Linha,  50, (Linha+xLinha),  51)
//        oPrn:Box( Linha,1510, (Linha+xLinha),1511) //DFS - 28/02/11 - Posicionamento das linhas
					oPrn:Box( Linha,2300, (Linha+xLinha),2301)
				ENDCASE

				RETURN NIL
				
				
*----------------------------------------*
			Static Function DATA_MES(x)
*----------------------------------------*

				IF !Empty(x)
					Return SUBSTR(DTOC(x)  ,1,2)+ " " + IF( nIdioma == INGLES, SUBSTR(CMONTH(x),1,3),;
						SUBSTR(Nome_Mes(MONTH(x)),1,3) ) + " " + LEFT(DTOS(x)  ,4)
				EndIf

				Return ""

Static FUNCTION ST150Texto()

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif
				
	
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					//TRACO_NORMAL
				Endif
				oSend( oPrn, "Say",  Linha,065, "STECK and its suppliers, commit to the following principles: ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
		
				oSend( oPrn, "Say",  Linha,065, "Promote the commitments included in “The Global Compact” pertaining to human rights, labour standards,", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif

				oSend( oPrn, "Say",  Linha,065, "environment and anti-corruption.  ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "The 10 commitments of The Global Compact are: ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif

				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
		
				oSend( oPrn, "Say",  Linha,065, "Human Rights ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 1: Businesses should support and respect the protection of internationally proclaimed human rights.  ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 8
				ST150BateTraco()
				oSend( oPrn, "Say",  Linha,065, "Principle 2: Make sure that they are not complicit in human rights abuses. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif
				
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Labour Standards ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 3: Businesses should uphold the freedom of association and the effective recognition of the right to collective ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
				
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,290, "bargaining;  ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
				
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 4: The elimination of all forms of forced and compulsory labour. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif

				oSend( oPrn, "Say",  Linha,065, "Principle 5: The effective abolition of child labour. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 6: The elimination of discrimination in respect of employment and occupation. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
				
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif
						
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif

				oSend( oPrn, "Say",  Linha,065, "Environment ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
			If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 7: Businesses should support a precautionary approach to environmental challenges. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
			If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 8: Undertake initiatives to promote greater environmental responsibility. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				oFnt  := aFontes:COURIER_20_NEGRITO
				pTipo := 8
				ST150BateTraco()
				oSend( oPrn, "Say",  Linha,065, "Principle 9: Encourage the development and diffusion of environmentally friendly technologies. ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
			
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					Linha := Linha+50
				Endif
					
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Anti-Corruption ", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				If Linha >= 3000
					ENCERRA_PAGINA
					COMECA_PAGINA

					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
					TRACO_NORMAL
				Else
					oFnt  := aFontes:COURIER_20_NEGRITO
					pTipo := 8
					ST150BateTraco()
				Endif
				oSend( oPrn, "Say",  Linha,065, "Principle 10: Businesses should work against corruption in all its forms, including extortion and bribery.", aFontes:COURIER_08_NEGRITO )
				Linha := Linha+50
		
				TRACO_NORMAL
		


				RETURN NIL
				
				
				