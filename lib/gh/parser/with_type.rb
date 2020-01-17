require 'delegate'
require 'yaml'
require_relative '../../hash'

module GH
  module Parser
    class WithType < SimpleDelegator
      PATH = File.expand_path(File.join(%w(res events.yml)))
      HEURISTICS = YAML.load_file(PATH)

      # this is a carefully curated list of fields in gh-events that might
      # be helpful when filtering events
      ASPECTS = %w[type action state]

      def [](key)
        parse_extra_attributes
        super
      end

      def to_json
        parse_extra_attributes
        super
      end

      private

      def parse_extra_attributes
        payload['type'] ||= parse_type
        payload['aspects'] ||= parse_aspects
        payload['stype'] ||= parse_stype
      end

      def parse_type
        HEURISTICS.each do |type, characteristics|
          # all keys in `present` are there
          x = characteristics.fetch('present', []) - keys
          next unless x.empty?

          # non of the keys in `absent` are there
          y = characteristics.fetch('absent', []) & keys
          next unless y.empty?

          # everything in `exactly` is there including the values
          exactly = characteristics.fetch('exactly', {})
          z = deep_stringified_keys.dup.merge(exactly) == deep_stringified_keys
          next unless z

          n = characteristics['number_of_keys'] &&
              keys.count != characteristics['number_of_keys']
          next if n

          return type
        end

        return 'unknown'
      end

      def parse_aspects
        ASPECTS.map { |a| payload[a] }.compact
      end

      def parse_stype
        payload['aspects'] * '.'
      end

      def keys
        deep_stringified_keys.keys
      end

      def deep_stringified_keys
        payload.to_h.deep_stringify_keys
      end

      def payload
        __getobj__
      end
    end
  end
end
