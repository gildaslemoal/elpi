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
    <h1>Tableau de bord des commandes</h1>
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
                              <div class="huge">${dayApprove?size?default(0)?string.number}</div>
                              <div>Aujourd'hui</div>
                          </div>
                      </div>
                  </div>
<!--                   <a href="#"> -->
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${dayItemTotal} €</span>
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
                              <div class="huge">${weekApprove?size?default(0)?string.number}</div>
                              <div>Cette semaine</div>
                          </div>
                      </div>
                  </div>
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${weekItemTotal} €</span>
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
                              <div class="huge">${monthApprove?size?default(0)?string.number}</div>
                              <div>Ce mois</div>
                          </div>
                      </div>
                  </div>
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${monthItemTotal} €</span>
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
                              <div class="huge">${yearApprove?size?default(0)?string.number}</div>
                              <div>Cette année</div>
                          </div>
                      </div>
                  </div>
                  <a href="#">
                      <div class="panel-footer">
                          <span class="pull-left">Total</span>
                          <span class="pull-right">${yearItemTotal} €</span>
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
period: '2014-1',
totalAmount: 2500
}, {
period: '2014-2',
totalAmount: 1680
}, {
period: '2014-3',
totalAmount: 3075
}, {
period: '2014-4',
totalAmount: 4500
}, {
period: '2014-5',
totalAmount: 4750
}, {
period: '2014-6',
totalAmount: 6800
}, {
period: '2014-7',
totalAmount: 3500
}, {
period: '2014-8',
totalAmount: 2780
}, {
period: '2014-9',
totalAmount: 10500
}, {
period: '2014-10',
totalAmount: 11350
}, {
period: '2014-11',
totalAmount: 9750
}, {
period: '2014-12',
totalAmount: 11000
}],
xkey: 'period',
ykeys: ['totalAmount'],
labels: ['total amount'],
pointSize: 5,
hideHover: 'auto',
resize: true
});

Morris.Bar({
element: 'morris-bar-chart',
data: [{
y: '2014-01',
a: 100,
}, {
y: '2014-02',
a: 75,
}, {
y: '2014-03',
a: 50,
}, {
y: '2014-04',
a: 75,
}, {
y: '2014-05',
a: 50,
}, {
y: '2014-06',
a: 90,
}, {
y: '2014-07',
a: 5,
}, {
y: '2014-08',
a: 10,
}, {
y: '2014-09',
a: 120,
}, {
y: '2014-10',
a: 105,
}, {
y: '2014-11',
a: 95,
}, {
y: '2014-12',
a: 102,
}],
xkey: 'y',
ykeys: ['a'],
labels: ['Quantité de commandes'],
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
                        <i class="fa fa-bar-chart-o fa-fw"></i> Montant des commandes
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
                        <i class="fa fa-bar-chart-o fa-fw"></i> Quantité de commandes
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
            