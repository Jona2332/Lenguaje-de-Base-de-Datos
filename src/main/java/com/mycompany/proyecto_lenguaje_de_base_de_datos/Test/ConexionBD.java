package com.mycompany.proyecto_lenguaje_de_base_de_datos.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    private Connection connection;

    public ConexionBD(String url, String username, String password) throws SQLException {
        this.connection = DriverManager.getConnection(url, username, password);
    }

    public Connection getConnection() {
        return this.connection;
    }

    public void closeConnection() throws SQLException {
        if (this.connection != null) {
            this.connection.close();
        }
    }
    
}
