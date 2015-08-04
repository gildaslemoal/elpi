package org.ofbiz.frontend;

import javolution.context.LocalContext;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.Map;

public class FrontendEvents {
    public static final String module = FrontendEvents.class.getName();
    public static final String resource_error = "FrontendErrorUiLabels";

    /**
     * Complete assignment event
     */
    public static String setDefaultRoof(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();

        Map<String, Object> parameterMap = UtilHttp.getParameterMap(request);
        String customerDefaultRoof = (String) parameterMap.get("customerDefaultRoof");
        if(UtilValidate.isEmpty(customerDefaultRoof)) {
            customerDefaultRoof = (String) session.getAttribute("defaultRoof");
        }

        if(UtilValidate.isEmpty(customerDefaultRoof)) {
            customerDefaultRoof = (String) session.getAttribute("defaultRoof");
        }

        if(UtilValidate.isEmpty(customerDefaultRoof)) {
            customerDefaultRoof = (String) session.getAttribute("defaultRoof");
        }
        if(UtilValidate.isNotEmpty(customerDefaultRoof)) {
            Cookie defaultRoofCookie = new Cookie("DEFAULT_ROOF", customerDefaultRoof);
            defaultRoofCookie.setMaxAge(60 * 60 * 24 * 365);
            defaultRoofCookie.setPath("/");
            response.addCookie(defaultRoofCookie);

            session.setAttribute("defaultRoof", customerDefaultRoof);
        }
        return "success";
    }

    public static String loadDefaultRoof(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        GenericValue userLogin = (GenericValue) session.getAttribute("userLogin");

        String defaultRoof = "";

        if (UtilValidate.isEmpty(userLogin)) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    if (cookies[i].getName().equals("DEFAULT_ROOF")) {
                        defaultRoof = cookies[i].getValue();
                        break;
                    }
                }
            }
        } else {
            LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
            DispatchContext dctx = dispatcher.getDispatchContext();
            Map<String, Object> context = UtilHttp.getParameterMap(request);

            Map<String, Object> getUserDefaultRoof = null;
            try {
                getUserDefaultRoof = dctx.makeValidContext("getUserDefaultRoof", "IN", context);

                if (!userLogin.isEmpty()) {
                    if (!userLogin.equals("")) {
                        getUserDefaultRoof.put("USER_LOGIN", userLogin.get("userLoginId"));
                    }
                }

                Map<String, Object> result = dctx.getDispatcher().runSync("getUserDefaultRoof", getUserDefaultRoof);
                String userDefaultRoof = (String) result.get("CUSTOMER_DEFAULT_ROOF");

                defaultRoof = userDefaultRoof;
                session.setAttribute("defaultRoof", defaultRoof);
                setDefaultRoof(request, response);

            } catch (GenericServiceException e) {
                e.printStackTrace();
            }
        }
        session.setAttribute("defaultRoof", defaultRoof);

        return "success" ;
    }
}