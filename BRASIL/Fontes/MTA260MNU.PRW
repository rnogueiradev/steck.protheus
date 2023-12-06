#INCLUDE "PROTHEUS.CH"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA260MNU  บAutor  ณJoao Rinaldi       บ Data ณ  09/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste ponto de entrada tem por finalidade incluir novos      บฑฑ
ฑฑบ          ณbot๕es na rotina MATA260.PRX                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ MATA260.PRX                                                บฑฑ
ฑฑบNome      ณ Transfer๊ncia entre Armaz้ns                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA260MNU()

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local _aInc     := {"Incluir"   ,"A260Inclui"  , 0 , 3,0,nil}//"Incluir"
	Local _aAlt     := {}
	Local _aExc     := {"Estornar"  ,"A260Estorn"  , 0 , 5,0,nil}//"Estornar"
	Local _aVis     := {"Visualizar","A260Visual"  , 0 , 2,0,nil}//"Visualizar"
	Local _aPesq    := {"Pesquisar" ,"AxPesqui"    , 0 , 1,0,.F.}//"Pesquisar"
	Local _aLeg     := {"Legenda"   ,"A240Legenda" , 0 , 2,0,.F.}//"Legenda"

	If !Empty(_cProgram)
		_cAlias    := 'ZZ3'
		aRotina    := U_STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

		aAdd(aRotina,_aPesq)
		aAdd(aRotina,_aLeg)
	Endif

Return(aRotina)