#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STESTF01() บAutor  ณ Vitor Merguizo   บ Data ณ  28/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para atualiza็ใo do custo das MOD's a partir do valorบฑฑ
ฑฑบDesc.     ณinformado pelo usuแrio                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STESTF02()

Local nx		:= 0
Local cAlias	:= "QRYEST2"
Local cQuery	:= ""
Local cQueryUpd	:= ""
Local aNumSeq	:= {}
Local aParam	:= {}
/*
cQueryUpd := " UPDATE SD3010 SET D3_CF='RE1' "
cQueryUpd += " WHERE D3_EMISSAO BETWEEN '20130701' AND '20130731' AND D3_CF='RE2' AND D3_OP <> ' ' AND D_E_L_E_T_ = ' ' "
TcSqlExec(cQueryUpd)

aAdd(aNumSeq,{'9AAN3G',3.8053})
aAdd(aNumSeq,{'9AAN3H',3.8472})
aAdd(aNumSeq,{'9AAN3S',3.8053})
aAdd(aNumSeq,{'9AAN4A',4.0319})
aAdd(aNumSeq,{'9AAN4B',4.0319})
aAdd(aNumSeq,{'9AAN4C',4.0319})
aAdd(aNumSeq,{'9AAN4D',6.7109})
aAdd(aNumSeq,{'9AAN4E',6.6296})
aAdd(aNumSeq,{'9AAN4F',6.8472})
aAdd(aNumSeq,{'9AAN4G',6.7764})
aAdd(aNumSeq,{'9AAN4H',6.7764})
aAdd(aNumSeq,{'9AAN44',3.8053})
aAdd(aNumSeq,{'9AAN46',3.8053})
aAdd(aNumSeq,{'9AAN49',4.0319})
aAdd(aNumSeq,{'9AAN5A',9.86592})
aAdd(aNumSeq,{'9AAN5B',9.60447})
aAdd(aNumSeq,{'9AAN5C',9.7982})
aAdd(aNumSeq,{'9AAN5D',9.871})
aAdd(aNumSeq,{'9AAN5M',9.8834})
aAdd(aNumSeq,{'9AAN5N',9.8111})
aAdd(aNumSeq,{'9AAN50',6.801})
aAdd(aNumSeq,{'9AAN51',7.5174})
aAdd(aNumSeq,{'9AAN58',6.68334})
aAdd(aNumSeq,{'9AAN59',7.0785})
aAdd(aNumSeq,{'9AAN6H',10.8359})
aAdd(aNumSeq,{'9AAN6J',10.3807})
aAdd(aNumSeq,{'9AAN68',10.5602})
aAdd(aNumSeq,{'9AAQUO',2.49895})
aAdd(aNumSeq,{'9AAR8B',28.4179})
aAdd(aNumSeq,{'9AAVA0',155.50582})
aAdd(aNumSeq,{'9AAYOV',68.35508})
aAdd(aNumSeq,{'9ABBXB',1.1686})
aAdd(aNumSeq,{'9ABBXC',3.409})
aAdd(aNumSeq,{'9ABBXD',0.9991})
aAdd(aNumSeq,{'9ABBXE',4.8871})
aAdd(aNumSeq,{'9ABBXF',24.7296})
aAdd(aNumSeq,{'9ABBX1',16.5052})
aAdd(aNumSeq,{'9ABBX3',28.7291})
aAdd(aNumSeq,{'9ABBX8',1.1153})
aAdd(aNumSeq,{'9ABBYY',3.8117})
aAdd(aNumSeq,{'9ABIWE',0.1384})
aAdd(aNumSeq,{'9ABIWP',0.39359})
aAdd(aNumSeq,{'9ABIWQ',0.5928})
aAdd(aNumSeq,{'9ABJYJ',101.95})
aAdd(aNumSeq,{'9ABJY8',921.6497})
aAdd(aNumSeq,{'9ABJZF',24.0504})
aAdd(aNumSeq,{'9ABJZU',1.4046})
aAdd(aNumSeq,{'9ABJZ4',54.6694})
aAdd(aNumSeq,{'9ABLAC',20.4218})
aAdd(aNumSeq,{'9ABOMF',34.90659})
aAdd(aNumSeq,{'9ABOMG',56.7899})
aAdd(aNumSeq,{'9ABOMY',54.6694})
aAdd(aNumSeq,{'9ABOMZ',52.4873})
aAdd(aNumSeq,{'9ABOM4',11.889})
aAdd(aNumSeq,{'9ABOM7',11.0692})
aAdd(aNumSeq,{'9ABOM8',12.1752})
aAdd(aNumSeq,{'9ABONW',23.599})
aAdd(aNumSeq,{'9ABONX',37.3231})
aAdd(aNumSeq,{'9ABOO1',101.6435})
aAdd(aNumSeq,{'9ABOO2',9.1219})
aAdd(aNumSeq,{'9ABOO3',11.4152})
aAdd(aNumSeq,{'9ABOO5',11.8073})
aAdd(aNumSeq,{'9ABSHS',0.0806})
aAdd(aNumSeq,{'9ABSIE',0.0767})
aAdd(aNumSeq,{'9ABSIM',0.1186})
aAdd(aNumSeq,{'9ABSI7',0.09})
aAdd(aNumSeq,{'9ABSI8',0.1225})
aAdd(aNumSeq,{'9ABSI9',0.1264})
aAdd(aNumSeq,{'9ABSJJ',0.1566})
aAdd(aNumSeq,{'9ABSJK',0.1658})
aAdd(aNumSeq,{'9ABSLF',0.2243})
aAdd(aNumSeq,{'9ABSL7',0.1775})
aAdd(aNumSeq,{'9ABSL9',48.71})
aAdd(aNumSeq,{'9ABSMM',0.2831})
aAdd(aNumSeq,{'9ABSM1',0.2431})
aAdd(aNumSeq,{'9ABSN3',0.2613})
aAdd(aNumSeq,{'9ABSPN',0.3278})
aAdd(aNumSeq,{'9ABSQB',0.5032})
aAdd(aNumSeq,{'9ABSWH',0.22517})
aAdd(aNumSeq,{'9ABTAP',1.3384})
aAdd(aNumSeq,{'9ABTAS',0.1143})
aAdd(aNumSeq,{'9ABTAT',0.1807})
aAdd(aNumSeq,{'9ABTA4',0.7359})
aAdd(aNumSeq,{'9ABTA5',1.5144})
aAdd(aNumSeq,{'9ABTBG',0.2612})
aAdd(aNumSeq,{'9ABTBR',0.3384})
aAdd(aNumSeq,{'9ABTB9',0.2883})
aAdd(aNumSeq,{'9ABT2T',0.2132})
aAdd(aNumSeq,{'9ABT6N',0.316})
aAdd(aNumSeq,{'9ABT8F',0.3654})
aAdd(aNumSeq,{'9ABT8L',0.604})
aAdd(aNumSeq,{'9ABT83',0.2763})
aAdd(aNumSeq,{'9ABT9E',0.7514})
aAdd(aNumSeq,{'9AB5HK',18.19396})
aAdd(aNumSeq,{'9AB6BW',64.75})
aAdd(aNumSeq,{'9AB7KW',12.4493})
aAdd(aNumSeq,{'9AB7L3',101.6435})
aAdd(aNumSeq,{'9AB7L7',16.0528})
aAdd(aNumSeq,{'9ACF1R',11.05})
aAdd(aNumSeq,{'9ACF1S',11.90604})
aAdd(aNumSeq,{'9ACF2J',11.2355})
aAdd(aNumSeq,{'9ACF2M',3.38546})
aAdd(aNumSeq,{'9ACF3Q',239.21565})
aAdd(aNumSeq,{'9ACIXG',23.4614})
aAdd(aNumSeq,{'9ACJTM',67.006})
aAdd(aNumSeq,{'9ACK75',71.317})
aAdd(aNumSeq,{'9ACLON',86.5937})
aAdd(aNumSeq,{'9ACM9T',1.3384})
aAdd(aNumSeq,{'9ACOVU',0.0166})
aAdd(aNumSeq,{'9ACOWD',0.015})
aAdd(aNumSeq,{'9ACOWP',0.0147})
aAdd(aNumSeq,{'9ACSD4',34.90659})
aAdd(aNumSeq,{'9ACS5V',107.38758})
aAdd(aNumSeq,{'9ACUAU',96.65966})
aAdd(aNumSeq,{'9ACUG1',38.4232})
aAdd(aNumSeq,{'9ACUT5',0.0193})
aAdd(aNumSeq,{'9ACUT6',0.2658})
aAdd(aNumSeq,{'9ACVXC',0.0193})
aAdd(aNumSeq,{'9ACVYH',0.0193})
aAdd(aNumSeq,{'9ACVZP',0.0193})
aAdd(aNumSeq,{'9ACV2G',4.1709})
aAdd(aNumSeq,{'9ACV2P',5.8617})
aAdd(aNumSeq,{'9ACV2S',5.0741})
aAdd(aNumSeq,{'9ACV3L',5.4485})
aAdd(aNumSeq,{'9ACV3M',4.6747})
aAdd(aNumSeq,{'9ACV31',5.631})
aAdd(aNumSeq,{'9ACV39',3.735})
aAdd(aNumSeq,{'9ACV4C',0.0193})
aAdd(aNumSeq,{'9ACV42',0.0193})
aAdd(aNumSeq,{'9ACV5N',0.0189})
aAdd(aNumSeq,{'9ACV5S',6.972})
aAdd(aNumSeq,{'9ACV6A',0.0193})
aAdd(aNumSeq,{'9ACWCH',0.0193})
aAdd(aNumSeq,{'9ACW0R',0.5866})
aAdd(aNumSeq,{'9ACW05',0.5479})
aAdd(aNumSeq,{'9ACW22',0.4903})
aAdd(aNumSeq,{'9ACXHA',0.0193})
aAdd(aNumSeq,{'9ACXHB',0.0193})
aAdd(aNumSeq,{'9ACXIF',0.01927})
aAdd(aNumSeq,{'9ACXIG',0.0193})
aAdd(aNumSeq,{'9ACXIH',0.0193})
aAdd(aNumSeq,{'9ACXI8',0.0193})
aAdd(aNumSeq,{'9ACXXT',5.6599})
aAdd(aNumSeq,{'9ACYGN',0.0192})
aAdd(aNumSeq,{'9ACZWH',0.0193})
aAdd(aNumSeq,{'9ACZWN',0.0193})
aAdd(aNumSeq,{'9AC6GI',832.67})
aAdd(aNumSeq,{'9ADA8O',1.4046})
aAdd(aNumSeq,{'9ADA8R',1.4046})
aAdd(aNumSeq,{'9ADA8Z',3.619})
aAdd(aNumSeq,{'9ADA92',3.619})
aAdd(aNumSeq,{'9ADA93',3.619})
aAdd(aNumSeq,{'9ADBKZ',2.0201})
aAdd(aNumSeq,{'9ADBLU',6.16973})
aAdd(aNumSeq,{'9ADBNL',3.7928})
aAdd(aNumSeq,{'9ADCQO',23.599})
aAdd(aNumSeq,{'9ADCRP',19.3015})
aAdd(aNumSeq,{'9ADCSG',1.84445})
aAdd(aNumSeq,{'9ADCSR',11.1141})
aAdd(aNumSeq,{'9ADCST',3.38546})
aAdd(aNumSeq,{'9ADCSU',11.2355})
aAdd(aNumSeq,{'9ADCSV',11.90604})
aAdd(aNumSeq,{'9ADCSW',11.05})
aAdd(aNumSeq,{'9ADND5',62.32})
aAdd(aNumSeq,{'9ADRA8',5.367})
aAdd(aNumSeq,{'9ADRC5',2.2235})
aAdd(aNumSeq,{'9ADRE7',20.6734})
aAdd(aNumSeq,{'9ADRGS',1.5232})
aAdd(aNumSeq,{'9ADRJN',2.8958})
aAdd(aNumSeq,{'9ADRPN',5.4485})
aAdd(aNumSeq,{'9ADR9K',0.303})
aAdd(aNumSeq,{'9ADR9M',5.367})
aAdd(aNumSeq,{'9ADSZK',0.0193})
aAdd(aNumSeq,{'9ADSZL',0.0193})
aAdd(aNumSeq,{'9ADSZM',0.0193})
aAdd(aNumSeq,{'9ADTEF',2.67862})
aAdd(aNumSeq,{'9AD1PQ',0.01927})
aAdd(aNumSeq,{'9AD1PR',0.0193})
aAdd(aNumSeq,{'9AD1PS',0.0193})
aAdd(aNumSeq,{'9AD1SY',0.0193})
aAdd(aNumSeq,{'9AD2AO',0.0193})
aAdd(aNumSeq,{'9AD2AP',0.0193})
aAdd(aNumSeq,{'9AD29F',0.0193})
aAdd(aNumSeq,{'9AD29M',0.1599})
aAdd(aNumSeq,{'9AD29P',0.0193})
aAdd(aNumSeq,{'9AD29Q',0.0193})
aAdd(aNumSeq,{'9AD3DU',34.2915})
aAdd(aNumSeq,{'9AD3FB',80.57834})
aAdd(aNumSeq,{'9AD3F4',71.21})
aAdd(aNumSeq,{'9AD33X',0.0193})
aAdd(aNumSeq,{'9AD34K',0.0193})
aAdd(aNumSeq,{'9AD34Q',0.0193})
aAdd(aNumSeq,{'9AD37T',18.5752})
aAdd(aNumSeq,{'9AD4EZ',3.22816})
aAdd(aNumSeq,{'9AD4RV',153.493})
aAdd(aNumSeq,{'9AD4RX',31.29327})
aAdd(aNumSeq,{'9AD451',0.0193})
aAdd(aNumSeq,{'9AD457',0.0193})
aAdd(aNumSeq,{'9AD5AC',53.8916})
aAdd(aNumSeq,{'9AD8AW',0.0193})
aAdd(aNumSeq,{'9AD8A6',0.0193})
aAdd(aNumSeq,{'9AD8A7',0.0193})
aAdd(aNumSeq,{'9AD8A8',0.0193})
aAdd(aNumSeq,{'9AD8B8',0.0193})
aAdd(aNumSeq,{'9AD8GC',0.0193})
aAdd(aNumSeq,{'9AD861',0.0193})
aAdd(aNumSeq,{'9AD88E',0.0193})
aAdd(aNumSeq,{'9AD88H',0.0193})
aAdd(aNumSeq,{'9AD88X',0.0193})
aAdd(aNumSeq,{'9AEEIH',153.493})
aAdd(aNumSeq,{'9AEIOX',17.04132})
aAdd(aNumSeq,{'9AEND5',13.5433})
aAdd(aNumSeq,{'9AEND6',11.3651})
aAdd(aNumSeq,{'9AEND7',17.4913})
aAdd(aNumSeq,{'9AEO7T',2.18593})
aAdd(aNumSeq,{'9AEO7U',6.3114})
aAdd(aNumSeq,{'9AEO7W',4.3278})
aAdd(aNumSeq,{'9AEO7X',7.028})
aAdd(aNumSeq,{'9AEO7Y',3.3556})
aAdd(aNumSeq,{'9AEO7Z',25.60523})
aAdd(aNumSeq,{'9AEQ59',14.9402})
aAdd(aNumSeq,{'9AE3MA',446.9801})
aAdd(aNumSeq,{'9AE3MB',7.6262})
aAdd(aNumSeq,{'9AE3MC',7.8473})
aAdd(aNumSeq,{'9AE3MD',10.18})
aAdd(aNumSeq,{'9AE3ME',7.784})
aAdd(aNumSeq,{'9AE3MF',9.25})
aAdd(aNumSeq,{'9AE3M7',58.024})
aAdd(aNumSeq,{'9AE3M8',34.8542})
aAdd(aNumSeq,{'9AE3M9',67.025})
aAdd(aNumSeq,{'9AE530',3.58})
aAdd(aNumSeq,{'9AE97J',69.98794})
aAdd(aNumSeq,{'9AE97K',48.1462})
aAdd(aNumSeq,{'9AFC9P',0.6382})
aAdd(aNumSeq,{'9AFEJY',13.026})
aAdd(aNumSeq,{'9AFRY2',921.67667})
aAdd(aNumSeq,{'9AF3OF',13.8849})
aAdd(aNumSeq,{'9AF3ON',15.335})
aAdd(aNumSeq,{'9AF4HB',7.2803})
aAdd(aNumSeq,{'9AF44W',0.6355})
aAdd(aNumSeq,{'9AF5J9',7.2803})
aAdd(aNumSeq,{'9AF75X',1.5232})
aAdd(aNumSeq,{'9AF75Y',1.4046})

For nx := 1 to Len(aNumSeq)
	cQueryUpd := " UPDATE SD3010 SET D3_CUSTO1=D3_QUANT*"+cValtoChar(aNumSeq[nx][2])+" , D3_CF='RE6' "
	cQueryUpd += " WHERE D3_NUMSEQ='"+aNumSeq[nx][1]+"' AND D3_CF='RE4' "
	TcSqlExec(cQueryUpd)

	cQueryUpd := " UPDATE SD3010 SET D3_CUSTO1=D3_QUANT*"+cValtoChar(aNumSeq[nx][2])+" , D3_CF='DE6' "
	cQueryUpd += " WHERE D3_NUMSEQ='"+aNumSeq[nx][1]+"' AND D3_CF='DE4' "
	TcSqlExec(cQueryUpd)
Next nx

/*
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

cQuery := " SELECT SD3.R_E_C_N_O_ SD3_REC, MAX(SB9.B9_CM1)B9_CM1, MAX(B2_CMFIM1)B2_CMFIM1 "
cQuery += " FROM SD3010 SD3 "
cQuery += " LEFT JOIN SB9010 SB9 ON SB9.B9_FILIAL = '01' AND SB9.B9_DATA = '20130531' AND SB9.B9_LOCAL = '01' AND SB9.B9_COD = D3_COD AND SB9.D_E_L_E_T_= ' ' "
cQuery += " LEFT JOIN SB2010 SB2 ON B2_FILIAL = '01' AND B2_COD = D3_COD AND SB2.D_E_L_E_T_= ' ' "
cQuery += " WHERE "
cQuery += " D3_EMISSAO BETWEEN '20130601' AND '20130630' AND "
cQuery += " D3_CUSTO1 = 0 AND "
cQuery += " D3_CF IN ('RE6','DE6') AND "
cQuery += " SD3.D_E_L_E_T_= ' ' OR D3_DOC IN ('SK09I9','SK09I8','SK0972','SK06VO','SK07RQ') "
cQuery += " GROUP BY SD3.R_E_C_N_O_ "

//cQuery	:= ChangeQuery(cQuery)
	
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TCSetField(cAlias, "B9_CM1",		"N", TamSX3("D1_CUSTO"  )[1], TamSX3( "D1_CUSTO" )[2] )
TCSetField(cAlias, "B2_CMFIM1",		"N", TamSX3("D1_CUSTO"  )[1], TamSX3( "D1_CUSTO" )[2] )
	
dbSelectArea(cAlias)
(cAlias)->(DbGoTop())

While (cAlias)->(!Eof())
	DbSelectArea("SD3")
	SD3->(DbGoTo((cAlias)->SD3_REC))
	RecLock('SD3',.F.)
	If (cAlias)->B9_CM1 > 0
		SD3->D3_CUSTO1 := SD3->D3_QUANT*(cAlias)->B9_CM1
	ElseIf (cAlias)->B2_CMFIM1 > 0
		SD3->D3_CUSTO1 := SD3->D3_QUANT*(cAlias)->B2_CMFIM1
	EndIF
	SD3->(MsUnLock())
	(cAlias)->(DbSkip())
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif
*/

