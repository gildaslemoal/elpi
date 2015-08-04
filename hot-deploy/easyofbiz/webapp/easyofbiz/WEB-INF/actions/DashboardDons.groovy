/*
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
 */


import org.apache.commons.net.ntp.TimeStamp
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.*
import org.ofbiz.base.util.Debug;
import javolution.util.FastList;
import org.ofbiz.base.util.UtilDateTime
import org.ofbiz.entity.condition.EntityCondition
import org.ofbiz.entity.condition.EntityOperator
import org.ofbiz.entity.util.EntityUtil;
import java.util.Calendar;

firstTimeOfToday = UtilDateTime.getDayStart(nowTimestamp, timeZone, locale);
firstDayOfWeek = UtilDateTime.getWeekStart(nowTimestamp, timeZone, locale);
firstDayOfMonth = UtilDateTime.getMonthStart(nowTimestamp, timeZone, locale);
firstDayOfYear = UtilDateTime.getYearStart(nowTimestamp, timeZone, locale);

// ==============================================================
// Day donation stat
orderItemDonationCondition = EntityCondition.makeCondition([EntityCondition.makeCondition("productId", EntityOperator.EQUALS, "10010"),
                                                            EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstTimeOfToday)],
                                                            EntityOperator.AND);

orderItemDonationList = delegator.findList("OrderItem", orderItemDonationCondition, null, null, null, false);

donationDayValue = 0;
donationDayQuantity = 0;
for( orderItemDonation in orderItemDonationList) {
    donationDayValue += orderItemDonation.get("quantity");
    donationDayQuantity ++;
}

// ==============================================================
// Week donation stat
orderItemDonationCondition = EntityCondition.makeCondition([EntityCondition.makeCondition("productId", EntityOperator.EQUALS, "10010"),
                                                            EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfWeek)],
                                                            EntityOperator.AND);

orderItemDonationList = delegator.findList("OrderItem", orderItemDonationCondition, null, null, null, false);

donationWeekValue = 0;
donationWeekQuantity = 0;
for( orderItemDonation in orderItemDonationList) {
    donationWeekValue += orderItemDonation.get("quantity");
    donationWeekQuantity ++;
}

// ==============================================================
// Month donation stat
orderItemDonationCondition = EntityCondition.makeCondition([EntityCondition.makeCondition("productId", EntityOperator.EQUALS, "10010"),
                                                            EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfMonth)],
                                                            EntityOperator.AND);

orderItemDonationList = delegator.findList("OrderItem", orderItemDonationCondition, null, null, null, false);

donationMonthValue = 0;
donationMonthQuantity = 0;
for( orderItemDonation in orderItemDonationList) {
    donationMonthValue += orderItemDonation.get("quantity");
    donationMonthQuantity ++;
}

// ==============================================================
// Year donation stat
orderItemDonationCondition = EntityCondition.makeCondition([EntityCondition.makeCondition("productId", EntityOperator.EQUALS, "10010"),
                                                            EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfYear)],
                                                            EntityOperator.AND);

orderItemDonationList = delegator.findList("OrderItem", orderItemDonationCondition, null, null, null, false);

donationYearValue = 0;
donationYearQuantity = 0;

janValue = 0 ;
janQuantity = 0 ;
fevValue = 0 ;
fevQuantity = 0 ;
marValue = 0 ;
marQuantity = 0 ;
aprValue = 0 ;
aprQuantity = 0 ;
mayValue = 0 ;
mayQuantity = 0 ;
junValue = 0 ;
junQuantity = 0 ;
julValue = 0 ;
julQuantity = 0 ;
augValue = 0 ;
augQuantity = 0 ;
sepValue = 0 ;
sepQuantity = 0 ;
octValue = 0 ;
octQuantity = 0 ;
novValue = 0 ;
novQuantity = 0 ;
decValue = 0 ;
decQuantity = 0 ;

for( orderItemDonation in orderItemDonationList) {
    donationYearValue += orderItemDonation.get("quantity");
    donationYearQuantity ++;
    createStampTest = orderItemDonation.get("createStamp") ;
    Month = UtilDateTime.getMonth(orderItemDonation.get("createdStamp"), timeZone, locale) +1 ;
    switch (Month) {
        case 1 :
            janValue += orderItemDonation.get("quantity");
            janQuantity++ ;
            break;
        case 2 :
            fevValue += orderItemDonation.get("quantity");
            fevQuantity++ ;
            break;
        case 3 :
            marValue += orderItemDonation.get("quantity");
            marQuantity++ ;
            break;
        case 4 :
            aprValue += orderItemDonation.get("quantity");
            aprQuantity++ ;
            break;
        case 5 :
            mayValue += orderItemDonation.get("quantity");
            mayQuantity++ ;
            break;
        case 6 :
            junValue += orderItemDonation.get("quantity");
            junQuantity++ ;
            break;
        case 7 :
            julValue += orderItemDonation.get("quantity");
            julQuantity++ ;
            break;
        case 8 :
            augValue += orderItemDonation.get("quantity");
            augQuantity++ ;
            break;
        case 9 :
            sepValue += orderItemDonation.get("quantity");
            sepQuantity++ ;
            break;
        case 10 :
            octValue += orderItemDonation.get("quantity");
            octQuantity++ ;
            break;
        case 11 :
            novValue += orderItemDonation.get("quantity");
            novQuantity++ ;
            break;
        case 12 :
            decValue += orderItemDonation.get("quantity");
            decQuantity++ ;
            break;
    }
}

context.put("donationDayValue",donationDayValue);
context.put("donationDayQuantity",donationDayQuantity);
context.put("donationWeekValue",donationWeekValue);
context.put("donationWeekQuantity",donationWeekQuantity);
context.put("donationMonthValue",donationMonthValue);
context.put("donationMonthQuantity",donationMonthQuantity);
context.put("donationYearValue",donationYearValue);
context.put("donationYearQuantity",donationYearQuantity);


context.put("janValue",janValue);
context.put("janQuantity",janQuantity);
context.put("fevValue",fevValue);
context.put("fevQuantity",fevQuantity);
context.put("marValue",marValue);
context.put("marQuantity",marQuantity);
context.put("aprValue",aprValue);
context.put("aprQuantity",aprQuantity);
context.put("mayValue",mayValue);
context.put("mayQuantity",mayQuantity);
context.put("junValue",junValue);
context.put("junQuantity",junQuantity);
context.put("julValue",julValue);
context.put("julQuantity",julQuantity);
context.put("augValue",augValue);
context.put("augQuantity",augQuantity);
context.put("sepValue",sepValue);
context.put("sepQuantity",sepQuantity);
context.put("octValue",octValue);
context.put("octQuantity",octQuantity);
context.put("novValue",novValue);
context.put("novQuantity",novQuantity);
context.put("decValue",decValue);
context.put("decQuantity",decQuantity);
