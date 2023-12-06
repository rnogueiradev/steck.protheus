#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"


/*====================================================================================\
|Programa  | JOBATU           | Autor | GIOVANI.ZAGO             | Data | 22/01/2013  |
|=====================================================================================|
|Descrição | JOBATU      JOB limpa reserva e falta                                    |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | JOBATU                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function JOBATU1()
	*-----------------------------*

	Private cWorkFlow	:= "N"
	Private cWCodEmp    := cEmpAnt
	Private cWCodFil    := cFilAnt
	Private _cBlCred    := ""
	Private _dPar1      := date()
	Private _dPar2      := date()
	Private _cPar3      := ""
	Private _cPar4      := ""
	Private _cPar5      := ""
	Private _cPar6      := ""
	U_JOBATUROT()

Return()



User Function JOBATU()

	Private cWorkFlow	:= "S"
	Private cWCodEmp    := "01"
	Private cWCodFil    := "02"
	Private _cBlCred    := ""
	Private _dPar1      := date()
	Private _dPar2      := date()
	Private _cPar3      := ""
	Private _cPar4      := ""
	Private _cPar5      := ""
	Private _cPar6      := ""
	U_JOBATUROT()

Return()

User Function JOBATUROT()


	If cWorkFlow == "S"

		PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "PA1","PA2","SC5"
		ConOut("------------------------")
		ConOut("Iniciando Ambiente " )
		ConOut("------------------------")
		If dow(date()) = 1  .And. dow(date()) = 7 //domingo ---- sabado
			Return()
		EndIf
	EndIf
	_xAlias    := GETAREA()
	cPerg      := "STJOB"
	nLastKey   := 0
	lContinua  := .T.
	lEnd       := .F.
	Private _cArqTrb
	If cWorkFlow == "N"
		AjustaSX1(cPerg)           // Verifica perguntas. Se nao existe INCLUI.

		If Pergunte(cPerg,.T.)     // Solicita parametros

			_dPar1      :=	MV_PAR01
			_dPar2      :=	MV_PAR02
			_cPar3      :=	MV_PAR03
			_cPar4      :=	MV_PAR04
			_cPar5      :=	MV_PAR05
			_cPar6      :=	MV_PAR06


			Processa({|lEnd| RunProc()},'Limpando Reserva')

		EndIf

	Else
		_dPar1      := ctod('01/01/2000')
		_dPar2      := DATE()
		_cPar3      := '      '
		_cPar4      := 'zzzzzz'
		_cPar5      := '  '
		_cPar6      := 'zz'


		RunProc()

	Endif
	If cWorkFlow == "S"
		ConOut("------------------------")
		ConOut("Fim do Processamento " )
		ConOut("------------------------")
	EndIf



	Return
	*-----------------------------------*
Static Function RunProc()
	*-----------------------------------*


	DbSelectArea("PA2")
	PA2->(DbSetOrder(2))
	PA2->(DbSeek(xFilial('PA2')+'1'))
	Do While PA2->(!Eof()) .And. PA2->PA2_TIPO = '1'
		If datavalida(PA2->PA2_DTINCL+3) < DATE() .and. PA2->PA2_DTINCL >= _dPar1 .And. PA2->PA2_DTINCL <= _dPar2  .and.  SUBSTR(PA2->PA2_DOC,1,8) >= _cPar3+_cPar5 .And. SUBSTR(PA2->PA2_DOC,1,8) <= _cPar4+_cPar6
			_cBlCred:= Posicione('SC9',1,xFilial("SC9")+ALLTRIM(PA2->PA2_DOC),'C9_BLCRED')
			If  !Empty(Alltrim(_cBlCred)) .And. !(_cBlCred $ '09/10')

				PA2->(RecLock("PA2",.F.))
				If cWorkFlow == "N"
					PA2->PA2_OBS:=  "RESERVA LIMPA MANUALMENTE   - " + CUSERNAME +' - '+ __cuserId + ' - ' + dTOc(date())  +' - '+TIME()
				Else
					PA2->PA2_OBS:="RESERVA LIMPA PELO JOB   - "+dTOc(Date())+' - '+TIME()
				EndIf

				PA2->(DbDelete())
				PA2->(MsUnlock())
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If	SC5->(DbSeek( xFilial("SC5")+SUBSTR(PA2->PA2_DOC,1,6) ) )

					SC5->(RecLock("SC5",.F.))
					SC5->C5_ZDTJOB:=date()
					SC5->(MsUnlock())

				EndIf
			EndIf
		EndIf

		PA2->(	DBSKIP())
	EndDo
	If cWorkFlow == "S"
		ConOut("------------------------")
		ConOut("Limpando Reserva " )
		ConOut("------------------------")
	EndIf
	//************************************************8

	DbSelectArea("PA1")
	PA1->(DbSetOrder(2))
	PA1->(DbSeek(xFilial('PA1')+'1'))
	Do While PA1->(!Eof()) .And. PA1->PA1_TIPO = '1'
		If    Datavalida(PA1->PA1_DTINCL+2) < DATE().And. PA1->PA1_DTINCL >= _dPar1 .And. PA1->PA1_DTINCL <= _dPar2 .And. SUBSTR(PA1->PA1_DOC,1,8) >= _cPar3+_cPar5 .And. SUBSTR(PA1->PA1_DOC,1,8) <= _cPar4+_cPar6
			_cBlCred:= Posicione('SC9',1,xFilial("SC9")+ALLTRIM(PA1->PA1_DOC),'C9_BLCRED')
			If  !Empty(Alltrim(_cBlCred)) .And. !(_cBlCred $ '09/10')

				PA1->(RecLock("PA1",.F.))
				If cWorkFlow == "N"
					PA1->PA1_OBS:="FALTA LIMPA MANUALMENTE   "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
				Else
					PA1->PA1_OBS:="FALTA LIMPA PELO JOB   "+dTOc(date())+' - '+TIME()
				EndIf

				PA1->(DbDelete())
				PA1->(MsUnlock())
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If	SC5->(DbSeek( xFilial("SC5")+SUBSTR(PA1->PA1_DOC,1,6) ) )

					SC5->(RecLock("SC5",.F.))
					SC5->C5_ZDTJOB:=date()
					SC5->(MsUnlock())

				EndIf
			EndIf
		EndIf
		PA1->(DBSKIP())
	EndDo

	If cWorkFlow == "S"
		ConOut("------------------------")
		ConOut("Limpando Falta " )
		ConOut("------------------------")
	EndIf
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VALIDPERG ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
	Local j := 0 
	Local i := 0 
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	aRegs:={}
	//------------ Grupo/Ordem/Pergunta/PERGING/PERGESP/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	AADD(aRegs,{cPerg,"01","Data de    ?","","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data até   ?","","","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Pedido de  ?","","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"04","Pedido até ?","","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"05","Item de    ?","","","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Item até   ?","","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})


	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return
