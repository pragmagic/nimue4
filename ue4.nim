# Copyright 2016 Xored Software, Inc.

when not defined(CPP):
  {.error: "Must be compiled with cpp switch".}

import macros, typetraits, lib/macroutils, lib/clibpp
import sequtils, strutils

# these exports are needed for some templates to work
export strutils.format, strutils.split, strutils.join, strutils.capitalize
export sequtils.map
export typetraits.name
export expandObjReference
export macroutils.toCppSubstitution

const withEditor* = defined(editor)

{.hints: off.}

# {.hint[XDeclaredButNotUsed]: off.} <- didn't work
include macros/uetypes
include macros/uedelegate

include ue4engine
# {.hint[XDeclaredButNotUsed]: on.}
{.hints: on.}
