package com.mycompany.proyecto_lenguaje_de_base_de_datos.Test;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.SQLException;

public class EmpleadoUI extends JFrame {

    private JTable table;
    private DefaultTableModel model;
    private JTextField nameField;
    private JTextField emailField;
    private JButton addButton;
    private JButton updateButton;
    private JButton deleteButton;
    private EmpleadoDAO empleadoDAO;

    public EmpleadoUI(EmpleadoDAO empleadoDAO) {
        this.empleadoDAO = empleadoDAO;
        initUI();
    }

    private void initUI() {
        // Configuración de la ventana
        setTitle("Empleado Management");
        setSize(600, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Creación de la tabla y su modelo
        table = new JTable();
        model = new DefaultTableModel();
        model.addColumn("ID");
        model.addColumn("Name");
        model.addColumn("Email");
        table.setModel(model);

        // Creación de los campos de texto y los botones
        nameField = new JTextField(20);
        emailField = new JTextField(20);
        addButton = new JButton("Add");
        updateButton = new JButton("Update");
        deleteButton = new JButton("Delete");

        // Configuración del layout
        setLayout(new BorderLayout());
        JPanel topPanel = new JPanel();
        topPanel.setLayout(new FlowLayout());
        topPanel.add(new JLabel("Name:"));
        topPanel.add(nameField);
        topPanel.add(new JLabel("Email:"));
        topPanel.add(emailField);
        topPanel.add(addButton);
        topPanel.add(updateButton);
        topPanel.add(deleteButton);
        add(topPanel, BorderLayout.NORTH);
        add(new JScrollPane(table), BorderLayout.CENTER);

        // Carga inicial de los datos en la tabla
        try {
            List<Empleado> empleados = empleadoDAO.getAllEmpleados();
            for (Empleado empleado : empleados) {
                model.addRow(new Object[]{empleado.getId(), empleado.getName(), empleado.getEmail()});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Configuración de los eventos de los botones
        addButton.addActionListener(e -> {
            String name = nameField.getText();
            String email = emailField.getText();
            Empleado empleado = new Empleado(name, email);
            try {
                empleadoDAO.addEmpleado(empleado);
                model.addRow(new Object[]{empleado.getId(), empleado.getName(), empleado.getEmail()});
                nameField.setText("");
                emailField.setText("");
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        });

        updateButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow != -1) {
                int id = (int) model.getValueAt(selectedRow, 0);
                String name = nameField.getText();
                String email = emailField.getText();
                Empleado empleado = new Empleado(id, name, email);
                try {
                    empleadoDAO.updateEmpleado(empleado);
                    model.setValueAt(empleado.getName(), selectedRow, 1);
                    model.setValueAt(empleado.getEmail(), selectedRow, 2);
                    nameField.setText("");
                    emailField.setText("");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        });

        deleteButton.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow != -1) {
                int id = (int) model.getValueAt(selectedRow, 0);
                Empleado empleado = new Empleado(id);
                try {
                    empleadoDAO.deleteEmpleado(empleado);
                    model.removeRow(selectedRow);
                    nameField.setText("");
                    emailField.setText("");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        });

    }
}
