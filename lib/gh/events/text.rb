require 'ostruct'
require 'json'

module GH::Events::Text

  extend self

  # this is a carefully curated list of fields in gh events that might
  # be helpful when filtering events
  ASPECTS = %i[type action state]

  def translate(payload, dict)
    event = JSON.parse(payload, object_class: OpenStruct)
    type = GH::Events.typeof(event).to_s

    # unify
    event.ref_type = 'branch' if event.ref&.match(/^refs\/heads\//)
    event.ref_type = 'tag' if event.ref&.match(/^refs\/tags\//)
    event.ref = event.ref&.split('/')&.last

    # add type to the event
    event.type = type

    # collect the aspects
    aspects = ASPECTS.map { |a| event.send(a) }.compact
    event.aspects = aspects

    # add the specific type (stype) to the event
    event.stype = aspects * '.'

    GH::Events::Template.for_event(event, dict: dict)&.render(event)
  end
end
