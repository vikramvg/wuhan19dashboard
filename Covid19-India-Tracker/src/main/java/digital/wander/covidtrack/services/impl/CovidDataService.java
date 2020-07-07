package digital.wander.covidtrack.services.impl;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import digital.wander.covidtrack.model.DayWiseStats;
import digital.wander.covidtrack.model.LocationStats;
import lombok.Getter;

/**
 * @author Vikram Ghatikar
 *
 */

@Service
@Getter
public class CovidDataService {

	private static final String COVID19_INDIA_URL = "https://api.covid19india.org/data.json";
	private Map<String, LocationStats> allLocationStats = new HashMap<String, LocationStats>();
	private Map<String, DayWiseStats> allDayWiseStats = new LinkedHashMap<String, DayWiseStats>();

	@SuppressWarnings("rawtypes")
	@PostConstruct
	@Scheduled(cron = "${cron.expression}")
	public void fetchDailyLocationData() throws Exception {
		Map<String, LocationStats> newStats = new HashMap<String, LocationStats>();
		JSONObject jsonObject = apiDataToJson();
		JSONArray jsonArray = (JSONArray) jsonObject.get("statewise");
		Iterator iterator = jsonArray.iterator();
		Gson gson = new Gson();
		while (iterator.hasNext()) {
			LocationStats locationStats = gson.fromJson(iterator.next().toString(), LocationStats.class);
			newStats.put(locationStats.getState(), locationStats);
		}
		this.allLocationStats = newStats;
	}

	public JSONObject apiDataToJson() {
		String json = ClientBuilder.newClient().target(COVID19_INDIA_URL).request().accept(MediaType.APPLICATION_JSON)
				.get(String.class);
		JSONObject jsonObject = new JSONObject(json);
		return jsonObject;
	}

	@SuppressWarnings("rawtypes")
	@PostConstruct
	@Scheduled(cron = "${cron.expression}")
	public void fetchDayWiseStats() {
		Map<String, DayWiseStats> dayWiseStatsMap = new LinkedHashMap<String, DayWiseStats>();
		JSONObject jsonObject = apiDataToJson();
		JSONArray jsonArray = (JSONArray) jsonObject.get("cases_time_series");
		Iterator iterator = jsonArray.iterator();
		Gson gson = new Gson();
		while (iterator.hasNext()) {
			DayWiseStats dayWiseStats = gson.fromJson(iterator.next().toString(), DayWiseStats.class);
			dayWiseStatsMap.put(dayWiseStats.getDate().trim().toUpperCase(), dayWiseStats);
		}
		this.allDayWiseStats = dayWiseStatsMap;
	}
	
	public List<List<Map<Object, Object>>> prepareDayWiseChartDataForUI(){
		Map<Object, Object> last7DaysStatsMap = null;
		List<List<Map<Object, Object>>> canvasjsDataList = new ArrayList<List<Map<Object, Object>>>();
		List<Map<Object, Object>> dataPoints1 = new ArrayList<Map<Object, Object>>();
		Map<String, DayWiseStats> allDayWiseStatsMap = getAllDayWiseStats();
		for (int i = 1; i <= 7; i++) {
			LocalDate pastDay = LocalDate.now().minusDays(i);
			ZonedDateTime zdt = pastDay.atStartOfDay(ZoneId.of("Asia/Kolkata"));
			String[] date = pastDay.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")).split("-");
			String month = pastDay.getMonth().toString();
			String dayAndMonth = (date[0] + " " + month).trim();
			if (allDayWiseStatsMap.containsKey(dayAndMonth)) {
				last7DaysStatsMap = new LinkedHashMap<Object, Object>();
				last7DaysStatsMap.put("x", zdt.toInstant().toEpochMilli());
				last7DaysStatsMap.put("y", allDayWiseStatsMap.get(dayAndMonth).getDailyconfirmed());
				dataPoints1.add(last7DaysStatsMap);
			}
		}
		canvasjsDataList.add(dataPoints1);
		return canvasjsDataList;
	}

}