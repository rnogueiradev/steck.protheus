#INCLUDE "RWMAKE.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Funcao    ?STWF001    ?Autor ?Cristiano Pereira    ?Data ?27/08/08 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descricao ?Envio de mensagens com os boletos anexados                .  ³±?
±±?         ?                                                             ³±?
±±?         ?                                                             ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
User function STWF001(  )

	/***************************************************************************************************************************************
	<<Alteração>>
	Ação......: Trocado o parâmetro da Empresa 01 - Industria para 11 - Distribuidora
	Analista..: Marcelo Klopfer Leme - SIGAMAT
	Data......: 03/11/2021
	Chamado...: 20220916017684
	aParams := { "01", "01" }
	***************************************************************************************************************************************/
	aParams := { "11", "01" }

	prepare environment empresa aParams[1] filial aParams[2] Tables "SE1"

	U_STWF01A()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Funcao    ?STWF01A   ?Autor ?Cristiano Pereira      ?Data ?27/08/08 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descricao ?Envio de mensagens com os boletos anexados                   ³±?
±±?         ?                                                             ³±?
±±?         ?                                                             ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

User Function STWF01A()
	Local _nK,_nJ,_nlinha
	LOCAL cAttachFile := ""
	LOCAL _cCaminho := "\arquivos\BOLETOS_ITAU\"
	LOCAL _aAttach := {}
	Private oP, oHtml
	Private _aDados := {}
	Private _nlinha
	Private _cMens := ""
	Private _cQryE1 := ""
	PRIVATE cMSg := ""
	
	SETPRVT("_ANOME, _NPOS, _CPARAM, AUSERS")

	_aNome      := {}
	aUsers      := {}
	_nPos       := 0
	_cParam     := ""
	_nRec       := 1

	If _nRec > 0

		//Chamada da rotina para gerar o boleto
		u_STITAU03(@_aDados)

		For _nlinha:=1 to len(_aDados)
			_cMens := ""
			_cMens := "  E-MAIL DO CLIENTE: "+ _aDados[_nlinha,11]+"<br/><br/>    "
			_cMens += "  Prezado Cliente: "+ _aDados[_nlinha,4]+"<br/><br/>    "
			_cMens += "  Para sua comodidade encaminhamos a relação dos títulos a vencer e, em anexo o(s) respectivo(s) boleto(s) bancário(s).  "
			_cMens += "  Em caso de divergência ou dúvida, por favor, entre em contato através do telefone do Serviço de Atendimento Steck – SAS (011) 4090-2121"
			_cMens += "  ou através do email sas@steck.com.br, de segunda-feira a sexta-feira, de 08:00 as 17:00.<br/>"
			_cMens += "  No caso de seu departamento não ser o responsável, por favor nos informar ou encaminhar para o setor competente. "
			MONTAHTML(_nlinha)
			AADD( _aAttach,_aDados[_nlinha,1]+"_boleto.pdf")
			//XSendMail(_aDados[_nlinha,6], "", "BOLETOS - STECK DISTRIBUIDORA LTDA  ", cMSg, _cCaminho+_aDados[_nlinha,1]+"_boleto.pdf" )
			U_STMAILTES(_aDados[_nlinha,6],"","BOLETOS - STECK DISTRIBUIDORA LTDA  ", cMSg, _aAttach,_cCaminho)
			_aAttach := {}
		Next _nlinha

	Endif

return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ?STITAU03  ?Autor ?Cristiano Pereira    ?Data ?06/04/18 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO BANCO ITAU AUTOMATIZADA                ³±?
±±?		         												  	   ±±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
User Function STITAU03(_aDados)
LOCAL _nX := 0 
LOCAL nPos := 0
LOCAL cTipoAbat := GETMV("MVABATIM")
PRIVATE lExec    	:= .F.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''
Private _cBanco		:= ""
Private _cBancoR  	:= ""
Private _cEmailDes	:= GetMv("ST_DESTBOL",,"gleice.freitas@steck.com.br")
PRIVATE aVetor  := {}
PRIVATE aVetAux := {}

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOL341"
lEnd     := .F.
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

cQuery := "SELECT E1.E1_NUM,E1.E1_PREFIXO,E1.E1_PARCELA, E1.R_E_C_N_O_ AS SE1REC  FROM "+RetSqlName("SE1")+" E1 "
cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ = ' ' AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND A1.A1_XENV <> 'N' "
cQuery += "WHERE E1.D_E_L_E_T_ = ' ' "
cQuery += "AND E1.E1_SALDO > 0 AND E1.E1_EMISSAO = '"+DTOS(msdate()-10)+"' " 
cQuery += "AND E1.E1_TIPO = 'NF' "
cQuery += "AND E1.E1_NUMBCO <> ' ' "
cQuery += "AND E1.E1_PORTADO IN ('001','341','237','745') "
IF !EMPTY(cTipoAbat)
	cQuery += "AND E1.E1_TIPO NOT IN ('"+cTipoAbat+"') "
ENDIF
cQuery += "GROUP BY E1.E1_NUM,E1.E1_PREFIXO,E1.E1_PARCELA,E1.R_E_C_N_O_  "
cQuery += "ORDER BY E1.E1_NUM,E1.E1_PARCELA "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSE1', .F., .T.)
WHILE TSE1->(!EOF())

	nPos := 0
	nPos := aScan(aVetor,{|x| ALLTRIM(x[1])+ALLTRIM(x[2]) ==  ALLTRIM(TSE1->E1_NUM) + ALLTRIM(TSE1->E1_PREFIXO)})
	IF nPos = 0 
    AADD(aVetor,{TSE1->E1_NUM,TSE1->E1_PREFIXO,{}})
    AADD(aVetor[LEN(aVetor),3],{TSE1->SE1REC})
	ELSE
    AADD(aVetor[nPos,3],{TSE1->SE1REC})
  ENDIF

	TSE1->(DBSKIP())
ENDDO
TSE1->(DBCLOSEAREA())

