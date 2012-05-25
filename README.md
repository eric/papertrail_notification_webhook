# Papertrail Notification Webhook

A simple webhook to send log messages to iOS notifiers.

## Deploying

### Step 1: Create a heroku app

    $ heroku create

### Step 2: Create a Papertrail saved search

1. Create a saved search for a unique term (something like `ops-alert` would work)
2. Create a search alert (webhook) pointing to your heroku app pointing to `/submit`

Find out more about search alerts and webhooks here: http://help.papertrailapp.com/kb/how-it-works/web-hooks


## Setting up Prowl

### Step 1: Get a prowl API key

From https://www.prowlapp.com/api_settings.php

### Step 2: Add API key to your heroku app

    $ heroku config:add PROWL_API_KEY=69fd475972db19b6c2ee1f68d08acff1c4bcbf5b

## Setting up Pushover

### Step 1: Get a Pushover API key

From https://pushover.net/apps/build

### Step 2: Add API key to your heroku app

    $ heroku config:add PUSHOVER_APP_API_KEY=ea7b2ec95c62009404a41009b4d64ed6b8b66d73
    $ heroku config:add PUSHOVER_USER_API_KEY=ea7b2ec95c62009404a41009b4d64ed6b8b66d73


## Using

Once you've created a saved search in Papertrail and configured the search
alert, you can now send log messages that match that message.

For example, if your saved search matches `ops-alert`, you could use this 
to alert you when a big transfer has completed:

    $ rsync -R /backup backup:/backup ; logger -t ops-alert The transfer has completed
