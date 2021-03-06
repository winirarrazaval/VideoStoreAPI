class RemoveAColumnInMoviesAnAddToCustomers < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :movies_checked_out_count

    add_column :customers, :movies_checked_out_count, :integer, default: 0
  end
end
