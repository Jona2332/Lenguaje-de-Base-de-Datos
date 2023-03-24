package com.mycompany.proyecto_lenguaje_de_base_de_datos.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.*;

public class Test {

    public class ConexionBD {

        private static final String URL = "jdbc:oracle:thin:@//localhost:1521/yourdatabase";
        private static final String USUARIO = "yourusername";
        private static final String CLAVE = "yourpassword";

        public static void main(String[] args) {
            try {
                // Conexión a la base de datos
                String url = "jdbc:oracle:thin:@localhost:1521:XE";
                String user = "user";
                String password = "password";
                Connection connection = DriverManager.getConnection(url, user, password);
                EmpleadoDAO empleadoDAO = new EmpleadoDAO(connection);

                // Creación de la interfaz gráfica de usuario
                //EmpleadoUI empleadoUI = new EmpleadoUI();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}


