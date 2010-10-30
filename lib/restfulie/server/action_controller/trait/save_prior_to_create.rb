module Restfulie::Server::ActionController::Trait::SavePriorToCreate
  def to_format
    if (options[:status] == 201) || (options[:status] == :created)==201
      if resource.save
        super
      else
        render :action => "new"
      end
    else
      super
    end
  end
end
