require 'spec_helper'

describe EnrollmentImporter do

  let(:ei) { create(:enrollment_importer) }
  let(:ci) { create(:communication_importer, import: ei.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      ci
    end

    describe "when coummuncation importer finished" do
      before do
        CommunicationImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        ei.ready?.should == true
      end
    end

    describe "when communication importer has not finished" do
      before do
        CommunicationImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        ei.ready?.should == false
      end
      it "should be waiting" do
        ei.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      ei.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      ei.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if crm responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        ei.delegate_import()
        ei.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
