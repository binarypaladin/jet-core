# frozen_string_literal: true

module Jet
  class Result
    class << self
      def failure(output = nil, context = {})
        new(false, output, context)
      end

      def success(output = nil, context = {})
        new(true, output, context)
      end
    end

    attr_reader :context, :output

    def initialize(success, output = nil, context = {})
      @context = _context(context)
      @success = success ? true : false
      @output = output
    end

    def !=(other)
      !(self == other)
    end

    def ==(other)
      return output == other.output if other.is_a?(self.class)
      output == other
    end

    def [](key)
      @context[key]
    end

    def at
      context.fetch(:at, [])
    end

    def errors
      context.fetch(:errors, [])
    end

    def errors_at(*at)
      at.flatten.yield_self { |a| errors.select { |e| e.at[0...a.size] == a } }
    end

    def failure?
      !@success
    end

    def success?
      @success
    end

    def with(**context)
      self.class.new(@success, @output, @context.merge(context))
    end

    private

    def _errors(errors)
      case errors
      when Hash
        errors.map { |at, error| error.with(at: error.at + Array(at)) }
      else
        Array(errors)
      end
    end

    def _context(context)
      context.dup.tap do |ctx|
        ctx[:at] &&= Array(ctx[:at])
        ctx[:errors] &&= _errors(ctx[:errors])
      end
    end
  end
end
