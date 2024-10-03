<?php
    class Conectar{
         protected $dbh;

         protected function Conexion(){
            try{
                $conectar = $this->dbh=new PDO("sqlsrv:Server=localhost;Database=CompraVenta","sa","12345678");
                return $conectar;
            }catch(Exception $e){
                print "Error conexion bd". $e->getMessage() ."<br/>";
                die();
            }
         }
    }
?>