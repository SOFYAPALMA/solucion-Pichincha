using Comun;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace BP.Repositorio
{
    public class ConexionMS
    {
        #region Comun
        private static ConexionMS instance = null;

        public static ConexionMS Instanciar()
        {
            if (instance == null)
            {
                instance = new ConexionMS();
            }

            return instance;
        }
        #endregion

        #region Constructor
        public ConexionMS()
        {
            nuevaConexion();
        }
        #endregion

        #region Variables

        private static SqlConnection connection;
        private static SqlCommand comando = new SqlCommand();
        private static SqlDataAdapter Adaptador;
        private static DataSet dsData;

        #endregion

        #region Metodos

        /// <summary>
        /// Realiza la conecion a la bd
        /// </summary>
        /// <param name="strConneccion">la cadena de coneccion</param>
        public static void nuevaConexion(string strConneccion)
        {
            try
            {
                connection = new SqlConnection(strConneccion);
                comando.CommandTimeout = 1000;
            }
            catch (Exception ex)
            {
                throw new Exception("Se presentaron problemas al conectar en el metodo nuevaConexion Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Realiza la conecion a la bd
        /// </summary>
        /// <param name="strConneccion">la cadena de coneccion</param>
        public static void nuevaConexion()
        {
            try
            {
                string strConneccion = ConfigurationManager.ConnectionStrings["bpapp"].ConnectionString;
                connection = new SqlConnection(strConneccion);
                comando.CommandTimeout = 1000;
            }
            catch (Exception ex)
            {
                throw new Exception("Se presentaron problemas al conectar en el metodo nuevaConexion Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Conecta a la base de datos
        /// </summary>
        public static void conectar()
        {
            Instanciar();
            connection.Open();
        }

        /// <summary>
        /// Desconecta de la base de datos
        /// </summary>
        public static void desconectar()
        {
            connection.Close();
        }

        /// <summary>
        /// Ejecuta un procedimiento almacenado y me debuelve un data set
        /// </summary>
        /// <param name="procedimiento">Nombre del procedimiento almacenado</param>
        /// <param name="tabla">nombre de la tabla</param>
        /// <returns>DataSet relleno</returns>
        public static DataSet ejecutarStoreProcedure(string procedimiento, string tabla)
        {
            try
            {
                conectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), procedimiento, Logs.Tipo.Log);

                Adaptador = new SqlDataAdapter();
                dsData = new DataSet();
                comando.CommandText = procedimiento;
                comando.CommandType = CommandType.StoredProcedure;
                comando.Connection = connection;
                Adaptador.SelectCommand = comando;
                Adaptador.Fill(dsData, tabla);
                desconectar();
                return dsData;
            }
            catch (Exception ex)
            {
                desconectar();
                throw new Exception("Se presentaron problemas al ejecutar su consulta en el metodo ejecutarStoreProcedure Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Ejecuta un procedimiento almacenado y me debuelve un data set
        /// </summary>
        /// <param name="procedimiento">Nombre del procedimiento almacenado</param>
        /// <returns>DataSet relleno</returns>
        public static DataSet ejecutarStoreProcedure(string procedimiento)
        {
            try
            {
                conectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), procedimiento, Logs.Tipo.Log);
                SqlTransaction Transac;
                Transac = connection.BeginTransaction();
                Adaptador = new SqlDataAdapter();
                dsData = new DataSet();
                comando.CommandText = procedimiento;
                comando.CommandType = CommandType.StoredProcedure;
                comando.Connection = connection;
                comando.Transaction = Transac;
                Adaptador.SelectCommand = comando;
                Adaptador.Fill(dsData, "tbl");
                Transac.Commit();
                desconectar();
                return dsData;
            }
            catch (Exception ex)
            {
                desconectar();
                throw new Exception("Se presentaron problemas al ejecutar su consulta en el metodo ejecutarStoreProcedure Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Ejecuta un SQL dirrectamente sobre la base de datos
        /// </summary>
        /// <param name="Sql">SQL a ejecutar</param>
        /// <param name="tabla">nombre de la tabla</param>
        /// <returns>DataSet relleno</returns>
        public static DataSet EjecutarSql(string Sql, string tabla)
        {
            try
            {
                conectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), Sql, Logs.Tipo.Log);
                SqlTransaction Transac;
                Transac = connection.BeginTransaction();
                Adaptador = new SqlDataAdapter();
                dsData = new DataSet();
                comando.CommandText = Sql;
                comando.CommandType = CommandType.Text;
                comando.Connection = connection;
                comando.Transaction = Transac;
                Adaptador.SelectCommand = comando;
                Adaptador.Fill(dsData, tabla);
                Transac.Commit();
                desconectar();
                return dsData;
            }
            catch (Exception ex)
            {
                throw new Exception("Se presentaron problemas al ejecutar su consulta en el metodo EjecutarSql Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Ejecuta un scalar que sera utilizado para Insertar, Actualizar o Eliminar
        /// </summary>
        /// <param name="procedimiento">nombre del procedimiento almacenado a ejecutar</param>
        public static void ejecutarScalar(string procedimiento)
        {
            try
            {
                conectar();
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), procedimiento, Logs.Tipo.Log);
                comando.CommandText = procedimiento;
                comando.CommandType = CommandType.StoredProcedure;
                comando.Connection = connection;
                comando.ExecuteScalar();
                desconectar();
            }
            catch (Exception ex)
            {
                desconectar();
                throw new Exception("Se presentaron problemas al ejecutar su consulta en el metodo ejecutarScalar Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Adiciona un parametro al procedimiento almacenado que se va a ejecutar
        /// </summary>
        /// <param name="nombre">nombre del parametro</param>
        /// <param name="valor">Valor que se va a pasar</param>
        public static void AdicionarParametros(string nombre, object valor)
        {
            Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), nombre + "='" + valor + "'", Logs.Tipo.Log);
            //if (valor.GetType().Name == "String")
            {
                if (valor == "null")
                {
                    valor = DBNull.Value;
                }
            }

            if (nombre.IndexOf("@") == -1)
                nombre = "@" + nombre;

            comando.Parameters.AddWithValue(nombre, valor);
        }

        /// <summary>
        /// Adiciona un parametro al procedimiento almacenado que se va a ejecutar
        /// </summary>
        /// <param name="nombre">nombre del parametro</param>
        /// <param name="valor">Valor que se va a pasar</param>
        public static void AdicionarParametrosOut(string nombre, SqlDbType tipo, int tamano = 0)
        {
            Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), nombre, Logs.Tipo.Log);
            if (nombre.IndexOf("@") == -1)
                nombre = "@" + nombre;

            comando.Parameters.Add(nombre, tipo, tamano).Direction = ParameterDirection.Output;
        }

        /// <summary>
        /// Adiciona un parametro al procedimiento almacenado que se va a ejecutar
        /// </summary>
        /// <param name="nombre">nombre del parametro</param>
        /// <param name="valor">Valor que se va a pasar</param>
        public static string RecuperarParametrosOut(string nombre)
        {
            try
            {
                Logs.EscribirLog(System.Reflection.MethodBase.GetCurrentMethod(), nombre, Logs.Tipo.Log);
                if (nombre.IndexOf("@") == -1)
                    nombre = "@" + nombre;

                return comando.Parameters[nombre].Value.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("Se presentaron problemas al ejecutar su consulta en el metodo RecuperarParametrosOut Revise los Valores, err " + ex.Message);
            }
        }

        /// <summary>
        /// Limpia los parametros
        /// </summary>
        public static void limpiarParametros()
        {
            comando.Parameters.Clear();
        }

        #endregion
    }
}