FOR _nX := 1 TO LEN(aVetor)

	aVetAux := {}
	aVetAux := aVetor[_nX,3]		
	U_AMONTAR(aVetor[_nX,1])

	MV_PAR19	:= Alltrim(_cEmailDes) + ";" + Alltrim(SA1->A1_XAVSEML)
	//MV_PAR19 := "jonathan.silva@se.com"

	IF !EMPTY(SE1->E1_NUMBCO)
		AADD(_aDados, { SE1->E1_NUM ,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_NOMCLI ,SE1->E1_VENCTO,MV_PAR19,SE1->E1_EMISSAO,SE1->E1_VALOR,SE1->E1_SERIE,SE1->E1_FILIAL,Alltrim(SA1->A1_XAVSEML)})
	ENDIF

NEXT

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ? MontaRel?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
User Function AMontaR(cChave)
	LOCAL _nY := 0
	LOCAL oPrint
	LOCAL nX := 0

	//--- Marciane 11.10.05 - Criar variaveis para a agencia
	Local _cNomeAgen := ""
	Local _cCNPJAgen := ""
	LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     							,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

	Local _cMulta	   := GetMV("MV_XTXMUL")
	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatSacado
	LOCAL nI           := 1
	LOCAL aCB_RN_NN    := {}
	LOCAL nVlrAbat		:= 0
	Local xSetup       := .T.

	Local _cQuery	:= ""
	Local _cAlias	:= GetNextAlias()

	Private _cBanco	:= ""
	Private _cBancoR  := ""
	PRIVATE cStartPath 	  := ''
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := ''
	Default	_cCliente	:= ""
	Default	_cLoja	:= ""
	cNroDoc :=  " "

	//if isBlind()
	//_cDir 			:= "\BOLETOS_ITAU\"
	cStartPath 	  	:= "\arquivos\BOLETOS_ITAU\"
	_cNomePdf     	:= AllTrim(cChave)+ '_BOLETO'
	_cDirRel      	:=  'C:\ARQUIVOS_PROTHEUS\BOLETOS_ITAU\'+cEmpAnt
	If ! (ExistDir(_cDirRel))
		If MakeDir(_cDirRel) == 0
			MakeDir(_cDirRel)
		Endif
	Endif

	//oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\orcamento\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	//oPrint := FwMSPrinter():New(_cNomePdf , 6 , .f. , _cDir, .T., , , ,.f. , .F., ,.f. )
	oPrint := FwMSPrinter():New(_cNomePdf , IMP_PDF , .T. , cStartPath,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )//, .T., , , , , .F., ,!isBlind() )
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(5,5,5,0)


	cIndexName := ''
	cIndexKey  := ''
	cFilter    := ''

	Tamanho            := "M"
	titulo             := "Impressao de Boleto com Codigo de Barras"
	cDesc1             := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2             := ""
	cDesc3             := ""
	cString            := "SE1"
	wnrel              := "RFINR01"
	cPerg              := "FINR01"
	aReturn            := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey           := 00
	lEnd               := .F.

	FOR _nY := 1 TO LEN(aVetAux)

		SE1->(DBSETORDER(1))
		SE1->(DBGOTO(aVetAux[_nY,1]))

		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)

		//Posiciona na Arq de Parametros CNAB
		DbSelectArea("SEE")
		DbSetOrder(1)
		// ALTERADO EM 050112
		If !DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
			if IsInCallStack("U_GC05A07")
				//	RecLock("SF2",.F.)
				//	SF2->F2_XEXPBOL := "E"
				//	SF2->(MsUnlock())
			else
				MsgBox("Banco/Ag/conta nao cadastrado em parametros de bancos ref titulo: " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			endif
			DbSelectArea("SE1")
			DbSkip()
			Loop
		endif

		Do Case
			Case SEE->EE_CODIGO=="341"
			_cBanco := "Banco Itaú SA"
			_cBancoR:= "ITAÚ
			Case SEE->EE_CODIGO=="237"
			_cBanco := "Banco Bradesco"
			_cBancoR:= "Bradesco"
			Case SEE->EE_CODIGO=="001"
			_cBanco := "Banco do Brasil"
			_cBancoR:= "Banco do Brasil"
			Case SEE->EE_CODIGO=="745"
			  _cBanco := "Citibank S/A"
			  _cBancoR:= "Citibank S/A"
		EndCase

        If SEE->EE_CODIGO=="745"
           ccart := '100'
		Else 
		   ccart := '112'
		Endif


		cNroDoc	:=  Alltrim(SE1->E1_NUMBCO)

		// calcula valor dos abatimentos
		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		_nMoll:= 0
		_nMoll:=    (SE1->E1_SALDO - nVlrAbat)
		_nMoll:=  Round(( 5.9 * _nMoll/30/100),2)
		cmsg1 := "APOS O VENCIMENTO COBRAR MORA DE R$ " + AllTrim(Transform(_nMoll ,"@E 999,999,999.99")) + " AO DIA"


		cmsg2 := " "

		cmsg3 :="SUJEITO A PROTESTO SE NAO FOR PAGO NO VENCTO"
		cmsg4 := "REF. NF: "+SE1->E1_NUM+SE1->E1_PARCELA
		cmsg5 := "COBRANCA ESCRITURAL."

		aBolText     := {cmsg1 ,;
		cmsg2 ,;
		cmsg3 ,;
		cmsg4 ,;
		cmsg5 ,}



		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)


		DbSelectArea("SE1")

		If SE1->E1_PORTADO=="745"

          aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   //SA6->A6_NOME [2]Nome do Banco
			"001"                          ,; 	// [3]Agência
			"01",; 	// [4]Conta Corrente 5 digitos
			"03182018"  ,; 	// [5]Dígito da conta corrente 1 digito
			ccart                                          		   ,;	// [6]Codigo da Carteira
			Alltrim(SA6->A6_XCOSMO)										}   //[7]Conta Cosmo Banco Citi

		ElseIf Empty(Alltrim(SA6->A6_DVCTA))
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   //SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 1, 4)                          ,; 	// [3]Agência
			SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	// [4]Conta Corrente 5 digitos
			SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente 1 digito
			ccart                                          		   ,;	// [6]Codigo da Carteira
			Alltrim(SA6->A6_XCOSMO)										}   //[7]Conta Cosmo Banco Citi
		Else
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   // SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 2, 4)                          ,;   // [3]Agência
			Alltrim(SA6->A6_NUMCON)                                ,;   // [4]Conta Corrente 5 digitos
			SA6->A6_DVCTA                                          ,;   // [5]Dígito da conta corrente 1 digito
			ccart                                          		   ,;	// [6]Codigo da Carteira
			Alltrim(SA6->A6_XCOSMO)										}   //[7]Conta Cosmo Banco Citi
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

		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aDadosEmp[1] := "GC DISTRIBUIDORA LTDA"
		EndIf

		//Monta codigo de barras
		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aCB_RN_NN    := Ret_cBarr2(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		ElseIf AllTrim(SE1->E1_PORTADO)=="001" //BB
			aCB_RN_NN    := Ret_cBarr3(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		ElseIf AllTrim(SE1->E1_PORTADO)=="745"

            aCB_RN_NN    := Ret_cBa4rra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCTO,aDadosBanco[7])
		Else

			aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		EndIf

		//Preciso da agencia para ser o sacador/avalista do boleto
		_cNomeAgen := ""
		_cCNPJAgen := ""
		aDadosTit	:= {AllTrim(E1_NUM)                 		,;  // [1] Número do título            //tinha o numero da parcela, retirei pois so ?usado na impressao
		E1_EMISSAO                          ,;  // [2] Data da emissão do título
		dDataBase                    		,;  // [3] Data da emissão do boleto
		E1_VENCREA                           ,;  // [4] Data do vencimento
		(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do título
		aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                          ,;  // [7] Prefixo da NF
		E1_TIPO	                           	,;  // [8] Tipo do Titulo
		_cNomeAgen                      	,;  // [9] Nome da Agencia
		_cCNPJAgen                      	,;  // [10] CNPJ/CPF da Agencia
		E1_VALJUR                           ,}  // [11] Valor Taxa de Permanencia Diaria
		//         " parc.: " + STRZERO(QTPARC,2) + " de " +STRZERO(Val(nrparc),2)         }  // [12] Quantidade de parcelas
		//			" parc.: " + STRZERO(VAL(nrparc),2) + " de " +STRZERO(QTPARC,2)

		//	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,SE1->E1_PARCELA)
		nX := nX + 1
		//	EndIf
		IncProc()
		nI := nI + 1

	NEXT _nY


	FERASE(cStartPath + _cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath//"c:\"
	oPrint:Print()
	oPrint:EndPage()

Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ? Impress ?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,_cParcela)
	LOCAL oFont8
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
	/*
	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9n  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)      //criado em 28/12/2011 - Renan - TOTVS
	oFont11a := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)   //Criano em 08/05/2013 - Natanael Simões - Grand Cru
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
	*/

	oFont8   := TFont():New("Arial",,8+4,.T.,.F.)
	oFont9n  := TFont():New("Arial",,9+4,.T.,.T.)
	oFont11a := TFont():New("Arial",,11+4,.T.,.T.)
	oFont11c := TFont():New("Courier New",,11+4,.T.,.T.)
	oFont10  := TFont():New("Arial",,10+4,.T.,.T.)
	oFont14  := TFont():New("Arial",,14+4,.T.,.T.)
	oFont20  := TFont():New("Arial",,20+4,.T.,.T.)
	oFont21  := TFont():New("Arial",,21+4,.T.,.T.)
	oFont16n := TFont():New("Arial",,16+4,.T.,.F.)
	oFont15  := TFont():New("Arial",,15+4,.T.,.T.)
	oFont15n := TFont():New("Arial",,15+4,.T.,.F.)
	oFont14n := TFont():New("Arial",,14+4,.T.,.F.)
	oFont24  := TFont():New("Arial",,24+4,.T.,.T.)

	oPrint:StartPage()   // Inicia uma nova página

	/******************/
	/* PRIMEIRA PARTE */
	/******************/

	nRow1 := 0

	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

	oPrint:Say  (nRow1+0084+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )	// [2]Nome do Banco

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0075+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
	ElseIf SEE->EE_CODIGO=="745"
        oPrint:Say  (nRow1+0075+(oFont21:nHeight*2),513,aDadosBanco[1]+"-5",oFont21 )
	Else
		oPrint:Say  (nRow1+0075+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
	EndIf

	oPrint:Say  (nRow1+0084+(oFont10:nHeight*2),1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),100 ,"Cedente",oFont8)
	EndIf
	oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),1060,SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
    ElseIf  SEE->EE_CODIGO=="745"
           
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1060,"Agência/Código Cedente",oFont8)
		oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),1060,aDadosBanco[3]+"/"+aDadosBanco[4]+aDadosBanco[5],oFont10)
    Else
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1060,"Agência/Código Cedente",oFont8)
		oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	EndIf

	oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1510,"Nro.Documento",oFont8)
	//oPrint:Say  (nRow1+0200+(oFont9n:nHeight*2),1510,aDadosTit[7]+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela    28/12/2011 -> alterado oFont10 para oFont9n
	oPrint:Say  (nRow1+0200+(oFont9n:nHeight*2),1510,AllTrim(_cParcela)+" "+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela    28/12/2011 -> alterado oFont10 para oFont9n
	//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),100 ,"Sacado",oFont8)
	EndIf
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),100 ,aDatSacado[1],oFont10)				//Nome

	oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400+(oFont10:nHeight*2),0100,"Recebi(emos) o bloqueto/título",oFont10)
	oPrint:Say  (nRow1+0450+(oFont10:nHeight*2),0100,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350+(oFont8:nHeight*2),1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350+(oFont8:nHeight*2),1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450+(oFont8:nHeight*2),1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450+(oFont8:nHeight*2),1410,"Entregador",oFont8)

	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

	oPrint:Say  (nRow1+0165+(oFont8:nHeight*2),1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (nRow1+0205+(oFont8:nHeight*2),1910,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (nRow1+0245+(oFont8:nHeight*2),1910,"(  )Não existe não indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285+(oFont8:nHeight*2),1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325+(oFont8:nHeight*2),1910,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (nRow1+0365+(oFont8:nHeight*2),1910,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (nRow1+0405+(oFont8:nHeight*2),1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445+(oFont8:nHeight*2),1910,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (nRow1+0485+(oFont8:nHeight*2),1910,"(  )Outros(anotar no verso)"                  	,oFont8)


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

	oPrint:Say  (nRow2+0644+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )		// [2]Nome do Banco

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0644+(oFont10:nHeight*2),1800,"Recibo do Pagador",oFont10)
		oPrint:Say  (nRow2+0635+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )	// [1]Numero do Banco
	ElseIf SEE->EE_CODIGO=="745"
        oPrint:Say  (nRow2+0644+(oFont10:nHeight*2),1800,"Recibo do Sacado",oFont10)
		oPrint:Say  (nRow2+0635+(oFont21:nHeight*2),513,aDadosBanco[1]+"-5",oFont21 )
	Else
		oPrint:Say  (nRow2+0644+(oFont10:nHeight*2),1800,"Recibo do Sacado",oFont10)
		oPrint:Say  (nRow2+0635+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
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

	oPrint:Say  (nRow2+0710+(oFont8:nHeight*2),100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0725+(oFont10:nHeight*2),400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow2+0765+(oFont10:nHeight*2),400 ,"APÓS O VENCIMENTO, SOMENTE NO "+_cBancoR,oFont10)

	oPrint:Say  (nRow2+0710+(oFont8:nHeight*2),1810,"Vencimento"                                     ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),100 ,"Beneficiário"                                        ,oFont8)
		oPrint:Say  (nRow2+0840+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont10) //Nome + CNPJ
		oPrint:Say  (nRow2+0870+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3],oFont10) //Nome + CNPJ
	Else
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),100 ,"Cedente"                                        ,oFont8)
		oPrint:Say  (nRow2+0850+(oFont10:nHeight*2),100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	EndIf


	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	ElseIf SEE->EE_CODIGO=="745"
	   oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+aDadosBanco[5])
	Else
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf

	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),505 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela            28/12/2011 alterado de oFonte10 para oFonte8
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),505 ,+aDadosTit[1] +" "+ AllTrim(_cParcela),oFont10) //Prefixo +Numero+Parcela            28/12/2011 alterado de oFonte10 para oFonte8

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1005,"Espécie Doc."                                   ,oFont8)


	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1050,iif(SEE->EE_CODIGO=="745","00","DM"),oFont10) //Tipo do Titulo


	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1400,iif(SEE->EE_CODIGO=="745","N","A")                                             ,oFont10)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1810,"Nosso Número"                                   ,oFont8)

	//If SEE->EE_CODIGO=="237"
	//	cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	//Else
	//	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	//EndIf Solicitação Gleice - correção do nosso numero para 11 dígitos

	 If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	ElseIf SEE->EE_CODIGO=="745" 
		cString := Alltrim(aDadosTit[6])
	Else
	   	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf


	nCol := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow2+0940+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),100 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+1010+(oFont10:nHeight*2),555 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow2+1010+(oFont10:nHeight*2),805 ,"R$"                                             ,oFont10)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010+(oFont11c:nHeight*2),nCol,cString ,oFont11c)

	oPrint:Say  (nRow2+1050+(oFont8:nHeight*2),100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1100+(oFont10:nHeight*2),100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow2+1150+(oFont10:nHeight*2),100 ,aBolText[2],oFont10)
	oPrint:Say  (nRow2+1200+(oFont10:nHeight*2),100 ,aBolText[3],oFont10)
	//oPrint:Say  (nRow2+1200,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow2+1250+(oFont11a:nHeight*2),100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow2+1300+(oFont11a:nHeight*2),100 ,aBolText[5],oFont11a)

	oPrint:Say  (nRow2+1050+(oFont8:nHeight*2),1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120+(oFont8:nHeight*2),1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow2+1190+(oFont8:nHeight*2),1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260+(oFont8:nHeight*2),1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330+(oFont8:nHeight*2),1810,"(=)Valor Cobrado"                               ,oFont8)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+1400+(oFont8:nHeight*2),100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow2+1400+(oFont8:nHeight*2),100 ,"Sacado"                                         ,oFont8)
	EndIf
	oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),1850 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),1850 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow2+1483+(oFont10:nHeight*2),400 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow2+1536+(oFont10:nHeight*2),400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
   

     If SEE->EE_CODIGO<>"745"
	oPrint:Say  (nRow2+1536+(oFont10:nHeight*2),1850,SubStr(Rtrim(aDadosTit[6]),1,3)+"/"+SubStr(Rtrim(aDadosTit[6]),4,10)  ,oFont10)
	Else
	oPrint:Say  (nRow2+1536+(oFont10:nHeight*2),1850,Rtrim(aDadosTit[6])  ,oFont10)
	Endif

	

	oPrint:Say  (nRow2+1605+(oFont8:nHeight*2),100 ,"",oFont8)   //Sacador/Avalista"

	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14
			oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),1850,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),1850,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05

	oPrint:Say  (nRow2+1645+(oFont8:nHeight*2),1500,"Autenticação Mecânica",oFont8)

	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )


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

	oPrint:Say  (nRow3+1934+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+1925+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
	ElseIf SEE->EE_CODIGO=="745"
        oPrint:Say  (nRow3+1925+(oFont21:nHeight*2),513,aDadosBanco[1]+"-5",oFont21 )
	Else
		oPrint:Say  (nRow3+1925+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
	EndIf
	oPrint:Say  (nRow3+1934+(oFont15n:nHeight*2),755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000+(oFont8:nHeight*2),100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2015+(oFont10:nHeight*2),400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow3+2055+(oFont10:nHeight*2),400 ,"APÓS O VENCIMENTO, SOMENTE NO "+_cBancoR,oFont10)

	oPrint:Say  (nRow3+2000+(oFont8:nHeight*2),1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2130+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
		oPrint:Say  (nRow3+2160+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3]	,oFont10) //Nome + CNPJ
	Else
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),100 ,"Cedente",oFont8)
		oPrint:Say  (nRow3+2140+(oFont10:nHeight*2),100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	EndIf


	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	ElseIf SEE->EE_CODIGO=="745"
        oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+aDadosBanco[5])
	Else
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf

	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140+(oFont11c:nHeight*2),nCol,cString ,oFont11c)


	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say (nRow3+2230+(oFont10:nHeight*2),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),505 ,aDadosTit[7]+aDadosTit[1]	,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),505 ,  aDadosTit[1]+" "+ AllTrim(_cParcela)	,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1005,"Espécie Doc."                                   ,oFont8)

	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1050,iif(SEE->EE_CODIGO=="745","00","DM")										,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1400,iif(SEE->EE_CODIGO=="745","N","A")                                             ,oFont10)

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1810,"Nosso Número"                                   ,oFont8)

	If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	ElseIf SEE->EE_CODIGO=="745"
		cString := Alltrim(aDadosTit[6])
	Else 
	   	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf

	nCol 	 := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow3+2230+(oFont11c:nHeight*2),nCol,cString,oFont11c)


	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),100 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300+(oFont10:nHeight*2),555 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow3+2300+(oFont10:nHeight*2),805 ,"R$"                                             ,oFont10)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2340+(oFont8:nHeight*2),100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2390+(oFont10:nHeight*2),100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow3+2440+(oFont10:nHeight*2),100 ,aBolText[2],oFont10)
	oPrint:Say  (nRow3+2490+(oFont10:nHeight*2),100 ,aBolText[3],oFont10)     //Retirado uma linha em branco da parte inferior do boleto (09-05-2013)
	//oPrint:Say  (nRow3+2490,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow3+2540+(oFont11a:nHeight*2),100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow3+2590+(oFont11a:nHeight*2),100 ,aBolText[5],oFont11a)


	oPrint:Say  (nRow3+2340+(oFont8:nHeight*2),1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow3+2410+(oFont8:nHeight*2),1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow3+2480+(oFont8:nHeight*2),1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow3+2550+(oFont8:nHeight*2),1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow3+2620+(oFont8:nHeight*2),1810,"(=)Valor Cobrado"                               ,oFont8)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2690+(oFont8:nHeight*2),100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow3+2690+(oFont8:nHeight*2),100 ,"Sacado"                                         ,oFont8)
	EndIf
	oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2740+(oFont10:nHeight*2),400 ,aDatSacado[3]+" - "+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5]                                    ,oFont10)
	Else
		oPrint:Say  (nRow3+2740+(oFont10:nHeight*2),400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (nRow3+2780+(oFont10:nHeight*2),400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	EndIf
    
	If SEE->EE_CODIGO<>"745"
	oPrint:Say  (nRow3+2780+(oFont10:nHeight*2),1750,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,10)  ,oFont10)
	Else
	oPrint:Say  (nRow3+2780+(oFont10:nHeight*2),1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	Endif

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Say  (nRow3+2900+(oFont8:nHeight*2),100 ,"Sacador/Avalista"                               ,oFont8)
	//Else
	oPrint:Say  (nRow3+2815+(oFont8:nHeight*2),100 ,"Sacador/Avalista"                               ,oFont8)
	//EndIf

	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14

			oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),1750,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),1750,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Say  (nRow3+2935+(oFont8:nHeight*2),1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	//Else
	oPrint:Say  (nRow3+2855+(oFont8:nHeight*2),1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	//EndIf

	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
	oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
	oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Line (nRow3+2930,100,nRow3+2930,2300  )
	//Else
	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
	//EndIf

	//MSBAR("INT25",13.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.9,Nil,Nil,"A",.F.)
	//oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,0.9,Nil,Nil,"A",.F.)

	//--- Diogo Moura - 29/01/2018 ---//
	If SEE->EE_CODIGO=="237"
		//oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
		//oPrint:FWMsBar("INT25",40,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",67.5,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",39.5,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		//Fim --- Diogo Moura - 29/01/2018 ---//
	ElseIf SEE->EE_CODIGO=="001"
		oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",40,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
	Else
		oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,0.9,Nil,Nil,"A",.F.)
	EndIf


	oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ?Modulo10 ?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ?Modulo11 ?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ³Ret_cBarra?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

	LOCAL cValorFinal := StrZero((nvalor*100),10)  //strzero(int(nValor*100),10)
	LOCAL cNroDoc 
	LOCAL nDvnn			:= 0
	LOCAL nDvcb			:= 0
	LOCAL nDv			:= 0
	LOCAL cNN			:= ''
	LOCAL cRN			:= ''
	LOCAL cCB			:= ''
	LOCAL cS				:= ''
	LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)
	//--- Marciane 11.10.05 - O parametro define o codigo da carteira
	//LOCAL cCart			:= "109"
	//--- fim Marciane 11.10.05
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	cS    :=  cAgencia + cConta + cDacCC + cCart + cNroDoc
	nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num

    If SE1->E1_PORTADO<>"745"
	   cNroDoc := strzero(val(cNroDoc),8)
	Else
	  cNroDoc := strzero(val(cNroDoc),11)
	Endif

	 

	//cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn)) Correção Nosso Número Gleice 12/01/2021
	
	If SE1->E1_PORTADO<>"745"
	   cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn)) 
	Else
	  cNN    := cNroDoc
	Endif

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + cFator +  cValorFinal + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)

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
	cRN   := cRN + cFator + StrZero((nvalor*100),10)  //StrZero(Int(nValor * 100),14-Len(cFator))

