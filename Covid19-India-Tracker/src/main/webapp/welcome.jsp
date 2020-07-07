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
		<link href="${contextPath}/resources/css/bootstrap.css" rel="stylesheet">
	</head>
	
	<body>
		<div class="container">
			<c:if test="${pageContext.request.userPrincipal.name != null}">
				<form id="logoutForm" method="POST" action="${contextPath}/logout">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</form>
				
				<h2>
					Welcome ${pageContext.request.userPrincipal.name} | <a onclick="document.forms['logoutForm'].submit()">Logout</a>
				</h2>
			</c:if>
		</div>
		<div class="container">
			<h1>Coronavirus Tracker Application</h1>
			<p> This application lists the current number of cases reported in India </p>
			<div class="jumbotron" style="width: 500px; float: left; height: 400px; margin: 10px">
				<h1 class="display-4">${totalReportedCases}</h1>
				<p class="lead">Total cases reported as of today</p>
				<hr class="my-4">
				<p><span>Total active cases</span> <span>${totalActiveCases}</span></p>
				<p><span>Total Recovered</span> <span>${totalRecovered}</span></p>
				<p><span>Total deaths</span> <span>${totalDeceased}</span></p>
			</div>
	
			<div class="container-fluid" id="chartContainer" style="width: 500px; float: left; height: 400px; margin: 10px"></div>
	
			<table id="locationStatsTable" class="table table-striped table-bordered">
				<thead class="thead-dark">
					<tr>
						<th style="width: 40%; font-size: 16px;">State</th>
						<th style="width: 15%; font-size: 16px;">Total Cases</th>
						<th style="width: 15%; font-size: 16px;">Active cases</th>
						<th style="width: 15%; font-size: 16px;">Recovered</th>
						<th style="width: 15%; font-size: 16px;">Deaths</th>
					</tr>
				</thead>
				<c:forEach var="mapItem" items="${locationStats}">
					<table class="table table-hover table-striped table-bordered">
						<tr>
							<td style="width: 40%; font-size: 14px;"><c:out value="${mapItem.key}" /></td>
							<td style="width: 15%; font-size: 14px;"><c:out value="${mapItem.value.confirmed}" /></td>
							<td style="width: 15%; font-size: 14px;"><c:out value="${mapItem.value.active}" /></td>
							<td style="width: 15%; font-size: 14px;"><c:out value="${mapItem.value.recovered}" /></td>
							<td style="width: 15%; font-size: 14px;"><c:out value="${mapItem.value.deaths}" /></td>
						</tr>
					</table>
				</c:forEach>
			</table>
		</div>
		
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
		
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