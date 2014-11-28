class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|

      t.integer :user_id
      t.string :title
      t.string :body_text

      t.date :reported_date

      t.boolean :public_flag

      t.timestamps
    end
    add_index :reports,[:user_id, :created_at, :reported_date]
  end
end
