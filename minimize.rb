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
      max_iterations: 100,
      foo:            0.01,
      bar:            1e-4,
      baz:            1e-3,
    }.merge(options)
  end

  def minimize(*guess)
    my_func = Function_fdf.alloc(@loss, @params[:gradient], guess.size)
    my_func.set_params(@constants)      # parameters

    x = Vector.alloc(*guess)          # starting point

    minimizer = FdfMinimizer.alloc("conjugate_fr", guess.size)
    minimizer.set(my_func, x, @params[:foo], @params[:bar])

    iter = 0
    begin
      iter += 1
      status = minimizer.iterate()
      status = minimizer.test_gradient(@params[:baz])
      puts("Minimum found at") if status == GSL::SUCCESS
      x = minimizer.x
      f = minimizer.f
      printf("%5d %.5f %.5f %10.5f\n", iter, x[0], x[1], f)
    end while status == GSL::CONTINUE and iter < @params[:max_iterations]
  end
end

