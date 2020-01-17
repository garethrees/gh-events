require "gh/events/version"
require "gh/events/template"
require "gh/events/text"
require "gh/parser/with_ref"
require "gh/parser/with_type"
require 'json'

module GH
  module Events
    class Error < StandardError; end

    extend self

    def typeof(payload)
      GH::Parser::WithType.new(JSON.parse(payload))['type'].to_sym
    end
  end
end
