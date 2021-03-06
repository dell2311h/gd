class ImageRelation < ActiveRecord::Base
  belongs_to  :image
  belongs_to  :owner, :polymorphic => true
  
  def owner_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
end
