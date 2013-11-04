require 'spec_helper'

describe ImportModule do

  let(:import_module){create(:import_module)}

  describe "#realtime_status" do
    describe "if status_url if nil" do
      it "returns nil" do
        import_module.realtime_status.should be_nil
      end
    end
  end
end
