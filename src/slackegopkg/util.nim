import terminal

proc error*(msg: string, code: int = 1) =
  styledWriteLine(stderr, fgRed, "Error: ", msg, resetStyle)
  quit(code)

