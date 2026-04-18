package vn.edu.nlu.fit.datxedulich.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.nlu.fit.datxedulich.services.CarTypeService;
import vn.edu.nlu.fit.datxedulich.model.CarType;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", value = "/index")
public class HomeController extends HttpServlet {

    private final CarTypeService carTypeService = new CarTypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CarType> allCars = carTypeService.getListCarType();

            List<CarType> featuredCars = allCars.size() > 6 ? allCars.subList(0, 6) : allCars;
            request.setAttribute("featuredCars", featuredCars);

            HttpSession session = request.getSession(false);
            boolean isLoggedIn = false;
            String fullName = "";

            if (session != null) {
                Integer accountId = (Integer) session.getAttribute("account_id");
                String sessionFullName = (String) session.getAttribute("full_name");

                if (accountId != null) {
                    isLoggedIn = true;
                    fullName = sessionFullName != null ? sessionFullName : "User";
                }
            }

            request.setAttribute("isLoggedIn", isLoggedIn);
            request.setAttribute("fullName", fullName);

            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}