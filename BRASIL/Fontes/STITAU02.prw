//Última alteração 28/09/2017

#INCLUDE "RWMAKE.CH"
#include "TBICONN.CH"
#include "TBICODE.CH"
#include "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BOLITAU  ³ Autor ³ Microsiga             ³ Data ³ 26/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO ITAU COM CODIGO DE BARRAS        ³±±
±±³			 ³ FINANCEIRO											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BOLITAU()
	
	LOCAL	aPergs := {}
	PRIVATE lExec    := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	Private _cBanco	:= ""
	Private _cBancoR  := ""
	
	Tamanho  := "M"
	titulo   := "Impressao de Boleto com Codigo de Barras"
	cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SE1"
	wnrel    := "BOL341"
	lEnd     := .F.
	cPerg     :="BOL341    "
	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0
	
	dbSelectArea("SE1")
	
	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//--- Marciane - 11/10/05 - Informar qual a carteira do boleto
	//Aadd(aPergs,{"Carteira","","","mv_chj","C",3,0,0,"G","","MV_PAR19","","","","175","","","","","","","","","","","","","","","","","","","","","Z2","","","",""})
	//--- fim Marciane 11/10/05
	
	AjustaSx1("BOL341    ",aPergs)
	
	Pergunte (cPerg,.t.)
	
	
	cIndexName	:= Criatrab(Nil,.F.)
	//cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cIndexKey	:= "E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+DTOS(E1_EMISSAO)" //alterado Por Nádia em 12/08/13
	cFilter		+= "E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
	cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
	cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
	cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
	cFilter		+= "!(E1_TIPO$MVABATIM).And."
	cFilter		+= "E1_PORTADO $ ('001#341#237') "
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	
	dbGoTop()
	If lExec
		
		
		dbGoTop()
		ProcRegua(RecCount())
		Do While !EOF()
			IncProc()
			Processa({U_MONTAR(,,,,.T.,SE1->E1_NUM,SE1->E1_NUM,E1_PREFIXO,SE1->E1_NUM,,)})
			
			
		EndDo
	Endif
	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
	LOCAL oPrint
	LOCAL nX := 0
	
	//--- Marciane 11.10.05 - Criar variaveis para a agencia
	Local _cNomeAgen := ""
	Local _cCNPJAgen := ""
	LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
	
	Local _cMulta	   :=  GetMV("MV_XTXMUL")
	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatSacado
	LOCAL nI           := 1
	LOCAL aCB_RN_NN    := {}
	LOCAL nVlrAbat		:= 0
	Local _nDiasAtraso	:= 0
	Local _nJuros		:= 0
	Local _nMulta		:= 0
	cNroDoc :=  " "
	
	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página
	
	dbGoTop()
	ProcRegua(RecCount())
	Do While !EOF()
		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
		
		//Posiciona na Arq de Parametros CNAB
		DbSelectArea("SEE")
		DbSetOrder(1)
		// ALTERADO EM 050112
		If !DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
			MsgBox("Banco/Ag/conta nao cadastrado em parametros de bancos ref titulo: " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			DbSelectArea("SE1")
			DbSkip()
			Loop
		endif
		
		Do Case
		Case SEE->EE_CODIGO=="341"
			_cBanco := "Banco Itaú SA"
			_cBancoR:= "ITAÚ"
		Case SEE->EE_CODIGO=="237"
			_cBanco := "Banco Bradesco"
			_cBancoR:= "Bradesco"
		Case SEE->EE_CODIGO=="001"
			_cBanco := "Banco do Brasil"
			_cBancoR:= "Banco do Brasil"
		EndCase
		
		//ccart := '109'   //see->ee_xcart // tirar o comentario
		If SEE->EE_CODIGO=="237"
			ccart := Alltrim(SEE->EE_XCART)
		elseIf SEE->EE_CODIGO=="001"
			ccart := SuperGetMv("GC_BBCARTE",.F.,"3049774")
		Else
			ccart := '109'
		EndIf
		
		// para controla o numero de parcelas o parametro MV_DUP tem que ser igual a numeros
		/* excluido em 050112
		DbSelectarea("SE1")
		reg    := recno()
		qtparc := 0
		ctitul := se1->e1_filial+se1->e1_prefixo+se1->e1_num+se1->e1_parcela
		if empty(se1->e1_parcela) .or. se1->e1_parcela $('00/0 ')
			nrparc := '01'
		else
			nrparc := se1->e1_parcela
		endif
		While xfilial("SE1")+se1->e1_prefixo+se1->e1_num+se1->e1_parcela == ctitul .and. !eof()
			qtparc++
			DbSkip()
		Enddo
		*/
		
		//DbGoto(reg)
		
		
		dbSelectArea("SEE")
		while !SEE->(RLock())
			sleep(1000)
		enddo
		
		RecLock("SEE",.F.)
		
		If !Empty(SE1->E1_NUMBCO)
			If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
				cNroDoc := PADL(AllTrim(SE1->E1_NUMBCO),11,"0")
			ElseIf AllTrim(SE1->E1_PORTADO)=="001" //BB
				//cNroDoc := PADL(AllTrim(SE1->E1_NUMBCO),TamSx3("E1_IDCNAB")[1],"0")//SE1->E1_IDCNAB//
				cNroDoc := Substr(SE1->E1_NUMBCO,Len(AllTrim(SE1->E1_NUMBCO))-9,10)
			Else
				cNroDoc	:= SUBSTR(SE1->E1_NUMBCO,1,8)    //SUBSTR(SE1->E1_NUMBCO,4,8)
			EndIf
			_cexiste := .t.
		else
			_cexiste := .f.
			
			If EMPTY(SEE->EE_FAXATU)
				cNroDoc := '00000001'
			else
				cNroDoc	:= STRZERO(VAL(SEE->EE_FAXATU)+1,8)    //Right(SEE->EE_FAXATU,8)
			endif
			
			If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
				cNroDoc := PADL(AllTrim(cNroDoc),11,"0")
			Endif
			
			If AllTrim(SE1->E1_PORTADO)=="001" //bb
				cNroDoc := PADL(AllTrim(cNroDoc),10,"0")//SE1->E1_IDCNAB//
			EndiF
			
			SEE->EE_FAXATU	:= cNroDoc
			
		Endif
		
		SEE->(MsUnlock())
		
		If AllTrim(SE1->E1_PORTADO)=="001"
			dbSelectArea("SE1")
			while !SE1->(RLock())
				sleep(1000)
			endDo
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO 	:= SuperGetMv("GC_BBCARTE",.F.,"3049774") + cNrodoc
			SE1->(MsUnlock())
		endif
		
		nVlrAbat   :=  	SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nAcresc    :=   SE1->E1_ACRESC   //nadia
		nJurDia    :=	ROUND(0.001 * (SE1->E1_SALDO - nVlrAbat), 2)
		
		//TIRAR O COMENTARIO
		cmsg1 := "Apos vencto cobrar R$ " + AllTrim(Transform((_cMulta * (SE1->E1_SALDO - nVlrAbat))/100,"@E 999,999,999.99")) + " de multa"
		
		If SE1->E1_VALJUR > 0
			cmsg2 := "Apos vencto cobrar R$" + AllTrim(Transform(0.001 * (SE1->E1_SALDO - nVlrAbat),"@E 999,999,999.99")) + " de juros por dia " //nadia
			//	cmsg2 := "Apos vencto cobrar R$ " + AllTrim(Transform(SE1->E1_VALJUR ,"@E 999,999,999.99")) + " de juros por dia"  // alterado em 271211
		Else
			cmsg2 := " "
		Endif
		
		//Valida se a Data de Vencimento foi alterada e calcula o juros.
		
		nValMulta := 0
		nValJuros := 0
		nFator	:= 0
		nSaldo	:= SE1->E1_SALDO + SE1->E1_ACRESC  //04/09/13 //VALOR A CONSIDERAR SOMENTE PARA TÍTULOS ATÉ EMISSÃO 31/08/2013
		
		_nDiasAtraso	:= 0
		_nJuros			:= 0
		_nMulta			:= 0
		
		//_nDiasAtraso	:= Date()-SE1->E1_VENCREA
		//_nDiasAtraso	:= Date()-SE1->E1_VENCORI
		//_nDiasAtraso	:= SE1->E1_VENCREA-SE1->E1_VENCORI
		_nDiasAtraso	:= DiasUteis(SE1->E1_VENCORI,SE1->E1_VENCREA)
		
		If _nDiasAtraso>0
			
			_nJuros	:= ( ( SE1->E1_SALDO * 0.001 ) *_nDiasAtraso )
			_nMulta	:= SE1->E1_SALDO*0.03
			
			If MV_PAR19<>2
				nValMulta	:= _nMulta
				nSaldo := SE1->E1_SALDO + nValMulta
			EndIf
			
			If MV_PAR20 <> 2 //'Nao'        //2
				nValJuros := _nJuros
				If nSaldo > SE1->E1_SALDO
					nSaldo := nSaldo + nValJuros
				Else
					nSaldo := SE1->E1_SALDO + nValJuros
				Endif
			EndIf
			
		EndIf
		
		/*
		If SE1->E1_VENCREA > SE1->E1_VENCORI
			
			If MV_PAR19 <> 2 //'Nao'     //2
				nValMulta := _cMulta * (SE1->E1_SALDO - nVlrAbat)/100  //nadia
				nSaldo := SE1->E1_SALDO + nValMulta
			EndIf
			
			If MV_PAR20 <> 2 //'Nao'        //2
				nFator := SE1->E1_VENCREA - SE1->E1_VENCORI
				nValJuros := nJurDia * nFator
				If nSaldo > SE1->E1_SALDO
					nSaldo := nSaldo + nValJuros
				Else
					nSaldo := SE1->E1_SALDO + nValJuros
				Endif
			EndIf
			
		EndIf
		*/
		// inserido em 050112
		If nVlrAbat > 0
			cmsg6 := "Valor total dos abatimentos e retencoes de: " + AllTrim(Transform(nVlrAbat,"@E 999,999,999.99"))
		Else
			cmsg6 := " "
		Endif
		
		cmsg3 := ""
		cmsg4 := IF(SEE->EE_XDIASP>0,"PROTESTAR APÓS " +Str(SEE->EE_XDIASP,2)+" DIAS DO VENCIMENTO"," ")
		cmsg5 := "NÃO ACEITAMOS DEPÓSITOS EM CONTA CORRENTE PARA QUITAÇÃO DESTE TITULO"
		//cmsg4 := SE1->E1_XMSGBL1
		//cmsg5 := SE1->E1_XMSGBL2
		aBolText     := {cmsg1 ,;
			cmsg2 ,;
			cmsg3 ,;
			cmsg4 ,;
			cmsg5 ,;
			cmsg6 ,;
			"",;
			"",}
		//>> Sigaconsult - Elielson - 11/06/13
		//  				     Transform(nValMulta, "@E 999,999,999.99"),;
			//  				     Transform(nValJuros, "@E 999,999,999.99"),}
		//<<
		
		
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		
		
		DbSelectArea("SE1")
		If Empty(SA6->A6_DVCTA)
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   //SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 1, 4)                          ,; 	// [3]Agência
			SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	// [4]Conta Corrente 5 digitos
			SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente 1 digito
			ccart                                             		}	// [6]Codigo da Carteira
		Else
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   // SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 2, 4)                          ,;   // [3]Agência
			Alltrim(SA6->A6_NUMCON)                                ,;   // [4]Conta Corrente 5 digitos
			SA6->A6_DVCTA                                          ,;   // [5]Dígito da conta corrente 1 digito
			ccart                                             		}   // [6]Codigo da Carteira
		Endif
		
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
			SA1->A1_EST                                      ,;    		// [5]Estado
			SA1->A1_CEP                                      ,;      	// [6]CEP
			SA1->A1_CGC										          ,;  			// [7]CGC
			SA1->A1_PESSOA										}       				// [8]PESSOA
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
			AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
			SA1->A1_ESTC	                                     ,;   	// [5]Estado
			SA1->A1_CEPC                                        ,;   	// [6]CEP
			SA1->A1_CGC												 		 ,;		// [7]CGC
			SA1->A1_PESSOA												 }				// [8]PESSOA
		Endif
		
		//nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
		//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo.
		//Abaixo apenas uma sugestao
		//cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
		
		//Monta codigo de barras
		
		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aDadosEmp[1] := "GC DISTRIBUIDORA LTDA"
		EndIf
		
		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aCB_RN_NN    := Ret_cBarr2(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(nSaldo-nVlrAbat),E1_VENCREA)
		ElseIf AllTrim(SE1->E1_PORTADO)=="001" //BB
			aCB_RN_NN    := Ret_cBarr3(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(nSaldo-nVlrAbat),E1_VENCREA)
		Else
			aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(nSaldo-nVlrAbat),E1_VENCREA)
		EndIf
		
		//Preciso da agencia para ser o sacador/avalista do boleto
		_cNomeAgen := ""
		_cCNPJAgen := ""
		aDadosTit	:= {AllTrim(E1_NUM)                 		,;  // [1] Número do título            //tinha o numero da parcela, retirei pois so é usado na impressao
		E1_EMISSAO                          ,;  // [2] Data da emissão do título
		dDataBase                    		,;  // [3] Data da emissão do boleto
		E1_VENCREA                          ,;  // [4] Data do vencimento
		(nSaldo - nVlrAbat)                 ,;  // [5] Valor do título
		aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                          ,;  // [7] Prefixo da NF
		E1_TIPO	                           	,;  // [8] Tipo do Titulo
		_cNomeAgen                      	,;  // [9] Nome da Agencia
		_cCNPJAgen                      	,;  // [10] CNPJ/CPF da Agencia
		E1_VALJUR                           ,}  // [11] Valor Taxa de Permanencia Diaria
		//" parc.: " + STRZERO(QTPARC,2) + " de " +STRZERO(Val(nrparc),2)         }  // [12] Quantidade de parcelas
		
		// " parc.: " + STRZERO(VAL(nrparc),2) + " de " +STRZERO(QTPARC,2)
		
		If Marked("E1_OK")
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,SE1->E1_PARCELA)
			nX := nX + 1
		EndIf
		dbSkip()
		IncProc()
		nI := nI + 1
	EndDo
	oPrint:EndPage()     // Finaliza a página
	oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*/{Protheus.doc} Impress
