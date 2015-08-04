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
    <h1>Tableau de bord des dons</h1>
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
<!--                   <a href="#"> -->
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${donationDayValue} €</span>
                          <div class="clearfix"></div>
                      </div>
<!--                   </a> -->
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
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${donationWeekValue} €</span>
                          <div class="clearfix"></div>
                      </div>
                  </a>
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
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${donationMonthValue} €</span>
                          <div class="clearfix"></div>
                      </div>
                  </a>
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
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${donationYearValue} €</span>
                          <div class="clearfix"></div>
                      </div>
                  </a>
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
totalAmount: ${janValue}
}, {
period: '2015-2',
totalAmount: ${fevValue}
}, {
period: '2015-3',
totalAmount: ${marValue}
}, {
period: '2015-4',
totalAmount: ${aprValue}
}, {
period: '2015-5',
totalAmount: ${mayValue}
}, {
period: '2015-6',
totalAmount: ${junValue}
}, {
period: '2015-7',
totalAmount: ${julValue}
}, {
period: '2015-8',
totalAmount: ${augValue}
}, {
period: '2015-9',
totalAmount: ${sepValue}
}, {
period: '2015-10',
totalAmount: ${octValue}
}, {
period: '2015-11',
totalAmount: ${novValue}
}, {
period: '2015-12',
totalAmount: ${decValue}
}],
xkey: 'period',
ykeys: ['totalAmount'],
labels: ['Total en valeur'],
pointSize: 5,
hideHover: 'auto',
resize: true
});

Morris.Bar({
element: 'morris-bar-chart',
data: [{
y: '2015-01',
a: ${janQuantity},
}, {
y: '2015-02',
a: ${fevQuantity},
}, {
y: '2015-03',
a: ${marQuantity},
}, {
y: '2015-04',
a: ${aprQuantity},
}, {
y: '2015-05',
a: ${mayQuantity},
}, {
y: '2015-06',
a: ${junQuantity},
}, {
y: '2015-07',
a: ${julQuantity},
}, {
y: '2015-08',
a: ${augQuantity},
}, {
y: '2015-09',
a: ${sepQuantity},
}, {
y: '2015-10',
a: ${octQuantity},
}, {
y: '2015-11',
a: ${novQuantity},
}, {
y: '2015-12',
a: ${decQuantity},
}],
xkey: 'y',
ykeys: ['a'],
labels: ['Quantité de dons'],
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
                        <i class="fa fa-bar-chart-o fa-fw"></i> Montant des dons
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
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-bar-chart-o fa-fw"></i> Nombre de dons
                    </div>
                    <!-- /.panel-heading -->
                    <div class="panel-body">
                        <div id="morris-bar-chart"></div>
                    </div>
                    <!-- /.panel-body -->
                </div>
                <!-- /.panel -->
            </div>
        </div>

<!--

 /.panel 

-->
  </div>
            