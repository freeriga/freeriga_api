# frozen_string_literal: true

# disable coverage for now to speed these tests up

require 'simplecov'
require "active_record"

require "bullet"
SimpleCov.start 'rails'
RSpec.configure do |config|
  config.fail_fast = 1
end

# let's do these testsin English, eh?
I18n.locale = :en
