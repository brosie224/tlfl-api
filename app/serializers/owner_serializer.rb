class OwnerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :phone
end
