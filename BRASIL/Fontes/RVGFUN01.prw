#INCLUDE "Protheus.ch" 
#INCLUDE "ParmType.ch"

//Estrutura de campos para formar arquivo HTML
#DEFINE POS_HT_CMP		1
#DEFINE POS_HT_TAM		2
#DEFINE POS_HT_TIT		3
#DEFINE POS_HT_PIC		4

//Tamanho da descricao do help no SX1
#DEFINE nTAMSX1H		35

//Constantes - Estrutura de dados para envio de emails
#DEFINE P_EML_FROM		1	//Conta SMTP
#DEFINE P_EML_USER 	2	//Usuario
#DEFINE P_EML_PWD 		3	//Senha
#DEFINE P_EML_SERV 	4	//Servidor
#DEFINE P_EML_PORT		5	//Porta
#DEFINE P_EML_AUTH 	6	//Autentica SMTP
#DEFINE P_EML_TLS 		7	//TLS
#DEFINE P_EML_TOUT 	8	//Timeout
#DEFINE P_EML_TO 		9	//Email destino
#DEFINE P_EML_SSL		10	//SSL

//--------------------------------------------------------------
/*/{Protheus.doc} rvgFun01
Classe de funcoes genericas

@author  - Pablo Gollan Carreras  
@since 14/02/2014
/*/
//--------------------------------------------------------------

Class rvgFun01

Data aTamObjRF		//Posicoes que definem tamanho (dimensao) do objeto - Referencia

//Propriedades de referencia de posicao
Data nTopCont
Data nEsqCont
Data nAltCont
Data nDistPad
Data nAltBot
Data nDistAPad
Data nDistEtq
Data nAltEtq
Data nLargEtq
Data nLargBot
Data cHK

//Metodos de inicializacao e finalizacao
Method New()
Method Finish()

//Metodos de funcionalidade
Method ApReducaoFWLayer(lConsVer)
Method GetMailConfig(lCapEml,lMens,cEmlSugere,cTitRot)
Method GetStartPath(lSepFin,cSubDir)
Method HTMxBody(aLstC,aLstVal,cTitulo,cRodape,lQuebra,lImpHead,nRecuo)
Method HTMxFooter()
Method HTMxHead(cTituloM,cLinkLOGO,lEmpresa,lQuebra)
Method HTMxMessage(cTitulo,cLinkLOGO,lInfoEmp,cMens,aLstREG)
Method InJob()
Method LastAlias(lTMP)
Method ListaCampos(cAlias,nTpRet,lIncFil,nArrFrm,aLstC,aLstCNL,bDecisaoAux,lRmEspT,lRmEspC,lLCpNBr,aLstCAd,lClasOrd)
Method LoadTables(aAlias,lPosIdx,lExMens)
Method MailSend(lSSL,lTLS,lAuth,cEmissor,cDest,cCC,cBCC,cAssunto,cMens,cServ,cPWD,nPorta,cUsuario,nTOUT,lGeraArq,aAnexo,lMostraMsg,lTentaAlt)
Method QuebraLinha(cTexto,nLimite)
Method RetCampoLOG(cAlias,nTipo)
Method RetFunName(lRotMenu,lDelimita,nRotRecuo)
Method RetGroupSize(cGrupo,cCampo,nTamPad)
Method RetPictNumerica(nCasas,nDecimais,lEuro,lSepM)
Method SetObjectSize(aTamObj,nTOP,nLEFT,nWIDTH,nBOTTOM,lAcVlZr,oObjAlvo)
Method SetRPCCon(cEmp,cFil,cModulo,aTabs,lMens)

EndClass

//--------------------------------------------------------------
/*/{Protheus.doc} New
Metodo para inicializar a classe de funcionalidades

@param : Nenhum

@return : Nenhum

@author Pablo Gollan Carreras  
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method New() Class rvgFun01

::aTamObjRF		:= Array(4)
::nTopCont		:= 003
::nEsqCont		:= 001
::nAltCont		:= 009
::nDistPad		:= 002
::nAltBot		:= 013
::nDistAPad		:= 004
::nDistEtq		:= 001
::nAltEtq		:= 007
::nLargEtq		:= 035
::nLargBot		:= 040
::cHK			:= "&"
aFill(::aTamObjRF,0)

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} Finish
Metodo para finalizar a classe

@param : Nenhum

@return : Nenhum

@author Pablo Gollan Carreras  
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method Finish() Class rvgFun01

FreeObj(oSelf)

Return Nil

//--------------------------------------------------------------
/*/{Protheus.doc} ApReducaoFWLayer
Metodo para definir se deve ser aplicado reducao de tamanho para 
a classe FWLayer nas janelas, em interface MDI e/ou com tema 
TEMAP10.

@param01[L] : Considerar a versao do FWLayer

@return[L] : Aplicar reducao de tamanho da area do FWLayer

@author Pablo Gollan Carreras  
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method ApReducaoFWLayer(lConsVer) Class rvgFun01

Local lRet				:= .F.
Local bCond				:= {|| }

PARAMTYPE 0	VAR lConsVer	AS Logical	OPTIONAL	DEFAULT .F.

If !lConsVer
	bCond := &('{|| (AllTrim(PtGetTheme()) == "MDI" .OR. AllTrim(GetTheme()) == "TEMAP10")}')
Else
	bCond := &('{|| (AllTrim(PtGetTheme()) == "MDI" .OR. AllTrim(GetTheme()) == "TEMAP10") .AND. AllTrim(GetVersao(.F.)) # "11" .AND. ' + ;
		'CtoD(DtoC(GetAPOInfo("FWLAYER.PRW")[4])) < CtoD("1/1/2011")}')
Endif
If Eval(bCond)
	lRet := .T.
Endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} RetFunName
Metodo para retornar nome de funcao de chamada, de menu ou
imediato da pilha de processos.

@Param01[L] : Considerar rotina de chamada do menu?
@Param02[L] : Envolver o nome da rotina com delimitadores?
@Param03[N] : Numero de recuos na pilha de chamadas pra determinar
              a rotina de chamada

@return[C] : Nome da rotina

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method RetFunName(lRotMenu,lDelimita,nRotRecuo) Class rvgFun01

Local cRet				:= ""
Local ni				:= 0
Local aLstCarRm			:= {"U_",".T.",".F."}
Local nTamPar			:= 0
Local nProcAt			:= 0

PARAMTYPE 0	VAR lRotMenu	AS LOGICAL	OPTIONAL	DEFAULT .T.
PARAMTYPE 1	VAR lDelimita	AS LOGICAL	OPTIONAL	DEFAULT .F.
PARAMTYPE 2	VAR nRotRecuo	AS NUMERIC	OPTIONAL	DEFAULT 1

If Type("PARAMIXB") == "A" .AND. IsInCallStack("EXECBLOCK")
	nTamPar := Len(PARAMIXB)
	If nTamPar >= 1 .AND. ValType(PARAMIXB[1]) == "L"
		lRotMenu := PARAMIXB[1]
	Endif
	If nTamPar >= 2 .AND. ValType(PARAMIXB[2]) == "L"
		lDelimita := PARAMIXB[2]
	Endif
	nProcAt := 2
Else
	nProcAt := nRotRecuo
Endif
If Upper(AllTrim(ProcName(nProcAt))) == "EXECBLOCK"
	nProcAt++
Endif
	cRet := Upper(AllTrim(AllToChar(IIf(lRotMenu,FunName(),ProcName(nProcAt)))))
If !Empty(cRet)
	For ni := 1 to Len(aLstCarRm)
		cRet := StrTran(cRet,aLstCarRm[ni],"")
	Next ni
	If lDelimita
		cRet := "[" + cRet + "]" + Space(1)
	Endif
Endif

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} SetObjectSize
Funcao para alimentar variavel de definicao de tamanho e posicio-
namento de objeto. VALORES NEGATIVOS com objeto container declara-
do indicara que o calculo do percentual sera utilizado.

@param01[A] : Array de tamanho e posicionamento
@param02[N] : Topo (valor negativo interpretado como % area)
@param03[N] : Esquerda (valor negativo interpretado como % area)
@param04[N] : Largura (valor negativo interpretado como % area)
@param05[N] : Altura (valor negativo interpretado como % area)
@param06[N] : Aceitar valores zerados (caso nao, nao altera os valo-
              res preexistentes na posicao.
@param07[O] : Objeto de referencia para calculo de posicao mediante
              percentuais em relacao a area do objeto container.

@return : Nenhum

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method SetObjectSize(aTamObj,nTOP,nLEFT,nWIDTH,nBOTTOM,lAcVlZr,oObjAlvo) Class rvgFun01

Local lRefPerc			:= .F.
Local nDimen			:= 0

PARAMTYPE 0	VAR aTamObj		AS ARRAY		OPTIONAL	DEFAULT aClone(::aTamObjRF)
PARAMTYPE 1	VAR nTOP		AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 2	VAR nLEFT		AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 3	VAR nWIDTH		AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 4	VAR nBOTTOM		AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 5	VAR	lAcVlZr		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 6	VAR	oObjAlvo	AS OBJECT		OPTIONAL	DEFAULT Nil

If ValType(oObjAlvo) == "O"
	lRefPerc := !lRefPerc
Endif
If Len(aTamObj) # 4
	aTamObj := aSize(aTamObj,4)
Endif
If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nTOP))
	If lRefPerc
		If nTOP < 0
			nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
			aTamObj[1] := (Abs(nTOP) / 100) * (nDimen / 2)
		Else
			aTamObj[1] := Abs(nTOP)
		Endif
	Else
		aTamObj[1] := Abs(nTOP)
	Endif
