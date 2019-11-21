module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      @connection_token = SecureRandom.urlsafe_base64
    end
  end
end
