require 'spec_helper'

describe TimeSlotImporter do

  let(:tsi) { create(:time_slot_importer) }
  let(:cim) { create(:contacts_import_module, import: tsi.import) }

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
        tsi.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        tsi.ready?.should == false
      end
    end

  end

  describe "#delegate_import" do
    before do
      tsi.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      tsi.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if attendances-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        tsi.delegate_import()
        tsi.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
