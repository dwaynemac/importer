class ChangeDefaultValueOfStatus < ActiveRecord::Migration
  def change
    change_column :import_modules, :status, :string, default: "ready"
    change_column :imports, :status, :string, default: "ready"
  end
end
