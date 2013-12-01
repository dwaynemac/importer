require 'spec_helper'

describe ImportModulesController do
  before do
    a = Account.first || create(:account)
    @user = build(:user, current_account_id: a.id)

    # mock interaction with padma-accounts-ws
    padma_account = PadmaAccount.new(name: @user.current_account.name)
    PadmaAccount.stub(:find).and_return padma_account
    padma_user = PadmaUser.new(
      username: @user.username,
      email: "test@test.com",
      current_account: padma_account,
      current_account_name: a.name
    )
    User.any_instance.stub(:padma).and_return(padma_user)

    Account.any_instance.stub(:padma).and_return(padma_account)
    User.any_instance.stub(:enabled_accounts).and_return([padma_account])

    # user is admin
    User.any_instance.stub(:admin?).and_return(true)

    @user.save!
    sign_in @user
  end

  let(:import_module){create(:import_module)}

  describe "#update" do
    before { put :update, id: import_module.id, import_module: { ignore_failed_rows: 'false' } }
    it "redirect to import" do
      should redirect_to import_module.import
    end
  end
end
