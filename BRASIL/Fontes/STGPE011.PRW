#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_STGPE011

Valida as marcações do Meu RH

@type function
@author Everson Santana
@since 30/12/20
@version Protheus 12 - Portal Meu RH

@history ,Ticket 20201203011635 ,

/*/

User Function STGPE011()

    Local _cQuery   := ""
    Local _cAlias	:= GetNextAlias()
    Local _cQuery1  := ""
    Local _cAlias1	:= GetNextAlias()
    Local _sPonmes  := ""
    Local _aPon     := {}
    Local _cTpMarca := ""
    Local n         := 0
    Local _cLockBy  := ""

    _cLockBy		:= "STGPE011"

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '03'

    If !LockByName(_cLockBy,.F.,.F.,.T.)
        Return()
    EndIf

    _sPonmes  := GetMv('MV_PONMES')

    _cQuery := " SELECT RS3_MAT,RS3_DATA, RS3_HORA, RS3_STATUS, RS3_JUSTIF, RS3_CODIGO, RH3_STATUS, RS3_FILIAL, P8_TPMCREP, P8_MOTIVRG, RS3_LATITU, RS3_LONGIT, P8_LATITU, P8_LONGIT "
    _cQuery += "    		FROM "+RetSqlName("RS3")+" RS3 "
    _cQuery += " INNER JOIN "+RetSqlName("RH3")+" RH3 ON "
    _cQuery += "		RS3_FILIAL = RH3_FILIAL AND"
    _cQuery += "		RS3_CODIGO = RH3_CODIGO "
    _cQuery += "	LEFT JOIN "+RetSqlName("SP8")+" SP8 ON "
    _cQuery += "		RS3_FILIAL = P8_FILIAL AND "
    _cQuery += "		RS3_MAT = P8_MAT AND "
    _cQuery += "		RS3_DATA = P8_DATA AND "
    _cQuery += "		RS3_HORA = P8_HORA "
    _cQuery += "	WHERE RS3_FILIAL = '"+xFilial("RS3")+"' AND "
    _cQuery += "    RS3_DATA = '"+DtoS(dDataBase)+"' AND "
    //_cQuery += " RS3_DATA >= '20210110' AND RS3_DATA <= '20210209' AND "
    //_cQuery += "	RS3_MAT = '000100' AND " //Retirar
    //_cQuery += "	RS3_DATA >= '"+Substring(_sPonmes,1,8)+"' AND " //20201210/20210109
    //_cQuery += "	RS3_DATA <= '"+Substring(_sPonmes,10,8)+"' AND "
    _cQuery += "	RS3.D_E_L_E_T_ = ' ' AND "
    _cQuery += "    RH3.D_E_L_E_T_ = ' ' AND "
    _cQuery += "	RS3_STATUS NOT IN ('3') AND " //Aguardando Aprovação
    _cQuery += "    SP8.D_E_L_E_T_ IS NULL "
    _cQuery += "	ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA "

    If Select(_cAlias) > 0
        Dbselectarea(_cAlias)
        (_cAlias)->(DbClosearea())
    EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

    dbSelectArea(_cAlias)
    (_cAlias)->(dbGoTop())

    while !((_cAlias)->(eof()))

        _cQuery1 := " SELECT P8_CC,P8_FILIAL,P8_MAT,P8_DATA,P8_ORDEM,P8_FLAG,P8_APONTA,P8_TURNO,P8_TPMARCA,P8_PAPONTA,P8_DATAAPO,P8_SEMANA,P8_TIPOREG,P8_DATAALT,P8_USUARIO,P8_LATITU,P8_LONGIT, RS3_MAT,RS3_DATA,P8_HORA, RS3_HORA, RS3_STATUS, RS3_JUSTIF, RS3_CODIGO, RH3_STATUS, RS3_FILIAL, RS3_LATITU, RS3_LONGIT  "
        _cQuery1 += "    		FROM "+RetSqlName("RS3")+" RS3 "
        _cQuery1 += " INNER JOIN "+RetSqlName("RH3")+" RH3 ON "
        _cQuery1 += "		RS3_FILIAL = RH3_FILIAL AND"
        _cQuery1 += "		RS3_CODIGO = RH3_CODIGO "
        _cQuery1 += "	LEFT JOIN "+RetSqlName("SP8")+" SP8 ON "
        _cQuery1 += "		RS3_FILIAL = P8_FILIAL AND "
        _cQuery1 += "		RS3_MAT = P8_MAT AND "
        _cQuery1 += "		RS3_DATA = P8_DATA AND "
        _cQuery1 += "		RS3_HORA = P8_HORA "
        _cQuery1 += "	WHERE RS3_FILIAL = '"+(_cAlias)->RS3_FILIAL+"' AND "
        _cQuery1 += "	RS3_MAT = '"+(_cAlias)->RS3_MAT+"' AND " 
        _cQuery1 += "	RS3_DATA = '"+(_cAlias)->RS3_DATA+"' AND "
        _cQuery1 += "	RS3.D_E_L_E_T_ = ' ' AND "
        _cQuery1 += "    RH3.D_E_L_E_T_ = ' ' AND "
        _cQuery1 += "	RS3_STATUS NOT IN ('3') AND " //Aguardando Aprovação
        _cQuery1 += "    ( SP8.D_E_L_E_T_ = ' ' OR SP8.D_E_L_E_T_ IS NULL ) "
        _cQuery1 += "	ORDER BY RS3_FILIAL, RS3_MAT, RS3_DATA, RS3_HORA "

        If Select(_cAlias1) > 0
            Dbselectarea(_cAlias1)
            (_cAlias1)->(DbClosearea())
        EndIf

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

        dbSelectArea(_cAlias1)
        (_cAlias1)->(dbGoTop())

        While !((_cAlias1)->(eof()))

            If Empty(_cTpMarca)
                _cTpMarca := "1E"
            ElseIf _cTpMarca == "1E"
                _cTpMarca := "1S"
            ElseIf _cTpMarca == "1S"
                _cTpMarca := "2E"
            ElseIf _cTpMarca == "2E"
                _cTpMarca := "2S"
            EndIf

            aAdd(_aPon, {   Iif (Empty((_cAlias1)->P8_FILIAL),(_cAlias1)->RS3_FILIAL,(_cAlias1)->P8_FILIAL),;
                Iif (Empty((_cAlias1)->P8_MAT),(_cAlias1)->RS3_MAT,(_cAlias1)->P8_MAT),;
                Iif (Empty((_cAlias1)->P8_DATA),(_cAlias1)->RS3_DATA,(_cAlias1)->P8_DATA),;
                STORDEM((_cAlias1)->RS3_FILIAL,(_cAlias1)->RS3_DATA,(_cAlias1)->RS3_MAT),;
                Iif (Empty((_cAlias1)->P8_FLAG),"P",(_cAlias1)->P8_FLAG),;
                Iif (Empty((_cAlias1)->P8_APONTA),"S",(_cAlias1)->P8_APONTA),;
                Iif (Empty((_cAlias1)->P8_TURNO),Posicione("SRA",1,(_cAlias1)->RS3_FILIAL+(_cAlias1)->RS3_MAT,"RA_TNOTRAB"),(_cAlias1)->P8_TURNO),;
                _cTpMarca,;
                StrTran(_sPonmes,"/",""),;
                Iif (Empty((_cAlias1)->P8_DATAAPO),(_cAlias1)->RS3_DATA,(_cAlias1)->P8_DATAAPO),;
                Iif (Empty((_cAlias1)->P8_SEMANA),"01",(_cAlias1)->P8_SEMANA),;
                Iif (Empty((_cAlias1)->P8_TIPOREG),"O",(_cAlias1)->P8_TIPOREG),;
                Iif (Empty((_cAlias1)->P8_DATAALT),(_cAlias1)->RS3_DATA,(_cAlias1)->P8_DATAALT),;
                Iif (Empty((_cAlias1)->P8_USUARIO),"000000",(_cAlias1)->P8_USUARIO),;
                Iif (Empty((_cAlias1)->P8_LATITU),(_cAlias1)->RS3_LATITU,(_cAlias1)->P8_LATITU),;
                Iif (Empty((_cAlias1)->P8_LONGIT),(_cAlias1)->RS3_LONGIT,(_cAlias1)->P8_LONGIT),;
                Iif (Empty((_cAlias1)->P8_HORA),(_cAlias1)->RS3_HORA,(_cAlias1)->P8_HORA),;
                Iif (Empty((_cAlias1)->P8_CC),Posicione("SRA",1,(_cAlias1)->RS3_FILIAL+(_cAlias1)->RS3_MAT,"RA_CC"),(_cAlias1)->P8_CC);
                })

            (_cAlias1)->(dbskip())

        end

        DbSelectArea("SP8")
        DbSetOrder(2)
        DbGotop()

        For n:= 1 to Len(_aPon)

            If DbSeek(_aPon[n][01]+_aPon[n][02]+_aPon[n][03]+STR(_aPon[n][17],5,2)) 

                RECLOCK("SP8",.F.)

                SP8->P8_ORDEM   := IIf(Empty(SP8->P8_ORDEM),_aPon[n][04],SP8->P8_ORDEM)
                SP8->P8_FLAG    := IIf(Empty(SP8->P8_FLAG),_aPon[n][05],SP8->P8_FLAG)
                SP8->P8_APONTA  := IIf(Empty(SP8->P8_APONTA),_aPon[n][06],SP8->P8_APONTA)
                SP8->P8_TURNO   := IIf(Empty(SP8->P8_TURNO),_aPon[n][07],SP8->P8_TURNO)
                SP8->P8_TPMARCA := _aPon[n][08]
                SP8->P8_PAPONTA := IIf(Empty(SP8->P8_PAPONTA),_aPon[n][09],SP8->P8_PAPONTA)
                SP8->P8_DATAAPO := IIf(Empty(SP8->P8_DATAAPO),Stod(_aPon[n][10]),SP8->P8_DATAAPO)
                SP8->P8_SEMANA  := IIf(Empty(SP8->P8_SEMANA),_aPon[n][11],SP8->P8_SEMANA)
                SP8->P8_TIPOREG := IIf(Empty(SP8->P8_TIPOREG),_aPon[n][12],SP8->P8_TIPOREG)
                SP8->P8_DATAALT := IIf(Empty(SP8->P8_DATAALT),Stod(_aPon[n][13]),SP8->P8_DATAALT)
                SP8->P8_USUARIO := IIf(Empty(SP8->P8_USUARIO),_aPon[n][14],SP8->P8_USUARIO)
                SP8->P8_LATITU  := IIf(Empty(SP8->P8_LATITU),_aPon[n][15],SP8->P8_LATITU)
                SP8->P8_LONGIT  := IIf(Empty(SP8->P8_LONGIT),_aPon[n][16],SP8->P8_LONGIT)

                MSUNLOCK()

            else

                RECLOCK("SP8",.T.)

                SP8->P8_FILIAL  := _aPon[n][01]
                SP8->P8_MAT     := _aPon[n][02]
                SP8->P8_DATA    := Stod(_aPon[n][03])
                SP8->P8_ORDEM   := _aPon[n][04]
                SP8->P8_FLAG    := _aPon[n][05]
                SP8->P8_APONTA  := _aPon[n][06]
                SP8->P8_TURNO   := _aPon[n][07]
                SP8->P8_TPMARCA := _aPon[n][08]
                SP8->P8_PAPONTA := _aPon[n][09]
                SP8->P8_DATAAPO := Stod(_aPon[n][10])
                SP8->P8_SEMANA  := _aPon[n][11]
                SP8->P8_TIPOREG := _aPon[n][12]
                SP8->P8_DATAALT := Stod(_aPon[n][13])
                SP8->P8_USUARIO := _aPon[n][14]
                SP8->P8_LATITU  := _aPon[n][15]
                SP8->P8_LONGIT  := _aPon[n][16]
                SP8->P8_HORA    := _aPon[n][17]
                SP8->P8_CC      := _aPon[n][18]

                MSUNLOCK()

            EndIf
        Next
        _aPon := {}
        _cTpMarca := " "
        (_cAlias)->(dbskip())
    end

    UnLockByName(_cLockBy,.F.,.F.,.T.)
    Reset Environment

Return

Static Function STORDEM(_Filial,_Data,_Mat)

    Local _cQuery2 := ""
    Local _cAlias2	:= GetNextAlias()
    Local _cQuery3 := ""
    Local _cAlias3	:= GetNextAlias()
    Local _nRet     := ""

    _cQuery2 := " SELECT MAX(P8_ORDEM) P8_ORDEM FROM SP8010 "
    _cQuery2 += "    WHERE P8_FILIAL = '"+_Filial+"' "
    _cQuery2 += "        AND P8_DATA = '"+_Data+"' "
    _cQuery2 += " AND P8_MAT = '"+_Mat+"' "
    _cQuery2 += " AND D_E_L_E_T_ = ' ' "

    If Select(_cAlias2) > 0
        Dbselectarea(_cAlias2)
        (_cAlias2)->(DbClosearea())
    EndIf

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

    dbSelectArea(_cAlias2)
    (_cAlias2)->(dbGoTop())

    If Empty((_cAlias2)->P8_ORDEM)

        _cQuery3 := " SELECT MAX(P8_ORDEM) P8_ORDEM FROM SP8010 "
        _cQuery3 += "    WHERE P8_FILIAL = '"+_Filial+"' "
        _cQuery3 += "        AND P8_DATA = '"+_Data+"' "
        _cQuery3 += " AND D_E_L_E_T_ = ' ' "

        If Select(_cAlias3) > 0
            Dbselectarea(_cAlias3)
            (_cAlias3)->(DbClosearea())
        EndIf

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

        dbSelectArea(_cAlias3)
        (_cAlias3)->(dbGoTop())

        If Empty((_cAlias3)->P8_ORDEM)
            _nRet := "01"
        else
            _nRet := (_cAlias3)->P8_ORDEM
        EndIf

    Else
        _nRet := (_cAlias2)->P8_ORDEM
    EndIf

Return(_nRet)
