//FUNCION PARA IDENTIFICAR LOS QUE SON COMPENSACIONES
//SE AGREGO A LA FUNCION QUE YA EXISTIA EN BARNES
//NO COMPILAR

USER FUNCTION FA087BAIXA
    __aArea := Getarea()
    cRecibo := SEL->EL_RECIBO
    cQuery := "SELECT EL_RECIBO FROM " +RetSqlName("SEL")+ " WHERE EL_FILIAL = '"+ XFILIAL("SEL") +"' "  
    cQuery += "AND EL_RECIBO = '"+cRecibo+"' " 
    cQuery += "AND D_E_L_E_T_=' ' "   
    cQuery += "AND (EL_TIPO='TF ' OR EL_TIPO = 'CH ' OR EL_TIPO='EF ') "
    cQuery += "AND EL_CANCEL = 'F' "   
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"zRec",.F.,.F.)

    DBSELECTAREA("zRec")
    //SetRegua(RecCount())
    DBGotop()
    IF !Eof()
        lCompen := .F.
    else
        lCompen := .T.
    ENDIF
    zRec->(DBCLOSEAREA())
    RestArea(__aArea)
    IF SEL->EL_TIPODOC = "TB" .AND. (SEL->EL_TIPO="NF " .OR. SEL->EL_TIPO="NCC" )
        RecLock("SEL",.F.)
        SEL->EL_COMP    := lCompen
        MsUnLock()
    Endif
Return
