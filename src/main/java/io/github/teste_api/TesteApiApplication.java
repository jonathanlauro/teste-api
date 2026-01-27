package io.github.teste_api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.util.concurrent.atomic.AtomicInteger;

@SpringBootApplication
@EnableScheduling
public class TesteApiApplication {
	private static final Logger log = LoggerFactory.getLogger(TesteApiApplication.class);
	private static final AtomicInteger counter = new AtomicInteger(0);
	private static final int MAX_LOGS = 100;

	public static void main(String[] args) {
		SpringApplication.run(TesteApiApplication.class, args);
	}

	// 1800 ms ≈ 3 minutos / 100 logs
	@Scheduled(fixedRate = 800)
	public void gerarLogs() {
		int atual = counter.incrementAndGet();

		if (atual <= MAX_LOGS) {
			log.info("Log número {}", atual);
		}
	}
}
