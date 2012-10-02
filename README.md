# PrettyGLS

This gem provides a nice interface to the <a href = 'http://rb-gsl.rubyforge.org/'>GNU scientific library</a> through the <a href = 'http://www.gnu.org/software/gsl/manual/html_node/'>Ruby/GSL</a> wrapper. I've simply attempted to update the interface to use more idiomatic ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'pretty_gsl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pretty_gsl

## Usage

    function          = Proc.new{ |variables, constants| ...}
    optional_gradient = Proc.new{ |variables, constants, gradient_components| ...}
    constants = [1,2,3, ...]
    guess = [1,2,3, ...]
    m = Minimizer.new(function, constants, function_gradient: optional_gradient)
    m.minimize(*guess)
    => {:success=>true, :minimum_x=>[1, 2], :iterations=>50, :minimum_f=>30.0, :simplex_size=>0.0008 ... }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
