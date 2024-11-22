use CompraVenta

--TODO: 
ALTER PROCEDURE SP_I_COMPRA_01
@SUC_ID INT,
@USU_ID INT
AS
BEGIN
SET NOCOUNT ON
	INSERT INTO TM_COMPRA 
	(SUC_ID,USU_ID,EST)
	VALUES
	(@SUC_ID,@USU_ID,2)

	SELECT COMPR_ID FROM TM_COMPRA WHERE COMPR_ID=@@IDENTITY
SET NOCOUNT OFF
END

ALTER PROCEDURE SP_I_COMPRA_02
@COMPR_ID INT,
@PROD_ID INT,
@PROD_PCOMPRA NUMERIC(18,2),
@DETC_CANT INT
AS
BEGIN
	INSERT TD_COMPRA_DETALLE
	(COMPR_ID,PROD_ID,PROD_PCOMPRA,DETC_CANT,DETC_TOTAL,FECH_CREA,EST)
	VALUES
	(@COMPR_ID,@PROD_ID,@PROD_PCOMPRA,@DETC_CANT,@PROD_PCOMPRA * @DETC_CANT,GETDATE(),1)
END

ALTER PROCEDURE SP_L_COMPRA_01 
@COMPR_ID INT
AS
BEGIN
	SELECT        
	TD_COMPRA_DETALLE.DETC_ID, 
	TM_CATEGORIA.CAT_NOM, 
	TM_PRODUCTO.PROD_NOM, 
	TM_UNIDAD.UND_NOM, 
	TD_COMPRA_DETALLE.PROD_PCOMPRA,
	TD_COMPRA_DETALLE.DETC_CANT, 
	TD_COMPRA_DETALLE.DETC_TOTAL, 
	TD_COMPRA_DETALLE.COMPR_ID, 
	TD_COMPRA_DETALLE.PROD_ID
	FROM            
	TD_COMPRA_DETALLE INNER JOIN
	TM_PRODUCTO ON TD_COMPRA_DETALLE.PROD_ID = TM_PRODUCTO.PROD_ID INNER JOIN
	TM_CATEGORIA ON TM_PRODUCTO.CAT_ID = TM_CATEGORIA.CAT_ID INNER JOIN
	TM_UNIDAD ON TM_PRODUCTO.UND_ID = TM_UNIDAD.UND_ID
	WHERE
	TD_COMPRA_DETALLE.COMPR_ID = @COMPR_ID
	AND TD_COMPRA_DETALLE.EST=1
END

ALTER PROCEDURE SP_D_COMPRA_01
@DETC_ID INT
AS
BEGIN
	UPDATE TD_COMPRA_DETALLE
	SET
		EST=0
	WHERE
		DETC_ID = @DETC_ID
END

ALTER PROCEDURE SP_U_COMPRA_01
@COMPR_ID INT
AS
BEGIN
SET NOCOUNT ON
	UPDATE TM_COMPRA
	SET
		COMPR_SUBTOTAL = (SELECT SUM(DETC_TOTAL) AS COMPR_SUBTOTAL FROM TD_COMPRA_DETALLE WHERE COMPR_ID=@COMPR_ID AND EST=1),
		COMPR_IVA = (SELECT SUM(DETC_TOTAL) AS COMPR_SUBTOTAL FROM TD_COMPRA_DETALLE WHERE COMPR_ID=@COMPR_ID AND EST=1) * 0.19,
		COMPR_TOTAL = (SELECT SUM(DETC_TOTAL) AS COMPR_SUBTOTAL FROM TD_COMPRA_DETALLE WHERE COMPR_ID=@COMPR_ID AND EST=1) + ((SELECT SUM(DETC_TOTAL) AS COMPR_SUBTOTAL FROM TD_COMPRA_DETALLE WHERE COMPR_ID=@COMPR_ID AND EST=1) * 0.19)
	WHERE
		COMPR_ID = @COMPR_ID

	SELECT 
		COMPR_SUBTOTAL,
		COMPR_IVA,
		COMPR_TOTAL 
	FROM 
		TM_COMPRA
	WHERE
		COMPR_ID = @COMPR_ID
