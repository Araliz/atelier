class ReservationHandler

  def initialize(user)
    @user = user
  end

  def take(book)
    return "Book is not available for reservation" unless book.can_be_taken?(user)

    if book.available_reservation.present?
      perform_expiration_worker(book.available_reservation)
      book.available_reservation.update_attributes(status: 'TAKEN')
    else
      perform_expiration_worker(book.reservations.create(user: user, status: 'TAKEN'))
    end
  end

  def give_back(book)
    ActiveRecord::Base.transaction do
      book.reservations.find_by(status: 'TAKEN').update_attributes(status: 'RETURNED')
      book.next_in_queue.update_attributes(status: 'AVAILABLE') if book.next_in_queue.present?
    end
  end

  def reserve(book)
    return unless book.can_reserve?(user)

    book.reservations.create(user: user, status: 'RESERVED')
  end

  def cancel_reservation(book)
    book.reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end

  private

  def perform_expiration_worker(res)
    ::BookReservationExpireWorker.perform_at(res.expires_at-1.day, res.book_id)
  end
  attr_reader :user

  # def next_in_queue(book)
  #   book.reservations.where(status: 'RESERVED').order(created_at: :asc).first
  # end


  # def can_be_taken?(book)
  #   not_taken?(book) && ( book.available_for_user?(user) || book.reservations.empty? )
  # end
  #
  # def not_taken?(book)
  #   book.reservations.find_by(status: 'TAKEN').nil?
  # end


end
