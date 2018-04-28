const doc = """
Usage:
  slackego run <word>... --minutes=<minutes>
                         [--notify=<channel>]
                         [--config=<config>]
                         [--forever]
  slackego init

Options:
  <word>...               Search words
  --minutes=<minutes>     Since minutes before
  --notify=<channel>      Channel or direct message to notify (without #)
  --config=<config>       Config file [default: config.json]
  --forever               Run forever
"""
import options
import docopt
import strutils


const VERSION = "0.1.1"


type
  Command* = enum
    Run, Init
  Args* = object
    case kind*: Command
    of Run:
      words*: seq[string]
      minutes*: int
      notify*: Option[string]
      config*: string
      forever*: bool
    of Init:
      discard


proc parse*(): Args = 
  let args = docopt(doc, version = VERSION)
  if args["init"]:
    result = Args(kind: Command.Init)
  if args["run"]:
    result = Args(
      kind: Command.Run,
      words: @(args["<word>"]),
      minutes: ($args["--minutes"]).parseInt,
      notify: if args["--notify"].to_bool: some($args["--notify"]) else: none(string),
      config: $args["--config"],
      forever: args["--forever"],
    )
