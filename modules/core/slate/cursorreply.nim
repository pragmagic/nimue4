# Copyright 2016 Xored Software, Inc.

wclass(FCursorReply of TReplyBase[FCursorReply], header: "SlateCore.h"):
  ## A reply to the OnQueryCursor event.

  proc getCursorWindow(): TSharedPtr[SWindow] {.noSideEffect.}
    ## @return The window to render the Cursor Widget in.

  proc getCursorWidget(): TSharedPtr[SWidget] {.noSideEffect.}
    ## @return The custom Cursor Widget to render if set and the event was handled.

  proc getCursorType(): EMouseCursor {.noSideEffect.}
    ## @return The requested MouseCursor if no custom widget is set and the event was handled.

  proc setCursorWidget(inCursorWindow: TSharedPtr[SWindow], inCursorWidget: TSharedPtr[SWidget])
    ## Set the Cursor Widget, used by slate application to set the cursor widget if the MapCursor returns a widget.

proc unhandledFCursorReply*(): FCursorReply {.importcpp: "FCursorReply::Unhandled()", header: "SlateCore.h", noSideEffect.}
  ## Makes a NULL response meaning no prefersce.
  ## i.e. If your widget returns this, its parent will get to decide what the cursor shoudl be.
  ## This is the default behavior for a widget.

proc initCursorReply*(inCursor: EMouseCursor): FCursorReply {.importcpp: "FCursorReply::Cursor(@)", header: "SlateCore.h", noSideEffect.}
  ## Respond with a specific cursor.
  ## This cursor will be used and no other widgets will be asked.
