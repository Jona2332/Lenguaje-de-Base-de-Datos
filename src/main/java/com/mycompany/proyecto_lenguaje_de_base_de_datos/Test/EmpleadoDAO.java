package com.mycompany.proyecto_lenguaje_de_base_de_datos.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {
    private Connection connection;

    public EmpleadoDAO(Connection connection) {
        this.connection = connection;
    }

    public List<Empleado> getAllEmpleados() throws SQLException {
        List<Empleado> empleados = new ArrayList<>();

        try (PreparedStatement statement = this.connection.prepareStatement("SELECT * FROM empleados");
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String email = resultSet.getString("email");
                Empleado empleado = new Empleado(id, name, email);
                empleados.add(empleado);
            }
        }

        return empleados;
    }

    public void addEmpleado(Empleado empleado) throws SQLException {
        try (PreparedStatement statement = this.connection.prepareStatement("INSERT INTO empleados (name, email) VALUES (?, ?)")) {
            statement.setString(1, empleado.getName());
            statement.setString(2, empleado.getEmail());
            statement.executeUpdate();
        }
    }

    public void updateEmpleado(Empleado empleado) throws SQLException {
        try (PreparedStatement statement = this.connection.prepareStatement("UPDATE empleados SET name = ?, email = ? WHERE id = ?")) {
            statement.setString(1, empleado.getName());
            statement.setString(2, empleado.getEmail());
            statement.setInt(3, empleado.getId());
            statement.executeUpdate();
        }
    }

    public void deleteEmpleado(Empleado empleado) throws SQLException {
        try (PreparedStatement statement = this.connection.prepareStatement("DELETE FROM empleados WHERE id = ?")) {
            statement.setInt(1, empleado.getId());
            statement.executeUpdate();
        }
    }
}
