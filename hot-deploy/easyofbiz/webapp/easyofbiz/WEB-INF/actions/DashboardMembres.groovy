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
// Day new members stat
membersConditions =
        EntityCondition.makeCondition([
                EntityCondition.makeCondition("partyTypeId", EntityOperator.EQUALS, "PERSON"),
                EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PARTY_ENABLED"),
                EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstTimeOfToday)
        ],EntityOperator.AND);

membersList = delegator.findList("Party", membersConditions, null, null, null, false);

donationDayQuantity = 0;
for( member in membersList) {
    partyRole = delegator.findOne("PartyRole", false, "partyId", member.getString("partyId"), "roleTypeId", "CUSTOMER") ;
    if(UtilValidate.isNotEmpty(partyRole)) {
        donationDayQuantity ++;
    }
}

// ==============================================================
// Week new members stat
membersConditions =
        EntityCondition.makeCondition([
                EntityCondition.makeCondition("partyTypeId", EntityOperator.EQUALS, "PERSON"),
                EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PARTY_ENABLED"),
                EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfWeek)
        ],EntityOperator.AND);

membersList = delegator.findList("Party", membersConditions, null, null, null, false);

donationWeekQuantity = 0;
for( member in membersList) {
    partyRole = delegator.findOne("PartyRole", false, "partyId", member.getString("partyId"), "roleTypeId", "CUSTOMER") ;
    if(UtilValidate.isNotEmpty(partyRole)) {
        donationWeekQuantity++;
    }
}

// ==============================================================
// Month new members stat
membersConditions =
        EntityCondition.makeCondition([
                EntityCondition.makeCondition("partyTypeId", EntityOperator.EQUALS, "PERSON"),
                EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PARTY_ENABLED"),
                EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfMonth)
        ],EntityOperator.AND);

membersList = delegator.findList("Party", membersConditions, null, null, null, false);

donationMonthQuantity = 0;
for( member in membersList) {
    partyRole = delegator.findOne("PartyRole", false, "partyId", member.getString("partyId"), "roleTypeId", "CUSTOMER") ;
    if(UtilValidate.isNotEmpty(partyRole)) {
        donationMonthQuantity++;
    }
}

// ==============================================================
// Year new members stat
membersConditions =
        EntityCondition.makeCondition([
                EntityCondition.makeCondition("partyTypeId", EntityOperator.EQUALS, "PERSON"),
                EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PARTY_ENABLED"),
                EntityCondition.makeCondition("createdStamp", EntityOperator.GREATER_THAN, firstDayOfYear)
        ],EntityOperator.AND);

membersList = delegator.findList("Party", membersConditions, null, null, null, false);

donationYearQuantity = 0;

janQuantity = 0 ;
fevQuantity = 0 ;
marQuantity = 0 ;
aprQuantity = 0 ;
mayQuantity = 0 ;
junQuantity = 0 ;
julQuantity = 0 ;
augQuantity = 0 ;
sepQuantity = 0 ;
octQuantity = 0 ;
novQuantity = 0 ;
decQuantity = 0 ;

for( member in membersList) {
    partyRole = delegator.findOne("PartyRole", false, "partyId", member.getString("partyId"), "roleTypeId", "CUSTOMER") ;
    if(UtilValidate.isNotEmpty(partyRole)) {
        donationYearQuantity++;
        Month = UtilDateTime.getMonth(member.get("createdStamp"), timeZone, locale) + 1;
        switch (Month) {
            case 1:
                janQuantity++;
                break;
            case 2:
                fevQuantity++;
                break;
            case 3:
                marQuantity++;
                break;
            case 4:
                aprQuantity++;
                break;
            case 5:
                mayQuantity++;
                break;
            case 6:
                junQuantity++;
                break;
            case 7:
                julQuantity++;
                break;
            case 8:
                augQuantity++;
                break;
            case 9:
                sepQuantity++;
                break;
            case 10:
                octQuantity++;
                break;
            case 11:
                novQuantity++;
                break;
            case 12:
                decQuantity++;
                break;
        }
    }
}

context.put("donationDayQuantity",donationDayQuantity);
context.put("donationWeekQuantity",donationWeekQuantity);
context.put("donationMonthQuantity",donationMonthQuantity);
context.put("donationYearQuantity",donationYearQuantity);

context.put("janQuantity",janQuantity);
context.put("fevQuantity",fevQuantity);
context.put("marQuantity",marQuantity);
context.put("aprQuantity",aprQuantity);
context.put("mayQuantity",mayQuantity);
context.put("junQuantity",junQuantity);
context.put("julQuantity",julQuantity);
context.put("augQuantity",augQuantity);
context.put("sepQuantity",sepQuantity);
context.put("octQuantity",octQuantity);
context.put("novQuantity",novQuantity);
context.put("decQuantity",decQuantity);
