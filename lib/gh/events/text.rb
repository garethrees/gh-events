require 'ostruct'
require 'json'

module GH::Events::Text
  extend self

  def translate(payload, dict)
    payload_with_extras =
       GH::Parser::WithRef.new(GH::Parser::WithType.new(JSON.parse(payload)))
    event = JSON.parse(payload_with_extras.to_json, object_class: OpenStruct)

    GH::Events::Template.for_event(event, dict: dict)&.render(event)
  end
end
