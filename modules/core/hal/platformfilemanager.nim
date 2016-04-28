# Copyright 2016 Xored Software, Inc.

class(FPlatformFileManager, header: "HAL/PlatformFilemanager.h"):
  proc makePlatformFileManager(): FPlatformFileManager {.constructor.}
    ## Constructor
  proc getPlatformFile(): var IPlatformFile
    ## Gets the currently used platform file.
    ## @return Reference to the currently used platform file.

  proc setPlatformFile(newTopmostPlatformFile: var IPlatformFile)
    ## Sets the current platform file.
    ## @param NewTopmostPlatformFile Platform file to be used.

  proc findPlatformFile(name: wstring): ptr IPlatformFile
    ## Finds a platform file in the chain of active platform files.
    ## @param Name of the platform file.
    ## @return Pointer to the active platform file or nullptr if the platform file was not found.

  proc getPlatformFile(name: wstring): ptr IPlatformFile
    ## Creates a new platform file instance.
    ## @param Name of the platform file to create.
    ## @return Platform file instance of the platform file type was found, nullptr otherwise.

proc getFPlatformFileManager*(): var FPlatformFileManager {.noSideEffect, header: "HAL/PlatformFilemanager.h", importcpp: "FPlatformFileManager::Get()".}
  ## Gets FPlatformFileManager Singleton.