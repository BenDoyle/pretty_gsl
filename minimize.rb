require 'gsl'
#require 'debug'

class Minimize
  include GSL
  include GSL::MultiMin

  attr_accessor :verbose

  def initialize(loss, constants, options = {})
    @loss            = loss
    @constants       = constants
    @params = {
      max_iterations:               100,  # the maximum number of iterations to carry out the minimization
      step_size:                    0.01, # initial guess of the length scale of the minimiztion steps
      direction_tolerance:          1e-4, # the tolerance for errors in the direction of line minimization
      absolute_gradient_tolerance:  1e-3, # halt if the magnetude of the gradient falls below this value
    }.merge(options)
  end

  def minimize(*guess)
    loss = Function_fdf.alloc(@loss, @params[:gradient], guess.size)
    loss.set_params(@constants)
    x = Vector.alloc(*guess)
    minimizer = FdfMinimizer.alloc("conjugate_fr", guess.size)
    minimizer.set(loss, x, @params[:step_size], @params[:direction_tolerance])

    iter = 0
    begin
      iter += 1
      status = minimizer.iterate()
      status = minimizer.test_gradient(@params[:absolute_gradient_tolerance])
      puts("Minimum found at") if status == GSL::SUCCESS
      x = minimizer.x
      f = minimizer.f
      printf("%5d %.5f %.5f %10.5f\n", iter, x[0], x[1], f)
    end while status == GSL::CONTINUE and iter < @params[:max_iterations]
  end
end

