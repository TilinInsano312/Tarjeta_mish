CREATE SCHEMA IF NOT EXISTS tarjeta_mish;
SET SCHEMA tarjeta_mish;

CREATE TABLE "user" (
                        iduser BIGINT AUTO_INCREMENT PRIMARY KEY,
                        rut VARCHAR(9) NOT NULL UNIQUE,
                        name VARCHAR(60),
                        email VARCHAR(255),
                        pin VARCHAR(4) NOT NULL
);
CREATE TABLE card (
                        idcard BIGINT AUTO_INCREMENT PRIMARY KEY,
                        number VARCHAR(16) NOT NULL UNIQUE,
                        cvv VARCHAR(3) NOT NULL,
                        expirationdate date NOT NULL,
                        cardholdername VARCHAR(60) NOT NULL
);
create table if not exists account
(
    idaccount     BIGINT AUTO_INCREMENT
        primary key,
    balance       integer     not null,
    accountnumber varchar(20) not null,
    idcard        integer     not null
        references card
            on update cascade on delete cascade,
    iduser        integer     not null
        constraint account_user_iduser_fk
            references "user"
);
create table if not exists typeaccount
(
    idtypeaccount BIGINT AUTO_INCREMENT
        primary key,
    type          varchar(45) not null
);
create table if not exists typemovement
(
    idtypemovement BIGINT AUTO_INCREMENT
        primary key,
    typemovement   varchar(20) not null
);
create table if not exists bank
(
    idbank BIGINT AUTO_INCREMENT
        primary key,
    bank   varchar(60) not null
);

create table if not exists movement
(
    idmovement         BIGINT AUTO_INCREMENT
        primary key,
    amount             integer      not null,
    date               date         not null,
    description        varchar(300) not null,
    rutdestination     varchar(10),
    accountdestination varchar(45)  not null,
    rutorigin          varchar(10),
    accountorigin      varchar(45)  not null,
    idtypeMovement INTEGER NOT NULL,
    idbank INTEGER NOT NULL,
    idaccount INTEGER NOT NULL,
    FOREIGN KEY (idtypeMovement) REFERENCES typeMovement(idtypeMovement) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idbank) REFERENCES bank(idbank) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idaccount) REFERENCES account(idaccount) ON DELETE CASCADE ON UPDATE CASCADE,
    name               varchar(60)  not null
);
