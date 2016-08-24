type
  FBatchedElementParameters* {.importcpp, header: "BatchedElements.h".} = object

  FCanvasItem* {.importcpp, header: "CanvasItem.h", inheritable, bycopy.} = object
    position* {.importcpp: "Position".}: FVector2D
    stereoDepth* {.importcpp: "StereoDepth".}: uint32
      ## Stereo projection depth in game units.  Default value 0 draws at canvas property StereoDepth.
    blendMode* {.importcpp: "BlendMode".}: ESimpleElementBlendMode
      ## Blend mode.
    bFreezeTime*: bool
    batchedElementParameters* {.importcpp: "BatchedElementParameters".}: ptr FBatchedElementParameters
      ## Used for batch rendering.
    color* {.importcpp: "Color".}: FLinearColor
      ## Color of the item.

type
  EElementType* {.importcpp, header: "CanvasTypes.h".} = enum
    ##  Enum that describes what type of element we are currently batching.
    ET_Line, ET_Triangle, ET_MAX
  ECanvasAllowModes* {.importcpp, header: "CanvasTypes.h".} = enum
    ##  Enum for canvas features that are allowed
    ##
    Allow_Flush = 1 shl 0,
      ##  flushing and rendering
    Allow_DeleteOnRender = 1 shl 1
      ##  delete the render batches when rendering

  FCanvasWordWrapper* {.importcpp, header: "CanvasTypes.h".} = object
  FCanvasBaseRenderItem* {.importcpp, header: "CanvasTypes.h".} = object

  FTextSizingParameters* {.importcpp, header: "CanvasTypes.h".} = object
    ## General purpose data structure for grouping all parameters needed when sizing or wrapping a string
    drawX* {.importcpp: "DrawX".}: cfloat
      ## a pixel value representing the horizontal screen location to begin rendering the string
    drawY* {.importcpp: "DrawY".}: cfloat
      ## a pixel value representing the vertical screen location to begin rendering the string
    drawXL* {.importcpp: "DrawXL".}: cfloat
      ## a pixel value representing the width of the area available for rendering the string
    drawYL* {.importcpp: "DrawYL".}: cfloat
      ## a pixel value representing the height of the area available for rendering the string
    scaling* {.importcpp: "Scaling".}: FVector2D
      ## A value between 0.0 and 1.0, which represents how much the width/height should be scaled, where 1.0 represents 100% scaling.
    drawFont* {.importcpp: "DrawFont".}: ptr UFont
      ## the font to use for sizing/wrapping the string
    spacingAdjust* {.importcpp: "SpacingAdjust".}: FVector2D
      ## Horizontal spacing adjustment between characters and vertical spacing adjustment between wrapped lines

  FWrappedStringElement* {.importcpp, header: "CanvasTypes.h".} = object
    ## Used by UUIString::WrapString to track information about each line that is generated as the result of wrapping.
    value* {.importcpp: "Value".}: FString
      ## the string associated with this line
    lineExtent* {.importcpp: "LineExtent".}: FVector2D
      ## the size (in pixels) that it will take to render this string

  FWrappedLineData = TArray[TPair[int32, int32]]

wclass(FTransformEntry, header: "CanvasTypes.h"):
  ## Entry for the transform stack which stores a matrix and its CRC for faster comparisons
  proc constructFTransformEntry(inMatrix: FMatrix): FTransformEntry {.constructor.}
  proc setMatrix(inMatrix: FMatrix)
  proc getMatrix(): FMatrix {.noSideEffect.}
  proc getMatrixCRC(): uint32 {.noSideEffect.}

wclass(FCanvasSortElement, header: "CanvasTypes.h"):
  ##  Contains all of the batched elements that need to be rendered at a certain depth sort key
  proc initFCanvasSortElement(inDepthSortKey: int32): FCanvasSortElement {.constructor.}

  proc `==`(other: FCanvasSortElement): bool {.noSideEffect.}
    ## Equality is based on sort key
    ##
    ## @param Other - instance to compare against
    ## @return true if equal
  var depthSortKey: int32
    ## sort key for this set of render batch elements
  var renderBatchArray: TArray[ptr FCanvasBaseRenderItem]
    ## list of batches that should be rendered at this sort key level

