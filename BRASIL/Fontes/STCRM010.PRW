#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STCRM010         | Autoria: Flávia Rocha              | Data | 15/12/2021|
|=====================================================================================|
|Descrição | Webservice para cancelar pedido                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
/------------------------------------------------------------------------------------*/
WSRESTFUL cancelaPed DESCRIPTION "Cancela Pedido Venda"

WSMETHOD POST DESCRIPTION "Cancela Pedido Venda" WSSYNTAX "/rest/cancelaped"

END WSRESTFUL


WSMETHOD POST WSSERVICE cancelaped

	Local _cXml     := "" 
	Local oXml	
	
	Local _cRetorno	:= ""
	Local _nX		:= 0
	Local aData		:= {}
	//Local aCabec    := {}
	//Local aItens	:= {}
	//Local aLinha	:= {}
		
	//Local lTemSC5   := .F.
	Local lTUDOK    := .T.	
	
	Local cMsgRet   := ""
		
	Private lMsErroAuto := .F.
	Private _cTabRej   	:= 'Z7'
	Private cC5NUM      := ""
	Private cCodMot   	:= ""
	Private cDescMot    := ""
	Private cCodVend    := ""
	
	__cUserId := '000000'  				

	Conout("[STCRM010][CANCELAPED]"+FWTimeStamp(2)+" - Inicio do cancela pedido !")
	
	//------------------------------------------//
	//recebe o conteúdo do Postman (array Json)
	//------------------------------------------//
	_cXml := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")  
	_cXml := FwCutOff(_cXml,.T.)

	oXml := ""
	_lRet := FWJsonDeserialize(FwNoAccent(_cXml),@oXml)

	
	//----------------------//
	//Valida o Json
	//----------------------//
	If !_lRet
		_cRetorno := '{"CODRET":"01","DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(_cRetorno)
		Return .T.
	EndIf

	aData := ClassDataArr(oXml)						//transforma o objeto vindo do ws, em um array
	
	Asort(aData,,,{ | x,y | x[3] < y[3] } )	
	
	//COLETA INFORMAÇÕES DO ARRAY PARA VALIDAÇÃO:	
	For _nX:=1 To Len(aData)

		If SubStr(aData[_nX][1],1,3)=="C5_"

			If AllTrim(aData[_nX][1])=="C5_NUM"

				cC5NUM := aData[_nX][2]

				
			Elseif AllTrim(aData[_nX][1])=="C5_XMOTRES"

				cDescMot := UPPER(ALLTRIM(aData[_nX][2]))
				

			//FR - ALTERAÇÃO - 14/03/2022 - INCLUIR NA VALIDAÇÃO CAMPO NOVO: A3_XCANCPV - se o vendedor pode eliminar resíduo do pedido de venda: 
			Elseif AllTrim(aData[_nX][1])=="C5_VEND1"

				cCodVend := UPPER(ALLTRIM(aData[_nX][2]))				

			Endif

		Elseif  SubStr(aData[_nX][1],1,3)=="Z7_"

			If  AllTrim(aData[_nX][1])=="Z7_CODMOTIVO"				

				cCodMot := aData[_nX][2]				

			Endif

		Endif 	
		
	Next

	//valida numero pedido:
	//valida se existe o pedido passado
	SC5->(OrdSetFocus(1))
	If !SC5->(DbSeek(xFilial("SC5") + cC5NUM ))					
		
		_cRetorno := '{"CODRET":"02","DESCRET":"PEDIDO DE VENDA INEXISTENTE, CANCELAMENTO NAO PERMITIDO "}'
		::SetResponse(_cRetorno)
		Return .t.
	
	Else
		//verifica se já foi faturado			
		If SC5->C5_ZFATBLQ = '1' 
					
			_cRetorno := '{"CODRET":"03","DESCRET":"PEDIDO DE VENDA FATURADO TOTALMENTE, CANCELAMENTO NAO PERMITIDO "}'
			::SetResponse(_cRetorno)
			Return .t.

		Endif

		//verifica se já houve eliminação de resíduo
		If ('XXXX' $ SC5->C5_NOTA).And.(SC5->C5_ZFATBLQ $ '1/2') 
						
			_cRetorno := '{"CODRET":"04","DESCRET":"PEDIDO DE VENDA ELIMINADO POR RESIDUO (SALDO), CANCELAMENTO NAO PERMITIDO "}'
			::SetResponse(_cRetorno)
			Return .t.

		Endif

		//verifica se já foi totalmente eliminado resíduo
		If ('XXXX' $ SC5->C5_NOTA).And. (SC5->C5_ZFATBLQ = '3' .Or. Empty(Alltrim(SC5->C5_ZFATBLQ)))
						
			_cRetorno := '{"CODRET":"05","DESCRET":"PEDIDO DE VENDA CANCELADO, CANCELAMENTO NAO PERMITIDO "}'
			::SetResponse(_cRetorno)
			Return .t.

		Endif

	Endif

	//valida o motivo digitado:
	If Empty(cDescMot)
		_cRetorno := '{"CODRET":"06","DESCRET":"DESCRICAO MOTIVO VAZIA, CANCELAMENTO NAO PERMITIDO "}'
		::SetResponse(_cRetorno)
		Return .t.
	Endif

	//valida o vendedor digitado:
	If Empty(cCodVend)
		_cRetorno := '{"CODRET":"07","DESCRET":"CODIGO VENDEDOR VAZIO, CANCELAMENTO NAO PERMITIDO "}'
		::SetResponse(_cRetorno)
		Return .t.
	Else 
		SA3->(OrdSetFocus(1))
		If SA3->(Dbseek(xFilial("SA3") + cCodVend ))
			
			If SA3->A3_XCANCPV <> "S" //se pode cancelar PV
				_cRetorno := '{"CODRET":"08","DESCRET":"VENDEDOR SEM PERMISSAO PARA CANCELAR PEDIDO VENDA"}'
				::SetResponse(_cRetorno)
				Return .t. 
			Endif 
					
		Endif 
	Endif

	//valida o motivo:
	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	If !SX5->(dbSeek(xFilial("SX5") + _cTabRej + cCodMot))
	
		_cRetorno := '{"CODRET":"09","DESCRET":"CODIGO MOTIVO NAO LOCALIZADO NA TABELA SX5 - Z7"}'
		::SetResponse(_cRetorno)
		Return .t.

	Endif  

	
