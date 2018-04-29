import os
import ospaths
import system
import uri
import times
import httpclient
import json
import strutils
import strformat
import dotenv
import ../util

if fileExists(".env"):
  initDotEnv().load()


type Channel* = object
  is_channel*: bool
  name*: string

type Message* = object
  username*: string
  text*: string
  permalink*: string
  channel*: Channel
  ts: string

proc unixTime*(m: Message): int {.inline.} = m.ts.parseFloat.int
proc dateTime*(m: Message): DateTime {.inline.} = m.unixTime.fromUnix.inZone(local())


type Result* = object
  total*: int
  matches*: seq[Message]

type SearchResult* = object
  ok*: bool
  query*: string
  messages*: Result
  # TODO: error: Option[str]



proc assertToken(): void = 
  if not existsEnv("SLACK_TOKEN"):
    error("Please set a environmental variable `SLACK_TOKEN` or create .env.")


proc search*(word: string, after: DateTime): SearchResult = 
  assertToken()

  let
    token = getEnv("SLACK_TOKEN")
    afterDate = after.format("yyyy-MM-dd")
    query = encodeUrl(fmt"{word} after:{afterDate}")

  let url = fmt"https://slack.com/api/search.messages?token={token}&query={query}&sort=timestamp&count=100"
  let content: string = newHttpClient().getContent(url)

  let json: JsonNode = parseJson(content)
  if not json["ok"].getBool:
    error json["error"].getStr

  result = to(json, SearchResult)


proc postMessage*(message: string, channel: string, username: string, iconEmoji: string): string =
  assertToken()

  let payloadJson: JsonNode = %*
    {
      "text": message,
      "channel": channel,
      "username": username,
      "icon_emoji": iconEmoji,
      "link_names": 0
    }

  let
    client = newHttpClient()
    url = fmt"https://slack.com/api/chat.postMessage"
    token = getEnv("SLACK_TOKEN")
    response: Response = client.request(url, httpMethod = HttpPost, body = $payloadJson, headers=newHttpHeaders({
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": fmt"Bearer {token}"
    }))

  result = response.body
