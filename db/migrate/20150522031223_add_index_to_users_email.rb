class AddIndexToUsersEmail < ActiveRecord::Migration
  # migration of model data to database 
  # to ensure emails are unique when people doubleclick registration.
  def change
    # rails unique add_index method
    add_index :users, :email, unique: true
  end
end
