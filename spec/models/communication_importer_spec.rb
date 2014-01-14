require 'spec_helper'

describe CommunicationImporter do

  let(:ci) { create(:communication_importer) }
  let(:cim) { create(:contacts_import_module, import: ci.import) }

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
        ci.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        ci.ready?.should == false
      end
      it "should be waiting" do
        ci.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      ci.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      ci.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if crm responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        ci.delegate_import()
        ci.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
