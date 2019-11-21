class SiteChannel < ApplicationCable::Channel

  def subscribed
    stream_from 'site_channel'
  end

  def unsubscribed
    stop_all_streams
  end
end
