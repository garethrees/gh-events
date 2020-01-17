require 'ostruct'
require 'json'

module GH::Events::Text
  extend self

  def translate(payload, dict)
    payload_with_type = GH::Parser::WithType.new(JSON.parse(payload))
    event = JSON.parse(payload_with_type.to_json, object_class: OpenStruct)

    # unify
    event.ref_type = 'branch' if event.ref&.match(/^refs\/heads\//)
    event.ref_type = 'tag' if event.ref&.match(/^refs\/tags\//)
    event.ref = event.ref&.split('/')&.last

    GH::Events::Template.for_event(event, dict: dict)&.render(event)
  end
end
