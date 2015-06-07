require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: id, followed_id: 2)
  end
  
  
  
end
