use CompraVenta

ALTER PROCEDURE SP_L_PAGO_01

AS
BEGIN
	SELECT * FROM TM_PAGO WHERE EST=1
END