#include 'Protheus.ch'
#include 'RwMake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STUPDPE	ºAutor  ³Renato Nogueira     º Data ³  04/05/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Update de LT nos produtos			  					   	º±±
±±											    							º±±	    					    		   	 				        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STUPDPE(_cGrupo)

	Local cQuery 				:= ""
	Local cTemp 				:= "QRYTEMP"
	Local _nNewLT				:= 0
	Local aArea				:= {}
	Private M->B1_COD			:= ""
	Private M->B1_GRUPO		:= ""
	Private M->B1_CLAPROD	:= ""
	Private M->B1_XFMR		:= ""
	
	Return
	
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	SBM->(DbGoTop())
	SBM->(DbSeek(xFilial("SBM")+_cGrupo))

	cQuery := " SELECT B1_COD CODIGO "
	cQuery += " FROM "+RetSqlName("SB1")+" B1 "
	cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_GRUPO IN ( "
	cQuery += " SELECT BM_GRUPO "
	cQuery += " FROM "+RetSqlName("SBM")+" BM "
	cQuery += " WHERE BM.D_E_L_E_T_=' ' AND BM.BM_XDAYIF>0 AND BM.BM_GRUPO='"+_cGrupo+"' "
	cQuery += " ) AND B1_CLAPROD<>' ' AND B1_XFMR<>' ' "

	If !Empty(Select(cTemp))
		DbSelectArea(cTemp)
		(cTemp)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTemp,.T.,.T.)

	dbSelectArea(cTemp)
	(cTemp)->(dbGoTop())
	
	While (cTemp)->(!Eof())
	
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+(cTemp)->(CODIGO)))

		M->B1_COD			:= SB1->B1_COD
		M->B1_GRUPO			:= SB1->B1_GRUPO
		M->B1_CLAPROD		:= SB1->B1_CLAPROD
		M->B1_XFMR			:= SB1->B1_XFMR
		
		_nNewLT	:= U_STGETPE()
			
		SB1->(RecLock("SB1",.F.))
		SB1->B1_PE	:= _nNewLT
		SB1->(MsUnLock())
	
		(cTemp)->(DbSkip())
	EndDo

Return()