//TODO Descrição auto-gerada.
@author DMoura
@since 01/02/2018
@version undefined
@param oPrint, object, descricao
@param aDadosEmp, array, descricao
@param aDadosTit, array, descricao
@param aDadosBanco, array, descricao
@param aDatSacado, array, descricao
@param aBolText, array, descricao
@param aCB_RN_NN, array, descricao
@param _cParcela, , descricao
@type function
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,_cParcela)
	LOCAL oFont8
	LOCAL oFont8n
	LOCAL oFont9n
	LOCAL oFont11c
	LOCAL oFont10
	LOCAL oFont14
	LOCAL oFont16n
	LOCAL oFont15
	LOCAL oFont14n
	LOCAL oFont24
	LOCAL nI := 0
	
	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n  := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9n  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)      //criado em 28/12/2011 - Renan - TOTVS
	oFont11a := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)   //Criano em 08/05/2011 - Natanael Simões - Grand Cru
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	
	oPrint:StartPage()   // Inicia uma nova página
	
	/******************/
	/* PRIMEIRA PARTE */
	/******************/
	
	nRow1 := 0
	
	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710)
	
	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont14 )	// [2]Nome do Banco
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
	Else
		oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
	EndIf
	
	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
	EndIf
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1060,SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	Else
		oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	EndIf
	
	//200//940
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow1+0200,1510,AllTrim(_cParcela)+" "+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela
	//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
	EndIf
	oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont10)				//Nome
	
	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
	
	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
	
	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
	oPrint:Say  (nRow1+0450,0100,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)
	
	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )
	
	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )
	
	oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  	,oFont8)
	
	
	/*****************/
	/* SEGUNDA PARTE */
	/*****************/
	
	nRow2 := 0
	
	//Pontilhado separador
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI
	
	oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
	oPrint:Line (nRow2+0710,710,nRow2+0630, 710)
	
	oPrint:Say  (nRow2+0644,100,aDadosBanco[2],oFont14 )		// [2]Nome do Banco
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
		oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10)
	Else
		oPrint:Say  (nRow2+0635,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
		oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)
	EndIf
	
	
	oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
	oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
	oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )
	
	oPrint:Line (nRow2+0910,500,nRow2+1050,500)
	oPrint:Line (nRow2+0980,750,nRow2+1050,750)
	oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
	oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
	oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)
	
	oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0725,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow2+0765,400 ,"APÓS O VENCIMENTO,SOMENTE NO "+_cBancoR,oFont10)
	
	oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810,100 ,"Beneficiário"                                        ,oFont8)
	Else
		oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
	EndIf
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont8n) //Nome + CNPJ
		oPrint:Say  (nRow2+0870,100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3]	,oFont8n) //Endereço
	Else
		oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	EndIf
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	Else
		oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf
	
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)
	
	oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
	
	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow2+0940,505 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow2+0940,505 ,AllTrim(_cParcela)+" "+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	
	oPrint:Say  (nRow2+0910,1005,"Espécie Doc."                                   ,oFont8)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0940,1050,"DM"										,oFont10) //Tipo do Titulo
	Else
		oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	EndIf
	
	oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)
	
	oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
	
	oPrint:Say  (nRow2+0910,1810,"Nosso Número"                                   ,oFont8)
	
	If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	Else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf
	
	nCol := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)
	
	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)
	
	oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)
	
	oPrint:Say  (nRow2+0980,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)
	
	oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)
	
	oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)
	
	oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1100,100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow2+1150,100 ,aBolText[2],oFont10)
	//oPrint:Say  (nRow2+1200,100 ,aBolText[3],oFont10)
	oPrint:Say  (nRow2+1200,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow2+1250,100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow2+1300,100 ,aBolText[5],oFont11a)
	
	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                          ,oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                              ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                   ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8)
	
	//>> SigaConsult - Elielson - 11/06/13
	//If MV_PAR19 <> 2
	//oPrint:Say  (nRow2+1220,1900,aBolText[7]									   ,oFont11c) //nValMulta
	//EndIf
	//aqui
	//If MV_PAR20 <> 2
	//oPrint:Say  (nRow2+1290,1900,aBolText[8]									   ,oFont11c) //nValJuros
	//EndIf
	//<<
	
	//aqui
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+1400,100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
	EndIf
	
	oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1430,1850 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1430,1850 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]+" - "+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5]                                    ,oFont10)
	Else
		oPrint:Say  (nRow2+1483,400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (nRow2+1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	EndIf
	
	oPrint:Say  (nRow2+1536,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)
	
	//oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
	
	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow2+1589,400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14
			oPrint:Say  (nRow2+1589,1850,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow2+1589,1850,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05
	
	If SEE->EE_CODIGO=="237"
		//--- Diogo Moura - 29/01/2018
		//oPrint:Line (nRow2+1710,100 ,nRow2+1710,2300 )
		//oPrint:Say  (nRow2+1715,1500,"Autenticação Mecânica",oFont8)
		oPrint:Line (nRow2+1650,100 ,nRow2+1650,2300 )
		oPrint:Say  (nRow2+1655,1500,"Autenticação Mecânica",oFont8)
		//--- Fim Diogo Moura - 29/01/2018
	Else
		oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )
		oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)
	EndIf
	
	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	
	
	
	/******************/
	/* TERCEIRA PARTE */
	/******************/
	
	nRow3 := 0
	
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI
	
	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)
	
	oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
	Else
		oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
	EndIf
	
	oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras
	//alert(aCB_RN_NN[2])
	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )
	
	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)
	
	oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2015,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow3+2055,400 ,"APÓS O VENCIMENTO, SOMENTE NO "+_cBancoR,oFont10)
	
	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
	EndIf
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2130,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont8n) //Nome + CNPJ
		oPrint:Say  (nRow3+2160,100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3]	,oFont8n) //Endereço
	Else
		oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ
	EndIf
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	Else
		oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf
	
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)
	
	
	oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)
	
	
	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow3+2230,505 ,aDadosTit[7]+aDadosTit[1]		,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2230,505 ,AllTrim(_cParcela)+" "+aDadosTit[1]		,oFont10) //Prefixo +Numero+Parcela
	//2230/605
	oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                   ,oFont8)
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2230,1050,"DM"										,oFont10) //Tipo do Titulo
	Else
		oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	EndIf
	
	oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"                                              ,oFont10)
	
	oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
	
	
	oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)
	
	If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	Else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf
	nCol 	 := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)
	
	
	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)
	
	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                   ,oFont10)
	
	oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)
	
	oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)
	
	oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	  ,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)
	
	oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2390,100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow3+2440,100 ,aBolText[2],oFont10)
	//oPrint:Say  (nRow3+2490,100 ,aBolText[3],oFont10)     //Retirado uma linha em branco da parte inferior do boleto (09-05-2013)
	oPrint:Say  (nRow3+2490,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow3+2540,100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow3+2590,100 ,aBolText[5],oFont11a)
	
	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8)
	
	//>> SigaConsult - Elielson - 11/06/13
	//If | <> 2
	//oPrint:Say  (nRow2+2510,1900,aBolText[7]									  ,oFont11c) //nValMulta
	//EndIf
	//aqui
	//If MV_PAR20 <> 2
	//oPrint:Say  (nRow2+2580,1900,aBolText[8]									   ,oFont11c) //nValJuros
	//EndIf
	//aqui
	//<<
	
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2690,100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
	EndIf
	oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700,1850,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2700,1850,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2740,400 ,aDatSacado[3]+" - "+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5]                                    ,oFont10)
	Else
		oPrint:Say  (nRow3+2740,400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (nRow3+2780,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	EndIf
	
	oPrint:Say  (nRow3+2780,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+3000,100 ,"Sacador/Avalista"                               ,oFont8)
	Else
		oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista"                               ,oFont8)
	EndIf
	
	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow3+2815,400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14
			
			oPrint:Say  (nRow3+2815,1850,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow3+2815,1850,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05
	
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+3035,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	Else
		oPrint:Say  (nRow3+2855,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	EndIf
	
	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
	oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
	oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
	
	If SEE->EE_CODIGO=="237"
		oPrint:Line (nRow3+3030,100,nRow3+3030,2300  )
	Else
		oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
	EndIf
	//oPrint:Line (nRow3+2600,100,nRow3+2850,2300  )
	//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
	
	//--- Diogo Moura - 29/01/2018 ---//
	//	If SEE->EE_CODIGO=="237"
	//		MSBAR("INT25",13.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
	//		MSBAR("INT25",24.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
	If SEE->EE_CODIGO=="237" //BRADESCO
		if aReturn[5] == 2 //SPOOL
			MSBAR("INT25",7.1,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.8,Nil,Nil,"A",.F.)
			MSBAR("INT25",12.9,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.8,Nil,Nil,"A",.F.)
		else //DISCO
			MSBAR("INT25",14.6,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
			MSBAR("INT25",26.2,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
		endif
		//--- Fim Diogo Moura - 29/01/2018 ---//
	elseIf SEE->EE_CODIGO=="001" //BANCO DO BRASIL
		if aReturn[5] == 2 //SPOOL
			MSBAR("INT25",7,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.9,Nil,Nil,"A",.F.)
			MSBAR("INT25",12.2,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.9,Nil,Nil,"A",.F.)
		else //DISCO
			MSBAR("INT25",14,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
			MSBAR("INT25",24.2,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
		endif
	Else
		MSBAR("INT25",13.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.9,Nil,Nil,"A",.F.)
	EndIf
	//MSBAR("INT25",25.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.018,1.3,Nil,Nil,"A",.F.)
	//MSBAR2("INT25",23,.9,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.022,1.3,Nil,Nil,"A",.F.)
	//alert(aCB_RN_NN[3])
	
	//
	
	//Alterado - 2013/06/05 - TOTVS
	DbSelectArea("SE1")
	RecLock("SE1",.f.)
	If SEE->EE_CODIGO=="237"
		SE1->E1_NUMBCO 	:= cNrodoc + SubStr(aCB_RN_NN[3],Len(aCB_RN_NN[3]),1)
	elseif SEE->EE_CODIGO=="001"
		SE1->E1_NUMBCO 	:= SuperGetMv("GC_BBCARTE",.F.,"3049774") + cNrodoc// + SubStr(aCB_RN_NN[3],Len(aCB_RN_NN[3]),1)
	Else
		SE1->E1_NUMBCO 	:= cNrodoc + Subs(aCB_RN_NN[3],13,1)   //Subs(aCB_RN_NN[3],1,11)+Subs(aCB_RN_NN[3],13,1)   // Nosso número (Ver fórmula para calculo)
	EndIf
	MsUnlock()
	
	//DbSelectArea("SEE")
	//RecLock("SEE",.f.)
	//SEE->EE_FAXATU	:= cNroDoc
	//MsUnlock()
	
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	if found()
		if _cexiste == .f.
			RecLock("SEE",.f.)
			SEE->EE_FAXATU	:= cNroDoc
			MsUnlock()
		endif
	endif
	
	
	DbSelectArea("SE1")
	
	oPrint:EndPage() // Finaliza a página
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
	LOCAL L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
	
	LOCAL cValorFinal := StrZero((nvalor*100),10)//strzero(int(nValor*100),10)//STRZERO(NoRound(1110.12*100,0), 10(
	LOCAL nDvnn			:= 0
	LOCAL nDvcb			:= 0
	LOCAL nDv			:= 0
	LOCAL cNN			:= ''
	LOCAL cRN			:= ''
	LOCAL cCB			:= ''
	LOCAL cS				:= ''
	LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)
	
	
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
		cS    :=  cAgencia + cConta + cCart + cNroDoc
		nDvnn := u_GCDIGBRA(cNroDoc)
		nDvnn := Val(AllTrim(nDvnn))
		cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))
	Else
		cS    :=  cAgencia + cConta + cCart + cNroDoc
		nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
		cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))
	EndIf
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + cFator +  cValorFinal + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)
	//alert(cCB)
	//alert(cs)
	
	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
	
	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	CCC = Codigo da Carteira de Cobranca
	//	 DD = Dois primeiros digitos no nosso numero
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
	nDv   := modulo10(cS)
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '
	
	// 	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cS :=Subs(cNN,6,6) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3)
	nDv:= modulo10(cS)
	cRN := Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' '
	
	// 	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS    := Subs(cAgencia,4,1) + Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
	nDv   := modulo10(cS)
	cRN   := cRN + Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))
	
	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '
	
	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	//cRN   := cRN + cFator + StrZero(Int(nValor * 100),14-Len(cFator))  // retirado pois da erro no valor no codigo de barras
	cRN   := cRN + cFator + StrZero((nvalor*100),10)
