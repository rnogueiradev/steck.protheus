#include 'Protheus.ch'
#include 'RwMake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPREDES	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STPREDES()

	Local aArea          := GetArea()
	Local aCores2        := {	;
	{ "ZZV->ZZV_STATUS == '0' .AND. !EMPTY(ZZV->ZZV_DTREV)", "BR_AZUL"   		},; //Em aprovação
	{ "ZZV->ZZV_STATUS == '1' .AND. !EMPTY(ZZV->ZZV_DTREV)", "BR_AMARELO"  		},; //Aguardando efetivação
	{ "ZZV->ZZV_STATUS == '2' .AND. !EMPTY(ZZV->ZZV_DTREV)", "BR_VERDE"  		},; //Aprovado
	{ "ZZV->ZZV_STATUS == '3' .AND. !EMPTY(ZZV->ZZV_DTREV)", "BR_VERMELHO"  	},;	//Rejeitado	
	{ "ZZV->ZZV_STATUS == '0' .AND. EMPTY(ZZV->ZZV_DTREV)",  "BR_AZUL_CLARO"   	},; //Em aprovação Sem Data de Revisão
	{ "ZZV->ZZV_STATUS == '1' .AND. EMPTY(ZZV->ZZV_DTREV)",  "BR_BRANCO"  		},; //Aguardando efetivação Sem Data de Revisão
	{ "ZZV->ZZV_STATUS == '2' .AND. EMPTY(ZZV->ZZV_DTREV)",  "BR_VERDE_ESCURO" 	},; //Aprovado Sem Data de Revisão
	{ "ZZV->ZZV_STATUS == '3' .AND. EMPTY(ZZV->ZZV_DTREV)",  "BR_VIOLETA"   	}}	//Rejeitado	Sem Data de Revisão

	Private cCadastro	 := "Cadastro de pré-desconto"
	Private cAlias1:= "ZZV"
	Private cAlias2:= "ZZX"
	Private aRotina := {;
	{ "Pesquisar"  					, "PesqBrw" 		, 0 , 1 },;
	{ "Visualizar" 					, "U_STCADZZV" 	, 0 , 2 },;
	{ "Incluir"    					, "U_STCADZZV" 	, 0 , 3 },;
	{ "Alterar"    					, "U_STCADZZV" 	, 0 , 4 },;
	{ "Legenda"    					, "U_STZZXLEG" 	, 0 , 5 },;
	{ "Finaliza pré-desconto"    	, "U_STZZXFIN" 	, 0 , 6 },;
	{ "Aprovar"				    	, "U_STZZXAPV" 	, 0 , 7 },;
	{ "Rejeitar"			    	, "U_STZZXREJ" 	, 0 , 8 },;
	{ "Voltar p/ edição"	    	, "U_STZZXRET" 	, 0 , 12 },;
	{ "Copiar"				    	, "U_STZZXCOP" 	, 0 , 9  },;
	{ "Excluir"				    	, "U_STDELZZV" 	, 0 , 10  },;
	{ "Copiar pré-desconto"    		, "U_STZZXCO1" 	, 0 , 11  },;
	{ "Atualizar Data revisao" 		, "U_STZZDTRV" 	, 0 , 4 }}

	DbSelectArea("ZZV")
	ZZV->(DbSetOrder(1))

	mBrowse( 7, 4,20,74,"ZZV", , , , , 2, aCores2)

	Restarea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCADZZV	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STCADZZV( cAlias, nReg, nOpc )

	Local i:=0
	Local cLinok := "U_XZZXVLD"
	Local cTudook := "U_XZZXTOK"
	Local nOpce := nopc
	Local nOpcg := nopc
	Local cFieldok := "allwaystrue"
	Local lVirtual := .T.
	Local nLinhas := 999
	Local nFreeze := 0
	Local lRet := .T.
	Local aParambox	:= {}
	Local cRegra		:= Space(6)
	Private aRet			:= {}
	Private aCols := {}
	Private aHeader := {}
	Private aCpoEnchoice := {}
	Private aAltEnchoice := {}
	Private aAlt := {}

	If INCLUI .Or. ALTERA .Or. IsInCallStack("U_STZZXCOP")

		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		SA3->(DbGoTop())
		If SA3->(DbSeek(xFilial("SA3")+__cUserId))
			If !SubStr(SA3->A3_COD,1,1) $ "S#G" .And. !__cUserId $ GetMv("ST_PREDES") //Acesso somente para supervisores e gerentes
				MsgAlert("Atenção, rotina disponível somente para supervisores e gerentes, verifique!")
				Return
			EndIf
		Else
			MsgAlert("Atenção, seu usuário não essa cadastrado como vendedor, verifique!")
			Return
		EndIf

		If ALTERA

			If !(AllTrim(ZZV->ZZV_SOLIC)==CUSERNAME)
				MsgAlert("Atenção, essa solicitação não está vinculada ao seu usuário")
				Return
			EndIf

			If ZZV->ZZV_STATUS $ "1#2#3" //Aguardando efetivação, efetivado ou rejeitado
				MsgAlert("Atenção, não é permitida mais alteração neste pré-desconto")
				Return
			EndIf

		EndIf

	EndIf

	If nOpc == 9
		aAdd(aParamBox,{1,"Regra"		,cRegra	,"@!","","ACO","",0,.T.})
		If !ParamBox(aParamBox,"Selecione a regra",@aRet,,,,,,,,.f.)
			Return
		Endif
		nOpce	:= 3
		nOpcg	:= 3
	EndIf

	Regtomemory(cAlias1,(nOpc==3).Or.(nOpc==9))
	Regtomemory(cAlias2,(nOpc==3).Or.(nOpc==9))
	CriaHeader()
	CriaCols(nOpc)
	lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,;
	nOpcg,cFieldok,lVirtual,nLinhas,aAltenchoice,nFreeze)

	If lRet
		//Se opcao for inclusão

		If nOpc == 3

			Processa({||Grvdados()},cCadastro,"Gravando os dados, aguarde...")

			ConfirmSX8()

			//Se opção for alteração

		ElseIf nOpc == 4

			Processa({||Altdados()},cCadastro,"Alterando os dados, aguarde...")

			//Se opção for exclusão

		ElseIf nOpc == 5

			Processa({||Excluidados()},cCadastro,"Excluindo os dados, aguarde...")

		ElseIf nOpc == 9

			Processa({||Grvdados()},cCadastro,"Gravando os dados, aguarde...")

			ConfirmSX8()

		EndIf

	Else

		RollbackSx8()

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaHeader	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaHeader()

	aHeader:= {}
	aCpoEnchoice := {}
	aAltEnchoice :={}

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(cAlias2)

	While !Eof() .and. x3_arquivo == cAlias2

		If x3uso(x3_usado) .and. cnivel >= x3_nivel

			AADD(aHeader,{trim(x3_titulo),;
			x3_campo,;
			x3_picture,;
			x3_tamanho,;
			x3_decimal,;
			x3_valid,;
			x3_usado,;
			x3_tipo,;
			x3_arquivo,;
			x3_context})

		EndIf

		DbSkip()

	EndDo

	Dbseek(cAlias1)

	While !Eof() .and. x3_arquivo == cAlias1

		If cnivel >= x3_nivel .And. x3uso(x3_usado)
			If Alltrim(x3_campo) $	"ZZV_FILIAL/ZZV_COD/ZZV_DTEMIS/ZZV_CLIENT/ZZV_LOJA/ZZV_NOMECL/ZZV_GRPVEN/ZZV_SOLIC/ZZV_VEND1/ZZV_NVEND1/ZZV_SUPER/ZZV_NSUPER/ZZV_MOTREJ/ZZV_CODVEN/ZZV_STATUS/ZZV_DTREV"
				AADD(aCpoEnchoice,x3_campo)
				AADD(aAltEnchoice,x3_campo)
			EndIf
		EndIf

		DbSkip()

	EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaCols	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function CriaCols(nOpc)

	Local nQtdcpo := 0
	Local i:= 0
	Local nCols := 0

	nQtdcpo := len(aHeader)
	aCols:= {}
	aAlt := {}

	If nOpc == 3

		AADD(aCols,array(nQtdcpo+1))

		For i := 1 to nQtdcpo

			aCols[1,i] := Criavar(aHeader[i,2])

		Next i

		aCols[1,nQtdcpo+1] := .F.

	Else

		If nOpc == 9 //Copia

			DbSelectArea("ACP")
			ACP->(DbSetOrder(1))
			ACP->(DbGoTop())
			ACP->(DbSeek(xFilial("ACP")+aRet[1]))

			While ACP->(!Eof()) .And. xFilial("ACP")==ACP->ACP_FILIAL .And. aRet[1]==ACP->ACP_CODREG

				AADD(aCols,array(nQtdcpo+1))

				nCols++

				For i:= 1 To nQtdcpo

					If aHeader[i,10] <> "V"

						Do Case
							Case i==1
							aCols[nCols,i]	:= PADL(ACP->ACP_ITEM,4,"0")
							Case i==2
							aCols[nCols,i]	:= ACP->ACP_CODPRO
							Case i==3
							aCols[nCols,i]	:= POSICIONE("SB1",1,xFilial("SB1")+ACP->ACP_CODPRO,"B1_DESC")
							Case i==4
							aCols[nCols,i]	:= ACP->ACP_GRUPO
							Case i==5
							aCols[nCols,i]	:= POSICIONE("SBM",1,xFilial("SBM")+ACP->ACP_GRUPO,"BM_DESC")
							Case i==6
							aCols[nCols,i]	:= ACP->ACP_PERDES
						EndCase

					Else

						aCols[nCols,i] := Criavar(aHeader[i,2],.T.)

					EndIf

				Next i

				aCols[nCols,nQtdcpo+1] := .F.

				ACP->(DbSkip())

			EndDo

		Else

			DbSelectArea(cAlias2)
			DbSetOrder(1)
			DbSeek(xfilial(cAlias2)+(cAlias1)->ZZV_COD)

			While .not. Eof() .and. (cAlias2)->ZZX_FILIAL == xfilial(cAlias2) .and. (cAlias1)->ZZV_COD==(cAlias2)->ZZX_COD

				AADD(aCols,array(nQtdcpo+1))

				nCols++

				For i:= 1 To nQtdcpo

					If aHeader[i,10] <> "V"

						aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))

					Else

						aCols[nCols,i] := Criavar(aHeader[i,2],.T.)

					EndIf

				Next i

				aCols[nCols,nQtdcpo+1] := .F.
				AADD(aAlt,Recno())

				DbSelectArea(cAlias2)
				DbSkip()

			EndDo

		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvDados	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvDados()

	Local bcampo := {|nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nItem :=0

	Procregua(len(aCols)+fCount())

	DbSelectArea(cAlias1)

	Reclock(cAlias1,.T.)

	For i:= 1 To fcount()

		IncProc()

		If "FILIAL" $ FieldName(i)

			Fieldput(i,xfilial(cAlias1))

		Else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

		If "COPIA" $ FieldName(i)
			If IsInCallStack("U_STZZXCOP")
				Fieldput(i,"S")
			EndIf
		EndIf

	Next

	Msunlock()

	DbSelectArea(cAlias2)
	DbSetOrder(1)

	For i:=1 to Len(aCols)

		incproc()

		If .not. aCols[i,Len(aHeader)+1]

			Reclock(cAlias2,.T.)

			For y:= 1 To Len(aHeader)

				Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

			Next

			nItem++

			(cAlias2)->ZZX_FILIAL := xfilial(cAlias2)
			(cAlias2)->ZZX_COD := (cAlias1)->ZZV_COD

			Msunlock()

		EndIf

	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Altdados	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Altdados()

	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0

	Procregua(Len(aCols)+fCount())

	DbSelectArea(cAlias1)

	Reclock(cAlias1,.F.)

	For i:= 1 To Fcount()

		incproc()

		If "FILIAL" $ fieldname(i)

			Fieldput(i,xfilial(cAlias1))

		Else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

	Next i

	Msunlock()

	DbSelectArea(cAlias2)
	DbSetOrder(1)

	nItem := len(aAlt)+1

	For i:=1 To Len(aCols)

		If i<=len(aAlt)

			DbGoTo(aAlt[i])

			Reclock(cAlias2,.F.)

			If aCols[i,Len(aHeader)+1]

				DbDelete()

			Else

				For y:= 1 To Len(aHeader)

					Fieldput(Fieldpos(Trim(aHeader[y,2])),aCols[i,y])

				Next y

			EndIf

			Msunlock()

		Else

			If ! aCols[i,Len(aHeader)+1]

				Reclock(cAlias2,.T.)

				For y:= 1 To Len(aHeader)

					Fieldput(Fieldpos(Trim(aHeader[y,2])),aCols[i,y])

				Next y

				(cAlias2)->ZZX_FILIAL := xfilial(calias2)
				(cAlias2)->ZZX_COD := (cAlias1)->ZZV_COD

				Msunlock()
				nItem++

			EndIf

		EndIf

	Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Excluidados	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Excluidados()

	Procregua(len(aCols)+1)

	DbSelectArea(cAlias2)
	DbSetOrder(1)
	DbSeek(xfilial(cAlias2)+(cAlias1)->ZZV_FILIAL)

	Do While .not. Eof() .and. (cAlias2)->ZZX_FILIAL == xfilial(cAlias2) .and. (cAlias2)->ZZX_COD==(cAlias1)->ZZV_COD

		Incproc()

		Reclock(cAlias2,.F.)
		DbDelete()
		Msunlock()
		DbSkip()

	EndDo

	DbSelectArea(cAlias1)
	DbSetOrder(1)

	Incproc()

	Reclock(cAlias1,.F.)
	DbDelete()
	Msunlock()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XZZXTOK	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function XZZXTOK()

	Local lRet:= .T.
	Local i:=0
	Local nDel :=0
	Local _nProduto		:= aScan(aHeader,{|w| AllTrim(w[2])=="ZZX_PROD"})
	Local _nGrupo			:= aScan(aHeader,{|w| AllTrim(w[2])=="ZZX_GRUPO"})

	For i:=1 to len(aCols)

		If aCols[i,len(aHeader)+1]
			nDel++
		EndIf

	Next

	If nDel == len(aCols)
		Msginfo("Para excluir todos os itens, utilize a opção Cancelar",cCadastro)
		lRet := .F.
	EndIf

return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXLEG	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXLEG()

	Local aCorDesc
	aCorDesc := {  ;
	{ "BR_AZUL"			,"Em aprovação" 		},;
	{ "BR_AMARELO"		,"Aguardando efetiv." 	},;
	{ "BR_VERMELHO"		,"Rejeitado" 			},;
	{ "BR_VERDE"		,"Aprovado" 			},;
	{ "BR_AZUL_CLARO"	,"Em aprovação Sem Data de Revisão" },;
	{ "BR_BRANCO"		,"Aguardando efetivação Sem Data de Revisão" },;
	{ "BR_VERDE_ESCURO"	,"Aprovado Sem Data de Revisão" 	},;
	{ "BR_VIOLETA"		,"Rejeitado	Sem Data de Revisão" 	}}
	
	BrwLegenda( "Legenda", "Status", aCorDesc )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XZZXVLD	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function XZZXVLD()

	Local lRet				:= .T.
	Local _nProduto		:= aScan(aHeader,{|w| AllTrim(w[2])=="ZZX_PROD"})
	Local _nGrupo			:= aScan(aHeader,{|w| AllTrim(w[2])=="ZZX_GRUPO"})
	Local i := 0
	If !aCols[n,len(aHeader)+1]

		If Empty(aCols[n,_nProduto]) .And. Empty(aCols[n,_nGrupo])
			MsgAlert("Atenção, preencha o produto ou o grupo")
			lRet	:= .F.
		EndIf

		If !Empty(aCols[n,_nProduto]) .And. !Empty(aCols[n,_nGrupo])
			MsgAlert("Atenção, preencha o produto ou o grupo")
			lRet	:= .F.
		EndIf

		For i:=1 to Len(aCols)

			If !aCols[i,len(aHeader)+1]

				Do case
					Case !Empty(aCols[n,_nProduto])
					If aCols[n,_nProduto]==aCols[i,_nProduto] .And. !(i==n)
						MsgAlert("Atenção, produto já colocado")
						lRet	:= .F.
					EndIf
					Case !Empty(aCols[n,_nGrupo])
					If aCols[n,_nGrupo]==aCols[i,_nGrupo] .And. !(i==n)
						MsgAlert("Atenção, grupo já colocado")
						lRet	:= .F.
					EndIf
				EndCase
			EndIf

		Next

	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXGNX	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXGNX()
	Local i:= 0
	Local _cItem	:= "0000"
	Local _nItem	:= aScan(aHeader,{|w| AllTrim(w[2])=="ZZX_ITEM"})

	If ALTERA

		For i:=1 to Len(aCols)

			If Len(aCols[i])>1

				If !aCols[i,len(aHeader)+1]
					_cItem	:= aCols[i,_nItem]
				EndIf

			EndIf

		Next

	EndIf

	_cItem	:= Soma1(_cItem,4)

Return(_cItem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXFIN	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXFIN()

	Local _aAttach  := {}
	Local _cCaminho := ''
	Local cMsg		:= ""
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	If !(AllTrim(ZZV->ZZV_SOLIC)==CUSERNAME)
		MsgAlert("Atenção, essa solicitação não está vinculada ao seu usuário")
		Return
	EndIf
	If !(ZZV->ZZV_STATUS=="0")
		MsgAlert("Atenção, essa solicitação não está com status de em aprovação")
		Return
	EndIf

	cQuery1	 := " SELECT ZZV_COD, ZZX_ITEM, ZZX_PROD, ZZX_GRUPO,
	cQuery1	 += " (SELECT A1_ATIVIDA FROM "+RetSqlName("SA1")+" A1 WHERE A1.D_E_L_E_T_=' ' AND ZZV_CLIENT=A1_COD AND ZZV_LOJA=A1_LOJA ) ATIVIDA "
	cQuery1	 += " ,(SELECT ACO_CODREG FROM "+RetSqlName("ACO")+" ACO WHERE ACO.D_E_L_E_T_=' ' AND ACO_GRPVEN=(SELECT A1_ATIVIDA FROM "+RetSqlName("SA1")+" A1 "
	cQuery1  += " WHERE A1.D_E_L_E_T_=' ' AND ZZV_CLIENT=A1_COD AND ZZV_LOJA=A1_LOJA AND ACO_CODCLI=' ')) ACOREG "
	cQuery1  += " ,CASE WHEN ZZX_PROD=' ' THEN NVL((SELECT ACP_PERDES FROM "+RetSqlName("ACP")+" ACP WHERE ACP.D_E_L_E_T_=' ' AND ACP_CODREG= "
	cQuery1  += " (SELECT ACO_CODREG FROM "+RetSqlName("ACO")+" ACO WHERE ACO.D_E_L_E_T_=' ' AND ACO_GRPVEN=(SELECT A1_ATIVIDA FROM "+RetSqlName("SA1")+" A1 "
	cQuery1  += " WHERE A1.D_E_L_E_T_=' ' AND ZZV_CLIENT=A1_COD AND ZZV_LOJA=A1_LOJA AND ACO_CODCLI=' ')) "
	cQuery1  += " AND ZZX_GRUPO=ACP_GRUPO),0) ELSE NVL((SELECT ACP_PERDES FROM "+RetSqlName("ACP")+" ACP WHERE ACP.D_E_L_E_T_=' ' AND ACP_CODREG= "
	cQuery1	 += " (SELECT ACO_CODREG FROM "+RetSqlName("ACO")+" ACO WHERE ACO.D_E_L_E_T_=' ' AND ACO_GRPVEN=(SELECT A1_ATIVIDA FROM "+RetSqlName("SA1")+" A1 "
	cQuery1	 += " WHERE A1.D_E_L_E_T_=' ' AND ZZV_CLIENT=A1_COD AND ZZV_LOJA=A1_LOJA AND ACO_CODCLI=' ')) "
	cQuery1	 += " AND ZZX_PROD=ACP_CODPRO),0) END AS ACHOU "
	cQuery1  += " FROM "+RetSqlName("ZZV")+" ZZV "
	cQuery1  += " LEFT JOIN "+RetSqlName("ZZX")+" ZZX "
	cQuery1  += " ON ZZV_FILIAL=ZZX_FILIAL AND ZZV_COD=ZZX_COD "
	cQuery1  += " WHERE ZZV.D_E_L_E_T_=' ' AND ZZX.D_E_L_E_T_=' ' AND ZZV_COD='"+ZZV->ZZV_COD+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	While (cAlias1)->(!Eof())
		If AllTrim(ZZV->ZZV_COPIA)=="S"
			If (cAlias1)->ACHOU=0
				MsgAlert("Atenção, não foi encontrado cadastro master de desconto para esse cliente, item: "+(cAlias1)->ZZX_ITEM+" verifique!")
				Return
			EndIf
		EndIf
		(cAlias1)->(DbSkip())
	EndDo

	If MsgYesNo("Deseja finalizar este pré-desconto e enviar para aprovação?")

		ZZV->(RecLock("ZZV",.F.))
		ZZV->ZZV_STATUS	:= "1" //Aguardando efetivação
		ZZV->(MsUnLock())

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Código: </b>'+Alltrim(ZZV->ZZV_COD)+'<br><b>Cliente: </b>'+Alltrim(ZZV->ZZV_NOMECL)+'<br>'
		cMsg += '</body></html>'

		If !U_STMAILTES(GetMv("ST_MAILPDE"),"","Novo pré-desconto: "+ZZV->ZZV_COD,cMsg,_aAttach,_cCaminho)
			VtAlert("Problemas no envio de email!")
		EndIf

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXAPV	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXAPV()

	Local _cAcoReg
	Local _nPerc	:= 0
	Local _cCodAco

	If !(__cUserId $ GetMv("ST_APVZZX")  )
		MsgAlert("Atenção, você não está autorizado a aprovar pré-desconto!")
		Return
	EndIf

	If !(ZZV->ZZV_STATUS=="1")
		MsgAlert("Atenção, este pré-desconto não está em fase de aprovação/rejeição!")
		Return
	EndIf

	If MsgYesNo("Deseja aprovar o pré-desconto"+ZZV->ZZV_COD+"?")

		Begin Transaction

			DbSelectArea("ZZX")
			ZZX->(DbSetOrder(1))
			ZZX->(DbGoTop())
			ZZX->(DbSeek(xFilial("ZZX")+ZZV->ZZV_COD))

			While ZZX->(!Eof()) .And. ZZX->ZZX_COD==ZZV->ZZV_COD

				DbSelectArea("ACO")
				ACO->(DbSetOrder(3))
				ACO->(DbGoTop())

				If !ACO->(DbSeek(xFilial("ACO")+ZZV->ZZV_CLIENT+ZZV->ZZV_LOJA)) //Caso não ache na tabela ACO cria o registro com o próximo código

					_cAcoReg	:= GETSXENUM("ACO", "ACO_CODREG")

					ACO->(RecLock("ACO",.T.))
					ACO->ACO_FILIAL	:= xFilial("ACO")
					ACO->ACO_CODREG	:= _cAcoReg
					ACO->ACO_DESCRI	:= ZZV->ZZV_NOMECL
					ACO->ACO_CODCLI	:= ZZV->ZZV_CLIENT
					ACO->ACO_LOJA   := ZZV->ZZV_LOJA
					ACO->ACO_MOEDA	:= 1
					ACO->ACO_CFAIXA	:= "YYYYYYYYYYYYYYY.YY"
					ACO->ACO_TPHORA	:= "1"
					ACO->ACO_HORADE	:= "00:00"
					ACO->ACO_HORATE	:= "23:59"
					ACO->ACO_DATDE	:= DATE()
					ACO->ACO_GRPVEN	:= ZZV->ZZV_GRPVEN
					ACO->ACO_DESCPR	:= .F.
					ACO->(MsUnLock())

					ACO->(ConfirmSX8())

				EndIf

				_cCodAco	:= ACO->ACO_CODREG

				DbSelectArea("ACP")
				ACP->(DbSetOrder(2)) //ACP_FILIAL+ACP_CODREG+ACP_GRUPO+ACP_CODPRO+ACP_CFAIXA
				ACP->(DbGoTop())

				Do Case

					Case !Empty(ZZX->ZZX_PROD)

					DbSelectArea("SA1")
					SA1->(DbSetOrder(1))
					SA1->(DbGoTop())
					If	SA1->(DbSeek(xFilial("SA1")+ZZV->ZZV_CLIENT+ZZV->ZZV_LOJA))

						DbSelectArea("ACO")
						ACO->(DbSetOrder(4))
						ACO->(DbGoTop())
						If	ACO->(DbSeek(xFilial("ACO")+SA1->A1_ATIVIDA))

							DbSelectArea("ACP")
							ACP->(DbSetOrder(2))
							ACP->(DbGoTop())
							If	ACP->(DbSeek(xFilial("ACP")+ACO->ACO_CODREG+'    '+ZZX->ZZX_PROD))
								_nPerc	:= STGETPER(ZZV->ZZV_CLIENT,ZZV->ZZV_LOJA,'    '+ZZX->ZZX_PROD,ZZX->ZZX_PERCEN,"P")
							Else
								_nPerc	:= STGETPER(ZZV->ZZV_CLIENT,ZZV->ZZV_LOJA,Posicione("SB1",1,xFilial("SB1")+ZZX->ZZX_PROD,"B1_GRUPO"),ZZX->ZZX_PERCEN,"P")
							EndIf
						EndIf
					EndIf		

					If ZZV->ZZV_COPIA=="S"
						_nPerc	:= ZZX->ZZX_PERCEN
					EndIf

					If ACP->(DbSeek(xFilial("ACP")+_cCodAco+"    "+ZZX->ZZX_PROD))

						ACP->(RecLock("ACP",.F.))
						ACP->ACP_PERDES	:= _nPerc
						ACP->(MsUnLock())

					Else

						ACP->(RecLock("ACP",.T.))
						ACP->ACP_FILIAL	:= xFilial("ACP")
						ACP->ACP_CODREG	:= _cCodAco
						ACP->ACP_ITEM	:= GETNXTITEM(_cCodAco)
						ACP->ACP_CODPRO	:= ZZX->ZZX_PROD
						ACP->ACP_FAIXA	:= 999999.99
						ACP->ACP_CFAIXA	:= "000000000999999.99"
						ACP->ACP_PERDES	:= _nPerc
						ACP->(MsUnLock())

					EndIf

					Case !Empty(ZZX->ZZX_GRUPO)

					_nPerc	:= STGETPER(ZZV->ZZV_CLIENT,ZZV->ZZV_LOJA,ZZX->ZZX_GRUPO,ZZX->ZZX_PERCEN,"G")
					If ZZV->ZZV_COPIA=="S"
						_nPerc	:= ZZX->ZZX_PERCEN
					EndIf

					If ACP->(DbSeek(xFilial("ACP")+_cCodAco+ZZX->ZZX_GRUPO))

						ACP->(RecLock("ACP",.F.))
						ACP->ACP_PERDES	:= _nPerc
						ACP->(MsUnLock())

					Else

						ACP->(RecLock("ACP",.T.))
						ACP->ACP_FILIAL	:= xFilial("ACP")
						ACP->ACP_CODREG	:= _cCodAco
						ACP->ACP_ITEM		:= GETNXTITEM(_cCodAco)
						ACP->ACP_GRUPO	:= ZZX->ZZX_GRUPO
						ACP->ACP_FAIXA	:= 999999.99
						ACP->ACP_CFAIXA	:= "000000000999999.99"
						ACP->ACP_PERDES	:= _nPerc
						ACP->(MsUnLock())

					EndIf

				EndCase

				ZZX->(DbSkip())

			EndDo

		End Transaction

		ZZV->(RecLock("ZZV",.F.))
		ZZV->ZZV_STATUS		:= "2" //Aprovado
		ZZV->(MsUnlock())

		MsgInfo("Pré-desconto aprovado com sucesso!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXREJ	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXREJ()

	Local cMotRej    := SPACE(200)
	Local nOpca      := 0

	If !(__cUserId $ GetMv("ST_APVZZX")  )
		MsgAlert("Atenção, você não está autorizado a aprovar pré-desconto!")
		Return
	EndIf

	If !(ZZV->ZZV_STATUS=="1")
		MsgAlert("Atenção, este pré-desconto não está em fase de aprovação/rejeição!")
		Return
	EndIf

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Motivo Rejeição") From 1,0 To 10,60 OF oMainWnd

	@ 05,04 SAY "Motivo:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cMotRej   Size 200,012  PIXEL OF oDlgEmail

	@ 043, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	//@ 043, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1

		ZZV->(RecLock("ZZV",.F.))
		ZZV->ZZV_STATUS		:= "3" //Rejeitado
		ZZV->ZZV_MOTREJ    	:= cMotRej
		ZZV->(MsUnlock())

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXRET	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXRET()

	If !(__cUserId $ GetMv("ST_APVZZX")  )
		MsgAlert("Atenção, você não está autorizado a aprovar pré-desconto!")
		Return
	EndIf

	If !(ZZV->ZZV_STATUS=="1")
		MsgAlert("Atenção, este pré-desconto não está em fase de aprovação/rejeição!")
		Return
	EndIf

	If MsgYesNo("Confirma voltar esse pré-desconto para em edição?")
		ZZV->(RecLock("ZZV",.F.))
		ZZV->ZZV_STATUS		:= "0" //Rejeitado
		ZZV->(MsUnlock())
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETNXTITEM	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto										   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GETNXTITEM(_cCodReg)

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local cNextItem	:= ""

	cQuery1  := " SELECT ACP_ITEM "
	cQuery1  += " FROM " +RetSqlName("ACP")+ " ACP "
	cQuery1  += " WHERE ACP.D_E_L_E_T_=' ' AND ACP_CODREG='"+_cCodReg+"' "
	cQuery1  += " ORDER BY ACP_ITEM DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	cNextItem	:= Soma1((cAlias1)->ACP_ITEM)

Return(cNextItem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGETPER	ºAutor  ³Renato Nogueira     º Data ³  09/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de pré-desconto									  º±±
±±																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STGETPER(_cCliente,_cLoja,_cCod,_nPerc,_cTipo)

	Local _nPercOk	:= 0
	Local _nBase	:= 0
	Local _aArea	:= GetArea()

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))

	DbSelectArea("ACO")
	ACO->(DbSetOrder(4))
	ACO->(DbGoTop())
	ACO->(DbSeek(xFilial("ACO")+SA1->A1_ATIVIDA))

	DbSelectArea("ACP")
	ACP->(DbSetOrder(2))
	ACP->(DbGoTop())
	ACP->(DbSeek(xFilial("ACP")+ACO->ACO_CODREG+_cCod))

	_nBase		:= 100-ACP->ACP_PERDES
	_nPercOk	:= _nBase*(_nPerc/100)
	_nPercOk	:= 100-(_nBase-_nPercOk)

	RestArea(_aArea)

Return(_nPercOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXCOP	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copia desconto já existente 							   	º±±
±±																		º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXCOP(cAlias, nReg, nOpc)

	U_STCADZZV(cAlias, nReg, nOpc)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDELZZV	ºAutor  ³Renato Nogueira     º Data ³  09/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Excluir pré-desconto				 							   	º±±
±±																					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STDELZZV(cAlias, nReg, nOpc)

	Local _cCod	:= ""

	If !ZZV->ZZV_STATUS $ "0#1"
		MsgAlert("Atenção, só é permitido excluir pré-desconto em aprovação ou aguardando aprovação, verifique!")
		Return
	EndIf

	If !(AllTrim(ZZV->ZZV_SOLIC)==UsrRetName(__cUserId))
		MsgAlert("Atenção, você não é o solicitante deste pré-desconto, verifique!")
		Return
	EndIf

	If MsgYesNo("Confirma exclusão do pré-desconto: "+_cCod+"?")

		_cCod	:= ZZV->ZZV_COD

		Begin Transaction

			ZZV->(RecLock("ZZV",.F.))
			ZZV->(DbDelete())
			ZZV->(MsUnLock())

			DbSelectArea("ZZX")
			ZZX->(DbSetOrder(1))
			ZZX->(DbGoTop())
			ZZX->(DbSeek(xFilial("ZZX")+_cCod))

			While ZZX->(!Eof()) .And. ZZX->ZZX_COD==_cCod

				ZZX->(RecLock("ZZX",.F.))
				ZZX->(DbDelete())
				ZZX->(MsUnLock())

				ZZX->(DbSkip())
			EndDo

			MsgAlert("Pré-desconto: "+_cCod+" excluído com sucesso")

		End Transaction

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STZZXCO1	ºAutor  ³Renato Nogueira     º Data ³  10/02/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copiar pré-desconto				 						º±±
±±																		º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STZZXCO1(cAlias, nReg, nOpc)

	Local aParambox		:= {}
	Local cPreDes		:= Space(6)
	Local cCliente		:= Space(6)
	Local cLoja			:= Space(2)
	Local _cCod			:= ""
	Local _cItem		:= "0001"
	Local _aItens		:= {}
	Local _aAttach  := {}
	Local _nX:=1
	Local _cCaminho := ''
	Local cMsg		:= ""
	Private aRet		:= {}

	aAdd(aParamBox,{1,"Pré-desconto"		,cPreDes	,"@!","","ZZV","",0,.T.})
	aAdd(aParamBox,{1,"Cliente"				,cCliente	,"@!","","SA1","",0,.T.})
	aAdd(aParamBox,{1,"Loja"				,cLoja		,"@!","","","",0,.T.})

	If !ParamBox(aParamBox,"Selecione a regra",@aRet,,,,,,,,.f.)
		Return
	Endif

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	If !DbSeek(xFilial("SA1")+MV_PAR02+MV_PAR03)
		MsgAlert("Atenção, cliente não encontrado, verifique")
		Return
	EndIf

	DbSelectArea("ZZV")
	ZZV->(DbSetOrder(1))
	ZZV->(DbGoTop())
	If !ZZV->(DbSeek(xFilial("ZZV")+MV_PAR01))
		MsgAlert("Atenção, pré-desconto não encontrado, verifique")
		Return
	EndIf

	_cCopia	:= ZZV->ZZV_COPIA
	_cCod	:= GetSXENum("ZZV","ZZV_COD")

	ZZV->(RecLock("ZZV",.T.))
	ZZV->ZZV_FILIAL	:= xFilial("ZZV")
	ZZV->ZZV_COD    := _cCod
	ZZV->ZZV_DTEMIS := Date()
	ZZV->ZZV_CLIENT := SA1->A1_COD
	ZZV->ZZV_LOJA	:= SA1->A1_LOJA
	ZZV->ZZV_NOMECL := SA1->A1_NOME
	ZZV->ZZV_GRPVEN	:= SA1->A1_ATIVIDA
	ZZV->ZZV_SOLIC  := CUSERNAME
	ZZV->ZZV_VEND1  := SA1->A1_VEND
	ZZV->ZZV_NVEND1 := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME")
	ZZV->ZZV_SUPER 	:= Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_SUPER")
	ZZV->ZZV_NSUPER	:= Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_SUPER"),"A3_NOME")
	ZZV->ZZV_CODVEN	:= Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_COD")
	ZZV->ZZV_COPIA	:= _cCopia
	ZZV->ZZV_STATUS	:= "0"
	ZZV->(MsUnLock())
	ZZV->(ConfirmSX8())
	DbSelectArea("ZZX")
	ZZX->(DbSetOrder(1))
	ZZX->(DbGoTop())
	ZZX->(DbSeek(xFilial("ZZX")+MV_PAR01))

	While ZZX->(!Eof()) .And. ZZX->ZZX_COD==MV_PAR01
		AADD(_aItens,{ZZX->ZZX_ITEM,ZZX->ZZX_PROD,ZZX->ZZX_NOMPRD,ZZX->ZZX_GRUPO,ZZX->ZZX_NOMGRP,ZZX->ZZX_PERCEN})
		ZZX->(DbSkip())
	EndDo

	For _nX:=1 To Len(_aItens)

		ZZX->(RecLock("ZZX",.T.))
		ZZX->ZZX_FILIAL	:= xFilial("ZZX")
		ZZX->ZZX_COD	:= _cCod
		ZZX->ZZX_ITEM	:= _aItens[_nX][1]
		ZZX->ZZX_PROD	:= _aItens[_nX][2]
		ZZX->ZZX_NOMPRD	:= _aItens[_nX][3]
		ZZX->ZZX_GRUPO	:= _aItens[_nX][4]
		ZZX->ZZX_NOMGRP := _aItens[_nX][5]
		ZZX->ZZX_PERCEN	:= _aItens[_nX][6]
		ZZX->(MsUnLock())

	Next

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>Código: </b>'+Alltrim(_cCod)+'<br><b>Cliente: </b>'+Alltrim(ZZV->ZZV_NOMECL)+'<br>'
	cMsg += '</body></html>'

	If !U_STMAILTES(GetMv("ST_MAILPDE"),"","Novo pré-desconto: "+_cCod,cMsg,_aAttach,_cCaminho)
		VtAlert("Problemas no envio de email!")
	EndIf

	MsgAlert("Pré-desconto :"+_cCod+" criado com sucesso!")

Return()

User Function STZZDTRV()

	Local _dDtRev  := ZZV->ZZV_DTREV //Date() //dtoc(ZZV->ZZV_DTREV)
	Local _nOpc	 := 0
	Local _oDlg
	Local lHasButton := .T.
	Private _oSay
	Private _oTGet
	Private _oTButCon
	Private _oTButFec

	DEFINE MSDIALOG _oDlg TITLE "Atualizar Data de Revisão - " FROM 000, 000  TO 150, 330 COLORS 0, 16777215 PIXEL

	_oSay	:= TSay():New(010,010,{||'Data de Revisão:'},_oDlg,,,,,,.T.,,,060,20)
	_oTGet := TGet():New( 020, 010, { | u | If( PCount() == 0, _dDtRev, _dDtRev := u ) },_oDlg,150,009,"@D",,0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"_dDtRev",,,,lHasButton  )

	_oTButCon:= TButton():New( 050, 070, "Confirmar" ,_oDlg,{|| _nOpc := 1,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButFec:= TButton():New( 050, 120, "Fechar",_oDlg,{|| _nOpc := 0,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc == 1

		DbSelectArea("ZZV")
		RecLock("ZZV",.f.)
		ZZV->ZZV_DTREV := _dDtRev
		MsUnLock("ZZV")

	EndIf

Return()

