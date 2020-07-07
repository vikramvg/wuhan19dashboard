package digital.wander.covidtrack.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import digital.wander.covidtrack.model.User;

/**
 * @author Vikram Ghatikar
 *
 */

public interface UserRepository extends JpaRepository<User, Long>{
	User findByUsername(String username);
}
