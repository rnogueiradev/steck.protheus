#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"
#include "tryexception.ch"



/*/{Protheus.doc} OPETQ002
description
    Rotina para chamada de etiquetas de produtos individuais
@type function
@author Valdemir Jose
@since 15/09/2020
@return return_type, return_description
u_OPETQ002
/*/
User Function OPETQ002()
	Local aParam   := {}
	Local aConfig  := {}
	Private nGQtdPCx := 0

	MsgAlert("Atenção, no parâmetro impressora coloque o NOME da impressora, ex.: pick1")

	If !__cUserId $ AllTrim(GetMv("OPETQ002",,"001331#001289"))
		MsgAlert("Usuário sem acesso!")
		Return
	EndIf

	aAdd(aParam,{1,"Produto:"		    ,Space(TamSx3("B1_COD")[1])	    ,"@!"     		,".T.","SB1","",70,.T.})
	aAdd(aParam,{1,"Impressora:"	    ,Space(10)	                    ,"@!"     		,".T.","","",70,.T.})
	aAdd(aParam,{1,"Qtde caixa:"	    ,0      	                    ,"@E 999"     	,".T.","","",70,.T.})
	aAdd(aParam,{1,"Qtde impressão:"	,0      	                    ,"@E 999"     	,".T.","","",70,.T.})

	If !ParamBox(aParam,"Impressão Etiqueta [ Produto ]",@aConfig, {|| VldPrd()},,.F.,90,15)
		Return
	EndIf
    /*
	If !CB5SETIMP(MV_PAR02, IsTelNet())
        MsgAlert("Falha na comunicacao com a impressora.")
        Return(Nil)
	EndIf
    */

	//nGQtdPCx := SB1->B1_XQTYMUL
	nGQtdPCx := MV_PAR03

	_cBkpUN   := cUserName
	cUserName := AllTrim(Lower(MV_PAR02))

	FWMsgRun(,{|| OPETQPROC() },'Aguarde','Imprimindo Etiqueta')

	cUserName := _cBkpUN

	DbSelectArea("ZS6")
	ZS6->(RecLock("ZS6",.T.))
	ZS6->ZS6_FILIAL := xFilial("ZS6")
	ZS6->ZS6_DATA   := Date()
	ZS6->ZS6_HORA   := SubStr(Time(),1,5)
	ZS6->ZS6_USER   := cUserName
	ZS6->ZS6_PROD   := MV_PAR01
	ZS6->ZS6_IMP    := AllTrim(Lower(MV_PAR02))
	ZS6->ZS6_QTDCAI := MV_PAR03
	ZS6->ZS6_QTDIMP := MV_PAR04
	ZS6->(MsUnLock())

Return


/*/{Protheus.doc} OPETQPROC
description
    Rotina que busca a etiqueta com base no produto
@type function
@author Valdemir Jose
@since 15/09/2020
@return return_type, return_description
/*/
Static Function OPETQPROC()

	Local cVld := u_getLista()

	if !Empty(cVld)
		&(cVld)
	endif

Return


/*/{Protheus.doc} VldPrd
description
    Rotina valida se o produto faz parte da etiqueta individual
@type function
@author Valdemir Jose
@since 15/09/2020
@return return_type, return_description
/*/
Static Function VldPrd()
	Local lRET := .F.
	Local aVld := u_getLista()

	DbSelectArea("SB1")
	DbSetOrder(1)
	lRET := DbSeek( xFilial("SB1") + MV_PAR01 )
	if !lRET
		FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não Cadastrado na Tabela de Produtos.(SB1)")
	Else
		if !lRET
			if Empty(SB1->B1_XVH)
				FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não foi informado o sentido da etiqueta")
			else
				FWMsgRun(,{|| Sleep(4000) },'Informativo',"Produto não consta na lista de etiquetas individuais (GetLista)")
			endif
		else
			lRET := (!Empty(SB1->B1_XMODETI))
			if !lRET
				FWMsgRun(,{|| Sleep(4000)},"Atenção!","O produto: "+Alltrim(SB1->B1_COD)+" não contém modelo de etiqueta informado.")
			Endif
		Endif
	Endif

Return lRET
