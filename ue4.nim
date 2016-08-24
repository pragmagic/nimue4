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
import macros/uetypes
import macros/uedelegate
import modules/core/coremodule

export uetypes
export uedelegate
export coremodule
export clibpp
# {.hint[XDeclaredButNotUsed]: on.}
{.hints: on.}
