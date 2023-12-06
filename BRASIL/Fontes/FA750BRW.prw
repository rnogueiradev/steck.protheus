#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA750BRW    ºAutor  ³Cristiano Pereira  º Data ³  01/15/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adicionar opções no aRotina das funçoes a pagar             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA750BRW()

	Local aRotina     := {}

	aAdd(aRotina, {'Manutenção PA',"U_STKF750A()",0,1})
	aAdd(aRotina, { "Editar Codigo de Barras","U_PSTFIN01" , 0 ,2})
	aAdd(aRotina, { "Anexos ","U_FIN004C(.T.)" , 0 ,2})
	aAdd(aRotina, { "Editar Titulo PA ","U_PSTFIN02" , 0 ,2})

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STKF750A  ºAutor  ³Cristiano Pereira   º Data ³  01/21/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutenção do titulo a pagar                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STKF750A()

	Private _cMens1 := SE2->E2_NUM+"  "+SE2->E2_TIPO
	Private _cMens2 := SE2->E2_NOMFOR
	Private _cMens3 := SE2->E2_PARCELA
	Private _cMens4 := SE2->E2_NATUREZ
	Private _nValor := SE2->E2_VALOR
	Private _dData  := SE2->E2_VENCTO
	Private _dDataN := Ctod(Space(8))
	Private oDlg1
	Private oComb


	If SE2->E2_TIPO<>"PA" .And. !Empty(SE2->E2_TIPO)

		MsgInfo("Manutenção disponível somente para PA!!!")
		returN
	ElseIf SE2->E2_SALDO == SE2->E2_VALOR

		DEFINE MSDIALOG oDlg1 TITLE "Manutenção de títulos a pagar" FROM 0,0 TO 260,700 PIXEL
		@ 10, 10 SAY "Título" PIXEL
		@ 10, 70 MSGET _cMens1 OF oDlg1 PIXEL when .F.
		@ 23, 10 SAY "Fornecedor" PIXEL
		@ 23, 70 MSGET _cMens2 OF oDlg1 PIXEL when .F.
		@ 36, 10 SAY "Parcela" PIXEL
		@ 36, 70 MSGET _cMens3 OF oDlg1 PIXEL when .F.
		@ 49, 10 SAY "Natureza" PIXEL
		@ 49, 70 MSGET _cMens4 OF oDlg1 PIXEL when .F.
		@ 65, 10 SAY "Vencto Atual" PIXEL
		@ 65, 70 MSGET _dData  OF oDlg1 PIXEL when .F.



		@ 80, 10 SAY "Valor" PIXEL
		@ 80, 70 MSGET _nValor Picture "@E 9,999,999,999,999.99" OF oDlg1 PIXEL when .F.

		@ 94, 10 SAY "Novo Vencto" PIXEL
		@ 94, 70 MSGET _dDataN  OF oDlg1 PIXEL when .T.




		@ 113, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( fGrava(), oDlg1:End() )
		@ 113, 130 BUTTON "Sair" SIZE 40,10 PIXEL ACTION (  oDlg1:End()   )

		ACTIVATE DIALOG oDlg1 CENTERED

	Else

		MsgInfo("Títulos com baixa, não poderá sofrer alteração!!!")
		return
	EndIf

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGrava()  ºAutor  ³Cristiano Pereira º Data ³  01/21/18     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para a gravacao dos valores                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGrava()




	If reclock("SE2",.F.)

		SE2->E2_EMISSAO:= _dDataN
		SE2->E2_VENCTO:= _dDataN
		SE2->E2_VENCREA:= _dDataN
		SE2->E2_EMIS1:= _dDataN
		SE2->E2_VENCORI:= _dDataN
		SE2->E2_SDACRES:= 0
		SE2->E2_SDDECRE:= 0
		SE2->E2_TIPO:="PA"
		MsUnlock()
	Endif

	DbSelectArea("SE5")
	DbSetOrder(7)
	If DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		If reclock("SE5",.F.)
			SE5->E5_DATA:= _dDataN
			SE5->E5_DTDIGIT:= _dDataN
			SE5->E5_DTDISPO:= _dDataN
            SE5->E5_TIPO:="PA"
			MsUnlock()
		EndIf
	Endif

	DbSelectArea("FK5")
	DbSetOrder(1)
	If DbSeek(xFilial("FK5")+SE5->E5_IDORIG)
		If reclock("FK5",.F.)
			FK5->FK5_DATA:= _dDataN
			FK5->FK5_DTCONC:= _dDataN
			FK5->FK5_DTDISP:= _dDataN
            FK5->FK5_TPDOC := "PA"
			MsUnlock()
		EndIf
	Endif
	MsgInfo("Alteração realizada com sucesso!!!")

