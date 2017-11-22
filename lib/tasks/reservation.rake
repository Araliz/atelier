namespace :reservation do
  task expires: :environment do
    reservation = Reservation.where('DATE(expires_at) = ?', Date.tomorrow)
    reservation.each do |r|
      ::BookReservationExpireWorker.perform_at(r.expires_at-1.day, r.book_id)
    end
  end
end
