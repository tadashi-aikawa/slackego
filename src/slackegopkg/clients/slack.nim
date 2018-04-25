import os
import uri
import times
import httpclient
import json
import strformat
import dotenv

initDotEnv().load()

type
  Channel* = object
    is_channel*: bool
    name*: string
  Message* = object
    username*: string
    ts*: string  # Want to use DateTime
    text*: string
    permalink*: string
    channel*: Channel
  Result* = object
    total*: int
    matches*: seq[Message]
  SearchResult* = object
    ok*: bool
    query*: string
    messages*: Result
    # TODO: error: Option[str]

proc search*(word: string, after: DateTime): SearchResult = 
  let
    token = getEnv("SLACK_TOKEN")
    afterDate = after.format("yyyy-MM-dd")
    query = encodeUrl(fmt"{word} after:{afterDate}")
  let url = fmt"https://slack.com/api/search.messages?token={token}&query={query}&sort=timestamp&count=100"
  let content: string = newHttpClient().getContent(url)

  result = to(parseJson(content), SearchResult)

proc postMessage*(message: string, channel: string, username: string, iconEmoji: string): string =
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
