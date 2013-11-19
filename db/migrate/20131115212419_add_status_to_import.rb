class AddStatusToImport < ActiveRecord::Migration
  def change
    add_column :imports, :status, :string, default: 'pending'
  end
end
