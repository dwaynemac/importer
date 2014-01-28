require 'spec_helper'

describe TrialLessonImporter do

  let(:trial_li) { create(:trial_lesson_importer) }
  let(:tsi) { create(:time_slot_importer, import: trial_li.import) }

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
        trial_li.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        TimeSlotImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        trial_li.ready?.should == false
      end
      it "should be waiting" do
        trial_li.realtime_status.should == 'waiting'
      end
    end

  end

  describe "#delegate_import" do
    before do
      trial_li.stub_chain(:import_file, :trial_lessons, :url).and_return("x_path")  
      trial_li.stub_chain(:open_tmp_file, :read) {"x_file"} 
    end

    describe "if attendances-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        trial_li.delegate_import()
        trial_li.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
