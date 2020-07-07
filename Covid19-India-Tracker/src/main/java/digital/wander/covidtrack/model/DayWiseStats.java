package digital.wander.covidtrack.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * @author Vikram Ghatikar
 *
 */

@Getter
@Setter
@ToString
public class DayWiseStats {

	private int dailyconfirmed;
	private int dailydeceased;
	private int dailyrecovered;
	private String date;
	private int totalconfirmed;
	private int totaldeceased;
	private int totalrecovered;

}