ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-------------------------------------------------------------------------------------------------CLIENTES--------------------------------------------------------------------------------------------------

-- Crear tabla Cliente
CREATE TABLE Cliente (
  id_cliente INT PRIMARY KEY,
  cedula VARCHAR(20),
  nombre VARCHAR(50),
  primer_apellido VARCHAR(50),
  segundo_apellido VARCHAR(50),
  direccion VARCHAR(255),
  telefono VARCHAR(15)
);

CREATE OR REPLACE PROCEDURE listar_clientes (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR SELECT * FROM Cliente;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar los clientes: ' || SQLERRM);
END;

-- Procedimiento Insertar clientes
CREATE OR REPLACE PROCEDURE insertar_cliente(
    id_cliente_in IN INT,
	cedula_in IN VARCHAR2,
    nombre_in IN VARCHAR2,
    primer_apellido_in IN VARCHAR2,
    segundo_apellido_in IN VARCHAR2,
    direccion_in IN VARCHAR2,
    telefono_in IN VARCHAR2
) AS
BEGIN
    INSERT INTO Cliente (id_cliente, cedula, nombre, primer_apellido, segundo_apellido, direccion, telefono)
    VALUES (id_cliente_in, cedula_in, nombre_in, primer_apellido_in, segundo_apellido_in, direccion_in, telefono_in);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente ha sido insertado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el cliente: ' || SQLERRM);
END;

-- Procedimiento Modificar clientes
CREATE OR REPLACE PROCEDURE modificar_cliente(
    id_cliente_in IN INT,
    nombre_in IN VARCHAR2,
	cedula_in IN VARCHAR2,
    primer_apellido_in IN VARCHAR2,
    segundo_apellido_in IN VARCHAR2,
    direccion_in IN VARCHAR2,
    telefono_in IN VARCHAR2
) AS
BEGIN
    UPDATE Cliente SET
        nombre = nombre_in,
		cedula = cedula_in,
        primer_apellido = primer_apellido_in,
        segundo_apellido = segundo_apellido_in,
        direccion = direccion_in,
        telefono = telefono_in
    WHERE id_cliente = id_cliente_in;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente ha sido modificado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al modificar el cliente: ' || SQLERRM);
END;

-- Procedimiento Eliminar clientes
CREATE OR REPLACE PROCEDURE eliminar_cliente(
    id_cliente_in IN INT
) AS
BEGIN
    DELETE FROM Cliente WHERE id_cliente = id_cliente_in;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente ha sido eliminado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el cliente: ' || SQLERRM);
END;


------------------------------------------------------------------------------------------LOGIN--------------------------------------------------------------------------------------------------------------

--Tabla Login
CREATE TABLE usuarios (
  id NUMBER(10) PRIMARY KEY,
  username VARCHAR2(50) NOT NULL,
  password VARCHAR2(50) NOT NULL,
  rol VARCHAR2(20) NOT NULL
);

--Inserts de prueba
INSERT INTO usuarios (id, username, password, rol) VALUES (1, 'admin', 'admin123', 'administrador');
INSERT INTO usuarios (id, username, password, rol) VALUES (2, 'cliente1', 'cliente123', 'cliente');
INSERT INTO usuarios (id, username, password, rol) VALUES (3, 'cliente2', 'cliente123', 'cliente');

--Procedimeinto login
CREATE OR REPLACE PROCEDURE login_proc (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2,
    p_rol OUT VARCHAR2
) AS
BEGIN
    SELECT rol INTO p_rol
    FROM usuarios
    WHERE username = p_username AND password = p_password;
END;

-------------------------------------------------------------------------------------------------------PRODUCTOS--------------------------------------------------------------------------------------------------

-- Crear tabla Producto
CREATE TABLE Producto (
  codigo_producto INT PRIMARY KEY,
  nombre_producto VARCHAR(50),
  precio_compra FLOAT
);

CREATE OR REPLACE PROCEDURE InsertarProducto(
    p_codigo_producto IN INT,
    p_nombre_producto IN VARCHAR2,
    p_precio_compra IN FLOAT
)
IS
BEGIN
    INSERT INTO Producto(codigo_producto, nombre_producto, precio_compra)
    VALUES(p_codigo_producto, p_nombre_producto, p_precio_compra);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido insertado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el producto: ' || SQLERRM);
        ROLLBACK;
END InsertarProducto;

CREATE OR REPLACE PROCEDURE ModificarProducto(
    p_codigo_producto IN INT,
    p_nombre_producto IN VARCHAR2,
    p_precio_compra IN FLOAT
)
IS
BEGIN
    UPDATE Producto
    SET nombre_producto = p_nombre_producto, precio_compra = p_precio_compra
    WHERE codigo_producto = p_codigo_producto;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido modificado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al modificar el producto: ' || SQLERRM);
        ROLLBACK;
END ModificarProducto;

CREATE OR REPLACE PROCEDURE ListarProductos (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR SELECT * FROM Producto;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar los productos: ' || SQLERRM);
END;

CREATE OR REPLACE PROCEDURE EliminarProducto(
    p_codigo_producto IN INT
)
IS
BEGIN
    DELETE FROM Producto WHERE codigo_producto = p_codigo_producto;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido eliminado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al eliminar el producto: ' || SQLERRM);
        ROLLBACK;
END EliminarProducto;



--------------------------------------------------------------------------------------------EMPLEADOS------------------------------------------------------------------------------------------------------
-- Crear tabla Puesto
CREATE TABLE Puesto (
  id_puesto INT PRIMARY KEY,
  nombre_puesto VARCHAR(50),
  descripcion_puesto VARCHAR(255)
);

-- Crear tabla Empleado
CREATE TABLE Empleado (
  id_empleado INT PRIMARY KEY,
  nombre VARCHAR(50),
  primer_apellido VARCHAR(50),
  segundo_apellido VARCHAR(50),
  salario FLOAT,
  id_puesto INT,
  FOREIGN KEY (id_puesto) REFERENCES Puesto(id_puesto)
);

CREATE OR REPLACE PROCEDURE insertar_puesto(
  id_puesto IN INT,
  nombre_puesto IN VARCHAR2,
  descripcion_puesto IN VARCHAR2
) AS
BEGIN
  INSERT INTO Puesto(id_puesto, nombre_puesto, descripcion_puesto)
  VALUES(id_puesto, nombre_puesto, descripcion_puesto);
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE modificar_puesto(
  id_puesto_modificar IN INT,
  nombre_puesto_modificar IN VARCHAR2,
  descripcion_puesto_modificar IN VARCHAR2
) AS
BEGIN
  UPDATE Puesto
  SET nombre_puesto = nombre_puesto_modificar, descripcion_puesto = descripcion_puesto_modificar
  WHERE id_puesto = id_puesto_modificar;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE listar_puestos AS
BEGIN
  FOR puesto IN (SELECT * FROM Puesto)
  LOOP
    DBMS_OUTPUT.PUT_LINE(puesto.id_puesto || ' | ' || puesto.nombre_puesto || ' | ' || puesto.descripcion_puesto);
  END LOOP;
END;



CREATE OR REPLACE PROCEDURE eliminar_puesto(id_puesto_eliminar IN INT) AS
BEGIN
  DELETE FROM Puesto WHERE id_puesto = id_puesto_eliminar;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE insertar_empleado(
    p_id_empleado IN INT,
    p_nombre IN VARCHAR2,
    p_primer_apellido IN VARCHAR2,
    p_segundo_apellido IN VARCHAR2,
    p_salario IN FLOAT,
    p_id_puesto IN INT
)
AS
BEGIN
    INSERT INTO Empleado(id_empleado, nombre, primer_apellido, segundo_apellido, salario, id_puesto)
    VALUES (p_id_empleado, p_nombre, p_primer_apellido, p_segundo_apellido, p_salario, p_id_puesto);
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE modificar_empleado(
    p_id_empleado IN INT,
    p_nombre IN VARCHAR2,
    p_primer_apellido IN VARCHAR2,
    p_segundo_apellido IN VARCHAR2,
    p_salario IN FLOAT,
    p_id_puesto IN INT
)
AS
BEGIN
    UPDATE Empleado
    SET nombre = p_nombre,
        primer_apellido = p_primer_apellido,
        segundo_apellido = p_segundo_apellido,
        salario = p_salario,
        id_puesto = p_id_puesto
    WHERE id_empleado = p_id_empleado;
    COMMIT;
END;



CREATE OR REPLACE PROCEDURE listar_empleados AS
   BEGIN
  FOR empleado IN (SELECT * FROM Empleado)
  LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido|| ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario|| ' | ' || empleado.id_puesto);
  END LOOP;
END;


CREATE OR REPLACE PROCEDURE eliminar_empleado(
    p_id_empleado IN INT
)
AS
BEGIN
    DELETE FROM Empleado
    WHERE id_empleado = p_id_empleado;
    COMMIT;
END;

-- Crear secuencia para Empleado
CREATE SEQUENCE empleado_id_seq START WITH 1 INCREMENT BY 1;


-- Crear trigger para Empleado que utiliza la secuencia
CREATE OR REPLACE TRIGGER empleado_id_trg
BEFORE INSERT ON Empleado
FOR EACH ROW
BEGIN
    SELECT empleado_id_seq.NEXTVAL INTO :new.id_empleado FROM dual;
END;

-- Crear secuencia para Puesto
CREATE SEQUENCE puesto_seq START WITH 1 INCREMENT BY 1;

-- Crear trigger para Puesto que utiliza la secuencia
CREATE OR REPLACE TRIGGER puesto_trigger
BEFORE INSERT ON Puesto
FOR EACH ROW
BEGIN
:NEW.id_puesto := puesto_seq.NEXTVAL;
END;


-----------------------------------------------------------------------------------------EMPRESA---------------------------------------------------------------------------------------------------------------

-- Crear tabla Empresa
CREATE TABLE Empresa (
  id_empresa INT PRIMARY KEY,
  nombre_empresa VARCHAR(50),
  ubicacion_empresa VARCHAR(50)
);

-- Crear tabla Contacto_Empresa
CREATE TABLE Contacto_Empresa (
  id_contacto INT PRIMARY KEY,
  id_empresa INT,
  nombre_contacto VARCHAR(50),
  telefono VARCHAR(15),
  FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);


CREATE OR REPLACE PROCEDURE insertar_empresa(
  id_empresa IN INT,
  nombre_empresa IN VARCHAR2,
  ubicacion_empresa IN VARCHAR2
) AS
BEGIN
  INSERT INTO Empresa(id_empresa, nombre_empresa, ubicacion_empresa)
  VALUES(id_empresa, nombre_empresa, ubicacion_empresa);
  COMMIT;
END;


CREATE OR REPLACE PROCEDURE modificar_empresa(
  id_empresa_modificar IN INT,
  nombre_empresa_modificar IN VARCHAR2,
  ubicacion_empresa_modificar IN VARCHAR2
) AS
BEGIN
  UPDATE Empresa
  SET nombre_empresa = nombre_empresa_modificar, ubicacion_empresa = ubicacion_empresa_modificar
  WHERE id_empresa = id_empresa_modificar;
  COMMIT;
END;


CREATE OR REPLACE PROCEDURE listar_empresas AS
BEGIN
  FOR empresa IN (SELECT * FROM Empresa)
  LOOP
    DBMS_OUTPUT.PUT_LINE(empresa.id_empresa || ' | ' || empresa.nombre_empresa || ' | ' || empresa.ubicacion_empresa);
  END LOOP;
END;


CREATE OR REPLACE PROCEDURE eliminar_empresa(id_empresa_eliminar IN INT) AS
BEGIN
  DELETE FROM Empresa WHERE id_empresa = id_empresa_eliminar;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE insertar_contacto_empresa (
    p_id_contacto IN Contacto_Empresa.id_contacto%TYPE,
    p_id_empresa IN Contacto_Empresa.id_empresa%TYPE,
    p_nombre_contacto IN Contacto_Empresa.nombre_contacto%TYPE,
    p_telefono IN Contacto_Empresa.telefono%TYPE
) AS
BEGIN
    INSERT INTO Contacto_Empresa (id_contacto, id_empresa, nombre_contacto, telefono)
    VALUES (p_id_contacto, p_id_empresa, p_nombre_contacto, p_telefono);
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE modificar_contacto_empresa (
    p_id_contacto IN Contacto_Empresa.id_contacto%TYPE,
    p_id_empresa IN Contacto_Empresa.id_empresa%TYPE,
    p_nombre_contacto IN Contacto_Empresa.nombre_contacto%TYPE,
    p_telefono IN Contacto_Empresa.telefono%TYPE
) AS
BEGIN
    UPDATE Contacto_Empresa
    SET id_empresa = p_id_empresa,
        nombre_contacto = p_nombre_contacto,
        telefono = p_telefono
    WHERE id_contacto = p_id_contacto;
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE listar_contactos_empresa IS
BEGIN
FOR contactos IN (SELECT * FROM Contacto_Empresa)
    LOOP
     DBMS_OUTPUT.PUT_LINE('ID Contacto Empresa: ' || contactos.id_contacto || ' | ' ||
                             'ID Empresa: ' || contactos.id_empresa || ' | ' ||
                             'Nombre Contacto: ' || contactos.nombre_contacto || ' | ' ||
                             'Telefono Contacto: ' || contactos.telefono);
END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar contactos de empresa.');
END listar_contactos_empresa;


CREATE OR REPLACE PROCEDURE eliminar_contacto_empresa (
    p_id_contacto IN Contacto_Empresa.id_contacto%TYPE
) AS
BEGIN
    DELETE FROM Contacto_Empresa
    WHERE id_contacto = p_id_contacto;
    COMMIT;
END;

----------------------------------------------------------------------------------------PUESTO----------------------------------------------------------------------------------------------------------------

-- Crear tabla Puesto
CREATE TABLE Puesto (
  id_puesto INT PRIMARY KEY,
  nombre_puesto VARCHAR(50),
  descripcion_puesto VARCHAR(255)
);


CREATE OR REPLACE PROCEDURE insertar_puesto(
  id_puesto IN INT,
  nombre_puesto IN VARCHAR2,
  descripcion_puesto IN VARCHAR2
) AS
BEGIN
  INSERT INTO Puesto(id_puesto, nombre_puesto, descripcion_puesto)
  VALUES(id_puesto, nombre_puesto, descripcion_puesto);
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE modificar_puesto(
  id_puesto_modificar IN INT,
  nombre_puesto_modificar IN VARCHAR2,
  descripcion_puesto_modificar IN VARCHAR2
) AS
BEGIN
  UPDATE Puesto
  SET nombre_puesto = nombre_puesto_modificar, descripcion_puesto = descripcion_puesto_modificar
  WHERE id_puesto = id_puesto_modificar;
  COMMIT;
END;

CREATE OR REPLACE PROCEDURE listar_puestos AS
BEGIN
  FOR puesto IN (SELECT * FROM Puesto)
  LOOP
    DBMS_OUTPUT.PUT_LINE(puesto.id_puesto || ' | ' || puesto.nombre_puesto || ' | ' || puesto.descripcion_puesto);
  END LOOP;
END;



CREATE OR REPLACE PROCEDURE eliminar_puesto(id_puesto_eliminar IN INT) AS
BEGIN
  DELETE FROM Puesto WHERE id_puesto = id_puesto_eliminar;
  COMMIT;
END;

--------------------------------------------------------------------------------------VENTA--------------------------------------------------------------------------------------------------------------------

-- Crear tabla Venta
CREATE TABLE Venta (
  id_venta INT PRIMARY KEY,
  id_empleado INT,
  id_cliente INT,
  fecha DATE,
  monto FLOAT,
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Crear tabla Detalle_Venta
CREATE TABLE Detalle_Venta (
  id_detalle_venta INT PRIMARY KEY,
  id_venta INT,
  codigo_producto INT,
  cantidad INT,
  descuento FLOAT,
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto)
);


CREATE OR REPLACE PROCEDURE insertar_venta (
    p_id_venta IN Venta.id_venta%TYPE,
    p_id_empleado IN Venta.id_empleado%TYPE,
    p_id_cliente IN Venta.id_cliente%TYPE,
    p_fecha IN Venta.fecha%TYPE,
    p_monto IN Venta.monto%TYPE
)
IS
BEGIN
    INSERT INTO Venta(id_venta, id_empleado, id_cliente, fecha, monto)
    VALUES(p_id_venta, p_id_empleado, p_id_cliente, p_fecha, p_monto);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Venta registrada correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al registrar la venta.');
END;

CREATE OR REPLACE PROCEDURE modificar_venta (
    p_id_venta IN Venta.id_venta%TYPE,
    p_id_empleado IN Venta.id_empleado%TYPE,
    p_id_cliente IN Venta.id_cliente%TYPE,
    p_fecha IN Venta.fecha%TYPE,
    p_monto IN Venta.monto%TYPE
)
IS
BEGIN
    UPDATE Venta
    SET id_empleado = p_id_empleado,
        id_cliente = p_id_cliente,
        fecha = p_fecha,
        monto = p_monto
    WHERE id_venta = p_id_venta;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Venta modificada correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al modificar la venta.');
END;


CREATE OR REPLACE PROCEDURE listar_ventas IS
BEGIN
    FOR venta IN (SELECT * FROM Venta)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Id de venta: ' || venta.id_venta ||
                             ', Id de empleado: ' || venta.id_empleado ||
                             ', Id de cliente: ' || venta.id_cliente ||
                             ', Fecha: ' || venta.fecha ||
                             ', Monto: ' || venta.monto);
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE eliminar_venta (p_id_venta IN Venta.id_venta%TYPE)
IS
BEGIN
    DELETE FROM Venta WHERE id_venta = p_id_venta;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Venta eliminada correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar la venta.');