Return({cCB,cRN,cNN})



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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ³Ret_cBarra?Autor ?Microsiga             ?Data ?13/10/03 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico para Clientes Microsiga                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function Ret_cBa4rra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cCCosmo)

	LOCAL cValorFinal := StrZero((nvalor*100),10)  //strzero(int(nValor*100),10)
	LOCAL cNroDoc := strzero(val(cNroDoc),11)
	LOCAL nDvnn			:= 0
	LOCAL nDvcb			:= 0
	LOCAL nDv			:= 0
	LOCAL cNN			:= ''
	LOCAL cRN			:= ''
	LOCAL cCB			:= ''
	LOCAL cS				:= ''
	LOCAL cFator      	:= strzero(dVencto - ctod("07/10/1997"),4)
	Local cCosInd		:= SubStr(cCCosmo,1,1)
	Local cCosBase		:= SubStr(cCCosmo,2,6)
	Local cCosSeq		:= SubStr(cCCosmo,8,2)
	Local cCosDv		:= SubStr(cCCosmo,10,1)

	//--- Marciane 11.10.05 - O parametro define o codigo da carteira
	//LOCAL cCart			:= "109"
	//--- fim Marciane 11.10.05
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	cS    :=  cNroDoc //cAgencia + cConta + cDacCC + cCart + cNroDoc
	nDvnn :=  modulo11(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
	//cNN   :=  cNroDoc + '-' + AllTrim(Str(nDvnn)) //cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))
    cNN   :=  cNroDoc  //Gleice 18012021
	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco +"9"+cFator+cValorFinal + "3"+"100"+Alltrim(cCosBase)+Alltrim(cCosSeq)+Alltrim(cCosDv)+"0"+Subs(cNN,1,11)//+Subs(cNN,13,1)
	nDvcb := modulo11(cS) //Modulo 11 com base 9

	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb))+ SubStr(cS,5,39)

	//-------- Conteudo da Conta Cosmos - Manaus
	//             Indice - 0
	//               Base - 106496
	//          Sequencia - 01
	// Digito Verificador - 3

	//-------- Conteudo da Conta Cosmos - São Paulo
	//             Indice - 0
	//               Base - 103182
	//          Sequencia - 01
	// Digito Verificador - 8

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.DDDEX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao (745 - Banco Citibank S/A. )
	//	  B = Codigo da moeda, sempre 9 (9 ?Valor Obrigatório (R$))
	//	  C = Código do produto (3 - Cobrança com registro / sem registro)
	//	DDD = Portfolio (Os 3 últimos dígitos do campo de identificação da empresa no CITIBANK. (Posição 44 a 46 do arquivo retorno) )
	//    E = Conta Cosmos (1o dígito do base (ver pág. 17))
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo (Dígito verificador do 1?campo da linha digitável (ver pág. 20))

	cS    := cBanco+"93"+"100"+SubStr(cCosBase,1,1)
	nDv   := modulo10(cS)
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + ' '

	// 	CAMPO 2:
	//	DDDDDD = Conta Cosmos (2o a 6o dígito do base (ver pág. 17))
	//	    EE = Conta Cosmos (Sequência da conta cosmos (ver pág. 15))
	//	     F = Conta Cosmos (Dígito verificador da conta cosmos)
	//	    YY = Nosso Número (2 primeiros dígitos do nosso número)

	cS := +SubStr(cCosBase,2,5) +Alltrim(cCosSeq)+Alltrim(cCosDv)+Subs(cNN,1,2)
	nDv:= modulo10(cS)
	cRN:= cRN+SubStr(cS,1,5)+"."+SubStr(cS,6,5)+AllTrim(Str(nDv)) + ' '

	// 	CAMPO 3:
	//	FFFFFFFFFF = Nosso Numero (Os 10 últimos dígitos do nosso no.)
	//	    	 G = Digito verificador da linha digitável
	cS    := Subs(cNN,2,10)
	nDv   := modulo10(cS)
	cRN   := cRN + Subs(cNN,2,5)+"."+Subs(cNN,7,5)+AllTrim(Str(nDv))

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + ' '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cRN   := cRN + cFator + StrZero((nvalor*100),10)  //StrZero(Int(nValor * 100),14-Len(cFator))

