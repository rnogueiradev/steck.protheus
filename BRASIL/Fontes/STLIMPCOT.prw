#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} STLIMPCOT

Ponto de entrada para limpar o flag do campo C8_XENVMAI

@type function
@author Everson Santana
@since 07/03/19
@version Protheus 12 - Compras

@history ,Chamado 009244 ,

/*/

User Function STLIMPCOT()

	Local _cQry := ""
	Local _stru:={}
	Local aCpoBro := {}
	Local oDlg
	Local _cRet := ""
	Local aCores := {}
	Local _lAlert := .f.
	Local aButtons := {}
	Local oBtn
	Local oTable
	Private lInverte := .F.
	Private cMark   := GetMark()
	Private oMark
	//Cria um arquivo de Apoio

	AADD(_stru,{"STATUS"   		,"C"	,01		,0		})
	AADD(_stru,{"OK"     		,"C"	,02		,0		})
	AADD(_stru,{"COTACAO" 		,"C"	,06		,0		})
	AADD(_stru,{"FORNECEDOR"	,"C"	,06		,0		})
	AADD(_stru,{"LOJA"			,"C"	,02		,0		})
	AADD(_stru,{"NOME"			,"C"	,40		,0		})

	//cArq:=Criatrab(_stru,.T.) 			 //Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("TTRB") //adicionado\Ajustado
	oTable:SetFields(_stru)				     //adicionado\Ajustado
	oTable:Create()							 //adicionado\Ajustado
	cArq := oTable:GetRealName()			 //adicionado\Ajustado
	DBUSEAREA(.t.,"TOPCONN",cArq,"TTRB")

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT C8_NUM,C8_FORNECE,C8_LOJA,C8_NUMPED,C8_XENVMAI "
	_cQry += " FROM "+RetSqlName("SC8")+" SC8 "
	_cQry += " WHERE C8_NUM = '"+SC8->C8_NUM+"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	_cQry += " GROUP BY C8_NUM,C8_FORNECE,C8_LOJA,C8_NUMPED,C8_XENVMAI "

	TcQuery _cQry New Alias "TRD"

	dbSelectArea("TRD")
	TRD->(dbGoTop())

	While TRD->(!Eof())

		DbSelectArea("TTRB")

		RecLock("TTRB",.T.)

		If !Empty(TRD->C8_NUMPED) .and. (Empty(TRD->C8_XENVMAI) .OR. TRD->C8_XENVMAI <> "S")
			TTRB->STATUS		:=  "0" // Pedido Gerado
		ElseIf TRD->C8_XENVMAI == "S" .and. Empty(TRD->C8_NUMPED)
			TTRB->STATUS		:=  "1" // Cotação Enviada
		ElseIf Empty(TRD->C8_XENVMAI) .and. Empty(TRD->C8_NUMPED)
			TTRB->STATUS		:=  "2" // Cotação Não Enviada
		EndIf

		TTRB->COTACAO		:=  TRD->C8_NUM
		TTRB->FORNECEDOR    :=  TRD->C8_FORNECE
		TTRB->LOJA		    :=  TRD->C8_LOJA
		TTRB->NOME			:= POSICIONE("SA2", 1, xFilial("SA2") +TRD->C8_FORNECE+TRD->C8_LOJA, "A2_NOME")

		MsunLock()

		TRD->(DbSkip())

	End

	aCores := {}

	aAdd(aCores,{"TTRB->STATUS == '0'","BR_VERDE"	}) // Pedido Gerado
	aAdd(aCores,{"TTRB->STATUS == '1'","BR_AMARELO"	}) // Cotação Enviada
	aAdd(aCores,{"TTRB->STATUS == '2'","BR_VERMELHO"}) // Cotação Não Enviada

	aCpoBro	:= {{ "OK"			,, ""           ,"@!"},;
	{ "COTACAO"		,, "Cotação"   	,"@!"},;
	{ "FORNECEDOR"	,, "Fornecedor" ,"@!"},;
	{ "LOJA"		,, "Loja" 		,"@!"},;
	{ "NOME"		,, "Nome" 		,"@!"}}

	DEFINE MSDIALOG oDlg TITLE "Selecione a Cotação" From 09,0 To 315,800 PIXEL

	Aadd( aButtons, {"HISTORIC", {|| Legenda()}, "Legenda...", "Legenda" , {|| .T.}} )

	@ -15,-15 BUTTON oBtn PROMPT "..." SIZE 1,1 PIXEL OF oDlg

	DbSelectArea("TTRB")
	DbGotop()
	//Cria a MsSelect
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{37,1,150,400},,,,,aCores)
	oMark:bMark := {| | Disp()}
	//Exibe a Dialog

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,@aButtons)

	DbSelectArea("TTRB")
	DbGotop()

	While TTRB->(!EOF())

		If !Empty(TTRB->OK)

			DbSelectArea("SC8")
			SC8->(DbGoTop())
			SC8->(DbSetOrder(1))
			SC8->(dBSeek(xFilial("SC8")+TTRB->COTACAO+TTRB->FORNECEDOR+TTRB->LOJA))

			While SC8->(!Eof()) .and. SC8->(C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA) = TTRB->(xFilial("SC8")+COTACAO+FORNECEDOR+LOJA)

				DbSelectArea("SC8")

				SC8->(RecLock("SC8",.F.))
				SC8->C8_XENVMAI := ' '
				SC8->(MsUnLock())

				SC8->(DbSkip())

			End

			_lAlert := .T.

		EndIf

		TTRB->(DbSkip())

	Enddo

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())

	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

	If _lAlert
		MsgAlert("Cotação reenviada!!!")
	EndIf

Return


//Funcao executada ao Marcar/Desmarcar um registro.

Static Function Disp()
	RecLock("TTRB",.F.)

	If Marked("OK")
		TTRB->OK := cMark
	Else
		TTRB->OK := ""
	Endif
	MSUNLOCK()

	oMark:oBrowse:Refresh()
Return()


Static Function Legenda()

	Local cTitulo 	:= ''
	Local aLegenda	:={}

	cTitulo 		:= 'Legenda'
	aLegenda		:= {	{"BR_VERDE"		,	"Pedido Gerado"			},;
							{"BR_VERMELHO"	,	"Cotação Não Enviada"	},;
							{"BR_AMARELO"	,	"Cotação Enviada"		}}

	BrwLegenda(" Legenda ",cTitulo, aLegenda)

Return
