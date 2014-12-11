class CreateBusinessContents < ActiveRecord::Migration
  def change
    create_table :business_contents do |t|
      t.integer :report_id
      t.string :content_name
      t.timestamps
    end
    add_index :business_contents,[:report_id]
  end
end
