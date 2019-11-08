# frozen_string_literal: true

module Jet
  module Core
    module InstanceRegistry
      def self.extended(base)
        super
        base.instance_variable_set(:@registry, {})
      end

      def [](obj)
        @registry[obj]
      end

      def []=(key, obj)
        raise "no `type` for registry has been set yet" unless @type
        @registry[Jet.type_check!("`key`", key, Symbol)] = Jet.type_check!("`obj`", obj, @type)
      end

      def fetch(*args)
        @registry.fetch(*args)
      end

      def freeze
        @registry.freeze
        super
      end

      def register(hash)
        hash.each { |key, obj| self[key] = obj }
        self
      end

      def to_h
        @registry.dup
      end

      def type(type = nil)
        return @type unless type
        raise "`type` cannot be changed once set" if @type
        Jet.type_check!("`type`", type, Class, Module)
        @type = type
      end
    end
  end
end
