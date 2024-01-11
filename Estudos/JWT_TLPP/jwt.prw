#Include "TOTVS.ch"

#Define ALGORITHMS {{'SHA256', 5}, {'SHA512', 7}}
Class Jwt 

  Data cSecret
  Data cAlgorithm
  Data nAlgorithm

  Method New() Constructor
  Method Sign()
  Method Verify()
  Method ValidTok()

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

// Ainda em andamento
Method ValidTok(cData) class Jwt


Return