SET NOCOUNT OFF
END


ALTER PROCEDURE SP_L_COMPRA_02
@COMPR_ID INT
AS
BEGIN
SELECT        
TM_COMPRA.COMPR_ID, 
TM_COMPRA.SUC_ID, 
TM_COMPRA.PAG_ID, 
TM_COMPRA.PROV_ID, 
TM_COMPRA.PROV_RUT, 
TM_COMPRA.PROV_DIRECC, 
TM_COMPRA.PROV_CORREO, 
TM_COMPRA.COMPR_SUBTOTAL, 
TM_COMPRA.COMPR_IVA, 
TM_COMPRA.COMPR_TOTAL, 
TM_COMPRA.COMPR_COMENT, 
TM_COMPRA.USU_ID, 
TM_COMPRA.MON_ID, 
TM_COMPRA.FECH_CREA, 
TM_COMPRA.EST, 
TM_SUCURSAL.SUC_NOM, 
TM_EMPRESA.EMP_NOM, 
TM_EMPRESA.EMP_RUT, 
TM_EMPRESA.EMP_CORREO, 
TM_EMPRESA.EMP_TELF, 
TM_EMPRESA.EMP_DIRECC, 
TM_EMPRESA.EMP_PAG, 
TM_COMPANIA.COM_NOM, 
TM_USUARIO.USU_CORREO, 
TM_USUARIO.USU_NOM, 
TM_USUARIO.USU_APE, 
TM_USUARIO.USU_CC, 
TM_USUARIO.USU_TELF, 
TM_ROL.ROL_NOM, 
TM_PAGO.PAG_NOM, 
TM_MONEDA.MON_NOM,
TM_PROVEEDOR.PROV_NOM
FROM            
TM_COMPRA INNER JOIN
TM_SUCURSAL ON TM_COMPRA.SUC_ID = TM_SUCURSAL.SUC_ID INNER JOIN
TM_EMPRESA ON TM_SUCURSAL.EMP_ID = TM_EMPRESA.EMP_ID INNER JOIN
TM_COMPANIA ON TM_EMPRESA.COM_ID = TM_COMPANIA.COM_ID INNER JOIN
TM_USUARIO ON TM_COMPRA.USU_ID = TM_USUARIO.USU_ID INNER JOIN
TM_ROL ON TM_USUARIO.ROL_ID = TM_ROL.ROL_ID INNER JOIN
TM_PAGO ON TM_COMPRA.PAG_ID = TM_PAGO.PAG_ID INNER JOIN
TM_MONEDA ON TM_COMPRA.MON_ID = TM_MONEDA.MON_ID INNER JOIN
TM_PROVEEDOR ON TM_COMPRA.PROV_ID = TM_PROVEEDOR.PROV_ID
WHERE  
TM_COMPRA.COMPR_ID = @COMPR_ID
END

  
ALTER PROCEDURE [dbo].[SP_U_COMPRA_03]  
@COMPR_ID INT,  
@PAG_ID INT,  
@PROV_ID INT,  
@PROV_RUT VARCHAR(20),  
@PROV_DIRECC VARCHAR(150),  
@PROV_CORREO VARCHAR(150),  
@COMPR_COMENT VARCHAR(250),  
@MON_ID INT  
AS  
BEGIN  
 UPDATE TM_COMPRA  
 SET  
  PAG_ID = @PAG_ID,  
  PROV_ID = @PROV_ID,  
  PROV_RUT = @PROV_RUT,  
  PROV_DIRECC = @PROV_DIRECC,  
  PROV_CORREO = @PROV_CORREO,  
  COMPR_COMENT = @COMPR_COMENT,  
  MON_ID = @MON_ID,  
  FECH_CREA = GETDATE(),  
  EST = 1  
 WHERE  
  COMPR_ID = @COMPR_ID  
   
 DECLARE @ID_REGISTRO INT  
 DECLARE @PROD_ID INT  
 DECLARE @CANT INT  
  
 DECLARE CUR CURSOR FOR SELECT DETC_ID FROM TD_COMPRA_DETALLE WHERE COMPR_ID=@COMPR_ID  
 OPEN CUR  
 FETCH NEXT FROM CUR INTO @ID_REGISTRO  
 WHILE @@FETCH_STATUS=0  
  BEGIN  
   SELECT @PROD_ID=PROD_ID FROM TD_COMPRA_DETALLE WHERE DETC_ID = @ID_REGISTRO  
     
   SELECT @CANT=DETC_CANT FROM TD_COMPRA_DETALLE WHERE DETC_ID = @ID_REGISTRO  
  
   UPDATE TM_PRODUCTO  
   SET  
    PROD_STOCK = PROD_STOCK + @CANT  
   WHERE  
    PROD_ID = @PROD_ID  
  
   FETCH NEXT FROM CUR INTO @ID_REGISTRO  
  END  
 CLOSE CUR  
 DEALLOCATE CUR  
