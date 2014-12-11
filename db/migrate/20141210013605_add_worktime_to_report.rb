class AddWorktimeToReport < ActiveRecord::Migration
  def change
    add_column :reports, :work_start_time, :time
    add_column :reports, :work_end_time, :time

  end
end