END;




-- Procedimiento para insertar un detalle de venta
CREATE OR REPLACE PROCEDURE Insertar_Detalle_Venta(
p_id_detalle_venta IN DETALLE_VENTA.ID_DETALLE_VENTA%TYPE,
p_id_venta IN DETALLE_VENTA.ID_VENTA%TYPE,
p_codigo_producto IN DETALLE_VENTA.CODIGO_PRODUCTO%TYPE,
p_cantidad IN DETALLE_VENTA.CANTIDAD%TYPE,
p_descuento IN DETALLE_VENTA.DESCUENTO%TYPE
) AS
BEGIN
INSERT INTO DETALLE_VENTA(ID_DETALLE_VENTA, ID_VENTA, CODIGO_PRODUCTO, CANTIDAD, DESCUENTO) VALUES (p_id_detalle_venta, p_id_venta, p_codigo_producto, p_cantidad, p_descuento);
COMMIT;
END Insertar_Detalle_Venta;

-- Procedimiento para modificar un detalle de venta
CREATE OR REPLACE PROCEDURE Modificar_Detalle_Venta(
p_id_detalle_venta IN DETALLE_VENTA.ID_DETALLE_VENTA%TYPE,
p_id_venta IN DETALLE_VENTA.ID_VENTA%TYPE,
p_codigo_producto IN DETALLE_VENTA.CODIGO_PRODUCTO%TYPE,
p_cantidad IN DETALLE_VENTA.CANTIDAD%TYPE,
p_descuento IN DETALLE_VENTA.DESCUENTO%TYPE
) AS
BEGIN
UPDATE DETALLE_VENTA SET ID_VENTA = p_id_venta, CODIGO_PRODUCTO = p_codigo_producto, CANTIDAD = p_cantidad, DESCUENTO = p_descuento WHERE ID_DETALLE_VENTA = p_id_detalle_venta;
COMMIT;
END Modificar_Detalle_Venta;

