require 'spec_helper'

describe InstallmentImporter do

  let(:ii) { create(:installment_importer) }
  let(:mi) { create(:membership_importer, import: ii.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      mi
    end

    describe "when membership importer has not finished" do
      before do
        MembershipImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        ii.ready?.should == false
      end
    end

    describe "when membership importer has finished" do
      before do
        MembershipImporter.any_instance.stub(:finished?) {true}
       end
      it "should be ready" do
        ii.ready?.should == true
      end
    end
  end

  describe "#delegate_import" do
    before do
      ii.stub_chain(:import_file, :installments, :url).and_return("x_path")
      ii.stub_chain(:open_tmp_file, :read) {"x_file"}
    end

    describe "if fnz-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        ii.delegate_import()
        ii.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
