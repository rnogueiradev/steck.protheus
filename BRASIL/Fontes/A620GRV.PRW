#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A620GRV   ºAutor  ³Renato Nogueira     º Data ³  24/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Copiar ferramentas entre empresas					          º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Steck                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A620GRV()

	Local aArea     	:= GetArea()
	Local aAreaSH4  	:= SH4->(GetArea())
	Local cQuery1 		:= ""
	Local cAlias1 		:= "QRYTEMP"
	Local _cEmpOld		:= cEmpAnt
	Local _cFilOld		:= cFilAnt
	Private aRotAuto	:= {}
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .f. // necessario a criacao, pois sera //atualizado quando houver

	If INCLUI
		If MsgYesNo("Deseja copiar a ferramenta para a empresa: "+IIf(cEmpAnt=="01","03","01")+"?")

			cQuery1	 := " SELECT COUNT(*) CONTADOR "
			cQuery1  += " FROM SH4"+IIf(cEmpAnt=="01","030","010")+" H4 "
			cQuery1  += " WHERE H4.D_E_L_E_T_=' ' AND H4_CODIGO='"+SH4->H4_CODIGO+"' "

			If !Empty(Select(cAlias1))
				DbSelectArea(cAlias1)
				(cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

			dbSelectArea(cAlias1)
			(cAlias1)->(dbGoTop())

			If (cAlias1)->CONTADOR>0
				MsgAlert("Atenção, ferramenta já cadastrada na outra empresa!")
				Return
			EndIf
	
			Begin Transaction
	
				aRotAuto:= {{'H4_FILIAL' ,"01",Nil},;
					{'H4_CODIGO' ,SH4->H4_CODIGO,Nil},;
					{'H4_DESCRI' ,SH4->H4_DESCRI,Nil},;
					{'H4_VIDAUTI' ,SH4->H4_VIDAUTI,Nil},;
					{'H4_TIPOVID' ,SH4->H4_TIPOVID,Nil},;
					{'H4_DTAQUIS' ,SH4->H4_DTAQUIS,Nil},;
					{'H4_VIDAACU' ,SH4->H4_VIDAACU,Nil},;
					{'H4_QUANT' ,SH4->H4_QUANT,Nil},;
					{'H4_EFEITO' ,SH4->H4_EFEITO,Nil},;
					{'H4_RESTR' ,SH4->H4_RESTR,Nil},;
					{'H4_TURNO' ,SH4->H4_TURNO,Nil},;
					{'H4_CGRAF' ,SH4->H4_CGRAF,Nil},;
					{'H4_CORMAX' ,SH4->H4_CORMAX,Nil},;
					{'H4_CORMIN' ,SH4->H4_CORMIN,Nil},;
					{'H4_CUSTOH' ,SH4->H4_CUSTOH,Nil},;
					{'H4_XCODSTE' ,SH4->H4_XCODSTE,Nil},;
					{'H4_XTPFERR' ,SH4->H4_XTPFERR,Nil},;
					{'H4_XNUMCAV' ,SH4->H4_XNUMCAV,Nil},;
					{'H4_XPESMOL' ,SH4->H4_XPESMOL,Nil},;
					{'H4_XDIMENS' ,SH4->H4_XDIMENS,Nil},;
					{'H4_XMATPRI' ,SH4->H4_XMATPRI,Nil},;
					{'H4_XPOSTIC' ,SH4->H4_XPOSTIC,Nil},;
					{'H4_XTPEXTR' ,SH4->H4_XTPEXTR,Nil},;
					{'H4_XPERIFE' ,SH4->H4_XPERIFE,Nil},;
					{'H4_XCOTEMP' ,SH4->H4_XCOTEMP,Nil},;
					{'H4_XZONAS' ,SH4->H4_XZONAS,Nil},;
					{'H4_XSTFERR' ,SH4->H4_XSTFERR,Nil},;
					{'H4_XCODFAB' ,SH4->H4_XCODFAB,Nil},;
					{'H4_XLJFAB' ,SH4->H4_XLJFAB,Nil},;
					{'H4_XDTINIF' ,SH4->H4_XDTINIF,Nil},;
					{'H4_XDTTRYO' ,SH4->H4_XDTTRYO,Nil},;
					{'H4_XFORMAN' ,SH4->H4_XFORMAN,Nil},;
					{'H4_XLJFORN' ,SH4->H4_XLJFORN,Nil},;
					{'H4_XDTMANU' ,SH4->H4_XDTMANU,Nil},;
					{'H4_XDTENT' ,SH4->H4_XDTENT,Nil},;
					{'H4_XDTAPRO' ,SH4->H4_XDTAPRO,Nil},;
					{'H4_XDTLIBE' ,SH4->H4_XDTLIBE,Nil},;
					{'H4_XOBS' ,SH4->H4_XOBS,Nil}}

				StartJob("U_STCOPSH4",GetEnvServer(), .T.,IIf(cEmpAnt=="01","03","01"), "01",aRotAuto,3)

				If lMsErroAuto
					DisarmTransaction()
					break
				EndIf
		
				If lMsErroAuto
					Mostraerro()
				Else
					MsgInfo("Ferramenta copiada com sucesso!")
				EndIf
	
			End Transaction

		EndIf
	EndIf

	RestArea(aAreaSH4)
	RestArea(aArea)

Return()

User Function STCOPSH4(cNewEmp, cNewFil,aRotAuto,nOpc)

	Private lMsErroAuto := .f.

//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	Begin Transaction

		MSExecAuto({|x,y| MATA620(x,y)},aRotAuto,nOpc)

	End Transaction

	If lMsErroAuto
		MostraErro("LOGS","PRODUTO"+Alltrim(aRotAuto[1][2])+".log")
	EndIf

	RpcClearEnv() //volta a empresa anterior

Return