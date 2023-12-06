#include "Totvs.ch"
#Include "Protheus.ch"
#Include "TbiConn.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} JOBPDVTRP
    (long_description)
    Rotina Job verifica transportadoras sem utilização nos ultimos 3 meses
    @type  Function
    @author user
    @since 12/11/2020
    @version version
    @example
    (examples)
    @see (links_or_references)
    u_JOBPDVTRP
/*/
User Function JOBPDVTRP()
    Local aEmpFil   := {}
    Local nX        := 0

    //aAdd(aEmpFil, {'01','01'})          // Empresa: 01
    aAdd(aEmpFil, {'01','02'})
    //aAdd(aEmpFil, {'01','03'})
    //aAdd(aEmpFil, {'01','04'})
    //aAdd(aEmpFil, {'03','01'})          // Empresa: 03
    //aAdd(aEmpFil, {'03','02'})

	AutoGrLog( "**********************************************************************************************************" )
	AutoGrLog( "*    INICIO LEITURA - PROCURA DE REGISTROS DE TRANSPORTADORA NÃO UTILIZADA NOS ULTIMOS 3 MESES VIA JOB   *" )
	AutoGrLog( "**********************************************************************************************************" )    
    
    For nX := 1 to Len(aEmpFil)
        RpcClearEnv()	
        RpcSetType(3)
        RpcSetEnv(aEmpFil[nX][1],aEmpFil[nX][2],,,,GetEnvServer(),{ "SC5","SA4" } )
        SetModulo("SIGAFAT","FAT")

        // Inicia Processo
        JOBVLDTRAN()

        RpcClearEnv()

    Next

    AutoGrLog( "*******************************************************************" )
	AutoGrLog( "*    TERMINO LEITURA JOB (JOBPDVTRP)                              *" )
	AutoGrLog( "*******************************************************************" )

    
Return .T.



Static Function JOBVLDTRAN()
    Local cQry    := getSqlTran()
    Local aAreasT := GetArea()
    Local aDados  := {}
    Local cAssunto:= "WORKFLOW TRANSPORTADORA SEM UTILIZAÇÃO NOS ULTIMOS 90 DIAS"
    Local cPara   := GetMV('ST_WFTRANS',.F.,"carla.lodetti@steck.com.br,valdemir.rabelo@sigamat.com.br")
    Local cCC     := ""

    dbSelectArea("SA4")
    dbSetOrder(1)

    if Select("TTAB") > 0
       TTAB->( dbCloseArea() )
    Endif 

    TcQuery cQry New Alias "TTAB"

    While TTAB->( !Eof() )
        SA4->( dbGoto(TTAB->REG) )

        aAdd(aDados, {"Cod.Transp....: ", SA4->A4_COD})
        aAdd(aDados, {"Transportadora: ", SA4->A4_NOME})
        aAdd(aDados, {"Status........: ", 'Bloqueado'})
        aAdd(aDados, {"                ", ''})
        
        RecLock('SA4',.F.)
        SA4->A4_XBLQ := '2'
        MsUnlock()
        

        TTAB->( dbSkip() )
    EndDo

    TTAB->( dbCloseArea() )

    IF Len(aDados) > 0
       u_EMailST(cPara, cCC, cAssunto, aDados)
    Endif 

    RestArea( aAreasT )

Return 


/*/{Protheus.doc} getSqlTran
description
Rotina Monta Filro buscando registro não utilizados nos ultimos 90 dias
@type function
@version 
@author Valdemir Jose
@since 12/11/2020
@return return_type, return_description
/*/
Static Function getSqlTran()
    Local cRET := ""

    cRET += "SELECT R_E_C_N_O_ REG FROM "+RETSQLNAME('SA4')+" A" + CRLF 
    cRET += "WHERE A.D_E_L_E_T_ =' '" + CRLF 
    cRET += " AND A4_XBLQ='1'       " + CRLF 
    cRET += " AND A4_COD NOT IN(SELECT C5_TRANSP FROM "+RETSQLNAME('SC5')+" SC5" + CRLF 
    cRET += "                   WHERE SC5.D_E_L_E_T_=' ' " + CRLF 
    cRET += "                    AND  C5_EMISSAO BETWEEN '"+dtos(dDatabase-90)+"' AND '"+dtos(dDatabase)+"' " + CRLF 
    cRET += "                    AND C5_FILIAL='"+XFILIAL('SC5')+"' )" + CRLF 

Return cRET


