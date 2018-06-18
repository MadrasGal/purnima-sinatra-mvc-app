require 'rack-flash'

#Dogs Controller 

class DogsController < ApplicationController
  use Rack::Flash

  # Display details of all dogs in db
  get '/dogs' do
    @dog= Dog.all 
    erb :'dogs/dogs'
  end 

  # Create Dog / Add new dog to db
  get "/dogs/new" do 
    if session[:user_id]   
      erb :'dogs/create_dog'
    else 
      redirect "/dogs"
    end 
  end 

  post '/dogs' do
    if session[:user_id]
      if params[:dog_name] != ""   
        @dog = Dog.create(dog_name: params[:dog_name], age: params[:age], breed: params[:breed], adoption_status: params[:adoption_status])
        @user=User.find_by(:id => params[:id])
        @dog.user_id = session[:user_id]
        @dog.save
        flash[:message] = "Success. Added dog to database." 
        redirect '/dogs'
      else
        flash[:message] = "Error. Try again." 
        redirect '/dogs/new'
      end     
    else
      redirect '/login'
    end
  end
  
  # Edit/Update dog details / check for user id match 

  get '/dogs/:id/edit' do
    if session[:user_id]
      @dog= Dog.find_by(:id => params[:id])
      @user=User.find_by(:id => params[:id])
         
      erb :'/dogs/edit_dog'
    else
      redirect "/login"
    end
  end

  patch '/dogs/:id' do
    if session[:user_id]    
      @dog= Dog.find_by(:id => params[:id])
      
      if params[:dog_name] != ""  
        @dog.update(dog_name: params[:dog_name])
      end 

      if params[:age] != ""  
        @dog.update(age: params[:age])
      end 

      if params[:breed] != ""  
        @dog.update(breed: params[:breed])
      end 

      if params[:adoption_status] != ""  
        @dog.update(adoption_status: params[:adoption_status])
      end      
        flash[:message] = "Error. The update did not go through. Try again."
        redirect "/dogs/#{@dog.id}"
    
    else
      redirect '/login'
    end
  end

  #Delete dog route 

  delete '/dogs/:id/delete' do
   
    if session[:user_id]
      
      if Dog.find(params[:id])
        @dog = Dog.find(params[:id])
        @user=User.find_by(:id => session[:user_id])
        
        if @dog.user_id == @user.id
            @dog.delete
            flash[:message] = "Delete successful!"
            redirect '/dogs'
        else 
          flash[:message] = "Error. The user id does not match. Try again."
          redirect "/dogs"
        end 
        
      end
    
    else
      redirect '/login'
    end
  end  

  # Find dog by id 

  get '/dogs/:id' do 
    if session[:user_id]
     @dog= Dog.find_by(:id => params[:id])
      @user=User.find_by(:id => session[:user_id])
      erb :'/dogs/show_dog'
    else
      redirect "/login"
    end
  end

end 