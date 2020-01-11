require 'ostruct'
require 'json'

module GH
  module Events
    class Text
      def self.translate(json, dict)
        event =
          JSON.parse(
            GH::Parser::WithRef.new(
              GH::Parser::WithType.new(
                JSON.parse(json)
              )
            ).to_json, object_class: OpenStruct
          )
        template = GH::Events::Template.for_event(event, dict: dict)
        new(event, template).render
      end

      def initialize(event, template)
        @event = event
        @template = template
      end

      def render
        template&.render(event)
      end

      def ==(other)
        render == other.render
      end

      private

      attr_reader :event
      attr_reader :template
    end
  end
end
