require 'spec_helper'

describe EnrollmentImporter do

  let(:enroll_imp) { create(:enrollment_importer) }
  let(:commimp) { create(:communication_importer, import: enroll_imp.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      commimp
    end

    describe "when contact importer finished" do
      before do
        CommunicationImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        enroll_imp.ready?.should == true
      end
    end

    describe "when contact importer has not finished" do
      before do
        CommunicationImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        enroll_imp.ready?.should == false
      end
    end

  end

  describe "#delegate_import" do
    before do
      enroll_imp.stub_chain(:import_file, :enrollments, :url).and_return("x_path")
      enroll_imp.stub_chain(:open, :read) {"x_file"}
    end

    describe "if crm-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        enroll_imp.delegate_import()
        enroll_imp.status_url.should == "localhost:3000/api/v0/imports/1"
      end
    end
  end

end