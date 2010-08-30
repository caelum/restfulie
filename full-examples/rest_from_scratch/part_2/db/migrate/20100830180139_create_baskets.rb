class CreateBaskets < ActiveRecord::Migration
  def self.up
    create_table :baskets do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :baskets
  end
end
