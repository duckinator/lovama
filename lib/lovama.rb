require 'lovama/version'
require 'spinny/utilities'

module Kernel
  def local_variable_set(variable, value)
    unless variable.is_a?(String) || variable.is_a?(Symbol)
      # Imitate behavior of {class,instance}_variable_set
      raise TypeError, "#{variable} is not a symbol"
    end

    # eval() doesn't like Symbols.
    variable = variable.to_s

    # b is the binding local_variable_set was called from. We do gross things there.
    b  = Spinny::Utilities.caller_binding

    # If the variable is undefined, it will raise a NameError.
    # Since it's impossible to set variables that haven't been defined before,
    # this is a respectable alternative.
    b.eval(variable)

    # Store the value in a variable accessible in both bindings (in a way that
    # avoids race conditions -- hence value.__id__).
    id = value.__id__
    $__LOVAMA_VALUES__ ||= {}
    $__LOVAMA_VALUES__[id] = value

    # Set the variable, and remove it from the global variable (to remove latent
    # object references).
    # This also has the value the variable is set to become the return value.
    b.eval("#{variable} = $__LOVAMA_VALUES__.delete(#{id})")
  end

  def local_variable_get(variable)
    unless variable.is_a?(String) || variable.is_a?(Symbol)
      # Imitate behavior of {class,instance}_variable_get
      raise TypeError, "#{variable} is not a symbol"
    end

    Spinny::Utilities.caller_binding.eval(variable.to_s)
  end

  def local_variable_hash
    b = Spinny::Utilities.caller_binding

    hsh = {}
    b.eval("local_variables").each do |k|
      hsh[k] = b.eval(k.to_s)
    end

    hsh
  end
end