wclass(FCanvas, header: "CanvasTypes.h"):
  proc initFCanvas(inRenderTarget: ptr FRenderTarget, inHitProxyConsumer: ptr FHitProxyConsumer,
              inWorld: ptr UWorld, inFeatureLevel: ERHIFeatureLevel): FCanvas {.constructor.}
    ## Constructor.

  proc initFCanvas(inRenderTarget: ptr FRenderTarget, inHitProxyConsumer: ptr FHitProxyConsumer, inRealTime: cfloat,
                   inWorldTime: cfloat, inWorldDeltaTime: cfloat, inFeatureLevel: ERHIFeatureLevel): FCanvas {.constructor.}
    ## Constructor. For situations where a world is not available, but time information is

  proc blendToSimpleElementBlend(blendMode: EBlendMode): ESimpleElementBlendMode

  proc getBatchedElements(inElementType: EElementType; inBatchedElementParameters: ptr FBatchedElementParameters = nil;
                          texture: ptr FTexture = nil;
                          blendMode: ESimpleElementBlendMode = SE_BLEND_MAX;
                          glowInfo: FDepthFieldGlowInfo = initFDepthFieldGlowInfo()): ptr FBatchedElements
    ##  Returns a FBatchedElements pointer to be used for adding vertices and primitives for rendering.
    ##  Adds a new render item to the sort element entry based on the current sort key.
    ##
    ##  @param InElementType - Type of element we are going to draw.
    ##  @param InBatchedElementParameters - Parameters for this element
    ##  @param InTexture - New texture that will be set.
    ##  @param InBlendMode - New blendmode that will be set.
    ##  @param GlowInfo - info for optional glow effect when using depth field rendering
    ##  @return Returns a pointer to a FBatchedElements object.

  proc addTileRenderItem(x: cfloat; y: cfloat; sizeX: cfloat; sizeY: cfloat; u: cfloat;
                         v: cfloat; sizeU: cfloat; sizeV: cfloat;
                         materialRenderProxy: ptr FMaterialRenderProxy;
                         hitProxyId: FHitProxyId; bFreezeTime: bool; inColor: FColor)
    ## Generates a new FCanvasTileRendererItem for the current sortkey and adds it to the sortelement list of items to render

  proc addTriangleRenderItem(tri: FCanvasUVTri;
                             materialRenderProxy: ptr FMaterialRenderProxy;
                             hitProxyId: FHitProxyId; bFreezeTime: bool)
    ##  Generates a new FCanvasTriangleRendererItem for the current sortkey and adds it to the sortelement list of items to render

  proc flush_RenderThread(RHICmdList: var FRHICommandListImmediate;
                          bForce: bool = false)
    ##  Sends a message to the rendering thread to draw the batched elements.
    ##  @param RHICmdList - command list to use
    ##  @param bForce - force the flush even if Allow_Flush is not enabled

  proc flush_GameThread(bForce: bool = false)
    ##  Sends a message to the rendering thread to draw the batched elements.
    ##  @param bForce - force the flush even if Allow_Flush is not enabled

  proc pushRelativeTransform(transform: FMatrix)
    ##  Pushes a transform onto the canvas's transform stack, multiplying it with the current top of the stack.
    ##  @param Transform - The transform to push onto the stack.

  proc pushAbsoluteTransform(transform: FMatrix)
    ##  Pushes a transform onto the canvas's transform stack.
    ##  @param Transform - The transform to push onto the stack.

  proc popTransform()
    ##  Removes the top transform from the canvas's transform stack.

  proc setBaseTransform(transform: FMatrix)
    ##  Replace the base (ie. TransformStack(0)) transform for the canvas with the given matrix
    ##
    ##  @param Transform - The transform to use for the base

  proc calcBaseTransform2D(viewSizeX: uint32; viewSizeY: uint32): FMatrix
    ##  Generate a 2D projection for the canvas. Use this if you only want to transform in 2D on the XY plane
    ##
    ##  @param ViewSizeX - Viewport width
    ##  @param ViewSizeY - Viewport height
    ##  @return Matrix for canvas projection

  proc calcBaseTransform3D(viewSizeX: uint32; viewSizeY: uint32; fFOV: cfloat;
                           nearPlane: cfloat): FMatrix
    ##  Generate a 3D projection for the canvas. Use this if you want to transform in 3D
    ##
    ##  @param ViewSizeX - Viewport width
    ##  @param ViewSizeY - Viewport height
    ##  @param fFOV - Field of view for the projection
    ##  @param NearPlane - Distance to the near clip plane
    ##  @return Matrix for canvas projection

  proc calcViewMatrix(viewSizeX: uint32; viewSizeY: uint32; fFOV: cfloat): FMatrix
    ##  Generate a view matrix for the canvas. Used for CalcBaseTransform3D
    ##
    ##  @param ViewSizeX - Viewport width
    ##  @param ViewSizeY - Viewport height
    ##  @param fFOV - Field of view for the projection
    ##  @return Matrix for canvas view orientation

  proc calcProjectionMatrix(viewSizeX: uint32; viewSizeY: uint32; fFOV: cfloat;
                            nearPlane: cfloat): FMatrix
    ##  Generate a projection matrix for the canvas. Used for CalcBaseTransform3D
    ##
    ##  @param ViewSizeX - Viewport width
    ##  @param ViewSizeY - Viewport height
    ##  @param fFOV - Field of view for the projection
    ##  @param NearPlane - Distance to the near clip plane
    ##  @return Matrix for canvas projection

  proc getTransform(): FMatrix {.noSideEffect.}
    ##  Get the current top-most transform entry without the canvas projection
    ##  @return matrix from transform stack.

  proc getBottomTransform(): var FMatrix {.noSideEffect.}
    ##  Get the bottom-most element of the transform stack.
    ##  @return matrix from transform stack.

  proc getFullTransform(): var FMatrix {.noSideEffect.}
    ##  Get the current top-most transform entry
    ##  @return matrix from transform stack.

  proc copyTransformStack(copy: FCanvas)
    ##  Copy the conents of the TransformStack from an existing canvas
    ##
    ##  @param Copy	canvas to copy from

  proc setRenderTarget_GameThread(newRenderTarget: ptr FRenderTarget)
    ##  Sets the render target which will be used for subsequent canvas primitives.

  proc getRenderTarget(): ptr FRenderTarget {.noSideEffect.}
    ##  Get the current render target for the canvas

  proc setRenderTargetRect(viewRect: FIntRect)
    ##  Sets a rect that should be used to offset rendering into the viewport render target
    ##  If not set the canvas will render to the full target
    ##
    ##  @param ViewRect The rect to use

  proc setRenderTargetDirty(bDirty: bool)
    ##  Marks render target as dirty so that it will be resolved to texture

  proc setHitProxy(hitProxy: ptr HHitProxy)
    ##  Sets the hit proxy which will be used for subsequent canvas primitives.

  proc getHitProxyId(): FHitProxyId {.noSideEffect.}