Return({cCB,cRN,cNN})


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)
	
	Local _sAlias	:= Alias()
	Local aCposSX1	:= {}
	Local nX 		:= 0
	Local lAltera	:= .F.
	Local nCondicao
	Local cKey		:= ""
	Local nJ			:= 0
	/*
	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
		"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
		"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
		"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
		"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
		"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
		"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }*/
	
	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
		"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
		"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
		"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
		"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
		"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
		"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
		"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }
	
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		If MsSeek(cPerg+Right(aPergs[nX][11], 2))
			If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
					Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			Endif
		Endif
		
		If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif
		
		If ! Found() .Or. lAltera
			/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
						FieldPos(AllTrim(aCposSX1[nJ])) > 0
					Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
				Endif
			Next nj
			MsUnlock()*/
			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
			
			If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			Else
				aHelpSpa := {}
			Endif
			
			If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			Else
				aHelpEng := {}
			Endif
			
			If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			Else
				aHelpPor := {}
			Endif
			
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		Endif
	Next
	
Return


*****************************************************************************
Static Function Ret_cBarr2(cBanco,cAgencia,cConta,cDacCC,cCart,cNroDoc,nValor,dVencto)
	
	LOCAL cValorFinal  := strzero((nValor*100),10) // alterado por Whilton em 08/06/07 retirado função "int"
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ""
	LOCAL RN           := ""
	LOCAL CB           := ""
	LOCAL snn          := ""
	LOCAL cFator       := strzero(dVencto - ctod("07/10/97"),4)
	//Banco + Moeda
	cBanco += alltrim("9")
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	//----------------------------
	snn  := cCart + cNroDoc
	dvnn := Mod11_Bas7(snn)
	
	//dvnn := modulo11(snn)  //Digito verificador no Nosso Numero   cCarteira + cNroDoc
	
	NN   := snn + AllTrim(dvnn)
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	//Banco + Moeda ( 9 = Real ) + DAC Cod Barra + Fator Vencimento + Valor + Campo Livre
	//  3       1                      1              4                10		25
	//----------------------------------
	//	 Definicao do Campo Livre
	//----------------------------------"
	//Agencia s/ DAC + Carteira + Nosso Num sem DAC + Conta s/ DAC + "0"
	
	cLivre := cAgencia + cCart + cNroDoc + cConta + '0'
	scb    := cBanco + cFator + cValorFinal + cLivre
	dvcb   := mod11CB(scb)	//digito verificador do codigo de barras
	CB     := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5)
	
	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	DDDDD.DDDDDZ	K			UUUUVVVVVVVVVV
	
	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//CCCCC = 5 primeiros digitos do campo livre
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	srn := cBanco + Substr(cLivre,1,5)
	dv  := Modulo10LD(srn)
	RN  := SubStr(srn, 1, 5) + "." + SubStr(srn,6,4) + AllTrim(Str(dv)) + " "
	
	// 	CAMPO 2:
	//DDDDD.DDDDD = 6 ao 15 do campo livre
	//	        Y = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	srn := SubStr(cLivre,6,10)	// posicao 6 a 15 do campo livre
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "
	
	// 	CAMPO 3:
	//DDDDDDDDDD = 16 ao 25 do campo livre
	//	       Z = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	srn := SubStr(cLivre,16)
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "
	
	// CAMPO 4:
	// K = Digito de controle do código de Barra
	RN  += AllTrim(Str(dvcb)) + " "
	
	// CAMPO 5:
	//       UUUU = Fator de Vencimento
	// VVVVVVVVVV = Valor do Documento
	RN  += cFator + cValorFinal
	