CREATE OR REPLACE PROCEDURE listar_detalle_venta IS
BEGIN
FOR listar_detalle IN (SELECT * FROM Detalle_Venta)
    LOOP
 DBMS_OUTPUT.PUT_LINE('Id de detalle de venta: ' || listar_detalle.id_detalle_venta ||
                             ', Id de venta: ' || listar_detalle.id_venta ||
                             ', Codigo de producto: ' || listar_detalle.codigo_producto ||
                             ', Cantidad: ' || listar_detalle.cantidad ||
                             ', Monto: ' || listar_detalle.descuento);
    END LOOP;
END;


-- Procedimiento para eliminar un detalle de venta
CREATE OR REPLACE PROCEDURE Eliminar_Detalle_Venta(
p_id_detalle_venta IN DETALLE_VENTA.ID_DETALLE_VENTA%TYPE
) AS
BEGIN
DELETE FROM DETALLE_VENTA WHERE ID_DETALLE_VENTA = p_id_detalle_venta;
COMMIT;
END Eliminar_Detalle_Venta;




--------------------------------------------------------------------------------------COMPRA---------------------------------------------------------------------------------------------------------------

-- Crear tabla Compra
CREATE TABLE Compra (
  id_compra INT PRIMARY KEY,
  id_empleado INT,
  id_empresa INT,
  monto FLOAT,
  fecha VARCHAR(20),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
  FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);

-- Crear tabla Detalle_Compra
CREATE TABLE Detalle_Compra (
  id_detalle_compra INT PRIMARY KEY,
  id_compra INT,
  codigo_producto INT,
  cantidad INT,
  precio_compra FLOAT,
  FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo_producto),
	FOREIGN KEY (id_compra) REFERENCES Compra(id_compra)
);

