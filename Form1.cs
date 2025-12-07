using System.IO.Ports;

namespace TestProgramApp
{
    public partial class Form1 : Form

    {
        private SerialPort serial;

        public Form1()
        {
            InitializeComponent();
            serial = new SerialPort("COM3", 9600, Parity.None, 8, StopBits.One);
            serial.DataReceived += serial_DataReceived;
            try
            {
                serial.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error opening serial port: " + ex.Message);
            }
        }
        private void serial_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            while (serial.BytesToRead > 0)
            {
                int b = serial.ReadByte();
                char c = (char)b;


                BeginInvoke(new Action(() =>
                {
                    switch (c)
                    {
                        case 'A':
                            if (TeamA.Value < TeamA.Maximum)
                            {
                                TeamA.Value++;
                            }
                            break;

                        case 'B':
                            if (TeamA.Value > TeamA.Minimum)
                            {
                                TeamA.Value--;
                            }
                            break;

                        case 'a':
                            if (teamB.Value < teamB.Maximum)
                            {
                                teamB.Value++;
                            }
                            break;
                        case 'b':
                            if (teamB.Value > teamB.Minimum)
                            {
                                teamB.Value--;
                            }
                            break;
                        default:
                            MessageBox.Show("error wrong character sent");
                            break;
                    }
                }));
            }
        }

        private void button1_Click(object sender, EventArgs e) //Challenge for team A
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("C");
                }

            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e) // Timeout for team A
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("T");
                }

            }

        }

        private void button5_Click(object sender, EventArgs e) //Substitute for team A
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("S");
                }

            }
        }

        private void button2_Click(object sender, EventArgs e) // Challenge for team B
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("c");
                }

            }
        }

        private void button4_Click(object sender, EventArgs e) //Timeout for team B
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("t");
                }

            }

        }

        private void button6_Click(object sender, EventArgs e) // Substitute for team B
        {
            if (serial != null && serial.IsOpen)
            {
                {
                    serial.Write("s");
                }

            }
        }



        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked && serial != null && serial.IsOpen)
            {
                serial.Write("1");
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked && serial != null && serial.IsOpen)
            {
                serial.Write("2");
            }
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton3.Checked && serial != null && serial.IsOpen)
            {
                serial.Write("3");
            }
        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton4.Checked && serial != null && serial.IsOpen)
            {
                serial.Write("4");
            }
        }

      

        private void button7_Click(object sender, EventArgs e)
        {
            if (TeamA.Value > teamB.Value && serial != null && serial.IsOpen)
            {
                serial.Write("G");
            }
            else if(TeamA.Value < teamB.Value && serial != null && serial.IsOpen)
            {
                serial.Write("g");
            }
            else
            {

                if (serial != null && serial.IsOpen)
                {
                    {
                        serial.Write("D");
                    }

                }
            }
                TeamA.Value = 0;
            teamB.Value = 0;
            radioButton1.Checked = true;


        }
    }
}