aAdd(aParam,{'MV_APUSEP',GETMV('MV_APUSEP')})
aAdd(aParam,{'MV_ARMFOG',GETMV('MV_ARMFOG')})
aAdd(aParam,{'MV_ATUCOMP',GETMV('MV_ATUCOMP')})
aAdd(aParam,{'MV_C140TIT',GETMV('MV_C140TIT')})
aAdd(aParam,{'MV_CDATPL',GETMV('MV_CDATPL')})
aAdd(aParam,{'MV_CFC195',GETMV('MV_CFC195')})
aAdd(aParam,{'MV_CFC195',GETMV('MV_CFC195')})
aAdd(aParam,{'MV_CIAPDAC',GETMV('MV_CIAPDAC')})
aAdd(aParam,{'MV_CIAPVST',GETMV('MV_CIAPVST')})
aAdd(aParam,{'MV_COMBUS',GETMV('MV_COMBUS')})
aAdd(aParam,{'MV_COMPFRT',GETMV('MV_COMPFRT')})
aAdd(aParam,{'MV_CONV115',GETMV('MV_CONV115')})
aAdd(aParam,{'MV_DTINCB1',GETMV('MV_DTINCB1')})
aAdd(aParam,{'MV_ESTADO',GETMV('MV_ESTADO')})
aAdd(aParam,{'MV_ESTE113',GETMV('MV_ESTE113')})
aAdd(aParam,{'MV_ESTE240',GETMV('MV_ESTE240')})
aAdd(aParam,{'MV_F9CC',GETMV('MV_F9CC')})
aAdd(aParam,{'MV_F9CDATF',GETMV('MV_F9CDATF')})
aAdd(aParam,{'MV_F9CHVNF',GETMV('MV_F9CHVNF')})
aAdd(aParam,{'MV_F9CTBCC',GETMV('MV_F9CTBCC')})
aAdd(aParam,{'MV_F9DIF',GETMV('MV_F9DIF')})
aAdd(aParam,{'MV_F9ESP',GETMV('MV_F9ESP')})
aAdd(aParam,{'MV_F9FRT',GETMV('MV_F9FRT')})
aAdd(aParam,{'MV_F9FUNC',GETMV('MV_F9FUNC')})
aAdd(aParam,{'MV_F9GENCC',GETMV('MV_F9GENCC')})
aAdd(aParam,{'MV_F9GENCT',GETMV('MV_F9GENCT')})
aAdd(aParam,{'MV_F9ICMST',GETMV('MV_F9ICMST')})
aAdd(aParam,{'MV_F9ITEM',GETMV('MV_F9ITEM')})
aAdd(aParam,{'MV_F9PL',GETMV('MV_F9PL')})
aAdd(aParam,{'MV_F9PROD',GETMV('MV_F9PROD')})
aAdd(aParam,{'MV_F9SKPNF',GETMV('MV_F9SKPNF')})
aAdd(aParam,{'MV_F9VLLEG',GETMV('MV_F9VLLEG')})
aAdd(aParam,{'MV_HISTTAB',GETMV('MV_HISTTAB')})
aAdd(aParam,{'MV_INTTMS',GETMV('MV_INTTMS')})
aAdd(aParam,{'MV_MEDICA',GETMV('MV_MEDICA')})
aAdd(aParam,{'MV_NGD162',GETMV('MV_NGD162')})
aAdd(aParam,{'MV_NRPRBIC',GETMV('MV_NRPRBIC')})
aAdd(aParam,{'MV_OPSEMF',GETMV('MV_OPSEMF')})
aAdd(aParam,{'MV_P9SPED',GETMV('MV_P9SPED')})
aAdd(aParam,{'MV_PRDPRI',GETMV('MV_PRDPRI')})
aAdd(aParam,{'MV_PRFSPED',GETMV('MV_PRFSPED')})
aAdd(aParam,{'MV_REGSPED',GETMV('MV_REGSPED')})
aAdd(aParam,{'MV_RESF3FT',GETMV('MV_RESF3FT')})
aAdd(aParam,{'MV_SFRBCD2',GETMV('MV_SFRBCD2')})
aAdd(aParam,{'MV_SFUFGNR',GETMV('MV_SFUFGNR')})
aAdd(aParam,{'MV_SPDIFC',GETMV('MV_SPDIFC')})
aAdd(aParam,{'MV_SPDTC95',GETMV('MV_SPDTC95')})
aAdd(aParam,{'MV_SPEDNAT',GETMV('MV_SPEDNAT')})
aAdd(aParam,{'MV_SPEDQTD',GETMV('MV_SPEDQTD')})
aAdd(aParam,{'MV_STFRETE',GETMV('MV_STFRETE')})
aAdd(aParam,{'MV_STNIEUF',GETMV('MV_STNIEUF')})
aAdd(aParam,{'MV_SUBTRIB',GETMV('MV_SUBTRIB')})
aAdd(aParam,{'MV_UFRESPD',GETMV('MV_UFRESPD')})
aAdd(aParam,{'MV_USASPED',GETMV('MV_USASPED')})
aAdd(aParam,{'MV_USAXX8',GETMV('MV_USAXX8')})
aAdd(aParam,{'MV_VEICNV',GETMV('MV_VEICNV')})

MSGALERT("Processo Finalizado!!!")

Return

Static Function STESTF2A(cCod,cDocQ)

Local cAlias1	:= "QRYEST2A"
Local cQuery1	:= ""
Local nRet		:= 0

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

cQuery1 := " SELECT D1_CUSTO "
cQuery1 += " FROM SD1010 SD1 "
cQuery1 += " WHERE "
cQuery1 += " D1_COD = '"+cCod+"' AND "
cQuery1 += " D1_NUMCQ = '"+cDocQ+"' AND "
cQuery1 += " SD1.D_E_L_E_T_ = ' ' "

//cQuery1	:= ChangeQuery(cQuery1)
	
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1),cAlias1, .F., .T.)

TCSetField(cAlias1, "D1_CUSTO",		"N", TamSX3("D1_CUSTO"  )[1], TamSX3( "D1_CUSTO" )[2] )
	
dbSelectArea(cAlias1)
(cAlias1)->(DbGoTop())

While (cAlias1)->(!Eof())
	nRet := (cAlias1)->(D1_CUSTO)
	(cAlias1)->(DbSkip())
End

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

Return(nRet)