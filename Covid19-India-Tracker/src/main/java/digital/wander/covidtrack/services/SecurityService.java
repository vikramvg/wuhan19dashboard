package digital.wander.covidtrack.services;

/**
 * @author Vikram Ghatikar
 *
 */

public interface SecurityService {

	String findLoggedInUsername();
	void autoLogin(String username, String password);
	
}
