class BooksNotifierMailer < ApplicationMailer

  def confirmation(reservation)
    @reservation = reservation

    mail(to: reservation.user.email, subject: "Potwierdzenie")
  end
end
