require 'spec_helper'

FakeAdapter = Class.new

describe Apis::Adapter do
  it 'registers adapters shortnames' do
    Apis::Adapter.register(:fake, FakeAdapter)
    Apis::Adapter.get_instance(:fake).should be_instance_of(FakeAdapter)
  end
end
