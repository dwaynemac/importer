class ChangeStatusDeafultValueToImportModule < ActiveRecord::Migration
  def change
    change_column :import_modules, :status, :string, default: 'pending'
  end
end
