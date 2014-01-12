require 'spec_helper'

describe MembershipImporter do

  let(:mi) { create(:membership_importer) }
  let(:cim) { create(:contacts_import_module, import: mi.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      cim
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        mi.ready?.should == false
      end
    end

    describe "when contact importer has finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {true}
       end
      it "should be ready" do
        mi.ready?.should == true
      end
    end
  end

  describe "#delegate_import" do
    before do
      mi.stub_chain(:import_file, :memberships, :url).and_return("x_path")
      mi.stub_chain(:open, :read) {"x_file"}
    end

    describe "if fnz-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        mi.delegate_import()
        mi.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
