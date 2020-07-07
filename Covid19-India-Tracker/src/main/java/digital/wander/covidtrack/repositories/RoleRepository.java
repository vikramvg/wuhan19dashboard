/**
 * 
 */
package digital.wander.covidtrack.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import digital.wander.covidtrack.model.Role;

/**
 * @author Vikram Ghatikar
 *
 */

public interface RoleRepository extends JpaRepository<Role, Long> {
}
