require 'yajl'
require 'active_support'
require 'active_support/core_ext/hash'
require 'prowly'
require 'pushover'

module PapertrailNotificationWebhook
  class App < Sinatra::Base
    get '/' do
      "200\n"
    end

    post '/submit' do
      payload = HashWithIndifferentAccess.new(Yajl::Parser.parse(params[:payload]))

      notify_pushover(payload)
      notify_prowl(payload)

      'ok'
    end

    def notify_prowl(payload)
      return unless ENV['PROWL_API_KEY']

      payload[:events].each do |event|
        Prowly.notify do |n|
          n.apikey      = ENV['PROWL_API_KEY']
          n.priority    = Prowly::Notification::Priority::NORMAL
          n.application = 'Papertrail'
          n.event       = event[:hostname]
          n.description = event[:message]
          n.url         = "#{payload[:saved_search][:html_search_url]}?center_on_id=#{event[:id]}"
        end
      end
    end

    def notify_pushover(payload)
      return unless ENV['PUSHOVER_APP_API_KEY'] && ENV['PUSHOVER_USER_API_KEY']

      payload[:events].each do |event|
        Pushover.notification(
          :token     => ENV['PUSHOVER_APP_API_KEY'],
          :user      => ENV['PUSHOVER_USER_API_KEY'],
          :title     => event[:hostname],
          :message   => event[:message],
          :timestamp => Time.iso8601(event[:received_at]).to_i,
          :url_title => "View logs",
          :url       => "#{payload[:saved_search][:html_search_url]}?center_on_id=#{event[:id]}"
        )
      end
    end
  end
end