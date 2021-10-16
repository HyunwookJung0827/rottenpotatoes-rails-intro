class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false    
    order_by = params[:order_by]
    
    if order_by.nil?
      order_by = session[:order_by]
      redirect = ! order_by.nil?
    else
      session[:order_by] = order_by
    end
    
    @all_ratings = Movie.all_ratings
    @ratings_to_show = @all_ratings
    
    if not params[:ratings].nil?
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show
    elsif not session[:ratings].nil?
      @ratings_to_show = session[:ratings]      
      redirect = true
    end
    
    if order_by == "title"
      @title_header_class = 'hilite'
      @sort_order = { title: :asc }
      
    elsif order_by == "date"
      @date_header_class = 'hilite'
      @sort_order = { release_date: :asc }
    end
    
    if redirect
      ratings_hash = {}
      @ratings_to_show.each { |key| ratings_hash[key] = 1 }
      redirect_to order_by: order_by, ratings: ratings_hash
    else
      @movies = Movie.where(rating: @ratings_to_show).order(@sort_order)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
