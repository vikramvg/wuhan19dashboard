package digital.wander.covidtrack.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import digital.wander.covidtrack.model.LocationStats;
import digital.wander.covidtrack.model.User;
import digital.wander.covidtrack.services.SecurityService;
import digital.wander.covidtrack.services.UserService;
import digital.wander.covidtrack.services.impl.CovidDataService;
import digital.wander.covidtrack.validator.UserValidator;

/**
 * @author Vikram Ghatikar
 *
 */

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private SecurityService securityService;

	@Autowired
	private UserValidator userValidator;

	@Autowired
	CovidDataService covidDataService;

	@RequestMapping(value = "/registration", method = RequestMethod.GET)
	public String registration(Model model) {
		model.addAttribute("userForm", new User());
		return "registration";
	}

	@RequestMapping(value = "/registration", method = RequestMethod.POST)
	public String registration(@ModelAttribute("userForm") User userForm, BindingResult bindingResult) {
		userValidator.validate(userForm, bindingResult);
		if (bindingResult.hasErrors()) {
			return "registration";
		}
		userService.save(userForm);
		securityService.autoLogin(userForm.getUsername(), userForm.getPasswordConfirm());
		return "redirect:/welcome";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model, String error, String logout) {
		if (error != null)
			model.addAttribute("error", "Your username and password is invalid.");
		if (logout != null)
			model.addAttribute("message", "You have been logged out successfully.");
		return "login";
	}

	@RequestMapping(value = { "/", "/welcome" }, method = RequestMethod.GET)
	public String welcome(Model model, ModelMap modelMap) {
		Map<String, LocationStats> allLocationStatsMap = covidDataService.getAllLocationStats();
		prepareLocationDataForUI(model, allLocationStatsMap);
		
		List<List<Map<Object, Object>>> canvasjsDataList = covidDataService.prepareDayWiseChartDataForUI();
		modelMap.addAttribute("dataPointsList", canvasjsDataList);
		return "welcome";
	}

	private void prepareLocationDataForUI(Model model, Map<String, LocationStats> allLocationStatsMap) {
		LocationStats totalCountObject = allLocationStatsMap.get("Total");
		int totalReportedCases = totalCountObject.getConfirmed();
		int totalActiveCases = totalCountObject.getActive();
		int totalRecovered = totalCountObject.getRecovered();
		int totalDeceased = totalCountObject.getDeaths();
		Map<String, LocationStats> copyOfAllLocationStatsMap = new LinkedHashMap<>(); 
		copyOfAllLocationStatsMap.putAll(allLocationStatsMap);
		copyOfAllLocationStatsMap.remove("Total");
		copyOfAllLocationStatsMap.remove("State Unassigned");
		model.addAttribute("locationStats", copyOfAllLocationStatsMap);
		model.addAttribute("totalReportedCases", totalReportedCases);
		model.addAttribute("totalActiveCases", totalActiveCases);
		model.addAttribute("totalRecovered", totalRecovered);
		model.addAttribute("totalDeceased", totalDeceased);
	}

}