Endif
If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nLEFT))
	If lRefPerc
		If nLEFT < 0
			nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
			aTamObj[2] := (Abs(nLEFT) / 100) * (nDimen / 2)
		Else
			aTamObj[2] := Abs(nLEFT)
		Endif
	Else
		aTamObj[2] := Abs(nLEFT)
	Endif
Endif
If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nWIDTH))
	If lRefPerc
		If nWIDTH < 0
			nDimen := IIf(Type("oObjAlvo:nClientWidth") == "U",oObjAlvo:nWidth,oObjAlvo:nClientWidth)
			aTamObj[3] := (Abs(nWIDTH) / 100) * (nDimen / 2)
		Else
			aTamObj[3] := Abs(nWIDTH)
		Endif
	Else
		aTamObj[3] := Abs(nWIDTH)
	Endif
Endif
If lAcVlZr .OR. (!lAcVlZr .AND. !Empty(nBOTTOM))
	If lRefPerc
		If nBOTTOM < 0
			nDimen := IIf(Type("oObjAlvo:nClientHeight") == "U",oObjAlvo:nHeight,oObjAlvo:nClientHeight)
			aTamObj[4] := (Abs(nBOTTOM) / 100) * (nDimen / 2)
		Else
			aTamObj[4] := Abs(nBOTTOM)
		Endif
	Else
		aTamObj[4] := Abs(nBOTTOM)
	Endif
Endif
::aTamObjRF := aClone(aTamObj)

Return Nil

//--------------------------------------------------------------
/*/ {Protheus.doc} SetRPCCon
Rotina de conexao RPC

@Param01[C] : Codigo da empresa
@Param02[C] : Codigo da filial
@Param03[C] : Codigo do modulo
@Param04[A] : Lista de tabelas
@Param05[L] : Exibir mensagem de console?

@return[A] : Estrutura : [1] Alias
                         [2] Campo
                         [3] Tipo
                         [4] Tamanho
                         [5] Decimais

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method SetRPCCon(cEmp,cFil,cModulo,aTabs,lMens) Class rvgFun01

Local lRet				:= .T.
Local ni				:= 0
Local cTMP				:= ""
Local lOk				:= .F.
Local aErro				:= {}
Local lJob				:= ::InJob()
Local cRotN				:= ::RetFunName(.F.,.T.) 
Local bExMens			:= {|x| IIf(lMens,IIf(lJob,ConOut(cRotN + x),MsgStop(x,cRotN)),.F.)}
Local nTenta			:= 0
Local nTentaMax			:= 3

PARAMTYPE 0	VAR cEmp		AS CHARACTER	OPTIONAL 	DEFAULT "01"
PARAMTYPE 1	VAR cFil		AS CHARACTER	OPTIONAL 	DEFAULT ""
PARAMTYPE 2	VAR cModulo		AS CHARACTER	OPTIONAL 	DEFAULT "SIGAFAT"
PARAMTYPE 3	VAR aTabs		AS ARRAY		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 4	VAR lMens		AS LOGICAL		OPTIONAL	DEFAULT .T.

If Empty(cEmp)
	Eval(bExMens,"Ausencia de parametro(s)")
	Return !lRet
Endif
If !lJob .AND. cEmpAnt == cEmp
	Return lRet
Endif
RpcSetType(3)
Do While !lOk
	If ++nTenta > nTentaMax
		Exit
	Endif
	lOk := RpcSetEnv(cEmp,cFil,,,cModulo,,IIf(!Empty(aTabs),aTabs,Nil),,,.T./*lOpenSX*/,.T./*lConnect*/)
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O retorno da funcao de conexao RPC pode retornar nulo  ³
//³em caso de falha, fazer validacao.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(lOk) # "L"
	lOk := .F.
Endif
If !lOk /*lOk 
	If !RpcChkSXs(cEmp,@aErro)
		If lMens
			lOk := .F.
			cTMP := "Os arquivos SX da empresa " + cEmp + " nao puderam ser abertos, processo interrompido! Erros : " + CRLF
			For ni := 1 to Len(aErro)
				If !Empty(aTail(aErro[ni]))
					lOk := .T.
					cTMP += "-" + AllTrim(AllToChar(aTail(aErro[ni]))) + CRLF
				Endif
			Next ni
			cTMP += IIf(!lOk,"-INDEFINIDO","")
			Eval(bExMens,cTMP)
		Endif
		lRet := !lRet
		RpcClearEnv()
	Endif
Else*/
	Eval(bExMens,"Falha na conexao RPC")
	lRet := !lRet
Endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} QuebraLinha
Funcao para formatar texto quebrando linhas de acordo com o li-
mite informado. Caso nenhum limite seja informado, o tamanho
considerado eh o do campo de help do SX1.

@param01[C] : Texto
@param02[C] : Limite por linha

@return[A] : Array com o texto quebrado em linhas

@author Pablo Gollan Carreras  
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

Method QuebraLinha(cTexto,nLimite) Class rvgFun01

Local aRet				:= {}
Local ni				:= 0
Local nTam				:= 0
Local nCont				:= 1
Local nPos				:= 0
Local cVogais			:= "AEIOUÁÉÍÓÚÂÊÎÔÛÀÈÌÒÙÃÕÄËÏÖÜ"
Local cConsoa			:= "BCDFGHJKLMNPQRSTVXWYZÇÑ"
Local cPontua			:= "(){}[]:.,;"
Local cNum				:= "0123456789"
Local cEspaco			:= " " + CRLF
Local lPontua 			:= .F.
Local lUltVog			:= .F.
Local lEncVoc			:= .F.
Local lEncCon			:= .F.
Local lTritongo 		:= .F.
Local lEspaco			:= .F.
Local lConEsp			:= .F.
Local lPalDuas			:= .F.
Local lPalTres			:= .F.

PARAMTYPE 0	VAR cTexto		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 1	VAR	nLimite		AS NUMERIC		OPTIONAL	DEFAULT nTAMSX1H

If Empty(cTexto)
	Return aRet
Endif
cTexto	:= AllTrim(cTexto)
nTam 	:= Len(cTexto)
aRet	:= Array(1)
nPos	:= Len(aRet)
If nTam > nLimite
	aRet[nPos] := ""
	For ni := 1 to nTam
		If ni > 1
			lPontua := Upper(Substr(cTexto,ni,1)) $ (cPontua + cNum)
			lUltVog	:= Upper(Right(aRet[nPos],1)) $ cVogais
			lEncVoc	:= Upper(Substr(cTexto,ni,1)) $ cVogais .AND. lUltVog
			lEncCon	:= Upper(Substr(cTexto,ni,1)) $ cConsoa .AND. Upper(Substr(cTexto,ni + 1,1)) $ cConsoa
			If lEncCon
				If Upper(Substr(cTexto,ni + 2,1)) $ "LR"
					lTritongo := .T.
				Else
					lTritongo := .F.
				Endif
			Else
				lTritongo := .F.
			Endif
			lEspaco	:= Upper(Substr(cTexto,ni,1)) $ cEspaco
			lConEsp	:= Upper(Substr(cTexto,ni,1)) $ cConsoa .AND. Upper(Substr(cTexto,ni + 1,1)) $ cEspaco
			//Palavra duas letras, que nao deve ser quebrada
			If ni > 2
				lPalDuas := Upper(Substr(cTexto,ni - 2,1)) $ cEspaco .AND. Upper(Substr(cTexto,ni,1)) $ (cConsoa + cVogais) .AND. ;
					Upper(Substr(cTexto,ni + 2,1)) $ (cEspaco + cPontua)
			Else
				lPalDuas := .F.
			Endif
			//Palavra tres letras, que nao deve ser quebrada
			If !lPalDuas .AND. ni > 2
				lPalTres := Upper(Substr(cTexto,ni - 2,1)) $ cEspaco .AND. Upper(Substr(cTexto,ni,1)) $ (cConsoa + cVogais) .AND. ;
					Upper(Substr(cTexto,ni + 1,1)) $ (cConsoa + cVogais) .AND. Upper(Substr(cTexto,ni + 2,1)) $ (cEspaco + cPontua)
			Else
				lPalTres := .F.
			Endif
			If nCont > nLimite .AND. ((!lPontua .AND. lUltVog .AND. !lEncVoc .AND. (!lEncCon .OR. lTritongo) .AND. !lConEsp .AND. !lPalDuas .AND. !lPalTres) .OR. (lEspaco))
				nCont := 0
				//Se nao for o ultimo caracter
				If ni < nTam
					//Se o caracter processado for uma consoante ou vogal e nao for um tritongo inserir o separador
					If Upper(Substr(cTexto,ni,1)) $ (cVogais + cConsoa)
						If lTritongo
							aRet[nPos] += Substr(cTexto,ni,1) + "-"
						Else
							aRet[nPos] += "-"
						Endif
					Endif
				Endif
				aAdd(aRet,"")
				nPos := Len(aRet)
			Else
				//Negar o tritongo, pois nao havera necessidade de quebra e a letra precisa ser adicionada
				lTritongo := .F.
			Endif
		Endif
		If !lTritongo
			aRet[nPos] += Substr(cTexto,ni,1)
		Endif
		nCont++
	Next ni
	For ni := 1 to Len(aRet)
		aRet[ni] := LTrim(aRet[ni])
	Next ni
Else
	aRet[nPos] := cTexto
Endif

Return aRet

