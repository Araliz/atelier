class BooksNotifierMailer < ApplicationMailer

  def confirmation(reservation)
    @reservation = reservation

    mail(to: reservation.user.email, subject: "Potwierdzenie")
  end

  def book_return_remind
    @reservation = reservation

    mail(to: reservation.user.email, subject: "Upływa termin zwrotu książki #{reservation.book.title}")
  end

end
