require 'spec_helper'

describe "imports/show" do
  before(:each) do
    @import = assign(:import, stub_model(Import))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
