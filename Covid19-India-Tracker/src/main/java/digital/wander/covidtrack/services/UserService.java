package digital.wander.covidtrack.services;

import digital.wander.covidtrack.model.User;

/**
 * @author Vikram Ghatikar
 *
 */

public interface UserService {
	
	public void save(User user);
	public User findByUsername(String username);
	
}
