# Copyright 2016 Xored Software, Inc.

wclass(SObjectWidget of SCompoundWidget, header: "UMG.h"):
  ## The SObjectWidget allows UMG to insert an SWidget into the hierarchy that manages the lifetime of the
  ## UMG UWidget that created it.  Once the SObjectWidget is destroyed it frees the reference it holds to
  ## The UWidget allowing it to be garbage collected.  It also forwards the slate events to the UUserWidget
  ## so that it can forward them to listeners.
  proc resetWidget()
  proc getWidgetObject(): ptr UUserWidget {.noSideEffect.}
  proc setPadding(inMargin: TAttribute[FMargin])
