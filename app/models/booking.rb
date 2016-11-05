class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :type
  belongs_to :validation_by, :class_name => "User", :foreign_key => "validation_by"

end
