#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | StCepReg         | Autor | GIOVANI.ZAGO             | Data | 18/05/2013  |
|=====================================================================================|
|Descrição | Regiao de Acordo com o cep                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StCepReg                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------*
User Function StCepReg(_cDoc,_cSerie,_cCepx)
	*---------------------------------------------*
	Local _xAlias 	  := GetArea()
	Local _cRegiao    := ''
	Default _cCepx	  := ' '
	DbSelectArea( "SD2" )
	SD2->(DbSetOrder(3))
	If 	SD2->(DbSeek( xFilial("SD2") + _cDoc + _cSerie))
		_cRegiao:=  U_REGCEPED(SD2->D2_PEDIDO,_cCepx)
	EndIf
	RestArea(_xAlias)
Return (_cRegiao)
	/*====================================================================================\
	|Programa  | REGCEPED         | Autor | GIOVANI.ZAGO             | Data | 18/05/2013  |
	|=====================================================================================|
	|Descrição | Regiao de Acordo com o cep                                               |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | REGCEPED                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------*
User Function REGCEPED(_cPed,_cCepx)
	*---------------------------------------------*
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAliasLif   := "TE"+cHora+ cMinutos+cSegundos
	Local cQuery      := ' '
	Local _cRegi      := ' '
	Local _cCep       := ' '
	Local _cCep1      := ' '
	Local _cCep2      := ' '
	Default _cCepx:= ' '

	cQuery := " SELECT  DISTINCT "
	cQuery += ' SC5.C5_XTIPO            "TIPO"            ,  '
	cQuery += ' SC5.C5_TRANSP           "TRANSP"          ,  '
	cQuery += ' NVL(ZZ1.ZZ1_CEP,'+"' '"+ ')    "OBRA"     ,  '
	cQuery += ' SC5.C5_ZCEPE             "ENTREGA"         ,  '
	cQuery += ' SA1.A1_CEP              "CLIENTE"         ,  '
	cQuery += ' NVL(SA4.A4_CEP ,'+"' '"+ ')  "CEPTRANSP"          '
	cQuery += " FROM "+RetSqlName("SC5")+" SC5   "
	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SA1")+" ) SA1   "
	cQuery += " ON SA1.A1_COD        = SC5.C5_CLIENTE  "
	cQuery += " AND SA1.A1_LOJA      = SC5.C5_LOJACLI  "
	cQuery += " AND SA1.D_E_L_E_T_   = ' '             "
	cQuery += " AND SA1.A1_FILIAL    = '"+xFilial("SA1")+"'"
	cQuery += " LEFT JOIN (SELECT * FROM "+RetSqlName("SA4")+" ) SA4   "
	cQuery += " ON SA4.A4_COD        = SC5.C5_TRANSP  "
	cQuery += " AND SA4.D_E_L_E_T_   = ' '            "
	cQuery += " AND SA4.A4_FILIAL    = '"+xFilial("SA4")+"'"
	cQuery += " LEFT  JOIN (SELECT * FROM "+RetSqlName("ZZ1")+" ) ZZ1   "
	cQuery += " ON ZZ1.ZZ1_COD = SC5.C5_ZCODOBR     "
	cQuery += " AND ZZ1.ZZ1_FILIAL   = '"+xFilial("ZZ1")+"'"
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '         "
	cQuery += " AND SC5.C5_FILIAL    = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_NUM       = '"+_cPed+"'"


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())

		If (cAliasLif)->TRANSP = '000163'
			_cRegi:= 'TNT'
			If _cCepx = '1'
				Return (_cCep)
			EndIf
		Else
			If	(cAliasLif)->TIPO = '1'
				_cRegi:= 'RET'
				If _cCepx = '1'
					Return (_cCep)
				EndIf
			ElseIf	(cAliasLif)->TIPO = '2'
				If !((cAliasLif)->TRANSP $ '000001/10000')
					_cCep:= 	(cAliasLif)->CEPTRANSP
				Else
					If	    ! Empty(Alltrim((cAliasLif)->OBRA ))
						_cCep  := (cAliasLif)->OBRA
					ElseIf	! Empty(Alltrim((cAliasLif)->ENTREGA ))
						_cCep  := (cAliasLif)->ENTREGA
					Else
						_cCep  := (cAliasLif)->CLIENTE
					EndIf
				EndIf
				If	    ! Empty(Alltrim(_cCep))
					
					_cRegi := GETREGCEP(_cCep)//chamado 007630
					If _cCepx = '1'
						Return (_cCep)
					EndIf
				 
				EndIf
			EndIf
		EndIf
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
Return (_cRegi)

/*/{Protheus.doc} GETREGCEP
@name GETREGCEP
@type Static Function
@desc função utilizada para retornar regiao do CEP
@author Renato Nogueira
@since 24/05/2018
/*/

Static Function GETREGCEP(_cCepRec)

	Local _cRegRet := " "

	DbSelectArea("SZN")
	SZN->(DbSetOrder(1))
	SZN->(DbGoTop())
	If SZN->(DbSeek(xFilial("SZN")+_cCepRec))
		_cRegRet := SZN->ZN_ROTA
	EndIf
	
	_cRegRet := Alltrim(_cRegRet)

Return(_cRegRet)



User Function CadSZN()

	Private cAlias := "SZN"
	Private aRotina   := {}
	Private aSubRotina := {}
	Private lRefresh  := .T.
	Private cCadastro := "Cadastro de Rotas/Cep"

	aAdd( aRotina, {"Pesquisar" ,"AxPesqui",0,1} )
	aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
	aAdd( aRotina, {"Incluir"   ,'AxInclui(cAlias,RecNo(),3,,,,,,,)',0,3} )
	aAdd( aRotina, {"Alterar"   ,'AxAltera(cAlias,RecNo(),4)',0,4} )
	aAdd( aRotina, {"Excluir"   ,"AxDeleta",0,6} )

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return