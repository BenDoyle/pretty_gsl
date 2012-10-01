require './multimin'

my_f = Proc.new do |v, params|
  x = v[0]
  y = v[1]
  p0 = params[0]
  p1 = params[1]
  10.0 * (x - p0) * (x - p0) + 20.0 * (y - p1) * (y - p1) + 30.0
end

my_df = Proc.new do |v, params, df|
  x = v[0]
  y = v[1]
  p0 = params[0]
  p1 = params[1]
  df[0] = 20.0*(x-p0)
  df[1] = 40.0*(y-p1)
end

m = Multimin.new(my_f, [1.0, 2.0], my_df)
m.minimize(5.0, 7.0)