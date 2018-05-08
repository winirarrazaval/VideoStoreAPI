class AddColumnToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :movies_checked_out_count, :integer, default: 0
  end
end