Return({CB,RN,NN})


Static Function Ret_cBarr3(cBanco,cAgencia,cConta,cDacCC,cCart,cNroDoc,nValor,dVencto)
	
	LOCAL cValorFinal  := strzero((nValor*100),10) // alterado por Whilton em 08/06/07 retirado função "int"
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ""
	LOCAL RN           := ""
	LOCAL CB           := ""
	LOCAL snn          := ""
	LOCAL cFator       := strzero(dVencto - ctod("07/10/97"),4)
	//Banco + Moeda
	cBanco += alltrim("9")
	
	//-----------------------------
	// Definicao do NOSSO NUMERO
	//----------------------------
	snn  := cCart + cNroDoc
	dvnn := Mod11_Bas7(snn)
	
	//dvnn := modulo11(snn)  //Digito verificador no Nosso Numero   cCarteira + cNroDoc
	NN   := snn + AllTrim(dvnn)
	
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	//Banco + Moeda ( 9 = Real ) + DAC Cod Barra + Fator Vencimento + Valor + Campo Livre
	//  3       1                      1              4                10		25
	//----------------------------------
	//	 Definicao do Campo Livre
	//----------------------------------"
	//Agencia s/ DAC + Carteira + Nosso Num sem DAC + Conta s/ DAC + "0"
	
	cLivre := cCart + cNroDoc + "17" //+ cAgencia + cConta +
	scb    := cBanco + cFator + cValorFinal + Replicate("0",6) + cLivre
	dvcb   := mod11CB(scb)	//digito verificador do codigo de barras
	CB     := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5)
	
	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	DDDDD.DDDDDZ	K			UUUUVVVVVVVVVV
	
	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//CCCCC = 5 primeiros digitos do campo livre
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	RN := ""
	srn := Substr(CB,1,4) + Substr(CB,20,5)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv + " "
	
	srn :=  Substr(CB,25,10)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv+ " "
	
	srn := Substr(CB,35,10)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv+ " "
	
	dv := cValToChar(dvcb)
	RN += dv + " " + cFator + cValorFinal
	
	/*
	srn := cBanco + Substr(cLivre,1,5)
	dv  := Modulo10LD(srn)
	RN  := SubStr(srn, 1, 5) + "." + SubStr(srn,6,4) + AllTrim(Str(dv)) + " "
	
	// 	CAMPO 2:
	//DDDDD.DDDDD = 6 ao 15 do campo livre
	//	        Y = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	srn := SubStr(cLivre,6,10)	// posicao 6 a 15 do campo livre
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "
	
	// 	CAMPO 3:
	//DDDDDDDDDD = 16 ao 25 do campo livre
	//	       Z = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior
	
	srn := SubStr(cLivre,16)
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "
	
	// CAMPO 4:
	// K = Digito de controle do código de Barra
	RN  += AllTrim(Str(dvcb)) + " "
	
	// CAMPO 5:
	//       UUUU = Fator de Vencimento
	// VVVVVVVVVV = Valor do Documento
	RN  += cFator + cValorFinal
	*/