# HitProxy Accessors.
  proc getHitProxyConsumer(): ptr FHitProxyConsumer {.noSideEffect.}

  proc isHitTesting(): bool {.noSideEffect.}

  proc pushDepthSortKey(inSortKey: int32)
    ##  Push sort key onto the stack. Rendering is done with the current sort key stack entry.
    ##
    ##  @param InSortKey - key value to push onto the stack

  proc popDepthSortKey(): int32
    ##  Pop sort key off of the stack.
    ##
    ##  @return top entry of the sort key stack

  proc topDepthSortKey(): int32
    ##  Return top sort key of the stack.
    ##
    ##  @return top entry of the sort key stack

  proc setAllowedModes(inAllowedModes: uint32)
    ##  Toggle allowed canvas modes
    ##
    ##  @param InAllowedModes	New modes to set

  proc getAllowedModes(): uint32 {.noSideEffect.}
    ##  Accessor for allowed canvas modes
    ##
    ##  @return current allowed modes

  proc hasBatchesToRender(): bool {.noSideEffect.}
    ##  Determine if the canvas has dirty batches that need to be rendered
    ##
    ##  @return true if the canvas has any element to render

  proc getFeatureLevel(): ERHIFeatureLevel {.noSideEffect.}
    ##  Access current feature level
    ##
    ##  @return feature level that this canvas is rendering at

  proc getShaderPlatform(): EShaderPlatform {.noSideEffect.}
    ##  Access current shader platform
    ##
    ##  @return shader platform that this canvas is rendering at

  proc getAllowSwitchVerticalAxis(): bool {.noSideEffect.}
    ##  Get/Set if this Canvas allows its batched elements to switch vertical axis (e.g., rendering to back buffer should never flip)
  proc setAllowSwitchVerticalAxis(bInAllowsToSwitchVerticalAxis: bool)
  var alphaModulate: cfloat

  proc getTransformStack(): var TArray[FTransformEntry] {.noSideEffect.}
    ## returns the transform stack
  proc getViewRect(): var FIntRect {.noSideEffect.}
  proc setScaledToRenderTarget(bScale: bool = true)
  proc isScaledToRenderTarget(): bool {.noSideEffect.}
  proc setStereoRendering(bStereo: bool = true)
  proc isStereoRendering(): bool {.noSideEffect.}


  proc setStereoDepth(inDepth: int32)
  proc getStereoDepth(): int32 {.noSideEffect.}
    ## Depth used for orthographic stereo projection. Uses World Units.

  var wordWrapper: TSharedPtr[FCanvasWordWrapper]

  proc getCurrentRealTime(): cfloat {.noSideEffect.}
    ##  Access current real time

  proc getCurrentWorldTime(): cfloat {.noSideEffect.}
    ##  Access current world time

  proc getCurrentDeltaWorldTime(): cfloat {.noSideEffect.}
    ##  Access current delta time

  proc drawItem(item: var FCanvasItem)
    ##  Draw a CanvasItem
    ##
    ##  @param Item			Item to draw

  proc drawItem(item: var FCanvasItem; inPosition: FVector2D)
    ##  Draw a CanvasItem at the given coordinates
    ##
    ##  @param Item			Item to draw
    ##  @param InPosition	Position to draw item

  proc drawItem(item: var FCanvasItem; x: cfloat; y: cfloat)
    ##  Draw a CanvasItem at the given coordinates
    ##
    ##  @param Item			Item to draw
    ##  @param X				X Position to draw item
    ##  @param Y				Y Position to draw item

  proc clear(color: FLinearColor)
    ##  Clear the canvas
    ##
    ##  @param	Color		Color to clear with.

  proc drawTile(x: cfloat; y: cfloat; sizeX: cfloat; sizeY: cfloat; u: cfloat; v: cfloat;
                sizeU: cfloat; sizeV: cfloat; color: FLinearColor;
                texture: ptr FTexture = nil; alphaBlend: bool = true)
    ##  Draw arbitrary aligned rectangle.
    ##
    ##  @param X - X position to draw tile at
    ##  @param Y - Y position to draw tile at
    ##  @param SizeX - Width of tile
    ##  @param SizeY - Height of tile
    ##  @param U - Horizontal position of the upper left corner of the portion of the texture to be shown(texels)
    ##  @param V - Vertical position of the upper left corner of the portion of the texture to be shown(texels)
    ##  @param SizeU - The width of the portion of the texture to be drawn. This value is in texels.
    ##  @param SizeV - The height of the portion of the texture to be drawn. This value is in texels.
    ##  @param Color - tint applied to tile
    ##  @param Texture - Texture to draw
    ##  @param AlphaBlend - true to alphablend

  proc drawShadowedString(startX: cfloat; startY: cfloat; text: wstring;
                          font: ptr UFont; color: FLinearColor;
                          shadowColor: FLinearColor = blackLinearColor): int32
    ##  Draw an string centered on given location.
    ##  This function is being deprecated. a FCanvasTextItem should be used instead.
    ##
    ##  @param StartX - X point
    ##  @param StartY - Y point
    ##  @param Text - Text to draw
    ##  @param Font - Font to use
    ##  @param Color - Color of the text
    ##  @param ShadowColor - Shadow color to draw underneath the text (ignored for distance field fonts)
    ##  @return total size in pixels of text drawn

  proc drawShadowedText(startX: cfloat; startY: cfloat; text: FText; font: ptr UFont;
                        color: FLinearColor; shadowColor: FLinearColor = blackLinearColor): int32
  proc wrapString(parameters: var FTextSizingParameters; inCurX: cfloat;
                  pText: wstring; out_Lines: var TArray[FWrappedStringElement];
                  outWrappedLineData: ptr TArray[TPair[int32, int32]] = nil)
  proc drawNGon(center: FVector2D; color: FColor; numSides: int32; radius: cfloat)


  var sortedElements: TArray[FCanvasSortElement]
    ## Batched canvas elements to be sorted for rendering. Sort order is back-to-front

  var sortedElementLookupMap: TMap[int32, int32]
    ## Map from sortkey to array index of SortedElements for faster lookup of existing entries

  var lastElementIndex: int32
    ## Store index of last Element off to avoid semi expensive Find()

  proc getSortElement(depthSortKey: int32): var FCanvasSortElement
    ##  Get the sort element for the given sort key. Allocates a new entry if one does not exist
    ##
    ##  @param DepthSortKey - the key used to find the sort element entry
    ##  @return sort element entry


proc initFCanvasItem*(inPosition: FVector2D): FCanvasItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
  ## Basic render item.
  ##
  ## @param	InPosition		Draw position

proc draw*(this: var FCanvasItem; inCanvas: ptr FCanvas) {.importcpp: "Draw", header: "CanvasItem.h".}
proc draw*(this: var FCanvasItem; inCanvas: ptr FCanvas; inPosition: FVector2D) {.importcpp: "Draw", header: "CanvasItem.h".}
proc draw*(this: var FCanvasItem; inCanvas: ptr FCanvas; x: cfloat; y: cfloat) {.importcpp: "Draw", header: "CanvasItem.h".}
proc setColor*(this: var FCanvasItem; inColor: FLinearColor) {.importcpp: "SetColor", header: "CanvasItem.h".}

type
  FCanvasTileItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    ## 'Tile' item can override size and UV
    size* {.importcpp: "Size".}: FVector2D
    z* {.importcpp: "Z".}: cfloat
      ## used to calculate depth.
    UV0*: FVector2D
      ## UV Coordinates 0 (Left/Top).
    UV1*: FVector2D
      ## UV Coordinates 0 (Right/Bottom).
    texture* {.importcpp: "Texture".}: ptr FTexture
      ## Texture to render.
    materialRenderProxy* {.importcpp: "MaterialRenderProxy".}: ptr FMaterialRenderProxy
      ## Material proxy for rendering.
    rotation* {.importcpp: "Rotation".}: FRotator
      ## Rotation.
    pivotPoint* {.importcpp: "PivotPoint".}: FVector2D
      ## Pivot point, as percentage of tile (0-1).

proc initFCanvasTileItem*(inPosition: FVector2D; inTexture: ptr FTexture;
                         inColor: FLinearColor): FCanvasTileItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
  ## Tile item using size from texture.
  ##
  ## @param	InPosition  Draw position
  ## @param	InTexture		The texture

proc initFCanvasTileItem*(inPosition: FVector2D; inTexture: ptr FTexture;
                         inSize: FVector2D; inColor: FLinearColor): FCanvasTileItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTileItem*(inPosition: FVector2D; inSize: FVector2D;
                         inColor: FLinearColor): FCanvasTileItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTileItem*(inPosition: FVector2D; inTexture: ptr FTexture;
                         inUV0: FVector2D; inUV1: FVector2D;
                         inColor: FLinearColor): FCanvasTileItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTileItem*(inPosition: FVector2D; inTexture: ptr FTexture;
                         inSize: FVector2D; inUV0: FVector2D; inUV1: FVector2D;
                         inColor: FLinearColor): FCanvasTileItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTileItem*(inPosition: FVector2D;
                         inMaterialRenderProxy: ptr FMaterialRenderProxy;
                         inSize: FVector2D): FCanvasTileItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTileItem*(inPosition: FVector2D;
                         inMaterialRenderProxy: ptr FMaterialRenderProxy;
                         inSize: FVector2D; inUV0: FVector2D; inUV1: FVector2D): FCanvasTileItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}

