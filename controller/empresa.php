<?php
    /* TODO: Llamando Clases */
    require_once("../config/conexion.php");
    require_once("../models/Empresa.php");
    /* TODO: Inicializando clase */
    $empresa = new Empresa();

    switch($_GET["op"]){
        /* TODO: Guardar y editar, guardar cuando el ID este vacio, y Actualizar cuando se envie el ID */
        case "guardaryeditar":
            if(empty($_POST["emp_id"])){
                $empresa->insert_empresa($_POST["com_id"], $_POST["emp_nom"], $_POST["emp_rut"]);
            }else{
                $empresa->update_empresa($_POST["emp_id"],$_POST["com_id"], $_POST["emp_nom"], $_POST["emp_rut"]);
            }
            break;

        /* TODO: Listado de registros formato JSON para Datatables JS */
        case "listar":
            $datos=$empresa->get_empresa_x_com_id($_POST["com_id"]);
            $data=Array();
            foreach($datos as $row){
                $sub_array = array();
                $sub_array = $row["emp_nom"];
                $sub_array = "Editar";
                $sub_array = "Eliminar";
                $data[] =$sub_array;
            }

            $results = array (
                "sEcho"=>1,
                "iTotalRecords"=>count($data),
                "iTotalDisplayRecords"=>count($data),
                "aaData"=>$data);
            echo json_encode($results);
            break;

        /* TODO: Mostrar informacion de registro segun su ID */
        case "mostrar":
            $datos=$empresa->get_empresa_x_emp_id($_POST["emp_id"]);
            if(is_array($datos)==true and count ($datos)>0){
                foreach($datos as $row){
                    $output["emp_id"] = $row["emp_id"];
                    $output["com_id"] = $row["com_id"];
                    $output["emp_nom"] = $row["emp_nom"];
                    $output["emp_rut"] = $row["emp_rut"];
                }
                echo json_encode($output);
            }
            break;

        /* TODO: Cambiar estado a 0 del registro */
        case "eliminar";
            $empresa->delete_empresa($_POST["emp_id"]);
            break;
    }
?>