#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"

User Function STCOPIAB1()

	Local cEmpFilAtu		:= Alltrim(cEmpAnt + cFilAnt)
	Local aArea 			:= GetArea()
	Local aAreaSB1 		:= SB1->(GetArea())
	Local _aParametros 	:= {}
	
	Local cOldEmp	:= cEmpAnt
	Local cOldFil	:= cFilAnt
	 
	Private aRotAuto 		:= {}
	Private nOpc 			:= 0
	Private _cNewEmp		:= "03" //Manaus
	Private _cNewFil 		:= "01" //Filial principal

//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO 'FAT'

	If cEmpFilAtu $ "0101/0105/0104"     // Adicionado Empresa/Filial 0105 - Valdemir Rabelo 03/02/2021 - Ticket: 20210127001450

//	If INCLUI

		nOpc := 3
		cPAIS := IF(EMPTY(SB1->B1_XPAIS),'9',SB1->B1_XPAIS)             // Valdemir Rabelo 28/01/2021 - Ticket: 20210127001450
		aRotAuto:= {		{'B1_COD' 	  ,SB1->B1_COD		,Nil},;                                                  
							{'B1_DESC'    ,SB1->B1_DESC   	,Nil},;//U_TstGrp()
							{'B1_XGATCL'  ,SB1->B1_XGATCL 	,Nil},;
							{'B1_CLAPROD' ,SB1->B1_CLAPROD	,Nil},;
							{'B1_UM'      ,SB1->B1_UM     	,Nil},;//U_TstGrp()
							{'B1_GRUPO'   ,SB1->B1_GRUPO  	,Nil},;
							{'B1_ORIGEM'  ,SB1->B1_ORIGEM 	,Nil},;
							{'B1_APROPRI' ,SB1->B1_APROPRI	,Nil},;//U_TstGrp()
							{'B1_TIPO'    ,SB1->B1_TIPO   	,Nil},;
							{'B1_LOCPAD'  ,"01"				,Nil},;
							{'B1_GARANT'  ,SB1->B1_GARANT   ,Nil},;							
							{'B1_XDESEXD' ,SB1->B1_XDESEXD	,Nil},;
							{'B1_XPAIS'   ,cPAIS			,Nil}}							
		/*
		aRotAuto:= {		{'B1_COD' 		,SB1->B1_COD,Nil},;
							{'B1_DESC' 	,SB1->B1_DESC,Nil},;
							{'B1_TIPO' 	,SB1->B1_TIPO,Nil},;
							{'B1_UM' 		,SB1->B1_UM,Nil},;
							
							{'B1_PICM' 	,0,Nil},;
							{'B1_IPI' 		,0,Nil},;
							{'B1_PRV1' 	,SB1->B1_PRV1,Nil},;
							{'B1_LOCALIZ' ,SB1->B1_LOCALIZ,Nil},;
							{'B1_ORIGEM' 	,SB1->B1_ORIGEM,Nil},;
							{'B1_CLAPROD' ,SB1->B1_CLAPROD,Nil},;
							{'B1_GRUPO' 	,SB1->B1_GRUPO,Nil},;
							{'B1_CODBAR' 	,SB1->B1_CODBAR,Nil},;
							{'B1_POSIPI'	,SB1->B1_POSIPI,Nil},;
							{'B1_XGATCL'	,SB1->B1_XGATCL,Nil},;
							{'B1_XDESEXT'	,SB1->B1_XDESEXT,Nil},;
							{'B1_FANSTAM'	,SB1->B1_FANTASM,Nil},;
							{'B1_APROPRI'	,SB1->B1_APROPRI,Nil},;
							{'B1_XDESENH'	,SB1->B1_XDESENH,Nil},;
							{'B1_XDESEXT'	,SB1->B1_XDESEXT,Nil},;
							{'B1_XCOMP'	,SB1->B1_XCOMP,Nil},;
							{'B1_XTENSAO'	,SB1->B1_XTENSAO,Nil},;
							{'B1_XCORREN'	,SB1->B1_XCORREN,Nil},;
							{'B1_PESBRU'	,SB1->B1_PESBRU,Nil},;
							{'B1_PESO'		,SB1->B1_PESO,Nil},;
							{'B1_XCRIACB'	,SB1->B1_XCRIACB,Nil},;
							{'B1_XDESEXT'	,SB1->B1_XDESEXT,Nil},;
							{'B1_CODBAR'	,SB1->B1_CODBAR,Nil},;
							{'B1_GRTRIB'	,IIf(!Empty(SB1->B1_GRTRIB),"001",""),Nil},;
							{'B1_XDTINCL'	,SB1->B1_XDTINCL,Nil},;
							{'B1_XDESEXD'	,SB1->B1_XDESEXD,Nil},;
							{'B1_XPAIS'	,SB1->B1_XPAIS,Nil}}
		*/
		
		//----------------------------------------------------------------------------------------------------------------
		// Richard - 20/10/2017
		// StartJob nao funcionou no P12 - Sera verificado posteriormente. 
		// Provisoriamente alterado para chamar a funcao e utilizado PREPARE ENVIRONMENT ao inves de RpcSetEnv()
		//----------------------------------------------------------------------------------------------------------------
		
		_aParametros := {_cNewEmp, _cNewFil, aRotAuto, nOpc,cOldEmp,cOldFil}
		cArqError := StartJob("U_STCB1AM",GetEnvServer(),.T.,_aParametros)      // Ajuste Valdemir Rabelo - 28/01/2021 - Ticket:20210127001450

		// Ajuste Valdemir Rabelo - 28/01/2021 - Ticket:20210127001450
		if !Empty(cArqError)
		   cOrigem  := "\Logs\" + cArqError
		   cDestino := "C:\arquivos_protheus\"
		   MakeDir("C:\arquivos_protheus\")
		   __CopyFile(cOrigem, cDestino+cArqError)
		   ShellExecute("OPEN", cDestino+cArqError, "", "", 1)
		Endif 
		
		//StartJob("U_STCB1AM",GetEnvServer(), .T.,_cNewEmp, _cNewFil, aRotAuto, nOpc)
		//U_STCB1AM(_cNewEmp, _cNewFil, aRotAuto, nOpc,cOldEmp,cOldFil)

/*	ElseIf ALTERA

		//MsgAlert("Altera")

	ElseIf EXCLUI

		//MsgAlert("Exclui")

	EndIf
*/

	EndIf

	SB1->(RestArea(aAreaSB1))
	RestArea(aArea)

Return .T.

//User Function STCB1AM(cNewEmp, cNewFil,aRotAuto,nOpc,cOldEmp,cOldFil)
User Function STCB1AM(_aParametros)

	//Conout ("[STCB1AM] Carrego as variaveis")
	//Local aArea	:= GetArea()
	
	Local cNewEmp 	:= _aParametros[01]
	Local cNewFil		:= _aParametros[02]
	Local aRotAuto 	:= _aParametros[03]
	Local nOpc			:= _aParametros[04]
	Local cOldEmp		:= _aParametros[05]
	Local cOldFil		:= _aParametros[06]
	Private _cError     := ""

	//Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
	//Private lMsErroAuto := .f. // necessario a criacao, pois sera //atualizado quando houver

	Conout ("[STCB1AM]  Antes do PREPARE Gravando produto na empresa 03")

//Inicia outra Thread com outra empresa e filial
	//Reset Environment
	RpcSetType( 3 )
	//PREPARE ENVIRONMENT EMPRESA cNewEmp FILIAL cNewFil MODULO 'FAT'
	RpcSetEnv(cNewEmp,cNewFil,,'COM')
	//RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	Conout ("[STCB1AM]  Depois do PREPARE Gravando produto na empresa 03")
	Begin Transaction
	
		lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
		lMsErroAuto := .f. // necessario a criacao, pois sera //atualizado quando houver
		
		Conout ("[STCB1AM] Antes do MSExecAuto Gravando produto na empresa 03")
		MSExecAuto({|x,y| mata010(x,y)},aRotAuto,nOpc)
		Conout ("[STCB1AM] Depois do MSExecAuto Gravando produto na empresa 03")
		If lMsErroAuto
			Conout ("[STCB1AM] Erro MSExecAuto Gravando produto na empresa 03")
			MostraErro("LOGS","PRODUTO_"+Alltrim(aRotAuto[1][2])+".log")
			_cError     := "PRODUTO_"+Alltrim(aRotAuto[1][2])+".log"
			DisarmTransaction()
			break
		Else
			Conout ("[STCB1AM] MSExecAuto Executado Gravando produto na empresa 03")
		EndIf

	End Transaction

//RpcClearEnv() //volta a empresa anterior
	Conout ("[STCB1AM]  volta a empresa anterior")
	Reset Environment
	//RpcSetType( 3 )
	//RpcSetEnv(cOldEmp,cOldFil,,'Fat')
	//PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil MODULO 'FAT'
	
	Conout ("[STCB1AM]  Fim")
//RestArea(aArea)

Return _cError
