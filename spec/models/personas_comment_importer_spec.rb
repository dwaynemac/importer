require 'spec_helper'

describe PersonasCommentImporter do

  let(:perscommimp) { create(:personas_comment_importer) }
  let(:cim) { create(:contacts_import_module, import: perscommimp.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      cim
    end

    describe "when contact importer finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        perscommimp.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        perscommimp.ready?.should == false
      end
    end

  end

  describe "#delegate_import" do
    before do
      perscommimp.stub_chain(:import_file, :personas, :url).and_return("x_path")
      perscommimp.stub_chain(:open, :read) {"x_file"}
    end

    describe "if crm-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        perscommimp.delegate_import()
        perscommimp.status_url.should == "localhost:3000/api/v0/imports/1"
      end
    end
  end

end