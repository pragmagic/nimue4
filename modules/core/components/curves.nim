# Copyright 2017 Xored Software, Inc.

wclass(UCurveVector of UCurveBase, header: "Curves/CurveVector.h", notypedef):

  proc getVectorValue(inTime: float32): FVector
    ## Evaluate this float curve at the specified time

wclass(UCurveLinearColor of UCurveBase, header: "Curves/CurveLinearColor.h", notypedef):

  proc getLinearColorValue(inTime: float32): FLinearColor
    ## Evaluate this color curve at the specified time

wclass(UCurveFloat of UCurveBase, header: "Curves/CurveFloat.h", notypedef):

  proc getFloatValue(inTime: float32): float32
    ## Evaluate this float curve at the specified time
