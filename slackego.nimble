# Package
version       = "0.1.1"
author        = "tadashi-aikawa"
description   = "Ego search script for Slack."
license       = "MIT"
srcDir        = "src"
bin           = @["slackego"]

# Dependencies
requires "nim >= 0.18.0"
requires "docopt >= 0.6.5"
requires "dotenv >= 1.1.0"

