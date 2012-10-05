module PrettyGSL
  class Minimizer
    include GSL
    include GSL::MultiMin

    attr_reader :result

    def initialize(function, constants, options = {})
      @function            = function
      @constants       = constants
      @params = {
        max_iterations:               100,  # the maximum number of iterations to carry out the minimization
        step_size:                    0.01, # initial guess of the length scale of the minimiztion steps
        direction_tolerance:          1e-4, # the tolerance for errors in the direction of line minimization
        absolute_gradient_tolerance:  1e-3, # halt if the magnetude of the gradient falls below this value
        logger:                       nil,  # logger target
      }.merge(options)
      @result  = nil
      @logger = Logger.new(@params[:logger])
      self
    end

    def minimize(*guess)
      minimizer = get_gsl_minimizer(guess)
      @params[:max_iterations].times do |iter|
        status = minimizer.iterate
        status = test_gsl_convergence(minimizer)
        @logger.info minimizer.x.to_a.inspect
        if status != CONTINUE
          @result = {
            success:    status == SUCCESS,
            minimum_x:  minimizer.x.to_a,
            iterations: iter
          }.merge(get_gsl_result(minimizer))
          break
        end
      end
      @result
    end

    protected
    def test_gsl_convergence(minimizer)
      if @params[:function_gradient]
        minimizer.test_gradient @params[:absolute_gradient_tolerance]
      else
        minimizer.test_size @params[:absolute_gradient_tolerance]
      end
    end

    def get_gsl_minimizer(guess)
      minimizer = nil
      if @params[:function_gradient]
        function = Function_fdf.alloc(@function, @params[:function_gradient], guess.size)
        function.set_params(@constants)
        minimizer = FdfMinimizer.alloc("conjugate_fr", guess.size)
        minimizer.set(function, Vector.alloc(*guess), @params[:step_size], @params[:direction_tolerance])
      else
        function = Function.alloc(@function, guess.size)
        function.set_params(@constants)
        minimizer = FMinimizer.alloc("nmsimplex", guess.size)
        ss = Vector.alloc(guess.size)
        ss.set_all(@params[:step_size])
        minimizer.set(function, Vector.alloc(*guess), ss)
      end
      minimizer
    end

    def get_gsl_result(minimizer)
      if @params[:function_gradient]
        {
          minimum_f:  minimizer.f,
        }
      else
        {
          minimum_f:    minimizer.fval,
          simplex_size: minimizer.size,
        }
      end
    end
  end
end