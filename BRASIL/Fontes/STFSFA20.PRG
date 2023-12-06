#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH"			//FR - 10/06/2021
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA20 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina Chamada processos SEPARACAO Steck                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//--------------------------------------------------------------------------//
//Alterações Realizadas:
//--------------------------------------------------------------------------//
//FR - 10/06/2021 - Ticket #20200710004035 - Prioridade Alocação
//--------------------------------------------------------------------------//
//FR - 17/06/2021 - Ticket #20210614010082  - Prioridade Alocação
//--------------------------------------------------------------------------//
//Chamada da funcao para SEPARACAO de produtos
Static __ArmSel:=''
User Function STFSFA20()
	Local cCodOpe 		:= CBRetOpe()
	Local cArmOper		:= "  "
	Local cMsg			:= ""
	Local cMsg2			:= ""
	Local cMsgAux		:= ""

	Local cOSOK
	Local bkey02
	Local bkey03
	Local bkey04
	Local bkey05
	Local bkey06
	Local bkey09
	Local aETQSEP       := {}
	Local aCB7Area
	Local cMsgObsExp	:= ""
	Local cMsgTpEntr    := ""
	Local _MsgSB1       := ''
	Local lVai			:= .T. //FR - 14/06/2021 -#20210614010082
	Private aTEmpFil    := Separa(getMV("ST_TEMPFIL",.F.,"11,01"),",")    // Valdemir Rabelo 07/01/2022 - Aruja CD

	If Empty(cCodOpe)
		CBAlert("Operador nao cadastrado!",".: ATENCAO :.",.T.,2000,1)
		Return .f.
	Endif
	CB1->( dbSetOrder(2) ) // Ticket: 20210420006321 - Valdemir Rabelo 26/04/2021
	if !CB1->( dbSeek(xFilial('CB1')+__cUserId) )
		CBAlert("Usuário: " + __cUserId + " não encontrado (CB1)",".: ATENCAO :.",.T.,3000,1)
		Return .f.
	endif 

	cArmOper := CB1->CB1_XLOCAL
	If Empty(cArmOper)
		VTClear()
		@ 1,0 VtSay "Informe o Armazem"
		@ 2,0 VtSay "Para a separacao"
		@ 3,0 VTGet cArmOper PICT "@!" Valid ! Empty(cArmOper)
		VtRead
		If VtLastKey() == 27
			Return
		EndIf
		VTClear()
	EndIf
	__ArmSel := cArmOper
	cOSOK := BuscaOrdemSep(cCodOpe,cArmOper)		//FR - #20210614010082 - aqui pega a OS que o separador vai separar
	
	If Empty(cOSOK)
		CBAlert("Nao existem Ordens de Separacao para o operador " + cCodOpe + "!!!",".: ATENCAO :.",.T.,3000,1)
		Return .f.
	Endif

	CB7->(DbSetOrder(1))
	CB7->(DbSeek(xFilial("CB7")+cOSOK))
	cOSOKANT := cOSOK		//FR - guarda o número da OS para busca

	lVai := .T.
	//FR - verifica se a OS que o sistema trouxe para separar, já tem operador registrado nela (se já foi iniciada)
	lVai := fVerSeTem(CB7->CB7_FILIAL, CB7->CB7_ORDSEP, cCodOpe)		

	//FR - se o retorno acima for FALSO, é porque já tem alguém separanddo, então tenta buscar uma nova OS para este operador
	//Faz looping de busca e verificação até encontrar uma OS livre
	If !lVai
		nTenta := 0
		While !lVai
			If nTenta > 5		//faz 5 tentativas e se não encontrar OS livre, sai fora
				Return .F.				
			Endif
			cOSOK := BuscaOrdemSep(cCodOpe,cArmOper,lVai,cOSOKANT)		//FR - #20210614010082 - aqui pega a OS que o separador vai separar
			If !Empty(cOSOK)
				cOSOKANT := cOSOK
				CB7->(DbSetOrder(1))
				CB7->(DbSeek(xFilial("CB7")+cOSOK))
				lVai     := fVerSeTem(CB7->CB7_FILIAL, CB7->CB7_ORDSEP, cCodOpe)
				nTenta++
			Endif			
		Enddo
	Endif
		
	
	If ! Empty(CB7->CB7_PEDIDO)

		cMsgObsExp	:=  SC5->(GetAdvFVal("SC5","C5_XOBSEXP",xFilial("SC5")+CB7->CB7_PEDIDO,1,""))
		cMsgTpEntr  :=  iif(Posicione("SC5",1,xFilial("SC5")+CB7->CB7_PEDIDO,"C5_XTIPO")=="1", "RETIRA PRIORIZAR","")   // Valdemir Rabelo Ticket: 20210728013968 - 01/10/2021

		if !Empty(cMsgTpEntr)
		   cMsgObsExp	:= alltrim(cMsgObsExp)+" "+cMsgTpEntr+""
		endif 

		cMsg	+= "Separe o pedido:      " + CB7->CB7_PEDIDO+"        "
		cMsg	+= "Linhas: "+CVALTOCHAR(STQTDCB8(CB7->CB7_FILIAL,CB7->CB7_ORDSEP,"L"))+"        "
		cMsg	+= "Pecas: "+CVALTOCHAR(STQTDCB8(CB7->CB7_FILIAL,CB7->CB7_ORDSEP,"P"))+"                            "
		cMsg    += "Obs.Exp.: " + Alltrim(cMsgObsExp) +"                         "    // Valdemir Rabelo 01/04/2021
		cMsg2	+= "STFSFA20 - Sep. Pedido:"+CB7->CB7_PEDIDO

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+CB7->(CB7_CLIENT+CB7_LOJA)))

		If U_STFAT340("3","C",.F.)
			If !Empty(cMsgObsExp)

				cMsgAux	:= CRLF+"Obs. Expedicao:"
				cMsgAux	:= CRLF+SubStr(cMsgObsExp,01,20)
				cMsg	+= cMsgAux

				cMsgAux	:= CRLF+SubStr(cMsgObsExp,21,20)
				cMsg	+= IiF(Empty(cMsgAux),"",cMsgAux)

				cMsgAux	:= CRLF+SubStr(cMsgObsExp,41,20)
				cMsg	+= IiF(Empty(cMsgAux),"",cMsgAux)

				If Empty(CB7->CB7_XMSG)

					CB1->(RecLock("CB1",.F.))
					CB1->CB1_XMSG	:= cMsgObsExp
					CB1->(MsUnLock())

					CB7->(RecLock("CB7",.F.))
					CB7->CB7_XMSG	:= "S"
					CB7->(MsUnLock())

				EndIf

			EndIf
		EndIf

		// Valdemir Rabelo 05/04/2021
		if (cEmpAnt==aTEmpFil[1]) .and. (cFilAnt==aTEmpFil[2])     // Valdemir Rabelo 08/01/2022
			_MsgSB1 := u_VERIFMSG('M') //StaticCall (XACDV166X, VERIFMSG, 'M')
			aETQSEP := {;
					{'PEDIDO', CB7->CB7_PEDIDO},;
					{'OS', CB7->CB7_ORDSEP},;
					{'SEPARADOR',ALLTRIM(CB1->CB1_NOME)},;
					{'LINHAS', CVALTOCHAR(STQTDCB8(CB7->CB7_FILIAL,CB7->CB7_ORDSEP,"L"))},;
					{'PECAS', CVALTOCHAR(STQTDCB8(CB7->CB7_FILIAL,CB7->CB7_ORDSEP,"P"))},;
					{'DATA', dtoc(dDatabase)},;                    //CB7->CB7_DTINIS
					{'HORA', Left(Time(),5)},;                     // CB7->CB7_HRINIS
					{'OBS', ALLTRIM(_MsgSB1) };
			}
		Endif

		If !Empty(cMsgAux)
			cMsg += cMsgAux
		EndIf

	Else
		cMsg	+="Separe a OP: " + CB7->CB7_OP
		cMsg2	+="STFSFA20 - Sep. OP:"+CB7->CB7_OP  +"     OS " +CB7->CB7_ORDSEP
	EndIf
	CBAlert(cMsg,".: ATENCAO :.",.T.)
	VTAtuSem("SIGAACD",cMsg2)

	If !Empty(CB7->CB7_XOSFIL)
		CBAlert("O.Sep Filha "+CB7->CB7_XOSFIL+"!",".: ATENCAO :.",.T.)
		aCB7Area := CB7->(GetArea())
		If CB7->(DbSeek(xFilial("CB7")+CB7->CB7_XOSFIL))
			CB7->(RecLock("CB7",.F.))
			CB7->CB7_XAUTSE := "1"
			CB7->(MsUnlock())
		Endif
		RestArea(aCB7Area)
	Endif

	If Empty(CB7->CB7_XDISE)
		CB7->(RecLock("CB7"))
		CB7->CB7_XDISE := Date()
		CB7->CB7_XHISE := Time()
		CB7->(MsUnLock())
	EndIf

	
	// Valdemir Rabelo - Ticket: 20201113010536	
	if (cEmpAnt==aTEmpFil[1]) .and. (cFilAnt==aTEmpFil[2])     // Valdemir Rabelo 08/01/2022
		if VTYesNo("Confirma a Impressão da Etiqueta Pedido","Atencao")
			ImpEtqSep( aETQSEP )				
		Endif 
	Endif

	bkey02 := VTSetKey(02,{|| Etiqueta()},"Etiqueta")
	bkey03 := VTSetKey(03,{|| CONSPROD()},"Consulta Produto")
	bkey04 := VTSetKey(04,{|| Informa() },"Informacoes")
	bkey09 := VTSetKey(09,{|| Informa() },"Informacoes")
	bkey05 := VTSetKey(05,{|| Estorna() },"Estorna")
	bkey06 := VTSetKey(06,{|| PulaItem()},"Pula")

	VTClearBuffer()    
	VTKeyBoard(cOSOK)  
	
	u_XACDV166X(1)

	VTSetKey(02,bkey02)
	VTSetKey(03,bkey03)
	VTSetKey(04,bkey04)
	VTSetKey(05,bkey05)
	VTSetKey(06,bkey06)
	VTSetKey(09,bkey09)

