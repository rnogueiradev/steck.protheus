#INCLUDE "PROTHEUS.CH"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STACESSOS  ºAutor  ³Joao Rinaldi       º Data ³  09/09/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para liberar as opções de acesso de Inclusão,       º±±
±±º          ³ Alteração, Exclusão e Visualização por Grupo de Usuário    º±±
±±º          ³ onde o programa STACESSOS é chamado pelo Menu de Acesso do º±±
±±º          ³ Programa acessado pelo usuário                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º_cAlias   ³ Tabela ZZ3 - Acessos X Botoes Rotinas                      º±±
±±º_cProgram ³ Nome do Programa acessado pelo usuário                     º±±
±±º_aInc     ³ Array contendo o botão de Inclusão                         º±±
±±º_aAlt     ³ Array contendo o botão de Alteração                        º±±
±±º_aExc     ³ Array contendo o botão de Exclusão                         º±±
±±º_aVis     ³ Array contendo o botão de Visualização                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STACESSOS(_cAlias,_cProgram,_aInc,_aAlt,_aExc,_aVis)

	Local _aGrupos  := {}
	Local _cGrupo   := ''
	

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos   := PswRet()
		_cGrupo    := _aGrupos[1][10][1]
	EndIf

	Dbselectarea(_cAlias)
	(_cAlias)->(DbSetOrder(1))//ZZ3_FILIAL+ZZ3_PROGRA
	(_cAlias)->(DbGoTop())
	If DbSeek(xFilial(_cAlias)+_cProgram)
		If (_cProgram) = Alltrim(UPPER((_cAlias)->ZZ3_PROGRA))
		
			aRotina := {}
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPINC)
				If len(_aInc) >= 4 .And. Findfunction(_aInc[2])
					aAdd(aRotina,_aInc)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPALT)
				If len(_aAlt) >= 4 .And. Findfunction(_aAlt[2])
					aAdd(aRotina,_aAlt)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPEXC)
				If len(_aExc) >= 4 .And. Findfunction(_aExc[2])
					aAdd(aRotina,_aExc)
				Endif
			Endif
			
			If  _cGrupo $ Alltrim((_cAlias)->ZZ3_GRPVIS)
				If len(_aVis) >= 4 .And. Findfunction(_aVis[2])
					aAdd(aRotina,_aVis)
				Endif
			Endif
			
		Endif
	Endif
	(_cAlias)->(dbCloseArea())

Return (aRotina)
