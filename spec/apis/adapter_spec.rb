require 'spec_helper'

describe Apis::Adapter do
  it 'registers adapters shortnames' do
    Apis::Adapter.register(:fake, FakeAdapter)
    Apis::Adapter.lookup(:fake).should == FakeAdapter
  end

  specify ':net_http is set as default adapter' do
    Apis::Adapter.default.should == :net_http
  end
end