Return .t.


User Function STRetArm()
Return __ArmSel


//--------------------------------------------------------------------
// Funcao que retorna a Ordem de Separacao atual conforme o usuario
Static Function BuscaOrdemSep(cCodOpe,cArmOper,lVai,cOSOKANT)		//BuscaOrdemSep(cCodOpe,cArmOper,lVai,cOSOKANT)
Local cOSOK := ""
Local cQuery
Local cCodOpeGen := "" //operador genérico 

//---------------------------------------------------------------------------------------------------------------------------------------//
//Verificar primeiro as OS's em aberta para este usuário logado (pois pode ter iniciado uma separação e a OS estar parcialmente separada)
//Ver o que há pendente para este usuário
//---------------------------------------------------------------------------------------------------------------------------------------//
//Status:
//CB7_STATUS:
//0=Inicio;1=Separando;2=Sep.Final;3=Embalando;4=Emb.Final;5=Gera Nota;6=Imp.nota;7=Imp.Vol;8=Embarcado;9=Embarque Finalizado
//---------------------------------------------------------------------------------------------------------------------------------------//

//--------------------------------------//
//Status da separação:
//CB7_XSEP: 
//1=Concluido;2=Aberto
//--------------------------------------//


//FR - 10/06/2021 - #20200710004035 - adicionar um operador genérico para a consulta abaixo
cCodOpeGen := U_fTrazCB1Gen()	