CREATE OR REPLACE PROCEDURE insertar_compra(
  p_id_compra IN Compra.id_compra%TYPE,
  p_id_empleado IN Compra.id_empleado%TYPE,
  p_id_empresa IN Compra.id_empresa%TYPE,
  p_monto IN Compra.monto%TYPE,
  p_fecha IN Compra.fecha%TYPE
) AS
BEGIN
  INSERT INTO Compra(id_compra, id_empleado, id_empresa, monto, fecha)
  VALUES (p_id_compra, p_id_empleado, p_id_empresa, p_monto, p_fecha);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Compra registrada exitosamente.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error al registrar la compra: ' || SQLERRM);
END;



CREATE OR REPLACE PROCEDURE modificar_compra(
  p_id_compra IN Compra.id_compra%TYPE,
  p_id_empleado IN Compra.id_empleado%TYPE,
  p_id_empresa IN Compra.id_empresa%TYPE,
  p_monto IN Compra.monto%TYPE,
  p_fecha IN Compra.fecha%TYPE
) AS
BEGIN
  UPDATE Compra
  SET id_empleado = p_id_empleado,
      id_empresa = p_id_empresa,
      monto = p_monto,
      fecha = p_fecha
  WHERE id_compra = p_id_compra;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Compra actualizada exitosamente.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error al actualizar la compra: ' || SQLERRM);
END;



CREATE OR REPLACE PROCEDURE listar_compras AS
BEGIN
  FOR compra IN (SELECT * FROM Compra)
  LOOP
    DBMS_OUTPUT.PUT_LINE('ID de la compra: ' || compra.id_compra ||
                         ', ID del empleado: ' || compra.id_empleado ||
                         ', ID de la empresa: ' || compra.id_empresa ||
                         ', Monto: ' || compra.monto ||
                         ', Fecha: ' || compra.fecha);
  END LOOP;
END;



CREATE OR REPLACE PROCEDURE eliminar_compra(p_id_compra IN Compra.id_compra%TYPE) AS
BEGIN
  DELETE FROM Compra
  WHERE id_compra = p_id_compra;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Compra eliminada exitosamente.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error al eliminar la compra: ' || SQLERRM);
END;


CREATE OR REPLACE PROCEDURE insertar_detalle_compra (
    p_id_detalle_compra IN Detalle_Compra.id_detalle_compra%TYPE,
    p_id_compra IN Detalle_Compra.id_compra%TYPE,
    p_codigo_producto IN Detalle_Compra.codigo_producto%TYPE,
    p_cantidad IN Detalle_Compra.cantidad%TYPE,
    p_precio_compra IN Detalle_Compra.precio_compra%TYPE
)
IS
BEGIN
    INSERT INTO Detalle_Compra (id_detalle_compra, id_compra, codigo_producto, cantidad, precio_compra)
    VALUES (p_id_detalle_compra, p_id_compra, p_codigo_producto, p_cantidad, p_precio_compra);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de compra insertado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar detalle de compra.');
END insertar_detalle_compra;


CREATE OR REPLACE PROCEDURE modificar_detalle_compra (
    p_id_detalle_compra IN Detalle_Compra.id_detalle_compra%TYPE,
    p_id_compra IN Detalle_Compra.id_compra%TYPE,
    p_codigo_producto IN Detalle_Compra.codigo_producto%TYPE,
    p_cantidad IN Detalle_Compra.cantidad%TYPE,
    p_precio_compra IN Detalle_Compra.precio_compra%TYPE
)
IS
BEGIN
    UPDATE Detalle_Compra
    SET id_compra = p_id_compra,
        codigo_producto = p_codigo_producto,
        cantidad = p_cantidad,
        precio_compra = p_precio_compra
    WHERE id_detalle_compra = p_id_detalle_compra;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de compra modificado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al modificar detalle de compra.');
END modificar_detalle_compra;



CREATE OR REPLACE PROCEDURE eliminar_detalle_compra (p_id_detalle_compra IN Detalle_Compra.id_detalle_compra%TYPE)
IS
BEGIN
    DELETE FROM Detalle_Compra WHERE id_detalle_compra = p_id_detalle_compra;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Detalle de compra eliminado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar detalle de compra.');
END eliminar_detalle_compra;


CREATE OR REPLACE PROCEDURE listar_detalle_compra
IS
BEGIN
    FOR detalle IN (SELECT * FROM Detalle_Compra)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID detalle de compra: ' || detalle.id_detalle_compra || ' | ' ||
                             'ID compra: ' || detalle.id_compra || ' | ' ||
                             'Código de producto: ' || detalle.codigo_producto || ' | ' ||
                             'Cantidad: ' || detalle.cantidad || ' | ' ||
                             'Precio de compra: ' || detalle.precio_compra);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al listar detalles de compra.');
END listar_detalle_compra;


-- VISTAS 

-- Vista que muestra el nombre de la empresa, el nombre del contacto y el teléfono de cada contacto:

CREATE VIEW vw_contactos_empresas AS
SELECT e.nombre_empresa, c.nombre_contacto, c.telefono
FROM Contacto_Empresa c
INNER JOIN Empresa e ON c.id_empresa = e.id_empresa;


--Vista que muestra el nombre, primer apellido, segundo apellido y salario de cada empleado junto con el nombre y descripción del puesto que ocupa:

CREATE VIEW vw_empleados_puestos AS
SELECT emp.nombre, emp.primer_apellido, emp.segundo_apellido, emp.salario, p.nombre_puesto, p.descripcion_puesto
FROM Empleado emp
INNER JOIN Puesto p ON emp.id_puesto = p.id_puesto;


--Vista que muestra el nombre de cada producto junto con su precio de compra:

CREATE VIEW vw_productos AS
SELECT nombre_producto, precio_compra
FROM Producto;


--Vista que muestra el nombre de cada cliente junto con su dirección y teléfono:

CREATE VIEW vw_clientes AS
SELECT nombre, primer_apellido, segundo_apellido, direccion, telefono
FROM Cliente;


--Vista que muestra la fecha, monto, nombre del empleado y nombre del cliente de cada venta:

CREATE VIEW vw_ventas AS
SELECT v.fecha, v.monto, e.nombre AS nombre_empleado, c.nombre AS nombre_cliente
FROM Venta v
INNER JOIN Empleado e ON v.id_empleado = e.id_empleado
INNER JOIN Cliente c ON v.id_cliente = c.id_cliente;


--Vista que muestra el nombre y ubicación de cada empresa:

CREATE VIEW vw_empresas AS
SELECT nombre_empresa, ubicacion_empresa
FROM Empresa;


--Vista que muestra el nombre de cada puesto junto con su descripción:

CREATE VIEW vw_puestos AS
SELECT nombre_puesto, descripcion_puesto
FROM Puesto;


--Vista que muestra el nombre de cada empleado y el nombre de la empresa para la que realizó una compra:

CREATE VIEW vw_empleados_compras AS
SELECT emp.nombre, emp.primer_apellido, emp.segundo_apellido, e.nombre_empresa
FROM Empleado emp
INNER JOIN Compra c ON emp.id_empleado = c.id_empleado
INNER JOIN Empresa e ON c.id_empresa = e.id_empresa;


