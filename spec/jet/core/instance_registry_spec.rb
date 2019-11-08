require "spec_helper"

module Jet
  module Core
    class InstanceRegistrySpec < Minitest::Spec
      it "creates an instance registry module" do
        m = Module.new
        m.extend(InstanceRegistry)
        _(m.to_h).must_equal({})
        _(proc { m[:first_name] = "John" }).must_raise(RuntimeError)
        _(proc { m.type "John" }).must_raise(TypeError)

        m.type String
        m[:first_name] = "John"
        _(m[:first_name]).must_equal("John")
        _(proc { m[:first_name] = :John }).must_raise(TypeError)

        m.register(last_name: "Doe")
        _(m.to_h).must_equal(first_name: "John", last_name: "Doe")

        refute m.frozen?
        m.freeze
        assert m.frozen?
        _(proc { m[:last_name] = "Smith" }).must_raise(FrozenError)
      end
    end
  end
end
