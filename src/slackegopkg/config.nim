import os
import json
import streams
import strformat

import util

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
  if not fileExists(path):
    error(fmt"{path} is not existed. Please create it.")
  result = to(parseFile(path), Config)
