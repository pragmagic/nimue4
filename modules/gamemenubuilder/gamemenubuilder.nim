# Copyright 2016 Xored Software, Inc.

wclass(IGameMenuBuilderModule, header: "GameMenuBuilder.h"):
  ## The public interface to game menu builder module

proc getIGameMenuBuilderModule*(): ptr IGameMenuBuilderModule {.
  importcpp: "(& IGameMenuBuilderModule::Get())", header: "GameMenuBuilder.h".}
  ## Singleton-like access to this module's interface.  This is just for convenience!
  ## Beware of calling this during the shutdown phase, though.  Your module might have been unloaded already.
  ##
  ## @return Returns singleton instance, loading the module on demand if needed
