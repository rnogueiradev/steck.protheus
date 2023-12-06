#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MTA010MNU ºAutor  ³Renato Nogueira     º Data ³  05/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. na rotina MATA010 (Cadastro de Produtos) para         º±±
±±º          ³ retirar opções do menu de produtos.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MTA010MNU()
Local _cUsrAlt
Local _cUsrAlt2
_cUsrAlt	:= GetMv("ST_USRALTP")
_cUsrAlt2	:= GetMv("ST_USRALT3")
If !__cUserId $ _cUsrAlt .And.  !__cUserId $ _cUsrAlt2 //Renato Nogueira - Chamado 000080 - Somente alguns usuários podem alterar os produtos
	aRotina[4][2]	:= ""
EndIf
aAdd(aRotina,{"Copiar prod. AM" , "U_STCOPIAB1"   , 0 , 9, 0, .F.})
aAdd(aRotina,{"Rel.Dados.Log"  	, "U_DADOSLOG"   , 0 , 9, 0, .F.}) // Adicionado por Eduardo Matias 18/12/18 - Relatório dados logisticos.
aAdd(aRotina,{"Anexos"  		, "U_STEST100"   , 0 , 9, 0, .F.})

// Jonathan (Integracao Totvs x Thomson)
//           {     Nome do Botao,  Integracao(             Api processamento, 03=Inclusao Tipo Interface, P=Registro Posicionado, TST=Ambiente, 2=AskYesNo)
aAdd(aRotina,{ "# Integ Thomson", "u_WsGnrc00('PKG_SFW_PRODUTOS.PRC_PRODUTO',                       '03',                    'P',        'PRD',          2)"   , 0, 9, 0, .F. })

Do Case
	Case cEmpAnt=="01"
		aAdd(aRotina,{"Replicar CB - AM"  , "U_STREPCOD"   , 0 , 9, 0, .F.})
	Case cEmpAnt=="03"
		aAdd(aRotina,{"Replicar CB - SP"  , "U_STREPCOD"   , 0 , 9, 0, .F.})
EndCase
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STREPCOD  ºAutor  ³Renato Nogueira     º Data ³  05/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcionalidade para copiar codigo de barras			      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STREPCOD()

Local aArea				:= GetArea()
Local _cQuery			:= ""

If Empty(SB1->B1_CODBAR)
	MsgAlert("Atenção, código de barras não preenchido na empresa corrente, verifique!","STREPCOD")
	Return
EndIf

_cQuery := " UPDATE "+IIf(cEmpAnt=="01","SB1030","SB1010")+" B1 "
_cQuery += " SET B1.B1_CODBAR='"+SB1->B1_CODBAR+"'  "
_cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD='"+SB1->B1_COD+"' "

nErrQry := TCSqlExec( _cQuery )

If nErrQry <> 0
	MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
EndIf

MsgAlert("Cópia Finalizada","STREPCOD")

RestArea(aArea)

Return()