--Vista que muestra el nombre de cada empresa junto con el nombre y teléfono de su contacto principal (asumiendo que hay una tabla Contacto_Principal que contiene la información de contacto del contacto principal de cada empresa):

CREATE VIEW vw_empresas_contactos AS
SELECT e.nombre_empresa, cp.nombre_contacto, cp.telefono
FROM Empresa e
INNER JOIN Contacto_Empresa cp ON e.id_empresa = cp.id_empresa;


-- Vista que muestra los detalles de las ventas y los productos vendidos
CREATE VIEW detalles_venta_producto AS
SELECT v.id_venta, v.fecha, c.nombre AS cliente, e.nombre AS empleado, p.nombre_producto, dv.cantidad, dv.descuento, dv.cantidad * (p.precio_compra - dv.descuento) AS total_venta
FROM Venta v
INNER JOIN Cliente c ON v.id_cliente = c.id_cliente
INNER JOIN Empleado e ON v.id_empleado = e.id_empleado
INNER JOIN Detalle_Venta dv ON v.id_venta = dv.id_venta
INNER JOIN Producto p ON dv.codigo_producto = p.codigo_producto;



-- FUNCIONES

-- Función que devuelva el nombre de un producto dado su código:
CREATE FUNCTION obtener_nombre_producto(codigo_producto INT)
RETURN VARCHAR
IS
nombre_producto VARCHAR(50);
BEGIN
SELECT nombre_producto INTO nombre_producto FROM Producto WHERE codigo_producto = codigo_producto;
RETURN nombre_producto;
END;

-- Función que devuelva el precio de compra de un producto dado su código:
CREATE FUNCTION obtener_precio_compra(codigo_producto INT)
RETURN FLOAT
IS
precio_compra FLOAT;
BEGIN
SELECT precio_compra INTO precio_compra FROM Producto WHERE codigo_producto = codigo_producto;
RETURN precio_compra;
END;

-- Función que devuelva el nombre de una empresa dado su ID:
CREATE FUNCTION obtener_nombre_empresa(id_empresa INT)
RETURN VARCHAR
IS
nombre_empresa VARCHAR(50);
BEGIN
SELECT nombre_empresa INTO nombre_empresa FROM Empresa WHERE id_empresa = id_empresa;
RETURN nombre_empresa;
END;

-- Función que devuelva la ubicación de una empresa dado su ID:
CREATE FUNCTION obtener_ubicacion_empresa(id_empresa INT)
RETURN VARCHAR
IS
ubicacion_empresa VARCHAR(50);
BEGIN
SELECT ubicacion_empresa INTO ubicacion_empresa FROM Empresa WHERE id_empresa = id_empresa;
RETURN ubicacion_empresa;
END;

-- Función que devuelva el nombre de un puesto dado su ID:
CREATE FUNCTION obtener_nombre_puesto(id_puesto INT)
RETURN VARCHAR
IS
nombre_puesto VARCHAR(50);
BEGIN
SELECT nombre_puesto INTO nombre_puesto FROM Puesto WHERE id_puesto = id_puesto;
RETURN nombre_puesto;
END;

-- Función que devuelva la descripción de un puesto dado su ID:
CREATE FUNCTION obtener_descripcion_puesto(id_puesto INT)
RETURN VARCHAR
IS
descripcion_puesto VARCHAR(255);
BEGIN
SELECT descripcion_puesto INTO descripcion_puesto FROM Puesto WHERE id_puesto = id_puesto;
RETURN descripcion_puesto;
END;


-- Función que devuelva la dirección de un cliente dado su ID:
CREATE FUNCTION obtener_direccion_cliente(id_cliente INT)
RETURN VARCHAR
IS
direccion_cliente VARCHAR(255);
BEGIN
SELECT direccion INTO direccion_cliente FROM Cliente WHERE id_cliente = id_cliente;
RETURN direccion_cliente;
END;

-- Función que devuelva el teléfono de un cliente dado su ID:
CREATE FUNCTION obtener_telefono_cliente(id_cliente INT)
RETURN VARCHAR
IS
telefono_cliente VARCHAR(15);
BEGIN
SELECT telefono INTO telefono_cliente FROM Cliente WHERE id_cliente = id_cliente;
RETURN telefono_cliente;
END;

-- Función para obtener el total de ventas realizadas por un empleado en un rango de fechas específico:
CREATE FUNCTION total_ventas_empleado (
  p_id_empleado IN Venta.id_empleado%TYPE,
  p_fecha_ini IN Venta.fecha%TYPE,
  p_fecha_fin IN Venta.fecha%TYPE
)
RETURN FLOAT
IS
  v_total FLOAT;
BEGIN
  SELECT SUM(monto) INTO v_total
  FROM Venta
  WHERE id_empleado = p_id_empleado
  AND fecha BETWEEN p_fecha_ini AND p_fecha_fin;
  RETURN v_total;
END;

-- Función para obtener el total de compras realizadas por un empleado en un rango de fechas específico:
CREATE FUNCTION total_compras_empleado (
  p_id_empleado IN Compra.id_empleado%TYPE,
  p_fecha_ini IN Compra.fecha%TYPE,
  p_fecha_fin IN Compra.fecha%TYPE
)
RETURN FLOAT
IS
  v_total FLOAT;
BEGIN
  SELECT SUM(monto) INTO v_total
  FROM Compra
  WHERE id_empleado = p_id_empleado
  AND fecha BETWEEN p_fecha_ini AND p_fecha_fin;
  RETURN v_total;
END;

-- Función para obtener el total de ventas de un producto en un rango de fechas específico:

CREATE FUNCTION total_ventas_producto (
  p_codigo_producto IN Detalle_Venta.codigo_producto%TYPE,
  p_fecha_ini IN Venta.fecha%TYPE,
  p_fecha_fin IN Venta.fecha%TYPE
)
RETURN FLOAT
IS
  v_total FLOAT;
BEGIN
  SELECT SUM(cantidad*(monto-descuento)) INTO v_total
  FROM Detalle_Venta dv
  JOIN Venta v ON dv.id_venta = v.id_venta
  WHERE dv.codigo_producto = p_codigo_producto
  AND v.fecha BETWEEN p_fecha_ini AND p_fecha_fin;
  RETURN v_total;
END;

-- Función para obtener el total de compras de un producto en un rango de fechas específico:
CREATE FUNCTION total_compras_producto (
  p_codigo_producto IN Detalle_Compra.codigo_producto%TYPE,
  p_fecha_ini IN Compra.fecha%TYPE,
  p_fecha_fin IN Compra.fecha%TYPE
)
RETURN FLOAT
IS
  v_total FLOAT;
BEGIN
  SELECT SUM(cantidad*precio_compra) INTO v_total
  FROM Detalle_Compra dc
  JOIN Compra c ON dc.id_compra = c.id_compra
  WHERE dc.codigo_producto = p_codigo_producto
  AND c.fecha BETWEEN p_fecha_ini AND p_fecha_fin;
  RETURN v_total;
END;


-- Función para obtener la cantidad de productos vendidos en un rango de fechas específico:
CREATE FUNCTION total_productos_vendidos (
  p_fecha_ini IN Venta.fecha%TYPE,
  p_fecha_fin IN Venta.fecha%TYPE
)
RETURN INT
IS
  v_total INT;
