package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.model.Brand;
import vn.edu.nlu.fit.datxedulich.services.BrandService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListBrandProductController", value = "/brand")
public class ListBrandController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BrandService bs = new BrandService();
        String country = request.getParameter("country");
        List<Brand> listBrand = (country != null && !country.isBlank()) ? bs.filterBrands(country) : bs.getListBrand();

        request.setAttribute("listBrand", listBrand);
        request.setAttribute("countries", bs.getDistinctCountries());
        request.setAttribute("selectedCountry", country);

        request.getRequestDispatcher("/WEB-INF/views/cars-brand.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}