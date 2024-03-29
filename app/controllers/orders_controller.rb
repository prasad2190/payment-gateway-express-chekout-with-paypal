class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end


  def express

  response = GATEWAY.setup_purchase(1000,
    :ip => '127.0.0.1',
      :return_url => "http://localhost:3000/orders/new",
      :cancel_return_url => "http://localhost:3000/cancel"
  )
  redirect_to GATEWAY.redirect_url_for(response.token)
end

  # GET /orders/new
  # GET /orders/new.json
  def new
    binding.pry
    @order = Order.new(:express_token => params[:token])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  
  def create
    binding.pry
    @order = Order.new(params[:order])
      @order.ip_address = request.remote_ip
  if @order.save
    if @order.purchase
      render :action => "success"
    else
      render :action => "failure"
    end
  else
    render :action => 'new'
  end
  end



  
  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
