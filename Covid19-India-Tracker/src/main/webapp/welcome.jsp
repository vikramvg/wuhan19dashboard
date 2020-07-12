<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		
		<title>Welcome to Covid19 India Tracker</title>
		
		<!-- Font Awesome -->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css">
		<!-- Google Fonts Roboto -->
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
		<!-- Bootstrap core CSS -->
		<link rel="stylesheet" href="${contextPath}/resources/css/bootstrap.css">
		<link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css"></link>
	</head>
	
	<body>
		<div class="container">
			<nav class="navbar sticky-top navbar-dark bg-dark">
				<c:if test="${pageContext.request.userPrincipal.name != null}">
					<form id="logoutForm" method="POST" action="${contextPath}/logout">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					</form>
					<div class="col-11">
						<span class="navbar-brand mb-0 h1 float-md-left">
							Welcome ${pageContext.request.userPrincipal.name}
						</span>
					</div>
					<div>
						<form class="form-inline">
						    <button class="btn btn-outline-success" type="button" onclick="document.forms['logoutForm'].submit()">Logout</button>
						</form>
					</div>
				</c:if>	
			</nav>
		</div>
		<div class="container">
			<h1>&nbsp;Coronavirus Tracker Application</h1>
			<p>&nbsp;&nbsp;&nbsp;This application lists the current number of cases reported in India</p>
			<div class="jumbotron" style="width: 535px; float: left; height: 400px; margin: 10px">
				<h1 class="display-4">${totalReportedCases}</h1>
				<p class="lead">Total cases reported as of today</p>
				<hr class="my-4">
				<p><span>Total active cases</span> <span>${totalActiveCases}</span></p>
				<p><span>Total Recovered</span> <span>${totalRecovered}</span></p>
				<p><span>Total deaths</span> <span>${totalDeceased}</span></p>
			</div>
	
			<div class="container-fluid" id="chartContainer" style="width: 535px; float: right; height: 400px; margin: 10px"></div>
			
			<div class="table-responsive-md">
				<table id="locationStatsTable" class="table table-striped table-bordered table-hover">
					<thead style="background-color: #ADADAD;">
						<tr>
							<th>State</th>
							<th>Total Cases</th>
							<th>Active cases</th>
							<th>Recovered</th>
							<th>Deaths</th>
						</tr>
					</thead>
					<c:forEach var="mapItem" items="${locationStats}">
							<tr>
								<td><c:out value="${mapItem.key}" /></td>
								<td><c:out value="${mapItem.value.confirmed}" /></td>
								<td><c:out value="${mapItem.value.active}" /></td>
								<td><c:out value="${mapItem.value.recovered}" /></td>
								<td><c:out value="${mapItem.value.deaths}" /></td>
							</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
		<script type="text/javascript" src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
		<script>
			$(document).ready(function(){
			    $('#locationStatsTable').dataTable();
			});
		</script>
		<script type="text/javascript">
			window.onload = function() {
	
				var dps = [ [] ];
				var chart = new CanvasJS.Chart("chartContainer", {
					theme : "light2", // "dark2", "light1", "dark1"
					animationEnabled : true,
					exportEnabled : true,
					title : {
						text : "Time series - last 7 days",
						fontSize: 26
					},
					axisX : {
						valueFormatString : "DD MMM"
					},
					axisY : {
						title : "Daily confirmed cases",
						includeZero : false
					},
					data : [ {
						type : "line",
						xValueType : "dateTime",
						xValueFormatString : "DD MMM",
						yValueFormatString : "",
						dataPoints : dps[0]
					} ]
				});
	
				var xValue;
				var yValue;
				
				<c:forEach items="${dataPointsList}" var="dataPoints" varStatus="loop">
					<c:forEach items="${dataPoints}" var="dataPoint">
						xValue = parseFloat("${dataPoint.x}");
						yValue = parseInt("${dataPoint.y}");
						dps[parseInt("${loop.index}")].push({
							x : xValue,
							y : yValue
						});
					</c:forEach>
				</c:forEach>
				chart.render();
			}
		</script>
		<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
	</body>
</html>