#!/bin/bash

VERSION=v0.2.0

wget https://github.com/tadashi-aikawa/slackego/releases/download/${VERSION}/slackego -O /usr/local/bin/slackego \
  && chmod +x /usr/local/bin/slackego

