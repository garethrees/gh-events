require 'erb'
require 'ostruct'
require 'yaml'

module GH
  module Events
    class Template
      class UnknownDictFileError < StandardError ; end

      def self.for_event(event, dict: nil)
        dict ||= 'plain'

        templates = YAML.load_file(templates_file(dict))

        # lookup the template by type and all the specific types
        _result = event.aspects.reduce({as: [], ts: []}) do |r, aspect|
          r[:as] << aspect
          r[:ts] << templates[r[:as] * '.']
          r
        end

        template = _result[:ts].compact.last

        # if the event was set to `false` abort
        return nil if template === false

        # if there is no template use a default
        template ||= templates['no_template']

        new(template)
      end

      def self.templates_file(dict)
        dict_file = File.join(%w(.. .. .. .. res) << "#{dict}.yml")
        preset = File.expand_path(dict_file, __FILE__)
        return preset if File.exists?(preset)

        return dict if File.exists?(dict.to_s)

        raise UnknownDictFileError, "Could not find dict file: #{dict}"
      end

      class ErbBinding < OpenStruct
        def get_binding
          return binding()
        end
      end

      def initialize(template_data)
        @template_data = template_data
      end

      def render(payload)
        ERB.new(JSON.unparse(template_data)).
          result(ErbBinding.new(payload).get_binding)
      end

      def ==(other)
        template_data == other.template_data
      end

      protected

      attr_reader :template_data
    end
  end
end
