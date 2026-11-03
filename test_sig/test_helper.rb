require "test/unit"
require "rbs/unit_test"

module TestHelper
  include RBS::UnitTest::TypeAssertions

  def self.included(base)
    base.extend RBS::UnitTest::TypeAssertions::ClassMethods
  end
end
