# slacktunes

Set your Slack status to the current iTunes track (when you're set to active on Slack)

## How?

Get a Slack token (or tokens if you want to do this across multiple Slack workspaces) or use your [test Slack token](https://api.slack.com/docs/oauth-test-tokens).

Get your Slack User ID (or IDs if you want to do this across multiple Slack workspaces):

`curl -s 'https://slack.com/api/auth.test?token=your_token_here' | jq .user_id`

Create an `.env` file and replace with your own Slack token(s) and user ID(s). For example:

```
SLACK_TOKENS=xoxp-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxxx-xxxxxxxxxx,xoxp-xxxxxxxxxx-xxxxxxxxxx-xxxxxxxxxxx-xxxxxxxxxx
SLACK_USERS=U12345678,U23456789
```

Run `ruby slacktunes.rb`

## Scheduling

Run it on a cron.

Add this to your `~/.bashrc` so cron doesn't 😧 about any special ❄️ characters

```
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

Add this to your crontab with `crontab -e` to run it every two minutes:

```
SHELL=/bin/bash
BASH_ENV="~/.bashrc"
*/2 * * * * cd /path/to/slacktunes && /path/to/bundle exec ruby slacktunes.rb > /dev/null
```
