class CreateImportModules < ActiveRecord::Migration
  def change
    create_table :import_modules do |t|
      t.belongs_to :import
      t.string :name
      t.string :status
    end
  end
end
