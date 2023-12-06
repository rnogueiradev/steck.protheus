#INCLUDE 'PROTHEUS.CH'   
//Fonte utilizado para instanciar os objetos do webservice
User Function TesteWs()

_oWsTeste := WSWSPEDIDOPORTAL():New()

_oWSTeste:oWSPEDIDO:oWSAPRODS := WSPEDIDOPORTAL_ARRAYOFITENS():NEW()

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_oWSTeste:oWSPEDIDO:CCCNPJCLI			 	:= "61505400000143"
_oWSTeste:oWSPEDIDO:CCCNPJENT			 	:= "61505400000143"
_oWSTeste:oWSPEDIDO:CCCNPJSTE			 	:= "05890658000130"
_oWSTeste:oWSPEDIDO:cCCONDPAG			 	:= "615"
_oWSTeste:oWSPEDIDO:CCOBSERV			 	:= "AAAA"
_oWSTeste:oWSPEDIDO:CCPEDCLI			 	:= "199146"
_oWSTeste:oWSPEDIDO:CCTIPOENT			 	:= "1"
_oWSTeste:oWSPEDIDO:CCTIPOFAT			 	:= "1"
_oWSTeste:oWSPEDIDO:CCTIPOFRE			 	:= "C"
_oWSTeste:oWSPEDIDO:DDDTENT			 		:= CTOD("27/12/2014")

_Obj:cCITEM			:= "1"
_Obj:CCITEMPED		:= "1"
_Obj:cCPRODUTO		:= "SCBB2T10"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "2"
_Obj:CCITEMPED		:= "2"
_Obj:cCPRODUTO		:= "SCV12PT"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "3"
_Obj:CCITEMPED		:= "3"
_Obj:cCPRODUTO		:= "S4676"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "4"
_Obj:CCITEMPED		:= "4"
_Obj:cCPRODUTO		:= "S007"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "5"
_Obj:CCITEMPED		:= "5"
_Obj:cCPRODUTO		:= "S303"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "6"
_Obj:CCITEMPED		:= "6"
_Obj:cCPRODUTO		:= "SCV5PT"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "7"
_Obj:CCITEMPED		:= "7"
_Obj:cCPRODUTO		:= "SDLS630"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "8"
_Obj:CCITEMPED		:= "8"
_Obj:cCPRODUTO		:= "SLPRN4"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "9"
_Obj:CCITEMPED		:= "9"
_Obj:cCPRODUTO		:= "SD180A11M"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "10"
_Obj:CCITEMPED		:= "10"
_Obj:cCPRODUTO		:= "SLPL47"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "11"
_Obj:CCITEMPED		:= "11"
_Obj:cCPRODUTO		:= "SDLS500"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "12"
_Obj:CCITEMPED		:= "12"
_Obj:cCPRODUTO		:= "SDDS350"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "13"
_Obj:CCITEMPED		:= "13"
_Obj:cCPRODUTO		:= "SDLS400"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "14"
_Obj:CCITEMPED		:= "14"
_Obj:cCPRODUTO		:= "SDLS300"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "15"
_Obj:CCITEMPED		:= "15"
_Obj:cCPRODUTO		:= "SDLS300"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "16"
_Obj:CCITEMPED		:= "16"
_Obj:cCPRODUTO		:= "SDR4125003"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "17"
_Obj:CCITEMPED		:= "17"
_Obj:cCPRODUTO		:= "SDLS250"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "18"
_Obj:CCITEMPED		:= "18"
_Obj:cCPRODUTO		:= "SDLS160"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "19"
_Obj:CCITEMPED		:= "19"
_Obj:cCPRODUTO		:= "SDLS225"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "20"
_Obj:CCITEMPED		:= "20"
_Obj:cCPRODUTO		:= "SDLS100"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "21"
_Obj:CCITEMPED		:= "21"
_Obj:cCPRODUTO		:= "SDLS50"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "22"
_Obj:CCITEMPED		:= "22"
_Obj:cCPRODUTO		:= "A4676"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "23"
_Obj:CCITEMPED		:= "23"
_Obj:cCPRODUTO		:= "S4506"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "24"
_Obj:CCITEMPED		:= "24"
_Obj:cCPRODUTO		:= "TA363E"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "25"
_Obj:CCITEMPED		:= "25"
_Obj:cCPRODUTO		:= "SDR480003"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "26"
_Obj:CCITEMPED		:= "26"
_Obj:cCPRODUTO		:= "N4546"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "27"
_Obj:CCITEMPED		:= "27"
_Obj:cCPRODUTO		:= "SDR44030"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "28"
_Obj:CCITEMPED		:= "28"
_Obj:cCPRODUTO		:= "SDR440300"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "29"
_Obj:CCITEMPED		:= "29"
_Obj:cCPRODUTO		:= "SN4276"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "30"
_Obj:CCITEMPED		:= "30"
_Obj:cCPRODUTO		:= "TA332E"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "31"
_Obj:CCITEMPED		:= "31"
_Obj:cCPRODUTO		:= "SCV24PO"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "32"
_Obj:CCITEMPED		:= "32"
_Obj:cCPRODUTO		:= "SEV322"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "33"
_Obj:CCITEMPED		:= "33"
_Obj:cCPRODUTO		:= "ST44210N"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "34"
_Obj:CCITEMPED		:= "34"
_Obj:cCPRODUTO		:= "SCBB2T16"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

_Obj:= WSPEDIDOPORTAL_ITENS():NEW()

_Obj:cCITEM			:= "35"
_Obj:CCITEMPED		:= "35"
_Obj:cCPRODUTO		:= "N4249"
_Obj:nNPRECO			:= 1
_Obj:nNQUANT			:= 1

aadd(_oWSTeste:oWSPEDIDO:oWSAPRODS:oWSITENS,_Obj)

If _oWSTeste:RETPEDIDO()   

alert('Pedido inserido com sucesso!"')   

Else   

alert('Erro de Execução : '+GetWSCError())   	

Endif   

Return 
