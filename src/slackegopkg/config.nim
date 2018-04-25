import json
import streams


type
  Exclude* = object
    usernames*: seq[string]
    channels*: seq[string]
  User* = object
    name*: string
    iconEmoji*: string
  Config* = object
    exclude*: Exclude
    messageTemplateLines*: seq[string]
    user*: User

proc load*(path: string): Config =
  result = to(parseFile(path), Config)