//1A. QUERY:
cQuery := " SELECT * FROM ("+CRLF
cQuery += " Select "		+CRLF
cQuery += " CB7_STATUS, CB7_CODOPE, CB7_XOPEXP, CB7_XOPEXG, "+CRLF		//FR
cQuery += " CB8_ORDSEP,CB8_LOCAL,CB8_QTDORI,CB8_SALDOS,CB7_ORDSEP,CB7_XPRIOR, "+CRLF
cQuery += " CB7_XOPE2, "  +CRLF

//FR - OPERADOR 2, se estiver preenchido, o filtro abaixo assume qtde 0, se estiver vazio, assume qtde = 1 para ordenação geral dos resultados
cQuery += " (CASE WHEN CB7_XOPE2 <>' ' THEN 0 ELSE 1 END) QTDOPE2, "+CRLF
cQuery += " CB7_FILIAL ,CB8_FILIAL "+CRLF
	
cQuery += "   From "+RetSqlName("CB8")+" CB8 "+CRLF
cQuery += "   INNER JOIN " + RetSqlName("CB7") + " CB7  "+CRLF
cQuery += "   ON CB8_FILIAL = CB7_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ <> '*' " + CRLF

cQuery += "  Where " + CRLF
cQuery += "  CB8_FILIAL = '" + xFilial("CB8") + "' "	+CRLF
cQuery += "  AND CB8_SALDOS > 0  "						+CRLF
cQuery += "  AND CB8_LOCAL = '" + cArmOper + "' "		+CRLF

