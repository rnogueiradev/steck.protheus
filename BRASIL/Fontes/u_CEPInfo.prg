#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"

#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STCEP            | Autor | GIOVANI.ZAGO             | Data | 19/07/2014  |
|=====================================================================================|
|Descrição | STCEP                                                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCEP                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCEP(_cCep,_cTip,_cNum)
	*-----------------------------*
	Local aArea 		:= GetArea()
	Local _lCall      	:= IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _lPv        	:= IsInCallSteck("MATA410")
	Local _lCli        	:= IsInCallSteck("MATA030")
	Local _lFor        	:= IsInCallSteck("MATA020")
	Local _lTrans       := IsInCallSteck("MATA050")
	Local _lRet         := .T.
	Local bCEPSearch
	Local cXML
	Local cError		:= ""
	Local cWarning		:= ""
	Local cUF
	Local cCidade
	Local cBairro
	Local cMensagem
	Local cResultado
	Local cLogradouro
	Local cTpLogradouro
	Local oWSCEP
	Local oXML
	Local _lBloq := GetMv("ST_CEPBLQ",,.T.)
	Local _lFora := .F.		//FR - 10/09/2021 - indica que a chamada veio de fora do Protheus

	Private _lSa2Aut		:= IsInCallSteck("U_STINCSA2")
	Default _cNum := ""
	Default _cTip		:= ' '

	If IsInCallStack("U_STMKP030") .Or. IsInCallStack("U_STIMP040") .Or. IsInCallStack("POST")
		Return(.T.)
	EndIf

	//FR - 10/09/2021:
	//qdo a chamada vem do POST não tá retornando .T. lá em cima, então coloco aqui para poder sair desta função
	If IsBlind()
		_lFora := .T.
	Endif 

	If _lFora	
		Return(.T.)
	Endif 

	If !Empty(_cNum)
		_lCli := .T.
	EndIf

	If _lBloq
		Return(.t.)
	EndIf

	_cCep:= StrTran(_cCep,"-","")
	_cCep:=  AllTrim(_cCep)
	If Len(_cCep) <> 8 .And. ! Empty(AllTrim(_cCep))
		If !Isblind()
			MsgInfo("Cep Nao Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
		Endif 
		Return(.f.)
	EndIf
	// Ajuste referente ao Ticket 20220829016666.
	/*If _cCep = '02275010'
		MsgInfo("Cep N�o Autorizado....Solicite Libera��o � Gerencia Comercial...!!!!")
		Return(.f.)
	EndIf*/

	If  ( Type("l410Auto") == "U" .OR. !l410Auto )

		/*
		BEGIN SEQUENCE
		bCEPSearch := { ||						;
		oWSCEP 		:= WSU_WSCEPINFO():New(),	;
		oWSCEP:cCEP	:=  _cCep  ,				;
		oWSCEP:CEPSEARCH()						;
		}

		MsgRun( "Aguarde" , "Consultando CEP" , bCEPSearch ) //"Aguarde"###"Consultando CEP"

		cXML		:= oWSCEP:cCEPSEARCHRESULT
		If Valtype(cXML) <>'U'
		oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )

		cResultado	:= oXml:_WebServiceCep:_Resultado:Text
		cMensagem	:= oXml:_WebServiceCep:_Resultado_Txt:Text

		IF ( cResultado == "1" )

		cUF				:= NoAcento(oXml:_WebServiceCep:_UF:Text           )
		cCidade			:= NoAcento(oXml:_WebServiceCep:_Cidade:Text       )
		cBairro			:= NoAcento(oXml:_WebServiceCep:_Bairro:Text       )
		cLogradouro		:= NoAcento(oXml:_WebServiceCep:_Logradouro:Text   )
		cTpLogradouro	:= NoAcento(oXml:_WebServiceCep:_Tipo_Logradouro:Text  )
		cNumEnd  	    := NoAcento(STNUMCEP())
		cTpLogradouro	:= NoAcento(cTpLogradouro+' '+cLogradouro+', '+cNumEnd)
		Else
		MsgInfo("Cep Não Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
		cUF				:= SPACE(TamSx3("A1_EST")[1])
		cCidade			:= SPACE(TamSx3("A1_MUN")[1])
		cBairro			:= SPACE(TamSx3("A1_BAIRRO")[1])
		cLogradouro		:= SPACE(TamSx3("A1_END")[1])
		cTpLogradouro	:= SPACE(TamSx3("A1_END")[1])

		EndIF
		Else
		MsgInfo("Cep Não Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
		cUF				:= SPACE(TamSx3("A1_EST")[1])
		cCidade			:= SPACE(TamSx3("A1_MUN")[1])
		cBairro			:= SPACE(TamSx3("A1_BAIRRO")[1])
		cLogradouro		:= SPACE(TamSx3("A1_END")[1])
		cTpLogradouro	:= SPACE(TamSx3("A1_END")[1])

		EndIF
		END SEQUENCE
		*/
		DbSelectArea("JC2")
		JC2->( dbSetOrder(1))

		If JC2->( dbSeek(xFilial("JC2")+_cCep) ) .And. !Empty(Alltrim(_cCep))
			cUF				:= Alltrim(JC2->JC2_ESTADO)
			cCidade			:= Alltrim(JC2->JC2_CIDADE)

			If IsInCallStack("U_STFAT300") .Or. IsInCallStack("U_STIMP041")
				cBairro			:= Alltrim(JC2->JC2_BAIRRO)
				cLogradouro		:= Alltrim(JC2->JC2_LOGRAD)
				cNumEnd  	    := _cNum
			Else
				cBairro			:= Iif(Empty(Alltrim(JC2->JC2_BAIRRO)), TiraGraf(STNUMCEP('2')) ,Alltrim(JC2->JC2_BAIRRO))
				cLogradouro		:= Iif(Empty(Alltrim(JC2->JC2_LOGRAD)),TiraGraf(STNUMCEP('3'))  ,Alltrim(JC2->JC2_LOGRAD))
				cNumEnd  	    := TiraGraf(STNUMCEP('1'))
			EndIf

			cTpLogradouro	:= TiraGraf(cLogradouro+', '+cNumEnd)
			cCodMun			:= Alltrim(JC2->JC2_CODCID)
		Else
			If !Empty(Alltrim(_cCep))
				If !IsBlind()
					MsgInfo("Cep Não Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
				Else 
					cMsgRet := "Cep Nao Encontrado..!!!"+CR+CR+"Verifique o Cep Digitado!!!"
				Endif 
			Else
				_cCep := '        '
			EndIf
			cUF				:= SPACE(TamSx3("A1_EST")[1])
			cCidade			:= SPACE(TamSx3("A1_MUN")[1])
			cBairro			:= SPACE(TamSx3("A1_BAIRRO")[1])
			cLogradouro		:= SPACE(TamSx3("A1_END")[1])
			cTpLogradouro	:= SPACE(TamSx3("A1_END")[1])
			cCodMun			:= SPACE(TamSx3("C5_XCODMUN")[1])
		EndIf

		If _lPv
			M->C5_ZCEPE     := UPPER(_cCep)
			M->C5_ZENDENT  := UPPER(cTpLogradouro )
			M->C5_ZESTE    := UPPER(cUF)
			M->C5_ZBAIRRE  := UPPER(cBairro)
			M->C5_ZMUNE    := UPPER(cCidade)
			M->C5_XCODMUN  := UPPER(cCodMun)
		ElseIf _lCall

			M->UA_ENDENT  := UPPER(cTpLogradouro )					// Endereço
			M->UA_BAIRROE := UPPER(cBairro)				    // Bairro
			M->UA_MUNE    := UPPER(cCidade)					// CIdade
			M->UA_CEPE    := UPPER(_cCep)					// CEP
			M->UA_ESTE    := UPPER(cUF)					// UF
			M->UA_XCODMUN := UPPER(cCodMun)
		ElseIf _lTrans

			M->A4_END 	 := UPPER(cTpLogradouro )					// Endereço
			M->A4_BAIRRO := UPPER(cBairro)				    // Bairro
			M->A4_MUN    := UPPER(cCidade)					// CIdade
			M->A4_CEP    := UPPER(_cCep)					// CEP
			M->A4_EST    := UPPER(cUF)					// UF

		ElseIf _lCli
			If _cTip = '1'
				M->A1_END 	 := UPPER(cTpLogradouro )					// Endereço
				M->A1_BAIRRO := UPPER(cBairro)				    // Bairro
				M->A1_CEP    := UPPER(_cCep)					// CEP
				M->A1_MUN    := UPPER(cCidade)					// CIdade
				M->A1_EST    := UPPER(cUF)
				M->A1_COD_MUN:= UPPER(cCodMun)				// UF
			ElseIf _cTip = '2'
				M->A1_ENDCOB  := UPPER(cTpLogradouro )					// Endereço
				M->A1_BAIRROC := UPPER(cBairro)				    // Bairro
				M->A1_MUNC    := UPPER(cCidade)					// CIdade
				M->A1_CEPC    := UPPER(_cCep)					// CEP
				M->A1_ESTC    := UPPER(cUF)					// UF
			ElseIf _cTip = '3'

				If M->A1_CEP = UPPER(_cCep) .And. !Empty(JC2->JC2_LOGRAD) //.And. Alltrim(UPPER(M->A1_END)) = Alltrim(UPPER(cTpLogradouro ))//Chamado 003204 - Mesmo CEP com endereços diferentes //mesmo cep com numero diferente giovani 07/01/2016
					cUF				:= SPACE(TamSx3("A1_EST")[1])
					cCidade			:= SPACE(TamSx3("A1_MUN")[1])
					cBairro			:= SPACE(TamSx3("A1_BAIRRO")[1])
					cLogradouro		:= SPACE(TamSx3("A1_END")[1])
					cTpLogradouro	:= SPACE(TamSx3("A1_END")[1])
					cCodMun			:= SPACE(TamSx3("C5_XCODMUN")[1])
					If !IsBlind()
						MsgInfo("Cep de Entrega NÃO pode ser Igual Cep de Faturamento..!!!"+CR+CR+"Verifique o Cep Digitado!!!")
					Endif  
				EndIf

				M->A1_ENDENT  := UPPER(cTpLogradouro )					// Endereço
				M->A1_BAIRROE := UPPER(cBairro)				    // Bairro
				M->A1_MUNE    := UPPER(cCidade)					// CIdade
				M->A1_CEPE    := UPPER(_cCep)					// CEP
				M->A1_ESTE    := UPPER(cUF)					// UF
				M->A1_CODMUNE := UPPER(cCodMun)				// UF

			ElseIf _cTip = '4'

				SA1->A1_END 	:= UPPER(cTpLogradouro )					// Endereço
				SA1->A1_BAIRRO 	:= UPPER(cBairro)				    // Bairro
				SA1->A1_CEP    	:= UPPER(_cCep)					// CEP
				SA1->A1_MUN    	:= UPPER(cCidade)					// CIdade
				SA1->A1_EST    	:= UPPER(cUF)
				SA1->A1_COD_MUN	:= UPPER(cCodMun)				// UF

			EndIf

		ElseIf _lFor

			M->A2_END 	 := UPPER(cTpLogradouro )					// Endereço
			M->A2_BAIRRO := UPPER(cBairro)				    // Bairro
			M->A2_CEP    := UPPER(_cCep)					// CEP
			M->A2_MUN    := UPPER(cCidade)					// CIdade
			M->A2_EST    := UPPER(cUF)					// UF
		EndIf

	EndIf

	RestArea(aArea)
	Return(_lRet)

	/*====================================================================================\
	|Programa  | STNUMCEP         | Autor | GIOVANI.ZAGO             | Data | 19/07/2014  |
	|=====================================================================================|
	|Descrição | STNUMCEP                                                                 |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STNUMCEP                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function STNUMCEP(_cTip)
	*-----------------------------*
	Local _cRet := Space(60)
	Local oDlgEmail
	Local lSaida      := .F.
	/*
	If _lSa2Aut
	_cRet	:= "1"
	Return
	EndIf
	*/
	If _cTip = '1'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Numero Entrega") From  1,0 To 80,200 Pixel OF oMainWnd

			@ 02,04 SAY "Numero:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 55,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 12,62 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo
	ElseIf _cTip = '2'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Bairro Entrega") From  1,0 To 85,200 Pixel OF oMainWnd

			@ 02,04 SAY "Bairro:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 90,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 26,35 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo

	ElseIf _cTip = '3'
		Do While !lSaida

			DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Endereço Entrega") From  1,0 To 85,200 Pixel OF oMainWnd

			@ 02,04 SAY "Endereço:" PIXEL OF oDlgEmail
			@ 12,04 MSGet _cRet   Size 90,013  PIXEL OF oDlgEmail valid !Empty(Alltrim(_cRet))
			@ 26,35 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cRet)),Eval({||lSaida:=.T.,oDlgEmail:End()}),msginfo("Preencha o Numero..!!!"))  Pixel

			ACTIVATE MSDIALOG oDlgEmail CENTERED
		EndDo
	EndIf
