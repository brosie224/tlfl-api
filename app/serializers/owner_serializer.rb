class OwnerSerializer < ActiveModel::Serializer
  belongs_to :tlfl_team
  attributes :id, :full_name, :email, :phone
end
