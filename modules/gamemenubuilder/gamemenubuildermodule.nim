# Copyright 2016 Xored Software, Inc.

import ue4
import macros
import "../../lib/macroutils"

type
  SGameMenuPageWidget* {.header: "SGameMenuPageWidget.h", importcpp.} = object of SCompoundWidget

include gamemenubuilder
include gamemenupage
include gamemenupagewidget
