package org.ofbiz.backend;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.base.util.UtilXml;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javolution.util.FastMap;

/**
 * BackendUtils.java
 */

public class BackendUtils {

    public static final String module = BackendUtils.class.getName();
    public static final boolean INTERFACE_BACK_ENABLED = "Y".equalsIgnoreCase(UtilProperties.getPropertyValue("interface-back", "active", "N"));
    public static final boolean INTERFACE_BACK_SCHUDLE = "Y".equalsIgnoreCase(UtilProperties.getPropertyValue("interface-back", "schedule", "N"));
    public static final Long INTERFACE_BACK_SCHUDLE_START = UtilProperties.getPropertyAsLong("interface-back", "schedule-start-hour", Long.valueOf(1));
    public static final Long INTERFACE_BACK_SCHUDLE_END = UtilProperties.getPropertyAsLong("interface-back", "schedule-start-hour", Long.valueOf(6));
    public static final String OUT_LOG = "OUT_LOG";
    public static final String IN_LOG = "IN_LOG";
    /** exporterLogger
     * write a log entry in ofbiz records about back exchange operations
     * @param dctx
     * @param context
     * @return good or bad status
     */
    public static boolean logService(DispatchContext dctx, String mode, String logRequest, String logResult, String entityPK) {
        //GenericServiceException toThrow = null;
        Map<String, Object> logCtx = FastMap.newInstance();
        logCtx.put("interfaceId", "BACK_OFFICE");
        logCtx.put("interfaceLogDate", UtilDateTime.nowTimestamp());
        if (null == entityPK) logCtx.put("underlyingEntityPK", " -- none -- "); else logCtx.put("underlyingEntityPK", entityPK);
        if (null == logRequest) logCtx.put("interfaceLogReq", " -- none -- "); else logCtx.put("interfaceLogReq", logRequest);
        if (null == logResult) logCtx.put("interfaceLogRes", " -- none -- "); else logCtx.put("interfaceLogRes", logResult);
        if (mode.equalsIgnoreCase("OUT_LOG")) logCtx.put("mode", "OUT_LOG"); else logCtx.put("mode", "IN_LOG"); 
        try {
            dctx.getDispatcher().runSync("createInterfaceLog", dctx.makeValidContext("createInterfaceLog", "IN", logCtx));
        }
        catch (GenericServiceException gsE) {
            Debug.logError("- BackendUtils.logService : failed creating interface log for request : " + logRequest, module);
            return false;
        }
        return true;
    }
    public static boolean logService(DispatchContext dctx, String mode, String logRequest, String logResult) {
        return logService(dctx, mode, logRequest, logResult, "");
    }