type
  FCanvasBorderItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    ## Resizable 3x3 border item.
    size* {.importcpp: "Size".}: FVector2D            ##  Scale of the border
    borderScale {.importcpp: "BorderScale".}: FVector2D     ##  Scale of the border
    backgroundScale {.importcpp: "BackgroundScale".}: FVector2D ## used to calculate depth.
    z {.importcpp: "Z".}: cfloat                  ## Border UV Coordinates 0 (Left/Top).
    borderUV0 {.importcpp: "BorderUV0".}: FVector2D       ## Border UV Coordinates 1 (Right/Bottom).
    borderUV1 {.importcpp: "BorderUV1".}: FVector2D       ## Corners texture.
    borderTexture {.importcpp: "BorderTexture".}: ptr FTexture ## Background tiling texture.
    backgroundTexture {.importcpp: "BackgroundTexture".}: ptr FTexture ## Border left tiling texture.
    borderLeftTexture {.importcpp: "BorderLeftTexture".}: ptr FTexture ## Border right tiling texture.
    borderRightTexture {.importcpp: "BorderRightTexture".}: ptr FTexture ## Border top tiling texture.
    borderTopTexture {.importcpp: "BorderTopTexture".}: ptr FTexture ## Border bottom tiling texture.
    borderBottomTexture {.importcpp: "BorderBottomTexture".}: ptr FTexture ## Rotation.
    rotation {.importcpp: "Rotation".}: FRotator         ## Pivot point.
    pivotPoint {.importcpp: "PivotPoint".}: FVector2D      ##  Frame corner size in percent of frame texture (should be < 0.5f)
    cornerSize {.importcpp: "CornerSize".}: FVector2D

proc initFCanvasBorderItem*(inPosition: FVector2D;
                            inBorderTexture: ptr FTexture;
                            inBackgroundTexture: ptr FTexture;
                            inBorderLeftTexture: ptr FTexture;
                            inBorderRightTexture: ptr FTexture;
                            inBorderTopTexture: ptr FTexture;
                            inBorderBottomTexture: ptr FTexture;
                            inSize: FVector2D; inColor: FLinearColor): FCanvasBorderItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
  ## 3x3 grid border with tiled frame and tiled interior.
  ##
  ## @param	InPosition		    Draw position
  ## @param	InBorderTexture		The texture to use for border
  ## @param	InBackgroundTexture	The texture to use for border background
  ## @param	InSize			    The size to render
  ## @param	InColor			    Tint of the border

type
  FCanvasTextItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    ## Text item with misc optional items such as shadow, centering etc.
    text* {.importcpp: "Text".}: FText
    font* {.importcpp: "Font".}: ptr UFont
      ## Font to draw text with.
    slateFontInfo* {.importcpp: "SlateFontInfo".}: TOptional[FSlateFontInfo]
      ##  Font info to draw the text with.
    horizSpacingAdjust* {.importcpp: "HorizSpacingAdjust".}: cfloat
      ## Horizontal spacing adjustment.
    forcedViewportHeight* {.importcpp: "ForcedViewportHeight".}: ptr cfloat
      ## Override viewport height.
    depth* {.importcpp: "Depth".}: cfloat
      ## Depth sort key.
    fontRenderInfo* {.importcpp: "FontRenderInfo".}: FFontRenderInfo
      ## Custom font render information.
    shadowColor* {.importcpp: "ShadowColor".}: FLinearColor
      ## The color of the shadow
    shadowOffset* {.importcpp: "ShadowOffset".}: FVector2D
      ## The offset of the shadow.
    drawnSize* {.importcpp: "DrawnSize".}: FVector2D
      ## The size of the drawn text after the draw call.
    bCentreX*: bool
      ## Centre the text in the viewport on horizontally.
    bCentreY*: bool
      ## Centre the text in the viewport on vertically.
    bOutlined*: bool
      ## Draw an outline on the text.
    outlineColor* {.importcpp: "OutlineColor".}: FLinearColor
      ## The color of the outline.
    bDontCorrectStereoscopic*: bool
      ## Disables correction of font render issue when using stereoscopic display.
    scale* {.importcpp: "Scale".}: FVector2D
      ## The scale of the text
    tileItem* {.importcpp: "TileItem".}: FCanvasTileItem
      ## Background tile used to fixup 3d text issues.
    batchedElements* {.importcpp: "BatchedElements".}: ptr FBatchedElements
      ## Get the type of font cache the UFont is using

proc initFCanvasTextItem*(inPosition: FVector2D; inText: FText;
                             inFont: ptr UFont; inColor: FLinearColor): FCanvasTextItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
  ## Text item
  ##
  ## @param	InPosition		Draw position
  ## @param	InText			String to draw
  ## @param	InFont			Font to draw with
proc initFCanvasTextItem*(inPosition: FVector2D; inText: FText;
                             inFontInfo: FSlateFontInfo; inColor: FLinearColor): FCanvasTextItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc enableShadow*(this: var FCanvasTextItem; inColor: FLinearColor;
                   inOffset: FVector2D = initFVector2D(1.0, 1.0)) {.importcpp: "EnableShadow", header: "CanvasItem.h".}
proc disableShadow*(this: var FCanvasTextItem) {.importcpp: "DisableShadow", header: "CanvasItem.h".}
proc getFontCacheType*(this: FCanvasTextItem): EFontCacheType {.noSideEffect, importcpp: "GetFontCacheType", header: "CanvasItem.h".}

type
  FCanvasLineItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    ## Line item.
    origin* {.importcpp: "Origin".}: FVector
    endPos* {.importcpp: "EndPos".}: FVector ## The end position of the line.
    lineThickness* {.importcpp: "LineThickness".}: cfloat ## The thickness of the line.

proc initFCanvasLineItem*(): FCanvasLineItem {.constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasLineItem*(inPosition: FVector2D; inEndPos: FVector2D): FCanvasLineItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasLineItem*(inPosition: FVector; inEndPos: FVector): FCanvasLineItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}

proc draw*(this: var FCanvasLineItem; inCanvas: ptr FCanvas; inStartPos: FVector2D;
         inEndPos: FVector2D) {.importcpp: "Draw", header: "CanvasItem.h".}
proc draw*(this: var FCanvasLineItem; inCanvas: ptr FCanvas; inPosition: FVector) {.importcpp: "Draw", header: "CanvasItem.h".}
proc draw*(this: var FCanvasLineItem; inCanvas: ptr FCanvas; x: cfloat; y: cfloat; z: cfloat) {.importcpp: "Draw", header: "CanvasItem.h".}
proc setEndPos*(this: var FCanvasLineItem; inEndPos: FVector2D) {.importcpp: "SetEndPos", header: "CanvasItem.h".}

type
  FCanvasBoxItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    size* {.importcpp: "Size".}: FVector2D            ## The thickness of the line.
    lineThickness* {.importcpp: "LineThickness".}: cfloat

proc initFCanvasBoxItem*(inPosition: FVector2D; inSize: FVector2D): FCanvasBoxItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}

