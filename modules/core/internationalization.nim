# Copyright 2017 Xored Software, Inc.

proc getCurrentCultureName*(): FString {.importcpp: "FInternationalization::Get().GetCurrentCulture()->GetName()", header: "Internationalization/Internationalization.h".}
