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

TODO


### Create config

```
$ slackego init
```


### Set `SLACK_TOKEN`

Either `set a environmental variable` or `create .env`


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

```
$ slackego <search_word> --minutes 60
```