Return(Alltrim(_cRet))

Static function TiraGraf (_sOrig)
	local _sRet := _sOrig
	_sRet = strtran (_sRet, "á", "a")
	_sRet = strtran (_sRet, "é", "e")
	_sRet = strtran (_sRet, "í", "i")
	_sRet = strtran (_sRet, "ó", "o")
	_sRet = strtran (_sRet, "ú", "u")
	_SRET = STRTRAN (_SRET, "Á", "A")
	_SRET = STRTRAN (_SRET, "É", "E")
	_SRET = STRTRAN (_SRET, "Í", "I")
	_SRET = STRTRAN (_SRET, "Ó", "O")
	_SRET = STRTRAN (_SRET, "Ú", "U")
	_sRet = strtran (_sRet, "ã", "a")
	_sRet = strtran (_sRet, "õ", "o")
	_SRET = STRTRAN (_SRET, "Ã", "A")
	_SRET = STRTRAN (_SRET, "Õ", "O")
	_sRet = strtran (_sRet, "â", "a")
	_sRet = strtran (_sRet, "ê", "e")
	_sRet = strtran (_sRet, "î", "i")
	_sRet = strtran (_sRet, "ô", "o")
	_sRet = strtran (_sRet, "û", "u")
	_SRET = STRTRAN (_SRET, "Â", "A")
	_SRET = STRTRAN (_SRET, "Ê", "E")
	_SRET = STRTRAN (_SRET, "Î", "I")
	_SRET = STRTRAN (_SRET, "Ô", "O")
	_SRET = STRTRAN (_SRET, "Û", "U")
	_sRet = strtran (_sRet, "ç", "c")
	_sRet = strtran (_sRet, "Ç", "C")
	_sRet = strtran (_sRet, "à", "a")
	_sRet = strtran (_sRet, "À", "A")
	_sRet = strtran (_sRet, "º", ".")
	_sRet = strtran (_sRet, "ª", ".")
	_sRet = strtran (_sRet, chr (9), " ") // TAB
	return _sRet

	/*====================================================================================\
	|Programa  | STCADJC2         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCADJC2      cadastro de cCEP                           |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCADJC2                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCADJC2()
	*-----------------------------*
	Local aArea          := GetArea()
	Private _cUserCam  := GetMv("ST_STCADJC",,"000000")+"/000000/000612"

	If !(__cUserId $ _cUserCam)
		MsgInfo("Usuario Sem Acesso")
		Return()
	EndIf

	DbSelectArea("JC2")
	JC2->(DbSetOrder(1))

	AxCadastro("JC2","CEP")

	Restarea(aArea)

	Return()

	*-----------------------------*
User Function STCADPPM()
	*-----------------------------*
	Local aArea          := GetArea()

	DbSelectArea("PPM")
	PPM->(DbSetOrder(1))

	AxCadastro("PPM","EAA-2015")

	Restarea(aArea)

Return()