//--------------------------------------------------------------
/*/{Protheus.doc} RetPictNumerica
Metodo para retornar uma picture de valor numerico de acordo com
o tamanho do campo e o numero de casas decimais informados.

@param01[N] : Tamanho do campo
@param02[N] : Numero de casas decimais
@param03[L] : Formatar o numero em formato europeu
@param04[L] : Incluir separador de milhar

@return[C] : Mascara de formatacao elaborada de acordo com os param.

@author Pablo Gollan Carreras  
@since 14/02/2014
/*/
//--------------------------------------------------------------

Method RetPictNumerica(nCasas,nDecimais,lEuro,lSepM) Class rvgFun01

Local cRet				:= ""
Local ni				:= 0
Local aForma			:= Array(2)
Local nLimite			:= 0
Local nCntM				:= 0
Local cSepM				:= ","
Local cSepD				:= "."

PARAMTYPE 0	VAR nCasas		AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 1	VAR nDecimais	AS NUMERIC		OPTIONAL	DEFAULT 0
PARAMTYPE 2	VAR lEuro		AS LOGICAL		OPTIONAL	DEFAULT .T.
PARAMTYPE 3	VAR lSepM		AS LOGICAL		OPTIONAL	DEFAULT .F.

If Empty(nCasas) .OR. nCasas < nDecimais
	Return cRet
Endif
aFill(aForma,"")
cRet := "@" + IIf(lEuro,"E","") + Space(1)
nLimite := (nCasas - IIf(!Empty(nDecimais),1,0)) - nDecimais
For ni := nLimite to 1 Step -1
	aForma[1] := "9" + aForma[1]
	If lSepM .AND. ++nCntM >= 3 .AND. ni # 1
		aForma[1] := cSepM + aForma[1]
		nCntM := 0
	Endif
Next ni
If !Empty(nDecimais)
	aForma[2] := cSepD + Replicate("9",nDecimais)
Endif
cRet += (aForma[1] + aForma[2])

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} RetCampoLOG
Rotina para retornar o nome de campo de LOG de inclusao e/ou 
alteracao de uma tabela informada.

@param01[C] : Alias da tabela alvo
@param02[N] : 1. Campo inclusao 2. Campo alteracao

@return[C] : Nome do campo

@author  - Pablo Gollan Carreras  
@since 14/02/2014
/*/
//--------------------------------------------------------------

Method RetCampoLOG(cAlias,nTipo) Class rvgFun01

Local cRet				:= ""

PARAMTYPE 0	VAR cAlias		AS Character				DEFAULT ""
PARAMTYPE 1	VAR nTipo		AS Numeric		OPTIONAL	DEFAULT 1

Do Case
	Case nTipo == 1
		If Substr(cAlias,1,1) == "S"
			cRet := Substr(cAlias,2,2) + "_USERLGI"
		Else
			cRet := cAlias + "_USERGI"
		Endif
	Case nTipo == 2
		If Substr(cAlias,1,1) == "S"
			cRet := Substr(cAlias,2,2) + "_USERLGA"
		Else
			cRet := cAlias + "_USERGA"
		Endif
EndCase

Return cRet

//--------------------------------------------------------------
/*/{Protheus.doc} RetGroupSize
Metodo para retornar o tamanho padrao de um campo relacionado
com um grupo de campos. Caso o grupo nao seja encontrado retorna
o tamanho do campo informado.

@param01[C] : Codigo do grupo de campos
@param02[C] : Nome do campo
@param03[N] : Tamanho padrao a ser considerado

@return[U] : Valor numerico

@author Pablo Gollan Carreras  
@since 14/02/2014
/*/
//--------------------------------------------------------------

Method RetGroupSize(cGrupo,cCampo,nTamPad) Class rvgFun01

Local nRet				:= 0
Local aAreaSXG			:= SXG->(GetArea())

PARAMTYPE 0	VAR cGrupo		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 1	VAR cCampo		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 2	VAR nTamPad		AS NUMERIC		OPTIONAL	DEFAULT 0

nTamPad	:= IIf(!Empty(cCampo),TamSX3(cCampo)[1],0)
If Empty(cGrupo) .OR. Empty(cCampo) .OR. Empty(nTamPad)
	Return nRet
Endif
dbSelectArea("SXG")
SXG->(dbSetOrder(1))
If SXG->(dbSeek(cGrupo))
	If SXG->XG_SIZE < nTamPad
		nRet := nTamPad
	Else
		nRet := SXG->XG_SIZE
	Endif
Else
	nRet := nTamPad
Endif
RestArea(aAreaSXG)

Return nRet

//--------------------------------------------------------------
/*/{Protheus.doc} LoadTables
Metodo para carregar tabelas na workarea, posicionar indices
(opcional) e validar a existencia da tabela no dicionario.

@Param01[C] : Array com os alias
@Param02[N} : Posicionar tabelas no primeiro indice
@Param02[N} : Exibir mensagem em caso de erro

@return[C] : Operacao ok

@author  - Pablo Gollan Carreras [RVG]
@since 14/02/2014
/*/
//--------------------------------------------------------------

Method LoadTables(aAlias,lPosIdx,lExMens) Class rvgFun01

Local lRet				:= .T.
Local cErro				:= ""
Local bForma01			:= {|x| Upper(AllTrim(x))}

PARAMTYPE 0	VAR aAlias		AS ARRAY		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 1	VAR lPosIdx		AS LOGICAL		OPTIONAL	DEFAULT .T.
PARAMTYPE 2	VAR lExMens		AS LOGICAL		OPTIONAL	DEFAULT .T.

If Empty(aAlias)
	Return !lRet
Endif
aEval(aAlias,{|x| IIf(FWAliasInDic(Eval(bForma01,x)),(IIf(Empty(Select(x)),dbSelectArea(x),.F.),IIf(lPosIdx,(x)->(dbSetOrder(1)),.F.)),;
	cErro += "A tabela [" + Eval(bForma01,x) + "] não foi encontrada no dicionário de dados." + CRLF)})
If !Empty(cErro)
	lRet := !lRet
	If lExMens
		Eval({|| IIf(IsBlind(),ConOut(cErro),MsgStop(cErro))})
	Endif
Endif

Return lRet

//--------------------------------------------------------------
/*/{Protheus.doc} InJob
Metodo para determinar se a rotina esta sendo executada em job

@Param : Nil

@return[L] : Ambiente de job

@author  - Pablo Gollan Carreras [RVG]
@since 31/01/2014
/*/
//--------------------------------------------------------------

Method InJob() Class rvgFun01

Return GetRemoteType() == -1 .OR. Empty(Select("SX2"))

//--------------------------------------------------------------
/*/{Protheus.doc} ListaCampos
Metodo para retornar a lista de campos a serem listados no browse
ou alguma getdados.

@Param01[C] : Alias da tabela                                        º±±
@Param02[N] : Tipo de retorno 1=String 2=Array
@Param03[L] : Incluir o campo filial para retorno
@Param04[N] : Formatao da array de retorno de dados
@Param05[A] : Lista de campos a pesquisar (FIXO)
@Param06[A] : Lista de campos para nao listar
@Param07[B] : Bloco de codigo para decisao da utilizacao de campos
@Param08[L] : Remover espacos do titulo
@Param09[L] : Remover espacos do nome do campo
@Param10[L] : Listar campos que nao sejam marcados como browse
@Param11[A] : Campos adicionais que nao estao marcados como browse
              no SX3 e que devem ser listados.
@Param12[L] : Classificar campos por ordem do SX3

@return[U] : Retorno com lista de campos como string ou array