type
  FCanvasTriangleItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem
    ## Triangle item (no texture)
    ##
    ## @param	InPointA		Point A of triangle
    ## @param	InPointB		Point B of triangle
    ## @param	InPointC		Point C of triangle
    texture* {.importcpp: "Texture".}: ptr FTexture
    materialRenderProxy* {.importcpp: "MaterialRenderProxy".}: ptr FMaterialRenderProxy
      ## Material proxy for rendering.
    triangleList* {.importcpp: "TriangleList".}: TArray[FCanvasUVTri]
      ## List of triangles.

proc initFCanvasTriangleItem*(inPointA: FVector2D; inPointB: FVector2D;
                                 inPointC: FVector2D; inTexture: ptr FTexture): FCanvasTriangleItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTriangleItem*(inPointA: FVector2D; inPointB: FVector2D;
                                 inPointC: FVector2D; inTexCoordPointA: FVector2D;
                                 inTexCoordPointB: FVector2D;
                                 inTexCoordPointC: FVector2D;
                                 inTexture: ptr FTexture): FCanvasTriangleItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTriangleItem*(inSingleTri: FCanvasUVTri;
                                 inTexture: ptr FTexture): FCanvasTriangleItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc initFCanvasTriangleItem*(inTriangleList: TArray[FCanvasUVTri];
                                 inTexture: ptr FTexture): FCanvasTriangleItem {.
    constructor, importcpp: "'0(@)", header: "CanvasItem.h".}

proc destroyFCanvasTriangleItem*(this: var FCanvasTriangleItem) {.
  importcpp: "DestroyFCanvasTriangleItem", header: "CanvasItem.h".}
proc setPoints*(this: var FCanvasTriangleItem; inPointA: FVector2D;
                inPointB: FVector2D; inPointC: FVector2D) {.importcpp: "SetPoints", header: "CanvasItem.h".}

type
  FCanvasNGonItem* {.importcpp, header: "CanvasItem.h".} = object of FCanvasItem

proc initFCanvasNGonItem*(inPosition: FVector2D; inRadius: FVector2D;
                          inNumSides: int32; inTexture: ptr FTexture;
                          inColor: FLinearColor): FCanvasNGonItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
  ## NGon item Several texture tris with a common central point with a fixed radius.
  ##
  ## @param	InPosition	List of triangles
  ## @param	InRadius	Size of the object
  ## @param	InNumSides	How many tris/sides the object has
  ## @param	InTexture	Texture to render
  ## @param	InColor		Color to tint the texture with

proc initFCanvasNGonItem*(inPosition: FVector2D; inRadius: FVector2D;
                             inNumSides: int32; inColor: FLinearColor): FCanvasNGonItem {.
  constructor, importcpp: "'0(@)", header: "CanvasItem.h".}
proc destroyFCanvasNGonItem*(this: var FCanvasNGonItem) {.importcpp: "DestroyFCanvasNGonItem", header: "CanvasItem.h".}
proc setupPosition*(this: var FCanvasNGonItem; inPosition: FVector2D;
                    inRadius: FVector2D) {.importcpp: "SetupPosition", header: "CanvasItem.h".}

type
  FDisplayDebugManager* {.header: "Engine/Canvas.h", importcpp.} = object
  FCanvasIcon* {.header: "Engine/Canvas.h", importcpp.} = object
    ## Holds texture information with UV coordinates as well.
    texture {.importcpp: "Texture".}: ptr UTexture
      ## Source texture
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CanvasIcon)
    u {.importcpp: "U".}: cfloat
      ## UV coords
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CanvasIcon)
    v {.importcpp: "V".}: cfloat
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CanvasIcon)
    UL: cfloat
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CanvasIcon)
    VL: cfloat
      ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=CanvasIcon)

  ELastCharacterIndexFormat* {.importcpp, header: "Engine/Canvas.h".} = enum
    lastWholeCharacterBeforeOffset, ## The last whole character before the horizontal offset
    characterAtOffset, ## The character directly at the offset
    unused ## Not used

wclass(UCanvas of UObject, header: "Engine/Canvas.h", notypedef):
# Modifiable properties.

  var orgX: cfloat
    ## Origin for drawing in X.
  var orgY: cfloat
    ## Origin for drawing in Y.
  var clipX: cfloat
    ## Bottom right clipping region.
  var clipY: cfloat
    ## Bottom right clipping region.
  var drawColor: FColor
    ## Color for drawing.
  var bCenterX: bool
    ## Whether to center the text horizontally (about CurX)
  var bCenterY: bool
    ## Whether to center the text vertically (about CurY)
  var bNoSmooth: bool
    ## Don't bilinear filter.
  var sizeX: int32
    ## Zero-based actual dimensions X.
  var sizeY: int32
    ## Zero-based actual dimensions Y.

# Internal.
  var colorModulate: FPlane
  var defaultTexture: ptr UTexture2D
    ##Default texture to use
  var gradientTexture0: ptr UTexture2D
    ##Default texture to use
  var reporterGraph: ptr UReporterGraph
  var unsafeSizeX: int32
    ## Canvas size before safe frame adjustment
  var unsafeSizeY: int32
    ## Canvas size before safe frame adjustment

# cached data for safe zone calculation.  Some platforms have very expensive functions
# to grab display metrics
  var safeZonePadX: int32
  var safeZonePadY: int32
  var cachedDisplayWidth: int32
  var cachedDisplayHeight: int32
  var displayDebugManager: FDisplayDebugManager

  var canvas: ptr FCanvas
  var sceneView: ptr FSceneView
  var viewProjectionMatrix: FMatrix
  var hmdOrientation: FQuat

