require 'gsl'
#require 'debug'

class Multimin
  include GSL
  include GSL::MultiMin

  def initialize(loss, constants = [], gradient = nil)
    @loss      = loss
    @gradient  = gradient
    @constants = constants
  end

  def minimize(*guess)
    my_func = Function_fdf.alloc(@loss, @gradient, guess.size)
    my_func.set_params(@constants)      # parameters

    x = Vector.alloc(*guess)          # starting point

    minimizer = FdfMinimizer.alloc("conjugate_fr", guess.size)
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
  end
end