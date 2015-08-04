<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<div class="page-header">
    <h1>Tableau de bord des nouveaux membres</h1>
</div>
<div class="row">
          <div class="col-lg-3 col-md-6">
              <div class="panel panel-primary">
                  <div class="panel-heading">
                      <div class="row">
                          <div class="col-xs-3">
                              <i class="fa fa-calendar fa-5x"></i>
                          </div>
                          <div class="col-xs-9 text-right">
                              <div class="huge">${donationDayQuantity}</div>
                              <div>Aujourd'hui</div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
          <div class="col-lg-3 col-md-6">
              <div class="panel panel-green">
                  <div class="panel-heading">
                      <div class="row">
                          <div class="col-xs-3">
                              <i class="fa fa-calendar fa-5x"></i>
                          </div>
                          <div class="col-xs-9 text-right">
                              <div class="huge">${donationWeekQuantity}</div>
                              <div>Cette semaine</div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
          <div class="col-lg-3 col-md-6">
              <div class="panel panel-yellow">
                  <div class="panel-heading">
                      <div class="row">
                          <div class="col-xs-3">
                              <i class="fa fa-calendar fa-5x"></i>
                          </div>
                          <div class="col-xs-9 text-right">
                              <div class="huge">${donationMonthQuantity}</div>
                              <div>Ce mois</div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
          <div class="col-lg-3 col-md-6">
              <div class="panel panel-red">
                  <div class="panel-heading">
                      <div class="row">
                          <div class="col-xs-3">
                              <i class="fa fa-calendar fa-5x"></i>
                          </div>
                          <div class="col-xs-9 text-right">
                              <div class="huge">${donationYearQuantity}</div>
                              <div>Cette année</div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
      <!-- /.row -->
<script>
$(function() {

Morris.Area({
element: 'morris-area-chart',
data: [{
period: '2015-1',
totalAmount: ${janQuantity}
}, {
period: '2015-2',
totalAmount: ${fevQuantity}
}, {
period: '2015-3',
totalAmount: ${marQuantity}
}, {
period: '2015-4',
totalAmount: ${aprQuantity}
}, {
period: '2015-5',
totalAmount: ${mayQuantity}
}, {
period: '2015-6',
totalAmount: ${junQuantity}
}, {
period: '2015-7',
totalAmount: ${julQuantity}
}, {
period: '2015-8',
totalAmount: ${augQuantity}
}, {
period: '2015-9',
totalAmount: ${sepQuantity}
}, {
period: '2015-10',
totalAmount: ${octQuantity}
}, {
period: '2015-11',
totalAmount: ${novQuantity}
}, {
period: '2015-12',
totalAmount: ${decQuantity}
}],
xkey: 'period',
ykeys: ['totalAmount'],
labels: ['Total en quantité'],
pointSize: 5,
hideHover: 'auto',
resize: true
});

});
</script>
      <!-- /.row -->
        <div class="row">
            <div class="col-lg-6">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-bar-chart-o fa-fw"></i> Nombre de membres
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <div id="morris-area-chart"></div>
                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
            <div class="col-lg-6">
            </div>
        </div>

<!--

 /.panel 

-->
  </div>
            