package digital.wander.covidtrack;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * @author Vikram Ghatikar
 *
 */

@SpringBootApplication
@EnableScheduling
public class CovidIndiaTrackerApplication extends SpringBootServletInitializer{
	
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(CovidIndiaTrackerApplication.class);
    }

	public static void main(String[] args) {
		SpringApplication.run(CovidIndiaTrackerApplication.class, args);
	}

}