Return({CB,RN,NN})


//Funcao criada em 20/03/2006 por Paulo Moreto
//Digito verificador estava sendo recusado pelo bradesco
//Esta funcao substituiu a funcao Modulo11.
Static Function Mod11_Bas7(cData)
	
	Local _cDigito
	Local _nPos      := 1
	Local _nTam      := Len(cData)
	Local _nTotal    := 0
	Local _nFator    := 8
	Local _nValAtu   := 0
	Local _nResto    := 0
	Local _nValResto := 0
	
	While _nTam > 0
		If _nFator >= 7
			_nFator := 2
		Else
			_nFator ++
		Endif
		_nValAtu := Val(Substr(cData,_nTam,1))
		_nTotal += _nValAtu * _nFator
		_nTam--
	EndDo
	
	_nResto := Mod(_nTotal,11)
	
	If _nResto <> 0
		_nValResto := (11-_nResto)
	Else
		_nValResto := _nResto
	Endif
	
	If _nValResto == 0
		_cDigito := Str(0)
	ElseIf _nValResto == 10
		_cDigito := "P"
	Else
		_cDigito := Str(_nValResto)
	Endif
	
Return(_cDigito)




***************************
Static Function Mod11CB(cData) // Modulo 11 com base 9
	
	LOCAL CBL, CBD, CBP := 0
	CBL := Len(cdata)
	CBD := 0
	CBP := 1
	
	While CBL > 0
		CBP := CBP + 1
		CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
		If CBP = 9
			CBP := 1
		End
		CBL := CBL - 1
	End
	_nCBResto := mod(CBD,11)  //Resto da Divisao
	CBD := 11 - _nCBResto
	If (CBD == 0 .Or. CBD == 1 .Or. CBD > 9)
		CBD := 1
	End
	
Return(CBD)

*******************************
Static Function Modulo10LD(cData)
	
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	MS := (INT(D/10) + 1) * 10 // Multiplo Superior
	D  := MS - D
	If D = 10
		D := 0
	End
	
Return(D)

Static Function DiasUteis(dDtIni, dDtFin)
	
	Local aArea    := GetArea()
	Local nDias    := 0
	Local dDtAtu   := sToD("")
	Default dDtIni := dDataBase
	Default dDtFin := dDataBase
	
	//Enquanto a data atual for menor ou igual a data final
	dDtAtu := dDtIni
	While dDtAtu < dDtFin
		//Se a data atual for uma data Válida
		//If dDtAtu == DataValida(dDtAtu)
		nDias++
		//EndIf
		
		dDtAtu := DaySum(dDtAtu, 1)
	EndDo
	
	RestArea(aArea)
Return nDias
