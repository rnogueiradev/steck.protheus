#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFIS012 ºAutor  ³Cristiano Pereira   º Data ³  24/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Apropriação custo Pis Cofins                                 º±±
±±º          ³                                                            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³          ³Especifico Steck Industria                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function STFIS012()


	Local aArea    := GetArea()
	Local aRet     := {}
	Local aParam   := {}
	Private _dAdDe := Ctod(Space(8))
	Private _dAdAt :=  Ctod(Space(8))

    aAdd(aParam, {1, "Data De:",  _dAdDe,  ,,,, 50, .T.})
	aAdd(aParam, {1, "Data Até:", _dAdAt,  ,,,, 50, .T.})

	If !ParamBox(aParam,"Informe os dados", @aRet,,,,,,,,.F.,.F.)
		RestArea( aArea )
		Return
	EndIf


	Processa( {|| aDados := getProcess() }, "Aguarde, Filtrando registros")

	

Return .T.

/*/{Protheus.doc} getProcess
(long_description)
Retorna array com os dados a serem apresentados
@author user
Valdemir José Rabelo - SigaMat
@since date
21/03/2020
@example
(examples)
/*/
Static Function getProcess()

	Local cQry      := GetQryProc()
	Local aRET      := {}
	Local nTotal    := 0
	Local cAlias    := GetNextAlias()


	IF Select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	Endif

	cQry := ChangeQuery( cQry )
	TcQuery cQry New Alias (cAlias)
 
	dbSelectArea(cAlias)
	dbGotop()
	COUNT TO nTotal

	ProcRegua(nTotal)

	dbSelectArea(cAlias)
	dbGotop()



	While (cAlias)->(!Eof())


		IncProc()

        DbSelectArea("SD1")
        DbSetOrder(1)
        If DbSeek(xFilial("SD1")+(cAlias)->D1_DOC+(cAlias)->D1_SERIE+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA+(cAlias)->D1_COD+(cAlias)->D1_ITEM)
              If Reclock("SD1",.F.)
                      SD1->D1_CUSTO  := D1_TOTAL-D1_BASIMP5*(4.60/100)-D1_BASIMP6*(1/100)-D1_VALICM+D1_VALIPI
                 MsUnlock()   
              Endif
        Endif
	

		(cAlias)->( dbSkip())
	EndDo

	IF Select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	Endif

    MsgInfo("Processamento realizado com sucesso..","Atenção")


Return aRET



/*/{Protheus.doc} GetQryProc
(long_description)
Retorna query montada
@author user
Cristiano Pereira - SigaMat
@since date
21/03/2020
@example
(examples)
/*/
Static Function GetQryProc()

	Local cRET   := ""
	Local cDATA1 := DTOS(MV_PAR01)
	Local cDATA2 := DTOS(MV_PAR02)



	cRET += "SELECT " + CRLF
	cRET += " SD1.* " + CRLF 
	cRET += "FROM " + RETSQLNAME("SD1") + " SD1                         " + CRLF
	cRET += "WHERE SD1.D_E_L_E_T_ = ' '                  AND            " + CRLF           
    cRET += "      SD1.D1_FILIAL ='"+xFilial("SD1")+"'             AND  " + CRLF
	cRET += "      SD1.D1_TES IN ('005')                           AND  " + CRLF
    cRET += "      SD1.D1_FORNECE IN ('005866')                    AND  " + CRLF
	cRET += "      SD1.D1_DTDIGIT>='"+cDATA1+"'                    AND  " + CRLF
	cRET += "      SD1.D1_DTDIGIT <='"+cDATA2+"'                        "  + CRLF
    

	cRET += "ORDER BY D1_FILIAL,D1_DOC,D1_FORNECE,D1_LOJA                     " + CRLF

Return cRET


