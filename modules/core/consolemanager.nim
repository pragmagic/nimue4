# Copyright 2016 Xored Software, Inc.

wclass(TConsoleVariableData[T], header: "HAL/IConsoleManager.h", bycopy):
  ## T: int32, float
  proc initTConsoleVariableData(defaultValue: T): TConsoleVariableData[T] {.constructor.}

  proc getValueOnGameThread(): T
    ## faster than GetValueOnAnyThread()

  proc getValueOnRenderThread(): T
    ## faster than GetValueOnAnyThread()

  proc getValueOnAnyThread(bForceGameThread = false): T
    ## convenient, for better performance consider using GetValueOnGameThread() or GetValueOnRenderThread()

wclass(IConsoleManager, header: "HAL/IConsoleManager.h"):
  proc findTConsoleVariableDataInt(name: wstring): ptr TConsoleVariableData[int32]
    ## Find a typed console variable (faster access to the value, no virtual function call)
    ## @param Name must not be 0
    ## @return 0 if the object wasn't found

  proc findTConsoleVariableDataFloat(name: wstring): ptr TConsoleVariableData[float]
    ## Find a typed console variable (faster access to the value, no virtual function call)
    ## @param Name must not be 0
    ## @return 0 if the object wasn't found

proc getConsoleManager*(): var IConsoleManager {.
    importcpp: "IConsoleManager::Get()", header: "HAL/IConsoleManager.h".}
  ## Returns the singleton for the console manager
