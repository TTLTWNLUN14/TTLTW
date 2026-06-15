package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.BookingDao;
import vn.edu.nlu.fit.datxedulich.model.Booking;

import java.util.List;

public class BookingService {
    private final BookingDao bookingDao = new BookingDao();

    public Booking getBookingById(int bookingId) {
        return bookingDao.getBookingById(bookingId);
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {
        return bookingDao.getBookingsByCustomerId(customerId);
    }

    public boolean createBooking(Booking booking) {
        return bookingDao.createBooking(booking);
    }

    public boolean updateBooking(Booking booking) {
        return bookingDao.updateBooking(booking);
    }

    public boolean deleteBooking(int bookingId) {
        return bookingDao.deleteBooking(bookingId);
    }

    public List<Booking> getAllBookings() {
        return bookingDao.getAllBookings();
    }

    public List<Booking> searchBookings(String keyword, String status,
                                        String dateFrom, String dateTo) {
        return bookingDao.searchBookings(keyword, status, dateFrom, dateTo);
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        return bookingDao.updateBookingStatus(bookingId, status);
    }

}