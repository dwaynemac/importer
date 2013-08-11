require 'spec_helper'

describe "Imports" do
  describe "GET /imports" do
    it "Redirects when not admin" do
      get imports_path
      response.status.should be(302)
    end
  end
end
