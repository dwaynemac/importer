require 'spec_helper'

describe FollowImporter do

  let(:fi) { create(:follow_importer) }
  let(:cim) { create(:contacts_import_module, import: fi.import) }

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
        fi.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        fi.ready?.should == false
      end
      it "should be waiting" do
        fi.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      fi.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      fi.stub_chain(:open_tmp_file, :read) {"x_file"} 
    end

    describe "if crm responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        fi.delegate_import()
        fi.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