If lVai <> Nil 
	If !lVai
		cQuery += " AND CB8_ORDSEP <> '" + cOSOKANT + "' " + CRLF //se estiver no looping de leitura de OS, para buscar a próxima disponível
	Endif
Endif

cQuery += "  AND "+CRLF
cQuery += "        ( "									+CRLF
cQuery += "				CB7_CODOPE = '" + cCodOpe + "' "+CRLF
cQuery += "			OR "								+CRLF
cQuery += "				CB7_XOPEXP = '" + cCodOpe + "' "+CRLF
cQuery += "			OR  "								+CRLF
cQuery += "				CB7_XOPE2  = '" + cCodOpe+ "' "	+CRLF
cQuery += "			OR  "								+CRLF
cQuery += "				CB7_XOPE3  = '" + cCodOpe+ "' "	+CRLF
cQuery += "			OR  "								+CRLF
cQuery += "				CB7_XOPE4  = '" + cCodOpe+ "' "	+CRLF
cQuery += "			OR  "								+CRLF
cQuery += "				CB7_XOPE5  = '" + cCodOpe+ "' "	+CRLF
cQuery += "			) "									+CRLF
cQuery += "        AND CB7_XAUTSE = '1' "				+CRLF			//FR - OS Autorizada: 1-Sim; 2-Não

//status iniciado para ver se tem algo pendente deste usuário:
cQuery += "        AND CB7_STATUS IN ('1')" 
cQuery += "        AND CB8.D_E_L_E_T_ = ' ' "+CRLF

cQuery += " )" //FECHA PARENTESES DA QUERY DA CB7/CB8	
	
cQuery += "  Order by QTDOPE2,CB7_XPRIOR"

MemoWrite("C:\TEMP\SELOS_USER.sql" , cQuery)

cQuery := ChangeQuery(cQuery)
	
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
TMP->(DbGoTop())
If !TMP->(Bof()) .AND. !TMP->(Eof())
	cOSOK := TMP->CB8_ORDSEP

Else

