package com.pltl.prolog;

import org.jpl7.Atom;
import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

@SpringBootApplication
public class PrologApplication {
	private static final Logger logger = LoggerFactory.getLogger(PrologApplication.class);

	public static void main(String[] args) throws IOException {
		SpringApplication.run(PrologApplication.class, args);

		JPL.init();

		Term consult_arg[] = {
				new Atom(getPrologFilePath())
		};
		Query consult_query = new Query("consult", consult_arg);
		consult_query.oneSolution();
	}

	// Used for prolog file reading in unknown system (for .jar)
	private static String getPrologFilePath() throws IOException {
		// Use getResourceAsStream to get an InputStream for the file within the JAR
		InputStream is = PrologApplication.class.getClassLoader().getResourceAsStream("prolog/bakalauras.pl");

		// Create a temporary file
		File temp = File.createTempFile("tempfile", ".pl");

		// Copy the contents of the InputStream to the temporary file
		try (FileOutputStream out = new FileOutputStream(temp)) {
			byte[] buffer = new byte[1024];
			int bytesRead;
			while ((bytesRead = is.read(buffer)) != -1) {
				out.write(buffer, 0, bytesRead);
			}
		}

		logger.info("TEMP FILE PATH: '{}'", temp.getAbsolutePath());
		return temp.getAbsolutePath();
	}

}
