# Copyright 2016 Xored Software, Inc.

type FTouchInputControl* {.header: "GameFramework/TouchInterface.h", importcpp.} = object
  image1*: UTexture2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="For sticks, this is the Thumb"))

  image2*: UTexture2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="For sticks, this is the Background"))

  center*: FVector2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="The center point of the control (if <= 1.0, it's relative to screen, > 1.0 is absolute)"))

  visualSize*: FVector2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="The size of the control (if <= 1.0, it's relative to screen, > 1.0 is absolute)"))

  thumbSize*: FVector2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="For sticks, the size of the thumb (if <= 1.0, it's relative to screen, > 1.0 is absolute)"))

  interactionSize*: FVector2D
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="The interactive size of the control (if <= 1.0, it's relative to screen, > 1.0 is absolute)"))

  inputScale*: FVector2D
    ## UPROPERTY(EditAnywhere, Category = "Control", meta = (ToolTip = "The scale for control input"))

  mainInputKey*: FKey
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="The main input to send from this control (for sticks, this is the horizontal axis)"))

  altInputKey*: FKey
    ## UPROPERTY(EditAnywhere, Category="Control", meta=(ToolTip="The alternate input to send from this control (for sticks, this is the vertical axis)"))

proc makeFTouchInputControl(): FTouchInputControl {.header: "GameFramework/TouchInterface.h", constructor, importcpp.}

type UTouchInterface* {.header: "GameFramework/TouchInterface.h", importcpp.} = object of UObject
  ## Defines an interface by which touch input can be controlled using any number of buttons and virtual joysticks

  controls*: TArray[FTouchInputControl]
    ## UPROPERTY(EditAnywhere, Category="TouchInterface")

  ActiveOpacity*: cfloat
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="Opacity (0.0 - 1.0) of all controls while any control is active"))

  InactiveOpacity*: cfloat
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="Opacity (0.0 - 1.0) of all controls while no controls are active"))

  TimeUntilDeactive*: cfloat
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="How long after user interaction will all controls fade out to Inactive Opacity"))

  TimeUntilReset*: cfloat
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="How long after going inactive will controls reset/recenter themselves (0.0 will disable this feature)"))

  ActivationDelay*: cfloat
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="How long after joystick enabled for touch (0.0 will disable this feature)"))

  bPreventRecenter*: bool
    ## UPROPERTY(EditAnywhere, Category="TouchInterface", meta=(ToolTip="Whether to prevent joystick re-center"))

  StartupDelay*: cfloat
    ## UPROPERTY(EditAnywhere, Category = "TouchInterface", meta = (ToolTip = "Delay at startup before virtual joystick is drawn"))