return

/*/{Protheus.doc} FA750BRW

Ponto de Entrada para limpar o Codigo de Barras do Titulo.

@type function
@author Everson Santana
@since 07/02/18
@version Protheus 12 - Financeiro Contas a Pagar

@history , ,

/*/

User Function PSTFIN01()

	Local _cVersao := '20180209'
	Local _cBarra  := SE2->E2_CODBAR
	Local _nOpc	 := 0
	Local _oDlg
	Local _cUser	 := RetCodUsr()
	Local _lEdtBar := .T.
	Private _oSay
	Private _oTGet
	Private _oTButCon
	Private _oTButFec

	If Substring(_cUser,1,6) $ GETMV("ST_EDTBAR")
		_lEdtBar := .F.
	EndIf

	If _lEdtBar
		MsgAlert("Seu usuário não tem permissão para utilizar esta rotina!!!", "Atenção")
		Return
	EndIf

	DEFINE MSDIALOG _oDlg TITLE "Editar Codigo de Barras - "+_cVersao FROM 000, 000  TO 150, 330 COLORS 0, 16777215 PIXEL

	_oSay	:= TSay():New(010,010,{||'Codigo de Barras:'},_oDlg,,,,,,.T.,,,060,20)
	_oTGet  := TGet():New(020,010,{| u | if( pCount() > 0,_cBarra := u, _cBarra ) },_oDlg,150,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_cBarra,,,, )

	_oTButCon:= TButton():New( 050, 070, "Confirmar" ,_oDlg,{|| _nOpc := 1,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButFec:= TButton():New( 050, 120, "Fechar",_oDlg,{|| _nOpc := 0,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc == 1

		DbSelectArea("SE2")
		RecLock("SE2",.f.)
		SE2->E2_CODBAR := _cBarra
		MsUnLock("SE2")

	EndIf

Return

User Function PSTFIN02()

	Local nOpca 	:= 0
	Local _cQuery	:= ""
	Local _cAlias	:= "QRY"
	Private cBancoAdt 	:= Space(TamSX3("A6_COD")[1])
	Private cAgenciaAdt := Space(TamSX3("A6_AGENCIA")[1])
	Private cNumCon		:= Space(TamSX3("A6_NUMCON")[1])

	Private cPictHist
	Private nMoedAux	:= 1

	If !Alltrim(SE2->E2_TIPO) $ "PA"

		MsgAlert("Está rotina só pode ser utilizada para títulos do tipo PA.","Atenção  - FA750BRW ")
		Return()

	EndIf

	_cQuery := " SELECT E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_FORNECE,E5_LOJA,E5_BANCO,E5_AGENCIA,E5_CONTA "
	_cQuery += " FROM "+RetSqlName("SE5")+" SE5 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND E5_FILIAL = '"+SE2->E2_FILIAL+"' "
	_cQuery += " AND E5_PREFIXO = '"+SE2->E2_PREFIXO+" ' "
	_cQuery += " AND E5_NUMERO = '"+SE2->E2_NUM+"' "
	_cQuery += " AND E5_PARCELA = '"+SE2->E2_PARCELA+" ' "
	_cQuery += " AND E5_TIPO = '"+SE2->E2_TIPO+"' "
	_cQuery += " AND E5_FORNECE = '"+SE2->E2_FORNECE+"' "
	_cQuery += " AND E5_LOJA = '"+SE2->E2_LOJA+"' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If Select(_cAlias) > 0

		cBancoAdt	:= PADR((_cAlias)->E5_BANCO,TamSX3("E5_BANCO")[1])
		cAgenciaAdt := PADR((_cAlias)->E5_AGENCIA,TamSX3("E5_AGENCIA")[1])
		cNumCon		:= PADR((_cAlias)->E5_CONTA,TamSX3("E5_CONTA")[1])

	Else

		MsgAlert("Título não Localizado nos Movimentos Bancários.","Atenção  - FA750BRW ")
		Return()

	Endif
	//---------------------------------------------------------------
	// Mostra Get do Banco de Entrada
	//---------------------------------------------------------------
	nOpca := 0
	DEFINE MSDIALOG oDlg FROM 10, 5 TO 20, 60 TITLE OemToAnsi("Local de Entrada") //"Local de Entrada"
	@	.3,1 TO 04.0,26 OF oDlg
	// BANCO
	@	1.0,2 	Say OemToAnsi("Banco : ") //"Banco : "

	@	1.0,8  	MSGET oBcoAdt 			VAR cBancoAdt F3 "SA6" 	//Valid Iif(SA6->A6_BLOCKED <> '2', MsgAlert("Conta Bloqueada para Movimentações."),.T.) //CarregaSa6(@cBancoAdt,,,,,,, @nMoedAux ) HASBUTTON //.And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)

	// AGENCIA
	@	2.0,2 	Say OemToAnsi("Agência : ") //"Agência : "
	@	2.0,8 	MSGET cAgenciaAdt 								//Valid CarregaSa6(@cBancoAdt,@cAgenciaAdt) .And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)
	// CONTA
	@	3.0,2 	Say OemToAnsi("Conta : ") //"Conta : "
	@	3.0,8 	MSGET cNumCon 									//Valid If(CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.),FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt),oBcoAdt:SetFocus())

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbGotop()
	DbSeek(xFilial("SA6")+cBancoAdt+cAgenciaAdt+cNumCon)

	bAction := {||	nOpca:=1,Iif(!Empty(cBancoAdt) , Iif(SA6->A6_BLOCKED <> '2', MsgAlert("Conta Bloqueada para Movimentações."),oDlg:End()) ,nOpca:=0)}

	DEFINE SBUTTON FROM 60,180.1 TYPE 1 ACTION ( Eval(bAction) ) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

	IF nOpca != 0

		_cQuery := " "
		_cQuery += " UPDATE "+RetSqlName("SE5")+" SET E5_BANCO = '"+cBancoAdt+"', E5_AGENCIA = '"+cAgenciaAdt+"', E5_CONTA = '"+cNumCon+"'  "
		_cQuery += " WHERE D_E_L_E_T_ = ' ' "
		_cQuery += " AND E5_FILIAL = '"+SE2->E2_FILIAL+"' "
		_cQuery += " AND E5_PREFIXO = '"+SE2->E2_PREFIXO+" ' "
		_cQuery += " AND E5_NUMERO = '"+SE2->E2_NUM+"' "
		_cQuery += " AND E5_PARCELA = '"+SE2->E2_PARCELA+" ' "
		_cQuery += " AND E5_TIPO = '"+SE2->E2_TIPO+"' "
		_cQuery += " AND E5_FORNECE = '"+SE2->E2_FORNECE+"' "
		_cQuery += " AND E5_LOJA = '"+SE2->E2_LOJA+"' "

		nStatus := TcSQLExec(_cQuery)

		If (nStatus < 0)
			conout("TCSQLError() " + TCSQLError())
		Else
			MSGINFO( "Alteração realizada com sucesso.", "Atenção - FA750BRW" )
		Endif

	EndIf

Return()
