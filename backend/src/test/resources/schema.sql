CREATE SCHEMA IF NOT EXISTS tarjeta_mish;
SET SCHEMA tarjeta_mish;

CREATE TABLE "user" (
                        iduser BIGINT AUTO_INCREMENT PRIMARY KEY,
                        rut VARCHAR(9) NOT NULL UNIQUE,
                        name VARCHAR(60),
                        email VARCHAR(255),
                        pin VARCHAR(4) NOT NULL
);