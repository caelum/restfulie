# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password


  # HELPER IF WE NEED TO DEBUG SOMETHING
  #
  #
  #
  # def respond_to(*types, &block)
  #   puts "tentando aqui... #{request.headers['ACCEPT']}"
  #   raise ArgumentError, "respond_to takes either types or a block, never both" unless types.any? ^ block
  #   block ||= lambda { |responder| types.each { |type| responder.send(type) } }
  #   responder = Responder.new(self)
  #   def responder.respond
  #     # debugger
  #       for priority in @mime_type_priority
  #         puts "estou verificando esse tal de #{priority} sendo que posso #{@responses.keys}"
  #         if priority == Mime::ALL
  #           @responses[@order.first].call
  #           return
  #         else
  #           if @responses[priority]
  #             @responses[priority].call
  #             return # mime type match found, be happy and return
  #           end
  #         end
  #       end
  #       
  #       puts "ate agora nenhum..."
  # 
  #       if @order.include?(Mime::ALL)
  #         @responses[Mime::ALL].call
  #       else
  #         puts "nada mesmo!"
  #         @controller.send :head, :not_acceptable
  #       end
  #   end
  #   block.call(responder)
  #   responder.respond
  # end
  
end
