class AddAttachmentImageToFeatures < ActiveRecord::Migration
  def self.up
    change_table :features do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :features, :image
  end
end