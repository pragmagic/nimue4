# Copyright 2016 Xored Software, Inc.

wclass(FSlotBase, header: "SlateCore.h", notypedef):
  proc initFSlotBase(): FSlotBase {.constructor.}

  proc initFSlotBase(inWidget: TSharedRef[SWidget]): FSlotBase {.constructor.}

  proc attachWidget(inWidget: TSharedRef[SWidget])

  proc getWidget(): TSharedRef[SWidget] {.noSideEffect.}
    ## Access the widget in the current slot.
    ## There will always be a widget in the slot; sometimes it is
    ## the SNullWidget instance.

  proc detachWidget(): TSharedPtr[SWidget]
    ## Remove the widget from its current slot.
    ## The removed widget is returned so that operations could be performed on it.
    ## If the null widget was being stored, an invalid shared ptr is returned instead.

wclass(TSlotBase[T] of FSlotBase, header: "SlateCore.h"):
  proc initTSlotBase(): TSlotBase[T] {.constructor.}
  proc initTSlotBase(inWidget: TSharedRef[SWidget]): TSlotBase[T]

  # TODO: uncomment after Nim issue is fixed: https://github.com/nim-lang/Nim/issues/4673
  # proc `[]`(inChildWidget: TSharedRef[SWidget]): var T
  # proc expose(outVarToInit: var ptr T): var T
