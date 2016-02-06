/**
 * Created by acid on 06/02/16.
 */


function loadCharts(dso_data) {
    google.load("visualization", "1", {"callback": drawCharts(dso_data)});
    google.charts.load('current', {packages: ['corechart', 'line']});
}



function drawCharts(dso_data) {
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'X');
    data.addColumn('number', 'V');

    i = 1;
    for (d in dso_data) {
        data.addRow([i++, dso_data[d]]);
    }


    var options = {
        hAxis: {
            title: 'Time'
        },
        vAxis: {
            title: 'V'
        },
        colors: ['#a52714', '#097138']
    };

    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));

    chart.draw(data, options);
}