BEGIN
  SELECT SUM(cantidad) INTO v_total
  FROM Detalle_Venta dv
  JOIN Venta v ON dv.id_venta = v.id_venta
  WHERE v.fecha BETWEEN p_fecha_ini AND p_fecha_fin;
  RETURN v_total;
END;


-- Función para calcular el total de ventas por empleado en un rango de fechas:
CREATE OR REPLACE FUNCTION total_ventas_empleado(
  emp_id IN INT,
  fecha_inicio IN DATE,
  fecha_fin IN DATE
)
RETURN FLOAT
AS
  total FLOAT;
BEGIN
  SELECT SUM(monto)
  INTO total
  FROM Venta
  WHERE id_empleado = emp_id AND fecha BETWEEN fecha_inicio AND fecha_fin;
  
  RETURN total;
END;


-- Función para actualizar el salario de un empleado en base a su puesto:
CREATE OR REPLACE FUNCTION actualizar_salario_empleado(
  emp_id IN INT
)
RETURN FLOAT
AS
  salario_nuevo FLOAT;
BEGIN
  SELECT salario * 1.1
  INTO salario_nuevo
  FROM Empleado e JOIN Puesto p ON e.id_puesto = p.id_puesto
  WHERE e.id_empleado = emp_id;
  
  UPDATE Empleado
  SET salario = salario_nuevo
  WHERE id_empleado = emp_id;
  
  RETURN salario_nuevo;
END;


-- PAQUETES

-- Paquete Productos
CREATE OR REPLACE PACKAGE Paquete_Producto IS
  PROCEDURE InsertarProducto(p_codigo_producto IN INT, p_nombre_producto IN VARCHAR2, p_precio_compra IN FLOAT);
  PROCEDURE ModificarProducto(p_codigo_producto IN INT, p_nombre_producto IN VARCHAR2, p_precio_compra IN FLOAT);
  PROCEDURE ListarProductos;
  PROCEDURE EliminarProducto(p_codigo_producto IN INT);
END Paquete_Producto;

CREATE OR REPLACE PACKAGE BODY Paquete_Producto IS
  PROCEDURE InsertarProducto(p_codigo_producto IN INT, p_nombre_producto IN VARCHAR2, p_precio_compra IN FLOAT) IS
  BEGIN
    INSERT INTO Producto(codigo_producto, nombre_producto, precio_compra)
    VALUES(p_codigo_producto, p_nombre_producto, p_precio_compra);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido insertado correctamente.');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el producto: ' || SQLERRM);
      ROLLBACK;
  END InsertarProducto;

  PROCEDURE ModificarProducto(p_codigo_producto IN INT, p_nombre_producto IN VARCHAR2, p_precio_compra IN FLOAT) IS
  BEGIN
    UPDATE Producto
    SET nombre_producto = p_nombre_producto, precio_compra = p_precio_compra
    WHERE codigo_producto = p_codigo_producto;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido modificado correctamente.');
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrió un error al modificar el producto: ' || SQLERRM);
    ROLLBACK;
  END ModificarProducto;

  PROCEDURE ListarProductos IS
  BEGIN
    FOR prod IN (SELECT * FROM Producto)
    LOOP
      DBMS_OUTPUT.PUT_LINE('Código de Producto: ' || prod.codigo_producto || ', Nombre del Producto: ' || prod.nombre_producto || ', Precio de Compra: ' || prod.precio_compra);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrió un error al listar los productos: ' || SQLERRM);
  END ListarProductos;

  PROCEDURE EliminarProducto(p_codigo_producto IN INT) IS
  BEGIN
    DELETE FROM Producto WHERE codigo_producto = p_codigo_producto;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El producto ha sido eliminado correctamente.');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrió un error al eliminar el producto: ' || SQLERRM);
      ROLLBACK;
  END EliminarProducto;
END Paquete_Producto;


-- Paquete Empresa
CREATE OR REPLACE PACKAGE empresa_pkg AS
  PROCEDURE insertar_empresa(
    id_empresa IN INT,
    nombre_empresa IN VARCHAR2,
    ubicacion_empresa IN VARCHAR2
  );
  
  PROCEDURE modificar_empresa(
    id_empresa_modificar IN INT,
    nombre_empresa_modificar IN VARCHAR2,
    ubicacion_empresa_modificar IN VARCHAR2
  );
  
  PROCEDURE listar_empresas;
  
  PROCEDURE eliminar_empresa(id_empresa_eliminar IN INT);
END empresa_pkg;


-- Paquete Puesto
CREATE OR REPLACE PACKAGE puesto_pkg AS
  PROCEDURE insertar_puesto(
    id_puesto IN INT,
    nombre_puesto IN VARCHAR2,
    descripcion_puesto IN VARCHAR2
  );
  
  PROCEDURE modificar_puesto(
    id_puesto_modificar IN INT,
    nombre_puesto_modificar IN VARCHAR2,
    descripcion_puesto_modificar IN VARCHAR2
  );
  
  PROCEDURE listar_puestos;
  
  PROCEDURE eliminar_puesto(id_puesto_eliminar IN INT);
END puesto_pkg;


-- Paquete Cliente
CREATE OR REPLACE PACKAGE cliente_pkg AS
  PROCEDURE insertar_cliente(
    id_cliente_in IN INT,
    nombre_in IN VARCHAR2,
    primer_apellido_in IN VARCHAR2,
    segundo_apellido_in IN VARCHAR2,
    direccion_in IN VARCHAR2,
    telefono_in IN VARCHAR2
  );
END cliente_pkg;
 

-- Paquete Empleado
CREATE OR REPLACE PACKAGE empleado_pkg AS
  PROCEDURE insertar_empleado(
    id_empleado IN INT,
    nombre IN VARCHAR2,
    primer_apellido IN VARCHAR2,
    segundo_apellido IN VARCHAR2,
    salario IN FLOAT,
    id_puesto IN INT
  );
  
  PROCEDURE modificar_empleado(
    id_empleado_modificar IN INT,
    nombre_modificar IN VARCHAR2,
    primer_apellido_modificar IN VARCHAR2,
    segundo_apellido_modificar IN VARCHAR2,
    salario_modificar IN FLOAT,
    id_puesto_modificar IN INT
  );
END empleado_pkg;


-- Paquete Venta
CREATE OR REPLACE PACKAGE venta_pkg AS
  PROCEDURE insertar_venta(
    id_venta IN INT,
    id_empleado IN INT,
    id_cliente IN INT,
    fecha IN DATE,
    monto IN FLOAT
  );
END venta_pkg;


-- Paquete Detalle Venta
CREATE OR REPLACE PACKAGE detalle_venta_pkg AS
  PROCEDURE insertar_detalle_venta(
    id_detalle_venta IN INT,
    id_venta IN INT,
    codigo_producto IN INT,
    cantidad IN INT,
    descuento IN FLOAT
  );
END detalle_venta_pkg;


-- Paquete Compra
CREATE OR REPLACE PACKAGE compra_pkg AS
  PROCEDURE insertar_compra(
    id_compra IN INT,
    id_empleado IN INT,
    id_empresa IN INT,
    monto IN FLOAT,
    fecha IN DATE
  );
