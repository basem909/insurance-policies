class CreatePolicies < ActiveRecord::Migration[7.2]
  def change
    create_table :policies do |t|
      t.string :policy_number
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :status

      t.timestamps
    end
  end
end