Return({cCB,cRN,cNN})


STATIC FUNCTION MONTAHTML(_nlinha)
cMSg := ''
cMsg += '<html> '
cMsg += '<head> '
//cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '
cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> '
cMsg += '<title>BOLETOS - STECK DISTRIBUIDORA LTDA</title> '
cMsg += '<style type="text/css"> '
cMsg += '   .botao { '
cMsg += '	       border-top: 2px solid #5571A7; '
cMsg += '		   border-bottom: 2px solid #08245A; '
cMsg += '		   border-right:  2px solid #08245A; '
cMsg += '		   border-left:  2px solid #5571A7; '
cMsg += '		   background: #0C3381; '
cMsg += '		   color: #fff; '
cMsg += '		   font-size: 12px; '
cMsg += '		   padding: 1 5px; '
cMsg += '	       } '
cMsg += 'a:hover {  text-decoration: underline} '
cMsg += 'a:link {  text-decoration: none} ' 
cMsg += 'a:active {  } '
cMsg += '.cel-b '
cMsg += '{ background: #F0F0F0; } '
cMsg += '.tit-tabela  '
cMsg += '{ font-weight: bold; background: #0C3381; color: #fff; padding: 4px 5px; } '
cMsg += '.tabela '
cMsg += '{ border-left: 1px solid #ccc; border-top: 1px solid #ccc; } '
cMsg += '.texto { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 12px; '
cMsg += '	color: #333333; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: normal; '
cMsg += '} '
cMsg += '.Scroll { '
cMsg += 'SCROLLBAR-FACE-COLOR: #DEDEDE;  '
cMsg += 'SCROLLBAR-HIGHLIGHT-COLOR: #DEDEDE;  '
cMsg += 'SCROLLBAR-SHADOW-COLOR: #ffffff;  '
cMsg += 'SCROLLBAR-3DLIGHT-COLOR: #ffffff;  '
cMsg += 'SCROLLBAR-ARROW-COLOR:  #ffffff;  '
cMsg += 'SCROLLBAR-TRACK-COLOR: #ffffff;  '
cMsg += 'SCROLLBAR-DARKSHADOW-COLOR: #DEDEDE;  '
cMsg += '} '
cMsg += '.combo { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 11px; '
cMsg += '	margin: 1px; '
cMsg += '	padding: 1px; '
cMsg += '	border: 1px solid #000000; '
cMsg += '} '
cMsg += '.comboselect { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	color: #666666; '
cMsg += '	font-size: 11px; '
cMsg += '	border: 1px #CCCCCC double; '
cMsg += '} '
cMsg += '.links { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 11px; '
cMsg += '	color: #CC0000; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.links-clientes { '
cMsg += 'font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none '
cMsg += '} '
cMsg += '.textobold { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 11px; '
cMsg += '	color: #003366; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.textoItalico { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 11px; '
cMsg += '	color: 7F7F7F; '
cMsg += '	text-decoration: none; '
cMsg += '	font-style: italic; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.titulo { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 16px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.links-detalhes { '
cMsg += 'font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: FF0000; text-decoration: none '
cMsg += '} '
cMsg += '.TituloMenor { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 12px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.Botoes { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 10px; '
cMsg += '	font-weight: normal; '
cMsg += '	text-decoration: none; '
cMsg += '	margin: 2px; '
cMsg += '	padding: 2px; '
cMsg += '	cursor: hand; '
cMsg += '	border: 1px outset #000000; '
cMsg += '} '
cMsg += '.TarjaTopoMenu { '
cMsg += '	text-decoration: none; '
cMsg += '	height: 6px; '
cMsg += '	background-image: url(apmenu-right.jpg); '
cMsg += '} '
cMsg += '.FundoMenu { '
cMsg += '	text-decoration: none; '
cMsg += '	background-image: url(apmenu-right.jpg); '
cMsg += '} '
cMsg += '.FonteMenu { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 12px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.FonteSubMenu { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 12px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '} '
cMsg += '.FundoSubMenu { '
cMsg += '	text-decoration: none; '
cMsg += '	background-image: url(apmenu-right.jpg); '
cMsg += '} '
cMsg += '.DivisoriaOpçõesMenu { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #6680A6; '
cMsg += '	background-image: url(apmenu-right.jpg); '
cMsg += '} '
cMsg += '.TarjaTopoLogin { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #426285; '
cMsg += '	height: 6px; '
cMsg += '} '
cMsg += '.FundoLogin { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #F7F7F7; '
cMsg += '} '
cMsg += '.FundoClaro { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #fbfbfb; '
cMsg += '} '
cMsg += '.TituloDestaques { '
cMsg += '	font-family: Verdana, Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 11px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.TextoDestaques { '
cMsg += '	font-family: Verdana, Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 10px; '
cMsg += '	color: #777777; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: normal; '
cMsg += '} '
cMsg += '.FundoDestaques { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #E5E5E5; '
cMsg += '} '
cMsg += '.FundoPontilhado { '
cMsg += '	text-decoration: none; '
cMsg += '	background-image: url(pontilhado.gif); '
cMsg += '	height: 5px; '
cMsg += '} '
cMsg += '.FundoPontilhadoVertical { '
cMsg += '	text-decoration: none; '
cMsg += '	background-image: url('+"'"+'file:///C:/mp8/mp_data/workflow/HTML/PC/imagens/pontilhado_vertical.gif'+"'"+'); '
cMsg += '	height: 5px '
cMsg += '} '
cMsg += '.TituloTabelas { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 12px; '
cMsg += '	color: #FFFFFF; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '} '
cMsg += '.FundoTituloTabela { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #495E73; '
cMsg += '} '
cMsg += '.TarjaTopoCor { '
cMsg += '	text-decoration: none; '
cMsg += '	height: 6px; '
cMsg += '	background-image: url('+"'"+'file:///C:/mp8/mp_data/workflow/HTML/PC/imagens/pontilhado.gif'+"'"+'); '
cMsg += '	background-color: #6699CC '
cMsg += '} '
cMsg += '.FundoTabelaDestaques { '
cMsg += '	text-decoration: none; '
cMsg += '	background-color: #495E73; '
cMsg += '} '
cMsg += '.comboselect-pequeno { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	color: #666666; '
cMsg += '	font-size: 11px; '
cMsg += '	border: 1px solid #CCCCCC; '
cMsg += '	width: 132px; '
cMsg += '	clear: none; '
cMsg += '	float: none; '
cMsg += '	text-decoration: none; '
cMsg += '	left: 1px; '
cMsg += '	top: 1px; '
cMsg += '	right: 1px; '
cMsg += '	bottom: 1px; '
cMsg += '	clip:  rect(1px 1px 1px 1px); '
cMsg += '} '
cMsg += '.comboselect-grande { '
cMsg += '	font-family: Arial, Helvetica, sans-serif; '
cMsg += '	color: #666666; '
cMsg += '	font-size: 11px; '
cMsg += '	border: 1px #CCCCCC double; '
cMsg += '	width: 415px; '
cMsg += '} '
cMsg += '.texto-layer { '
cMsg += 'font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none '
cMsg += '} '
cMsg += '.tituloAvaliacao { '
cMsg += '	font-family: Verdana, Arial, Helvetica, sans-serif; '
cMsg += '	font-size: 9px; '
cMsg += '	color: #19167D; '
cMsg += '	text-decoration: none; '
cMsg += '	font-weight: bold; '
cMsg += '	vertical-align: middle; '
cMsg += '	text-align: center; '
cMsg += '	line-height: 12px; '
cMsg += '} '
cMsg += '</style> '
cMsg += '</head> '
cMsg += '<body class="TituloMenor"> '
cMsg += '<table cellpadding="0" cellspacing="0" border="0" width="954" height="31" id="table1" bordercolor="#FFFFFF"> '
cMsg += '   <tr> '
cMsg += '       <td width="171" rowspan="2" background="file:///C:/mp8/mp_data/workflow/HTML/PC/imagens/bg-logo.gif" align="center" height="31"> '
cMsg += '       <img  src="https://ecommercenews.com.br/wp-content/uploads/2017/12/steck-584x389.jpg" width="270" height="90"> '
cMsg += '	 </td> '
cMsg += '	 '
cMsg += '	 <td background="file:///C:/mp8/mp_data/workflow/HTML/PC/imagens/bg-barra1.gif" height="74" width="560"> '
cMsg += '        <strong> '
cMsg += '		<font color="#FFFFFF"><span style="font-size: 18px"> '
cMsg += '		<img border="0"  width="600" height="100"></span></font></strong></td> '
cMsg += '   </tr> '
cMsg += '</table> '
cMsg += '<p align="center"><strong><font><span style="font-size:28px">BOLETOS - STECK DISTRIBUIDORA LTDA</span></font></strong> '
cMsg += '	<hr> '
cMsg += '</p> '
cMsg += '<table width="96%" border="0" align="center" cellpadding="0" cellspacing="3"> '
cMsg += '  <tr> '
cMsg += '    <td width="50%"><div align="left"><span class="TituloMenor"><span class="textoItalico">Data:'+DTOC(DATE())+'</span></span></div></td> '
cMsg += '    <td width="50%">&nbsp;</td> '
cMsg += '  </tr> '
cMsg += '</table> '
cMsg += '  <tr> '
cMsg += '    <td width="100%" bordercolor="#FFFFFF" class="titulo" style="border: 1px solid #C0C0C0"> '
cMsg += '	<table border="0" cellpadding="2" cellspacing="1" width="100%"> '
cMsg += '        <tr> '
cMsg += '          <td class="TituloMenor"> '
cMsg += '		    '+_cMens+' '
cMsg += '          </td> '
cMsg += '          <td class="texto"></td> '
cMsg += '          <td class="TituloMenor"></td> '
cMsg += '          <td class="texto"></td> '
cMsg += '        </tr> '
cMsg += '      </table> '
cMsg += '       <table width="100%" border="0" cellspacing="2" style="border: 1px solid #C0C0C0; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px" class="cel-b" id="table2"> '
cMsg += '      <tr bgcolor="#E4E4E4" class="TituloMenor"> '
cMsg += '       	<td align="center" bgcolor="#0C3381" width="100"><font color="#FFFFFF"><span style="font-size: 9pt"><b>Nº Título   </b></span></font></td> '
cMsg += '					<td align="center" bgcolor="#0C3381" width="100"><font color="#FFFFFF"><span style="font-size: 9pt"><b>Parcela     </b></span></font></td> '
cMsg += '        	<td align="center" bgcolor="#0C3381" width="250"><font color="#FFFFFF"><span style="font-size: 9pt"><b>Data Emissão</b></span></font></td> '
cMsg += '					<td align="center" bgcolor="#0C3381" width="250"><font color="#FFFFFF"><span style="font-size: 9pt"><b>Vencto      </b></span></font></td> '
cMsg += '					<td align="center" bgcolor="#0C3381" width="250"><font color="#FFFFFF"><span style="font-size: 9pt"><b>Valor Título</b></span></font></td> '
cMsg += '      </tr> '

