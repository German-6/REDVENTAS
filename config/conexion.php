<?php
    session_start();
    class Conectar{
         protected $dbh;

         public function Conexion(){
            try{
                $conectar = $this->dbh=new PDO("sqlsrv:Server=localhost;Database=CompraVenta","sa","12345678");
                $conectar->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                return $conectar;
            }catch(Exception $e){
                print "Error conexion bd". $e->getMessage() ."<br/>";
                die("Error de conexión a la base de datos: " . $e->getMessage());
            }
         }
         public static function ruta(){
            /* TODO: Ruta de acceso del Proyecto */
            return "http://localhost:80/REDVENTAS/";

        }
        // Obtener los datos para el combo box
}

?>