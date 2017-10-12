#!/usr/bin/env ruby

require 'dotenv'
require 'json'
require 'open-uri'

Dotenv.load

def get_track
  %x{ osascript <<APPLESCRIPT
    if application "iTunes" is running then
      tell application "iTunes"
        if player state is paused
          return ""
        else
          set track_artist to the artist of the current track
          set track_name to the name of the current track
          set track_display to "Listening to " & track_artist & ": " & track_name
        end if
      end tell
      return track_display
    else
      return ""
    end if
  APPLESCRIPT }
end

track = URI::encode(get_track)
track.gsub!('%0A','')
status_emoji = ":headphones:" unless track == ""

tokens = ENV['SLACK_TOKENS'].split(',')
users = ENV['SLACK_USERS'].split(',')

token_users = tokens.zip(users)

token_users.each do |token, user|
  presence_response = `curl -s 'https://slack.com/api/users.getPresence?token=#{token}&user=#{user}'`
  presence = JSON.parse(presence_response)['presence']

  profile = `curl -s 'https://slack.com/api/users.profile.get?token=#{token}'`
  status_text = JSON.parse(profile)['profile']['status_text'] || ''

  if presence == 'active' && status_text && (status_text.include?("Listening to") || status_text.empty?)
    track.gsub!("'",'%27')
    track.gsub!('?','%3F')
    track.gsub!('+','%2B')
    track.gsub!('&','%26')
    track.gsub!('%0A','')
    track = track[0..99]
    track.gsub!(/.{3}$/,'...') if track.length == 100
    track.gsub!(/%.$/,'')
    curl = "curl -s -XPOST 'https://slack.com/api/users.profile.set?token=#{token}&profile=%7B%22status_emoji%22%3A%22#{status_emoji}%22%2C%22status_text%22%3A%22#{track}%22%7D'"
    `#{curl}`
  end
end

