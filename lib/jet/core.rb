# frozen_string_literal: true

require "jet/core/version"

module Jet
  class << self
    def all_are?(obj, *types)
      obj.all? { |v| is_a?(v, *types) }
    end

    def context(obj, additional_context = nil)
      if obj.respond_to?(:context)
        obj.context
      elsif obj.is_a?(Hash)
        obj
      else
        {}
      end.yield_self { |ctx| additional_context ? ctx.merge(additional_context) : ctx }
    end

    def failure?(obj)
      obj.respond_to?(:failure?) ? obj.failure? : !obj
    end

    def is_a?(obj, *types)
      types.any? { |t| obj.is_a?(t) }
    end

    def success?(obj)
      obj.respond_to?(:success?) ? obj.success? : obj
    end

    def type_check!(desc, obj, *types)
      raise TypeError, "#{desc} must be #{type_error_desc(*types)}" unless
        is_a?(obj, *types)
      obj
    end

    def type_check_each!(desc, obj, *types)
      type_check!(desc, obj, Array)

      raise TypeError, "elements of #{desc} must be #{type_error_desc(*types)}" unless
        all_are?(obj, *types)

      obj
    end

    def type_check_hash!(desc, obj, *types, key_type: nil)
      type_check!(desc, obj, Hash)

      raise TypeError, "#{desc} keys must all be #{type_error_desc(*key_type)}" unless
        !key_type || all_are?(obj.keys, *key_type)

      raise TypeError, "#{desc} values must all be #{type_error_desc(*types)}" unless
        all_are?(obj.values, *types)

      obj
    end

    def type_error_desc(*types)
      return types.join(" or ") if types.size < 3
      "#{types[0..-2].join(', ')} or #{types.last}"
    end

    def output(obj)
      obj.respond_to?(:output) ? obj.output : obj
    end
  end

  module Core
    class << self
      def block_and_callables!(*callables, &blk)
        raise ArgumentError, "`callables` must respond to `call`" unless
          callables.all? { |obj| obj.respond_to?(:call) }

        ([blk] + callables).compact
      end

      def block_or_callable!(callable, &blk)
        raise ArgumentError, "both block and callable given" if blk && callable
        raise ArgumentError, "`callable` must respond to `call`" if
          callable && !callable.respond_to?(:call)

        blk || callable
      end
    end
  end
end

require "jet/core/instance_registry"
require "jet/result"
