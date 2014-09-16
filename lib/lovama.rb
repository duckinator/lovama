require 'lovama/version'
require 'debug_inspector'

module Kernel
  def local_variable_set(variable, value)
    unless variable.is_a?(String) || variable.is_a?(Symbol)
      # Imitate behavior of {class,instance}_variable_set
      raise TypeError, "#{variable} is not a symbol"
    end

    b  = caller_binding
    id = b.__id__

    variable = variable.to_s
    b.eval(variable)

    $__LOVAMA_VALUES__ ||= {}
    $__LOVAMA_VALUES__[id] = value

    b.eval("#{variable} = $__LOVAMA_VALUES__[#{id}]")
  end

  def local_variable_get(variable)
    unless variable.is_a?(String) || variable.is_a?(Symbol)
      # Imitate behavior of {class,instance}_variable_get
      raise TypeError, "#{variable} is not a symbol"
    end

    caller_binding.eval(variable.to_s)
  end

  def local_variable_hash
    b = caller_binding

    hsh = {}
    b.eval("local_variables").each do |k|
      hsh[k] = b.eval(k.to_s)
    end

    hsh
  end

  private

  def caller_binding
    RubyVM::DebugInspector.open {|i| i.frame_binding(3) }
  end
end