    /** exporterServiceToBack
     * generic service exporting data to the back-office
     * @param dctx
     * @param context
     * @return standard service return Map
     */
    public static Map<String, Object> exportService(DispatchContext dctx, Map<String, Object> execParams) {
        // Interface activated ?
        if (!INTERFACE_BACK_ENABLED) {
            Debug.logInfo("--- aborting webService ["+ execParams.get("webService") +"]", module);
            return ServiceUtil.returnSuccess();
        }
        try {
            String ws = (String)execParams.remove("webService");
            Map<String, Object> callCtx = dctx.makeValidContext(ws, "IN", execParams);
            Map<String, Object> results = null;
            
            if(INTERFACE_BACK_SCHUDLE) {
                Timestamp startTime = UtilDateTime.adjustTimestamp(UtilDateTime.getDayStart(
                        UtilDateTime.addDaysToTimestamp(UtilDateTime.nowTimestamp(), 1)
                        ), Calendar.HOUR, INTERFACE_BACK_SCHUDLE_START.intValue()) ;

                Timestamp endTime = UtilDateTime.adjustTimestamp(UtilDateTime.getDayStart(
                        UtilDateTime.addDaysToTimestamp(UtilDateTime.nowTimestamp(), 1)
                        ), Calendar.HOUR, INTERFACE_BACK_SCHUDLE_END.intValue()) ;
                dctx.getDispatcher().schedule(null, null, ws, startTime.getTime(), -1, 0, -1, endTime.getTime(), -1, callCtx);
                results = ServiceUtil.returnSuccess("service planned for later excution");
            } 
            else {
                results = dctx.getDispatcher().runSync(ws, callCtx);
            }
            logService(dctx, OUT_LOG, serializeParams(execParams), serializeParams(results));
            return ServiceUtil.returnSuccess();
        }
        catch(Exception gsE) {
            String msg = "Error calling back service ["+ execParams.get("webService") +"] due to : " + gsE;
            Debug.logError(msg, module);
            try {
                logService(dctx, OUT_LOG, serializeParams(execParams), serializeParams(UtilMisc.toMap(ModelService.ERROR_MESSAGE, msg)));
            }
            catch(Exception e) {
                //ignore it
            }
            return ServiceUtil.returnError("Error calling back service ["+ execParams.get("webService") +"] due to : " + gsE);
        }
    }
    public static Map<String, Object> createInterfaceLog(DispatchContext dctx, Map<String, ?> context) {
        Delegator delegator = dctx.getDelegator();
        Map<String, Object> response = ServiceUtil.returnSuccess();
        String interfaceId = (String) context.get("interfaceId");
        String mode = (String) context.get("mode");
        Timestamp interfaceLogDate = (Timestamp) context.get("interfaceLogDate");
        String interfaceLogReq = (String) context.get("interfaceLogReq");
        String interfaceLogRes = (String) context.get("interfaceLogRes");
        String undelyingEntityPK = (String) context.get("undelyingEntityPK");
        String interfaceLogId = delegator.getNextSeqId("InterfaceLog");
        try {
            if (UtilValidate.isEmpty(interfaceLogDate)) {
                interfaceLogDate = UtilDateTime.nowTimestamp();
            }
            GenericValue newLog = delegator.makeValidValue("InterfaceLog", UtilMisc.toMap("interfaceLogId", interfaceLogId, "interfaceId", interfaceId, "mode", mode, "interfaceLogReq", interfaceLogReq, "interfaceLogRes", interfaceLogRes, "undelyingEntityPK", undelyingEntityPK));
            newLog.set("interfaceLogDate", interfaceLogDate);
            newLog.create();
        }
        catch(GenericEntityException gee) {
            Debug.logError("Can not create InterfaceLog entry du to entity engine exception : " + gee.getLocalizedMessage(), module);
        }
        response.put("interfaceLogId", interfaceLogId);
        return response;
    }
    public static String serializeParams(Map<?, ?> params) throws IOException {
        Document doc = UtilXml.makeEmptyXmlDocument("params");
        Iterator<Map.Entry<?, ?>> iter = UtilGenerics.cast(params.entrySet()
                .iterator());
        while (iter.hasNext()) {
            Map.Entry<?, ?> entry = iter.next();
            serializeSingle(entry.getKey().toString(), entry.getValue(),
                    doc.getDocumentElement());
        }
        return UtilXml.writeXmlDocument(doc);
    }

    public static void serializeSingle(String name, Object val, Element root)
            throws IOException {
        Element param = root.getOwnerDocument().createElement(name);
        if (UtilValidate.isEmpty(val)) {
            root.appendChild(param);
        } else if (isSimpleType(val)) {
            param.setTextContent(val.toString());
            root.appendChild(param);
        } else if (val instanceof BigDecimal) {

            param.setTextContent(((BigDecimal) val).setScale(10,
                    BigDecimal.ROUND_HALF_UP).toString());
            root.appendChild(param);
        } else if (val instanceof Timestamp) {
            param.setTextContent(UtilDateTime.timeStampToString(
                    ((Timestamp) val), TimeZone.getDefault(),
                    Locale.getDefault()));
            root.appendChild(param);
        } else if (val instanceof java.util.Date) {
            param.setTextContent(new SimpleDateFormat(
                    UtilDateTime.DATE_TIME_FORMAT).format((java.util.Date) val));
            root.appendChild(param);
        } else if (val instanceof Map) {
            root.appendChild(param);
            Map<?, ?> params = (Map<?, ?>) val;
            Iterator<Map.Entry<?, ?>> iter = UtilGenerics.cast(params
                    .entrySet().iterator());
            while (iter.hasNext()) {
                Map.Entry<?, ?> entry = iter.next();
                Element entryELement = root.getOwnerDocument().createElement(
                        entry.getKey().toString());
                if (UtilValidate.isNotEmpty(entry.getValue())) {
                    entryELement.setTextContent(entry.getValue().toString());
                }
                param.appendChild(entryELement);
            }
        } else if (val instanceof List) {
            root.appendChild(param);
            List<?> params = (List<?>) val;
            Iterator<?> iter = UtilGenerics.cast(params.iterator());
            while (iter.hasNext()) {
                Object entry = iter.next();
                serializeSingle(name + "-entry", entry, param);
            }
        }
    }

    public static boolean isSimpleType(Object obj) {
        if (obj == null)
            return true;
        return obj instanceof String || obj instanceof Integer
                || obj instanceof Long || obj instanceof Float
                || obj instanceof Double || obj instanceof Boolean
                || obj instanceof Locale || obj instanceof Date
                || obj instanceof Time;
    }
}