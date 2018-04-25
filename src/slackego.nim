import os
import strformat
import options
import times
import strutils
import sequtils
import algorithm

import slackegopkg.clients.slack
import slackegopkg.config
import slackegopkg.args


const dateFormat = "yyyy-MM-dd HH:mm:ss"
proc log(message: string) = echo fmt"[{now().format(dateFormat)}] {message}"


proc exclude(m: Message, usernames: seq[string], channels: seq[string], minutes: int): bool =
  let behindSec: int64 = now().toTime.toUnix - m.ts.parseFloat.toInt
  result = anyIt([
    m.username in usernames,
    m.channel.name in channels,
    not m.channel.is_channel,
    behindSec > minutes*60
  ], it)


proc searchMessages(word: string, messageTemplate: string, minutes: int, exclude: Exclude): seq[string] =
  search(word, now() - initInterval(days=1, minutes=minutes))
    .messages.matches
    .sortedByIt(it.ts)
    .filterIt(not exclude(it, exclude.usernames, exclude.channels, minutes))
    .mapIt(messageTemplate.format(
      it.username,
      it.text.replace("@").replace("<!", "<"),  # No mentions
      it.channel.name,
      it.permalink,
      it.ts.parseFloat.int.fromUnix.inZone(local()).format(dateFormat),
      word
    ))


proc exec(args: Args, config: Config) = 
  for word in args.words:
    log fmt"Search {word} within {args.minutes} minutes..."
    let messages: seq[string] = searchMessages(word, config.messageTemplateLines.join("\n"), args.minutes, config.exclude)
    if messages.len > 0:
      log fmt"Found {messages.len} messages!"
      for m in messages:
        echo m
        if args.notify.isSome:
          echo postMessage(m, args.notify.get, config.user.name, config.user.iconEmoji)
    else:
      log "No messages"


proc main = 
  let
    args: Args = args.parse()
    config: Config = config.load(args.config)

  while true:
    exec(args, config)
    if args.forever:
      sleep args.minutes * 1000 * 60
    else:
      break;

main()
