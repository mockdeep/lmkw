# frozen_string_literal: true

class CreateCheckCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :check_counts do |t|
      t.references :check, null: false, foreign_key: true
      t.bigint :value, null: false

      t.timestamps
    end
  end
end
