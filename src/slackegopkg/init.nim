import json
import strformat

proc param(question: string, default: string): string =
  echo fmt"{question} [{default}]"
  let r = readLine(stdin)
  result = if r != "": r else: default


proc param(question: string): string =
  while true:
    echo question
    let r = readLine(stdin)
    if r != "":
      return r


proc init*() = 
  let userName: string = param "Your name: Your slack username? (ex: tadashi-aikawa)"
  let channel: string = param("Excluded channel: Channels you want to excludes? (without #)", "times_yourname")
  let posterName: string = param("Slack user name: Slack username who post messages?", "Slackego")
  let posterEmoji: string = param("Slack user emoji: Slack user emoji who post message?", ":slackego:")

  let messageTemplateLines: seq[string] = @[
    "--------------------------------------",
    "| :house: <${permalink}|${channel}>",
    "| :bust_in_silhouette: ${username}",
    "| :timer_clock: ${datetime}",
    "| :mag: ${word}",
    "--------------------------------------",
    "${text}"
  ]

  let j = %*
    {
      "exclude": {
        "usernames": @[userName],
        "channels": @[channel]
      },
      "user": {
        "name": posterName,
        "iconEmoji": posterEmoji
      },
      "messageTemplateLines": messageTemplateLines
    }

  let f: File = open("config.json", FileMode.fmWrite)
  defer: close(f)
  f.write(j.pretty())
  echo "config.json is created."

