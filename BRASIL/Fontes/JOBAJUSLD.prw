#include "Totvs.ch"
#Include "Protheus.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} JOBAJUSSLD()
(long_description)
Job para Transferir Saldo a Endereçar para um novo endereço
@author user
Valdemir Rabelo - SigaMat
@since date
01/11/2019
@example
(examples)

/*/
User Function JOBAJUSSLD()
	Local aEmpFil   := {}
	Local nX        := 0

	If IsBlind()

		aAdd(aEmpFil, {'01','01'})          // Empresa: 01
		aAdd(aEmpFil, {'01','02'})
		aAdd(aEmpFil, {'01','03'})
		aAdd(aEmpFil, {'01','04'})
		aAdd(aEmpFil, {'03','01'})          // Empresa: 03
		aAdd(aEmpFil, {'03','02'})

		AutoGrLog( "*************************************************************************" )
		AutoGrLog( "*    INICIO LEITURA - PROCURA DE REGISTROS SALDOS A ENDEREÇAR VIA JOB   *" )
		AutoGrLog( "*************************************************************************" )

		For nX := 1 to Len(aEmpFil)
			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(aEmpFil[nX][1],aEmpFil[nX][2],,,,GetEnvServer(),{ "SD3","SDA","SB2","SB1","SBF" } )
			SetModulo("SIGAEST","EST")

			// Inicia Processo
			JOBAJUS1()

			RpcClearEnv()

		Next

		AutoGrLog( "*******************************************************************" )
		AutoGrLog( "*    TERMINO LEITURA JOB (JOBAJUSSLD)                             *" )
		AutoGrLog( "*******************************************************************" )

	Else

		JOBAJUS1()
		MsgAlert("Processamento finalizado!")

	EndIf

Return .T.

Static Function JOBAJUS1()
	Local cQry     := MntQry()
	Local aProd    := {}
	Local nHoraIniCtr := 0

	if Select("TSLD") > 0
		TSLD->( dbCloseArea() )
	endif

	nHoraIniCtr := Seconds()

	AutoGrLog("-------- I N I C I O  P R O C E S S A M E N T O ----------"	)
	AutoGrLog(""															)
	AutoGrLog("DATABASE...........: " + DtoC( dDataBase ) 					)
	AutoGrLog("DATA...............: " + DtoC( Date() ) 					)
	AutoGrLog("HORA...............: " + Time() 							)
	AutoGrLog("EMPRESA............: " + cEmpAnt 							)
	AutoGrLog("FILIAL.............: " + cFilAnt 							)

	TcQuery cQry New Alias "TSLD"

	// CB0_CODPRO,CB0_NUMSEQ,CB0_NUMSER,CB0_LOTE,CB0_SLOTE,CB0_QTDE
	While TSLD->( !Eof() )
		nPos:= Ascan(aProd, { |x| x[1]+x[2]+x[3] == TSLD->(DA_PRODUTO+DA_NUMSEQ+DA_LOTECTL) })
		If (nPos==0)
			aAdd(aProd, {TSLD->DA_PRODUTO,;
			TSLD->DA_NUMSEQ,;
			TSLD->DA_LOTECTL,;
			TSLD->DA_NUMLOTE,;
			"",;
			TSLD->DA_SALDO,;
			TSLD->DA_DOC,;
			TSLD->DA_SERIE,;
			TSLD->DA_ORIGEM,;
			TSLD->DA_LOCAL,;
			TSLD->RECSDA})
		else
			aProd[nPos,4] += TSLD->DA_SALDO
		Endif
		TSLD->( dbSkip() )
	EndDo
	AutoGrLog("=> => =>  Realizando a transferencia, aguarde...")
	TransfEnd(aProd)

	AutoGrLog(" -> F I M - P R O C E S S A M E N T O  -> Data : "+DtoC(Date())+" Hora : "+Time())
	AutoGrLog(" -> T E M P O "+AllTrim(Str(Seconds()-nHoraIniCtr,10,3))+" Segundo(s)")

Return

Static Function TransfEnd(aProd)
	Local cEndPara    := SuperGetMV("ST_JBENDPA",.f.,"AENDERECAR")     // Informa o armazem Destino
	Local nX          := 0
	Local cCod 		  := ""
	Local cLocal      := ""
	Local cNumSeq	  := ""
	Local cLoteCtl    := ""
	Local cNumLote    := ""
	Local cNumSeri    := ""
	Local nQuant	  := 0
	Local cDOC        := ""
	Local cORIGEM     := ""
	Local cSERIE      := ""
	Local lGera       := .T.
	Local lLocaliza   := .T.
	Local lError      := .F.
	
	DbSelectArea("SDA")

	Private lMSErroAuto := .F.

	For nX := 1 to Len(aProd)
		cCod 		:= aProd[nX,1]
		cNumSeq	    := aProd[nX,2]
		cLoteCtl    := aProd[nX,3]
		cNumLote    := aProd[nX,4]
		cNumSeri    := aProd[nX,5]
		nQuant	    := aProd[nX,6]
		cDOC        := aProd[nX,7]
		cSERIE      := aProd[nX,8]
		cORIGEM     := aProd[nX,9]
		cLocal      := aProd[nX,10]
		nrecno		:= aProd[nX,11]

		lLocaliza   := Localiza(cCod)       // Controla Endereço

		If lLocaliza
			aAreaSBE := SBE->(GetArea())
			SBE->(dbSetOrder(1))
			If SBE->(MsSeek(xFilial("SBE")+cLocal+cEndPara))
				cLocaliz := SBE->BE_LOCALIZ
			else
				AutoGrLog("Endereçamento não encontrado (SBE) Local: "+cLocal+" Endereço: "+cEndPara)
			EndIf
			SBE->(RestArea(aAreaSBE))

			_aArSB2	:= SB2->(GetArea())
			DbSelectArea("SB2")
			DbSetOrder(1)
			MsSeek(xFilial("SB2") + cCod + cLocal )

			cEndPara := PadR(cEndPara, TamSx3('BE_LOCALIZ')[1])
			
			SDA->(DbGoTo(nrecno))
			
			lGera := A100Distri(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,AllTrim(cEndPara),Nil,SDA->DA_SALDO,SDA->DA_LOTECTL,SDA->DA_NUMLOTE)

			if !lGera
				AutoGrLog("Ocorreu um problema ao transferir de endereço"+CRLF+;
				"Produto: "+cCod+CRLF+;
				"Local: "+cLocal+CRLF+;
				"Numero Seq.: "+cNumSeq+CRLF+;
				"Documento: "+cDoc+CRLF+;
				"Endereço Destino: "+cEndPara+CRLF+;
				"Numero Serie: "+cNumSeri+CRLF+;
				"Quantidade a Transferir: " + cValToChar(nQuant)+CRLF+;
				"Lote: "+cLoteCtl+CRLF+;
				"Numero Lote: "+cNumLote;
				)
				lError := .T.
				Exit
			Endif

		Endif

		RestArea( _aArSB2)
	Next

	If lError
		AutoGrLog("*************** << Ocorreu um problema no processamento >> *************")
	EndIf

Return

Static Function MntQry()
	Local cRET := ""

	cRET := "SELECT DISTINCT " + CRLF
	cRET += "    DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_LOTECTL, DA_NUMLOTE, DA_SALDO, DA_DOC, DA_SERIE, DA_ORIGEM, A.R_E_C_N_O_ RECSDA " + CRLF
	cRET += "FROM " + RETSQLNAME("SDA") + " A " + CRLF
	cRET += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cRET += " AND A.DA_SALDO > 0 " + CRLF
	//cRET += " AND A.DA_DATA >= '20190801' " + CRLF
	cRET += " AND A.DA_FILIAL='" + XFILIAL("SDA") + "' " + CRLF
	cRET += "ORDER BY DA_DOC, DA_NUMSEQ " + CRLF

Return cRET

/*
PONTO DE ENTRADA
-----------------
User Function A100DIST()
Local cProd := PARAMIXB[1]
Local cLoc  := PARAMIXB[2]
Local lRet  := .T.

If  //Validação do usuário
lret := .F.
Endif

Return(lRet)
*/