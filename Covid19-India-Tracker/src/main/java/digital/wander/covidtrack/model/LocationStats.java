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
public class LocationStats {

	private String state;
	private int confirmed;
	private int active;
	private int recovered;
	private int deaths;

}