//se não tem OS iniciada, faz query para pegar a próxima OS livre	
//2A.QUERY
	cQuery := " SELECT * FROM ("
	cQuery += " Select "
	cQuery += " CB7_XOPEXP, CB7_XOPEXG, CB7_STATUS,"		//FR
	cQuery += " CB8_ORDSEP,CB8_LOCAL,CB8_QTDORI,CB8_SALDOS,CB7_ORDSEP,CB7_XPRIOR, "
	cQuery += " CB7_XOPE2, "  
	//FR - OPERADOR 2, se estiver preenchido, o filtro abaixo assume qtde 0, se estiver vazio, assume qtde = 1 para ordenação geral dos resultados
	cQuery += " (CASE WHEN CB7_XOPE2<>' ' THEN 0 ELSE 1 END) QTDOPE2, "
	cQuery += " CB7_FILIAL ,CB8_FILIAL "
	
	cQuery += "   From "+RetSqlName("CB8")+" CB8 "
	cQuery += "   INNER JOIN " + RetSqlName("CB7") + " CB7  "+CRLF
	cQuery += "   ON CB8_FILIAL = CB7_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ <> '*' " + CRLF

	cQuery += "  Where " 
	cQuery += "  CB8_FILIAL = '" + xFilial("CB8") + "' "
	cQuery += "  AND CB8_SALDOS > 0  "
	cQuery += "  AND CB8_LOCAL = '" + cArmOper + "' "

	If lVai <> Nil 
		If !lVai
			cQuery += " AND CB8_ORDSEP <> '" + cOSOKANT + "' " + CRLF //se estiver no looping de leitura de OS, para buscar a próxima disponível
		Endif
	Endif

	cQuery += "  AND "
	//cQuery += "        (CB7_CODOPE = '" + cCodOpe + "' OR CB7_XOPEXP = '" + cCodOpe + "' OR CB7_XOPE2='"+cCodOpe+"' OR CB7_XOPE3='"+cCodOpe+"' OR CB7_XOPE4='"+cCodOpe+"' OR CB7_XOPE5='"+cCodOpe+"' ) AND"
	//FR - 10/06/2021 - #20200710004035
	If !Empty(cCodOpeGen)
		cQuery += "        ( "
		cQuery += "          CB7_CODOPE = '" + cCodOpe + "' "
		cQuery += "          OR "
		cQuery += "          CB7_XOPEXP = '" + cCodOpe + "' "
		cQuery += "          OR "
		cQuery += "          CB7_XOPEXG = '" + cCodOpeGen + "' "
		cQuery += "          OR "
		cQuery += "          CB7_XOPE2='"+cCodOpe+"' "
		cQuery += "          OR  " 
		cQuery += "          CB7_XOPE3='"+cCodOpe+"' "
		cQuery += "          OR "
		cQuery += "          CB7_XOPE4='"+cCodOpe+"' "
		cQuery += "          OR "
		cQuery += "          CB7_XOPE5='"+cCodOpe+"' "
		cQuery += "         )  "
	Else
		//caso não tenha operador genérico nesta filial, faz o filtro anterior:
		cQuery += "        (CB7_CODOPE = '" + cCodOpe + "' OR CB7_XOPEXP = '" + cCodOpe + "' OR CB7_XOPE2='"+cCodOpe+"' OR CB7_XOPE3='"+cCodOpe+"' OR CB7_XOPE4='"+cCodOpe+"' OR CB7_XOPE5='"+cCodOpe+"' ) "
	Endif
	cQuery += "        AND CB7_XAUTSE = '1' "			//FR - OS Autorizada: 1-Sim; 2-Não	
	cQuery += "        AND CB8.D_E_L_E_T_ = ' ' "
	
	cQuery += " )" //FECHA PARENTESES DA QUERY DA CB7/CB8	
	
	cQuery += "  Order by QTDOPE2,CB7_XPRIOR"
	MemoWrite("C:\TEMP\SELOS.sql" , cQuery)
	cQuery := ChangeQuery(cQuery)
		
	//--------------------------------------------------------------------------------------------------------------------------------------//
	//Regra para fila da alocação:
	//Quando alocação manual: Dois ou mais separadores podem separar a mesma OS	quando a alocação tiver sido feita 
	//pela rotina "Alocação manual"
	//
	//Quando for alocação automática, só pode ser 1 OS para cada separador
	//Filtro para OS quando houver separador "Generico", para evitar que dois separadores estejam separando a mesma OS
	//Para isso, foi alinhado com Jefferson Puglia a seguinte regra para alocação automática:	
	//1-Quando a OS estiver com o status "NÃO INICIADO" 
	//2-Quando houver gravado o campo do "generico" no campo CB7_XOPEXG
	//Estas duas condições acima precisam estar atendidas para que o sistema jogue a próxima OS (totalmente livre) para o operador separar
	//--------------------------------------------------------------------------------------------------------------------------------------//
	//cQuery += " AND  CB7_STATUS = (CASE WHEN CB7_XOPEXG <> ''  THEN  '0' ELSE CB7_STATUS END) "  //Filtra por status qdo houver separador genérico gravado
	//nova regra
	
	//FR - 17/06/2021
	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
	//FR

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	TMP->(DbGoTop())
	If !TMP->(Bof()) .AND. !TMP->(Eof())
		cOSOK := TMP->CB8_ORDSEP
	Endif
	TMP->(dbCloseArea())