/*
ARRAY RECEBIDO:
	{
    	"C5_NUM": "280086",
		"C5_VEND1": "I08564",
    	"Z7_CODMOTIVO": "000001",
		"C5_XMOTRES": "DESCRICAO MOTIVO"   	
	}	

•	Número do pedido (obrigatório);
•	Código vendedor (obrigatório);
•	Código do motivo do cancelamento (obrigatório);
•	Observação quanto ao motivo (obrigatório);

*/

	
lTUDOK := GravaDados(cC5NUM,cCodMot,cDescMot,@cMsgRet)
//TESTE PV: 002624	
	
//Prepara arquivo de log de gravação ou erro de gravação:	
cNArq  := "STCRM010_"+dtos(date())+Substr(time(),1,2) + Substr(time(),4,2)+".log"  //nome do arquivo de log
cDir    := "\arquivos\logs\"

If !ExistDir(cDir)
	Makedir(cDir)
EndIf
//arquivo log

If lTUDOK  

	_cRetorno := '{"CODRET":"OK","DESCRET":"Residuo Eliminado com Sucesso:",'+;
	   	          '"PEDIDO":' + '"' + cC5NUM + '"' + '}'	

Else
		
	_cRetorno := '{"CODRET":"00","DESCRET":"Erro ao Eliminar Residuo Pedido, Motivo: '+ cMsgRet+ '" ,'+;
	              '"PEDIDO":' + '"' + cC5NUM + '"' + '}'
	

Endif

