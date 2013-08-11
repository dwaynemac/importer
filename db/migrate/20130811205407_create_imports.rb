class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.references :account

      t.timestamps
    end
  end
end
