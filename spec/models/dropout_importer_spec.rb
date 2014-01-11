require 'spec_helper'

describe DropoutImporter do

  let(:di) { create(:dropout_importer) }
  let(:ei) { create(:enrollment_importer, import: di.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      ei
    end

    describe "when enrollment importer finished" do
      before do
        EnrollmentImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        di.ready?.should == true
      end
    end

    describe "when enrollment importer has not finished" do
      before do
        EnrollmentImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        di.ready?.should == false
      end
      it "should be waiting" do
        di.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      di.stub_chain(:import_file, :time_slots, :url).and_return("x_path")  
      di.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if crm responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        di.delegate_import()
        di.status_url.should == "test/v0/imports/1"
      end
    end

  end

end