//----------------------------------//
//grava o arquivo de log na pasta:
//----------------------------------//
_cFile := cDir+ cNArq  //diretório mais nome do arquivo
			
nHdlXml:= FCreate(_cFile,0)		//Cria o arquivo no diretorio (cria o nome.extensao na pasta apenas)

If nHdlXml > 0
						
	FWrite(nHdlXml,_cRetorno)	//aqui grava o conteudo no arquivo acima gravado na pasta
	FClose(nHdlXml)

Endif
	

Conout("[STCRM010][cancelaped]"+ FWTimeStamp(2)+" - Fim do cancela pedido")

::SetResponse(_cRetorno)

 

Return .T.



//gravação
/*====================================================================================\
|Programa  | GravaDados       | Autoria: Flávia Rocha              | Data | 22/12/2021|
|=====================================================================================|
|Descrição | Gravação dos dados da eliminação do resíduo                              |
|          |                                                                          |
|=====================================================================================|
/------------------------------------------------------------------------------------*/
Static Function GravaDados(cC5NUM,cCodMot,cDescMot,cMsgRet)
Local lContinua := .T.
Local _cTabRej 	:= 'Z7'
Local cC5FIL    := ""
Local cGetMDe   := ""
Local aSC6Area		:= SC6->(GetArea())
Local aArea			:= GetArea()
Local aSC5Area		:= SC5->(GetArea())
Local lValido 	    := .F. 
Private lBLOQUEADOS := .F.

DbSelectArea("SC5")
SC5->(OrdSetFocus(1))
If SC5->(DbSeek(xFilial("SC5") + cC5NUM))
	lContinua := .T.
	cC5FIL := SC5->C5_FILIAL 
Else 
	lContinua := .F.
Endif 

