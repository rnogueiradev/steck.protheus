#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} STFAT040
@name STFAT040
@type User Function
@desc enviar danfe para os clientes
@author Renato Nogueira
@since 10/07/2018
/*/

User Function STFAT040()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STFAT040",.F.,.F.,.T.)
		ConOut("[STFAT040]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT040]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03"
			ConOut(CRLF + "[STFAT041]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STFAT041",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			//U_STFAT041(SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STFAT041]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STFAT040]["+ FWTimeStamp(2) +"] Fim do processamento")

	UnLockByName("STFAT040",.F.,.F.,.T.)

	Reset Environment

Return()

/*/{Protheus.doc} STFAT041
@name STCOMA30
@type User Function
@desc processa os wf
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STFAT041(cNewEmp,cNewFil)

	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Default cNewEmp := "01"
	Default cNewFil := "05"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias2 := GetNextAlias()

	_cQuery2 := " SELECT F2.R_E_C_N_O_ RECSF2
	_cQuery2 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery2 += " WHERE F2.D_E_L_E_T_=' '
	_cQuery2 += " AND F2_CHVNFE<>' ' AND F2_XDTENVD=' '
	_cQuery2 += " AND F2_EMISSAO>='"+DTOS(Date()-30)+"'
	_cQuery2 += " AND F2_FILIAL='"+cNewFil+"'
	//_cQuery2 += " AND F2_DOC='000464893'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	DbSelectArea("SF2")

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))

	While (_cAlias2)->(!Eof())

		SF2->(DbGoTo((_cAlias2)->RECSF2))

		_cEmail := ""
		_cNome  := ""
		_cCnpj	:= ""

		If !AllTrim(SF2->F2_TIPO)=="B"
			If SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
				_cEmail := AllTrim(SA1->A1_EMAIL)
				_cNome	:= AllTrim(SA1->A1_NOME)
				_cCnpj  := SA1->A1_CGC
			EndIf
		Else
			If SA2->(DbSeek(xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA)))
				_cEmail := AllTrim(SA2->A2_EMAIL)
				_cNome	:= AllTrim(SA2->A2_NOME)
				_cCnpj  := SA2->A2_CGC
			EndIf
			IF (SA4->a4_COD=='04064')
				If SA4->(DbSeek(xFilial("SA4")+SF2->(F2_TRANSP)))
					_cEmail += ";"+AllTrim(SA4->A4_EMAIL)
				EndIf
			Endif 

		EndIf

		U_STXPRTNF(SF2->F2_CHVNFE,.T.)
		U_STFAT030(SF2->F2_CHVNFE)

		If File("\arquivos\xml_nfe\"+cNewEmp+"\"+SF2->F2_CHVNFE+".pdf") .And.;
				File("\arquivos\xml_nfe\"+cEmpAnt+"\"+SF2->F2_CHVNFE+".xml")


			_cEmail   := AllTrim(_cEmail)
			_cEmail   += ";"+AllTrim(GetMv("STFAT0401",,"renato.oliveira@steck.com.br"))
			_cCopia	  := ""
			_cAssunto := "[ STECK - Industria Eletrica ] - Danfe da Nota "+SF2->F2_DOC
			_aAttach  := {}
			_cCaminho := ""

			cMsg := ' <html>
			cMsg += '     <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			cMsg += '     <head>
			cMsg += '         <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			cMsg += '         </head>
			cMsg += '         <html
			cMsg += '             xmlns="http://www.w3.org/1999/xhtml">
			cMsg += '             <head>
			cMsg += '                 <title>NFe Nacional</title>
			cMsg += '                 <style type="text/css">
			cMsg += '                     <!-- body {background-color: rgb(37, 64, 97);} .style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} .style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} .style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} .style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} .style5 {font-size: 10pt} -->
			cMsg += '                 </style>
			cMsg += '             </head>
			cMsg += '             <body>
			cMsg += '                 <table style="background-color: rgb(240, 240, 240); width: 520px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
			cMsg += '                     <tbody>
			cMsg += '                         <tr>
			cMsg += '                             <td colspan="2">
			cMsg += '                                 <p class="style1">Esta mensagem refere-se a Nota Fiscal Eletrônica Nacional de serie/número [1/'+SF2->F2_DOC+'] emitida para:</p>
			cMsg += '                             </td>
			cMsg += '                         </tr>
			cMsg += '                         <tr>
			cMsg += '                             <td style="width: 250px; white-space: nowrap;">
			cMsg += '                                 <p class="style1">Razão Social:
			cMsg += '                                     <br>CNPJ:
			cMsg += '                                         <br>
			cMsg += '                                             <br>
			cMsg += '                                             </p>
			cMsg += '                                         </td>
			cMsg += '                                         <td width="326">
			cMsg += '                                             <p class="style1">['+_cNome+']
			cMsg += '                                                 <br>['+_cCnpj+']
			cMsg += '                                                     <br>
			cMsg += '                                                         <br>
			cMsg += '                                                         </p>
			cMsg += '                                                     </td>
			cMsg += '                                                 </tr>
			cMsg += '                                                 <tr>
			cMsg += '                                                     <td colspan="2">
			cMsg += '                                                         <p class="style1">Para verificar a autorização da SEFAZ referente à nota acima mencionada, acesse o sitio
			cMsg += '                                                             <a href="http://www.nfe.fazenda.gov.br/portal">
			cMsg += '                                                                 <span style="text-decoration: underline;">http://www.nfe.fazenda.gov.br/portal</span>
			cMsg += '                                                             </a>
			cMsg += '                                                         </p>
			cMsg += '                                                     </td>
			cMsg += '                                                 </tr>
			cMsg += '                                                 <tr>
			cMsg += '                                                     <td style="white-space: nowrap;">
			cMsg += '                                                         <p class="style1">Chave de acesso:&nbsp;
				cMsg += '                                                             </p>
			cMsg += '                                                         </td>
			cMsg += '                                                         <td>
			cMsg += '                                                             <span class="style1">[NFe'+SF2->F2_CHVNFE+']
			cMsg += '                                                                 </span>
			cMsg += '                                                             </td>
			cMsg += '                                                         </tr>
			cMsg += '                                                         <tr>
			cMsg += '                                                             <td colspan="2">
			cMsg += '                                                                 <p class="style1">Este e-mail foi enviado automaticamente pelo&nbsp;Sistema de Nota Fiscal Eletrônica (NF-e) da&nbsp;STECK IND ELETRICA LTDA</p>
			cMsg += '                                                             </td>
			cMsg += '                                                         </tr>
			cMsg += '                                                         <tr>
			cMsg += '                                                             <td colspan="2" class="style4">
			cMsg += '                                                                 <span class="style5">
			cMsg += '                                                                     <em>
			cMsg += '                                                                         <span style="text-decoration: underline;">powered by TotvsServices - Totvs S/A</span>
			cMsg += '                                                                     </em>
			cMsg += '                                                                     <em></em>
			cMsg += '                                                                 </span>
			cMsg += '                                                             </td>
			cMsg += '                                                         </tr>
			cMsg += '                                                     </tbody>
			cMsg += '                                                 </table>
			cMsg += '                                                 <p class="style1">&nbsp;</p>
			cMsg += '                                             </body>
			cMsg += '                                         </html>

			_aAttach := {}
			AADD(_aAttach,SF2->F2_CHVNFE+".pdf")
			AADD(_aAttach,SF2->F2_CHVNFE+".xml")

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,"\arquivos\xml_nfe\"+cNewEmp+"\")

			SF2->(RecLock("SF2",.F.))
			SF2->F2_XDTENVD := Date()
			SF2->F2_XHRENVD := Time()
			SF2->(MsUnLock())

			IF (cEmpAnt == '01')   // Adicionado Valdemir Rabelo 23/07/2021 - Ticket: 20210705011711
			    if cFilAnt $ "02/05"
				   // Já processa de acordo com a nota
				   U_ProcesAG(SF2->F2_DOC)
			     //StaticCall (JOBAGAPI, ProcesAG, SF2->F2_DOC)
				endif 
			endif 
		EndIf

		(_cAlias2)->(DbSkip())
	EndDo

	IF (cEmpAnt == '01')   // Adicionado Valdemir Rabelo 16/07/2021
	    if cFilAnt $ "02/05"
		   // Processa todos os registros em busca de nota
		   u_JOBAGAPI()     // Valdemir Rabelo 22/06/2021
		endif 
	Endif 

	Reset Environment
	//RpcClearEnv()

Return
