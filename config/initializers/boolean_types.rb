class Object
  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass) 
  end
end
