require 'delegate'

module GH
  module Parser
    class WithRef < SimpleDelegator
      def [](key)
        parse_extra_attributes
        super
      end

      private

      def parse_extra_attributes
        payload['original_ref'] ||= payload['ref']
        payload['ref'] = parse_short_ref if payload['ref'] =~ /\//
        payload['ref_type'] ||= parse_ref_type
      end

      def parse_short_ref
        payload['ref']&.split('/')&.last
      end

      def parse_ref_type
        case payload['original_ref']
        when /^refs\/heads\//
          'branch'
        when /^refs\/tags\//
          'tag'
        else
          nil
        end
      end

      def payload
        __getobj__
      end
    end
  end
end
