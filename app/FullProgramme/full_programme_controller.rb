require 'rho/rhocontroller'
require 'helpers/browser_helper'

class FullProgrammeController < Rho::RhoController
  include BrowserHelper

  # GET /FullProgramme
  def index
    @fullprogrammes = FullProgramme.find(:all)
    render :back => '/app'
  end

  # GET /FullProgramme/{1}
  def show
    @fullprogramme = FullProgramme.find(@params['id'])
    if @fullprogramme
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /FullProgramme/new
  def new
    @fullprogramme = FullProgramme.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /FullProgramme/{1}/edit
  def edit
    @fullprogramme = FullProgramme.find(@params['id'])
    if @fullprogramme
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /FullProgramme/create
  def create
    @fullprogramme = FullProgramme.create(@params['fullprogramme'])
    redirect :action => :index
  end

  # POST /FullProgramme/{1}/update
  def update
    @fullprogramme = FullProgramme.find(@params['id'])
    @fullprogramme.update_attributes(@params['fullprogramme']) if @fullprogramme
    redirect :action => :index
  end

  # POST /FullProgramme/{1}/delete
  def delete
    @fullprogramme = FullProgramme.find(@params['id'])
    @fullprogramme.destroy if @fullprogramme
    redirect :action => :index  
  end
end
