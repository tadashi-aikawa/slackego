Slackego
========

Ego search script for Slack.


Requirements
------------

* Linux
* Mac (maybe)


Quick start
-----------

### Install

```
$ curl https://raw.githubusercontent.com/tadashi-aikawa/slackego/master/install.sh | sudo sh
```


### Create config

```
$ slackego init
```


### Set `SLACK_TOKEN`

Either `set a environmental variable` or `create .env`.

You can get legacy tokens at https://api.slack.com/custom-integrations/legacy-tokens.

### Check usage

```
$ slackego --help
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
```


### Run

They are examples.

```
# Search for tadashi-aikawa.
$ slackego run tadashi-aikawa --minutes 60

# If you want to notify results to #times_tadashi-aikawa (slack channel)
$ slackego run tadashi-aikawa --minutes 60 --notify times_tadashi-aikawa
```


For developers
--------------

### Development

TODO


### Release

1. Update version in `slackego.nimble`
2. Update version in `install.sh`
3. Update version in `src/slackegopkg/args.nim`
4. `make release`