_cQryE1 := "SELECT * FROM "+RetSqlName("SE1")+" E1 WHERE E1.D_E_L_E_T_ = ' ' "
_cQryE1 += "AND E1.E1_FILIAL  = '"+_aDados[_nlinha,10]+"' "
_cQryE1 += "AND E1.E1_NUM     = '"+_aDados[_nlinha,01]+"' "
_cQryE1 += "AND E1.E1_CLIENTE = '"+_aDados[_nlinha,02]+"' "
_cQryE1 += "AND E1.E1_LOJA    = '"+_aDados[_nlinha,03]+"' "
_cQryE1 += "AND E1.E1_SERIE   = '"+_aDados[_nlinha,09]+"' "
_cQryE1 += "AND E1.E1_SALDO > 0  "
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryE1), 'XSE1', .F., .T.)

//_nRec := 0
//DbEval({|| _nRec++  })           
XSE1->(DBGOTOP())
While !XSE1->(EOF())
	cMsg += '	<tbody><tr bgcolor="#FFFFFF" class="texto-layer"> '
	cMsg += '	<td align="center" width="60"><div > '
	cMsg += '	<font face="Verdana"style="font-size: 7pt">'+XSE1->E1_NUM+'</font></div></td> '
	cMsg += ' <td align="center"><font face="Verdana" style="font-size: 7pt">'+XSE1->E1_PARCELA+'</font></td> '
	cMsg += ' <td align="center"><font face="Verdana" style="font-size: 7pt">'+DTOC(stod(XSE1->E1_EMISSAO))+'</font></td> '
	cMsg += ' <td align="center" width="258"><font face="Verdana" style="font-size: 7pt">'+DTOC(stod(XSE1->E1_VENCTO))+'</font></td> '
	cMsg += ' <td align="center" width="258"><font face="Verdana" style="font-size: 7pt">'+Transform(XSE1->E1_VALOR,"@E 999,999,999,999.99")+'</font></td>    '       	
	cMsg += ' </tr>
	cMsg += '</tbody> 
	XSE1->(DBSKIP())
Enddo
XSE1->(DBCLOSEAREA())

cMsg += '    </table> '
cMsg += '<p>&nbsp;</p> '
cMsg += '<br> '
cMsg += '<p class="TituloMenor"> '
cMsg += '<br/><br/>Atenciosamente, '
cMsg += '<br/><br/>Departamento Financeiro  '
cMsg += '<br/>STECK DISTRIBUIDORA LTDA   '
cMsg += '<br/>CNPJ : 44.415.136/0001-38 </p> '
cMsg += '<p>&nbsp;</p> '
cMsg += '</table> '
cMsg += '</body> ' 
cMsg += '</html> '

RETURN 

STATIC Function XSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cFrom		:= GetMV( "MV_RELACNT" )   
Local cAttach 	:= cAnexo


CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return
