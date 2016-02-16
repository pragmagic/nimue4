class(FClientReceiveData, header: "GameFramework/LocalMessage.h"):
  var localPC: ptr APlayerController
  var messageType: FName
  var MessageIndex: int32
  var messageString: FString
  var relatedPlayerState_1: ptr APlayerState
  var relatedPlayerState_2: ptr APlayerState
  var optionalObject: ptr UObject

class(ULocalMessage of UObject, header: "GameFramework/LocalMessage.h"):
  method clientReceive(clientData: var FClientReceiveData) {.noSideEffect.}
    ## send message to client
