class GuestbookEntriesController < ApplicationController
  load_resource
  authorize_resource
  
  def index
    @guestbook_entries = GuestbookEntry.accessible_by(current_ability).order("created_at desc").page(params[:page]) 
  end

  def create 
    @guestbook_entry = GuestbookEntry.new(params[:guestbook_entry])
    if verify_recaptcha
      if @guestbook_entry.save
        flash.delete(:recaptcha_error)
        redirect_to guestbook_entries_path, :notice => "Successfully created guestbook entry."
      else
        render 'new'
      end
    else
      flash.now[:recaptcha_error] = "There was an error with the recaptcha code. Please re-enter the code."
      render 'new'
    end
  end

  def update
    if @guestbook_entry.update_attributes(params[:guestbook_entry])
      redirect_to guestbook_entries_path, :notice => "Successfully updated guestbook entry."
    else
      render 'edit'
    end
  end

  def destroy    
    @guestbook_entry.destroy
    redirect_to guestbook_entries_path, :notice => "Successfully destroyed guestbook entry."
  end
end