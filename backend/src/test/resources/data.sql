SET SCHEMA tarjeta_mish;
insert into "user" (rut, name, email, pin) values
('123456789', 'John Doe', 'example@test.com', '1234');

insert into card (number, cvv, expirationdate, cardholdername) values
('123456789010256', '123', '2025-12-31', 'John Doe');