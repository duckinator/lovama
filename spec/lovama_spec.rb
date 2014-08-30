require 'spec_helper'

TEST_STRING = "default value!"

describe 'local_variable_set' do
  it 'raises a TypeError if the first argument is not a String or a Symbol' do
    lambda { local_variable_set(1, 2) }.must_raise TypeError
  end

=begin
  it 'defines new variables' do
    tmp =
      begin
        test_variable
      rescue NameError => e
        e
      end

    tmp.must_be_instance_of NameError

    local_variable_set(:test_variable, true).must_equal true

    test_variable.must_equal true
  end
=end

  it 'redefines variables' do
    test_variable = false

    local_variable_set(:test_variable, true)

    test_variable.must_equal true
  end
end

describe 'local_variable_get' do
  it 'raises a TypeError if the first argument is not a String or a Symbol' do
    lambda { local_variable_get(1) }.must_raise TypeError
  end

  it 'raises a NameError for undefined variables' do
    lambda { local_variable_get(:test_variable) }.must_raise NameError
  end

  it 'returns the value of defined variables' do
    test_variable = true

    local_variable_get(:test_variable).must_equal true
  end
end
