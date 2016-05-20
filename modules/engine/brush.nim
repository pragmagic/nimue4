# Copyright 2016 Xored Software, Inc.

type
  ECsgOper {.size: sizeof(cint), header: "Engine/Brush.h", importcpp.} = enum
    CSG_Active, ## Active brush. (deprecated, do not use.)
    CSG_Add, ## Add to world. (deprecated, do not use.)
    CSG_Subtract, ## Subtract from world. (deprecated, do not use.)
    CSG_Intersect, ## Form from intersection with world.
    CSG_Deintersect, ## Form from negative intersection with world.
    CSG_None,
    CSG_MAX

  EBrushType {.size: sizeof(cint), header: "Engine/Brush.h", importcpp.} = enum
    Brush_Default, ## Default/builder brush.
    Brush_Add, ## Add to world.
    Brush_Subtract, ## Subtract from world.
    Brush_MAX

  FBuilderPoly {.header: "Engine/BrushBuilder.h", importcpp.} = object
    vertexIndices: TArray[int32]
    direction: int32
    itemName: FName
    polyFlags: int32

  UBrushBuilder {.header: "Engine/BrushBuilder.h", importcpp.} = object of UObject
    ##  Base class of UnrealEd brush builders.
    ##
    ##
    ##  Tips for writing brush builders:
    ##
    ##  - Always validate the user-specified and call BadParameters function
    ##    if anything is wrong, instead of actually building geometry.
    ##    If you build an invalid brush due to bad user parameters, you'll
    ##    cause an extraordinary amount of pain for the poor user.
    ##
    ##  - When generating polygons with more than 3 vertices, BE SURE all the
    ##    polygon's vertices are coplanar!  Out-of-plane polygons will cause
    ##    geometry to be corrupted.

    bitmapFilename: FString
    toolTip: FString
      ## localized FString that will be displayed as the name of this brush builder in the editor
    notifyBadParams: bool
      ## If false, disabled the bad param notifications

    vertices: TArray[FVector]
    polys: TArray[FBuilderPoly]
    layer: FName
    mergeCoplanars: bool

  FGeomSelection{.header: "Engine/Brush.h", importcpp.} = object
    ## Selection information for geometry mode
    kind {.importcpp: "Type".}: int32 ## EGeometrySelectionType_
    index: int32 ## Index into the geometry data structures
    selectionIndex: int32 ## The selection index of this item

  ABrush {.header: "Engine/Brush.h", importcpp.} = object of AActor
    brushType: EBrushType
      ## Type of brush
      ## UPROPERTY(EditAnywhere, Category=Brush)

    brushColor: FColor
      ## Information.
      ## UPROPERTY()

    polyFlags: int32
      ## UPROPERTY()

    bColored: bool
      ## UPROPERTY()

    bSolidWhenSelected: bool
      ## UPROPERTY()

    bPlaceableFromClassBrowser: bool
      ## If true, this brush class can be placed using the class browser like other simple class types
      ## UPROPERTY()

    bNotForClientOrServer: bool
      ## If true, this brush is a builder or otherwise does not need to be loaded into the game
      ## UPROPERTY()

    brush: ptr UModel
      ## UPROPERTY(export)

  #if WITH_EDITORONLY_DATA:
    brushBuilder: ptr UBrushBuilder
      ## UPROPERTY(VisibleAnywhere, Instanced, Category=BrushBuilder)
  #endif

    bInManipulation: bool
      ## Flag set when we are in a manipulation (scaling, translation, brush builder param change etc.)
      ## UPROPERTY()

    savedSelections: TArray[FGeomSelection]
      ## Stores selection information from geometry mode.  This is the only information that we can't
      ## regenerate by looking at the source brushes following an undo operation.
      ##
      ## UPROPERTY()

proc makeFGeomSelection(): FGeomSelection {.header: "Engine/Brush.h", importcpp: "'0(@)", constructor.}
proc makeFBuilderPoly(): FBuilderPoly {.header: "Engine/BrushBuilder.h", importcpp: "'0(@)", constructor.}

