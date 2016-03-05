class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #part 1: make the Title and Release Date clickable and sortable
    @movies = Movie.all
    @movies = Movie.order(params[:sort])
    @column = params[:sort]

    #part 2: make the checkboxes appear with corresponding ratings
    if params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort])
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings]
    if !@selected_ratings
      @selected_ratings = Hash.new
    end

    #part 3: remember the settings
    @redirect = 0
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @redirect = 1
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @redirect = 1
    end
    
    if @redirect == 1
      flash.keep
      redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
