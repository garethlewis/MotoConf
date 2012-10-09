require 'rho/rhocontroller'
require 'helpers/browser_helper'

class FAQController < Rho::RhoController
  include BrowserHelper

  # GET /FAQ
  def index
    @faqs = FAQ.find(:all)
    render :back => '/app'
  end

  # GET /FAQ/{1}
  def show
    @faq = FAQ.find(@params['id'])
    if @faq
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /FAQ/new
  def new
    @faq = FAQ.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /FAQ/{1}/edit
  def edit
    @faq = FAQ.find(@params['id'])
    if @faq
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /FAQ/create
  def create
    @faq = FAQ.create(@params['faq'])
    redirect :action => :index
  end

  # POST /FAQ/{1}/update
  def update
    @faq = FAQ.find(@params['id'])
    @faq.update_attributes(@params['faq']) if @faq
    redirect :action => :index
  end

  # POST /FAQ/{1}/delete
  def delete
    @faq = FAQ.find(@params['id'])
    @faq.destroy if @faq
    redirect :action => :index  
  end
end
