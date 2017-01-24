# Copyright 2017 Xored Software, Inc.

wclass(UCommandlet of UObject, header: "Commandlets/Commandlet.h", notypedef):
  proc main(params: FString): int32
    ## Entry point for your commandlet
    ## @params - the string containing the parameters for the commandlet