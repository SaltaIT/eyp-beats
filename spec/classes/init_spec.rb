require 'spec_helper'
describe 'beats' do

  context 'with defaults for all parameters' do
    it { should contain_class('beats') }
  end
end
