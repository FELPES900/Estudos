#Include "TOTVS.ch"

/*//////////////////////////////////////////////////////////////////
    Author Original  Lucas Fidélis
    @since 02/11/2021
    @version P12
    GitHub https://github.com/LucasFidelis/jwt-advpl
    Fonte usado de inspiração
////////////////////////////////////////////////////////////////////*/

#Define ALGORITHMS {{'SHA256', 5}, {'SHA512', 7}}
Class Jwt 

    Data cSecret
    Data cAlgorithm
    Data nAlgorithm

    Method New() Constructor
    Method Sign()
    Method Verify()
    Method ValidTok()
    Method ValidUsu()

EndClass
Method New(cSecret, cAlgorithm) Class Jwt

    Local nPos := 0
    
    Default cAlgorithm := 'SHA256'

    nPos := AScan(ALGORITHMS, { |x| x[1] == cAlgorithm})
    If nPos == 0
        UserException('Algorithm not found')
    EndIf

    ::cAlgorithm := ALGORITHMS[nPos][1]
    ::nAlgorithm := ALGORITHMS[nPos][2]
    ::cSecret := cSecret

Return Self

Method Sign(oPayload) class Jwt

    Local cToken, cHeader, cPayload, cSign
    Local oHeader

    oHeader := JsonObject():New()
    oHeader["typ"] := "JWT"
    oHeader["alg"] := ::cAlgorithm 

    cHeader := StrTran(Encode64(oHeader:toJson()), "=", "")
    cPayload := StrTran(Encode64(oPayload:toJson()), "=", "")
    cSign := StrTran(Encode64(HMAC(cHeader + '.' + cPayload, ::cSecret, ::nAlgorithm)), "=", "")

    cToken := cHeader+"."+cPayload+"."+cSign

Return cToken
Method Verify(cToken, oPay) class Jwt

    Local aParts := StrTokArr(cToken, '.')
    Local cHeader := aParts[1]
    Local cPayload := aParts[2]
    Local cTokenValid

    cSign := StrTran(Encode64(HMAC(cHeader + '.' + cPayload, ::cSecret, ::nAlgorithm)), "=", "")
    cTokenValid := cHeader+"."+cPayload+"."+cSign
    lValid := cToken == cTokenValid

Return lValid

Method ValidTok(cData) class Jwt

    Local nDate as Numeric
    Local nTime as Numeric
    Local nMin as Numeric
    Local dDate as Date
    Local cTime := "" as Character

    nDate := Val(cData) / 60 / 60 / 24
    nTime := nDate - Int(nDate)
    nDate := Int(nDate)
    nHour := nTime * 24
    nMin := (nHour - Int(nHour)) * 60
    nHour := Int(nHour) -4 //TIMEZONE, pode verificar esse cálculo de outra forma...
    nMin := Int(nMin)

    dDate := CtoD("01/01/1970") + nDate
    cTime := StrZero(nHour, 2) + ":" + StrZero(nMin, 2) + ":" + StrZero(nMin, 2)

Return (dDate,cTime)

// Ainda em andamento
Method ValidUsu() class Jwt

Return
