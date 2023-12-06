#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CR    chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT13     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Expedição                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT13()

	Local   oReport
	Private cPerg 			:= "RFAT13"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.

	PutSx1( cPerg, "01","Data?"			,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Data?"			,"","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Pedido de:"    ,"","","mv_ch3","C",6,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Pedido Até:"   ,"","","mv_ch4","C",6,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "05","Os de:"        ,"","","mv_ch5","C",6,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "06","Os Até:"       ,"","","mv_ch6","C",6,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "07","Com NF:"		,"","","mv_ch7","C",1,0,0,"C","","","","","mv_par07","1-SIM","","","","2-NAO","","","","3-TODOS","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection
	Pergunte(cPerg,.t.)

	oReport := TReport():New(cPerg,"RELATÓRIO EXPEDIÇÃO",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório EXPEDIÇÃO .")



	oSection := TRSection():New(oReport,"Análise  Expedição",{"SC5"})

	TRCell():New(oSection,"Pedido"		,,"Pedido"				,					,06,.F.,)
	TRCell():New(oSection,"Os"			,,"Os"					,					,06,.F.,)
	TRCell():New(oSection,"Separador"	,,"Separador"			,					,26,.F.,)
	TRCell():New(oSection,"Volumes"		,,"Volumes"				,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"Status"		,,"Status"				,					,15,.F.,)
	//TRCell():New(oSection,"TIPO"		,,"Tipo"				,					,10,.F.,)//Chamado 007873 - Everson Santana
	TRCell():New(oSection,"Cliente"		,,"Cliente"				,					,06,.F.,)
	TRCell():New(oSection,"Loja"		,,"Loja"				,					,02,.F.,)
	TRCell():New(oSection,"Nome"		,,"Nome"				,					,40,.F.,)
	TRCell():New(oSection,"Emissao"		,,"Data de emissão"		,					,10,.F.,)
	TRCell():New(oSection,"TipoCli"		,,"TipoCli"				,					,20,.F.,) // Jefferson
	TRCell():New(oSection,"Transp"		,,"Transp"				,					,06,.F.,)
	TRCell():New(oSection,"Romaneio"	,,"Romaneio"			,					,09,.F.,)
	TRCell():New(oSection,"Nf"			,,"Nf"					,					,09,.F.,)
	TRCell():New(oSection,"EmissaoNF"	,,"Emissao NF"			,					,10,.F.,)
	TRCell():New(oSection,"Bloq"		,,"Bloq"				,					,22,.F.,)
	TRCell():New(oSection,"Refatur"		,,"Refaturamento Blq?"	,"@!"				,01		)
	TRCell():New(oSection,"Entrega"		,,"Entrega"				,					,03,.F.,)
	TRCell():New(oSection,"Frete"		,,"Frete"				,					,10,.F.,)
	TRCell():New(oSection,"Vendedor"	,,"Vendedor"			,					,50,.F.,)
	TRCell():New(oSection,"Cubag"		,,"Cubagem"				,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"ResLiq"		,,"Vlr Res Liq"			,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"Valor"		,,"Vlr Bruto NF"		,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"TotPes"		,,"Peso total"			,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"QtdLin"		,,"Qtde Linhas"			,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"QtdPec"		,,"Qtde Peças"			,"@E 99,999,999.99"	,14		)
	TRCell():New(oSection,"Embalador"	,,"Embalador"			,"@!"				,30		)
	TRCell():New(oSection,"ALERTFAT"	,,"Alerta Fatur"		,"@!"				,40		)
	TRCell():New(oSection,"C5_XOBSVEN"	,,"Observação de Vendas","@!"				,40		)
	TRCell():New(oSection,"ALERTFIN"	,,"Alerta Finan."		,"@!"				,40		)
	TRCell():New(oSection,"XDTSERA"		,,"Status Serasa"		,					,10,.F.,)//Chamado 007855 - Everson Santana
	TRCell():New(oSection,"DTEMIS"		,,"Data Emissão OS"		,					,10,.F.,)
	TRCell():New(oSection,"HREMIS"		,,"Hora Emissão OS"		,					,10,.F.,)
	
	TRCell():New(oSection,"DTFINS"		,,"Data fim separação"	,					,10,.F.,)
	TRCell():New(oSection,"HRFINS"		,,"Hora fim separação"	,					,10,.F.,)
	
	
	TRCell():New(oSection,"DTFIMS"		,,"Data Final Embalagem",					,10,.F.,)
	TRCell():New(oSection,"HRFIMS"		,,"Hora Final Embalagem",					,10,.F.,)
	TRCell():New(oSection,"DTLIBF"		,,"Data Lib.Financeira"	,					,10,.F.,)
	TRCell():New(oSection,"HRLIBF"		,,"Hora Lib.Financeira"	,					,10,.F.,)	
	TRCell():New(oSection,"ZDTCLI"		,,"Dt. Cliente"			,					,10,.F.,)//Chamado 007840 - Everson Santana
	TRCell():New(oSection,"XORDEM"		,,"Ordem Compra"		,					,30,.F.,)//Chamado 007873 - Everson Santana
	TRCell():New(oSection,"VLRLIQ"		,,"Vlr Liquido"			,"@E 99,999,999.99"	,14		)//Ticket 20191128000028
	TRCell():New(oSection,"UFCLI"		,,"UF Cadastro"		,					,02,.F.,)//20230824010793

	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("DA1")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection		:= oReport:Section(1)
	Local oSection1		:= oReport:Section(1)
	Local nX			:= 0
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local cQuery1 		:= ""
	Local cAlias1 		:= "QRYTEMP10"
	Local aDados[2]
	Local aDados1[99]
	Local _nCubag		:= 0
	Local _nVlrRes		:= 0
	Local _nPesTot		:= 0
	Local _nSerasa		:= 0
	Local cArML			:= ""
	Local cEndML		:= ""

	oSection1:Cell("Pedido")    :SetBlock( { || aDados1[01] } )
	oSection1:Cell("Os")		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Volumes")	:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Status")	:SetBlock( { || aDados1[04] } )
	//oSection1:Cell("TIPO")		:SetBlock( { || aDados1[36] } )
	oSection1:Cell("Cliente")	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Loja")		:SetBlock( { || aDados1[38] } )
	oSection1:Cell("Nome")		:SetBlock( { || aDados1[37] } )
	oSection1:Cell("Transp")	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("Romaneio")	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Nf")   		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("EmissaoNF")	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("Bloq")		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Entrega")	:SetBlock( { || aDados1[11] } )
	oSection1:Cell("Frete")		:SetBlock( { || aDados1[12] } )
	oSection1:Cell("Vendedor")	:SetBlock( { || aDados1[13] } )
	oSection1:Cell("Valor")		:SetBlock( { || aDados1[14] } )
	oSection1:Cell("Cubag")		:SetBlock( { || aDados1[15] } )
	oSection1:Cell("ResLiq")	:SetBlock( { || aDados1[16] } )
	oSection1:Cell("TotPes")	:SetBlock( { || aDados1[17] } )
	oSection1:Cell("Separador") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("TipoCli")   :SetBlock( { || aDados1[19] } )  //Jefferson
	oSection1:Cell("QtdLin")	:SetBlock( { || aDados1[20] } )
	oSection1:Cell("QtdPec")	:SetBlock( { || aDados1[21] } )
	oSection1:Cell("Embalador")	:SetBlock( { || aDados1[22] } )
	oSection1:Cell("Emissao")  	:SetBlock( { || aDados1[23] } )
	oSection1:Cell("Refatur")   :SetBlock( { || aDados1[24] } )
	oSection1:Cell("ALERTFAT")	:SetBlock( { || aDados1[25] } )
	oSection1:Cell("ALERTFIN")	:SetBlock( { || aDados1[26] } )
	oSection1:Cell("DTEMIS")	:SetBlock( { || aDados1[27] } )
	oSection1:Cell("HREMIS")	:SetBlock( { || aDados1[28] } )
	oSection1:Cell("DTFIMS")	:SetBlock( { || aDados1[29] } )
	oSection1:Cell("HRFIMS")	:SetBlock( { || aDados1[30] } )

	oSection1:Cell("DTFINS")	:SetBlock( { || aDados1[40] } )
	oSection1:Cell("HRFINS")	:SetBlock( { || aDados1[41] } )


	oSection1:Cell("DTLIBF")	:SetBlock( { || aDados1[31] } )
	oSection1:Cell("HRLIBF")	:SetBlock( { || aDados1[32] } )
	oSection1:Cell("XDTSERA")	:SetBlock( { || aDados1[33] } )
	oSection1:Cell("ZDTCLI")	:SetBlock( { || aDados1[34] } )
	oSection1:Cell("XORDEM")	:SetBlock( { || aDados1[35] } )
	oSection1:Cell("VLRLIQ")	:SetBlock( { || aDados1[39] } )
	oSection1:Cell("C5_XOBSVEN")	:SetBlock( { || aDados1[42] } )
	oSection1:Cell("UFCLI")		:SetBlock( { || aDados1[43] } )

	
	oReport:SetTitle("Análise Expedição")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	rptstatus({|| strelquer( ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			/*    //GIOVANI ZAGO ESTE TRECHO DEIXOU O RELATORIO LENTO (PISOU NA BOLA RE...KKKKKK)
			CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
			CB6->(DbSeek(xFilial('CB6')+(cAliasLif)->OS))

			While CB6->(!Eof() .and. CB6_FILIAL+CB6_XORDSE == xFilial('CB6')+(cAliasLif)->OS)

			_nCubag	 += Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_VOLUME") //Renato Nogueira - Chamado 000214

			_nPesTot +=	CB6->CB6_XPESO

			CB6->(DbSkip())

			EndDo

			cQuery1 := " SELECT SUM(C6_ZVALLIQ/C6_QTDVEN*CB8_QTDORI) RESLIQ "
			cQuery1 += " FROM " +RetSqlName("CB8")+ " CB8 "
			cQuery1 += " LEFT JOIN " +RetSqlName("SC6")+ " C6 "
			cQuery1 += " ON CB8_FILIAL=C6_FILIAL AND CB8_PEDIDO=C6_NUM AND CB8_ITEM=C6_ITEM AND C6_PRODUTO=CB8_PROD "
			cQuery1 += " WHERE CB8.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND CB8_ORDSEP='"+(cAliasLif)->OS+"' AND CB8_FILIAL='"+(cAliasLif)->FILIAL+"' "

			If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

			dbSelectArea(cAlias1)
			(cAlias1)->(dbGoTop())
			*/
			cArML	:= ""
			cEndML	:= ""
			xNF     := ""
			xEMINF  := ""
			//PutSx1( cPerg, "07","Com NF:"		,"","","mv_ch7","C",1,0,0,"C","","","","","mv_par07","1-SIM","","","","2-NAO","","","","3-TODOS","","","","","","","")
			//=============================================================================================================================================//
			//TRATATIVA PARA QUANDO PEDIDO FOR 'MERCADO LIVRE'
			//FR - 28/07/2023 - Flávia Rocha - Sigamat Consultoria

			//CONTEXTO: PEDIDOS E-COMMERCE NÃO SERÃO FATURADOS INTERNAMENTE, POIS:

			//O FATURAMENTO É REALIZADO PELO INPUT DE PEDIDO E GERAÇÃO DE NOTA PELA PLATAFORMA EXTERNA;
			//ESSE PEDIDO É COLOCADO DE FORMA AUTOMATIZADA CONSIDERANDO O ARMAZÉM 06;
			//ESSE PEDIDO É GERADO NOTA DE FORMA AUTOMATIZADA, PUXANDO OS MATERIAIS QUE EM TESE ESTARIAM NO 06;
			//EM PARALELO, É GERADO UM OUTRO PEDIDO DE VENDA MANUALMENTE PELA ÁREA DE NEGÓCIOS, ESSE PEDIDO É COLOCADO NO ARMAZÉM 03;
			//ESSE NOVO PEDIDO, NÃO SERÁ FATURADO, MAS APENAS SEPARADO E EMBALADO;
			//AO FINALIZAR A EMBALAGEM, OS MATERIAIS SERÃO TRANSFERIDOS VIA EXECAUTO DO ARMAZÉM 03 PARA 06 
			//(PARA SUPRIR O SALDO DO PEDIDO COLOCADO PELA PLATAFORMA, QUE É COLOCADO NO ARMAZÉM 06).
			//O PEDIDO COLOCADO INTERNAMENTE QUE É FEITA TRANSFERÊNCIA DE FORMA AUTOMATIZADA, ESSE PEDIDO APÓS FINALIZADA A TRANSFERÊNCIA, É "CARIMBADA"
			//A "NOTA FISCAL", COM O DIZER "MERCLIVRE" NO CAMPO C5_NOTA, e CAMPO C5_ZFATBLQ RECEBE O CONTEÚDO "1" , INDICANDO QUE O PEDIDO FOI ENCERRADO.
				
			//A IDÉIA AQUI É BUSCAR PELO CLIENTE, SE ELE POSSUI NOS CAMPOS A1_XAMZTRF e A1_XENDTRF, se estes CAMPOS NÃO ESTIVEREM VAZIOS;
			//ESTES CAMPOS SE REFEREM AO ARMAZÉM E ENDEREÇO, RESPECTIVAMENTE;
			//QUANDO PREENCHIDOS, OS PEDIDOS DESTE CLIENTE NÃO SÃO FATURADOS, MAS SIM, TRANSFERIDOS PELO PROCESSO DE EMBALAGEM.
			//ESTE É O SINALIZADOR QUE PRECISAMOS PARA BUSCAR O "NÚMERO DA NF" PARA EXIBIR NO RELATÓRIO
			//==============================================================================================================================================//
				
			DbSelectArea("SA1")
			If FieldPos("A1_XAMZTRF") > 0 .and. FieldPos("A1_XENDTRF") > 0						
				//CAMPO ARMAZÉM P/ TRANSFERÊNCIA
				cArML := Posicione("SA1",1,xFilial("SA1") + (cAliasLif)->CLIENTE + (cAliasLif)->LOJA,"A1_XAMZTRF")
				//CAMPO ENDEREÇO P/ TRANSFERÊNCIA
				cEndML:= Posicione("SA1",1,xFilial("SA1") + (cAliasLif)->CLIENTE + (cAliasLif)->LOJA,"A1_XENDTRF")		
				If !Empty(cArML)
					SC5->(DBSETORDER(1))
					SC5->(Dbseek( xFilial("SC5") + (cAliasLif)->PEDIDO) )
					xNF	   := SC5->C5_NOTA
					xEMINF := StoD(Substr((cAliasLif)->DTHRFIMS,01,08)) //a data final da embalagem conto como data emissão da "nf"
				else
					xNF	    :=	(cAliasLif)->NF 
					xEMINF	:=	(cAliasLif)->EMISSAONF						
				Endif 
			Else 
				xNF	    :=	(cAliasLif)->NF 
				xEMINF	:=	(cAliasLif)->EMISSAONF					
				//caso não faça parte do conceito explicado acima (MERCADO LIVRE), imprime normalmente o conteúdo recebido do campo CB7_NOTA
			Endif 
			//TRATATIVA PARA QUANDO PEDIDO FOR 'MERCADO LIVRE'
			//FR - 28/07/2023 - Flávia Rocha - Sigamat Consultoria
			//==============================================================================================================================================//
			dbSelectArea(cAliasLif)
			//If  Mv_Par07 = 1 .And.  !(Empty(Alltrim((cAliasLif)->NF))) .Or. Mv_Par07 = 2 .And.  Empty(Alltrim((cAliasLif)->NF)) .Or. Mv_Par07 = 3
			If  ( Mv_Par07 = 1 .And.  !(Empty(Alltrim(xNF))) ) .Or. (( Mv_Par07 = 2  .And.  Empty(Alltrim(xNF)) ).Or. Mv_Par07 = 3)
				
				_nCubag	 := (cAliasLif)->XCUBA
				_nPesTot := (cAliasLif)->XPESO
				_nVlrRes := (cAliasLif)->RESLIQ

				aDados1[01]	:=	(cAliasLif)->PEDIDO
				aDados1[02]	:=	(cAliasLif)->OS
				aDados1[03]	:=	(cAliasLif)->VOLUME
				aDados1[04]	:=	(cAliasLif)->STATUSX
				aDados1[05]	:=	(cAliasLif)->CLIENTE
				aDados1[38]	:=	(cAliasLif)->LOJA
				aDados1[37]	:=	(cAliasLif)->NOME				
				aDados1[06]	:= 	(cAliasLif)->TRANSP
				aDados1[07]	:=	(cAliasLif)->ROMANEIO
				aDados1[08]	:=	xNF 
				aDados1[09]	:=	xEMINF
				aDados1[18]	:=	(cAliasLif)->SEPARADOR

				//F=Cons.Final;L=Prod.Rural;R=Revendedor;S=Solidario;X=Exportacion/Importacion

				If (cAliasLif)->TIPOCLI = "X"
					aDados1[19] :=  "EXPORTACAO"
				ElseIf	(CAliasLif)->TIPOCLI = "F"
					aDados1[19] := "Cons.Final"
				ElseIf  (CAliasLif)->TIPOCLI = "L"
					aDados1[19] := "Prod.Rural"
				ElseIf (CAliasLif)->TIPOCLI = "R"
					aDados1[19] := "Revendedor"
				ElseIf   (CAliasLif)->TIPOCLI = "S"
					aDados1[19] := "Solidario"
				EndIf

				If (CAliasLif)->A1_XBLQFIN == "1"
					aDados1[26] := "Cliente bloqueado Fin."
				Else
					aDados1[26] := ' '
				EndIf

				aDados1[23]	:= DTOC(STOD((CAliasLif)->EMISSAO))
				aDados1[24]	:= IIf((CAliasLif)->REFATUR == "1","S","N")
				aDados1[25]	:= (CAliasLif)->ALERTFAT

				aDados1[20]	:= (CAliasLif)->QTDLINHAS
				aDados1[21]	:= (CAliasLif)->QTDPECAS
				aDados1[22]	:= (CAliasLif)->EMBALADOR

				If "LIBERADO" $ (cAliasLif)->BLOQVISTA .And. "LIBERADO" $ (cAliasLif)->BLOQTRANSP
					aDados1[10]	:=  "LIBERADO"
				ElseIf !("LIBERADO" $ (cAliasLif)->BLOQVISTA) .And. "LIBERADO" $ (cAliasLif)->BLOQTRANSP
					aDados1[10]	:=  (cAliasLif)->BLOQVISTA
				ElseIf "LIBERADO" $ (cAliasLif)->BLOQVISTA .And. !("LIBERADO" $ (cAliasLif)->BLOQTRANSP)
					aDados1[10]	:=  (cAliasLif)->BLOQTRANSP
				EndIf
				aDados1[11]	:=	(cAliasLif)->ENTREGA
				aDados1[12]	:= 	(cAliasLif)->FRETE
				aDados1[13]	:= 	(cAliasLif)->NVEND
				aDados1[14]	:= 	(cAliasLif)->TOTAL
				aDados1[15]	:= 	_nCubag

				aDados1[27]	:= 	StoD((cAliasLif)->DTEMIS)
				aDados1[28]	:= 	Alltrim((cAliasLif)->HREMIS)+":00"
				aDados1[29]	:= 	StoD(Substr((cAliasLif)->DTHRFIME,01,08))
				aDados1[30]	:= 	Substr((cAliasLif)->DTHRFIME,09,08)
				aDados1[31]	:= 	StoD(Substr((cAliasLif)->DTHRLIBF,01,08))
				aDados1[32]	:= 	Substr((cAliasLif)->DTHRLIBF,09,08)

				_nSerasa := 	dDataBase - stod((cAliasLif)->XDTSERA) 

				If _nSerasa > 90
					aDados1[33]	:= 	"Bloqueado"
				Else
					aDados1[33]	:= 	"Liberado"
				EndIf 

				aDados1[34]	:= 	Stod((cAliasLif)->ZDTCLI)
				aDados1[35]	:= 	(cAliasLif)->XORDEM
				//aDados1[36]	:= 	(cAliasLif)->TIPO

				If (cAliasLif)->TOTAL > 0
					aDados1[16]	:=	0
				Else
					aDados1[16]	:=	_nVlrRes
				EndIf

				aDados1[17]	:=	_nPesTot
				aDados1[39] := (cAliasLif)->VALIQ 
				
				aDados1[40]	:= 	StoD(Substr((cAliasLif)->DTHRFIMS,01,08))
				aDados1[41]	:= 	Substr((cAliasLif)->DTHRFIMS,09,08)
				aDados1[42]	:= 	Alltrim((cAliasLif)->C5_XOBSVEN)
				aDados1[43]	:= 	Alltrim((cAliasLif)->UFCLI)
				
				
				_nCubag := _nVlrRes := _nPesTot := 0

				oSection1:PrintLine()
				aFill(aDados1,nil)

			EndIf

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

//SELECIONA OS PRODUTOS
Static Function strelquer()

	Local cQuery     := ""

	cQuery += " WITH EMB AS "+CR
	cQuery += " ( "+CR

	cQuery += " SELECT "+CR
	cQuery += " SC5.C5_NUM "+CR
	cQuery += ' "PEDIDO", '+CR
	
	cQuery += " (SELECT COUNT(*) QTDLINHAS FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_=' ' AND CB8.CB8_FILIAL=CB7.CB7_FILIAL AND CB8.CB8_ORDSEP=CB7.CB7_ORDSEP) AS QTDLINHAS, "+CR
	cQuery += " (SELECT SUM(CB8_QTDORI) QTDPECAS  FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_=' ' AND CB8.CB8_FILIAL=CB7.CB7_FILIAL AND CB8.CB8_ORDSEP=CB7.CB7_ORDSEP) AS QTDPECAS, "+CR
	cQuery += " (SELECT CB1_NOME NOMEEMB FROM "+RetSqlName("CB6")+" CB6 LEFT JOIN "+RetSqlName("CB1")+" CB1 ON CB1.CB1_FILIAL=CB6.CB6_FILIAL AND CB1.CB1_CODOPE=CB6.CB6_XOPERA WHERE CB1.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' ' AND CB7.CB7_FILIAL=CB6.CB6_FILIAL AND CB7.CB7_ORDSEP=CB6.CB6_XORDSE AND ROWNUM=1) AS EMBALADOR, "+CR
	cQuery += ' SA1.A1_XDTSERA ' +CR//Chamado 007855 - Everson Santana
	cQuery += ' "XDTSERA", '+CR  
	//cQuery += " (SELECT DISTINCT CASE WHEN Count(PA1_DOC) > 0 THEN 'PARCIAL' ELSE 'TOTAL' END FROM "+RetSqlName("PA1")+" WHERE SubStr(PA1_DOC,1,6) = SC5.C5_NUM AND D_E_L_E_T_ = ' ') as TIPO, "+CR 
	cQuery += ' SC5.C5_ZDTCLI '+CR 
	cQuery += ' "ZDTCLI",  '+CR //Chamado 007840 - Everson Santana

	cQuery += ' SC5.C5_XORDEM '+CR
	cQuery += ' "XORDEM",  '+CR //Chamado 007873 - Everson Santana

	cQuery += ' SA1.A1_EST '+CR
	cQuery += ' "UFCLI",  '+CR //20230824010793 - Leandro Godoy


	cQuery += " SC5.C5_FILIAL "+CR
	cQuery += ' "FILIAL", '+CR
	cQuery += " SC5.C5_ZREFNF "+CR
	cQuery += ' "REFATUR", '+CR 
	cQuery += " CB7.CB7_ORDSEP "+CR
	cQuery += ' "OS", '+CR

	cQuery += " CB7.CB7_DTEMIS "+CR
	cQuery += ' "DTEMIS", '+CR
	cQuery += " CB7.CB7_HREMIS "+CR
	cQuery += ' "HREMIS", '+CR

	cQuery += " NVL((SELECT TRIM(CB1.CB1_NOME) FROM  "+RetSqlName("CB1")+" CB1 "+CR
	cQuery += " WHERE CB1.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB1.CB1_FILIAL= '"+xFilial("CB1")+"'" +CR
	cQuery += " AND CB1.CB1_CODOPE  = CB7.CB7_XOPEXP), ' ') "+CR
	cQuery += ' "SEPARADOR", '+CR

	cQuery += " (SELECT MAX(CB6_XDTFIN || CB6_XHFIN || ':00') "+CR
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "+CR
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB6_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"'" +CR
	cQuery += " AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "DTHRFIME", '+CR
	
	cQuery += " (SELECT MAX(CB8_XDTFIM || CB8_XHFIM || ':00') "+CR
	cQuery += " FROM "+RetSqlName("CB8")+" CB8 "+CR
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB8.CB8_FILIAL = CB7.CB7_FILIAL "+CR
	cQuery += " AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "DTHRFIMS", '+CR

	cQuery += " (SELECT COUNT(CB6_PEDIDO) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "+CR
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB6_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"'" +CR
	cQuery += " AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "VOLUME", '+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '0' THEN '0-Inicio' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '1' THEN '1-Separando' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '2' THEN '2-Sep.Final' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '3' THEN '3-Embalando' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '4' THEN '4-Emb.Final' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '8' THEN '8-Embarcado' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '9' THEN '9-Embarque Finalizado' ELSE 'SEM NUMERACAO' "+CR
	cQuery += " END END END END END END END "+CR
	cQuery += ' "STATUSX", '+CR
	cQuery += " SC5.C5_CLIENTE "+CR
	cQuery += ' "CLIENTE", '+CR

	cQuery += " SC5.C5_LOJACLI "+CR
	cQuery += ' "LOJA" , '+CR
	cQuery += " SC5.C5_XALERTF "+CR
	cQuery += ' "ALERTFAT" , '+CR
	cQuery += " SC5.C5_XOBSVEN , "+CR
	cQuery += " SA1.A1_NOME "+CR 
	cQuery += ' "NOME" , SA1.A1_XBLQFIN, '+CR
	cQuery += " SC5.C5_TRANSP "+CR
	cQuery += ' "COD.TRANSP", '+CR
	cQuery += " SC5.C5_TIPOCLI "+CR
	cQuery += ' "TIPOCLI" , '+CR
	cQuery += " SC5.C5_EMISSAO "+CR
	cQuery += ' "EMISSAO" , '+CR
	cQuery += " SC5.C5_VEND2 "+CR
	cQuery += ' "XVEND", '+CR
	cQuery += " NVL(SA4.A4_NOME,' ') "+CR
	cQuery += ' "TRANSP"  , '+CR
	cQuery += " SA3.A3_NOME "+CR
	cQuery += ' "NVEND"  , '+CR
	cQuery += " NVL((SELECT MAX(PD2_CODROM) FROM "+RetSqlName("PD2")+" PD2 "+CR
	cQuery += " WHERE PD2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND PD2.PD2_NFS    = CB7.CB7_NOTA "+CR
	cQuery += " AND PD2.PD2_SERIES = CB7.CB7_SERIE "+CR
	cQuery += " AND PD2.PD2_CLIENT    = SC5.C5_CLIENTE "+CR
	cQuery += " AND PD2.PD2_LOJCLI = SC5.C5_LOJACLI "+CR
	cQuery += " AND PD2.PD2_FILIAL = '"+xFilial("PD2")+"' ),' ') "+CR
	cQuery += ' "ROMANEIO" , '+CR
	cQuery += " CB7.CB7_NOTA "+CR
	cQuery += ' "NF", '+CR
	cQuery += " nvl((SELECT "+CR
	cQuery += " SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4) "+CR
	cQuery += " FROM "+RetSqlName("SF2")+"  SF2 "+CR
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SF2.F2_DOC   = CB7.CB7_NOTA "+CR
	cQuery += " AND SF2.F2_SERIE = CB7.CB7_SERIE "+CR
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'),'  /  /    ') "+CR
	cQuery += ' "EMISSAONF", '+CR
	cQuery += " CASE WHEN SC5.C5_CONDPAG = '501' AND SC5.C5_XLIBAVI <> 'S' THEN 'Bloqueado à Vista' ELSE 'LIBERADO' END "+CR
	cQuery += ' "BLOQVISTA", '+CR
	cQuery += "  CASE WHEN SC5.C5_TRANSP = ' '   THEN 'Transportadora em Branco' ELSE 'LIBERADO' END "+CR
	cQuery += ' "BLOQTRANSP", '+CR
	cQuery += " CASE WHEN SC5.C5_XTIPO ='1' THEN 'RETIRA' ELSE 'ENTREGA' END "+CR
	cQuery += ' "ENTREGA", '+CR
	cQuery += " CASE WHEN SC5.C5_TPFRETE ='F' THEN 'FOB' ELSE 'CIF' END "+CR
	cQuery += ' "FRETE", '+CR
	cQuery += " SC5.C5_CONDPAG "+CR
	cQuery += ' "COND", '+CR
	cQuery += " (SELECT E4_DESCRI FROM "+RetSqlName("SE4")+"  SE4 "+CR
	cQuery += " WHERE E4_CODIGO = SC5.C5_CONDPAG "+CR
	cQuery += " AND SE4.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SE4.E4_FILIAL = '"+xFilial("SE4")+"' ) "+CR
	cQuery += ' "DESCRI", '+CR
	cQuery += " (SELECT X5_DESCRI FROM "+RetSqlName("SX5")+"  SX5 " +CR
	cQuery += " WHERE SX5.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SX5.X5_TABELA = 'SX' " +CR
	cQuery += " AND SX5.X5_CHAVE = "+CR
	cQuery += " (SELECT DISTINCT SC6.C6_OPER FROM "+RetSqlName("SC6")+"  SC6 " +CR
	cQuery += " WHERE  C6_NUM = SC5.C5_NUM "+CR
	cQuery += " AND C6_FILIAL = SC5.C5_FILIAL "+CR
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SC6.C6_OPER <> '') "+CR
	cQuery += " AND SX5.X5_FILIAL = '"+xFilial("SX5")+"' ) "+CR
	cQuery += ' "VENDA", '+CR
	//valor total da nota
	cQuery += " nvl((SELECT "+CR
	cQuery += " F2_VALBRUT "+CR
	cQuery += " FROM "+RetSqlName("SF2")+"  SF2 "+CR
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SF2.F2_DOC   = CB7.CB7_NOTA "+CR
	cQuery += " AND SF2.F2_SERIE = CB7.CB7_SERIE "+CR
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'),0) "+CR
	cQuery += ' "TOTAL" '+CR
	//*******************************************************************************
	cQuery += ' ,NVL((SELECT SUM(C6_ZVALLIQ/C6_QTDVEN*CB8_QTDORI) RESLIQ '+CR
	cQuery += " FROM "+RetSqlName("CB8")+"  CB8 "+CR
	cQuery += " LEFT JOIN( SELECT * FROM "+RetSqlName("SC6")+" ) SC6 "+CR
	cQuery += ' ON CB8_FILIAL=C6_FILIAL '+CR
	cQuery += ' AND CB8_PEDIDO=C6_NUM '+CR
	cQuery += ' AND CB8_ITEM=C6_ITEM '+CR
	cQuery += ' AND C6_PRODUTO=CB8_PROD '+CR
	cQuery += " WHERE CB8.D_E_L_E_T_= ' ' "+CR
	cQuery += " AND SC6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB8_ORDSEP = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB8_FILIAL = CB7.CB7_FILIAL),0) "RESLIQ" '+CR

	cQuery += " ,NVL((SELECT SUM (CB6.CB6_XPESO) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+"  CB6 " +CR
	cQuery += " WHERE CB6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB6.CB6_FILIAL = CB7.CB7_FILIAL ),0) "XPESO" '+CR

	cQuery += " ,NVL((SELECT SUM (CB3.CB3_VOLUME) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+"  CB6 "+CR
	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("CB3")+" ) CB3 "+CR
	cQuery += ' ON CB3_FILIAL = CB6.CB6_FILIAL '+CR
	cQuery += ' AND CB3.CB3_CODEMB = CB6.CB6_TIPVOL '+CR
	cQuery += " AND CB3.D_E_L_E_T_= ' ' "+CR

	cQuery += " WHERE CB6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB6.CB6_FILIAL = CB7.CB7_FILIAL ),0) "XCUBA" '+CR

	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "+CR

	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("CB7")+" )CB7 "+CR
	cQuery += " ON CB7.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB7_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB7_ORDSEP  BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "+CR
	cQuery += " AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"+CR
	//Giovani Zago chamado 000255
	cQuery += " AND CB7.CB7_DTEMIS BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CR
	//If MV_PAR07 == 1 //COM NF 
	//	cQuery += " AND CB7.CB7_NOTA <> ' ' " + CR 
	//Elseif MV_PAR07 == 2 //SEM NF 
	//	cQuery += " AND CB7.CB7_NOTA = ' ' " + CR 
	//Endif 

	//cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC6")+" )SC6 "
	//cQuery += " ON   (C6_ITEM = '01' or C6_ITEM = '02')
	//cQuery += " AND  C6_NUM = SC5.C5_NUM
	//cQuery += " AND C6_FILIAL = SC5.C5_FILIAL

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "+CR
	cQuery += " ON SA1.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE "+CR
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI "+CR
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"+CR

	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "+CR
	cQuery += " ON SA3.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND2 "+CR

	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA4")+" )SA4 "+CR
	cQuery += " ON SA4.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA4.A4_COD = SC5.C5_TRANSP "+CR
	cQuery += " AND SA4.A4_FILIAL = '"+xFilial("SA4")+"'"+CR

	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"+CR
	//cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND SC5.C5_NUM  BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "+CR
	cQuery += " ORDER BY SC5.C5_NUM "+CR

	cQuery += " ) "+CR

	cQuery += " SELECT EMB.*, "+CR
	cQuery += " (SELECT MAX(ZA_DATA || ZA_HORA) FROM " + RetSqlName("SZA") + " SZA "+CR
	cQuery += " WHERE ZA_FILIAL = '" + xFilial("SZA") + "' "+CR
	cQuery += " AND ZA_FILIAL = EMB.FILIAL "+CR
	cQuery += " AND ZA_CLIENTE = EMB.CLIENTE "+CR
	cQuery += " AND ZA_LOJA = EMB.LOJA "+CR
	cQuery += " AND ZA_PEDIDO = EMB.PEDIDO "+CR
	cQuery += " AND SZA.D_E_L_E_T_ = ' ' "+CR
	cQuery += " GROUP BY ZA_FILIAL, ZA_PEDIDO "+CR
	cQuery += " ) AS DTHRLIBF "+CR
	
	cQuery += " ,nvl((SELECT " +CR
	cQuery += " SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM) "+CR 
	cQuery += " VALOR " +CR
	cQuery += " FROM "+RetSqlName("SD2")+"  SD2 "+CR 
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' " +CR
	cQuery += " AND SD2.D2_DOC   = NF  "  +CR

	/*********************************************
	<<<< ALTERAÇÃO >>>>
	Ação.........: Tratamento para Filial quando o relatório emitido pela Industria ou Distribuidora
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 21/02/2022
	Chamados.....: 20220218004013
	****************************************/		
	IF cEmpAnt = "11"
		cQuery += " AND SD2.D2_FILIAL = '01' "+CR
	ELSE
		cQuery += " AND SD2.D2_FILIAL = '02' "+CR
	ENDIF
	cQuery += " ),0) " +CR
	cQuery += " VALIQ " +CR

	cQuery += " FROM EMB"+CR

	//SELECT SC5.C5_NUM "PEDIDO",CB7.CB7_ORDSEP "OS",(SELECT COUNT(CB6_PEDIDO) FROM CB6010 CB6 WHERE  CB6.D_E_L_E_T_ = ' ' AND CB6_PEDIDO = SC5.C5_NUM AND CB6.CB6_FILIAL = '02' AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP)  "VOLUME",CASE WHEN CB7.CB7_STATUS = '0' THEN '0-Inicio' ELSE CASE WHEN CB7.CB7_STATUS = '1' THEN '1-Separando' ELSE CASE WHEN CB7.CB7_STATUS = '2' THEN '2-Sep.Final' ELSE CASE WHEN CB7.CB7_STATUS = '3' THEN '3-Embalando' ELSE CASE WHEN CB7.CB7_STATUS = '4' THEN '4-Emb.Final' ELSE CASE WHEN CB7.CB7_STATUS = '8' THEN '8-Embarcado' ELSE CASE WHEN CB7.CB7_STATUS = '9' THEN '9-Embarque Finalizado' ELSE 'SEM NUMERACAO' END END END END END END END "STATUSX",SC5.C5_CLIENTE "CLIENTE",SC5.C5_LOJACLI "LOJA",SA1.A1_NREDUZ "NOME",SC5.C5_TRANSP "COD.TRANSP",SC5.C5_VEND2 "XVEND",COALESCE(SA4.A4_NOME,' ') "TRANSP",SA3.A3_NOME "NVEND",COALESCE((SELECT PD2_CODROM FROM PD2010 PD2 WHERE  PD2.D_E_L_E_T_ = ' ' AND PD2.PD2_NFS = CB7.CB7_NOTA AND PD2.PD2_SERIES = CB7.CB7_SERIE AND PD2.PD2_CLIENT = SC5.C5_CLIENTE AND PD2.PD2_LOJCLI = SC5.C5_LOJACLI AND PD2.PD2_FILIAL = '02' ),' ') "ROMANEIO",CB7.CB7_NOTA "NF",COALESCE((SELECT SUBSTR(F2_EMISSAO,7,2)||'/'|| SUBSTR(F2_EMISSAO,5,2)||'/'|| SUBSTR(F2_EMISSAO,1,4) FROM SF2010 SF2 WHERE  SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = CB7.CB7_NOTA AND SF2.F2_SERIE = CB7.CB7_SERIE AND SF2.F2_FILIAL = '02'),'  /  /    ') "EMISSAO",CASE WHEN SC5.C5_CONDPAG = '501' AND SC5.C5_XLIBAVI <> 'S' THEN 'Bloqueado à Vista' ELSE 'LIBERADO' END "BLOQVISTA",CASE WHEN SC5.C5_TRANSP = ' ' THEN 'Transportadora em Branco' ELSE 'LIBERADO' END "BLOQTRANSP",CASE WHEN SC5.C5_XTIPO ='1' THEN 'RETIRA' ELSE 'ENTREGA' END "ENTREGA",CASE WHEN SC5.C5_TPFRETE ='F' THEN 'FOB' ELSE 'CIF' END "FRETE",SC5.C5_CONDPAG "COND",(SELECT E4_DESCRI FROM SE4010 SE4 WHERE  E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' AND SE4.E4_FILIAL = '  ' )  "DESCRI",(SELECT X5_DESCRI FROM SX5010 SX5 WHERE  SX5.D_E_L_E_T_ = ' ' AND SX5.X5_TABELA = 'SX' AND SX5.X5_CHAVE = (SELECT DISTINCT SC6.C6_OPER FROM SC6010 SC6 WHERE  C6_NUM = SC5.C5_NUM AND C6_FILIAL = SC5.C5_FILIAL AND SC6.D_E_L_E_T_ = ' ' AND SC6.C6_OPER <> ' ')  AND SX5.X5_FILIAL = '  ' )  "VENDA" FROM SC5010 SC5 INNER JOIN (SELECT * FROM CB7010 ) CB7 ON CB7.D_E_L_E_T_ = ' ' AND CB7_PEDIDO = SC5.C5_NUM AND CB7_ORDSEP BETWEEN '      ' AND 'ZZZZZZ' AND CB7.CB7_FILIAL = '02' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  ' LEFT JOIN(SELECT * FROM SA3010 ) SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = SC5.C5_VEND2 LEFT JOIN(SELECT * FROM SA4010 ) SA4 ON SA4.D_E_L_E_T_ = ' ' AND SA4.A4_COD = SC5.C5_TRANSP AND SA4.A4_FILIAL = '  '  WHERE  SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = '02' AND SC5.C5_EMISSAO BETWEEN '20130101' AND '20140101' AND SC5.C5_NUM BETWEEN '      ' AND 'ZZZZZZ'  ORDER BY  SC5.C5_NUM

	//cQuery := ChangeQuery(cQuery)
	MEMOWRITE("C:\TEMP\RSTFAT13.TXT" , cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
