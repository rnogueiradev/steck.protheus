#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} FINALEG

Legenda para identificar os titulos bloqueados

@type function
@author Everson Santana
@since 04/12/18
@version Protheus 12 - Financeiro

@history ,Chamado 006559 ,

/*/

User Function FINALEG()

	LOCAL aAreaAnt := GETAREA("SE2")
	Local nReg     := PARAMIXB[1]
	Local cAlias   := PARAMIXB[2]
	Local uRetorno := {}
	Local lPrjCni 	:= ValidaCNI()
	Local _FinAprov := GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprovação de Titulos
	Local aLegenda := {}

	//If _FinAprov

		If cAlias = "SE1"

			aLegenda		:= {{"BR_VERDE", 	"Titulo em aberto" },;	//1.  "Titulo em aberto"
			{"BR_AZUL"		,"Baixado parcialmente" },;	//2.  "Baixado parcialmente"
			{"BR_VERMELHO"	,"Titulo Baixado" },;	//3.  "Titulo Baixado"
			{"BR_PRETO"		,"Titulo em Bordero" },;	//4.  "Titulo em Bordero"
			{"BR_BRANCO"	,"Adiantamento com saldo" },;	//5.  "Adiantamento com saldo"
			{"BR_CINZA"		,"Titulo baixado parcialmente e em bordero" },; //6. "Titulo baixado parcialmente e em bordero"
			{"BR_VERDE_ESCURO", "Titulo Protestado"}}  // "Titulo Protestado"
		Else

			aLegenda := {	{"BR_VERDE"    		, "Titulo em aberto"       },;					//1. "Titulo em aberto"
			{"BR_AZUL"     		, "Baixado parcialmente"   },;					//2. "Baixado parcialmente"
			{"BR_VERMELHO" 		, "Titulo baixado"         },;					//3. "Titulo Baixado"
			{"BR_PRETO"    		, "Titulo em bordero"      },;					//4. "Titulo em Bordero"
			{"BR_BRANCO"   		, "Adiantamento com saldo" },; 					//5. "Adiantamento com saldo"
			{"BR_CINZA"			, "Titulo baixado parcialmente e em bordero" },;//6. "Titulo baixado parcialmente e em bordero"
			{"BR_MARROM"		, "Adiantamento de Imp. Bx. com saldo"},; 		//7. "Adiantamento de Imp. Bx. com saldo"
			{"BR_PINK"			, "Titulo Bloqueado Aguardando Liberação"},;	//8. "Titulo Bloqueado Aguardando Liberação"
			{"BR_VIOLETA"		, "Titulo Rejeitado"},;							//9. "Titulo Rejeitado"
			{"BR_VERDE_ESCURO"	, "Titulo Liberado"},;						//10. "Titulo Liberado"
			{"BR_MARRON_OCEAN"	, "Titulo Aguardando Classificação"} ,;			//11. "Titulo Aguardando Classificação"
			{"BR_AZUL_CLARO"	, "Titulo Aguardando Aprovação do Financeiro"},;	//12. "Titulo Aguardando Aprovação do Financeiro"
			{"BR_PRETO_0"		, "Titulo Aguardando Aprovação Multas/Juros"}}	//13. "Titulo Aguardando Aprovação Multas/Juros"

		EndIf

		If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
			uRetorno := {}
			If cAlias = "SE1"

				If cPaisLoc == "MEX" .And. X3Usado("ED_OPERADT")
					Aadd(aLegenda, {"BR_PINK"	, "Adiantamento gerado por Nota Fiscal"}) //7.  "Adiantamento gerado por Nota Fiscal"
					Aadd(aLegenda, {"BR_LARANJA", "Titulo com operacão de adiantamento"}) //8.  "Titulo com operacão de adiantamento"
				EndIf
				
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) > 0 .AND. EMPTY(E1_BAIXA) .AND. Empty(E1_NUMBOR) .AND. E1_SITUACA <> "F"', aLegenda[1][1] } ) //Titulo em aberto
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) = 0 '													, aLegenda[3][1]				} ) //"Titulo Baixado"
				Aadd(uRetorno, { '!Empty(E1_NUMBOR) .and.(ROUND(E1_SALDO,2) # ROUND(E1_VALOR,2))'			, aLegenda[6][1]				} ) //"Titulo baixado parcialmente e em bordero"
				Aadd(uRetorno, { 'E1_TIPO == "'+MVRECANT+'".and. ROUND(E1_SALDO,2) > 0 .And. !FXAtuTitCo() '	, aLegenda[5][1]				} ) //"Adiantamento com saldo"
				Aadd(uRetorno, { '!Empty(E1_NUMBOR)  '														, aLegenda[4][1]				} ) //"Titulo em Bordero"
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) + ROUND(E1_SDACRES,2) # ROUND(E1_VALOR,2) + ROUND(E1_ACRESC,2) .And. !FXAtuTitCo() '		, aLegenda[2][1]				} ) //"Baixado parcialmente"
				Aadd(uRetorno, { 'ROUND(E1_SALDO,2) == ROUND(E1_VALOR,2) .and. E1_SITUACA == "F" '			, aLegenda[7][1]	} ) //"Titulo Protestado"

				If cPaisLoc == "MEX" .And. X3Usado("ED_OPERADT")
					Aadd(uRetorno, {	'E1_ORIGEM == "MATA467N" .And. ROUND(E1_SALDO,2) > 0 .And. FXAtuTitCo() '									, aLegenda[7][1] } )
					Aadd(uRetorno, {	'E1_ORIGEM == "FINA087A" .And. ROUND(E1_SALDO,2) > 0 .And. FXAtuTitCo() .And. E1_TIPO == "'+MVRECANT+'"'	, aLegenda[8][1] } )
				EndIf

			Else
				If lPrjCni
					IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")
						Aadd(aLegenda, {"BR_AMARELO", "Titulo aguardando liberacao"})  //"Titulo aguardando liberacao"
						Aadd(uRetorno, { ' EMPTY(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0 .AND. E2_XBLQ = " "', aLegenda[Len(aLegenda)][1] } )
					EndIf
				Else
					IF GetMv("MV_CTLIPAG")
						Aadd(aLegenda, {"BR_AMARELO", "Titulo aguardando liberacao"})	//"Titulo aguardando liberacao"
						Aadd(uRetorno, { ' !( SE2->E2_TIPO $ MVPAGANT ).and. EMPTY(E2_DATALIB) .AND. (SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE) > GetMV("MV_VLMINPG") .AND. E2_SALDO > 0 .AND. E2_XBLQ = " "', aLegenda[Len(aLegenda)][1] } )
					EndIf
				EndIf

				Aadd(aLegenda, {"BR_LARANJA", "Adiantamento de Viagem sem taxa"}) //"Adiantamento de Viagem sem taxa"
				Aadd(uRetorno, { ' (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677") .and. SE2->E2_MOEDA > 1 .AND. SE2->E2_TXMOEDA == 0 .AND. SE2->E2_SALDO > 0 .AND. E2_XBLQ = " "', aLegenda[Len(aLegenda)][1] } )


				//Validação para uso do documento hábil - SIAFI
				If FinUsaDH()
					Aadd(aLegenda,{"BR_VIOLETA","Titulo Vinculado a Docto Hábil"}) // "Titulo Vinculado a Docto Hábil"
					Aadd(uRetorno, { 'ROUND(E2_SALDO,2) > 0 .And. !EMPTY(E2_DOCHAB) .AND. E2_XBLQ = " "'	, aLegenda[Len(aLegenda)][1]				} ) //"Titulo relacionado ao Documento hábil"
				Endif

				Aadd(uRetorno, { 'E2_TIPO $ "INA/'+MVTXA+'" .and. ROUND(E2_SALDO,2) > 0 .And. E2_OK == "TA" .AND. E2_XBLQ = " "  ', aLegenda[7][1] } )
				Aadd(uRetorno, { 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0 .AND. E2_XBLQ = " "', aLegenda[5][1] } )
				Aadd(uRetorno, { 'ROUND(E2_SALDO,2) + ROUND(E2_SDACRES,2)  = 0 .AND. E2_XBLQ = " " ', aLegenda[3][1] } )
				Aadd(uRetorno, { '!Empty(E2_NUMBOR) .and.(ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)) .AND. E2_XBLQ = " " ', aLegenda[6][1] } )
				Aadd(uRetorno, { '!Empty(E2_NUMBOR) .AND. E2_XBLQ = " " ', aLegenda[4][1] } )
				Aadd(uRetorno, { 'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2) .AND. E2_XBLQ = " "', aLegenda[2][1] } )
				Aadd(uRetorno, { 'E2_XBLQ = "1"', aLegenda[8][1] } ) //Bloqueado
				Aadd(uRetorno, { 'E2_XBLQ = "2"', aLegenda[9][1] } ) //Rejeitado
				Aadd(uRetorno, { 'E2_XBLQ = "3"', aLegenda[10][1] } ) //Aprovado
				Aadd(uRetorno, { 'E2_XBLQ = "4"', aLegenda[11][1] } ) //Classificação
				Aadd(uRetorno, { 'E2_XBLQ = "5"', aLegenda[12][1] } ) //Aguardando Aprovação do Financeir para titulos PA
				Aadd(uRetorno, { 'E2_XBLQ = "6"', aLegenda[13][1] } ) //Titulo Aguardando Aprovação Multas/Juros
				Aadd(uRetorno, { 'E2_XBLQ = " "', aLegenda[1][1] } ) //Titulo em aberto

			Endif
		Else
			If cAlias = "SE1"
				If cPaisLoc == "MEX" .And. X3Usado("ED_OPERADT")
					Aadd(aLegenda, {"BR_PINK"	,"Adiantamento gerado por Nota Fiscal"}) //7.  "Adiantamento gerado por Nota Fiscal"
					Aadd(aLegenda, {"BR_LARANJA","Titulo com operacão de adiantamento"}) //8.  "Titulo com operacão de adiantamento"
				EndIf
				//Aadd(aLegenda,{"BR_AMARELO", "Titulo Protestado"}) //"Titulo Protestado"
			Else
				If lPrjCni
					IF !Empty(GetMv("MV_APRPAG")) .or. GetMv("MV_CTLIPAG")
						Aadd(aLegenda, {"BR_AMARELO",  "Titulo aguardando liberacao"})		//"Titulo aguardando liberacao"
					EndIf
				Else
					IF GetMv("MV_CTLIPAG")
						Aadd(aLegenda, {"BR_AMARELO",  "Titulo aguardando liberacao"})		//"Titulo aguardando liberacao"
					EndIf
				Endif
				//Validação para uso do documento habil (SIAFI)
				If FinUsaDH()
					Aadd(aLegenda,{"BR_VIOLETA","Titulo Vinculado a Docto Hábil"}) // "Titulo Vinculado a Docto Hábil"
				Endif
			EndIf
			BrwLegenda(cCadastro, "Legenda", aLegenda)		//"Legenda"
		Endif
	//EndIf

	RESTAREA(aAreaAnt)

Return uRetorno