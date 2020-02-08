using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;




namespace cervantes_challange
{
    public partial class Form1 : Form
    {
        private static string Host = "localhost";
        private static string User = "postgres";
        private static string DBname = "postgres";
        private static string Password = "123";
        private static string Port = "5432";

        NpgsqlDataAdapter adpt;
        DataTable dt;

        public Form1()
        {
            InitializeComponent();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            //Salvar

            string connString =
                            String.Format(
                                "Server={0};Username={1};Database={2};Port={3};Password={4};SSLMode=Prefer",
                                Host,
                                User,
                                DBname,
                                Port,
                                Password);
            var conn = new NpgsqlConnection(connString);

            conn.Open();

            using (var command = new NpgsqlCommand("INSERT INTO estudantes(nome, id_number) VALUES (@n1, @q1)", conn))
            {
                command.Parameters.AddWithValue("@n1", txbNome.Text);
                command.Parameters.AddWithValue("@q1", nmrID.Value);


                int nRows = command.ExecuteNonQuery();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            //Pesquisar
            string connString =
                String.Format(
                    "Server={0}; User Id={1}; Database={2}; Port={3}; Password={4};SSLMode=Prefer",
                    Host,
                    User,
                    DBname,
                    Port,
                    Password);

            using (var conn = new NpgsqlConnection(connString))
            {

                Console.Out.WriteLine("Opening connection");
                conn.Open();


                //var command = new NpgsqlCommand("SELECT * FROM estudantes", conn);

                //var reader = command.ExecuteReader();

                adpt = new NpgsqlDataAdapter("SELECT * FROM estudantes", conn);
                dt = new DataTable();
                adpt.Fill(dt);
                dataGridView1.DataSource = dt;
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
          
        }

        private void button3_Click(object sender, EventArgs e)
        {
            adpt = new NpgsqlDataAdapter();
        }
    }
}
