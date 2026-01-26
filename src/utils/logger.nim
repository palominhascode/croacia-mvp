# ============================================================================
# LOGGER - Logging Centralizado
# ============================================================================

import times

type
  LogLevel* = enum
    DEBUG = 0
    INFO = 1
    WARN = 2
    ERROR = 3

proc log*(level: LogLevel, message: string) =
  let timestamp = now().format("yyyy-MM-dd HH:mm:ss")
  let levelStr = case level
    of DEBUG: "[DEBUG]"
    of INFO: "[INFO]"
    of WARN: "[WARN]"
    of ERROR: "[ERROR]"

  echo "[" & timestamp & "] " & levelStr & " " & message

proc logDebug*(msg: string) = log(DEBUG, msg)
proc logInfo*(msg: string) = log(INFO, msg)
proc logWarn*(msg: string) = log(WARN, msg)
proc logError*(msg: string) = log(ERROR, msg)