Endif

Return cOSOK


Static Function Etiqueta()
	Local aArea		:= CB8->(GetArea())              //RENATO/LEO 180413 QUANDO MANDAVA IMPRIMIR PELO CTRL+B E VOLTAVA APRESENTAVA ENDERECO INVALIDO
	Local aTela 	:= VTSave()
	Local cEtiProd := Space(48)
	Local cLoteX	:= ""

	CB1->( dbSetOrder(2) )                        // Ticket: 20210420006321 - Valdemir Rabelo 26/04/2021
	While .t.
	    CB1->( dbSeek(xFilial('CB1')+__cUserId) )	// Ticket: 20210420006321 - Valdemir Rabelo 26/04/2021
		cEtiProd := Space(48)
		cLocImp	:= CB1->CB1_XLOCIM
 
		aEtiqueta:= {}
		VtClear()
		@ 0,0 VtSay "Impressao Etiqueta"
		@ 2,0 VTSay "Leia a etiqueta"
		@ 3,0 VTGet cEtiProd pict "@!" Valid VldProduto(cEtiProd,aEtiqueta)
		@ 5,0 VtSay "Local de Impresao"
		@ 6,0 VtGet cLocImp pict "999999" F3 'CB5' Valid ! Empty(cLocImp)
		VTRead

		If VtLastkey() == 27
			Exit
		EndIf

		If ! VTYesNo("Confirma a Impressão de Etiqueta","Atencao")
			Loop
		EndIf
		VTMSG("Imprimindo..")
		If !CB5SetImp(cLocImp)
			CBAlert("Local de impressão "+cLocImp+" não existe!!!","Atenção")
			Return
		EndIf
		cLoteX := U_RetLoteX()

		If ExistBlock("IMG01")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial('SB1')+aEtiqueta[1]))
			ExecBlock("IMG01",,,{aEtiqueta[2],,,1,,,,,,,,cLoteX,Space(6),,,,,Space(20)})
		EndIf
		MSCBCLOSEPRINTER()
	End

	VtRestore(,,,,aTela)
	RestArea(aArea)               //RENATO/LEO 180413 QUANDO MANDAVA IMPRIMIR PELO CTRL+B E VOLTAVA APRESENTAVA ENDERECO INVALIDO
Return

Static Function VldProduto(cEtiqueta,aEtiqueta)
	Local _cEtiqueta	:= AllTrim(cEtiqueta)+"|"
	Local aEti 			:= CBRetEtiEan(_cEtiqueta)
	Local cProduto		:= Space(15)
	Local cLote       := Space(10)
	Local cSLote      := Space(6)

	If len(aEti) == 0
		VtAlert("Etiqueta invalida","Atencao [ENTER]")
		VtKeyBoard(chr(20))
		Return .f.
	EndIf
	If Empty(aEti[1])
		VtAlert("Produto não encontrado","Atencao [ENTER]")
		VtKeyBoard(chr(20))
		Return .f.
	EndIf

	cProduto := aEti[1]
	cLote 	:= aEti[3]

	If ! CBRastro(cProduto,@cLote,@cSLote)
		Return .f.
	EndIf
	aEti[3] 	:= cLote
	aEtiqueta := aClone(aEti)

Return .t.

Static Function STQTDCB8(_cFilial,_cOrdSep,_cTipo)

	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYTEMP2"

	cQuery2	 := " SELECT COUNT(*) LINHAS, SUM(CB8_QTDORI) PECAS "
	cQuery2  += " FROM " +RetSqlName("CB8")+ " CB8 "
	cQuery2  += " WHERE CB8.D_E_L_E_T_=' ' AND CB8_FILIAL='"+_cFilial+"' AND CB8_ORDSEP='"+_cOrdSep+"' "

	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())

	If (cAlias2)->(!Eof())
		Do Case
			Case _cTipo=="L"
			_nQuantidade	:= (cAlias2)->LINHAS
			Case _cTipo=="P"
			_nQuantidade	:= (cAlias2)->PECAS
		EndCase
	EndIf

Return(_nQuantidade)

