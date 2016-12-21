# Copyright 2016 Xored Software, Inc.

proc getCommandLine*(): wstring {.
    importcpp: "FCommandLine::Get()", header: "Misc/CommandLine.h".}
  ## Returns an edited version of the executable's command line with the game name and certain other parameters removed. 