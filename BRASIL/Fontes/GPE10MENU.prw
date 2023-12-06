#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPE10MENU ºAutor  ³Renato Nogueira     º Data ³  14/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para adicionar itens no menu do GPE10MENU  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GPE10MENU()

	aAdd(aRotina, { OemToAnsi("Aviso desligar func")  		  		, 'U_STDESFUN' 	, 0, 1,0,.F.})
	aAdd(aRotina, { OemToAnsi("Criar fornecedor")	  		  		, 'U_STINCSA2' 	, 0, 1,0,.F.})
	aAdd(aRotina, { OemToAnsi("Alterar PIS")	  		  			, 'U_STALTPIS' 	, 0, 1,0,.F.})

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDESFUNC ºAutor  ³Renato Nogueira     º Data ³  14/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para informar desligamento de funcionário			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STDESFUN()

	Local aArea		:= GetArea()
	Local lSaida	:= .F.
	Local cGetEmail	:= space(40)
	Local cCmbItem  := space(5)
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local cMsg		:= ""
	Local aCmbItens	:= {"Sim","Não"}

	If !Empty(SRA->RA_XDTDESL)

		MsgAlert("Atenção, este funcionário já foi desligado")

	Else

		If MsgYesNo("Deseja avisar o desligamento do funcionário: "+Alltrim(SRA->RA_NOME)+"?")

			While !lSaida

				Define msDialog oDlg Title "Digitar e-mail" From 10,10 TO 20,45

				@ 000,001 Say "Email desviado para: " Pixel Of oDlg
				@ 010,003 MsGet cGetEmail size 60,10 Picture "@!" pixel OF oDlg
				//>> Ticket 20210312004051 - Everson Santana - 24.03.2021 
				@ 025,001 Say "Realocar Equipamento: " Pixel Of oDlg
				@ 035,003 MSCOMBOBOX oCmbItem VAR cCmbItem ITEMS aCmbItens SIZE 60,10 Pixel OF oDlg 
				//<< Ticket 20210312004051
				DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION (nOpcao:=1,lSaida:=.T.,oDlg:End()) ENABLE OF oDlg

				Activate dialog oDlg centered

			End

			SRA->(Reclock("SRA",.F.))
			SRA->RA_XDTDESL	:= DATE()
			SRA->RA_XHRDELS	:= TIME()
			SRA->RA_XUSRDES	:= Alltrim(UsrRetName(__CUSERID))
			SRA->RA_XEMAILD	:= Alltrim(cGetEmail)
			SRA->(Msunlock())

			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Funcionário: </b>'+Alltrim(SRA->RA_NOME)+'<br><b>Usuário: </b>'+Alltrim(SRA->RA_XUSRDES)+'<br>'
			cMsg += '<b>Centro de custo: </b>'+Posicione("CTT",1,xFilial('CTT')+SRA->RA_CC,"CTT_DESC01")+'<br>'
			cMsg += '<b>Email desviado para: </b> '+Alltrim(SRA->RA_XEMAILD)+'<br>'
			cMsg += '<b>Realocar Equipamento: </b> '+Alltrim(cCmbItem)+'<br>' // Ticket 20210312004051
			cMsg += '<b>Verificar e-mail nos codigos fontes protheus </b>' 
			cMsg += '</body></html>'

			U_STMAILTES(GetMv("ST_EMLDESL"),"","Desligamento de funcionário - "+Alltrim(SRA->RA_NOME),cMsg,_aAttach,_cCaminho)
				

			MsgAlert("Aviso enviado com sucesso")

		EndIf

	EndIf

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STINCSA2 ºAutor  ³Renato Nogueira     º Data ³  11/05/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para criar fornecedor a patir do funcionario     	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STINCSA2()

	Local aArea				:= GetArea()
	Local cProxFor			:= ""
	Private lMsErroAuto     	:= .F.
	Private lMsHelpAuto     	:= .T.

	If MSGYESNO("Deseja criar fornecedor para o funcionário: "+AllTrim(SRA->RA_NOME))

		DbSelectArea("SA2")
		SA2->(DbSetOrder(3))
		SA2->(DbGoTop())
		If SA2->(DbSeek(xFilial("SA2")+SRA->RA_CIC))
			MsgAlert("Atenção, esse fornecedor já foi cadastrado")
			Return
		EndIf

		//cCodMun     := BuscaMun(SRA->RA_ESTADO,SRA->RA_MUNICIP)
		cProxFor	:= GetSX8Num("SA2","A2_COD")
		SA2->(ConfirmSX8())


		SA2->(RecLock("SA2",.T.))

		SA2->A2_TIPO 	:= "F" 
		SA2->A2_CGC 	:= SRA->RA_CIC          
		SA2->A2_COD		:= cProxFor                
		SA2->A2_LOJA	:= "01"
		SA2->A2_NOME	:= SRA->RA_NOME
		SA2->A2_NREDUZ	:= SubString(SRA->RA_NOME,1,20)
		SA2->A2_END		:= AllTrim(SRA->RA_ENDEREC)+", "+SRA->RA_LOGRNUM
		SA2->A2_EST		:= SRA->RA_ESTADO
		SA2->A2_NR_END	:= "SN"
		SA2->A2_COD_MUN	:= SRA->RA_CODMUN
		SA2->A2_BAIRRO	:= SRA->RA_BAIRRO
		SA2->A2_COMPLEM	:= SRA->RA_COMPLEM
		SA2->A2_CEP		:= SRA->RA_CEP
		SA2->A2_EMAIL	:= SRA->RA_EMAIL
		SA2->A2_MAT		:= SRA->RA_MAT
		SA2->A2_TEL		:= SubSTring(SRA->RA_TELEFON,1,10)
		SA2->A2_INSCR	:= "ISENTO"
		SA2->A2_CODPAIS	:= "01058"
		SA2->A2_TEL		:= SubString(SRA->RA_TELEFON,1,10)
		SA2->A2_XSOLIC	:= UsrRetName(RetCodUsr())
		SA2->A2_XDEPTO	:= "RH"
		SA2->A2_MSBLQL	:= "2"
		SA2->A2_MUN		:= SRA->RA_MUNICIP

		SA2->(MsUnLock())

		MsgInfo("Fornecedor incluido com sucesso: "+SA2->A2_COD+" "+SA2->A2_LOJA)

		SRA->(RecLock("SRA",.F.))
		SRA->RA_FOR	 := SA2->A2_COD
		SRA->RA_LOJA := SA2->A2_LOJA
		SRA->(MsUnLock())

		/*
		aVetor := {{"A2_TIPO" ,"F"              ,nil},;
		{"A2_CGC" ,SRA->RA_CIC              ,nil},;
		{"A2_COD" , cProxFor                ,nil},;
		{"A2_LOJA" ,"01"                    ,nil},;
		{"A2_NOME" ,SRA->RA_NOME            ,nil},;
		{"A2_NREDUZ",SubString(SRA->RA_NOME,1,20)          ,nil},;
		{"A2_END" ,AllTrim(SRA->RA_ENDEREC)+", "+SRA->RA_LOGRNUM          ,nil},;
		{"A2_EST" ,SRA->RA_ESTADO           ,nil},;
		{"A2_NR_END" ,"SN"                  ,nil},;
		{"A2_COD_MUN" ,SRA->RA_CODMUN       ,nil},;
		{"A2_BAIRRO" ,SRA->RA_BAIRRO        ,nil},;
		{"A2_COMPLEM" ,SRA->RA_COMPLEM      ,nil},;
		{"A2_CEP" ,SRA->RA_CEP              ,nil},;
		{"A2_EMAIL" ,SRA->RA_EMAIL          ,nil},;
		{"A2_MAT" ,SRA->RA_MAT			    ,nil},;
		{"A2_TEL" ,SubSTring(SRA->RA_TELEFON,1,10) 			,nil},;
		{"A2_INSCR" ,"ISENTO"               ,nil},;
		{"A2_CODPAIS" ,"01058"              ,nil},;
		{"A2_TEL" ,SubString(SRA->RA_TELEFON,1,10)          ,nil},;
		{"A2_XSOLIC" ,UsrRetName(RetCodUsr()),nil},;
		{"A2_XDEPTO" ,"RH"  			        ,nil},;
		{"A2_MSBLQL" ,"2"  			        ,nil},;
		{"A2_MUN" ,SRA->RA_MUNICIP          ,nil}}

		MSExecAuto({|x,y| Mata020(x,y)},aVetor,3)

		If lMsErroAuto
		MostraErro()
		SA2->(RollBackSX8()) // Se deu algum erro ele libera o n° do auto incremento para ser usado novamente;
		Else
		If !(cProxFor==SA2->A2_COD)
		MsgInfo("Problema na criação do código, verifique")
		SA2->(RollBackSX8())
		Else
		MsgInfo("Fornecedor incluido com sucesso: "+SA2->A2_COD+" "+SA2->A2_LOJA)
		// Confirma se o auto incremento foi usado;

		SRA->(RecLock("SRA",.F.))
		SRA->RA_FOR	 := SA2->A2_COD
		SRA->RA_LOJA := SA2->A2_LOJA
		SRA->(MsUnLock())

		EndIf
		EndIf
		*/

	EndIf

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STALTPIS ºAutor  ³Renato Nogueira     º Data ³  07/03/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para alterar o PIS do funcionário			     	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STALTPIS()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}

	AADD(_aParamBox,{1,"PIS",Space(12),"","","","",0,.F.})

	If ParamBox(_aParamBox,"PIS...",@_aRet)
		SRA->(RecLock("SRA",.F.))
		SRA->RA_PIS	:= MV_PAR01
		SRA->(MsUnLock())
		MsgInfo("PIS alterado com sucesso!")
	EndIf

Return()





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPM670FIM ºAutor  ³Giovani Zago         º Data ³  11/06/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alterar nome de fornecedor no titulo financeiro	     	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GPM670FIM()


	RecLock("SE2", .F.)
	SE2->E2_NOMFOR:= 'STECK'
	SE2->(MsUnlock())
	SE2->(DbCommit())



Return()

