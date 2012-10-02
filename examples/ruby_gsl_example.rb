# RUBY
# ruby 1.9.2p320 (2012-04-20 revision 35421) [x86_64-darwin11.3.0]

# GEM
# gsl (1.14.7)

# LIB
# gsl-1.15


require 'gsl'
include GSL
include GSL::MultiMin

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

my_func = Function_fdf.alloc(my_f, my_df, 2)
my_func.set_params([1.0, 2.0])      # parameters

x = Vector.alloc(5.0, 7.0)          # starting point

minimizer = FdfMinimizer.alloc("conjugate_fr", 2)
minimizer.set(my_func, x, 0.01, 1e-4)

iter = 0
begin
  iter += 1
  status = minimizer.iterate()
  status = minimizer.test_gradient(1e-3)
  puts("Minimum found at") if status == GSL::SUCCESS
  x = minimizer.x
  f = minimizer.f
  printf("%5d %.5f %.5f %10.5f\n", iter, x[0], x[1], f)
end while status == GSL::CONTINUE and iter < 100