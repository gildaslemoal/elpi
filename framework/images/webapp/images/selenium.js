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

function zoomAndType(id, level, text) {
    var element = $('#' + id)
    if(!element.length) {
        element = $("[name='" + id + "']");
    }
    element.focus()
    element.focusout(
        function() {
            element.animate({ 'zoom': 1 }, 50);
        }
    );
    element.animate({ 'zoom': level }, 800);
    element.val(text);
}
function showSeleniumInfoPanel(text, duration) {
    var seleniumInfoPanel = jQuery("<div id='seleniumInfoPanel'></div>").appendTo('body');
    seleniumInfoPanel.dialog({
            modal: true,
            open : function() {
                $(".ui-widget-header").hide();
                $('#seleniumInfoPanel').css('text-align','center')
                $('#seleniumInfoPanel').css('line-height','1.2em');
                $('#seleniumInfoPanel').css('font-size','2em');
                seleniumInfoPanel.html(text);
                setTimeout(function(){ $('#seleniumInfoPanel').dialog('destroy').remove();}, duration);
            },
            buttons: {}
        });
}
