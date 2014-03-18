class AddSourceSystemToImport < ActiveRecord::Migration
  def change
    add_column :imports, :source_system, :string
  end
end
