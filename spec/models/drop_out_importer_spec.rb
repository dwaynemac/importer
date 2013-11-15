require 'spec_helper'

describe DropOutImporter do

  let(:dp_imp) { create(:drop_out_importer) }
  let(:enroll_imp) { create(:enrollment_importer, import: dp_imp.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      enroll_imp
    end

    describe "when contact importer finished" do
      before do
        EnrollmentImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        dp_imp.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        EnrollmentImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        dp_imp.ready?.should == false
      end
    end

  end

  describe "#delegate_import" do
    before do
      dp_imp.stub_chain(:import_file, :drop_outs, :url).and_return("x_path")
      dp_imp.stub_chain(:open, :read) {"x_file"}
    end

    describe "if crm-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        dp_imp.delegate_import()
        dp_imp.status_url.should == "localhost:3000/api/v0/imports/1"
      end
    end
  end

end