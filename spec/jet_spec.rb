require "spec_helper"

class JetSpec < Minitest::Spec
  it "infers a context" do
    hash = { key: "output" }
    _(Jet.context(nil)).must_equal({})
    _(Jet.context(hash)).must_equal(hash)
    _(Jet.context(hash, a: 1)).must_equal(hash.merge(a: 1))
    _(Jet.context(Jet::Result.failure(:example_error, hash))).must_equal(hash)
  end
end