END compra_pkg;


-- Paquete Empleado
CREATE OR REPLACE PACKAGE empleado_pkg AS
  PROCEDURE insertar_empleado(
    id_empleado IN INT,
    nombre IN VARCHAR2,
    primer_apellido IN VARCHAR2,
    segundo_apellido IN VARCHAR2,
    salario IN FLOAT,
    id_puesto IN INT
  );
  
  PROCEDURE modificar_empleado(
    id_empleado_modificar IN INT,
    nombre_modificar IN VARCHAR2,
    primer_apellido_modificar IN VARCHAR2,
    segundo_apellido_modificar IN VARCHAR2,
    salario_modificar IN FLOAT,
    id_puesto_modificar IN INT
  );
  
  PROCEDURE listar_empleados;
  
  PROCEDURE eliminar_empleado(id_empleado_eliminar IN INT);
  
END empleado_pkg;

CREATE OR REPLACE PACKAGE BODY empleado_pkg AS
  PROCEDURE insertar_empleado(
    id_empleado IN INT,
    nombre IN VARCHAR2,
    primer_apellido IN VARCHAR2,
    segundo_apellido IN VARCHAR2,
    salario IN FLOAT,
    id_puesto IN INT
  ) AS
  BEGIN
    INSERT INTO Empleado(id_empleado, nombre, primer_apellido, segundo_apellido, salario, id_puesto)
    VALUES(id_empleado, nombre, primer_apellido, segundo_apellido, salario, id_puesto);
    COMMIT;
  END;

  PROCEDURE modificar_empleado(
    id_empleado_modificar IN INT,
    nombre_modificar IN VARCHAR2,
    primer_apellido_modificar IN VARCHAR2,
    segundo_apellido_modificar IN VARCHAR2,
    salario_modificar IN FLOAT,
    id_puesto_modificar IN INT
  ) AS
  BEGIN
    UPDATE Empleado
    SET nombre = nombre_modificar, primer_apellido = primer_apellido_modificar, segundo_apellido = segundo_apellido_modificar, salario = salario_modificar, id_puesto = id_puesto_modificar
    WHERE id_empleado = id_empleado_modificar;
    COMMIT;
  END;

  PROCEDURE listar_empleados AS
  BEGIN
    FOR empleado IN (SELECT * FROM Empleado)
    LOOP
      DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario || ' | ' || empleado.id_puesto);
    END LOOP;
  END;

  PROCEDURE eliminar_empleado(id_empleado_eliminar IN INT) AS
  BEGIN
    DELETE FROM Empleado WHERE id_empleado = id_empleado_eliminar;
    COMMIT;
  END;
END empleado_pkg;


-- Paquete Compras
CREATE OR REPLACE PACKAGE gestion_compras IS

  PROCEDURE insertar_compra(
    id_compra_in IN INT,
    id_empleado_in IN INT,
    id_empresa_in IN INT,
    monto_in IN FLOAT,
    fecha_in IN DATE
  );

  PROCEDURE modificar_compra(
    id_compra_modificar IN INT,
    id_empleado_modificar IN INT,
    id_empresa_modificar IN INT,
    monto_modificar IN FLOAT,
    fecha_modificar IN DATE
  );

  PROCEDURE listar_compras;

  PROCEDURE eliminar_compra(id_compra_eliminar IN INT);

END gestion_compras;

CREATE OR REPLACE PACKAGE BODY gestion_compras IS

  PROCEDURE insertar_compra(
    id_compra_in IN INT,
    id_empleado_in IN INT,
    id_empresa_in IN INT,
    monto_in IN FLOAT,
    fecha_in IN DATE
  ) AS
  BEGIN
    INSERT INTO Compra (id_compra, id_empleado, id_empresa, monto, fecha)
    VALUES (id_compra_in, id_empleado_in, id_empresa_in, monto_in, fecha_in);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La compra ha sido insertada exitosamente');
  END;

  PROCEDURE modificar_compra(
    id_compra_modificar IN INT,
    id_empleado_modificar IN INT,
    id_empresa_modificar IN INT,
    monto_modificar IN FLOAT,
    fecha_modificar IN DATE
  ) AS
  BEGIN
    UPDATE Compra
    SET id_empleado = id_empleado_modificar, id_empresa = id_empresa_modificar, monto = monto_modificar, fecha = fecha_modificar
    WHERE id_compra = id_compra_modificar;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La compra ha sido modificada exitosamente');
  END;

  PROCEDURE listar_compras AS
  BEGIN
    FOR compra IN (SELECT * FROM Compra)
    LOOP
      DBMS_OUTPUT.PUT_LINE(compra.id_compra || ' | ' || compra.id_empleado || ' | ' || compra.id_empresa || ' | ' || compra.monto || ' | ' || compra.fecha);
    END LOOP;
  END;

  PROCEDURE eliminar_compra(id_compra_eliminar IN INT) AS
  BEGIN
    DELETE FROM Compra WHERE id_compra = id_compra_eliminar;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La compra ha sido eliminada exitosamente');
  END;

END gestion_compras;


CREATE OR REPLACE PACKAGE Empresa_Package AS
  PROCEDURE insertar_empresa(
    id_empresa IN INT,
    nombre_empresa IN VARCHAR2,
    ubicacion_empresa IN VARCHAR2
  );

  PROCEDURE modificar_empresa(
    id_empresa_modificar IN INT,
    nombre_empresa_modificar IN VARCHAR2,
    ubicacion_empresa_modificar IN VARCHAR2
  );

  PROCEDURE listar_empresas;

  PROCEDURE eliminar_empresa(id_empresa_eliminar IN INT);
END;



-- TRIGGERS


-- Trigger para actualizar el salario de un empleado en la tabla Empleado cada vez que se inserta una fila en la tabla Venta:
CREATE OR REPLACE TRIGGER actualizar_salario
AFTER INSERT ON Venta
FOR EACH ROW
BEGIN
UPDATE Empleado
SET salario = salario + (:NEW.monto * 0.1)
WHERE id_empleado = :NEW.id_empleado;
END;

-- Trigger para eliminar una fila en la tabla Detalle_Compra cada vez que se elimina una fila en la tabla Compra:
CREATE OR REPLACE TRIGGER eliminar_detalle_compra
BEFORE DELETE ON Compra
FOR EACH ROW
BEGIN
DELETE FROM Detalle_Compra
WHERE id_compra = :OLD.id_compra;
END;

-- Trigger para insertar automáticamente la fecha de registro de una venta:
CREATE OR REPLACE TRIGGER insert_fecha_venta
BEFORE INSERT ON Venta
FOR EACH ROW
BEGIN
:NEW.fecha := SYSDATE;
END;

-- Trigger para impedir la eliminación de un puesto que esté asignado a algún empleado:
CREATE OR REPLACE TRIGGER impedir_eliminacion_puesto
BEFORE DELETE ON Puesto
FOR EACH ROW
DECLARE
contador INT;
BEGIN
SELECT COUNT(*) INTO contador
FROM Empleado
WHERE id_puesto = :OLD.id_puesto;
IF contador > 0 THEN
RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el puesto, ya que está asignado a uno o más empleados.');
END IF;
END;

