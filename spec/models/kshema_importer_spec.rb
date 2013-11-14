require 'spec_helper'

describe KshemaImporter do
  let(:import) { create(:import) }
  describe "#process" do
    %W(ContactsImportModule TimeSlotImporter TrialLessonImporter AttendanceImporter).each do |module_name|
      it "creates #{module_name}" do
        ki = KshemaImporter.new(import)
        expect{ki.process}.to change{module_name.constantize.count}.by 1
      end
    end
  end
end
