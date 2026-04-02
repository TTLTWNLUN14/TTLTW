package vn.edu.nlu.fit.datxedulich.services;

import vn.edu.nlu.fit.datxedulich.dao.VoucherDAO;
import vn.edu.nlu.fit.datxedulich.model.Voucher;

import java.util.List;

public class VoucherService {
    private final VoucherDAO voucherDAO = new VoucherDAO();

    public List<Voucher> getAllVouchers() {
        return voucherDAO.getAllVouchers();
    }

    public Voucher getVoucherById(int voucherId) {
        return voucherDAO.getVoucherById(voucherId);
    }

    public boolean addVoucher(Voucher voucher) {
        return voucherDAO.addVoucher(voucher);
    }

    public boolean updateVoucher(Voucher voucher) {
        return voucherDAO.updateVoucher(voucher);
    }

    public boolean deleteVoucher(int voucherId) {
        return voucherDAO.deleteVoucher(voucherId);
    }

    public List<Voucher> getAvailableVouchers(double orderPrice) {
        return voucherDAO.getActiveVouchers(orderPrice);
    }

    public boolean validateVoucher(int voucherId, double orderPrice) {
        return voucherDAO.validateVoucher(voucherId, orderPrice);
    }

    public boolean reduceVoucherUsage(int voucherId) {
        return voucherDAO.reduceVoucherUsage(voucherId);
    }

}
