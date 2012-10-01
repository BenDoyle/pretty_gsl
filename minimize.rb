require 'gsl'
#require 'debug'

class Minimize
  include GSL
  include GSL::MultiMin

  attr_accessor :verbose
  attr_reader :result

  def initialize(loss, constants, options = {})
    @loss            = loss
    @constants       = constants
    @params = {
      max_iterations:               100,  # the maximum number of iterations to carry out the minimization
      step_size:                    0.01, # initial guess of the length scale of the minimiztion steps
      direction_tolerance:          1e-4, # the tolerance for errors in the direction of line minimization
      absolute_gradient_tolerance:  1e-3, # halt if the magnetude of the gradient falls below this value
    }.merge(options)
    @result = nil
    self
  end

  def minimize(*guess)
    loss = Function_fdf.alloc(@loss, @params[:loss_gradient], guess.size)
    loss.set_params(@constants)
    x = Vector.alloc(*guess)
    minimizer = FdfMinimizer.alloc("conjugate_fr", guess.size)
    minimizer.set(loss, x, @params[:step_size], @params[:direction_tolerance])
    @params[:max_iterations].times do |iter|
      status = minimizer.iterate
      status = minimizer.test_gradient @params[:absolute_gradient_tolerance]
      if status != CONTINUE
        @result = {
          success:    status == SUCCESS,
          minimum_x:  minimizer.x.to_a,
          minimum_f:  f = minimizer.f,
          iterations: iter
        }
        break
      end
    end
    @result
  end
end