/*====================================================================================\
|Programa  | CONSPROD        | Autor | Renato Nogueira            | Data | 15/10/2018 |
|=====================================================================================|
|Descrição | Consultar produto								                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function CONSPROD()

	Local _aBkpTela := VTSave()

	ACDV110()

	VTRestore(,,,,_aBkpTela)

Return()



/*/{Protheus.doc} ImpEtqSep
description
Rotina de Impressão Separação Canaleta
@type function
@version  
@author Valdemir Jose
@since 05/04/2021
@param paETQSEP, param_type, param_description
@return return_type, return_description
/*/
Static Function ImpEtqSep( paETQSEP )
	Local cLocImp := ""
	Local ctamG   := "045,040"
	Local ctamG1  := "075,065"
	Local ctamM   := "024,020"
	//Local ctamP   := "021,018"
	//Local ctamx   := "018,015"
	Local _nLinha := 3
	Local cCateg  := ""
	Local nValor  := 0
	Local _cOBS   := ALLTRIM(paETQSEP[8][2])

	CB1->( dbSetOrder(2) ) // Ticket: 20210420006321 - Valdemir Rabelo 26/04/2021
	if !CB1->( dbSeek(xFilial('CB1')+__cUserId) )
	   Return 
	endif 
	cLocImp := CB1->CB1_XLOCIM

	if SC5->( dbSeek(xFilial("SC5")+paETQSEP[1][2]) )
	   nValor  := U_STRESFAB(SC5->C5_NUM,'2',LEFT(CB7->CB7_OP,6))
	   cCateg  := "Categoria: "+getCateg(nValor)
	endif 

	If !CB5SetImp(cLocImp)
		CBAlert("Local de impressão "+cLocImp+" não existe!!!","Atenção")
		Return
	EndIf

	VTMSG("Imprimindo..")

	MSCBINFOETI("CANALETA","")
	MSCBBEGIN(1,6)
	MSCBSAY(05,004,            Capital(paETQSEP[1][1])+": "+paETQSEP[1][2], "N","0", ctamG)  // Pedido
	MSCBSAY(50,004,            cCateg, "N","0", ctamM)  // Pedido
	MSCBSAY(05,007+_nLinha,    Capital(paETQSEP[2][1])+": "+paETQSEP[2][2],	"N","0", ctamG)  // OS
	MSCBSAY(05,013+_nLinha,    Capital(paETQSEP[3][1])+": "+paETQSEP[3][2], "N","0", ctamG)  // Separador
	MSCBSAY(05,018+_nLinha,    Capital(paETQSEP[4][1])+": "+paETQSEP[4][2] + " / " +Capital(paETQSEP[5][1])+": "+paETQSEP[5][2],	"N","0", ctamG)  // Linhas
	MSCBSAY(05,023+_nLinha,    "Data: "+paETQSEP[6][2]+" / Hora:"+paETQSEP[7][2],	"N","0", ctamG)  // Data / Hora
	MSCBSAY(05,028+_nLinha,    "Obs.: "+Left(_cOBS, 20),	"N","0", ctamG)  
	MSCBSAY(05,033+_nLinha,    "      "+Substr(_cOBS,21,20),"N","0", ctamG)  
	MSCBSAYBAR(05,038+_nLinha, AllTrim(paETQSEP[2][2]),"N",'MB07',10,.F.,.T.,.F., ,3,4,.F.,.F.,"1",.F.)
    if getCanaleta(paETQSEP[2][2])   // Verifico se tem canaleta
		MSCBSAY(70,27,            "CANALETA", "B","0", ctamG1)  // Descrição Canaleta
	Endif 
	MSCBEND()

	MSCBCLOSEPRINTER()

Return


/*/{Protheus.doc} getCanaleta
description
Rotina que irá verificar o grupo do Produto
@type function
@version  
@author Valdemir Jose
@since 05/04/2021
@param pPedido, param_type, param_description
@param pOS, param_type, param_description
@return return_type, return_description
/*/
Static Function getCanaleta(pOS)
	Local lRET := .F.
	Local aCB8 := GetArea()

	dbSelectArea("CB8")	
	dbSetOrder(3)
	if dbSeek(xFilial("CB8")+pOS)
       While !Eof() .and. (CB8->CB8_ORDSEP == pOS)
	     SB1->( dbSeek(XFilial('SB1')+CB8->CB8_PROD))		 
	     IF !lRET
		    lRET := ALLTRIM(SB1->B1_GRUPO) $ GetMv("STFSFA2001",,"927#924")
		 endif 
         dbSkip()
	   EndDo
	endif 

	RestArea( aCB8)

Return lRET

/*/{Protheus.doc} getCateg
description
Rotina para encontrar a categoria de valor
@type function
@version  
@author Valdemir Jose
@since 05/04/2021
@param pnValor, param_type, param_description
@return return_type, return_description
/*/
Static Function getCateg(pnValor)
Local cRET := ""
Local nX   := 0
Local aTMP := {;
				{0, 5000, "G"},;
				{5000, 10000, "F"},;
				{10000, 20000, "E"},;
				{20000, 50000, "D"},;
				{50000, 100000, "C"},;
				{100000, 500000, "B"},;
				{500000, 999999999999,"A"};
			}

	For nX := 1 to Len(aTMP) 
		if (pnValor >= aTMP[nX][1]) .and. (pnValor <= aTMP[nX][2])
		   cRET := aTMP[nX][3]
		endif 
	Next

Return cRET

//==================================================================================//
//Função  : U_fTrazCB1Gen  
//Autoria : Flávia Rocha
//Data    : 11/06/2021
//Objetivo: Traz o código de operador genérico cadastrado na CB1 da filial corrente
//==================================================================================//
User Function fTrazCB1Gen()
Local cQuery := ""
Local cRetop := ""
/*
SELECT * FROM CB1010
WHERE UPPER(CB1_NOME) LIKE '%GENERICO%'
*/
cQuery := " SELECT CB1_FILIAL, CB1_CODOPE, CB1_NOME "
cQuery += " FROM " + RetSqlName("CB1") + " CB1 "
cQuery += " WHERE CB1.D_E_L_E_T_ <> '*' "
cQuery += " AND CB1.CB1_FILIAL = '" + Alltrim(xFilial("CB1")) + "' "
cQuery += " AND UPPER(CB1_NOME) LIKE '%GENERICO%' "		//precisa ter a palavra "Generico" no campo CB1_NOME