If lContinua

		DbSelectArea('SC6')
		SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If SC6->(DbSeek(xFilial("SC6")+ cC5NUM))			

			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+ cC5NUM
				
				dbSelectArea("SC9")
				SC9->(	dbSetOrder(1) )
				If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))

					While SC9->(! Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM == xFilial("SC6")+SC6->(C6_NUM+C6_ITEM))

						If !Empty (SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
							lContinua:=.F.
						EndIf
						SC9->(DbSkip())
					Enddo

				EndIf

				SC6->(DbSkip())

			Enddo 

		Endif

		If !lContinua
			/*
			Msginfo("Pedido de Venda em Separação pela Expedição....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
				"O mesmo não poderá ser utilizado para Eliminação de Resíduo....!!!!!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
				"Não será possível utilizar a rotina de Eliminação de Resíduo até a emissão da Nota Fiscal....!!!!!!")
			*/	
				cMsgRet := "PEDIDO DE VENDA EM SEPARACAO PELA EXPEDICAO, CANCELAMENTO NAO PERMITIDO !"
				Return lContinua 
		EndIf 

Endif

If lContinua

	dbSelectArea("SC6")
	SC6->(	dbSetOrder(1))
	SC6->(	dbSeek(xFilial("SC6")+ cC5NUM))

	Begin Transaction

		Do While ( SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM 	== cC5NUM )
			
			SC6->(RecLock("SC6",.F.))
			SC6->C6_QTDEMP 	 := 0
			SC6->C6_XDTRES   := Date()
			SC6->C6_XUSRRES  := __cUserId
			SC6->(MsUnlock())
			SC6->(DbCommit())

			dbSelectArea("PA1")
			PA1->(DbSetOrder(3))
			If PA1->(DbSeek(xFilial('PA1')+SC6->C6_NUM+SC6->C6_ITEM))
				PA1->(RecLock('PA1',.F.))
				PA1->PA1_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
				PA1->(DbDelete())
				PA1->(MsUnlock())
			EndIf
			dbSelectArea("PA2")
			PA2->(DbSetOrder(3))
			If PA2->(DbSeek(xFilial('PA2')+SC6->C6_NUM+SC6->C6_ITEM))
				PA2->(RecLock('PA2',.F.))
				PA2->PA2_OBS:="ELIMINAÇÃO DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
				PA2->(DbDelete())
				PA2->(MsUnlock())
			EndIf

			//elimina o resíduo
			lValido  := .T.
			If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
				If FindFunction("EECZERASALDO")
					lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				Else
					lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				EndIf
			EndIf
			If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
				MaResDoFat(,.T.,.F.)
			EndIf

			dbSelectArea("SC6")
			SC6->(dbSkip())
			SC6->(MaLiberOk({SC5->C5_NUM},.T.))
			
		EndDo

		//13/08/2014 - Limpar bloqueio após eliminacao de residuo
		DbSelectArea("SC5")
		SC5->(OrdSetFocus(1))

		If SC5->(DbSeek(xFilial("SC5") + cC5NUM))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZBLOQ	:= "2"
			SC5->C5_ZMOTBLO	:= ""
			MSMM(SC5->C5_XALTCAB,,,"Eliminado Residuo "+cUsername+" - "+dtoc(date())+' - '+time(),1,,,"SC5","C5_XALTCAB",,.T.)
			SC5->(MsUnLock())
		Endif 

		//U_STZZI01()
		STZZI01(cC5FIL,cC5NUM)  //apaga a alçada de desconto

		DbSelectArea("SC9")
		SC9->(DbGoTop())
		SC9->(DbSetOrder(1))
		If SC9->(DbSeek(xFilial("SC9")+ cC5NUM))

			While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO  == xFilial("SC9")+ cC5NUM )
				If Empty( Alltrim(SC9->C9_NFISCAL) )
					SC9->(RecLock("SC9",.F.))
					SC9->C9_XOBSFIN:=  "Eliminação de residuo  - " + CUSERNAME +' - '+ __cuserId + ' - ' + dTOc(date())  +' - '+TIME()
					SC9->(DbDelete())
					SC9->(MsUnlock())
				EndIf
					SC9->(Dbskip())
			Enddo
		EndIf

		cGetMDe := "" 

		SX5->(dbSetOrder(1))
		If SX5->(dbSeek(xFilial("SX5") + _cTabRej + cCodMot))
			cGetMDe := ALLTRIM(SX5->X5_DESCRI)
		Endif 

		DbSelectArea("SC5")
		SC5->(OrdSetFocus(1))

		If SC5->(DbSeek(xFilial("SC5") + cC5NUM))

			SC5->(RecLock("SC5",.F.))
			SC5->C5_XMOTRES	:= cCodMot + "--" + cGetMDe + "--" + cDescMot
			SC5->(MsUnLock())
		Endif 
			
		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT * FROM "+RetSqlName("SDC")
		_cQry += " WHERE DC_ORIGEM = 'SC6' "
		_cQry += " AND DC_FILIAL = '"+xFilial("SDC")+"' "
		_cQry += " AND DC_PEDIDO = '"+ cC5NUM+"' "
		_cQry += " AND D_E_L_E_T_ = ' ' "

		_cQry := ChangeQuery(_cQry)

		TcQuery _cQry New Alias "TRD"

		TRD->(dbGoTop())

		dbselectarea("SDC")
		SDC->(DBSETORDER(1))
		
		While !EOF()

			if SDC->(DBSEEK(XFILIAL("SDC")+TRD->DC_PRODUTO+TRD->DC_LOCAL+"SC6"+cC5NUM+TRD->DC_ITEM))
				Reclock("SDC", .F.)
					SDC->(dbdelete())
				SDC->( msunlock() )
				SBF->(DBSETORDER(1))
				IF SBF->(DBSSEK(XFILIAL("SBF")+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO))
					SBF->(RECKLOCK("SBF",.F.))
						SBF->BF_EMPENHO := SBF->BF_EMPENHO - TRD->DC_QUANT
					SBF->(MSUNLOCK())
				ELSE
					disarmtransaction()
				ENDIF
			endif
			/*
			_cQry1 := " "
			_cQry1 += " UPDATE "+RetSqlName("SBF")+" SET BF_EMPENHO = BF_EMPENHO - '"+Str(TRD->DC_QUANT)+"'
			_cQry1 += " WHERE BF_PRODUTO = '"+TRD->DC_PRODUTO+"'  "
			_cQry1 += " AND BF_LOCAL = '"+TRD->DC_LOCAL+"' "
			_cQry1 += " AND BF_LOCALIZ = '"+TRD->DC_LOCALIZ+"' "
			_cQry1 += " AND BF_FILIAL = '"+xFilial("SBF")+"'"
			_cQry1 += " AND D_E_L_E_T_ = ' ' "

			Tcsqlexec(_cQry1)

			_cQry2 := " "
			_cQry2 += " UPDATE "+RetSqlName("SDC")+" SET D_E_L_E_T_ = '*' "
			_cQry2 += " WHERE DC_ORIGEM = 'SC6' "
			_cQry2 += " AND DC_FILIAL = '"+xFilial("SDC")+"' "
			_cQry2 += " AND DC_PEDIDO = '"+ cC5NUM+"' "
			_cQry2 += " AND DC_PRODUTO = '"+TRD->DC_PRODUTO+"'
			_cQry2 += " AND D_E_L_E_T_ = ' ' "

			Tcsqlexec(_cQry2)*/

			TRD->(dbSkip())

		Enddo
	End Transaction
