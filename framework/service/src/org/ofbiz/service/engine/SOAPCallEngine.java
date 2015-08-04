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
package org.ofbiz.service.engine;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.xml.namespace.QName;


import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axis2.AxisFault;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelParam;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceDispatcher;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.service.SoapService;

/**
 * Generic Service SOAP Interface
 */
public final class SOAPCallEngine extends GenericAsyncEngine {

    public static final String module = SOAPCallEngine.class.getName();
    public static final String TNS_PREFIX = "ser";

    public class PeerConf {
        private String peerName;
        private Map<String, String> conf;

        public PeerConf(String peerName) {
            this.peerName = peerName;
            if (!confs.containsKey(peerName)) {
                confs.put(peerName,
                        getconMap(UtilProperties.getProperties(peerName)));
            }
            this.conf = getPeerConf(peerName);
        }

        private Map<String, Map<String, String>> confs = new HashMap<String, Map<String, String>>();

        public Map<String, String> getPeerConf(String peerName) {
            if (!confs.containsKey(peerName)) {
                confs.put(peerName,
                        getconMap(UtilProperties.getProperties(peerName)));
            }
            return confs.get(peerName);
        }

        private Map<String, String> getconMap(Properties props) {
            if (props == null)
                return null;
            Map<String, String> map = new HashMap<String, String>();
            for (Object key : props.keySet()) {
                map.put(key.toString(), props.getProperty(key.toString())
                        .toString());
            }
            return map;
        }

        private String getParam(String peerName, String paramName) {
            Map<String, String> conf = getPeerConf(peerName);
            if (UtilValidate.isNotEmpty(conf)) {
                return conf.get(paramName);
            }
            return null;
        }

        public boolean isValidPeer() {
            return (this.conf != null);
        }

        public String getUserName() {
            return getParam(this.peerName, "username");
        }

        public String getPassword() {
            return getParam(this.peerName, "password");
        }

        public String getHost() {
            return getParam(this.peerName, "host");
        }

        public int getPort() {
            return Integer.valueOf(getParam(this.peerName, "port")).intValue();
        }

        public String getTimeout() {
            return getParam(this.peerName, "default-timeout");
        }

        public boolean isHttps() {
            return !"Y".equalsIgnoreCase(getParam(this.peerName,
                    "disable-https"));
        }

        public boolean trustPeer() {
            return "Y".equalsIgnoreCase(getParam(this.peerName, "trust-certs"));
        }

        public boolean isActive() {
            return "Y".equalsIgnoreCase(getParam(this.peerName, "active"));
        }
    }

    public SOAPCallEngine(ServiceDispatcher dispatcher) {
        super(dispatcher);
    }

    /**
     * @see org.ofbiz.service.engine.GenericEngine#runSyncIgnore(java.lang.String,
     *      org.ofbiz.service.ModelService, java.util.Map)
     */
    @Override
    public void runSyncIgnore(String localName, ModelService modelService,
            Map<String, Object> context) throws GenericServiceException {
        runSync(localName, modelService, context);
    }

    /**
     * @see org.ofbiz.service.engine.GenericEngine#runSync(java.lang.String,
     *      org.ofbiz.service.ModelService, java.util.Map)
     */
    @Override
    public Map<String, Object> runSync(String localName,
            ModelService modelService, Map<String, Object> context)
            throws GenericServiceException {
        Map<String, Object> result = serviceInvoker(localName, modelService,
                context);

        if (result == null)
            throw new GenericServiceException(
                    "Service did not return expected result");
        return result;
    }

    // Invoke the remote SOAP service
    private Map<String, Object> serviceInvoker(String localName,
            ModelService modelService, Map<String, Object> context)
            throws GenericServiceException {
        if (modelService.location == null || modelService.invoke == null)
            throw new GenericServiceException("Cannot locate service to invoke");

        PeerConf conf = new PeerConf(modelService.location);
        if (!conf.isValidPeer()) {
            throw new GenericServiceException(
                    "Cannot get required configuration to invoke service "
                            + modelService.name);
        }
        String PEER_HOST = conf.getHost();
        boolean PEER_HTPPS = conf.isHttps();
        int PEER_PORT = conf.getPort();
        String PEER_USERNAME = conf.getUserName();
        String PEER_PASSWORD = conf.getPassword();
        ServiceClient client = null;
        QName serviceName = null;
        String PORT_STRING = "";
        if ((PEER_HTPPS && PEER_PORT != 443) || !PEER_HTPPS && PEER_PORT != 80) {
            PORT_STRING = ":" + PEER_PORT;
        }
        String location = "http" + ((PEER_HTPPS) ? "s" : "") + "://"
                + PEER_HOST + PORT_STRING + "/webtools/control/SOAPServiceNew";
        try {
            client = new ServiceClient();
            Options options = new Options();
            EndpointReference endPoint = new EndpointReference(location);
            options.setTo(endPoint);
            client.setOptions(options);

        } catch (AxisFault e) {
            throw new GenericServiceException("RPC service error", e);
        }

        List<ModelParam> inModelParamList = modelService.getInModelParamList();

        if (Debug.verboseOn())
            Debug.logVerbose("[" + module + ".invoke] : Parameter length - "
                    + inModelParamList.size(), module);

        if (UtilValidate.isNotEmpty(modelService.nameSpace)) {
            serviceName = new QName(modelService.nameSpace, modelService.invoke);
        } else {
            serviceName = new QName(ModelService.TNS, modelService.invoke,
                    TNS_PREFIX);
        }

        int i = 0;

        Map<String, Object> parameterMap = new HashMap<String, Object>();
        for (ModelParam p : inModelParamList) {
            if (Debug.verboseOn())
                Debug.logVerbose("[" + module + ".invoke} : Parameter: " + p.name
                        + " (" + p.mode + ") - " + i, module);
            Object val = context.get(p.name);
            // exclude params that ModelServiceReader insert into (internal
            // params)
            if (UtilValidate.isNotEmpty(val) && !p.internal) {
                parameterMap.put(p.name, context.get(p.name));
            }
            i++;
        }

        parameterMap.put("login.username", PEER_USERNAME);
        parameterMap.put("login.password", PEER_PASSWORD);

        OMElement parameterSer = null;
        OMFactory factory = OMAbstractFactory.getOMFactory();

        try {
            parameterSer = SoapService.serializeParamsToXML(factory.createOMElement("params", null), parameterMap);
        } catch (Exception e) {
            Debug.logError(e, module);
            return ServiceUtil.returnError(e.getMessage());
        }

        Map<String, Object> results = null;
        try {
            factory.createOMNamespace(ModelService.TNS, TNS_PREFIX);

            OMElement payload = factory.createOMElement(serviceName);
            Iterator<?> childs = parameterSer.getChildElements();
            while (childs.hasNext()) {
                OMElement child = (OMElement) childs.next();
                payload.addChild(child);
            }
            OMElement respOMElement = client.sendReceive(payload);
            client.cleanupTransport();
            results = (new SoapService(modelService))
                    .buildParameters(
                            dispatcher.getLocalContext(localName), respOMElement, modelService.getContextInfo(), "OUT");
        }
        catch( AxisFault af ) {
            return ServiceUtil.returnError(af.getMessage());
        }
        catch (Exception e) {
            Debug.logError(e, module);
            results = ServiceUtil.returnError(e.getLocalizedMessage());
        }
        return results;
    }
}