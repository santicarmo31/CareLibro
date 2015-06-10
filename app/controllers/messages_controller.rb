class MessagesController < ApplicationController

  def new
    @message = Message.new
    @receiver = User.find_by(username: params[:username])

  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    if @message.save
      flash[:success] = "Mensaje enviado exitosamente"
      redirect_to "/#{current_user.username}"
    else
      flash[:error] = "Error al enviar mensaje"
      redirect_to "/#{current_user.username}"
    end
  end

  def index
    @messages = Message.where(receiver_id: current_user.id)
    if @messages.any?
      @senders = []
      for x in @messages
       user = x.sender_id
       @senders << User.find_by(id: user)
      end
    end
  end

  def show
    @message = Message.find(params[:id])
    @user = User.find_by(id: @message.sender_id)
  end

  def destroy
    @message = Message.find(params[:id])
    if @message.destroy
        redirect_to :messages
    else
        render :index, notice: "No se borro el mensaje"
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id,:content,:body)
  end
end
