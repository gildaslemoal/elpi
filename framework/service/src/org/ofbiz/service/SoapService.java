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
package org.ofbiz.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.factory.WSDLFactory;
import javax.xml.XMLConstants;
import javax.xml.namespace.QName;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import javolution.util.FastMap;
import javolution.util.FastSet;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMNamespace;
import org.ofbiz.base.util.ObjectType;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.model.ModelFieldTypeReader;
import org.ofbiz.service.ModelParam.ModelParamAttrList;
import org.ofbiz.service.ModelParam.ModelParamAttrMap;
import org.ofbiz.service.ModelParam.ModelParamAttrMapEntry;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.ibm.wsdl.extensions.schema.SchemaImpl;

/**
 * Web service model which uses wrapped Generic Service Model Class
 */
@SuppressWarnings("serial")
public class SoapService implements Serializable {
    public static String module = SoapService.class.getName();
    public static String SOAP = "http://schemas.xmlsoap.org/wsdl/soap/";
    public static String SOAPENV = "http://schemas.xmlsoap.org/soap/envelope/";
    public static String WSSE = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
    public static String XMLNS = "http://www.w3.org/2000/xmlns/";
    public static String XSI = "http://www.w3.org/2001/XMLSchema-instance";

    public static String XML_TYPE = "text/xml";
    public static String JSON_TYPE = "application/json";

    public static String DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS";
    public static String DATE_FORMAT = "yyyy-MM-dd";
    public static String TIME_FORMAT = "HH:mm:ss.SSS";
    public static String DATE_TIME_TZ_FORMAT = DATE_TIME_FORMAT + "Z";
    public static String DATE_TZ_FORMAT = DATE_FORMAT + "Z";
    public static String TIME_TZ_FORMAT = TIME_FORMAT + "Z";

    protected Document wsdl;
    protected Schema wsdlSchema;
    protected ModelService modelService;
    protected Map<String, SchemaData> schemaDataMap = new FastMap<String, SchemaData>();
    protected Map<String, byte[]> resources = new FastMap<String, byte[]>();
    protected Map<String, OMNamespace> namespaces = new FastMap<String, OMNamespace>();
    protected Map<String, String> namespacePrefixes = new FastMap<String, String>();
    protected String namespace;
    protected int namespacePrefixIndex = 0;

    class SchemaData {
        SchemaImpl schemaImpl = null;
        Set<String> typeNames = new FastSet<String>();
    }

    /**
     * Web service model representing specific service.
     * @param modelService wrapped model service of specific service
     */
    public SoapService(ModelService modelService) {
        this.modelService = modelService;
        if (UtilValidate.isNotEmpty(modelService.getNameSpace())) {
            namespace = modelService.getNameSpace();
        } else {
            namespace = ModelService.TNS;
        }
    }

