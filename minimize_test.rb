require './minimize'

loss = Proc.new do |variables, constants|
  x = variables[0]
  y = variables[1]
  p0 = constants[0]
  p1 = constants[1]
  10.0 * (x - p0) * (x - p0) + 20.0 * (y - p1) * (y - p1) + 30.0
end

loss_gradient = Proc.new do |variables, constants, gradient_components|
  x = variables[0]
  y = variables[1]
  p0 = constants[0]
  p1 = constants[1]
  gradient_components[0] = 20.0*(x-p0)
  gradient_components[1] = 40.0*(y-p1)
end

constants = [1.0, 2.0]
guess     = [5.0, 7.0]

puts Minimize.new(loss, constants, loss_gradient: loss_gradient).minimize(*guess)
puts Minimize.new(loss, constants).minimize(*guess)

