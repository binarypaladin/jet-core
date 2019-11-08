require "spec_helper"

module Jet
  class ResultSpec < Minitest::Spec
    it "creates a success result" do
      r = Result.success(:output, key: "output")

      assert Jet.success?(r)
      assert r.success?
      refute Jet.failure?(r)
      refute r.failure?

      assert r == :output
      _(r.context).must_equal(key: "output")
      _(r.errors).must_be_empty
      _(r.output).must_equal(:output)
      _(r[:key]).must_equal("output")
    end

    it "creates a failure result" do
      msg = "Access denied to resource."
      r = Result.failure(:not_authorized, errors: msg)

      assert Jet.failure?(r)
      assert r.failure?
      refute Jet.success?(r)
      refute r.success?

      assert r == :not_authorized
      _(r.context).must_equal(errors: [msg])
      _(r.errors.first).must_equal(msg)
      _(r.output).must_equal(:not_authorized)
      _(r[:errors].first).must_equal(msg)
    end
  end
end
