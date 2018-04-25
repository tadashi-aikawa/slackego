const doc = """
Usage:
  slackego <word>... --minutes=<minutes>
                     [--notify=<notify>]
                     [--config=<config>]
                     [--forever]

Options:
  <word>...               Search words
  --minutes=<minutes>     Since minutes before
  --notify=<notify>       Channel or direct message to notify (without #)
  --config=<config>       Config file [default: config.json]
  --forever               Run forever
"""
import options
import docopt
import strutils


type Args* = object
  words*: seq[string]
  minutes*: int
  notify*: Option[string]
  config*: string
  forever*: bool

proc parse*(): Args = 
  let args = docopt(doc, version = "0.1.0")
  result = Args(
    words: @(args["<word>"]),
    minutes: ($args["--minutes"]).parseInt,
    notify: if args["--notify"].to_bool: some($args["--notify"]) else: none(string),
    config: $args["--config"],
    forever: args["--forever"],
  )