END

ALTER PROCEDURE SP_L_COMPRA_03  
@SUC_ID INT  
AS  
BEGIN  
 SELECT          
 TM_COMPRA.COMPR_ID,   
 TM_COMPRA.SUC_ID,   
 TM_COMPRA.PAG_ID,   
 TM_COMPRA.PROV_ID,   
 TM_COMPRA.PROV_RUT,   
 TM_COMPRA.PROV_DIRECC,   
 TM_COMPRA.PROV_CORREO,   
 TM_COMPRA.COMPR_SUBTOTAL,   
 TM_COMPRA.COMPR_IVA,   
 TM_COMPRA.COMPR_TOTAL,   
 TM_COMPRA.COMPR_COMENT,   
 TM_COMPRA.USU_ID,   
 TM_COMPRA.MON_ID,   
 TM_COMPRA.FECH_CREA,   
 TM_COMPRA.EST,   
 TM_SUCURSAL.SUC_NOM,   
 TM_EMPRESA.EMP_NOM,   
 TM_EMPRESA.EMP_RUT,   
 TM_EMPRESA.EMP_CORREO,   
 TM_EMPRESA.EMP_TELF,   
 TM_EMPRESA.EMP_DIRECC,   
 TM_EMPRESA.EMP_PAG,   
 TM_COMPANIA.COM_NOM,   
 TM_USUARIO.USU_CORREO,   
 TM_USUARIO.USU_NOM,   
 TM_USUARIO.USU_APE,   
 TM_USUARIO.USU_CC,   
 TM_USUARIO.USU_TELF,   
 TM_ROL.ROL_NOM,   
 TM_PAGO.PAG_NOM,   
 TM_MONEDA.MON_NOM,  
 TM_PROVEEDOR.PROV_NOM  
 FROM              
 TM_COMPRA INNER JOIN  
 TM_SUCURSAL ON TM_COMPRA.SUC_ID = TM_SUCURSAL.SUC_ID INNER JOIN  
 TM_EMPRESA ON TM_SUCURSAL.EMP_ID = TM_EMPRESA.EMP_ID INNER JOIN  
 TM_COMPANIA ON TM_EMPRESA.COM_ID = TM_COMPANIA.COM_ID INNER JOIN  
 TM_USUARIO ON TM_COMPRA.USU_ID = TM_USUARIO.USU_ID INNER JOIN  
 TM_ROL ON TM_USUARIO.ROL_ID = TM_ROL.ROL_ID INNER JOIN  
 TM_PAGO ON TM_COMPRA.PAG_ID = TM_PAGO.PAG_ID INNER JOIN  
 TM_MONEDA ON TM_COMPRA.MON_ID = TM_MONEDA.MON_ID INNER JOIN  
 TM_PROVEEDOR ON TM_COMPRA.PROV_ID = TM_PROVEEDOR.PROV_ID  
 WHERE  
 TM_COMPRA.EST=1  
 AND TM_COMPRA.SUC_ID = @SUC_ID  
END