    /**
     * Obtains XML-schema type for model parameter.
     * @param modelParam model parameter whose XML-schema type is required
     * @return XML-schema type name without namespace prefix
     * @throws WSDLException if no corresponding XML-schema type exists
     */
    protected String typeToSchemaType(String type, String name) throws WSDLException {
        Class<?> infoClass = ObjectType.loadInfoClass(type, null);
        if (ObjectType.instanceOf(infoClass, java.lang.Character.class)) {
            return "character";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.String.class)) {
            return "string";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Byte.class)) {
            return "byte";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Boolean.class)) {
            return "boolean";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Integer.class)) {
            return "int";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Short.class)) {
            return "short";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Long.class)) {
            return "long";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Double.class)) {
            return "double";
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Float.class)) {
            return "float";
        }
        if (ObjectType.instanceOf(infoClass, java.math.BigDecimal.class)) {
            return "decimal";
        }
        if (ObjectType.instanceOf(infoClass, java.math.BigInteger.class)) {
            return "integer";
        }
        if (ObjectType.instanceOf(infoClass, java.sql.Date.class)) {
            return "date";
        }
        if (ObjectType.instanceOf(infoClass, java.sql.Time.class)) {
            return "time";
        }
        if (ObjectType.instanceOf(infoClass, java.sql.Timestamp.class)
            || ObjectType.instanceOf(infoClass, java.util.Date.class)) {
            return "dateTime";
        }
        throw new WSDLException(WSDLException.OTHER_ERROR, "Service cannot be described with WSDL (name=" + name + ", type=" + type + ")");
    }

    public Object stringToTypedValue(String type, String value, String name) throws WSDLException {
        Class<?> infoClass = ObjectType.loadInfoClass(type, null);
        if (ObjectType.instanceOf(infoClass, java.lang.Character.class)) {
            return Character.valueOf(value.charAt(0));
        }
        if (ObjectType.instanceOf(infoClass, java.lang.String.class)) {
            return value;
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Byte.class)) {
            return Byte.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Boolean.class)) {
            if ("true".equalsIgnoreCase(value)) {
                return Boolean.TRUE;
            }
            if ("false".equalsIgnoreCase(value)) {
                return Boolean.FALSE;
            }
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Integer.class)) {
            return Integer.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Short.class)) {
            return Short.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Long.class)) {
            return Long.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Double.class)) {
            return Double.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.lang.Float.class)) {
            return Float.valueOf(value);
        }
        if (ObjectType.instanceOf(infoClass, java.math.BigDecimal.class)) {
            return new BigDecimal(value);
        }
        if (ObjectType.instanceOf(infoClass, java.math.BigInteger.class)) {
            return new BigInteger(value);
        }
        try {
            if (ObjectType.instanceOf(infoClass, java.sql.Date.class)) {
                Calendar calendar = parseXmlDate(value);
                calendar.set(Calendar.HOUR_OF_DAY, 0);
                calendar.set(Calendar.MINUTE, 0);
                calendar.set(Calendar.SECOND, 0);
                calendar.set(Calendar.MILLISECOND, 0);
                return new java.sql.Date(calendar.getTime().getTime());
            }
            if (ObjectType.instanceOf(infoClass, java.sql.Time.class)) {
                Calendar calendar = parseXmlTime(value);
                calendar.set(Calendar.YEAR, 0);
                calendar.set(Calendar.MONTH, 0);
                calendar.set(Calendar.DAY_OF_MONTH, 0);
                return new java.sql.Time(calendar.getTime().getTime());
            }
            if (ObjectType.instanceOf(infoClass, java.sql.Timestamp.class)
                || ObjectType.instanceOf(infoClass, java.util.Date.class)) {
                return new java.sql.Timestamp(parseXmlDateTime(value).getTime().getTime());
            }
        } catch (ParseException ex) {
            throw new WSDLException(WSDLException.OTHER_ERROR, "Date value cannot be converted to typed date value (name=" + name + ", type=" + type + ", value=" + value + ")");
        }
        throw new WSDLException(WSDLException.OTHER_ERROR, "String value cannot be converted to typed value (name=" + name + ", type=" + type + ", value=" + value + ")");
    }

    public String typedValueToString(String type, Object value, String name) throws WSDLException {
        if ( UtilValidate.isEmpty(value)) {
            return null;
        }
        if (ObjectType.instanceOf(java.lang.Character.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.String.class, type)) {
            return (String)value;
        }
        if (ObjectType.instanceOf(java.lang.Byte.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Boolean.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Integer.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Short.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Long.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Double.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.lang.Float.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.math.BigDecimal.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.math.BigInteger.class, type)) {
            return String.valueOf(value);
        }
        if (ObjectType.instanceOf(java.sql.Date.class, type)) {
            return formatXmlDate((Date)value, true);
        }
        if (ObjectType.instanceOf(java.sql.Time.class, type)) {
            return formatXmlTime((Date)value, true);
        }
        if (ObjectType.instanceOf(java.sql.Timestamp.class, type)
            || ObjectType.instanceOf(java.util.Date.class, type)) {
            return formatXmlDateTime((Date)value, true);
        }

        if (ModelService.ERROR_MESSAGE.equals(name)
                || ModelService.ERROR_MESSAGE_LIST.equals(name)
                || ModelService.ERROR_MESSAGE_MAP.equals(name)
                || ModelService.SUCCESS_MESSAGE_LIST.equals(name)
                || ModelService.SUCCESS_MESSAGE.equals(name)) {
            return value.toString();
        }
        throw new WSDLException(WSDLException.OTHER_ERROR, "Typed value cannot be converted to string value (parameter=" + name + ", type=" + type + ", value=" + value + ")");
    }
    /**
     * Generates WSDL-document from this web service model
     * @param dispatchContext dispatch context where nested service models
     *        can be found
     * @param locationURI SOAP location URI
     * @return WSDL-document object model
     * @throws GenericServiceException if exception encountered when
     *         getting nested service model
     * @throws SAXException if XML-schema could not be parsed
     * @throws WSDLException if XML-schema type could not be found
     */
    public Document toWSDL(DispatchContext dispatchContext, String locationURI)  throws GenericServiceException, ParserConfigurationException,
               SAXException, TransformerException, WSDLException {
        if (this.wsdl != null) {
            return this.wsdl;
        }
        WSDLFactory factory = WSDLFactory.newInstance();
        Definition definition = factory.newDefinition();
        definition.setTargetNamespace(namespace);
        definition.addNamespace("tns", namespace);
        definition.addNamespace("xsd", ModelService.XSD);
        definition.addNamespace("soap", SOAP);
        definition.addNamespace("wsse", WSSE);
        
        this.wsdl = modelService.generateWSDL(dispatchContext.getDelegator(), locationURI);
        SchemaImpl schemaImpl = makeSchemaImpl(wsdl, namespace);
        
        Element schema = schemaImpl.getElement();
        wsdlSchema = makeValidationSchema(schema);
        return this.wsdl;
    }

    public void validateWSDL(DispatchContext dispatchContext, String locationURI, Node node) throws IOException, GenericServiceException,
               ParserConfigurationException, SAXException,
               TransformerException, WSDLException {
        if (this.wsdlSchema == null) {
            toWSDL(dispatchContext, locationURI);
        }
        validate(this.wsdlSchema, node);
    }

    public void validate(Schema schema, Node node) throws IOException, SAXException {
        Validator validator = schema.newValidator();
        validator.validate(new DOMSource(node));
    }

    protected byte[] toBytes(Element element, boolean indent)
        throws TransformerException {
        DOMSource domSource = new DOMSource(element);
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        StreamResult streamResult = new StreamResult(bout);
        Transformer transformer
            = TransformerFactory.newInstance().newTransformer();
        if (indent) {
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        }
        transformer.transform(domSource, streamResult);
        return bout.toByteArray();
    }

    protected SchemaImpl makeSchemaImpl(Document document, String targetNamespace) {
        SchemaImpl schemaImpl = new SchemaImpl();
        Element schema = null;
        NodeList schemaNodes =  document.getElementsByTagName("xsd:schema");
        if(schemaNodes != null && schemaNodes.getLength() > 0) {
            schema = (Element) schemaNodes.item(0);
            schemaImpl.setElementType(new QName(ModelService.XSD, "schema"));
        }
        schemaImpl.setElement(schema);
        return schemaImpl;
    }

    protected Schema makeValidationSchema(Element schemaElement) throws SAXException {
        SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Schema schema = schemaFactory.newSchema(new DOMSource(schemaElement));
        return schema;
    }
    protected String convertFromXmlDateValue(String value, boolean hasFractionalSeconds, boolean[] useTimeZone) {
        int index,
            length = value.length();
        if (value.endsWith("Z")) {
            index = length - 1;
            useTimeZone[0] = true;
        } else {
            index = value.lastIndexOf('+');
            if (index == -1) {
                index = value.lastIndexOf('-');
                if (index != -1 && length - index != 5) {
                    index = -1;
                }
            }
            if (index != -1) {
                if (Character.isDigit(value.charAt(index + 1))) {
                    value = value.substring(0, index + 3)
                        + value.substring(index + 4);
                }
                useTimeZone[0] = true;
            } else {
                useTimeZone[0] = false;
            }
            if (index == -1) {
                index = length;
            }
        }
        int dot = value.indexOf('.');
        if (dot != -1) {
            String fractionalSeconds = value.substring(dot, index);
            long milliSeconds
                = (long)(Double.parseDouble(fractionalSeconds) * 1000.0 + .5);
            value = value.substring(0, dot + 1)
                + String.valueOf(milliSeconds) + value.substring(index);
        } else if (hasFractionalSeconds) {
            value = value.substring(0, index) + ".0";
            if (index < value.length()) {
                value += value.substring(index + 1);
            }
        }
        return value;
    }

    protected String convertToXmlDateValue(String value, boolean useTimeZone) {
        if (useTimeZone) {
            value = value.substring(0, value.length() - 2) + ":"
                + value.substring(value.length() - 2);
        }
        return value;
    }

    public Calendar parseXmlDateValue(String value, String format, String formatTZ, boolean hasFractionalSeconds) throws ParseException {
        boolean[] useTimeZone = new boolean[1];
        try {
            value = convertFromXmlDateValue(value, hasFractionalSeconds, useTimeZone);
        } catch (IndexOutOfBoundsException ex) {
            ex.printStackTrace();
            throw new ParseException(ex.toString() + ", value=" + value, 0);
        }
        if (useTimeZone[0]) {
            format = formatTZ;
        }
        DateFormat dateFormat = new SimpleDateFormat(format);
        dateFormat.parse(value);
        return dateFormat.getCalendar();
    }

    public Calendar parseXmlDateTime(String value) throws ParseException {
        return parseXmlDateValue(value, DATE_TIME_FORMAT, DATE_TIME_TZ_FORMAT, true);
    }

    public Calendar parseXmlDate(String value) throws ParseException {
        return parseXmlDateValue(value, DATE_FORMAT, DATE_TZ_FORMAT, false);
    }

    public Calendar parseXmlTime(String value) throws ParseException {
        return parseXmlDateValue(value, TIME_FORMAT, TIME_TZ_FORMAT, true);
    }

    public String formatXmlDateValue(Date date, String format, String formatTZ, boolean useTimeZone) {
        if (useTimeZone) {
            format = formatTZ;
        }
        DateFormat dateFormat = new SimpleDateFormat(format);
        return convertToXmlDateValue(dateFormat.format(date), useTimeZone);
    }

    public String formatXmlDateTime(Date date, boolean useTimeZone) {
        return formatXmlDateValue(date, DATE_TIME_FORMAT, DATE_TIME_TZ_FORMAT, useTimeZone);
    }

    public String formatXmlDate(Date date, boolean useTimeZone) {
        return formatXmlDateValue(date, DATE_FORMAT, DATE_TZ_FORMAT, useTimeZone);
    }

    public String formatXmlTime(Date date, boolean useTimeZone) {
        return formatXmlDateValue(date, TIME_FORMAT, TIME_TZ_FORMAT, useTimeZone);
    }

    @SuppressWarnings("rawtypes")
    protected boolean isList(Class clazz) {
        return ObjectType.instanceOf(clazz, java.util.List.class);
    }

    @SuppressWarnings("rawtypes")
    protected boolean isMap(Class clazz) {
        return ObjectType.instanceOf(clazz, java.util.Map.class);
    }

    protected OMElement convertSingleValueToElementTree(OMFactory factory, OMElement parent, 
            Object value, String name, String  type) throws WSDLException {
        if (UtilValidate.isEmpty(value)) {
            OMElement element = factory.createOMElement(name, null, parent);
            element.addAttribute("nil", "true", factory.createOMNamespace(XSI, "xsi"));
        }
        else {
            OMElement element = factory.createOMElement(name, null, parent);
            element.setText(typedValueToString(type, value, name));
        }
        return parent;
    }

    protected boolean skip(boolean error, ModelParam param, Object value) {
        boolean skip = true;
        if (param.isOut()) {
            if (error) {
                if (ModelService.RESPONSE_MESSAGE.equals(param.getName())) {
                    skip = false;
                }
            }
            else {
                skip = false;
            }
        }
        return skip;
    }

    public OMNamespace getNamespace(OMFactory factory,
                                    String namespace) {
        OMNamespace elementNamespace = namespaces.get(namespace);
        if (elementNamespace == null) {
            String namespacePrefix = "ns" + namespacePrefixIndex++;
            elementNamespace
                = factory.createOMNamespace(namespace, namespacePrefix);
            namespaces.put(namespace, elementNamespace);
        }
        return elementNamespace;
    }

    public String getNamespacePrefix(String namespace) {
        String namespacePrefix = namespacePrefixes.get(namespace);
        if (namespacePrefix == null) {
            namespacePrefix = "ns" + namespacePrefixIndex++;
            namespacePrefixes.put(namespace, namespacePrefix);
        }
        return namespacePrefix;
    }

    public List<OMElement> convertErrorsToXmlElement(OMFactory factory, Map<String, Object> results) {
        List<OMElement> elementTrees = new ArrayList<OMElement>();
        if (ServiceUtil.isError(results)) {
            OMElement element = factory.createOMElement(ModelService.ERROR_MESSAGE, null);
            element.setText(ServiceUtil.getErrorMessage(results));
            elementTrees.add(element);
        }
        return elementTrees;
    }
    public Map<String, Object> buildParameters(DispatchContext dctx, OMElement serviceElement,
                                               Map<String, ModelParam> modelParamMap) throws WSDLException {
        return buildParameters(dctx, serviceElement, modelParamMap, "IN");
    }
    public Map<String, Object> buildParameters(DispatchContext dctx, OMElement serviceElement,
                                               Map<String, ModelParam> modelParamMap, 
                                               String mode) throws WSDLException {
        Map<String, Object> parameters = new HashMap<>();
        if (serviceElement == null) return parameters;
        String serviceName = serviceElement.getLocalName();
        @SuppressWarnings("rawtypes")
        Iterator childElements = serviceElement.getChildElements();
        while (childElements.hasNext()) {
            OMElement param = (OMElement) childElements.next();
            String paramName = param.getLocalName();
            ModelParam modelParam = modelParamMap.get(paramName);
            //check if the element has a declared input parameter for this service
            if(UtilValidate.isEmpty(modelParam)) {
                if (!modelParamMap.containsKey(paramName) && !"username".equals(paramName) && !"password".equals(paramName)) {
                    throw new WSDLException(WSDLException.OTHER_ERROR, "Service attribute cannot be found (" + serviceName + "." + paramName + ")");
                }
            }
            if ( ! checkMode(modelParam, mode)) {
                throw new WSDLException(WSDLException.OTHER_ERROR, "parameter (" + serviceName + "." + paramName + ") was not declared as '" + mode + "' attribute");
            }
            String type = modelParam.getType();
            Class<?> modelParamClass = ObjectType.loadInfoClass(type, null);
            if (ObjectType.instanceOf(modelParamClass, java.util.List.class)) {
                //build parameter for a list
                ModelParamAttrList attrList = modelParam.getAttrList();
                if (attrList == null) {
                    throw new WSDLException(WSDLException.OTHER_ERROR, "parameter (" + serviceName + "." + paramName + ") declared to be a List but it doesn't define attributes and their types");
                }
                parameters.put(paramName, buildListParameter(dctx, serviceName, paramName, param, attrList));
            }
            else if (ObjectType.instanceOf(modelParamClass, java.util.Map.class)) {
                //build parameter for a Map
                ModelParamAttrMap attrMap = modelParam.getAttrMap();
                if (attrMap == null) {
                    throw new WSDLException(WSDLException.OTHER_ERROR, "parameter (" + serviceName + "." + paramName + ") declared to be a Map but it doesn't define attributes and their types");
                }
                parameters.put(paramName, buildMapParameter(dctx, serviceName, paramName, param, attrMap));
            }
            else {
                //build parameter for a simple type String, Double , Time, Datetime, ect...
                parameters.put(paramName, stringToTypedValue(modelParam.type, param.getText(), paramName));
            }
        }
        return parameters;
    }
    public static boolean checkMode(ModelParam modelParam, String mode) {
        if (modelParam.isIn() && modelParam.isOut()) 
            return true;
        if (modelParam.isIn()) 
            return "IN".equals(mode);
        else 
            return "OUT".equals(mode);
    }
    public List<Object> buildListParameter(DispatchContext dctx, String serviceName,
                                           String serviceParamName, OMElement listElement,
                                           ModelParamAttrList attrList) throws WSDLException {
        List<Object> result = new ArrayList<Object>();
        @SuppressWarnings("rawtypes")
        Iterator it = listElement.getChildElements();
        ModelParamAttrMap attrMap = attrList.getModelParamAttrMap();
        while (it.hasNext()) {
            OMElement entry = (OMElement) it.next();
            result.add(buildMapParameter(dctx, serviceName, serviceParamName, entry, attrMap));
        }
        return result;
    }
    public Map<String, Object> buildMapParameter(DispatchContext dctx, String serviceName, 
                                                 String serviceParamName, OMElement mapElement,
                                                 ModelParamAttrMap attrMap) throws WSDLException {
        Map<String, Object> result = new HashMap<String, Object>();
        @SuppressWarnings("rawtypes")
        Iterator it = mapElement.getChildElements();
        while (it.hasNext()) {
            OMElement mapEntry = (OMElement) it.next();
            String entryName = mapEntry.getLocalName();
            ModelParamAttrMapEntry typeEntry = attrMap.getEntry(entryName);
            if (UtilValidate.isEmpty(typeEntry)) {
                throw new WSDLException(WSDLException.OTHER_ERROR, "parameter (" + serviceName + "." + serviceParamName + ") is complexe and doesn't define and does not contains entry for " + entryName);
            }
            String type = typeEntry.type;
            try {
                ObjectType.loadInfoClass(typeEntry.type, null);
            }
            catch(Exception e) {
                ModelFieldTypeReader mftr = dctx.getDelegator().getModelFieldTypeReader(dctx.getDelegator().getModelEntity("Party"));
                try {
                    type = mftr.getModelFieldType(type).getJavaType();
                }
                catch(Exception ex) {
                    throw new WSDLException(WSDLException.OTHER_ERROR, "parameter (" + serviceName + "." + serviceParamName + ")  define an attributte " + entryName + " with unkown type " + type);
                }
            }
            result.put(entryName, stringToTypedValue(type, mapEntry.getText(), entryName));
        }
        return result;
    }

    public static OMElement serializeParamsToXML(OMElement element, Map<?, ?> params) throws IOException {
        Iterator<Map.Entry<?, ?>> iter = UtilGenerics.cast(params.entrySet()
                .iterator());
        while (iter.hasNext()) {
            Map.Entry<?, ?> entry = iter.next();
            serializeSingle(entry.getKey().toString(), entry.getValue(),
                    element);
        }
        return element;
    }
    public static void serializeSingle(String name, Object val, OMElement root)
            throws IOException {
        OMElement param = root.getOMFactory().createOMElement(name, null);
        if (UtilValidate.isEmpty(val)) {
            root.addChild(param);
        } else if (isSimpleType(val)) {
            param.setText(val.toString());
            root.addChild(param);
        } else if (val instanceof BigDecimal) {

            param.setText(((BigDecimal) val).setScale(10,
                    BigDecimal.ROUND_HALF_UP).toString());
            root.addChild(param);
        } else if (val instanceof Timestamp) {
            param.setText(UtilDateTime.timeStampToString(
                    ((Timestamp) val), SoapService.DATE_TIME_FORMAT, TimeZone.getDefault(),
                    Locale.getDefault()));
            root.addChild(param);
        } else if (val instanceof java.util.Date) {
            param.setText(new SimpleDateFormat(SoapService.DATE_FORMAT).format((java.util.Date) val));
            root.addChild(param);
        } else if (val instanceof Map) {
            root.addChild(param);
            Map<?, ?> params = (Map<?, ?>) val;
            Iterator<Map.Entry<?, ?>> iter = UtilGenerics.cast(params
                    .entrySet().iterator());
            while (iter.hasNext()) {
                Map.Entry<?, ?> entry = iter.next();
                if (UtilValidate.isNotEmpty(entry.getValue())) {
                    serializeSingle(entry.getKey().toString(), entry.getValue(), param);
                }
            }
            root.addChild(param);
        } else if (val instanceof List) {
            List<?> params = (List<?>) val;
            Iterator<?> iter = UtilGenerics.cast(params.iterator());
            while (iter.hasNext()) {
                Object entry = iter.next();
                serializeSingle(name + "-entry", entry, param);
            }
            root.addChild(param);
        }
    }

    public static boolean isSimpleType(Object obj) {
        if (obj == null)
            return true;
        return obj instanceof String || obj instanceof Integer
                || obj instanceof Long || obj instanceof Float
                || obj instanceof Double || obj instanceof Boolean
                || obj instanceof Locale ;
    }
}
