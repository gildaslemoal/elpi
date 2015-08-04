/*******************************************************************************
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/
package org.ofbiz.webapp.event;

import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.wsdl.WSDLException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.om.util.StAXUtils;
import org.apache.axiom.soap.SOAPBody;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axiom.soap.impl.builder.StAXSOAPModelBuilder;
import org.apache.axiom.soap.impl.llom.soap11.SOAP11HeaderBlockImpl;
import org.apache.axis2.util.XMLUtils;
import org.apache.ws.security.WSUsernameTokenPrincipal;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilXml;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceAuthException;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.service.SoapService;
import org.ofbiz.webapp.control.ConfigXMLReader;
import org.ofbiz.webapp.control.ConfigXMLReader.Event;
import org.ofbiz.webapp.control.ConfigXMLReader.RequestMap;
import org.ofbiz.webapp.control.RequestHandler;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * SOAPEventHandler - SOAP Event Handler implementation
 */
public class SOAPEventHandlerNew implements EventHandler {

    public static String module = SOAPEventHandlerNew.class.getName();

    /**
     * @see org.ofbiz.webapp.event.EventHandler#init(javax.servlet.ServletContext)
     */
    public void init(ServletContext context) throws EventHandlerException {
    }

    /**
     * @see org.ofbiz.webapp.event.EventHandler#invoke(ConfigXMLReader.Event, ConfigXMLReader.RequestMap, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    public String invoke(Event event, RequestMap requestMap, HttpServletRequest request, HttpServletResponse response) throws EventHandlerException {
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        String locationURI = this.getLocationURI(request);
        OMFactory factory = OMAbstractFactory.getOMFactory();
        OMNamespace namespace = factory.createOMNamespace(ModelService.TNS, "tns");
        // first check for WSDL request
        String wsdlReq = request.getParameter("wsdl");
        if (wsdlReq == null) {
            wsdlReq = request.getParameter("WSDL");
        }
        if (wsdlReq != null) {
            String serviceName = RequestHandler.getOverrideViewUri(request.getPathInfo());
            DispatchContext dctx = dispatcher.getDispatchContext();
            String locationUri = this.getLocationURI(request);

            if (serviceName != null) {
                Document wsdl = null;
                try {
                    wsdl = dctx.generateWSDL(serviceName, locationUri);
                } catch (GenericServiceException e) {
                    serviceName = null;
                } catch (WSDLException e) {
                    sendError(response, "Unable to obtain WSDL", serviceName);
                    throw new EventHandlerException("Unable to obtain WSDL", e);
                }

                if (wsdl != null) {
                    try {
                        OutputStream os = response.getOutputStream();
                        response.setContentType("text/xml");
                        UtilXml.writeXmlDocument(os, wsdl);
                        response.flushBuffer();
                    } catch (IOException e) {
                        throw new EventHandlerException(e);
                    }
                    return null;
                } else {
                    sendError(response, "Unable to obtain WSDL", serviceName);
                    throw new EventHandlerException("Unable to obtain WSDL");
                }
            }

            else {
                try {
                    Writer writer = response.getWriter();
                    StringBuilder sb = new StringBuilder();
                    sb.append("<html><head><title>OFBiz SOAP/1.1 Services</title></head>");
                    sb.append("<body>No such service.").append("<p>Services:<ul>");

                    for (String scvName: dctx.getAllServiceNames()) {
                        ModelService model = dctx.getModelService(scvName);
                        if (model.export) {
                            sb.append("<li><a href=\"").append(locationUri).append("/").append(model.name).append("?wsdl\">");
                            sb.append(model.name).append("</a></li>");
                        }
                    }
                    sb.append("</ul></p></body></html>");

                    writer.write(sb.toString());
                    writer.flush();
                    return "success";
                } catch (Exception e) {
                    sendError(response, "Unable to obtain WSDL", null);
                    return "error";
                }
            }
        }

        // not a wsdl request; invoke the service
        response.setContentType("text/xml");

        // SOAP request envelope
        DispatchContext dispatchContext = dispatcher.getDispatchContext();
        SOAPEnvelope requestEnvelope = null;
        String aServiceName = "";
        try {
            XMLStreamReader xmlStreamReader = StAXUtils.createXMLStreamReader(request.getInputStream());
            StAXSOAPModelBuilder builder = new StAXSOAPModelBuilder(xmlStreamReader);
            builder.setNamespaceURIInterning(true);
            requestEnvelope = (SOAPEnvelope)builder.getDocumentElement();
            // log the request message
            if (Debug.infoOn()) {
                Debug.logInfo("SOAP Request Message:\n"
                              + requestEnvelope + "\n", module);
            }
            Element requestElement = XMLUtils.toDOM(requestEnvelope);
            Document requestDocument = XMLUtils.newDocument();
            requestDocument.appendChild(requestDocument.importNode(requestElement, true));
            Debug.logVerbose("[Processing]: SOAP Event", module);
            // each is a different service call
            SOAPBody requestBody = requestEnvelope.getBody();
            validateSOAPBody(requestBody);
            @SuppressWarnings("rawtypes")
            Iterator serviceItems = requestBody.getChildElements();
            while (serviceItems.hasNext()) {
                Object service = serviceItems.next();
                OMElement serviceElement = (OMElement)service;
                aServiceName = serviceElement.getLocalName();
                if (Debug.infoOn()) {
                    Debug.logInfo("SOAP => Service Element: " + serviceElement, module);
                }
                ModelService modelService = dispatchContext.getModelService(aServiceName);
                OMElement resultElements = null;
                SoapService soapService = new SoapService(modelService);
                // verify the service is exported for remote execution and invoke it
                if (modelService.export) {
                    Element element = XMLUtils.toDOM(serviceElement);
                    try {
                        soapService.validateWSDL(dispatchContext, locationURI, element);
                    }
                    catch(Exception e) {
                        sendError(response,"Request Parameters are not valide according to WSDL [" + e.getLocalizedMessage() + "]", aServiceName);
                        return "error";
                    }
                    //Map<String, Object> parameters = soapService.convertElementTreeToValueMap(dispatchContext, serviceElement, modelService.getContextInfo(), Boolean.TRUE);
                    Map<String, Object> parameters = soapService.buildParameters(dispatchContext, serviceElement, modelService.getContextInfo());
                    if (modelService.auth) {
                        if (parameters.containsKey("username")) {
                            parameters.put("login.username", parameters.remove("username"));
                            if (parameters.containsKey("password")) {
                                parameters.put("login.password", parameters.remove("password"));
                            }
                        }
                    }
                    if (Debug.infoOn()) {
                        Debug.logInfo("parameters=" + parameters, module);
                    }
                    Map<String, Object> results = dispatcher.runSync(aServiceName, parameters);
                    if (Debug.infoOn()) {
                        Debug.logInfo("results=" + results, module);
                    }
                    resultElements = SoapService.serializeParamsToXML(factory.createOMElement(aServiceName + "Response", namespace), results);
                    if (Debug.infoOn()) {
                        Debug.logInfo("resultElements=" + resultElements, module);
                    }
                    Element resultElement = XMLUtils.toDOM(resultElements);
                    try {
                        soapService.validateWSDL(dispatchContext, locationURI, resultElement);
                    }
                    catch(Exception e) {
                        sendError(response,"Response Parameters are not valide according to WSDL [" + e.getLocalizedMessage() + "]", aServiceName);
                        return "error";
                    }
                }
                else {
                    sendError(response,"Invalid WebService, or Service not available for external use", aServiceName);
                    return "error";
                }
                //create and write out the response
                return sendSOAPResponse(response, resultElements);
            }
        } catch (Exception ex) {
            if (Debug.errorOn()) {
                Debug.logError(ex, ex.toString(), module);
            }
            String message;
            if (aServiceName != null
                && ex instanceof ServiceAuthException) {
                message = "User authorization is required for this service: " + aServiceName;
            } else {
                message = ex.getMessage();
            }
            sendError(response, "Error invkoing soap service " + message, aServiceName);
        }
        return "error";
    }
    public static String sendSOAPResponse(HttpServletResponse response, OMElement resultElements) {
        
        try {
            SOAPFactory soapFactory = OMAbstractFactory.getSOAP11Factory();
            SOAPEnvelope responseEnvelope = soapFactory.createSOAPEnvelope();
            SOAPBody responseBody = soapFactory.createSOAPBody();
            responseBody.addChild(resultElements);
            responseEnvelope.addChild(responseBody);
            // log the response message
            if (Debug.infoOn()) {
                Debug.logInfo("SOAP Response Message:\n" + responseEnvelope + "\n", module);
            }
            response.setContentType(SoapService.XML_TYPE);
            OutputStream out = response.getOutputStream();
            responseEnvelope.serialize(out);
            out.flush();
        }
        catch (Exception ex) {
            Debug.logError("Error invoking soap service " + ex.getMessage(), module);
            return "error";
        }
        return "success";
    }
    @SuppressWarnings("rawtypes")
    public Map<String, String> getAuthInfo(Iterator it) {
        Map<String, String> result = new HashMap<String, String>();
        if (it != null) {
            SOAP11HeaderBlockImpl hb = (SOAP11HeaderBlockImpl) it.next();
            //hb.getLocalName()
            //Element ele = (Element) it.next();
            while(hb != null) {
                if ("Security".equals(hb.getLocalName())) {
                   OMElement om =  hb.cloneOMElement();
                   if(om != null) {
                       Iterator childs = om.getChildrenWithLocalName("UsernameToken");
                        if (childs != null) {
                            OMElement unt = (OMElement) childs.next();
                            if(unt != null) {
                                Iterator untChilds = unt.getChildElements();
                                if (untChilds != null) {
                                    OMElement chld = (OMElement) untChilds.next();
                                     while(chld != null) {
                                         if ("Username".equals(chld.getLocalName())) {
                                             result.put("username", chld.getText());
                                         }
                                         if ("Password".equals(chld.getLocalName())) {
                                             result.put("password", chld.getText());
                                         }
                                         chld = (OMElement) untChilds.next();
                                     }
                                }
                            }
                        }
                   }
                }
                hb = (SOAP11HeaderBlockImpl) it.next();
            }
        }
        return result;
    }
    private void validateSOAPBody(SOAPBody reqBody) throws EventHandlerException {
        // ensure the SOAPBody contains only one service call request
        Integer numServiceCallRequests = 0;
        Iterator<Object> serviceIter = UtilGenerics.cast(reqBody.getChildElements());
        while (serviceIter.hasNext()) {
            numServiceCallRequests++;
            serviceIter.next();
        }
        if (numServiceCallRequests != 1) {
            throw new EventHandlerException("One service call expected, but received: " + numServiceCallRequests.toString());
        }
    }
    public static class WebServiceCallbackHandler implements CallbackHandler {
    public String username, password;

    public void handle(Callback[] callbacks) {
        for (Callback callback : callbacks) {
            if (callback instanceof WSUsernameTokenPrincipal) {
                password = ((WSUsernameTokenPrincipal)callback).getPassword();
                username = ((WSUsernameTokenPrincipal)callback).getName();
            }
        }
    }

}

    private void sendError(HttpServletResponse res, String errorMessage, String serviceName) throws EventHandlerException {
        // setup the response
        sendError(res, ServiceUtil.returnError(errorMessage), serviceName);
    }

    private void sendError(HttpServletResponse res, Map<String, Object> object, String serviceName) throws EventHandlerException {
        try {
            // setup the response
            SOAPFactory factory = OMAbstractFactory.getSOAP11Factory();
            res.setContentType("text/xml");
            OMElement resultSer = SoapService.serializeParamsToXML(
                    factory.createOMElement(serviceName + "Response", 
                            factory.createOMNamespace(ModelService.TNS, "tns")), object);

            // create the response soap
            SOAPEnvelope resEnv = factory.createSOAPEnvelope();
            SOAPBody resBody = factory.createSOAPBody();
            resBody.addChild(resultSer);
            resEnv.addChild(resBody);

            // log the response message
            if (Debug.verboseOn()) {
                try {
                    Debug.logInfo("Response Message:\n" + resEnv + "\n", module);
                } catch (Throwable t) {
                }
            }

            resEnv.serialize(res.getOutputStream());
            res.getOutputStream().flush();
        } catch (Exception e) {
            throw new EventHandlerException(e.getMessage(), e);
        }
    }

    private String getLocationURI(HttpServletRequest request) {
        StringBuilder uri = new StringBuilder();
        uri.append(request.getScheme());
        uri.append("://");
        uri.append(request.getServerName());
        if (request.getServerPort() != 80 && request.getServerPort() != 443) {
            uri.append(":");
            uri.append(request.getServerPort());
        }
        uri.append(request.getContextPath());
        uri.append(request.getServletPath());

        String reqInfo = RequestHandler.getRequestUri(request.getPathInfo());
        if (!reqInfo.startsWith("/")) {
            reqInfo = "/" + reqInfo;
        }

        uri.append(reqInfo);
        return uri.toString();
    }
}
