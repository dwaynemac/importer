require 'spec_helper'

describe ContactsFileImporter do

  let(:cfi) { create(:contacts_file_importer) }
  let(:cim) { create(:contacts_import_module, import: cfi.import) }

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
        cfi.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        cfi.ready?.should == false
      end
      it "should be waiting" do
        cfi.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      cfi.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      cfi.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if attendances-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        cfi.delegate_import()
        cfi.status_url.should == "test/pws/v1/files_export/1"
      end
    end

  end

end
