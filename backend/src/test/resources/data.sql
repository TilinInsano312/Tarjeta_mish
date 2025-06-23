SET SCHEMA tarjeta_mish;
insert into "user" (rut, name, email, pin) values
('123456789', 'John Doe', 'example@test.com', '1234');
insert into card (number, cvv, expirationdate, cardholdername) values
('123456789010256', '123', '2025-12-31', 'John Doe');
INSERT INTO bank (bank) VALUES
                            ('BANCO_DE_CHILE'),
                            ('BANCO_SANTANDER'),
                            ('BANCO_ESTADO'),
                            ('BANCO_ITAU'),
                            ('SCOTIABANK'),
                            ('BANCO_BICE'),
                            ('BANCO_CONSORCIO'),
                            ('BANCO_INTERNACIONAL'),
                            ('BANCO_SECURITY'),
                            ('BANCO_FALABELLA');
INSERT INTO typeAccount (type) VALUES
                                   ('CUENTA_CORRIENTE'),
                                   ('CUENTA_VISTA'),
                                   ('CUENTA_DE_AHORRO'),
                                   ('CUENTA_RUT'),
                                   ('TARJETA_DE_CREDITO');
INSERT INTO typeMovement (typeMovement) VALUES
                                            ('TRANSFERENCIA'),
                                            ('DEBITO');
insert into ACCOUNT ( balance, accountnumber, idcard, iduser) values
(100000, '1234567890', 1, 1);
insert into movement (amount, date, description, rutdestination, accountdestination, rutorigin, accountorigin, idtypemovement, IDBANK, IDACCOUNT, NAME) values
(50000, '2023-10-01', 'Transferencia a cuenta destino', '987654321', '0987654321', '123456789', '1234567890', 2, 1, 1, 'John Doe');
