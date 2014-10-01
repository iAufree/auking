class AddTopicCountToTopic < ActiveRecord::Migration
  def self.up 
  	add_column :topics, :comments_count, :integer, default: 0
  	Topic.all.each do |t|
  	  Topic.update_counters t.id, comments_count: t.comments.length
  	end
    add_column :topics, :suggested, :boolean, default: false
    add_column :topics, :excellent, :boolean, default: false
  end

  def self.down
  	remove_column :topics, :comments_count
  end
end
