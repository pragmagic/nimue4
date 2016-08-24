# Copyright 2016 Xored Software, Inc.

wclass(FReplyBase, header: "SlateCore.h"):
  proc isEventHandled(): bool {.noSideEffect.}
    ## @return true if this this reply is a result of the event being handled; false otherwise.

  proc getHandler(): TSharedPtr[SWidget] {.noSideEffect.}
    ## The widget that ultimately handled the event

# protected:

  proc initFReplyBase(inIsHandled: bool): FReplyBase {.constructor.}
    ## A reply can be handled or unhandled.
    ## Any widget handling events decides whether it has handled the event.

  var bIsHandled: bool
    ## Has a widget handled an event.

  var eventHandler: TSharedPtr[SWidget]
    ## Widget that handled the event that generated this reply.

wclass(TReplyBase[ReplyType] of FReplyBase, header: "SlateCore.h"):
  proc initTReplyBase(bIsHandled: bool): TReplyBase {.constructor.}

# protected:
  proc setHandler(inHandler: TSharedRef[SWidget]): var ReplyType
    ## Set the widget that handled the event; undefined if never handled.
    ## This method is to be used by SlateApplication only!

  proc me(): var ReplyType
    ## @return a reference to this reply

wclass(FNoReply of TReplyBase[FNoReply], header: "SlateCore.h"):
  ## A reply type for events that return a void reply. e.g. OnMouseLeave()
  proc initFNoReply(): FNoReply {.constructor.}

proc unhandledFNoReply*(): FNoReply {.noSideEffect, importcpp: "FNoReply::Unhandled()", header: "SlateCore.h".}
