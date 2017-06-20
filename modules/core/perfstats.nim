template declarePerfStatGroup*(name: string) =
  {.emit: "DECLARE_STATS_GROUP(TEXT(\"$#\"), STATGROUP_$#, STATCAT_Advanced);".format(name, name).}

template declarePerfCycleStat*(group: string, name: string) =
  {.emit: "DECLARE_CYCLE_STAT(TEXT(\"$#\"), STAT_$#, STATGROUP_$#);".format(name, name, group).}

template scopeCycleCounter*(name: string) =
  {.emit: "SCOPE_CYCLE_COUNTER(STAT_$#);".format(name).}
