# Copyright 2016 Xored Software, Inc.

type
  FUpdateTextureRegion2D* {.importcpp, header: "RHI.h", bycopy.} = object
    ## specifies an update region for a texture
    destX* {.importcpp: "DestX".}: uint32
      ## X offset in texture
    destY* {.importcpp: "DestY".}: uint32
      ## Y offset in texture

    srcX* {.importcpp: "SrcX".}: int32
      ## X offset in source image data
    srcY* {.importcpp: "SrcY".}: int32
      ## Y offset in source image data

    width* {.importcpp: "Width".}: uint32
      ## width of region to copy
    height* {.importcpp: "Height".}: uint32
      ## height of region to copy
  EPixelFormat* {.importcpp, header: "PixelFormat.h".} = enum
    pfUnknown
    pfA32B32G32R32F
    pfB8G8R8A8
    pfG8
    pfG16
    pfDXT1
    pfDXT3
    pfDXT5
    pfUYVY
    pfFloatRGB
    pfFloatRGBA
    pfDepthStencil
    pfShadowDepth
    pfR32_FLOAT
    pfG16R16
    pfG16R16F
    pfG16R16F_FILTER
    pfG32R32F
    pfA2B10G10R10
    pfA16B16G16R16
    pfD24
    pfR16F
    pfR16F_FILTER
    pfBC5
    pfV8U8
    pfA1
    pfFloatR11G11B10
    pfA8
    pfR32_UINT
    pfR32_SINT
    pfPVRTC2
    pfPVRTC4
    pfR16_UINT
    pfR16_SINT
    pfR16G16B16A16_UINT
    pfR16G16B16A16_SINT
    pfR5G6B5_UNORM
    pfR8G8B8A8
    pfA8R8G8B8
      ## Only used for legacy loading; do NOT use!
    pfBC4
    pfR8G8
    pfATC_RGB
    pfATC_RGBA_E
    pfATC_RGBA_I
    pfX24_G8
      ## Used for creating SRVs to alias a DepthStencil buffer to read Stencil. Don't use for creating textures.
    pfETC1
    pfETC2_RGB
    pfETC2_RGBA
    pfR32G32B32A32_UINT
    pfR16G16_UINT
    pfASTC_4x4
    pfASTC_6x6
    pfASTC_8x8
    pfASTC_10x10
    pfASTC_12x12
    pfBC6H
    pfBC7
    pfMAX

proc initFUpdateTextureRegion2D*(destX, destY: int32; srcX, srcY: int32; width, height: uint32): FUpdateTextureRegion2D {.
  importcpp: "FUpdateTextureRegion2D(uint32(#), uint32(#), @)", constructor, nodecl.}

wclass(UTexture of UObject, header: "Engine/Texture.h", notypedef):
  method updateResource()
  method getSurfaceWidth(): cfloat {.noSideEffect.}
  method getSurfaceHeight(): cfloat {.noSideEffect.}
  method createResource(): ptr FTextureResource
  method getMaterialType(): EMaterialValueType
  method getAverageBrightness(bIgnoreTrueBlack, bUseGrayscale: bool): cfloat

wclass(UTexture2D of UTexture, header: "Engine/Texture2D.h", notypedef):
  proc updateTextureRegions(mipIndex: int32, numRegions: uint32, regions: ptr FUpdateTextureRegion2D, srcPitch: uint32, srcBpp: uint32, srcData: ptr uint8)


proc updateTextureRegions*(texture: ptr UTexture2D, numRegions: uint32, regions: ptr FUpdateTextureRegion2D, srcPitch, srcBpp: uint32, srcData: ptr uint8, regionsMayChange: bool = false) =
  if not regionsMayChange:
    texture.updateTextureRegions(numRegions, regions, srcPitch, srcBpp, srcData)
  else:
    {.emit: """
    const uint32 regionsSize = `numRegions` * sizeof(FUpdateTextureRegion2D);
    FUpdateTextureRegion2D* SrcData = (FUpdateTextureRegion2D*) FMemory::Malloc(regionsSize);
		FMemory::Memcpy(SrcData, `regions`, regionsSize);

		auto DataCleanup = [](uint8* InSrcData, const FUpdateTextureRegion2D* Regions)
		{
			FMemory::Free((void *) Regions);
		};
		`texture`->UpdateTextureRegions(0, `numRegions`, SrcData, `srcPitch`, `srcBpp`, `srcData`, DataCleanup);
""".}


proc createTransientTexture*(sizeX, sizeY: int32; format: EPixelFormat = pfB8G8R8A8): ptr UTexture2D {.
  importcpp: "UTexture2D::CreateTransient(@)", nodecl.}