-- Trigger para impedir la eliminación de una empresa que tenga algún contacto registrado:
CREATE OR REPLACE TRIGGER impedir_eliminacion_empresa
BEFORE DELETE ON Empresa
FOR EACH ROW
DECLARE
contador INT;
BEGIN
SELECT COUNT(*) INTO contador
FROM Contacto_Empresa
WHERE id_empresa = :OLD.id_empresa;
IF contador > 0 THEN
RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar la empresa, ya que tiene uno o más contactos registrados.');
END IF;
END;



-- CURSORES

-- Cursor para listar todas las empresas:
DECLARE
  CURSOR empresas_cursor IS
    SELECT * FROM Empresa;
BEGIN
  FOR empresa IN empresas_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(empresa.id_empresa || ' | ' || empresa.nombre_empresa || ' | ' || empresa.ubicacion_empresa);
  END LOOP;
END;


-- Cursor para listar todos los puestos:
DECLARE
  CURSOR puestos_cursor IS
    SELECT * FROM Puesto;
BEGIN
  FOR puesto IN puestos_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(puesto.id_puesto || ' | ' || puesto.nombre_puesto || ' | ' || puesto.descripcion_puesto);
  END LOOP;
END;


--  Cursor para listar todos los clientes:
DECLARE
  CURSOR clientes_cursor IS
    SELECT * FROM Cliente;
BEGIN
  FOR cliente IN clientes_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(cliente.id_cliente || ' | ' || cliente.nombre || ' | ' || cliente.primer_apellido || ' | ' || cliente.segundo_apellido || ' | ' || cliente.direccion || ' | ' || cliente.telefono);
  END LOOP;
END;


-- Cursor para listar todos los empleados:
DECLARE
  CURSOR empleados_cursor IS
    SELECT * FROM Empleado;
BEGIN
  FOR empleado IN empleados_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario || ' | ' || empleado.id_puesto);
  END LOOP;
END;


-- Cursor para listar todas las ventas:
DECLARE
  CURSOR ventas_cursor IS
    SELECT * FROM Venta;
BEGIN
  FOR venta IN ventas_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(venta.id_venta || ' | ' || venta.id_empleado || ' | ' || venta.id_cliente || ' | ' || venta.fecha || ' | ' || venta.monto);
  END LOOP;
END;


-- Cursor para listar todos los detalles de venta:
DECLARE
  CURSOR detalles_venta_cursor IS
    SELECT * FROM Detalle_Venta;
BEGIN
  FOR detalle_venta IN detalles_venta_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(detalle_venta.id_detalle_venta || ' | ' || detalle_venta.id_venta || ' | ' || detalle_venta.codigo_producto || ' | ' || detalle_venta.cantidad || ' | ' || detalle_venta.descuento);
  END LOOP;
END;


-- Cursor para listar todas las compras:
DECLARE
  CURSOR compras_cursor IS
    SELECT * FROM Compra;
BEGIN
  FOR compra IN compras_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(compra.id_compra || ' | ' || compra.id_empleado || ' | ' || compra.id_empresa || ' | ' || compra.fecha || ' | ' || compra.monto);
  END LOOP;
END;


-- Listar todos los empleados y sus puestos correspondientes.
DECLARE
  CURSOR c_empleados IS
    SELECT e.id_empleado, e.nombre, e.primer_apellido, e.segundo_apellido, e.salario, p.nombre_puesto, p.descripcion_puesto
    FROM Empleado e
    INNER JOIN Puesto p ON e.id_puesto = p.id_puesto;
BEGIN
  FOR empleado IN c_empleados
  LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario || ' | ' || empleado.nombre_puesto || ' | ' || empleado.descripcion_puesto);
  END LOOP;
END;

-- Listar los empleados que hayan realizado ventas.
DECLARE
  CURSOR c_empleados IS
    SELECT DISTINCT e.*
    FROM Empleado e
    INNER JOIN Venta v ON e.id_empleado = v.id_empleado;
BEGIN
  FOR empleado IN c_empleados
  LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario);
  END LOOP;
END;

-- Listar los empleados que no hayan realizado ventas.
DECLARE
  CURSOR c_empleados IS
    SELECT *
    FROM Empleado
    WHERE id_empleado NOT IN (SELECT DISTINCT id_empleado FROM Venta);
BEGIN
  FOR empleado IN c_empleados
  LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario);
  END LOOP;
END;

-- Cursor para listar los contactos de una empresa
CREATE OR REPLACE PROCEDURE listar_contactos_empresa(id_empresa_in IN INT) AS
  CURSOR contactos IS
    SELECT Contacto_Empresa.nombre_contacto, Contacto_Empresa.telefono
    FROM Contacto_Empresa
    WHERE Contacto_Empresa.id_empresa = id_empresa_in;

BEGIN
  FOR contacto IN contactos
  LOOP
    DBMS_OUTPUT.PUT_LINE(contacto.nombre_contacto || ' | ' || contacto.telefono);
  END LOOP;
END;


-- Cursor que recupera todos los registros de la tabla Empresa.
DECLARE
CURSOR empresas_cursor IS SELECT * FROM Empresa;
BEGIN
FOR empresa IN empresas_cursor LOOP
DBMS_OUTPUT.PUT_LINE(empresa.id_empresa || ' | ' || empresa.nombre_empresa || ' | ' || empresa.ubicacion_empresa);
END LOOP;
END;

-- Cursor que recupera todos los registros de la tabla Puesto.
DECLARE
CURSOR puestos_cursor IS SELECT * FROM Puesto;
BEGIN
FOR puesto IN puestos_cursor LOOP
DBMS_OUTPUT.PUT_LINE(puesto.id_puesto || ' | ' || puesto.nombre_puesto || ' | ' || puesto.descripcion_puesto);
END LOOP;
END;

-- Cursor que recupera todos los registros de la tabla Cliente.
DECLARE
CURSOR clientes_cursor IS SELECT * FROM Cliente;
BEGIN
FOR cliente IN clientes_cursor LOOP
DBMS_OUTPUT.PUT_LINE(cliente.id_cliente || ' | ' || cliente.nombre || ' | ' || cliente.primer_apellido || ' | ' || cliente.segundo_apellido || ' | ' || cliente.direccion || ' | ' || cliente.telefono);
END LOOP;
END;

-- Cursor que recupera todos los registros de la tabla Empleado.

DECLARE
CURSOR empleados_cursor IS SELECT * FROM Empleado;
BEGIN
FOR empleado IN empleados_cursor LOOP
DBMS_OUTPUT.PUT_LINE(empleado.id_empleado || ' | ' || empleado.nombre || ' | ' || empleado.primer_apellido || ' | ' || empleado.segundo_apellido || ' | ' || empleado.salario || ' | ' || empleado.id_puesto);
END LOOP;
END;

-- Cursor que recupera todos los registros de la tabla Venta.

DECLARE
CURSOR ventas_cursor IS SELECT * FROM Venta;
BEGIN
FOR venta IN ventas_cursor LOOP
DBMS_OUTPUT.PUT_LINE(venta.id_venta || ' | ' || venta.id_empleado || ' | ' || venta.id_cliente || ' | ' || venta.fecha || ' | ' || venta.monto);
END LOOP;
END;






