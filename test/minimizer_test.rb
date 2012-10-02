require 'test_helper'

class MinimizerTest < Test::Unit::TestCase
  include PrettyGSL
  def setup
    @function = Proc.new do |variables, constants|
      x = variables[0]
      y = variables[1]
      p0 = constants[0]
      p1 = constants[1]
      10.0 * (x - p0) * (x - p0) + 20.0 * (y - p1) * (y - p1) + 30.0
    end

    @function_gradient = Proc.new do |variables, constants, gradient_components|
      x = variables[0]
      y = variables[1]
      p0 = constants[0]
      p1 = constants[1]
      gradient_components[0] = 20.0*(x-p0)
      gradient_components[1] = 40.0*(y-p1)
    end

    @constants = [1.0, 2.0]
    @guess     = [5.0, 7.0]
  end

  def test_with_gradient
    assert_not_nil Minimizer.new(@function, @constants, function_gradient: @function_gradient).minimize(*@guess)
  end

  def test_without_gradient
    assert_not_nil Minimizer.new(@function, @constants).minimize(*@guess)
  end

end