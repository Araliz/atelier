class BookReservationExpireWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find(book_id)
    BooksNotifierMailer.confirmation(reservation).deliver_now
  end
end
