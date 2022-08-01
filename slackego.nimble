# Package
version       = "0.1.2"
author        = "tadashi-aikawa"
description   = "Ego search script for Slack."
license       = "MIT"
srcDir        = "src"
bin           = @["slackego"]

# Dependencies
requires "nim >= 1.6.0"
requires "docopt >= 0.6.5"
requires "dotenv >= 2.0.1"

