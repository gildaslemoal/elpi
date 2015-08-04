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
