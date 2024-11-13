ALTER PROCEDURE SP_L_MENU_01
@ROL_ID INT
AS
BEGIN
	SELECT
	TD_MENU.MEND_ID,
	TD_MENU.MEN_ID,
	TD_MENU.ROL_ID,
	TD_MENU.MEND_PERMI,
	TD_MENU.FECH_CREA,
	TD_MENU.EST,
	TM_MENU.MEN_NOM,
	TM_MENU.MEN_RUTA,
	TM_MENU.MEN_IDENTI,
	TM_MENU.MEN_GRUPO
	FROM
	TD_MENU INNER JOIN
	TM_MENU ON TD_MENU.MEN_ID = TM_MENU.MEN_ID
	WHERE
	TD_MENU.ROL_ID = @ROL_ID
END

CREATE PROCEDURE [dbo].[SP_I_MENU_02]
@ROL_ID INT
AS
BEGIN
 IF (SELECT COUNT(*) FROM TD_MENU WHERE ROL_ID=@ROL_ID)=0
 BEGIN
  INSERT INTO TD_MENU
  (MEN_ID,ROL_ID,MEND_PERMI,FECH_CREA,EST)
  (SELECT MEN_ID,@ROL_ID,'No',GETDATE(),1 FROM TM_MENU WHERE EST=1)
 END
 ELSE
 BEGIN
  INSERT INTO TD_MENU
  (MEN_ID,ROL_ID,MEND_PERMI,FECH_CREA,EST)
  (SELECT MEN_ID,@ROL_ID,'No',GETDATE(),1 FROM TM_MENU WHERE EST=1 AND MEN_ID NOT IN (SELECT MEN_ID FROM TD_MENU WHERE ROL_ID=@ROL_ID))
 END
END

CREATE PROCEDURE SP_U_MENU_01
@MEND_ID INT
AS
BEGIN
	UPDATE TD_MENU
	SET
		MEND_PERMI = 'Si'
	WHERE
		MEND_ID = @MEND_ID
END

CREATE PROCEDURE SP_U_MENU_02
@MEND_ID INT
AS
BEGIN
	UPDATE TD_MENU
	SET
		MEND_PERMI = 'No'
	WHERE
		MEND_ID = @MEND_ID
END