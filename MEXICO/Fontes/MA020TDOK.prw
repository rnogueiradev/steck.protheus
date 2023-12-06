#include "protheus.ch"

/*

/* **********************************************************

         _.-'~~~~~~'-._            | Funcion: 		MA020TOK                                        
        /      ||      \           |                                        
       /       ||       \          | Descripcion: 	inclusion de Proveedores en CTD 
      |        ||        |         | 				                     
      | _______||_______ |         |                                        
      |/ ----- \/ ----- \|         | Parametros:	                                       
     /  (     )  (     )  \        | 				                                     
    / \  ----- () -----  / \       |                                        
   /   \      /||\      /   \      | Retorno:		                                      
  /     \    /||||\    /     \     |
 /       \  /||||||\  /       \    |                                        
/_        \o========o/        _\   | Autor:                               
  '--...__|'-._  _.-'|__...--'     | Modificado por: Daniel Mira                                        
          |    ''    |             | Fecha: 2020 04 01
************************************************************** */




//User Function MA020TOK()
User Function MA020TDOK()
	Local lRet:=.T.
	
	Local lDup:=.F.  

	if(alltrim(M->A2_COD)='')
		MsgStop("El Codigo puede estar vacio","Validacion Codigo")
		lRet:=.F.
		return lRet
	endIf
		cQryI :="SELECT CTD_ITEM, R_E_C_N_O_"
		cQryI +=" FROM "+RetSqlName("CTD")
		cQryI +=" WHERE  D_E_L_E_T_<>'*' AND CTD_FILIAL=" + CHR(39) + alltrim(xfilial("CTD")) + CHR(39) + " and CTD_ITEM="+ CHR(39) + ALLTRIM(M->A2_COD) + CHR(39)
		cQryI  := ChangeQuery(cQryI )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryI),"QRYITM",.F.,.T.)
	    if !QRYITM->(EOF())
	    	lDup:=.T.
            if(Type("lAutoma")=="L")
                    CTD->(DBGOTO(QRYITM->R_E_C_N_O_))
                    CTD->(Reclock("CTD",.F.))
                    CTD->CTD_DESC01   := M->A2_NOME
                    CTD->(MsUnlock())	
            else
                //if(MsgYesNo("Item ya existente.  ¿Desea actualizar?","Actualizacion Item"))
                    CTD->(DBGOTO(QRYITM->R_E_C_N_O_))
                    CTD->(Reclock("CTD",.F.))
                    CTD->CTD_DESC01   := M->A2_NOME
                    CTD->(MsUnlock())	
                //endIf
            endIf
	    Endif
		QRYITM->(dbCloseArea())
		
		if(!lDup)
		    Reclock("CTD",.T.)
		  	CTD->CTD_FILIAL :=xFilial("CTD")
		  	CTD->CTD_ITEM   :=alltrim(M->A2_COD)
		  	CTD->CTD_DESC01 := M->A2_NOME
		  	CTD->CTD_CLASSE := "2"
		  	CTD->CTD_BLOQ := "2"
		  	CTD->CTD_DTEXIS := STOD('20191231')//dDatabase
		  	CTD->(MsUnlock())	
		endIf

Return lRet