declareBuiltinDelegate(FOnBrushRegistered, dkMulticast, "Engine/Brush.h", brush: ptr ABrush)

wclass(ABrush of AActor, header: "Engine/Brush.h", notypedef):
#if WITH_EDITOR:
  proc getOnBrushRegisteredDelegate(): var FOnBrushRegistered
    ## Delegate used for notifications when PostRegisterAllComponents is called for a Brush
    ## DECLARE_MULTICAST_DELEGATE_OneParam(FOnBrushRegistered, ABrush*);
    ## Function to get the 'brush registered' delegate
#endif

  proc initPosRotScale()
  proc copyPosRotScaleFrom(other: ptr ABrush)
  proc setSuppressBSPRegeneration(bSuppress: bool)

  proc needsRebuild(outLevels: ptr TArray[TWeakObjectPtr[ULevel]] = nil): bool
    ## Called to see if any of the levels need rebuilding
    ##
    ## @param	OutLevels if specified, provides a copy of the levels array
    ## @return	true if the csg needs to be rebuilt on the next editor tick.

  proc onRebuildDone()
    ## Called upon finishing the csg rebuild to clear the rebuild bool.

  proc setNeedRebuild(inLevel: ptr ULevel)
    ## Called to make not of the level that needs rebuilding
    ##
    ## @param	InLevel The level that needs rebuilding

  method isStaticBrush(): bool {.noSideEffect.}
    ## @return true if this is a static brush

  method isVolumeBrush(): bool {.noSideEffect.}
    ## @return false

  method isBrushShape(): bool {.noSideEffect.}
    ## @return false

  method getWireColor(): FColor {.noSideEffect.}
    ## Figures out the best color to use for this brushes wireframe drawing.

  proc isNotForClientOrServer(): bool {.noSideEffect.}
    ## Return if true if this brush is not used for gameplay (i.e. builder brush)
    ##
    ## @return	true if brush is not for client or server

  proc setNotForClientOrServer()
    ## Indicate that this brush need not be loaded on client or servers

  proc clearNotForClientOrServer()
    ## Indicate that brush need should be loaded on client or servers

#if WITH_EDITORONLY_DATA:
  proc getBrushBuilder(): ptr UBrushBuilder {.noSideEffect.}
    ## @return the brush builder that created the current brush shape
#endif

  proc getBrushComponent(): ptr UBrushComponent {.noSideEffect.}
    ## Returns BrushComponent subobject

wclass(UBrushBuilder of UObject, header: "Engine/BrushBuilder.h", notypedef):
  proc beginBrush(inMergeCoplanars: bool; inLayer: FName)
  proc endBrush(inWorld: ptr UWorld; inBrush: ptr ABrush): bool
  proc getVertexCount(): int32 {.noSideEffect.}
  proc getVertex(i: int32): FVector {.noSideEffect.}
  proc getPolyCount(): int32 {.noSideEffect.}
  proc badParameters(msg: FText): bool
  proc vertexv(v: FVector): int32
  proc vertex3f(x: cfloat; y: cfloat; z: cfloat): int32
  proc poly3i(direction: int32; i, j, k: int32; itemName: FName = NAME_None;
              bIsTwoSidedNonSolid: bool = false)
  proc poly4i (direction: int32; i, j, k, L: int32;
               itemName: FName = NAME_None; bIsTwoSidedNonSolid: bool = false)
  proc polyBegin(direction: int32; itemName: FName = NAME_None)
  proc polyi(i: int32)
  proc polyEnd()

  proc build(inWorld: ptr UWorld; inBrush: ptr ABrush = nil): bool
    ## Builds the brush shape for the specified ABrush or the builder brush if Brush is nullptr.
    ## @param InWorld The world to operate in
    ## @param InBrush The brush to change shape, or nullptr to specify the builder brush
    ## @return true if the brush shape was updated.