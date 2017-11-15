class ReservationsController < ApplicationController
  before_action :load_user, only: [:users_reservations]

  def reserve
    ::ReservationHandler.new(current_user).reserve(book)
    redirect_to(book_path(book.id))
  end

  def take
    ::ReservationHandler.new(current_user).take(book)
    reservation = Reservation.where(user: current_user, book: @book).last
    # BooksNotifierMailer.confirmation(reservation).deliver_now
    redirect_to(book_path(book.id))
  end

  def give_back
    ::ReservationHandler.new(current_user).give_back(book)
    redirect_to(book_path(book.id))
  end

  def cancel
    ::ReservationHandler.new(current_user).cancel_reservation(book)
    redirect_to(book_path(book.id))
  end

  def users_reservations
  end

  private

  def book
    @book ||= Book.find(params[:book_id])
  end

  def load_user
    @user = User.find(params[:user_id])
  end
end