# UCanvas interface.

  proc init(inSizeX: int32; inSizeY: int32; inSceneView: ptr FSceneView)
    ## Initializes the canvas.

  proc setView(inView: ptr FSceneView)
    ## Changes the view for the canvas.

  proc update()
    ## Updates the canvas.

  proc applySafeZoneTransform()
    ## Applies the current Platform's safe zone to the current Canvas position. Automatically called by Update.

  proc popSafeZoneTransform()

  proc updateSafeZoneData()
    ## Updates cached SafeZone data from the device.  Call when main device is resized.

  ## static void UpdateAllCanvasSafeZoneData();
    ## Function to go through all constructed canvas items and update their safe zone data.


  proc setStereoDepth(depth: uint32)
    ## Changes depth in game units . Used to render stereo projection

  proc drawTile(tex: ptr UTexture; x: cfloat; y: cfloat; XL: cfloat; YL: cfloat; u: cfloat;
                v: cfloat; UL: cfloat; VL: cfloat;
                blendMode: EBlendMode = BLEND_Translucent)
    ## Draw arbitrary aligned rectangle.
    ##
    ## @param Tex Texture to draw.
    ## @param X Position to draw X.
    ## @param Y Position to draw Y.
    ## @param XL Width of tile.
    ## @param YL Height of tile.
    ## @param U Horizontal position of the upper left corner of the portion of the texture to be shown(texels).
    ## @param V Vertical position of the upper left corner of the portion of the texture to be shown(texels).
    ## @param UL The width of the portion of the texture to be drawn(texels).
    ## @param VL The height of the portion of the texture to be drawn(texels).
    ## @param ClipTile true to clip tile.
    ## @param BlendMode Blending mode of texture.

  proc wrappedStrLenf(font: ptr UFont; scaleX: cfloat; scaleY: cfloat; XL: var int32;
                      YL: var int32; fmt: wstring) {.varargs.}
    ## Calculate the length of a string.
    ##
    ## @param Font The font used.
    ## @param ScaleX Scale in X axis.
    ## @param ScaleY Scale in Y axis.
    ## @param XL out Horizontal length of string.
    ## @param YL out Vertical length of string.
    ## @param Text String to calculate for.
    ##
    ## static void ClippedStrLen(const UFont* Font, float ScaleX, float ScaleY, int32& XL, int32& YL, const TCHAR* Text);
    ##
    ## Calculate the size of a string built from a font, word wrapped to a specified region.

  proc wrappedPrint(draw: bool; x: cfloat; y: cfloat; out_XL: var int32; out_YL: var int32;
                    font: ptr UFont; scaleX: cfloat; scaleY: cfloat; bCenterTextX: bool;
                    bCenterTextY: bool; text: wstring; renderInfo: FFontRenderInfo): int32
    ## Compute size and optionally print text with word wrap.

  proc drawText(inFont: ptr UFont; inText: FString; x: cfloat; y: cfloat;
                XScale: cfloat = 1.0; YScale: cfloat = 1.0;
                renderInfo: FFontRenderInfo = FFontRenderInfo()): cfloat
    ## Draws a string of text to the screen.
    ##
    ## @param InFont The font to draw with.
    ## @param InText The string to be drawn.
    ## @param X Position to draw X.
    ## @param Y Position to draw Y.
    ## @param XScale Optional. The horizontal scaling to apply to the text.
    ## @param YScale Optional. The vertical scaling to apply to the text.
    ## @param RenderInfo Optional. The FontRenderInfo to use when drawing the text.
    ## @return The Y extent of the rendered text.
  proc drawText(inFont: ptr UFont; inText: FText; x: cfloat; y: cfloat;
                XScale: cfloat = 1.0; YScale: cfloat = 1.0;
                renderInfo: FFontRenderInfo = FFontRenderInfo()): cfloat

  ##
  ## Measures a string, optionally stopped after the specified horizontal offset in pixels is reached.
  ##
  ## @param	Parameters	Used for various purposes
  ## 							DrawXL:		[out] will be set to the width of the string
  ## 							DrawYL:		[out] will be set to the height of the string
  ## 							DrawFont:	[in] specifies the font to use for retrieving the size of the characters in the string
  ## 							Scale:		[in] specifies the amount of scaling to apply to the string
  ## @param	pText		the string to calculate the size for
  ## @param	TextLength	the number of code units in pText
  ## @param	StopAfterHorizontalOffset  Offset horizontally into the string to stop measuring characters after, in pixels (or INDEX_NONE)
  ## @param	CharIndexFormat  Behavior to use for StopAfterHorizontalOffset
  ## @param	OutCharacterIndex  The index of the last character processed (used with StopAfterHorizontalOffset)
  ##
  ##
  ## static void MeasureStringInternal( FTextSizingParameters& Parameters, const TCHAR* const pText, const int32 TextLength, const int32 StopAfterHorizontalOffset, const ELastCharacterIndexFormat CharIndexFormat, int32& OutLastCharacterIndex );
  ##
  ## Calculates the size of the specified string.
  ##
  ## @param	Parameters	Used for various purposes
  ## 							DrawXL:		[out] will be set to the width of the string
  ## 							DrawYL:		[out] will be set to the height of the string
  ## 							DrawFont:	[in] specifies the font to use for retrieving the size of the characters in the string
  ## 							Scale:		[in] specifies the amount of scaling to apply to the string
  ## @param	pText		the string to calculate the size for
  ##
  ## static void CanvasStringSize( FTextSizingParameters& Parameters, const TCHAR* pText );
  ##
  ## Parses a single string into an array of strings that will fit inside the specified bounding region.
  ##
  ## @param	Parameters		Used for various purposes:
  ## 							DrawX:		[in] specifies the pixel location of the start of the horizontal bounding region that should be used for wrapping.
  ## 							DrawY:		[in] specifies the Y origin of the bounding region.  This should normally be set to 0, as this will be
  ## 										     used as the base value for DrawYL.
  ## 										[out] Will be set to the Y position (+YL) of the last line, i.e. the total height of all wrapped lines relative to the start of the bounding region
  ## 							DrawXL:		[in] specifies the pixel location of the end of the horizontal bounding region that should be used for wrapping
  ## 							DrawYL:		[in] specifies the height of the bounding region, in pixels.  A input value of 0 indicates that
  ## 										     the bounding region height should not be considered.  Once the total height of lines reaches this
  ## 										     value, the function returns and no further processing occurs.
  ## 							DrawFont:	[in] specifies the font to use for retrieving the size of the characters in the string
  ## 							Scale:		[in] specifies the amount of scaling to apply to the string
  ## @param	CurX			specifies the pixel location to begin the wrapping; usually equal to the X pos of the bounding region, unless wrapping is initiated
  ## 								in the middle of the bounding region (i.e. indentation)
  ## @param	pText			the text that should be wrapped
  ## @param	out_Lines		[out] will contain an array of strings which fit inside the bounding region specified.  Does
  ## 							not clear the array first.
  ## @param	OutWrappedLineData An optional array to fill with the indices from the source string marking the begin and end points of the wrapped lines
  ##
  ## static void WrapString( FCanvasWordWrapper& Wrapper, FTextSizingParameters& Parameters, const float InCurX, const TCHAR* const pText, TArray<FWrappedStringElement>& out_Lines, FCanvasWordWrapper::FWrappedLineData* const OutWrappedLineData = nullptr);

  proc wrapString(parameters: var FTextSizingParameters; inCurX: cfloat;
                  pText: wstring; out_Lines: var TArray[FWrappedStringElement];
                  outWrappedLineData: ptr FWrappedLineData = nil)

  proc project(location: FVector): FVector {.noSideEffect.}
    ## Transforms a 3D world-space vector into 2D screen coordinates.
    ##
    ## @param Location The vector to transform.
    ## @return The transformed vector.

  proc deproject(screenPos: FVector2D; worldOrigin: var FVector;
                worldDirection: var FVector) {.noSideEffect.}
    ## Transforms 2D screen coordinates into a 3D world-space origin and direction.
    ##
    ## @param ScreenPos Screen coordinates in pixels.
    ## @param WorldOrigin (out) World-space origin vector.
    ## @param WorldDirection (out) World-space direction vector.

  proc strLen(inFont: ptr UFont; inText: FString; XL: var cfloat; YL: var cfloat)
    ## Calculate the length of a string, taking text wrapping into account.
    ##
    ## @param InFont The Font use.
    ## @param Text The string to calculate for.
    ## @param XL out Horizontal length of string.
    ## @param YL out Vertical length of string.

  proc textSize(inFont: ptr UFont; inText: FString; XL: var cfloat; YL: var cfloat;
                scaleX: cfloat = 1.0; scaleY: cfloat = 1.0)
    ## Calculates the horizontal and vertical size of a given string. This is used for clipped text as it does not take wrapping into account.
    ##
    ## @param Font The font to use.
    ## @param Text String to calculate for.
    ## @param XL out Horizontal length of string.
    ## @param YL out Vertical length of string.
    ## @param ScaleX Scale that the string is expected to draw at horizontally.
    ## @param ScaleY Scale that the string is expected to draw at vertically.

  proc setLinearDrawColor(inColor: FLinearColor; opacityOverride: cfloat = - 1.0)
    ## Set DrawColor with a FLinearColor and optional opacity override

  proc setDrawColor(r: uint8; g: uint8; b: uint8; a: uint8 = 255)
    ## Set draw color. (R,G,B,A)

  proc setDrawColor(c: FColor)
    ## Set draw color. (FColor)

  proc createFontRenderInfo(bClipText: bool = false; bEnableShadow: bool = false;
                            glowColor: FLinearColor = FLinearColor();
                            glowOuterRadius: FVector2D = FVector2D();
                            glowInnerRadius: FVector2D = FVector2D()): FFontRenderInfo
    ## constructor for FontRenderInfo

  proc reset(bKeepOrigin: bool = false)
    ## reset canvas parameters, optionally do not change the origin

  proc setClip(x, y: cfloat)
    ## Sets the position of the lower-left corner of the clipping region of the Canvas

  proc getCenter(outX: var cfloat; outY: var cfloat) {.noSideEffect.}
    ## Return X,Y for center of the draw region.

  ## Fake CanvasIcon constructor.
  ## static FCanvasIcon MakeIcon(class UTexture* Texture, float U = 0.f, float V = 0.f, float UL = 0.f, float VL = 0.f);

  proc drawScaledIcon(icon: FCanvasIcon; x: cfloat; y: cfloat; scale: FVector)
    ## Draw a scaled CanvasIcon at the desired canvas position.

  proc drawIcon(icon: FCanvasIcon; x: cfloat; y: cfloat; scale: cfloat = 0.0)
    ## Draw a CanvasIcon at the desired canvas position.

  proc drawDebugGraph(title: FString; valueX: cfloat; valueY: cfloat; UL_X: cfloat;
                      UL_Y: cfloat; w: cfloat; h: cfloat; rangeX: FVector2D;
                      rangeY: FVector2D)
    ## Draws a graph comparing 2 variables.  Useful for visual debugging and tweaking.
    ##
    ## @param Title		Label to draw on the graph, or "" for none
    ## @param ValueX	X-axis value of the point to plot
    ## @param ValueY	Y-axis value of the point to plot
    ## @param UL_X		X screen coord of the upper-left corner of the graph
    ## @param UL_Y		Y screen coord of the upper-left corner of the graph
    ## @param W			Width of the graph, in pixels
    ## @param H			Height of the graph, in pixels
    ## @param RangeX	Range of values expressed by the X axis of the graph
    ## @param RangeY	Range of values expressed by the Y axis of the graph

  proc drawItem(item: var FCanvasItem)
    ## Draw a CanvasItem
    ##
    ## @param Item			Item to draw

  proc drawItem(item: var FCanvasItem; inPosition: FVector2D)
    ## Draw a CanvasItem at the given coordinates
    ##
    ## @param Item			Item to draw
    ## @param InPostion		Position to draw item

  proc drawItem(item: var FCanvasItem; x: cfloat; y: cfloat)
    ## Draw a CanvasItem at the given coordinates
    ##
    ## @param Item			Item to draw
    ## @param X				X Position to draw item
    ## @param Y				Y Position to draw item

  proc getReporterGraph(): TWeakObjectPtr[UReporterGraph]
    ## Creates if necessary and returns ReporterGraph instance for 2d graph canvas drawing

  proc k2_DrawLine(screenPositionA: FVector2D = zeroVector2D;
                   screenPositionB: FVector2D = zeroVector2D; thickness: cfloat = 1.0;
                   renderColor: FLinearColor = whiteLinearColor)
    ## Draws a line on the Canvas.
    ##
    ## @param ScreenPositionA		Starting position of the line in screen space.
    ## @param ScreenPositionB		Ending position of the line in screen space.
    ## @param Thickness				How many pixels thick this line should be.
    ## @param RenderColor			Color to render the line.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Line"))

  proc k2_DrawTexture(renderTexture: ptr UTexture; screenPosition: FVector2D;
                      screenSize: FVector2D; coordinatePosition: FVector2D;
                      coordinateSize: FVector2D = unitVector2D;
                      renderColor: FLinearColor = whiteLinearColor;
                      blendMode: EBlendMode = BLEND_Translucent;
                      rotation: cfloat = 0.0;
                      pivotPoint: FVector2D = initFVector2D(0.5, 0.5))
    ## Draws a texture on the Canvas.
    ##
    ## @param RenderTexture				Texture to use when rendering. If no texture is set then this will use the default white texture.
    ## @param ScreenPosition			Screen space position to render the texture.
    ## @param ScreenSize				Screen space size to render the texture.
    ## @param CoordinatePosition		Normalized UV starting coordinate to use when rendering the texture.
    ## @param CoordinateSize			Normalized UV size coordinate to use when rendering the texture.
    ## @param RenderColor				Color to use when rendering the texture.
    ## @param BlendMode					Blending mode to use when rendering the texture.
    ## @param Rotation					Rotation, in degrees, to render the texture.
    ## @param PivotPoint				Normalized pivot point to use when rotating the texture.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Texture"))

  proc k2_DrawMaterial(renderMaterial: ptr UMaterialInterface;
                       screenPosition: FVector2D; screenSize: FVector2D;
                       coordinatePosition: FVector2D;
                       coordinateSize: FVector2D = unitVector2D; rotation: cfloat = 0.0;
                       pivotPoint: FVector2D = initFVector2D(0.5, 0.5))
    ## Draws a material on the Canvas.
    ##
    ## @param RenderMaterial			Material to use when rendering. Remember that only the emissive channel is able to be rendered as no lighting is performed when rendering to the Canvas.
    ## @param ScreenPosition			Screen space position to render the texture.
    ## @param ScreenSize				Screen space size to render the texture.
    ## @param CoordinatePosition		Normalized UV starting coordinate to use when rendering the texture.
    ## @param CoordinateSize			Normalized UV size coordinate to use when rendering the texture.
    ## @param Rotation					Rotation, in degrees, to render the texture.
    ## @param PivotPoint				Normalized pivot point to use when rotating the texture.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Material"))

  proc k2_DrawText(renderFont: ptr UFont; renderText: FString;
                   screenPosition: FVector2D; renderColor: FLinearColor = whiteLinearColor;
                   kerning: cfloat = 0.0; shadowColor: FLinearColor = blackLinearColor;
                   shadowOffset: FVector2D = unitVector2D; bCentreX: bool = false;
                   bCentreY: bool = false; bOutlined: bool = false;
                   outlineColor: FLinearColor = blackLinearColor)
    ## Draws text on the Canvas.
    ##
    ## @param RenderFont				Font to use when rendering the text. If this is null, then a default engine font is used.
    ## @param RenderText				Text to render on the Canvas.
    ## @param ScreenPosition			Screen space position to render the text.
    ## @param RenderColor				Color to render the text.
    ## @param Kerning					Horizontal spacing adjustment to modify the spacing between each letter.
    ## @param ShadowColor				Color to render the shadow of the text.
    ## @param ShadowOffset				Pixel offset relative to the screen space position to render the shadow of the text.
    ## @param bCentreX					If true, then interpret the screen space position X coordinate as the center of the rendered text.
    ## @param bCentreY					If true, then interpret the screen space position Y coordinate as the center of the rendered text.
    ## @param bOutlined					If true, then the text should be rendered with an outline.
    ## @param OutlineColor				Color to render the outline for the text.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Text"))

  proc k2_DrawBorder(borderTexture: ptr UTexture; backgroundTexture: ptr UTexture;
                     leftBorderTexture: ptr UTexture;
                     rightBorderTexture: ptr UTexture; topBorderTexture: ptr UTexture;
                     bottomBorderTexture: ptr UTexture; screenPosition: FVector2D;
                     screenSize: FVector2D; coordinatePosition: FVector2D;
                     coordinateSize: FVector2D = unitVector2D;
                     renderColor: FLinearColor = whiteLinearColor;
                     borderScale: FVector2D = initFVector2D(0.1, 0.1);
                     backgroundScale: FVector2D = initFVector2D(0.1, 0.1);
                     rotation: cfloat = 0.0;
                     pivotPoint: FVector2D = initFVector2D(0.5, 0.5);
                     cornerSize: FVector2D = zeroVector2D)
    ## Draws a 3x3 grid border with tiled frame and tiled interior on the Canvas.
    ##
    ## @param BorderTexture				Texture to use for border.
    ## @param BackgroundTexture			Texture to use for border background.
    ## @param LeftBorderTexture			Texture to use for the tiling left border.
    ## @param RightBorderTexture		Texture to use for the tiling right border.
    ## @param TopBorderTexture			Texture to use for the tiling top border.
    ## @param BottomBorderTexture		Texture to use for the tiling bottom border.
    ## @param ScreenPosition			Screen space position to render the texture.
    ## @param ScreenSize				Screen space size to render the texture.
    ## @param CoordinatePosition		Normalized UV starting coordinate to use when rendering the border texture.
    ## @param CoordinateSize			Normalized UV size coordinate to use when rendering the border texture.
    ## @param RenderColor				Color to tint the border.
    ## @param BorderScale				Scale of the border.
    ## @param BackgroundScale			Scale of the background.
    ## @param Rotation					Rotation, in degrees, to render the texture.
    ## @param PivotPoint				Normalized pivot point to use when rotating the texture.
    ## @param CornerSize				Frame corner size in percent of frame texture (should be < 0.5f).
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Border"))

  proc k2_DrawBox(screenPosition: FVector2D; screenSize: FVector2D;
                  thickness: cfloat = 1.0)
    ## Draws an unfilled box on the Canvas.
    ##
    ## @param ScreenPosition			Screen space position to render the text.
    ## @param ScreenSize				Screen space size to render the texture.
    ## @param Thickness					How many pixels thick the box lines should be.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Box"))

  proc k2_DrawTriangle(renderTexture: ptr UTexture; triangles: TArray[FCanvasUVTri])
    ## Draws a set of triangles on the Canvas.
    ##
    ## @param RenderTexture				Texture to use when rendering the triangles. If no texture is set, then the default white texture is used.
    ## @param Triangles					Triangles to render.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Triangles"))

  proc k2_DrawMaterialTriangle(renderMaterial: ptr UMaterialInterface;
                               triangles: TArray[FCanvasUVTri])
    ## Draws a set of triangles on the Canvas.
    ##
    ## @param RenderMaterial			Material to use when rendering. Remember that only the emissive channel is able to be rendered as no lighting is performed when rendering to the Canvas.
    ## @param Triangles					Triangles to render.
    ##
    ## UFUNCTION(BlueprintCallable, Category = Canvas, meta = (DisplayName = "Draw Material Triangles"))

  proc k2_DrawPolygon(renderTexture: ptr UTexture; screenPosition: FVector2D;
                      radius: FVector2D = unitVector2D; numberOfSides: int32 = 3;
                      renderColor: FLinearColor = whiteLinearColor)
    ## Draws a polygon on the Canvas.
    ##
    ## @param RenderTexture				Texture to use when rendering the triangles. If no texture is set, then the default white texture is used.
    ## @param ScreenPosition			Screen space position to render the text.
    ## @param Radius					How large in pixels this polygon should be.
    ## @param NumberOfSides				How many sides this polygon should have. This should be above or equal to three.
    ## @param RenderColor				Color to tint the polygon.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Draw Polygon"))

  proc k2_Project(worldLocation: FVector): FVector
    ## Performs a projection of a world space coordinates using the projection matrix set up for the Canvas.
    ##
    ## @param WorldLocation				World space location to project onto the Canvas rendering plane.
    ## @return							Returns a vector where X, Y defines a screen space position representing the world space location.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Project"))

  proc k2_Deproject(screenPosition: FVector2D; worldOrigin: var FVector;
                    worldDirection: var FVector)
    ## Performs a deprojection of a screen space coordinate using the projection matrix set up for the Canvas.
    ##
    ## @param ScreenPosition			Screen space position to deproject to the World.
    ## @param WorldOrigin				Vector which is the world position of the screen space position.
    ## @param WorldDirection			Vector which can be used in a trace to determine what is "behind" the screen space position. Useful for object picking.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Deproject"))

  proc k2_StrLen(renderFont: ptr UFont; renderText: FString): FVector2D
    ## Returns the wrapped text size in screen space coordinates.
    ##
    ## @param RenderFont				Font to use when determining the size of the text. If this is null, then a default engine font is used.
    ## @param RenderText				Text to determine the size of.
    ## @return							Returns the screen space size of the text.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Wrapped Text Size"))

  proc k2_TextSize(renderFont: ptr UFont; renderText: FString;
                   scale: FVector2D = unitVector2D): FVector2D
    ## Returns the clipped text size in screen space coordinates.
    ##
    ## @param RenderFont				Font to use when determining the size of the text. If this is null, then a default engine font is used.
    ## @param RenderText				Text to determine the size of.
    ## @param Scale						Scale of the font to use when determining the size of the text.
    ## @return							Returns the screen space size of the text.
    ##
    ## UFUNCTION(BlueprintCallable, Category=Canvas, meta=(DisplayName="Clipped Text Size"))

