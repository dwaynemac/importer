require 'spec_helper'

describe "imports/index" do
  before(:each) do
    assign(:imports, [
      stub_model(Import),
      stub_model(Import)
    ])
  end

  it "renders a list of imports" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
