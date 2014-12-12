class AddRestToReport < ActiveRecord::Migration
  def change
    add_column :reports, :rest, :string, :default => nil
  end
end