@author  - Pablo Gollan Carreras  
@since 27/12/2013
/*/
//--------------------------------------------------------------

Method ListaCampos(cAlias,nTpRet,lIncFil,nArrFrm,aLstC,aLstCNL,bDecisaoAux,lRmEspT,lRmEspC,lLCpNBr,aLstCAd,lClasOrd) Class rvgFun01

Local uRet				:= ""
Local aAreaSX3			:= SX3->(GetArea())
Local ni				:= 0
Local nx				:= 0
Local cCpAt				:= ""
Local aEstRtArr			:= {}
Local aTMP				:= {}
Local bForma			:= {|x| Upper(AllTrim(x))}
Local nMetodo			:= 1
Local bCpOk				:= {|| (X3Uso(SX3->X3_USADO) .AND. (lLCpNBr .OR. SX3->X3_BROWSE # "N") .AND. cNivel >= SX3->X3_NIVEL .AND. ;
							Empty(aScan(aLstCNL,{|x| Eval(bForma,x) == Eval(bForma,SX3->X3_CAMPO)})) .AND. Eval(bDecisaoAux)) .OR. ;
							IIf(lIncFil,"_FILIAL" $ SX3->X3_CAMPO,.F.)}
Local aClasOrd			:= {}
Local aLstCp			:= {}
Local cTMP				:= ""
Local nPosCpId			:= 0
Local bVlExCp			:= {|x| IIf(nTpRet == 1,.F.,(cTMP := x,!Empty(aScan(uRet,{|x| Eval(bForma,IIf(Empty(nPosCpId),x,x[nPosCpId])) == ;
							Eval(bForma,cTMP)}))))}

Private bFormaRT		:= {|x| IIf(lRmEspT,AllTrim(x),x)}
Private bFormaRC		:= {|x| IIf(lRmEspC,AllTrim(x),x)}

PARAMTYPE 0		VAR cAlias			AS Character	OPTIONAL	DEFAULT ""
PARAMTYPE 1		VAR nTpRet			AS Numeric		OPTIONAL	DEFAULT 1
PARAMTYPE 2		VAR lIncFil			AS Logical		OPTIONAL 	DEFAULT .F.
PARAMTYPE 3		VAR nArrFrm			AS Numeric		OPTIONAL	DEFAULT 1
PARAMTYPE 4		VAR aLstC			AS Array		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 5		VAR aLstCNL			AS Array		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 6		VAR bDecisaoAux		AS Block		OPTIONAL	DEFAULT {|| AllwaysTrue()}
PARAMTYPE 7		VAR lRmEspT			AS Logical		OPTIONAL	DEFAULT .T.
PARAMTYPE 8		VAR lRmEspC			AS Logical		OPTIONAL	DEFAULT .F.
PARAMTYPE 9		VAR lLCpNBr			AS Logical		OPTIONAL	DEFAULT .T.
PARAMTYPE 10	VAR aLstCAd			AS Array		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 11	VAR lClasOrd		AS Logical		OPTIONAL	DEFAULT .F.

uRet := IIf(nTpRet == 1,"",Array(0))
If Empty(cAlias) .OR. !cValToChar(nTpRet) $ "1|2"
	Return uRet
Endif
//Determinar qual o metodo de validacao de campos deve ser empregado
If Empty(aLstC)
	bCpOk := {|| (X3Uso(SX3->X3_USADO) .AND. (lLCpNBr .OR. SX3->X3_BROWSE # "N") .AND. cNivel >= SX3->X3_NIVEL .AND. ;
		Empty(aScan(aLstCNL,{|x| Eval(bForma,x) == Eval(bForma,SX3->X3_CAMPO)})) .AND. Eval(bDecisaoAux)) .OR. ;
		IIf(lIncFil,"_FILIAL" $ SX3->X3_CAMPO,.F.)}
Else
	bCpOk := {|| AllwaysTrue()}
Endif
//Campos adicionais sao aceitos apenas se nao foi informado uma lista de campos fixa
If !Empty(aLstCAd) .AND. Empty(aLstC)
	aLstC := aClone(aLstCAd)
	nMetodo := 3
Else
	If !Empty(aLstC)
		nMetodo := 2
	Endif
Endif
//Definir os campos para o formato do retorno
If nTpRet == 2
	Do Case
		Case nArrFrm == 1
			nPosCpId := 2
			aEstRtArr := {	"Eval(bFormaRT,X3Descric())",;
							"Eval(bFormaRC,SX3->X3_CAMPO)"}

		//Estrutura para TCBrowse
		Case nArrFrm == 2
			nPosCpId := 2
			aEstRtArr := {	"Eval(bFormaRT,X3Titulo())",;
							"Eval(bFormaRC,SX3->X3_CAMPO)",;
							"SX3->X3_TIPO",;
							"SX3->X3_TAMANHO",;
							"SX3->X3_DECIMAL",;
							"SX3->X3_PICTURE"}

		//Nome do campo
		Case nArrFrm == 3
			nPosCpId := 0
			aEstRtArr := {	"Eval(bFormaRC,SX3->X3_CAMPO)"}

		//Estrutura para MsNewGetDados
		Case nArrFrm == 4
			nPosCpId := 2
			aEstRtArr := {	"Eval(bFormaRT,X3Titulo())",;		//01
							"Eval(bFormaRC,SX3->X3_CAMPO)",;	//02
							"SX3->X3_PICTURE",;					//03
							"SX3->X3_TAMANHO",;					//04
							"SX3->X3_DECIMAL",;					//05
							"SX3->X3_VALID",;					//06
							"SX3->X3_USADO",;					//07
							"SX3->X3_TIPO",;					//08
							"SX3->X3_F3",;						//09
							"SX3->X3_CONTEXT",;					//10
							"SX3->X3_CBOX",;					//11
							"SX3->X3_RELACAO",;					//12
							"SX3->X3_WHEN",;					//13
							"SX3->X3_VISUAL",;					//14
							"SX3->X3_VLDUSER",;					//15
							"SX3->X3_PICTVAR",;					//16
							"SX3->X3_OBRIGAT"}					//17

		Case nArrFrm == 5
			nPosCpId := 2
			aEstRtArr := {	"Eval(bFormaRT,X3Titulo())",;
							"Eval(bFormaRC,SX3->X3_CAMPO)",;
							"SX3->X3_PICTURE",;
							"SX3->X3_TAMANHO",;
							"SX3->X3_DECIMAL",;
							"SX3->X3_VALID",;
							"SX3->X3_USADO",;
							"SX3->X3_TIPO",;
							"SX3->X3_F3",;
							"SX3->X3_CONTEXT"}
		
		//Campos de estrutura de arquivo (DBSTRUCT) usado por ex. para formatacao de campos resultantes de query
		Case nArrFrm == 6
			nPosCpId := 1
			aEstRtArr := {	"Eval(bFormaRC,SX3->X3_CAMPO)",;
							"SX3->X3_TIPO",;
							"SX3->X3_TAMANHO",;
							"SX3->X3_DECIMAL"}

		//Campos de estrutura de arquivo para funcoes HTML
		Case nArrFrm == 7
			nPosCpId := 1
			aEstRtArr := {	"Eval(bFormaRC,SX3->X3_CAMPO)",;
							"SX3->X3_TAMANHO",;
							"Eval(bFormaRT,X3Titulo())",;
							"SX3->X3_PICTURE"}
	EndCase
Endif
dbSelectArea("SX3")
If cValToChar(nMetodo) $ "1|3"
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	Do While !SX3->(Eof()) .AND. Eval(bForma,SX3->X3_ARQUIVO) == Eval(bForma,cAlias)
		If Eval(bVlExCp,SX3->X3_CAMPO)
			SX3->(dbSkip())
			Loop
		Endif
		If Eval(bCpOk) .OR. !Empty(aScan(aLstCAd,{|x| AllTrim(x) == AllTrim(SX3->X3_CAMPO)})) .OR. ;
			(!Empty(aLstCAd) .AND. aLstCAd[1] == "*" .AND. Eval(bDecisaoAux))
			
			cCpAt := Eval(bFormaRC,SX3->X3_CAMPO)
			If lClasOrd
				aAdd(aClasOrd,SX3->X3_ORDEM)
			Endif
			Do Case
				Case nTpRet == 1
					aAdd(aLstCp,cCpAt)
				Otherwise
					If nArrFrm == 3
						aAdd(uRet,&(aEstRtArr[1]))
					Else
						aTMP := {}
						For ni := 1 to Len(aEstRtArr)
							aAdd(aTMP,&(aEstRtArr[ni]))
						Next ni
						aAdd(uRet,aClone(aTMP))
					Endif
			EndCase
		Endif
		SX3->(dbSkip())
	EndDo
Endif
If cValToChar(nMetodo) $ "2|3"
	SX3->(dbSetOrder(2))
	For ni := 1 to Len(aLstC)
		If Eval(bVlExCp,aLstC[ni])
			Loop
		Endif
		If SX3->(dbSeek(PadR(aLstC[ni],10)))
			If Eval(bCpOk) .OR. !Empty(aScan(aLstCAd,{|x| AllTrim(x) == AllTrim(SX3->X3_CAMPO)})) .OR. ;
				(!Empty(aLstCAd) .AND. aLstCAd[1] == "*" .AND. Eval(bDecisaoAux))
				
				cCpAt := Eval(bFormaRC,SX3->X3_CAMPO)
				If lClasOrd
					aAdd(aClasOrd,SX3->X3_ORDEM)
				Endif
				Do Case
					Case nTpRet == 1
						aAdd(aLstCp,cCpAt)
					Otherwise
						If nArrFrm == 3
							aAdd(uRet,&(aEstRtArr[1]))
						Else
							aTMP := {}
							For nx := 1 to Len(aEstRtArr)
								aAdd(aTMP,&(aEstRtArr[nx]))
							Next nx
							aAdd(uRet,aClone(aTMP))
						Endif
				EndCase
			Endif
		Endif
	Next ni
Endif
//Classificacao por ordem
If lClasOrd
	For ni := 1 to Len(aClasOrd)
		For nx := ni to Len(aClasOrd)
			If aClasOrd[ni] > aClasOrd[nx]
				cTMP := aClasOrd[ni]
				aClasOrd[ni] := aClasOrd[nx]
				aClasOrd[nx] := cTMP
				Do Case
					Case nTpRet == 1
						cTMP := aLstCp[ni]
						aLstCp[ni] := aLstCp[nx]
						aLstCp[nx] := cTMP
					Otherwise
						If ValType(uRet[ni]) == "A"
							aTMP := aClone(uRet[ni])
							uRet[ni] := aClone(uRet[nx])
							uRet[nx] := aClone(aTMP)
						Else
							cTMP := uRet[ni]
							uRet[ni] := uRet[nx]
							uRet[nx] := cTMP
						Endif
				EndCase
			Endif
		Next nx
	Next ni
Endif
//Montar string para retorno do tipo caracter
If nTpRet == 1
	(ni := 0,uRet := "",aEval(aLstCp,{|x| ++ni,uRet += x + IIf(ni < Len(aLstCp),",","")}))
Endif
RestArea(aAreaSX3)

Return uRet

//--------------------------------------------------------------
/* {Protheus.doc} GetMailConfig
Metodo para validar configuracoes de SMTP e retorna parametros 
para envio de email.

@param01[L] : Capturar email (interface)
@param02[L] : Mostrar mensagem de erro
@param03[C] : Email sugerido
@param04[C] : Titulo da rotina

@return[A] : Parametros de email

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method GetMailConfig(lCapEml,lMens,cEmlSugere,cTitRot) Class rvgFun01

Local oArea				:= FWLayer():New()
Local aCoord			:= FWGetDialogSize(oMainWnd)
Local aTamObj			:= Array(4)
Local nCoefDif			:= 1
Local aRet				:= Array(10)
Local cSMTPUsu			:= ""
Local cContaEml			:= ""
Local cEmlTo			:= ""
Local cServ				:= ""
Local nPorta			:= ""
Local cPWD				:= ""
Local cSMTPAut			:= ""
Local lTLS				:= .F.
Local lSSL				:= .F.
Local nTOUT				:= 0
Local nPos				:= 0
Local ni				:= 0
Local nTamMax			:= 150
Local cEmail			:= Space(nTamMax)
Local cTMP				:= ""
Local aLstPar			:= {"MV_RELAUSR","MV_RELACNT","MV_RELSERV","MV_RELPSW","MV_RELAUTH","MV_RELTLS","MV_RELTIME","MV_RELSSL","MV_GCPPORT"}
Local cRotina			:= ::RetFunName(.F.,.T.)
Local cEtq01			:= OemToAnsi("Digite o e-mail de destino : ")
Local nOpcA				:= 0
//Objetos graficos
Local oTela
Local oPainel01S
Local oPainel01
Local oPainel02
Local oBot01
Local oBot02

PARAMTYPE 0	VAR lCapEml		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 1	VAR lMens		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 2	VAR cEmlSugere	AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 3	VAR cTitRot		AS CHARACTER	OPTIONAL	DEFAULT "Envio de e-mail"

cSMTPUsu 	:= RTrim(SuperGetMV("MV_RELAUSR",.F.,""))
cContaEml	:= RTrim(IIf(!Empty(cTMP := SuperGetMV("MV_RELACNT",.F.,"")),cTMP,SuperGetMV("MV_RELFROM",.F.,"")))
cServ 		:= RTrim(SuperGetMV("MV_RELSERV",.F.,""))
cPWD		:= RTrim(SuperGetMV("MV_RELPSW",.F.,""))
lSMTPAut	:= SuperGetMV("MV_RELAUTH",.F.,.F.)
lTLS		:= SuperGetMV("MV_RELTLS",.F.,.F.)
lSSL		:= SuperGetMV("MV_RELSSL",.F.,.F.)
nTOUT		:= SuperGetMV("MV_RELTIME",.F.,120)
cEmlSugere	:= PadR(cEmlSugere,nTamMax)
cEmail		:= cEmlSugere
If Empty(cSMTPUsu)
	cSMTPUsu := cContaEml
Endif
//--------------------
//Validar parametros
//--------------------
If Empty(cContaEml) .OR. Empty(cServ) .OR. Empty(cPWD) .OR. Empty(cContaEml) .OR. Empty(cSMTPUsu)
	ConOut(cRotina + "Configuracao de conta de e-mail para uso de SMTP invalida.")
	ConOut(cRotina + "Parametros necessarios : ")
	For ni := 1 to Len(aLstPar)
		ConOut(cRotina + aLstPar[ni] + " - " + AllToChar(GetMV(aLstPar[ni])))
	Next ni
	If lMens
		cTMP := "Configuracao de conta de e-mail para uso de SMTP invalida." + CRLF
		cTMP += "Parametros necessarios : " + CRLF
		For ni := 1 to Len(aLstPar)
			If aLstPar[ni] == "MV_RELPSW"
				cTMP += "- " + aLstPar[ni] + " - " + Embaralha(AllTrim(AllToChar(GetMV(aLstPar[ni]))),1) + CRLF
			Else
				cTMP += "- " + aLstPar[ni] + " - " + AllTrim(AllToChar(GetMV(aLstPar[ni]))) + CRLF
			Endif
		Next ni
		MsgStop(cTMP,cRotina)
	Endif
	Return Array(0)
Endif
//------------------------------------
//Capturar de validar conta de email
//------------------------------------
If lCapEml
	If ::ApReducaoFWLayer(.T.)
		nCoefDif := 0.95
	Endif
	aCoord[3] := aCoord[3] * 0.3
	aCoord[4] := aCoord[4] * 0.6

	oTela := tDialog():New(aCoord[1],aCoord[2],aCoord[3],aCoord[4],OemToAnsi(cTitRot),,,,NOR(WS_VISIBLE,WS_POPUP),/*nClrText*/,/*nClrBack*/,,,.T.)
	
	//PAINEL CSS
	oPainel01S := tPanel():New(000,000,,oTela,,,,,,000,000)
	oPainel01S:Align := CONTROL_ALIGN_ALLCLIENT
	oPainel01S:SetCss(" QLabel { background-color: white; border-radius: 12px ; border: 2px solid gray;}")
	//PAINEIS
	oArea:Init(oPainel01S,.F.)
	oArea:AddLine("L01",100 * nCoefDif,.T.)
	oArea:AddCollumn("L01C01",080,.F.,"L01")
	oArea:AddCollumn("L01C02",020,.F.,"L01")
	oArea:AddWindow("L01C01","L01C01P01","Digite o(s) e-mail(s) desejados :",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oPainel01 := oArea:GetWinPanel("L01C01","L01C01P01","L01")
	oArea:AddWindow("L01C02","L01C02P01","Funções",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oPainel02 := oArea:GetWinPanel("L01C02","L01C02P01","L01")
	//CAMPO DIGITACAO
	::SetObjectSize(@aTamObj,001,001,-099,::nAltCont,.F.,oPainel01)
	oEmail := tGet():New(aTamObj[1],aTamObj[2],{|x| IIf(PCount() > 0,cEmail := x,cEmail)},oPainel01,aTamObj[3],aTamObj[4],"",;
		{|| AllwaysTrue()}/*Valid*/,/*FColor*/,/*BColor*/,/*font*/,,,.T.,,,/*when*/,,,{|| }/*change*/,/*Read*/,.F./*Pwd*/,,"cEmail")
	oEmail:oJump := oBot01
	//FUNCOES
	::SetObjectSize(@aTamObj,000,000,-100,::nAltBot,.T.,oPainel02)
	oBot01 := tButton():New(aTamObj[1],aTamObj[2],::cHK + "Confirmar",oPainel02,;
		{|| IIf(!Empty(cEmail) .AND. Len(cEmail) >= 6 .AND. !Empty(At("@",cEmail)),(nOpcA := 1,oTela:End()),.F.)},aTamObj[3],aTamObj[4],,/*oFont*/,,.T.,,,,/*bWhen*/)
	::SetObjectSize(@aTamObj,aTamObj[1] + ::nAltBot + ::nDistPad)
	oBot02 := tButton():New(aTamObj[1],aTamObj[2],"C" + ::cHK + "ancelar",oPainel02,{|| oTela:End()},aTamObj[3],aTamObj[4],,/*oFont*/,,.T.,,,,/*bWhen*/)

	oTela:Activate(,,,.T.,/*valid*/,,{|| oEmail:SetFocus()})

	DelClassIntf()
	If Empty(nOpcA)
		Return Array(0)
	Endif
	cEmlTo := cEmail
Else
	cEmlTo := cEmail
Endif
//Separar servidor x porta
If (nPos := RAt(":",cServ)) > 0 .AND. !Empty(Substr(cServ,nPos + 1,Len(cServ)))
	nPorta := GetDToVal(Substr(cServ,nPos + 1,Len(cServ)))
	cServ := Substr(cServ,1,nPos - 1)
Else
	nPorta := SuperGetMV("MV_GCPPORT",.F.,25)
Endif
//-------------------------
//Estrutura de retorno :
//=========================
//01 - Conta SMTP
//02 - Usuario
//03 - Senha
//04 - Servidor
//05 - Porta
//06 - Autentica SMTP
//07 - TLS
//08 - Timeout
//09 - Email destino
//10 - SSL
//-------------------------
aRet[P_EML_FROM]	:= cContaEml
aRet[P_EML_USER]	:= cSMTPUsu
aRet[P_EML_PWD]		:= cPWD
aRet[P_EML_SERV]	:= cServ
aRet[P_EML_PORT]	:= nPorta
aRet[P_EML_AUTH] 	:= lSMTPAut
aRet[P_EML_TLS]		:= lTLS
aRet[P_EML_TOUT]	:= nTOUT
aRet[P_EML_TO]		:= cEmail
aRet[P_EML_SSL]		:= lSSL

Return aRet

//--------------------------------------------------------------
/* {Protheus.doc} MailSend
Metodo para envio de email utilizando as classes tMailManager e 
tMailMessage.

@param01[L] : Conexao SSL
@param02[L] : Conexao TLS
@param03[L] : Autenticar para envio
@param04[C] : E-mail do remetente
@param05[C] : E-mail de destino
@param06[C] : E-mail com copia
@param07[C] : E-mail com copia oculta
@param08[C] : Assunto (subject)
@param09[C] : Mensagem (body)
@param10[C] : Servidor SMTP
@param11[C] : Senha da conta / usuario
@param12[C] : Porta do servidor SMTP (padrao 25)
@param13[C] : Nome do usuario (para autenticacao)
@param14[N] : Time-out
@param15[L] : Gerar arquivo EML?
@param16[L] : Mostrar mensagens de erro em tela?
@param17[L] : Tentar alternativas em falha de conexao?

@return[L] : Resultado do envio

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method MailSend(lSSL,lTLS,lAuth,cEmissor,cDest,cCC,cBCC,cAssunto,cMens,cServ,cPWD,nPorta,cUsuario,nTOUT,lGeraArq,aAnexo,lMostraMsg,lTentaAlt) Class rvgFun01

Local lRet				:= .T.
Local cPath 			:= ""
Local nPos				:= 0
Local nStatusCode 		:= 0
Local MailServer 		:= tMailManager():New()
Local MailMessage 		:= tMailMessage():New()
Local cRotina			:= ::RetFunName(.F.,.T.)
Local bMensFim			:= {|| ConOut(cRotina + "Finalizado " + Time())}
Local bProcMsg			:= {|cTexto,lMF,lOff| ConOut(cRotina + cTexto),IIf(lMostraMsg .AND. !IsBlind(),MsgStop(cTexto,cRotina),.T.),;
							IIf(ValType(lMF) == "L" .AND. lMF,Eval(bMensFim),.T.)}
Local ni				:= 0
Local cDirSep			:= IIf(IsSrvUnix(),"/","\")
Local cDirStart			:= IIf(Right(RTrim(GetSrvProfString("StartPath","")),1) == cDirSep,RTrim(GetSrvProfString("StartPath","")),RTrim(GetSrvProfString("StartPath","")) + cDirSep)
Local aAnexoT			:= {}
Local cDrive			:= ""
Local cDir				:= ""
Local cArqP				:= ""
Local cExt				:= ""
Local cArqD				:= ""
Local bTrataEml			:= {|cEndEml| StrTran(StrTran(Lower(AllTrim(cEndEml)),",",";")," ",";")}

PARAMTYPE 0		VAR lSSL		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 1		VAR lTLS		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 2		VAR lAuth		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 3		VAR cEmissor	AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 4		VAR cDest		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 5		VAR cCC			AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 6		VAR cBCC		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 7		VAR cAssunto	AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 8		VAR cMens		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 9		VAR cServ		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 10	VAR cPWD		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 11	VAR nPorta		AS NUMERIC		OPTIONAL	DEFAULT 25
PARAMTYPE 12	VAR cUsuario	AS CHARACTER	OPTIONAL	DEFAULT cEmissor
PARAMTYPE 13	VAR nTOUT		AS NUMERIC		OPTIONAL	DEFAULT 30
PARAMTYPE 14	VAR lGeraArq	AS LOGICAL		OPTIONAL	DEFAULT .T.
PARAMTYPE 15	VAR aAnexo		AS ARRAY		OPTIONAL	DEFAULT Array(0)
PARAMTYPE 16	VAR lMostraMsg	AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 17	VAR lTentaAlt	AS LOGICAL		OPTIONAL	DEFAULT .F.

ConOut(cRotina + "Iniciando " + Time())
If Empty(cEmissor) .OR. Empty(cDest) .OR. Empty(cServ) .OR. Empty(cPWD)
	Eval(bProcMsg,"Falha no envio da mensagem SMTP por inconsistencia nos parametros.",.T.)
	Return !lRet
Endif
ConOut(cRotina + "Servidor : " + cServ)
ConOut(cRotina + "Usuario : " + cUsuario)
ConOut(cRotina + "Senha : " + cPWD)
ConOut(cRotina + "Porta : " + AllTrim(AllToChar(nPorta)))
ConOut(cRotina + "TLS : " + IIf(lTLS,"S","N"))
ConOut(cRotina + "SSL : " + IIf(lSSL,"S","N"))
If lGeraArq
	cPath	:= GetSrvProfString("RootPath","")
	cPath 	+= IIf(!(Left(cPath,1) == cDirSep),cDirSep,"")
Endif
//Redefine a chave Protocol com o valor POP3 na seção Mail
WritePProString("Mail","Protocol","POP3",GetSrvIniName())
//------------------------------
//Define o servidor de e-mails
//------------------------------
If lSSL
	MailServer:SetUseSSL(.T.)
ElseIf lTLS
	MailServer:SetUseTLS(.T.)
Endif
nStatusCode := MailServer:Init("",cServ,cUsuario,cPWD,0,nPorta)
If nStatusCode # 0
	Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
	Return !lRet
Endif
MailServer:SetSMTPTimeout(nTOUT)
//-----------------------------------
//Conecta com o servidor de e-mails
//-----------------------------------
ConOut(cRotina + "Tentando conexao usuario " + cUsuario)
nStatusCode := MailServer:SMTPConnect()
If nStatusCode # 0
	ConOut(cRotina + MailServer:GetErrorString(nStatusCode))
	//Desconectar
	MailServer:SMTPDisconnect()
	//Tratamento de tentativas alternativas de conexao em caso de falha
	If lTentaAlt
		If lSSL
			//Se o SSL estiver ativo, tentar a conexao sem SSL
			MailServer:SetUseSSL(.F.)
			nStatusCode := MailServer:SMTPConnect()
		Endif
		If lTLS
			//Se o TLS estiver ativo, tentar a conexao sem SSL
			MailServer:SetUseSSL(.F.)
			nStatusCode := MailServer:SMTPConnect()
		Endif
		//Se o usuario possuir @, tentar conectar sem
		If nStatusCode # 0
			If (nPos := At("@",cUsuario)) > 0
				cUsuario := Substr(cUsuario,1,nPos - 1)
				nStatusCode := MailServer:Init("",cServ,cUsuario,cPWD,,nPorta)
				If nStatusCode # 0
					Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
					Return !lRet
				Endif
				ConOut(cRotina + "Tentando conexao usuario " + cUsuario)
				nStatusCode := MailServer:SMTPConnect()
			Else
				cUsuario := cEmissor
				nStatusCode := MailServer:Init("",cServ,cUsuario,cPWD,,nPorta)
				If nStatusCode # 0
					Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
					Return !lRet
				Endif
				ConOut(cRotina + "Tentando conexao usuario " + cUsuario)
				nStatusCode := MailServer:SMTPConnect()
			Endif
		Endif
	Endif
	If nStatusCode # 0
		Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
		//Desconectar
		MailServer:SMTPDisconnect()
		If lGeraArq
			MailMessage:Clear()
			MailMessage:cFrom		:= cEmissor
			MailMessage:cTo			:= Eval(bTrataEml,cDest)
			MailMessage:cCC			:= Eval(bTrataEml,cCC)
			MailMessage:cBcc		:= Eval(bTrataEml,cBCC)
			MailMessage:cSubject	:= cAssunto
			MailMessage:cBody		:= cMens
			MailMessage:Save(cPath + "mensagem.eml")
		Endif
		Return !lRet
	Endif
Endif
//O servidor de e-mails requer autenticação
If lAuth
	nStatusCode := MailServer:SMTPAuth(cUsuario,cPWD)
	//Se o usuario possuir @, tentar conectar sem
	If nStatusCode # 0
		If (nPos := At("@",cUsuario)) > 0
			cUsuario := Substr(cUsuario,1,nPos - 1)
			nStatusCode := MailServer:Init("",cServ,cUsuario,cPWD,,nPorta)
			If nStatusCode # 0
				Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
				Return !lRet
			Endif
			ConOut(cRotina + "Tentando conexao usuario " + cUsuario)
			If (nStatusCode := MailServer:SMTPConnect()) == 0
				nStatusCode := MailServer:SMTPAuth(cUsuario,cPWD)
			Else
				Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
			Endif
		Else
			cUsuario := cEmissor
			nStatusCode := MailServer:Init("",cServ,cUsuario,cPWD,,nPorta)
			If nStatusCode # 0
				Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
				Return !lRet
			Endif
			ConOut(cRotina + "Tentando conexao usuario " + cUsuario)
			If (nStatusCode := MailServer:SMTPConnect()) == 0
				nStatusCode := MailServer:SMTPAuth(cUsuario,cPWD)
			Else
				Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
			Endif
		Endif
	Endif
	If nStatusCode # 0
		Eval(bProcMsg,MailServer:GetErrorString(nStatusCode),.T.)
		//Desconectar
		MailServer:SMTPDisconnect()
		Return !lRet
  	Endif
Endif
MailMessage:Clear()
MailMessage:cFrom		:= cEmissor	//Conta SMTP
MailMessage:cTo			:= Eval(bTrataEml,cDest)
MailMessage:cCC			:= Eval(bTrataEml,cCC)
MailMessage:cBcc		:= Eval(bTrataEml,cBCC)
MailMessage:cSubject	:= cAssunto
MailMessage:cBody		:= cMens
//-------
//Anexo
//-------
For ni := 1 to Len(aAnexo)
	If ValType(aAnexo[ni]) == "C" .AND. File(aAnexo[ni])
		//Caso o arquivo nao esteja no servidor, copiar para anexar e excluir apos o envio da mensagem
		If Empty(At(":",aAnexo[ni]))
			If MailMessage:AttachFile(aAnexo[ni]) < 0
				Eval(bProcMsg,"Erro ao tentar anexar o arquivo [" + aAnexo[ni] + "]")
				//Desconectar
				MailServer:SMTPDisconnect()
				Return !lRet
			Endif
		Else
			//Identificar nome e extensao do arquivo
			SplitPath(aAnexo[ni],@cDrive,@cDir,@cArqP,@cExt)
			cArqD := cDirStart + cArqP + cExt
			//Copiar para o servidor e validar arquivo
			If CpyT2S(aAnexo[ni],cDirStart,.F.) .AND. File(cArqD)
				aAdd(aAnexoT,cArqD)
				//Anexar o arquivo temporario
				If MailMessage:AttachFile(cArqD) < 0
					Eval(bProcMsg,"Erro ao tentar anexar o arquivo [" + cArqD + "]")
					aEval(aAnexoT,{|x| IIf(fErase(x) == 0,.T.,Eval(bProcMsg,fError()))})
					//Desconectar
					MailServer:SMTPDisconnect()
					Return !lRet
				Endif
			Else
				Eval(bProcMsg,"Erro ao tentar anexar o arquivo [" + aAnexo[ni] + "] cópia mal sucedida para [" + cDirStart + cArqP + cExt + "]")
				aEval(aAnexoT,{|x| IIf(fErase(x) == 0,.T.,Eval(bProcMsg,fError()))})
				//Desconectar
				MailServer:SMTPDisconnect()
				Return !lRet
			Endif
		Endif
	Endif
Next ni
//--------
//Salvar
//--------
If lGeraArq
	MailMessage:Save(IIf(lSSL,cPath,cPath) + "mensagem.eml")
Endif
//--------
//Enviar  
//--------
nStatusCode := MailMessage:Send(MailServer)
If nStatusCode # 0
	Eval(bProcMsg,MailServer:GetErrorString(nStatusCode))
	lRet := !lRet
Else
	Eval(bProcMsg,"E-mail enviado com sucesso!")
Endif
//-------------
//Desconectar
//-------------
MailServer:SMTPDisconnect()
//-----------------------------
//Apagar arquivos temporarios
//-----------------------------
aEval(aAnexoT,{|x| IIf(fErase(x) == 0,.T.,Eval(bProcMsg,fError()))})
Eval(bMensFim)

Return lRet

//--------------------------------------------------------------
/* {Protheus.doc} HTMxHead
Metodo para criar um cabecalho em padrao HTML

@param01[C] : Titulo do arquivo
@param02[C] : Link do logo da empresa ou o desejado
@param03[L] : Imprimir dados da empresa
@param04[L] : Imprimir linha de quebra

@return[C] : Cabecalho em formato HTML

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method HTMxHead(cTituloM,cLinkLOGO,lEmpresa,lQuebra) Class rvgFun01

Local cCabec			:= ""

PARAMTYPE 0	VAR cTituloM	AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 1	VAR cLinkLOGO	AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 2	VAR lEmpresa	AS LOGICAL		OPTIONAL	DEFAULT .T.
PARAMTYPE 3	VAR lQuebra		AS LOGICAL		OPTIONAL	DEFAULT .T.

cCabec := '<html>' + CRLF
cCabec += '<head>' + CRLF
cCabec += '<title>' + Upper(cTituloM) + '</title>' + CRLF
cCabec += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
cCabec += '<style type="text/css">' + CRLF
cCabec += 'body,td,th {font-family: Arial, Helvetica, sans-serif}' + CRLF
cCabec += '</style>' + CRLF
cCabec += '</head>' + CRLF
//FORM
cCabec += '<body>' + CRLF
cCabec += ' <form name="FORM">' + CRLF
cCabec += '  <div align="center">' + CRLF
cCabec += '   <table background="" border="0" cellpadding="0" cellspacing="0" width="100%">' + CRLF
cCabec += '    <tbody>' + CRLF
cCabec += '     <tr>' + CRLF
cCabec += '      <td height="84">' + CRLF
//---------------------
//CABECALHO PRINCIPAL
//---------------------
cCabec += '       <table border="0" cellpadding="0" cellspacing="0" width="100%">' + CRLF
cCabec += '        <tbody>' + CRLF
cCabec += '         <tr>' + CRLF
cCabec += '          <td height="16" width="33%">' + CRLF
cCabec += '           <div align="left">' + IIf(!Empty(cLinkLOGO),'<img src="' + RTrim(cLinkLOGO) + '" height="65" width="170">','') + CRLF
cCabec += '           </div>' + CRLF
cCabec += '          </td>' + CRLF
cCabec += '          <td height="16" width="33%">' + CRLF
cCabec += '           <div align="center">'
cCabec += '            <font face="Arial, Helvetica, sans-serif" size="4">' + CRLF
cCabec += '             <b>' + CRLF
cCabec += '             ' + cTituloM + CRLF
cCabec += '             </b>' + CRLF
cCabec += '            </font>' + CRLF
cCabec += '           </div>' + CRLF
cCabec += '          </td>' + CRLF
cCabec += '          <td height="16" valign="top" width="34%">' + CRLF
cCabec += '           <br>' + CRLF
cCabec += '          </td>' + CRLF
cCabec += '         </tr>' + CRLF
//------------------
//DADOS DA EMPRESA
//------------------
If lEmpresa
	cCabec += '         <tr>' + CRLF
	cCabec += '          <td colspan="2" height="41">' + CRLF
	cCabec += '           <b>' + CRLF
	cCabec += '            <font face="Arial, Helvetica, sans-serif" size="1">' + CRLF
	cCabec += '             ' + SM0->M0_NOMECOM + CRLF
	cCabec += '             <br>' + CRLF
	cCabec += '            </font>' + CRLF
	cCabec += '           </b>' + CRLF
	cCabec += '           <font face="Arial, Helvetica, sans-serif" size="1">' + CRLF
	cCabec += '            ' + "CNPJ : " + SM0->M0_CGC + CRLF
	cCabec += '            <br>' + CRLF
	cCabec += '            ' + SM0->M0_ENDENT + CRLF
	cCabec += '            <br>' + CRLF
	cCabec += "            CEP: " + RTrim(SM0->M0_CEPENT) + " - Tel. " + RTrim(SM0->M0_TEL) + CRLF
	cCabec += '            <br>' + CRLF
	cCabec += '           </font>' + CRLF
	cCabec += '          </td>' + CRLF
	cCabec += '          <td height="41" valign="top" width="34%">' + CRLF
	cCabec += '           <br>' + CRLF
	cCabec += '          </td>' + CRLF
	cCabec += '         </tr>' + CRLF
Endif
cCabec += '        </tbody>' + CRLF
cCabec += '       </table>' + CRLF
cCabec += '      </td>' + CRLF
cCabec += '     </tr>' + CRLF
//-----------------
//QUEBRA DE LINHA
//-----------------
If lQuebra
	cCabec += '     <tr>' + CRLF
	cCabec += '      <td>' + CRLF
	cCabec += '       <hr noshade="noshade">' + CRLF
	cCabec += '      </td>' + CRLF
	cCabec += '     </tr>' + CRLF
Endif
cCabec += '    </tbody>' + CRLF
cCabec += '   </table>' + CRLF
cCabec += '  </div>' + CRLF

Return cCabec

//--------------------------------------------------------------
/* {Protheus.doc} HTMxBody
Metodo para montar cabecalho e conteudo de uma lista de itens 
em padrao HTML.

@param01[A] : Lista de campos, com a seguinte estrutura :
              [1] Nome do campo
              [2] Tamanho do campo
              [3] Titulo
              [4] Picture de formatacao de dados
@param02[A] : Array com a lista de valores
@param03[3] : Titulo da lista
@param04[4] : Rodape da lista (HTML)
@param05[5] : Quebra de pagina apos impressao

@return[C] : Bloco de itens em formato HTML

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method HTMxBody(aLstC,aLstVal,cTitulo,cRodape,lQuebra,lImpHead,nRecuo) Class rvgFun01

Local cMens				:= ""
Local nEspTotH			:= 0
Local ni				:= 0
Local nx				:= 0
Local nz				:= 0
Local cMasc				:= ""
Local cAliTD			:= ""
Local nCasaDec			:= 0
Local lRecuo			:= .F.
Local nEspaco			:= 0

PARAMTYPE 0	VAR aLstC		AS ARRAY
PARAMTYPE 1	VAR aLstVal		AS ARRAY
PARAMTYPE 2	VAR cTitulo		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 3	VAR cRodape		AS CHARACTER	OPTIONAL	DEFAULT ""
PARAMTYPE 4	VAR lQuebra		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 5	VAR lImpHead	AS LOGICAL		OPTIONAL	DEFAULT .T.
PARAMTYPE 6	VAR nRecuo		AS NUMERIC		OPTIONAL	DEFAULT 0

If Len(aLstC) # Len(aLstVal[1])
	Return cMens
Endif
lRecuo := !Empty(nRecuo)
If !Empty(cTitulo)
	cMens += '<table style="width: 100%;" nowrap="1" background="" border="0" bordercolor="#cccccc" cellpadding="0" cellspacing="0">' + CRLF
	cMens += ' <tr>' + CRLF
	cMens += '  <td>' + CRLF
	cMens += '   <font face="Arial, Helvetica, sans-serif" size="4"><b>' + cTitulo + '</b></font>' + CRLF
	cMens += '  </td>' + CRLF
	cMens += ' </tr>' + CRLF
	cMens += '</table>' + CRLF + CRLF
Endif
//RECUO
If lRecuo
	cMens += '<table border="0" width="100%" cellpadding="10">' + CRLF
	cMens += ' <tr>' + CRLF
	cMens += '  <td width="' + cValToChar(nRecuo) + '%" valign="top">' + CRLF
	cMens += '  </td>' + CRLF
	cMens += '  <td width="' + cValToChar(100 - nRecuo) + '%" valign="top">' + CRLF
	nEspaco := 4
Endif
cMens += Space(nEspaco) + '<table style="width: 100%;" nowrap="1" background="" border="0" bordercolor="#cccccc" cellpadding="0" cellspacing="0">' + CRLF
If lImpHead
	cMens += Space(nEspaco) + ' <thead>' + CRLF
	cMens += Space(nEspaco) + '  <tr bgcolor="#cccccc">' + CRLF
	//Levantar o espacamento total das colunas
	nEspTotH := 0
	aEval(aLstC,{|x| nEspTotH += x[POS_HT_TAM]})
	For ni := 1 to Len(aLstC)
		cMens += Space(nEspaco) + '   <td height="' + cValToChar(Int((aLstC[ni][POS_HT_TAM] / nEspTotH) * 100)) + '%">' + CRLF
		cMens += Space(nEspaco) + '    <div align="left">' + CRLF
		cMens += Space(nEspaco) + '     <b>' + CRLF
		cMens += Space(nEspaco) + '      <font face="Arial, Helvetica, sans-serif" size="1">' + CRLF
		cMens += Space(nEspaco) + '       ' + Capital(AllTrim(aLstC[ni][POS_HT_TIT])) + CRLF
		cMens += Space(nEspaco) + '      </font>' + CRLF
		cMens += Space(nEspaco) + '     </b>' + CRLF
		cMens += Space(nEspaco) + '    </div>' + CRLF
		cMens += Space(nEspaco) + '   </td>' + CRLF
	Next ni
	cMens += Space(nEspaco) + '  </tr>' + CRLF
	cMens += Space(nEspaco) + ' </thead>' + CRLF
Endif
//ITENS
For nx := 1 to Len(aLstVal)
	cMens += Space(nEspaco) + ' <tr>' + CRLF
	For ni := 1 to Len(aLstC)
		cCmpAt := aLstC[ni][POS_HT_CMP]
		If Empty(cMasc := aLstC[ni][POS_HT_PIC])
			If Empty(cMasc := GetSX3Cache(cCmpAt,"X3_PICTURE"))
				cMasc := "@!"
			Endif
		Endif
		//Alinhamento da celula
		Do Case
			Case ValType(aLstVal[nx][ni]) == "N"
				nCasaDec := GetSX3Cache(cCmpAt,"X3_DECIMAL")
				If Empty(nCasaDec) .AND. !Empty(RAt(".",cMasc))
					nCasaDec := Len(RTrim(Substr(cMasc,RAt(".",cMasc) + 1)))
				Else
					If ValType(nCasaDec) # "N"
						nCasaDec := 0
					Endif
				Endif
				//Caso os campos possuam casas decimais alinhar a direita
				If nCasaDec > 0
					cAliTD := "Right"
				Else
					cAliTD := "Center"
				Endif
			Case ValType(aLstVal[nx][ni]) == "D"
				cAliTD := "Center"
			Otherwise
				cAliTD := "Left"
		EndCase
		cMens += Space(nEspaco) + '  <td align="' + cAliTD + '">&nbsp;' + CRLF
		cMens += Space(nEspaco) + '   <font face="Verdana" size="1">' + CRLF
		cMens += Space(nEspaco) + '    ' + AllTrim(Transform(aLstVal[nx][ni],cMasc)) + CRLF
		cMens += Space(nEspaco) + '   </font>' + CRLF
		cMens += Space(nEspaco) + '  </td>' + CRLF
	Next ni
	cMens += Space(nEspaco) + ' </tr>' + CRLF
Next nx
cMens += Space(nEspaco) + '</table>' + CRLF
//RECUO
If lRecuo
	cMens += '  </td>' + CRLF
	cMens += ' </tr>' + CRLF
	cMens += '</table>' + CRLF
Endif
//QUEBRA
If lQuebra
	cMens += Space(nEspaco) + '<hr noshade="noshade">' + CRLF
Endif
//RODAPE
If !Empty(cRodape)
	If !lQuebra
		cMens += "<p>" + CRLF
	Endif
	cMens += '<table style="width: 100%;" nowrap="1" background="" border="0" bordercolor="#cccccc" cellpadding="0" cellspacing="0">' + CRLF
	cMens += ' <tr>' + CRLF
	cMens += '  <td>' + CRLF
	cMens += '   <font face="Arial, Helvetica, sans-serif" size="1">' + CRLF
	cMens += '    ' + cRodape + CRLF
	cMens += '   </font>' + CRLF
	cMens += '   <p>' + CRLF
	cMens += '  </td>' + CRLF
	cMens += ' </tr>'
	cMens += '</table>'
Endif

Return cMens

//--------------------------------------------------------------
/* {Protheus.doc} HTMxFooter
Metodo para montar rodape do arquivo HTML e deve trabalhar com 
os outros componentes do grupo HTML.

@param : Nil

@return[C] : Cabecalho em formato HTML

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method HTMxFooter() Class rvgFun01

Local cRodape 			:= ""

cRodape += '</form>' + CRLF
cRodape += '</body>' + CRLF
cRodape += '</html>' + CRLF

Return cRodape

//--------------------------------------------------------------
/* {Protheus.doc} HTMxMessage
Metodo para montar rodape do arquivo HTML e deve trabalhar com 
os outros componentes do grupo HTML.

@param01[C] : Titulo
@param02[C] : Link do logo da empresa ou o desejado
@param03[L] : Imprimir dados da empresa
@param04[C] : Mensagem do corpo do arquivo
@param05[A] : Array com as listas de registros a imprimir
              Estrutura por elemento :
              [1] Lista de campos (cabecalho)
              [2] Lista de valores
              [3] Titulo da lista
              [4] Impressao para rodape

@return[C] : Arquivo em formato HTML

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method HTMxMessage(cTitulo,cLinkLOGO,lInfoEmp,cMens,aLstREG) Class rvgFun01

Local cHTML				:= ""
Local ni				:= 0

PARAMTYPE 0	VAR cTitulo		AS Character	OPTIONAL	DEFAULT ""
PARAMTYPE 1	VAR cLinkLOGO	AS Character	OPTIONAL	DEFAULT GetMV("MV_XLOGURL",.F.,"")
PARAMTYPE 2	VAR lInfoEmp	AS Logical		OPTIONAL	DEFAULT .F.
PARAMTYPE 3	VAR cMens		AS Character	OPTIONAL	DEFAULT ""
PARAMTYPE 4	VAR aLstREG		AS Array		OPTIONAL	DEFAULT Array(0)

//Montar cabecalho
cHTML := ::HTMxHead(cTitulo,cLinkLOGO,lInfoEmp,.T.)
//Montar bloco de mensagem
If !Empty(cMens)
	cMens := StrTran(cMens,CHR(10),"")
	For ni := 1 to Len(cMens)
		//Formatar quebra de linha
		If Asc(Substr(cMens,ni,1)) == 13
			If ni < Len(cMens) .AND. Asc(Substr(cMens,ni + 1,1)) == 13
				cHTML += "<p>"
				ni++
			Else
				cHTML += "<br>"
			Endif
			Loop
		Endif
		cHTML += Substr(cMens,ni,1)
	Next ni
Endif
//Imprimir listas de registros
For ni := 1 to Len(aLstREG)
	If ValType(aLstREG[ni]) # "A" .OR. Len(aLstREG[ni]) # 4 .OR. ValType(aLstREG[ni][1]) # "A" .OR. ValType(aLstREG[ni][2]) # "A"
		Loop
	Endif
	cHTML += ::HTMxBody(aLstREG[ni][1],aLstREG[ni][2],aLstREG[ni][3],aLstREG[ni][4],.T.)
Next ni
//Rodape do arquivo
cHTML += ::HTMxFooter()

Return cHTML

//--------------------------------------------------------------
/* {Protheus.doc} LastAlias
Metodo para retornar o ultimo alias aberto na workarea

@param01[L] : Considerar apenas tabelas temporarias

@return[C] : Alias

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method LastAlias(lTMP) Class rvgFun01

Local cRet				:= ""
Local ni				:= 0
Local cAliasAt			:= ""

PARAMTYPE 0	VAR lTMP		AS LOGICAL		OPTIONAL	DEFAULT .F.

For ni := 511 to 1 Step -1
	If !Empty(cAliasAt := Alias(ni))
		If lTMP
			If !AliasInDic(StrTran(cAliasAt,"_",""))
				cRet := cAliasAt
				Exit
			Endif
		Else
			cRet := cAliasAt
			Exit
		Endif
	Endif
Next ni

Return cRet

//--------------------------------------------------------------
/* {Protheus.doc} GetStartPath
Metodo para retornar o startpath do ambiente em utilizacao.

@param01[L] : Determina se o separador de diretorios deve ser 
              agregado no final do path
@param02[C] : Subdiretorio informado para ser agregado

@return[C] : Caminho

@author Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision 
*/
//--------------------------------------------------------------

Method GetStartPath(lSepFin,cSubDir) Class rvgFun01

Local cRet				:= ""
Local cDirSep			:= IIf(IsSrvUnix(),"/","\")
Local cEnvServ			:= GetEnvServer()
Local cIniFile			:= GetADV97()
Local cSPIni			:= RTrim(GetPvProfString(cEnvServ,"StartPath","",cIniFile))

PARAMTYPE 0	VAR lSepFin		AS LOGICAL		OPTIONAL	DEFAULT .F.
PARAMTYPE 1	VAR cSubDir		AS CHARACTER	OPTIONAL	DEFAULT ""

cRet := IIf(Right(cSPIni,1) == cDirSep,Substr(cSPIni,1,RAt(cDirSep,cSPIni) - 1),cSPIni)
If !Empty(cSubDir)
	cSubDir := AllTrim(cSubDir)
	If IsSrvUnix()
		If !Empty(At("\",cSubDir))
			cSubDir := StrTran(cSubDir,"\","/")
		Endif
	Else
		If !Empty(At("/",cSubDir))
			cSubDir := StrTran(cSubDir,"/","\")
		Endif
	Endif
	cSubDir := IIf(Right(cSubDir,1) == cDirSep,Substr(cSubDir,1,RAt(cDirSep,cSubDir) - 1),cSubDir)
	cSubDir := IIf(Substr(cSubDir,1,1) == cDirSep,Substr(cSubDir,2,Len(cSubDir)),cSubDir)
	cRet += cDirSep + cSubDir
Endif
cRet += IIf(lSepFin,cDirSep,"")

Return cRet
