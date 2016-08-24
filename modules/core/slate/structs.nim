# Copyright 2016 Xored Software, Inc.

wclass(FOptionalSize, header: "SlateCore.h", bycopy):
  ## Structure for optional floating point sizes.
  proc initFOptionalSize(): FOptionalSize {.constructor.}
    ## Creates an unspecified size.

  proc initFOptionalSize(specifiedSize: float32): FOptionalSize {.constructor.}
    ## Creates a size with the specified value.
    ##
    ## @param SpecifiedSize The size to set.

  proc isSet(): bool
    ## Checks whether the size is set.
    ##
    ## @return true if the size is set, false if it is unespecified.
    ## @see Get

  proc get(): float32
    ## Gets the value of the size.
    ##
    ## Before calling this method, check with IsSet() whether the size is actually specified.
    ## Unspecified sizes a value of -1.0f will be returned.
    ##
    ## @see IsSet

type
  ESizeRule* {.importcpp: "FSizeParam::ESizeRule", header: "SlateCore.h".} = enum
    SizeRule_Auto,
    SizeRule_Stretch

wclass(FSizeParam, header: "SlateCore.h", bycopy):
  ## Base structure for size parameters.
  ##
  ## Describes a way in which a parent widget allocates available space to its child widgets.
  ##
  ## When SizeRule is SizeRule_Auto, the widget's DesiredSize will be used as the space required.
  ## When SizeRule is SizeRule_Stretch, the available space will be distributed proportionately between
  ## peer Widgets depending on the Value property. Available space is space remaining after all the
  ## peers' SizeRule_Auto requirements have been satisfied.
  ##
  ## FSizeParam cannot be constructed directly - see FStretch, FAuto, and FAspectRatio

  var sizeRule: ESizeRule
    ## The sizing rule to use.

  var value: TAttribute[float32]
    ## The actual value this size parameter stores.
    ##
    ## This value can be driven by a delegate. It is only used for the Stretch mode.

  proc initFSizeParam(inTypeOfSize: ESizeRule, inValue: TAttribute[float32])
    ## Hidden constructor.
    ##
    ## Use FAspectRatio, FAuto, FStretch to instantiate size parameters.
    ##
    ## @see FAspectRatio, FAuto, FStretch

wclass(FStretch of FSizeParam, header: "SlateCore.h", bycopy):
  ## Structure for size parameters with SizeRule = SizeRule_Stretch.
  ##
  ## @see FAspectRatio
  ## @see FAuto
  proc initFStretch(stretchAmount: TAttribute[float32]): FStretch {.constructor.}
  proc initFStretch(): FStretch

wclass(FAuto of FSizeParam, header: "SlateCore.h", bycopy):
  ## Structure for size parameters with SizeRule = SizeRule_Auto.
  ##
  ## @see FAspectRatio, FStretch
  proc initFAuto(): FAuto {.constructor.}
