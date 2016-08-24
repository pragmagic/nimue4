# Copyright 2016 Xored Software, Inc.

type
  ELifetimeCondition {.size: sizeof(cint), importcpp: "ELifetimeCondition", header: "UObject/CoreNet.h".} = enum
    ## Secondary condition to check before considering the replication of a lifetime property.
    COND_None = 0, ## This property has no condition, and will send anytime it changes
    COND_InitialOnly = 1, ## This property will only attempt to send on the initial bunch
    COND_OwnerOnly = 2, ## This property will only send to the actor's owner
    COND_SkipOwner = 3, ## This property send to every connection EXCEPT the owner
    COND_SimulatedOnly = 4, ## This property will only send to simulated actors
    COND_AutonomousOnly = 5, ## This property will only send to autonomous actors
    COND_SimulatedOrPhysics = 6, ## This property will send to simulated OR bRepPhysics actors
    COND_InitialOrOwner = 7, ## This property will send on the initial packet, or to the actors owner
    COND_Custom = 8,
      ## This property has no particular condition, but wants the ability to toggle on/off via SetCustomIsActiveOverride
    COND_Max = 9,

  ELifetimeRepNotifyCondition  {.size: sizeof(cint),
                                 importcpp: "ELifetimeRepNotifyCondition",
                                 header: "UObject/CoreNet.h".} = enum
    REPNOTIFY_OnChanged = 0, ## Only call the property's RepNotify function if it changes from the local value
    REPNOTIFY_Always = 1, ## Always Call the property's RepNotify function when it is received from the server

wclass(IRepChangedPropertyTracker, header: "UObject/CoreNet.h"):
  method setCustomIsActiveOverride(repIndex: uint16, bIsActive: bool)

wclass(FLifetimeProperty, header: "UObject/CoreNet.h"):
  ##  This class is used to track a property that is marked to be replicated for the lifetime of the actor channel.
  ##  This doesn't mean the property will necessarily always be replicated, it just means:
  ##  "check this property for replication for the life of the actor, and I don't want to think about it anymore"
  ##  A secondary condition can also be used to skip replication based on the condition results
  var repIndex: uint16;
  var condition: ELifetimeCondition
  var repNotifyCondition: ELifetimeRepNotifyCondition

  proc makeFLifetimeProperty(): FLifetimeProperty {.constructor.}
  proc makeFLifetimeProperty(inRepIndex: int32): FLifetimeProperty {.constructor.}
  proc makeFLifetimeProperty(inRepIndex: int32,
                             inCondition: ELifetimeCondition,
                             inRepNotifyCondition: ELifetimeRepNotifyCondition = REPNOTIFY_OnChanged): FLifetimeProperty {.constructor.}

  proc `==`(other: var FLifetimeProperty) {.noSideEffect.}

wclass(IOnlinePlatformData, header: "OnlineSubsystemTypes.h"):
  proc `==`(other: var IOnlinePlatformData): bool {.noSideEffect.}
  proc `!=`(other: var IOnlinePlatformData): bool {.noSideEffect.}

  method getBytes(): ptr uint8 {.noSideEffect.}
    ## Get the raw byte representation of this opaque data
    ## This data is platform dependent and shouldn't be manipulated directly
    ##
    ## @return byte array of size GetSize()

  method getSize(): int32 {.noSideEffect.}
    ## Get the size of the opaque data
    ##
    ## @return size in bytes of the data representation

  method isValid(): bool {.noSideEffect.}
    ## Check the validity of the opaque data
    ##
    ## @return true if this is well formed data, false otherwise

  method toString(): FString {.noSideEffect.}
    ## Platform specific conversion to string representation of data
    ##
    ## @return data in string form

  method toDebugString(): FString {.noSideEffect.}
    ## Get a human readable representation of the opaque data
    ## Shouldn't be used for anything other than logging/debugging
    ##
    ## @return data in string form

wclass(FUniqueNetId of IOnlinePlatformData, header: "OnlineSubsystemTypes.h"):
  proc getHexEncodedString(): FString {.noSideEffect.}

wclass(FUniqueNetIdRepl, header: "GameFramework/OnlineReplStructs.h"):
  discard

# TODO: a lot more types