Endif
		

If lContinua
	STATULEG(cC5FIL,cC5NUM) 	
Endif

dbcommitall()
RestArea(aSC5Area)
RestArea(aSC6Area)
RestArea(aArea)

Return(lContinua)

/*====================================================================================\
|Programa  | STZZI01        | Autor | GIOVANI.ZAGO               | Data | 18/08/2020  |
|          |                | Adaptado por: Flávia Rocha         | Data | 22/12/2021  |
|=====================================================================================|
|Descrição | Remover ZZI - alçada de desconto                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   |                                                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function STZZI01(cFili,cC5NUM)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local aArea    := GetArea()
	
	DbSelectArea("ZZI")

	_cQuery1 := " SELECT ZZI.R_E_C_N_O_ RECZZI
	_cQuery1 += " FROM "+RetSqlName("ZZI")+" ZZI
	_cQuery1 += " WHERE ZZI.D_E_L_E_T_=' ' AND ZZI_FILANT='"+ cFili +"'
	_cQuery1 += " AND ZZI_BLQ='2' AND ZZI_TIPO='PEDIDO' AND ZZI_NUM='"+ cC5NUM+"'
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	_cQuery1 := ChangeQuery(_cQuery1)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())
	
		ZZI->(DbGoTo((_cAlias1)->RECZZI))
		If ZZI->(!Eof())
			ZZI->(RecLock("ZZI",.F.))
			ZZI->(DbDelete())
			ZZI->(MsUnLock())
		EndIf
	
		(_cAlias1)->(DbSkip())
	EndDo

	DbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STATULEG	ºAutor  ³Renato Nogueira     º Data ³  29/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para atualizar a legenda do pedido após a   º±±
±±º          ³eliminacao de residuo				  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum 										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STATULEG(cC5FIL,cC5NUM)

	Local cQuery   		:= ""
	Local cAlias   		:= "QRYTEMP"	

	cQuery := " SELECT COUNT(*) CONTADOR "
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "
	//cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C6_QTDENT>0 AND C6_NUM='"+SC5->C5_NUM+"' AND C6_FILIAL='"+SC5->C5_FILIAL+"' "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C6_QTDENT > 0 AND C6_NUM = '" + cC5NUM + "' AND C6_FILIAL='" + cC5FIL + "' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	If (cAlias)->CONTADOR > 0 //Faturado parcial

		DbSelectArea("SC5")
		SC5->(OrdSetFocus(1))

		If SC5->(DbSeek(xFilial("SC5") + cC5NUM))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_ZFATBLQ	:= "2"			
			SC5->(MsUnLock())
		Endif 

	EndIf

Return()

