require 'spec_helper'

describe "imports/edit" do
  before(:each) do
    @import = assign(:import, stub_model(Import))
  end

  it "renders the edit import form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", import_path(@import), "post" do
    end
  end
end
