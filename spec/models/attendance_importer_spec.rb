require 'spec_helper'

describe AttendanceImporter do

  let(:ai) { create(:attendance_importer) }
  let(:tsi) { create(:time_slot_importer, import: ai.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      tsi
    end

    describe "when contact importer finished" do
      before do
        TimeSlotImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        ai.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        TimeSlotImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        ai.ready?.should == false
      end
    end

  end

  describe "#delegate_import" do
    before do
      ai.stub_chain(:import_file, :attendances, :url).and_return("x_path")  
      ai.stub_chain(:open, :read) {"x_file"} 
    end

    describe "if attendances-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        ai.delegate_import()
        ai.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