MemoWrite("C:\TEMP\selopergen.SQL", cQuery)
		
If Select("XTAB") > 0
	XTAB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "XTAB"

XTAB->(dbSelectArea("XTAB"))
XTAB->(dbGoTop())
		
If !XTAB->(EOF()) 

	XTAB->(dbGoTop())
	cRetop := XTAB->CB1_CODOPE 		

EndIf
XTAB->(dbCloseArea())

Return(cRetop)


//==================================================================================//
//Função  : fVerSeTem  
//Autoria : Flávia Rocha
//Data    : 20/07/2021
//Objetivo: Verifica se a OS que o sistema trouxe para separação, já foi iniciada por
//          outro operador
//==================================================================================//
Static Function fVerSeTem(cB7FILIAL, cB7ORDSEP, cCodOpe)
Local lVai := .T.

lVai := .T.
Return lVai //ticket 20210614010082
CB8->(OrdSetFocus(1))
CB8->(Dbseek(xFilial("CB8") + cB7ORDSEP ))
While !CB8->(Eof()) .and. CB8->CB8_FILIAL == cB7FILIAL .and. CB8->CB8_ORDSEP == cB7ORDSEP
	//#20210614010082 - verifica na CB8 se já tem item em separação feito por este usuário que acabou de logar
	If !Empty(CB8->CB8_CODOPE)
		If CB8->CB8_CODOPE != cCodOpe //#20210614010082 - se  for diferente não vai deixar separar
			lVai := .F.
		Endif
	Endif
	CB8->(Dbskip())
Enddo

If !lVai
	//FR - #20210614010082 - 14/06/2021
	CBAlert("Esta OS Ja Esta Em Separacao Por Outro Operador!!!",".: ATENCAO :.",.T.,3000,1)
	Return .F.	
Endif

Return(lVai)
